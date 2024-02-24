//
//  day_4.swift
//  leetCode
//
//  Created by 陈晶泊 on 2022/3/19.
//

import Foundation
/**
 * Definition for singly-linked list.
 *
 */

 public class ListNode {
     public var val: Int
     public var next: ListNode?
     public var last: ListNode?
     public init(_ val: Int) {
         self.val = val
     }
  }


class Solution {
    func deleteNode(_ node: ListNode?) {
        if let currNode = node?.next {
            node?.val = currNode.val
            node?.next = currNode.next
            currNode.next = nil
        }

    }
}

func removeNthFromEnd(_ head: ListNode?, _ n: Int) -> ListNode? {
    var quickHead = head
    var lowHead = head
    var cunt = n
    while quickHead != nil,cunt > 0{
        quickHead = quickHead?.next
        cunt -= 1
    }
    guard cunt == 0 else {
        return head
    }
    guard quickHead != nil else {
        return head?.next
    }
    
    while let node = quickHead?.next {
        quickHead = node
        lowHead = lowHead?.next
    }
    let node = lowHead?.next?.next;
    lowHead?.next?.next = nil
    lowHead?.next = node
    return head
}

func reverseList(_ head: ListNode?) -> ListNode? {
    return reverseNodeList(head).1
}

func reverseNodeList(_ head: ListNode?) -> (ListNode?,ListNode?) {
    guard let nextNode  = head?.next else {
        return (head,head)
    }
    let (endNode,reslutNode) = reverseNodeList(nextNode);
    endNode?.next = head;
    head?.next = nil
    return (head,reslutNode)
}

func mergeTwoLists(_ list1: ListNode?, _ list2: ListNode?) -> ListNode? {
    guard let list1Node = list1 else {
        return list2
    }
    
    guard let list2Node = list2 else {
        return list1
    }

    let head: ListNode?
    if list1Node.val < list2Node.val {
        head = list1Node
        mergeMoreLowLists(list1Node.next, list2Node, head)
    } else {
        head = list2Node
        mergeMoreLowLists(list1Node, list2Node.next, head)
    }
    return head
}

func mergeMoreLowLists(_ list1: ListNode?, _ list2: ListNode?,_ head: ListNode?) {
    guard let list1Node = list1 else {
        head?.next = list2
        return
    }
    guard let list2Node = list2 else {
        head?.next = list1
        return
    }
    if list1Node.val < list2Node.val {
        head?.next = list1Node
        mergeMoreLowLists(list1Node.next, list2Node, list1Node)
    } else {
        head?.next = list2Node
        mergeMoreLowLists(list1Node, list2Node.next, list2Node)
    }
}

var temp:ListNode?
func isPalindrome(_ head: ListNode?) -> Bool {
    temp = head
    return check(head)
}

func check(_ head1: ListNode?)-> Bool {
    guard let value = head1?.val else {
        return true
    }
    let res = check(head1?.next) && (temp?.val == value)
    temp = temp?.next
    return res
    
}

func isPalindrome2(_ head: ListNode?) -> Bool {
    var quick = head
    var low = head
    while quick != nil,quick?.next != nil {
        quick = quick?.next?.next;
        low = low?.next
    }
    if quick != nil {
        low = low?.next
    }
    low = reverseNode(low)
    quick = head
    while low != nil {
        if(low?.val != quick?.val) {
            return false
        }
        quick = quick?.next
        low = low?.next
    }
    return true
}

func reverseNode(_ head: ListNode?) -> ListNode? {
    var pre: ListNode? = nil
    var headNode = head
    while headNode != nil {
        let next = headNode?.next
        headNode?.next = pre
        pre = headNode
        headNode = next
    }
    return pre
}

func hasCycle(_ head: ListNode?) -> Bool {
    var fast = head
    var low = head
    while fast != nil,fast?.next != nil {
        fast = fast?.next?.next
        low = low?.next
        if low === fast {
            return true
        }
    }
    return false
}

class MinStack {
    var head: ListNode?
    init() {
        
    }
    
    func push(_ val: Int) {
        let minNum = min(val, getMin())
        let nextNode = ListNode(val,minNum)
        nextNode.next = head
        head = nextNode
    }
    
    func pop() {
        head = head?.next
    }
    
    func top() -> Int {
        guard let top = head?.val else{
            return Int.min
        }
        return top
    }
    
    func getMin() -> Int {
        guard let min = head?.min else{
            return Int.max
        }
        return min
    }
    
    public class ListNode {
        public var val: Int
        public var min: Int?
        public var next: ListNode?
        public init(_ val: Int,_ min: Int) {
            self.val = val
            self.min = min
        }
     }
}

public class Node {
      public var val: Int
      public var next: Node?
      public var children: [Node] = []
      public init(_ val: Int) {
          self.val = val
          self.next = nil
    }
  }
func insert(_ head: Node?, _ insertVal: Int) -> Node? {
    guard let currentNode = head else {
        let head = Node(insertVal)
        head.next = head
        return head
    }
    var lasNode = currentNode
    while let curNode = lasNode.next {
        if lasNode.val < curNode.val,(insertVal > lasNode.val)&&(insertVal < curNode.val) {
            break
        } else if lasNode.val > curNode.val,(insertVal > lasNode.val)||(insertVal < curNode.val) {
            break
        } else if lasNode === curNode {
            break
        } else if lasNode.val == insertVal {
            break
        } else if curNode === head {
            break
        }
        lasNode = curNode
    }
    let temp = Node(insertVal)
    let curNode = lasNode.next
    lasNode.next = temp
    temp.next = curNode
    
    return head
}

//跳表数据结构
class Skiplist {
    let level = 10//实际数据的log2N
    class SkipNode {
        var forward:[SkipNode?]
        let val:Int
        init(level:Int,val:Int){
            self.val = val
            self.forward = Array(repeating: nil, count: level)
        }
    }
    var root:SkipNode
    
    init() {
        root = SkipNode(level: level, val: -1)
    }
    
    func search(_ target: Int) -> Bool {
        var nodeArr = Array<SkipNode?>(repeating: nil, count: level)
        find(target,&nodeArr)
        return nodeArr[0]?.forward[0] != nil && nodeArr[0]?.forward[0]?.val == target
    }
    
    func find(_ t:Int,_ ns:inout [SkipNode?]){
        var cur = root
        for i in (0..<level).reversed() {
            while let node = cur.forward[i],node.val < t {
                cur = node
            }
            ns[i] = cur
        }
    }
    
    func add(_ num: Int) {
        var nodeArr = Array<SkipNode?>(repeating: nil, count: level)
        find(num,&nodeArr)
        let node = SkipNode(level: level, val: num)
        let times = levelNum()
        for i in 0..<times{
            node.forward[i] = nodeArr[i]?.forward[i]
            nodeArr[i]?.forward[i] = node
        }
    }
    
    
    func levelNum()->Int {
       var num =  1
        var times = 0
        while num == 1,times < level {
            num =  Int.random(in: 0...1)
            times += 1
        }
        return times
    }
    
    func erase(_ num: Int) -> Bool {
        var nodeArr = Array<SkipNode?>(repeating: nil, count: level)
        find(num,&nodeArr)
        let node = nodeArr[0]?.forward[0]
        if node == nil || node?.val != num {
            return false
        }
        var i = 0
        while i < level,nodeArr[i]?.forward[i]?.val == num{
            nodeArr[i]?.forward[i] = nodeArr[i]?.forward[i]?.forward[i]
            i+=1
        }
        return true
    }
}

//删除链表
func deleteDuplicates(_ head: ListNode?) -> ListNode? {
    guard var currNode = head else {
        return head
    }
    var lastNum = currNode.val
    while let next = currNode.next {
        if next.val == lastNum {
            currNode.next = next.next
        } else {
            currNode = next
            lastNum = next.val
        }
    }
    return head
}

//203. 移除链表元素
func removeElements(_ head: ListNode?, _ val: Int) -> ListNode? {
    guard let head = head else {
        return head
    }
    if head.val == val {
        return removeElements(head.next, val)
    } else {
        let next = removeElements(head.next, val)
        head.next = next
        return head
    }
}

//2. 两数相加
func addTwoNumbers(_ l1: ListNode?, _ l2: ListNode?) -> ListNode? {
    guard let ll1 = l1,let ll2 = l2 else {
        return l1 == nil ? l2:l1
    }
    addTwoNumbers(ll1, ll2, 0)
    
    return ll1
}

func addTwoNumbers(_ l1: ListNode, _ l2: ListNode?,_ last:Int) {
    
    if let ll1 = l1.next,let lx2 = l2,let ll2 = lx2.next {
        //都有下一个
        let temp = l1.val + lx2.val + last
        l1.val = temp % 10
        addTwoNumbers(ll1, ll2, temp / 10)
    } else if let ll1 = l1.next,let lx2 = l2 {
        //1有下一个，2没有，2有当前的
        let temp = l1.val + lx2.val + last
        l1.val = temp % 10
        addTwoNumbers(ll1, nil, temp / 10)
    } else if let lx2 = l2,let ll2 = lx2.next {
        //2有下一个，1没有,1有当前
        let temp = l1.val + lx2.val + last
        l1.val = temp % 10
        l1.next = ll2
        addTwoNumbers(ll2, nil, temp / 10)
    }  else if let ll1 = l1.next,l2 == nil,last > 0 {
        //1有下一个，2为nil，last大于0
        let temp = l1.val + last
        l1.val = temp % 10
        addTwoNumbers(ll1, nil, temp / 10)
    } else if let l2 = l2 {
        //1,2都没有下一个，只有当前
        let temp = l1.val + l2.val + last
        l1.val = temp % 10
        if temp / 10  > 0 {
            l1.next = ListNode(temp / 10)
        }
    } else if last > 0 {
        //1没有下一个，2为nil，last大于0
        let temp = l1.val + last
        l1.val = temp % 10
        if temp / 10  > 0 {
            l1.next = ListNode(temp / 10)
        }
    }
}
//160. 相交链表, 双指针法
func getIntersectionNode1(_ headA: ListNode?, _ headB: ListNode?) -> ListNode? {
    //AB加起来的路径相等，其中前半段必相同，后半段有重叠位置，则会指向同一个点，无则指向nil
    guard headA != nil,headB != nil else {
        return nil
    }
    var nodeA = headA
    var nodeB = headB
    while !(nodeA === nodeB) {
        nodeA = nodeA?.next
        nodeB = nodeB?.next
        if nodeA == nil,nodeB == nil {
            return nil
        }
        if nodeA == nil {
            //只会出现一次
            nodeA = headB
        }
        if nodeB == nil {
            //只会出现一次
            nodeB = headA
        }
    }
    return nodeB
}
func getIntersectionNode2(_ headA: ListNode?, _ headB: ListNode?) -> ListNode? {
    var nodeAs = [ListNode]()
    var nodeBs = [ListNode]()
    var nodeA = headA
    var nodeB = headB
    while nodeA != nil || nodeB != nil {
        if let node = nodeA {
            nodeAs.append(node)
            nodeA = node.next
        }
        
        if let node = nodeB {
            nodeBs.append(node)
            nodeB = node.next
        }
    }
    let countA = nodeAs.count,countB = nodeBs.count
    let count = min(countA,countB)
    var result:ListNode? = nil
    for i in 1...count {
        if !(nodeAs[countA - i] ===  nodeBs[countB - i]) {
            break
        }
        result = nodeAs[countA - i]
    }
    
    return result
    
}


class MyLinkedList {
    class Node {
        let val:Int
        var next:Node?
        init(val: Int) {
            self.val = val
        }
    }
    
    var curNode:Node?
    var lasNode:Node?
    var count = 0
    init() {

    }
    
    func get(_ index: Int) -> Int {
        guard case 0..<count = index else {
            return -1
        }
        var cur = curNode
        for _ in 0..<index {
            cur = cur?.next
        }
        return cur?.val ?? -1
    }
    
    func addAtHead(_ val: Int) {
        let node = Node(val: val)
        node.next = curNode
        curNode = node
        if count == 0 {
            lasNode = node
        }
        count += 1
    }
    
    func addAtTail(_ val: Int) {
        let node = Node(val: val)
        lasNode?.next = node
        lasNode = node
        if count == 0 {
            curNode = node
        }
        count += 1
    }
    
    func addAtIndex(_ index: Int, _ val: Int) {
        if index == count {
            addAtTail(val)
        } else if index <= 0 {
            addAtHead(val)
        } else if count > 1,case 1..<count = index {
            var cur = curNode
            for _ in 0..<(index-1) {
                cur = cur?.next
            }
            let node = Node(val: val)
            node.next = cur?.next
            cur?.next = node
            count += 1
        }
        
    }
    
    func deleteAtIndex(_ index: Int) {
        guard case 0..<count = index else {
            return
        }
        if index == 0 {
            let nodel = curNode
            curNode = nodel?.next
            nodel?.next = nil
            count -= 1
        } else {
            var cur = curNode
            for _ in 0..<(index-1) {
                cur = cur?.next
            }
            let next = cur?.next?.next
            cur?.next = next
            if index == count-1 {
                lasNode = cur
            }
            count -= 1
        }
        
    }
}

//817. 链表组件
func numComponents(_ head: ListNode?, _ nums: [Int]) -> Int {
    guard nums.count > 1 else {
        return 1
    }
    var node = head,sum = 0
    var map = Dictionary<Int,Int>(minimumCapacity: nums.count)
    for num in nums {
        map[num] = 1
    }
    var last = false
    while let nod = node {
        defer {
            node = node?.next
        }
        //上一个是连续的
        guard last else {
            if map[nod.val] != nil {
                //之前断的，不为断的，
                last = true
            }
            //一直未断的不管
            
            continue
        }
        if map[nod.val] == nil {
            //在当前断了
            sum += 1
            last = false
        }
        //其他没断，不做处理
    }
    

    return last ? sum + 1:sum
}

func preorder(_ root: Node?) -> [Int] {
    guard let root = root else {
        return []
    }
    var temp = [root.val]
    for node in root.children {
        temp += preorder(node)
    }
    return temp
}


func mergeInBetween(_ list1: ListNode?, _ a: Int, _ b: Int, _ list2: ListNode?) -> ListNode? {
    var node = ListNode(0),lasA = node,endN:ListNode?
    node.next = list1
    var index = 0
    while let curN = lasA.next {
        if index == a {
            lasA.next = list2
        }
        
        if index == b {
            endN = curN.next
            break
        }
        lasA = curN
        index += 1
    }
    var lasB = list2
    while let curN = lasB?.next {
        lasB = curN
    }
    lasB?.next = endN
    return node.next
}

//876. 链表的中间结点
func middleNode(_ head: ListNode?) -> ListNode? {
    var qNode = head,sNode = head
    while let temp1 = qNode?.next?.next,let temp2 = sNode?.next {
        sNode = temp2
        qNode = temp1
    }
    guard qNode?.next  != nil else {
        return sNode
    }
    return sNode?.next
}

//1019. 链表中的下一个更大节点
//[9,7,6,7,6,9]
//

func nextLargerNodes(_ head: ListNode?) -> [Int] {
    var node = head
    
    var lastNode = head,lastMin = lastNode!.val,res = [Int](),undein = [(Int,Int)]()
    while let cur = node?.next {
        if cur.val > lastMin {
            while lastNode !== cur {
                if lastNode!.val < cur.val {
                    res.append(cur.val)
                } else {
                    undein.append((res.count,lastNode!.val))
                    res.append(0)
                }
                lastNode = lastNode?.next
            }
            while let last = undein.last,last.1 < cur.val {
                res[last.0] = cur.val
                undein.removeLast()
            }
            lastMin = cur.val
        } else {
            lastMin = min(lastMin,cur.val)
        }
        node = cur
    }
    
    while lastNode != nil {
        res.append(0)
        lastNode = lastNode?.next
    }
    return res
}

//1171. 从链表中删去总和值为零的连续节点
func removeZeroSumSublists(_ head: ListNode?) -> ListNode? {
    let temp = ListNode(0)
    temp.next = head
    var arr = [(temp,0)],head1 = head
    while let cur = head1 {
        arr.append((cur,arr.last!.1 + cur.val))
        head1 = cur.next
    }
    let n = arr.count
    var i = 0
    while i < n {
        var j = n-1
        while j > i {
            print(arr[j].1 - arr[i].1)
            if arr[j].1 - arr[i].1 == 0 {
                arr[i].0.next = arr[j].0.next
                i = j
                break
            }
            j -= 1
        }
        i += 1
    }
    return arr.first?.0.next
}

//445. 两数相加 II
func addTwoNumbers2(_ l1: ListNode?, _ l2: ListNode?) -> ListNode? {
    var res1 = [Int](),res2 = [Int](),l1 = l1,l2 = l2
    while let cur = l1 {
        res1.append(cur.val)
        l1 = l1?.next
    }
    
    while let cur = l2 {
        res2.append(cur.val)
        l2 = l2?.next
    }
    var cur = ListNode(0),last = 0
    let minC = min(res1.count,res2.count)
    for i in 1..<(minC+1) {
        let temp = last + res1[res1.count - i] + res2[res2.count - i]
        cur.val = temp % 10
        last = temp / 10
        let next = ListNode(0)
        next.next = cur
        cur = next
    }
    let maxArr = minC < res1.count ? res1:res2
    for i in (minC+1)..<(maxArr.count + 1) {
        let temp = last + maxArr[maxArr.count - i]
        cur.val = temp % 10
        last = temp / 10
        let next = ListNode(0)
        next.next = cur
        cur = next
    }
    guard last > 0 else {
        return cur.next
    }
    cur.val = last
    return cur
    
}

//142. 环形链表 II

func detectCycle(_ head: ListNode?) -> ListNode? {
    var fast = head,low = head
    while fast != nil,low != nil {
        if fast === low {
            low = head
            while fast !== low {
                fast = fast?.next
                low = low?.next
            }
            return fast
        }
        fast = fast?.next?.next
        low = low?.next
    }
    return nil
}

//143. 重排链表
func reorderList(_ head: ListNode?) {
//    var node = head,nodes = [ListNode]()
//    while let cur = node {
//        nodes.append(cur)
//        node = node?.next
//    }
//    let n = nodes.count
//    for i in 0..<n/2 {
//        let temp = nodes[i].next
//        nodes[i].next = nodes[n-i-1]
//        nodes[n-i-1].next = temp
//    }
//    if n > 0 {
//        nodes[n/2].next = nil
//    }
    let mid = midNode(head: head),l1 = head
    var l2 = mid?.next
    mid?.next = nil
    l2 = reverseList(head: l2)
    mergeList(l1: l1, l2: l2)
    func reverseList(head: ListNode?) -> ListNode? {
        var pre:ListNode? = nil
        var head = head
        while let cur = head {
            let tempNext = cur.next
            cur.next = pre
            pre = cur
            head = tempNext
        }
        return pre
    }
    func midNode(head:ListNode?) -> ListNode? {
        var slow = head,fast = head
        while let cur1 = slow?.next, let cur2 = fast?.next?.next {
            slow = cur1
            fast = cur2
        }
        return slow
    }
    func mergeList(l1:ListNode?,l2:ListNode?) {
        var l1 = l1,l2 = l2
        while l1 != nil,l2 != nil {
            let temp1 = l1?.next
            let temp2 = l2?.next
            l1?.next = temp2
            l1 = temp1
            l2?.next = temp1
            l2 = temp2
        }
    }
}

// 23. 合并 K 个升序链表 最小堆用法
func mergeKLists(_ lists: [ListNode?]) -> ListNode? {
    func heapFind(i:Int,arr:inout [ListNode]) {
        var i = i
        while arr[(i-1)/2].val > arr[i].val {
            (arr[(i-1)/2],arr[i]) = (arr[i],arr[(i-1)/2])
            i = (i-1)/2
        }
    }
    
    func heapInsert(i:Int,arr:inout [ListNode],size:Int) {
        var i = i,l = 2 * i + 1
        while l < size {
            let minIndex = 2 * i + 2 < size && arr[2 * i + 2].val < arr[2 * i + 1].val ? 2 * i + 2 : 2 * i + 1
            let changIndex = arr[i].val < arr[minIndex].val ? i:minIndex
            guard changIndex != i else {
                return
            }
            (arr[changIndex],arr[i]) = (arr[i],arr[changIndex])
            i = changIndex
            l = 2 * i + 1
        }
    }
    
    var res = ListNode(Int.min),heap = [ListNode]()
    for case let .some(node) in lists {
        heap.append(node)
        heapFind(i: heap.count-1, arr: &heap)
    }
    var cur = res,n = heap.count
    while n > 0 {
        cur.next = heap[0]
        cur = heap[0]
        if let next = heap[0].next {
            heap[0] = next
            heapInsert(i: 0, arr: &heap, size: n)
        } else {
            heap[0] = heap[n-1]
            n -= 1
            heapInsert(i: 0, arr: &heap, size: n)
        }
    }
    return res.next
}

// 2487. 从链表中移除节点
/**
 移除每个右侧有一个更大数值的节点。

 返回修改后链表的头节点 head
 [5,2,13,3,18];
 maxNode, 5->2,
 
 */
func removeNodes(_ head: ListNode?) -> ListNode? {
    var nodes = [ListNode](),head = head
    while let nod = head {
        while let last = nodes.last,last.val < nod.val {
            nodes.removeLast()
            nodes.last?.next = nil
        }
        nodes.last?.next = nod
        nodes.append(nod)
        head = head?.next
    }
    return nodes.first
}

//2807. 在链表中插入最大公约数
func insertGreatestCommonDivisors(_ head: ListNode?) -> ListNode? {
    func greatestCommonDivisors(a:Int,b:Int) -> Int {
        var l = max(a,b),s = min(a,b)
        while l % s != 0 {
            (l,s) = (s,l % s)
        }
        return s
    }
    guard var last = head else {
        return head
    }
    while let next = last.next {
        let tNod =  ListNode(greatestCommonDivisors(a: last.val, b: next.val))
        last.next = tNod
        tNod.next = next
        last = next
    }
    
    return head
}
// 1 2 10 11
// 82. 删除排序链表中的重复元素 II [-100,100]
func deleteDuplicates1(_ head: ListNode?) -> ListNode? {
    let h = ListNode(-112)
    h.next = ListNode(-110)
    var hc = h,cur = head,last = h.next!,time = 0
    while let c = cur {
        if c.val != last.val {
            if time == 0 {
                // hc.next 上一个合理
                hc = hc.next!
            }
            hc.next = c
            last = c
            time = 0
        } else {
            time += 1
        }
        cur = cur?.next
    }
    if time != 0 {
        hc.next = nil
    }
    
    return h.next?.next
}


// 92. 反转链表 II
/**
 给你单链表的头指针 head 和两个整数 left 和 right ，其中 left <= right 。请你反转从位置 left 到位置 right 的链表节点，返回 反转后的链表 。
 */
func reverseBetween(_ head: ListNode?, _ left: Int, _ right: Int) -> ListNode? {
    let roo = ListNode(0)
    roo.next = head
    var i = 1,cur:ListNode? = head,begin: ListNode? = nil,lefN: ListNode? = left == 1 ? roo:nil
    while cur != nil {
        let tNext = cur?.next
        if i == left {
            begin = cur
        } else if i == left - 1 {
            lefN = cur
        } else if i == right + 1 {
            lefN?.next?.next = cur
            lefN?.next = begin
            return roo.next
        } else if let nod = begin {
            begin = cur
            begin?.next = nod
        }
        cur = tNext
        i += 1
    }
    lefN?.next = begin
    return roo.next
}


