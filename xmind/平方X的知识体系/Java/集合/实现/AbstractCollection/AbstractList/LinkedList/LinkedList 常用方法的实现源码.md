# java.util.LinkedList#get
根据是否是 size 的一半，决定从前向后还是从后向前

    public E get(int index) {
        checkElementIndex(index);
        return node(index).item;
    }
    java.util.LinkedList#node
    Node<E> node(int index) {
        // assert isElementIndex(index);

        if (index < (size >> 1)) {
            Node<E> x = first;
            for (int i = 0; i < index; i++)
                x = x.next;
            return x;
        } else {
            Node<E> x = last;
            for (int i = size - 1; i > index; i--)
                x = x.prev;
            return x;
        }
    }