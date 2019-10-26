接口|分类|插入|移除|检查
-|-|-|-|-
Queue|抛出异常|add(e)|remove()|element()
Queue|返回特殊值|offer(e)|poll()|peek()
BlockingQueue|阻塞|put(e)|take()|-
BlockingQueue|超时|offer(e, time, unit)|poll(time, unit)|-
Deque|头部抛出异常|addFirst(e)|removeFirst()|getFirst()
Deque|头部返回特殊值|offerFirst(e)|pollFirst()|peekFirst()
Deque|尾部抛出异常|addLast(e)|removeLast()|getLast()
Deque|尾部返回特殊值|offerLast(e)|pollLast()|peekLast()
Deque|堆栈方法|push(e)|pop()|peek()
BlockingDeque|头部阻塞|putFirst(e)|takeFirst()|-
BlockingDeque|头部超时|offerFirst(e, time, unit)|pollFirst(time, unit)|-
BlockingDeque|尾部阻塞|putLast(e)|	takeLast()|-
BlockingDeque|尾部超时|offerLast(e, time, unit)|pollLast(time, unit)|-