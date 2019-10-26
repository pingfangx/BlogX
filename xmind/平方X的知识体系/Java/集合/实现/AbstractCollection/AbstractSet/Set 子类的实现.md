# HashSet
使用 HashMap

# LinkedHashSet
使用 LinkedHashMap

    HashSet(int initialCapacity, float loadFactor, boolean dummy) {
        map = new LinkedHashMap<>(initialCapacity, loadFactor);
    }
# TreeSet
内部使用 NavigableMap，实际为 TreeMap