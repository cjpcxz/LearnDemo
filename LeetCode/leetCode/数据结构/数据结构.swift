//
//  数据结构.swift
//  leetCode
//
//  Created by 陈晶泊 on 2022/8/21.
//

import Foundation
// LRU 缓存
class LRUCache {
    class LRU {
        var val:Int
        var key:Int
        var parent:LRU?
        var next:LRU?
        init(_ key:Int,_ val:Int){
            self.val = val
            self.key = key
        }
    }
    var cacheMap:[Int:LRU]
    var new:LRU?
    var old:LRU?
    let count:Int
    init(_ capacity: Int) {
        cacheMap = [:]
        count = capacity
    }
    
    func get(_ key: Int) -> Int {
        guard let value = cacheMap[key] else {
            return -1
        }
       
        updateLRU(value)
        return value.val
    }
    
    func put(_ key: Int, _ value: Int) {
        var lu = cacheMap[key]
        if lu == nil {
            lu = LRU(key,value)
            cacheMap[key] = lu
        }
        guard new != nil, old != nil else {
            new = lu
            old = lu
            return
        }
        lu?.val = value
        updateLRU(lu!)
        if cacheMap.count > count {
            let key1 = old!.key
            let temp = cacheMap.removeValue(forKey: key1)
            old = temp?.parent
            temp?.parent = nil
            old?.next = nil
        }
    }
    
    
    //更新本来在里面的
    func updateLRU( _ lu:LRU) {
        
        if lu.next == nil,lu.parent == nil {
            //单独的新节点
            lu.next = new
            new?.parent = lu
            new = lu
        } else if lu.next == nil {
            //父节点不为nil，下一个节点为空，此前为最后一个
            old = lu.parent
            old?.next = nil
            lu.next = new
            new?.parent = lu
            new = lu
            new?.parent = nil
        } else if lu.parent == nil {
            //说明为头节点，啥也不干
        } else if lu.parent != nil,lu.next != nil {
            //说明是中间节点
            lu.parent?.next = lu.next
            lu.next?.parent = lu.parent
            lu.next = new
            new?.parent = lu
            new = lu
            new?.parent = nil
        }
    }
}

class StockSpanner {
    var num = [Int]()
    var time = [Int]()
    init() {

    }
    
    func next(_ price: Int) -> Int {
        var sum = 1
        defer {
            num.append(price)
        }
        var i = num.count - 1
        while i >= 0  {
            if num[i] > price {
                time.append(sum)
                return sum
            } else if num[i] < price {
                sum += time[i]
                i = i - time[i]
            } else {
                let temp = time[i] + sum
                time.append(temp)
                return temp
            }
        }
        time.append(sum)
        return sum
        
    }
}


class NumArray {
    let sumPreArr:[Int]

    init(_ nums: [Int]) {
        var temp = Array(repeating: 0, count: nums.count),pre = 0
        for i in 0..<nums.count {
            pre += nums[i]
            temp[i] = pre
        }
        sumPreArr = temp
    }
    
    func sumRange(_ left: Int, _ right: Int) -> Int {
        guard case 0..<sumPreArr.count = left, case 0..<sumPreArr.count = right else {
            return -1
        }
        guard left > 0 else {
            return sumPreArr[right]
        }
        return sumPreArr[right] - sumPreArr[left-1]
    }
}


class AuthenticationManager {
    let timeToLive:Int
    private var unExpiredToken:[String:Int] = [:]
    
    init(_ timeToLive: Int) {
        self.timeToLive = timeToLive
    }
    
    func generate(_ tokenId: String, _ currentTime: Int) {
        unExpiredToken[tokenId] = currentTime
    }
    
    func renew(_ tokenId: String, _ currentTime: Int) {
        guard let lastTime = unExpiredToken[tokenId] else {
            return
        }
        guard lastTime + timeToLive > currentTime else {
            return
        }
        unExpiredToken[tokenId] = currentTime
    }
    
    func countUnexpiredTokens(_ currentTime: Int) -> Int {
        return unExpiredToken.reduce(0) { partialResult, info in
            return partialResult + ((info.value + timeToLive) > currentTime ? 1:0)
        }
    }
}

//2569. 更新数组后处理求和查询,线段树
// (1 , 5)(1,4) (2,3) (1,1) (4,4)
func handleQuery(_ nums1: [Int], _ nums2: [Int], _ queries: [[Int]]) -> [Int] {
    class Node {
        var l = 0
        var r = 0
        var sum = 0
        var lazytag = false
        
        
    }
    class SegTree {
        private var arr:[Node]
        init(nums:[Int]) {
            let n = nums.count
            self.arr = Array(repeating: Node(), count: (4 * n) + 1)
            build(id: 1, l: 0, r: n-1, nums: nums)
        }
        
        func sumRang(l:Int,r:Int) -> Int {
            return query(id: 1, l: l, r: r)
        }
        func reverseRang(l:Int,r:Int) {
            modify(id: 1, l: l, r: r)
        }
        
        func build(id:Int,l:Int,r:Int,nums:[Int]) {
            arr[id] = Node()
            arr[id].l = l
            arr[id].r = r
            if (l == r) {
                arr[id].sum = nums[l]
                return
            }
            let mid = (l + r) >> 1
            build(id: 2 * id, l: l, r: mid, nums: nums)
            build(id: 2 * id + 1, l:mid + 1, r: r, nums: nums)
            arr[id].sum = arr[2 * id].sum + arr[2 * id + 1].sum
        }
        //* pushdown函数：下传懒标记，即将当前区间的修改情况下传到其左右孩子结点 */
        func pushdown(x:Int) {
            if(arr[x].lazytag) {
                arr[2 * x].lazytag = !arr[2 * x].lazytag
                arr[2 * x].sum = arr[2 * x].r - arr[2 * x].l + 1 - arr[2 * x].sum
                arr[2 * x + 1].lazytag = !arr[2 * x + 1].lazytag
                arr[2 * x + 1].sum = arr[2 * x + 1].r - arr[2 * x + 1].l + 1 - arr[2 * x + 1].sum
                arr[x].lazytag = false
            }
        }
        
        //区间修改
        func modify(id:Int,l:Int,r:Int) {
            if arr[id].l >= l,arr[id].r <= r {
                arr[id].sum = arr[id].r - arr[id].l + 1 - arr[id].sum
                arr[id].lazytag = !arr[id].lazytag
                return
            }
            pushdown(x: id)
            if arr[2 * id].r >= l {
                modify(id: 2 * id, l: l, r: r)
            }
            
            if arr[2 * id + 1].l <= r {
                modify(id: (2 * id) + 1, l: l, r: r)
            }
            arr[id].sum = arr[2 * id].sum + arr[2 * id + 1].sum
        }
        
        func query(id:Int,l:Int,r:Int) -> Int {
            if arr[id].l >= l,arr[id].r <= r {
                return arr[id].sum
            }
            if arr[id].r < l || arr[id].l > r {
                return 0
            }
            pushdown(x: id)
            var res = 0
            if arr[2 * id].r >= l {
                res += query(id: 2 * id, l: l, r: r)
            }
            
            if arr[2 * id + 1].l <= r {
                res += query(id: 2 * id + 1, l: l, r: r)
            }
            return res
        }
    }
    
    let n = nums1.count
    let tree = SegTree(nums: nums1)
    var sum = nums2.reduce(0) { $0 + $1 },res = [Int]()
    for query in queries {
        switch query[0] {
        case 1:
            tree.reverseRang(l: query[1], r: query[2])
        case 2:
            sum += query[1] * tree.sumRang(l: 0, r: n-1)
        case 3:
            res.append(sum)
        default:break
        }
    }
    return res
}

// 1993. 树上的操作
class LockingTree {
    
    let tree:[[Int]]
    let parent:[Int]
    var lockMap = [Int:Int]()
    init(_ parent: [Int]) {
        var tree = Array(repeating: [Int](), count: parent.count)
        for i in 1..<parent.count {
            tree[parent[i]].append(i)
        }
        self.tree = tree
        self.parent = parent
    }
    
    func lock(_ num: Int, _ user: Int) -> Bool {
        guard lockMap[num] == nil else {
            return false
        }
        lockMap[num] = user
        return true
    }
    
    func unlock(_ num: Int, _ user: Int) -> Bool {
        guard lockMap[num] == user else {
            return false
        }
        lockMap[num] = nil
        return true
    }
    
    func upgrade(_ num: Int, _ user: Int) -> Bool {
        guard lockMap[num] == nil else {
            return false
        }
        guard !hasParentLock(num) else {
            return false
        }
        let cur = lockMap.count
        unLockSubTree(num: num)
        guard cur > lockMap.count else {
            return false
        }
        lockMap[num] = user
        return true
    }
    private func hasParentLock(_ num: Int) -> Bool {
        var par = parent[num]
        while par != -1 {
            if lockMap[par] != nil {
                return true
            }
            par = parent[par]
        }
        return false
    }
    
    private func unLockSubTree(num:Int) {
        for sub in tree[num] {
            lockMap[sub] = nil
            unLockSubTree(num: sub)
        }
    }
}

// 460. LFU 缓存
/**
 int get(int key) - 如果键 key 存在于缓存中，则获取键的值，否则返回 -1 。
 void put(int key, int value) - 如果键 key 已存在，则变更其值；如果键不存在，请插入键值对。当缓存达到其容量 capacity 时，则应该在插入新项之前，移除最不经常使用的项。在此问题中，当存在平局（即两个或更多个键具有相同使用频率）时，应该去除 最近最久未使用 的键。
get put,均会增加频率
 
 */
class LFUCache {
    class Node {
        var val: Int
        let key: Int
        var times: Int = 1
        var parent: Node?
        var next: Node?
        init(val:Int,key: Int) {
            self.val = val
            self.key = key
        }
    }
    let capacity:Int
    var timesMap = [Int:(Node,Node)]()
    var cacheMap = [Int:Node]()
    var old: Node?
    
    init(_ capacity: Int) {
        self.capacity = capacity
    }
    
    func get(_ key: Int) -> Int {
        guard let node = cacheMap[key] else {
            return -1
        }
        if old?.key == key {
            old = nil
        }
        increaseTime(node: node)
        return node.val
    }
    
    func put(_ key: Int, _ value: Int) {
        let node = cacheMap[key] ?? Node(val: value,key: key)
        
        if cacheMap.count >= capacity,cacheMap[key] == nil {
            //大于容量，并且是新插入的
            let removeKey = old!.key
            let parent = old?.parent
            parent?.next = nil
            if parent == nil {
                timesMap[old!.times] = nil
                old = nil
            }
            cacheMap.removeValue(forKey: removeKey)
            addTime(node: node, times: node.times)
        } else if cacheMap[key] == nil  {
            //新插入的
            addTime(node: node, times: 1)
        } else {
            increaseTime(node: node)
        }
        cacheMap[key] = node
    }
    
    func addTime(node: Node,times: Int) {
        if let timeNode = timesMap[times] {
            timeNode.0.parent = node
            node.next = timeNode.0
            timesMap[times] = (node,timeNode.1)
        } else {
            timesMap[times] = (node,node)
        }
        if old == nil {
            old = timesMap[times]?.1
        }
    }

    func increaseTime(node:Node) {
        let next = node.next
        if timesMap[node.times]?.0.key == node.key {
            //是首个
            next?.parent = nil
            if next == nil {
                timesMap[node.times] = nil
            } else {
                timesMap[node.times] = (next!,timesMap[node.times]!.1)
            }
        } else if timesMap[node.times]?.1.key == node.key {
            //是末尾
            let parent = node.parent
            parent?.next = nil
            node.parent = nil
            
            if parent == nil {
                timesMap[node.times] = nil
            } else {
                if old == nil {
                    old = parent
                }
                timesMap[node.times] = (timesMap[node.times]!.0,parent!)
            }
        } else {
           // 不是首个，是中间的
            let parent = node.parent
            parent?.next = next
            next?.parent = parent
        }
        node.times += 1
        addTime(node: node, times: node.times)
    }
}

// 2034. 股票价格波动
class StockPrice {
    var timestampMap = [Int:Int]()
    var curTimes: (Int,Int) = (Int.min,Int.min)
    // 存放最小的和最大的
    var maxArr:[(Int,Int)] = []
    var minArr:[(Int,Int)] = []
    
    init() {

    }
    
    func update(_ timestamp: Int, _ price: Int) {
        timestampMap[timestamp] = price
        if curTimes.0 <= timestamp {
            curTimes = (timestamp,price)
        }
        maxArr.append((timestamp,price))
        heapInsert(i: maxArr.count-1, handle: { arr,i, j in
            arr[j].1 > arr[i].1
        }, arr: &maxArr)
        minArr.append((timestamp,price))
        heapInsert(i: minArr.count-1, handle: { arr,i, j in
            arr[j].1 < arr[i].1
        }, arr: &minArr)
    }
    
    func current() -> Int {
        return curTimes.1
    }
    
    func maximum() -> Int {
        while let first = maxArr.first,timestampMap[first.0] != first.1 {
            maxArr[0] = maxArr.removeLast()
            heapFind(i: 0, handle: { arr,i, j in
                arr[j].1 > arr[i].1
            }, size: maxArr.count, arr: &maxArr)
        }
        return maxArr.first?.1 ?? 0
    }
    
    func minimum() -> Int {
        while let first = minArr.first,timestampMap[first.0] != first.1 {
            minArr[0] = minArr.removeLast()
            heapFind(i: 0, handle: { arr,i, j in
                arr[j].1 < arr[i].1
            }, size: minArr.count, arr: &minArr)
        }
        return minArr.first?.1 ?? 0
    }
    
    
    
    func heapInsert(i:Int,handle:(([(Int,Int)],Int,Int)->Bool),arr:inout [(Int,Int)]) {
        var i = i
        while handle(arr,(i-1)/2,i) {
            (arr[i],arr[(i-1)/2]) = (arr[(i-1)/2],arr[i])
            i = (i-1)/2
        }
    }
    
    func heapFind(i:Int,handle:(([(Int,Int)],Int,Int)->Bool),size:Int,arr:inout [(Int,Int)]) {
        var i = i
        var left = 2 * i + 1
        while left < size {
            let index = left + 1 < size && handle(arr,left,left+1) ? left + 1:left
            let changeIndex = handle(arr,i,index) ? index:i
            if changeIndex == i {
                // 不用交换
                return
            }
            (arr[i],arr[changeIndex]) = (arr[changeIndex],arr[i])
            i = changeIndex
            left = 2 * i + 1
        }
    }
}


// 1670. 设计前中后队列
class FrontMiddleBackQueue {
    class Node {
        let val:Int
        var next:Node?
        var parent:Node?
        init(val: Int) {
            self.val = val
        }
    }
    var front: Node?
    var mid: Node?
    var back: Node?
    var count: Int = 0
    init() {
        
    }
    // 1 4 3
    // 偶数加1，向前,奇数不变
    func pushFront(_ val: Int) {
        let temp = Node(val: val)
        if !isFristRetain(node: temp) {
            temp.next = front
            front?.parent = temp
            front = temp
            if count % 2 == 0  {
                mid = mid?.parent
            }
        }
    }
    
    //  1 2
    // 奇数向后，偶数向前， 2 时，前也会变
    func pushMiddle(_ val: Int) {
        let temp = Node(val: val)
        if !isFristRetain(node: temp) {
            
            if count == 2 {
                temp.next = front
                front?.parent = temp
                front = temp
            } else if count % 2 != 0  {
                let next = mid?.next
                mid?.next = temp
                temp.parent = mid
                temp.next = next
                next?.parent = temp
            } else {
                let parent = mid?.parent
                temp.next = mid
                mid?.parent = temp
                temp.parent = parent
                parent?.next = temp
            }
            mid = temp
        }
    }
    
    // 1 2 3 3
    // 奇数后退，偶数不变
    func pushBack(_ val: Int) {
        let temp = Node(val: val)
        if !isFristRetain(node: temp) {
            temp.parent = back
            back?.next = temp
            back = temp
            if count % 2 != 0  {
                mid = mid?.next
            }
        }
    }
    
    // 1 2 3 5
    // 奇数，中退，偶数不变
    func popFront() -> Int {
        guard count > 0 else {
            return -1
        }
        count -= 1
        let val = front!.val
        if count == 0 {
            front = nil
            back = nil
            mid = nil
        } else if count % 2 != 0 {
            mid = mid?.next
        }
        let temp = front?.next
        temp?.parent = nil
        front?.next = nil
        front = temp
        
        return val
    }
    
    // 1 2 3 4
    // 偶数，中进，奇数中退，2 的时候，前推
    func popMiddle() -> Int {
        guard count > 0 else {
            return -1
        }
        count -= 1
        let val = mid!.val
        if count == 0 {
            front = nil
            back = nil
            mid = nil
        }  else if count == 1 {
            front?.next = nil
            back?.parent = nil
            front = back
            mid = back
        } else if count % 2 == 0 {
            let temp = mid?.parent,next = mid?.next
            temp?.next = next
            next?.parent = temp
            mid?.next = nil
            mid?.parent = nil
            mid = temp
        } else {
            let temp = mid?.parent,next = mid?.next
            temp?.next = next
            next?.parent = temp
            mid?.next = nil
            mid?.parent = nil
            mid = next
        }
        
        return val
    }
    
    // 1 2 3
    // 偶数，中进，奇数不变
    func popBack() -> Int {
        guard count > 0 else {
            return -1
        }
        count -= 1
        let val = back!.val
        if count == 0 {
            front = nil
            back = nil
            mid = nil
        } else if count % 2 == 0 {
            mid = mid?.parent
        }
        let temp = back?.parent
        temp?.next = nil
        back?.parent = nil
        back = temp
        
        return val
    }
    
    func isFristRetain(node:Node) -> Bool {
        count += 1
        guard count == 1 else {
            return false
        }
        front = node
        back = node
        mid = node
        return true
    }
    
    
}


// 2336. 无限集中的最小数字
class SmallestInfiniteSet {
    var arr: [Int] = []
    var set: Set<Int> = .init()
    var small: Int = 1
    init() {

    }
    
    func heapInsert(arr:inout [Int],i:Int) {
        var i = i
        while arr[(i-1) / 2] > arr[i] {
            (arr[(i-1) / 2],arr[i]) = (arr[i],arr[(i-1) / 2])
            i = (i-1) / 2
        }
    }
    
    func heapFind(arr:inout [Int],i:Int,len:Int) {
        var i = i,l = 2 * i + 1
        while l < len {
            let smallEst = l + 1 < len && arr[l+1] < arr[l] ? (l + 1) : l
            let small = arr[smallEst] < arr[i] ? smallEst:i
            guard small != i else {
                return
            }
            (arr[small],arr[i]) = (arr[i],arr[small])
            i = l
            l = 2 * i + 1
        }
    }
    
    func popSmallest() -> Int {
        guard !arr.isEmpty else {
            defer {
                small += 1
            }
            return small
        }
        let res = arr[0]
        arr[0] = arr.last!
        arr.removeLast()
        set.remove(res)
        heapFind(arr: &arr, i: 0, len: arr.count)
        
        return res
    }
    
    func addBack(_ num: Int) {
        if num  < small,!set.contains(num){
            arr.append(num)
            set.insert(num)
            heapInsert(arr: &arr, i: arr.count - 1)
        }
    }
}
