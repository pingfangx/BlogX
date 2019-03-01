看 Python 3.7 文档的时候，看到
> dict 对象会保持插入时的顺序这个特性 [正式宣布](https://mail.python.org/pipermail/python-dev/2017-December/151283.html) 成为 Python 语言官方规范的一部分。

于是想到了以前遗留的一个
# 问题

    print({'1', '2'})
    
    多次运行，结果可能是
    {'1', '2'}
    也可能是
    {'2', '1'}
    
# ['order' of unordered Python sets](https://stackoverflow.com/questions/12165200)
根据相关回答，知道了 python 中的 set 使用 hashtable 实现

# python set 源码
[cpython/Objects/setobject.c](https://github.com/python/cpython/blob/master/Objects/setobject.c)

    static int
    set_add_entry(PySetObject *so, PyObject *key, Py_hash_t hash)
    {
        setentry *table;
        setentry *freeslot;
        setentry *entry;
        size_t perturb;
        size_t mask;
        size_t i;                       /* Unsigned for defined overflow behavior */
        size_t j;
        int cmp;

        /* Pre-increment is necessary to prevent arbitrary code in the rich
           comparison from deallocating the key just before the insertion. */
        Py_INCREF(key);

      restart:

        mask = so->mask;
        i = (size_t)hash & mask;

        entry = &so->table[i];
        if (entry->key == NULL)
            goto found_unused;

        freeslot = NULL;
        perturb = hash;

        while (1) {
            if (entry->hash == hash) {
                PyObject *startkey = entry->key;
                /* startkey cannot be a dummy because the dummy hash field is -1 */
                assert(startkey != dummy);
                if (startkey == key)
                    goto found_active;
                if (PyUnicode_CheckExact(startkey)
                    && PyUnicode_CheckExact(key)
                    && _PyUnicode_EQ(startkey, key))
                    goto found_active;
                table = so->table;
                Py_INCREF(startkey);
                cmp = PyObject_RichCompareBool(startkey, key, Py_EQ);
                Py_DECREF(startkey);
                if (cmp > 0)                                          /* likely */
                    goto found_active;
                if (cmp < 0)
                    goto comparison_error;
                /* Continuing the search from the current entry only makes
                   sense if the table and entry are unchanged; otherwise,
                   we have to restart from the beginning */
                if (table != so->table || entry->key != startkey)
                    goto restart;
                mask = so->mask;                 /* help avoid a register spill */
            }
            else if (entry->hash == -1)
                freeslot = entry;

            if (i + LINEAR_PROBES <= mask) {
                for (j = 0 ; j < LINEAR_PROBES ; j++) {
                    entry++;
                    if (entry->hash == 0 && entry->key == NULL)
                        goto found_unused_or_dummy;
                    if (entry->hash == hash) {
                        PyObject *startkey = entry->key;
                        assert(startkey != dummy);
                        if (startkey == key)
                            goto found_active;
                        if (PyUnicode_CheckExact(startkey)
                            && PyUnicode_CheckExact(key)
                            && _PyUnicode_EQ(startkey, key))
                            goto found_active;
                        table = so->table;
                        Py_INCREF(startkey);
                        cmp = PyObject_RichCompareBool(startkey, key, Py_EQ);
                        Py_DECREF(startkey);
                        if (cmp > 0)
                            goto found_active;
                        if (cmp < 0)
                            goto comparison_error;
                        if (table != so->table || entry->key != startkey)
                            goto restart;
                        mask = so->mask;
                    }
                    else if (entry->hash == -1)
                        freeslot = entry;
                }
            }

            perturb >>= PERTURB_SHIFT;
            i = (i * 5 + 1 + perturb) & mask;

            entry = &so->table[i];
            if (entry->key == NULL)
                goto found_unused_or_dummy;
        }

      found_unused_or_dummy:
        if (freeslot == NULL)
            goto found_unused;
        so->used++;
        freeslot->key = key;
        freeslot->hash = hash;
        return 0;

      found_unused:
        so->fill++;
        so->used++;
        entry->key = key;
        entry->hash = hash;
        if ((size_t)so->fill*5 < mask*3)
            return 0;
        return set_table_resize(so, so->used>50000 ? so->used*2 : so->used*4);

      found_active:
        Py_DECREF(key);
        return 0;

      comparison_error:
        Py_DECREF(key);
        return -1;
    }

    

[cpython/Include/setobject.h](https://github.com/python/cpython/blob/master/Include/setobject.h)
    
    typedef struct {
        PyObject_HEAD

        Py_ssize_t fill;            /* Number active and dummy entries*/
        Py_ssize_t used;            /* Number active entries */

        /* The table contains mask + 1 slots, and that's a power of 2.
         * We store the mask instead of the size because the mask is more
         * frequently needed.
         */
        Py_ssize_t mask;

        /* The table points to a fixed-size smalltable for small tables
         * or to additional malloc'ed memory for bigger tables.
         * The table pointer is never NULL which saves us from repeated
         * runtime null-tests.
         */
        setentry *table;
        Py_hash_t hash;             /* Only used by frozenset objects */
        Py_ssize_t finger;          /* Search finger for pop() */

        setentry smalltable[PySet_MINSIZE];
        PyObject *weakreflist;      /* List of weak references */
    } PySetObject;
    
    
# 测试
根据源码，知道

    index = hash & mask
    mask = length - 1
    
    
    def test(self):
        a = '1'
        b = '2'
        # used 为 2 so->used*4 还是有默认值，不确定是否正确
        length = 8
        mask = length - 1
        print(f'a.hash {a.__hash__()},index {a.__hash__() & mask}')
        print(f'b.hash {b.__hash__()},index {b.__hash__() & mask}')
        c = {a, b}
        print(c)
        
    测试结果与预期相符，当 b 的 index < a 的 index 时，输出的 2 就会在 1 前
    但是如果两者 index 相同，则需要处理 hash 冲实，具体实现没再注意看。