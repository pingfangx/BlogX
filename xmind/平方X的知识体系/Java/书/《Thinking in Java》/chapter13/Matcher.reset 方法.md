除了无参方法，还有一个带参 Charsequence 的方法，可以应用于一个新的字符序列。

    public Matcher reset(CharSequence input) {
        text = input;
        return reset();
    }
