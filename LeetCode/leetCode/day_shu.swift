//
//  day_shu.swift
//  leetCode
//
//  Created by 陈晶泊 on 2022/6/3.
//

import Foundation

//连续整数求和,奇数个，保证，%为0.偶数个，保证余数为(偶数 + 1)/2
func consecutiveNumbersSum(_ n: Int) -> Int {
    guard n > 2 else {
        return 1
    }
    var count = 1
    var i = 2
    var num = (i + 1) / 2
    while n / i >= num {
        if i % 2 == 0 && n % i == num {
            count += 1
        } else if i % 2 != 0 && n % i == 0 {
            count += 1
        }
        i += 1
        num = (i + 1) / 2
    }
    return count
}

class MyCalendarThree {
    var treeMapN = [Int:Int]()
    init() {

    }
        
    func book(_ start: Int, _ end: Int) -> Int {
        treeMapN[start] = (treeMapN[start] ?? 0) + 1
        treeMapN[end] = (treeMapN[end] ?? 0) - 1
        var lastNum = 0
        var maxNum = 1
        let keyArray = treeMapN.keys.sorted()
        for k in keyArray {
            lastNum = lastNum + treeMapN[k]!
            maxNum = max(maxNum, lastNum)
        }
        return maxNum
    }
}

func minEatingSpeed(_ piles: [Int], _ h: Int) -> Int {
    if piles.count == h {
        return piles.max()!
    }
    var left = 1
    var right = piles.max()!
    var mid = 0
    while left < right {
       mid = (right - left) / 2 + left
        if onKeep(piles, h, mid) {
            right = mid
        } else {
            left = mid + 1
        }
    }
    return mid
}

func onKeep(_ piles: [Int], _ h: Int,_ mid:Int)->Bool {
    var num = 0
    for pile in piles {
        let time = pile / mid + (pile % mid == 0 ? 0:1)
        num += time
    }
    return num <= h
}

func isBoomerang(_ points: [[Int]]) -> Bool {
    let x12  = points[0][0] - points[1][0]
    let y12  = points[0][1] - points[1][1]
    let x32  = points[2][0] - points[1][0]
    let y32  = points[2][1] - points[1][1]
    return y32 * x12 != y12 * x32
}

func nextGreaterElement(_ n: Int) -> Int {
    guard n > 10 else {
        return -1
    }
    var num = n
    var sorNum = [Int]()
    var lasNum = -1
    while num > 0 {
        let index = num % 10
        num = num / 10
        if index < lasNum {
            for i in 0..<sorNum.count {
                if sorNum[i] > index {
                    num = num * 10 + sorNum[i]
                    sorNum.remove(at: i)
                    sorNum.append(index)
                    break
                }
            }
            break
        }
        sorNum.append(index)
        lasNum = index
    }
    
    if num > 0 {
        sorNum.sort()
        for i in sorNum {
            num = num * 10 + i
        }
        return num > Int32.max ? -1 : num
    }
    
    return -1
}

class MyCalendar {
    var treeMap = [Int:Int]()
    init() {

    }
    
    func book(_ start: Int, _ end: Int) -> Bool {
        var canAdd = true
        for map in treeMap {
            if start >= map.value || end <= map.key {
                continue
            }
            canAdd = false
            break
        }
        if canAdd {
            treeMap[start] = end
        }
        return canAdd
    }
}


func replaceWords(_ dictionary: [String], _ sentence: String) -> String {
    var dict = dictionary
    quickStringSort(&dict, 0, dict.count-1)
    let minCount = dict.first!.count
    let strArr = sentence.components(separatedBy: " ")
    var result = [String]()
    for str in strArr {
        let strCount = str.count
        var addStr = true
        if strCount > minCount {
            for dicStr in dict {
                if subString(str,dicStr.count) == dicStr {
                    addStr = false
                    result.append(dicStr)
                    break
                }
            }
        }
        if addStr {
            result.append(str)
        }
        
    }
    return result.joined(separator: " ")
}

func subString(_ str:String,_ to:Int) -> String {
    guard str.count > to else {
        return ""
    }
    let startIndex = str.startIndex
    let endIndex = str.index(startIndex, offsetBy: to)
    return String(str[startIndex..<endIndex])
}

///荷兰国旗排序，方式
func quickStringSort(_ arr:inout [String],_ leftIndex:Int, _ rightIndex:Int){
    guard leftIndex < rightIndex else {
        return
    }
    var less = leftIndex - 1
    var i = leftIndex
    var more = rightIndex + 1
    let temp = arr[leftIndex].count
    while i < more {
        if arr[i].count < temp {
            less += 1
            swap(array: &arr, i: less, j: i)
            i += 1
        } else if arr[i].count > temp {
            more -= 1
            swap(array: &arr, i: more, j: i)
        } else {
            i += 1
        }
    }
    quickStringSort(&arr, leftIndex, less)
    quickStringSort(&arr, more, rightIndex)
    
}

func swap(array:inout [String],i:Int,j:Int){
    let temp =  array[i]
    array[i] = array[j]
    array[j] = temp
    
}

func mySqrt(_ x: Int) -> Int {
    guard x >= 4 else {
        return 1
    }
    var left = 2,right = x
    while left < right {
        let mid = (right - left) >> 1 + left
        if mid * mid < x {
            left = mid + 1//因为，取中间数是向下取的，因此，都是左边加1 ，不然会一直循环
        } else {
            right = mid
        }
    }
    return (left * left <= x) ? left:left-1
}


func groupThePeople(_ groupSizes: [Int]) -> [[Int]] {
    var map = [Int:[Int]]()
    for (index,value) in groupSizes.enumerated()  {
        map[value] = (map[value] ?? []) + [index]
    }
    var result = [[Int]]()
    for (key,value) in map {
        let times = (value.count / key)
        for i in 0..<times {
            let arr = Array(value[(key * i)..<(key * (i+1))])
            result.append(arr)
        }
    }
    return result
}

// 2003. 每棵子树内缺失的最小基因值
func smallestMissingValueSubtree(_ parents: [Int], _ nums: [Int]) -> [Int] {
    let n = parents.count
    var tree = Array(repeating: [Int](), count: parents.count)
    for i in 1..<n{
        tree[parents[i]].append(i)
    }
    var res = Array(repeating: 1, count: n)
    var visit = Array(repeating: false, count: n)
    var geneSet = Set<Int>()
    func dfs(node:Int,visit: inout [Bool],childen: [[Int]]) {
        guard !visit[node] else {
            return
        }
        visit[node] = true
        geneSet.insert(nums[node])
        for child in childen[node] {
            dfs(node: child, visit: &visit, childen: childen)
        }
    }
    var iNode = 1,node = -1
    for i in 0..<n where nums[i] == 1 {
        node = i
        break
    }
    while node != -1 {
        dfs(node: node, visit: &visit, childen: tree)
        while geneSet.contains(iNode) {
            iNode += 1
        }
        res[node] = iNode
        node = parents[node]
    }
    return res
}

// 117. 填充每个节点的下一个右侧节点指针 II
class TextNode {
    class Node {
        public var val: Int
        public var left: Node?
        public var right: Node?
        public var next: Node?
        public init(_ val: Int) {
             self.val = val
             self.left = nil
             self.right = nil
             self.next = nil
        }
        
    }
    func connect(_ root: Node?) -> Node? {
        guard let root = root else {
            return nil
        }
        var nodeArr = [root]
        while !nodeArr.isEmpty {
            var temp = [Node]()
            for i in 0..<nodeArr.count {
                if i < nodeArr.count - 1 {
                    nodeArr[i].next = nodeArr[i+1]
                }
                if let left = nodeArr[i].left {
                    temp.append(left)
                }
                
                if let right = nodeArr[i].right {
                    temp.append(right)
                }
            }
            nodeArr = temp
        }
        
        return root
    }
}

// 421. 数组中两个数的最大异或值
// 1 0 1 0
// 1 1 0 1
// 1 0 1 0 1
func findMaximumXOR(_ nums: [Int]) -> Int {
    var res = 0,mask = 0
    for i in (0...30).reversed() {
        mask = mask | (1 << i)
        var set = Set<Int>()
        for num in nums {
            set.insert(num & mask)
        }
        var temp = res | (1 << i)
        for prefix in set where set.contains(prefix ^ temp) {
            res = temp
            break
        }
    }
    return res
}

// 010 & 110
func pseudoPalindromicPaths (_ root: TreeNode?) -> Int {
    func pseudoPalindromicPaths(_ root: TreeNode,mode:Int16) -> Int {
        
        let mode = (1 << root.val) ^ mode
        var res = 0
        if let left = root.left {
            res += pseudoPalindromicPaths(left, mode: mode)
        }
        
        if let right = root.right {
            res += pseudoPalindromicPaths(right, mode: mode)
        }
        
        if root.left == nil,root.right == nil {
            res += (mode - (mode & -mode) == 0) ? 1:0
        }
        return res
    }
    
    return pseudoPalindromicPaths(root!,mode: 0b0)
}


//2846. 边权重均等查询
/**
 现有一棵由 n 个节点组成的无向树，节点按从 0 到 n - 1 编号。给你一个整数 n 和一个长度为 n - 1 的二维整数数组 edges ，其中 edges[i] = [ui, vi, wi] 表示树中存在一条位于节点 ui 和节点 vi 之间、权重为 wi 的边。

 另给你一个长度为 m 的二维整数数组 queries ，其中 queries[i] = [ai, bi] 。对于每条查询，请你找出使从 ai 到 bi 路径上每条边的权重相等所需的 最小操作次数 。在一次操作中，你可以选择树上的任意一条边，并将其权重更改为任意值。

 注意：

 查询之间 相互独立 的，这意味着每条新的查询时，树都会回到 初始状态 。
 从 ai 到 bi的路径是一个由 不同 节点组成的序列，从节点 ai 开始，到节点 bi 结束，且序列中相邻的两个节点在树中共享一条边。
 返回一个长度为 m 的数组 answer ，其中 answer[i] 是第 i 条查询的答案。
 cnt[n][26]记录到每个几点，每个边权出现的次数，
LCA倍增，以0为节点 ,a到b出现最多的边次数就是 cnt[a][j] + cnt[b][j] -2 x cnt[x][j]，x是最近公共祖先
 1 <= wi <= 26
 */
func minOperationsQueries(_ n: Int, _ edges: [[Int]], _ queries: [[Int]]) -> [Int] {
    let m = 64 - n.leadingZeroBitCount //类比log2n
    var lca = Array(repeating: Array(repeating: 0, count: m), count: n) // lca[i][j],节点i的第2^j个祖先
    var p = Array(repeating: 0, count: n) //父节点
    var depth = Array(repeating: 0, count: n)
    var dicArr = Array(repeating: [(Int,Int)](), count: n)
    for e in edges {
        dicArr[e[0]].append((e[1],e[2]-1))
        dicArr[e[1]].append((e[0],e[2]-1))
    }
    var cnt = Array(repeating: Array(repeating: 0, count: 26), count: n)
    var queue = [0] //从0开始遍历
    while !queue.isEmpty {
        let i = queue.removeFirst()
        lca[i][0] = p[i] // 2的0次倍，即父节点
        for j in 1..<m {
            lca[i][j] = lca[lca[i][j-1]][j-1] //i跳2^j后的父节点
        }
        for nxt in dicArr[i] where p[i] != nxt.0 { //排除父节点
            let j = nxt.0,w = nxt.1
            p[j] = i
            cnt[j] = cnt[i] //子节点和父节点，频次除了当前子节点的，其他是一样的
            cnt[j][w] += 1
            depth[j] = depth[i] + 1
            queue.append(j)
        }
    }
    let k = queries.count
    var res = Array(repeating: 0, count: k)
    for i in 0..<k {
        let a = queries[i][0],b = queries[i][1]
        var maxX = a,minY = b //最近公共节点
        if depth[maxX] < depth[minY] { (maxX,minY) = (minY,maxX)}
        for j in (0..<m).reversed() where depth[maxX] - depth[minY] >= (1 << j) {
            //由大到小，找到相同的深度LCA位置
            maxX = lca[maxX][j] //如果x和y的查询大于2^j，直接跳到这个位置，缩小距离，直到在同一位置
        }
        // 都是从大到小遍历，原因是，例如要到上方5的时候是，最近（5以上肯定是相当的）,到0b101,肯定是从大到小
        for j in (0..<m).reversed() where lca[maxX][j] != lca[minY][j] {
            (maxX,minY) = (lca[maxX][j],lca[minY][j]) //这里会遍历到x和y的父节点相同之前
        }
        if maxX != minY { //经过了第2个循环，x和y的父节点相同
            maxX = p[maxX]
        }
        var maxres = 0 //a到b频次最多的次数
        for j in 0..<26 {
            maxres = max(maxres,cnt[a][j] + cnt[b][j] - 2 * cnt[maxX][j])
        }
        // a和b的长度见去频次最多的
        res[i] = depth[a] + depth[b] - 2 * depth[maxX] - maxres
        
    }
    return res
}

//2641. 二叉树的堂兄弟节点 II
/**
 给你一棵二叉树的根 root ，请你将每个节点的值替换成该节点的所有 堂兄弟节点值的和 。

 如果两个节点在树中有相同的深度且它们的父节点不同，那么它们互为 堂兄弟 。

 请你返回修改值之后，树的根 root 。

 注意，一个节点的深度指的是从树根节点到这个节点经过的边数。
 */
func replaceValueInTree(_ root: TreeNode?) -> TreeNode? {
    var queue = [root],res = 0
    root?.val = 0
    while !queue.isEmpty {
        var tempQu = [TreeNode?]()
        if queue.count > 1 {
            var temque = [TreeNode](),cur = res
            for nod in queue {
                if let node = nod {
                    cur -= node.val
                    temque.append(node)
                } else {
                    for temN in temque {
                        temN.val = cur
                    }
                    cur = res
                    temque = []
                }
            }
        }
        res = 0
        for nod in queue {
            if let left = nod?.left {
                tempQu.append(left)
                res += left.val
            }
            
            if let right = nod?.right {
                tempQu.append(right)
                res += right.val
            }
            if nod?.left != nil || nod?.right != nil {
                tempQu.append(nil)
            }
        }
        queue = tempQu
    }

    return root
}


// 993. 二叉树的堂兄弟节点
/**
 在二叉树中，根节点位于深度 0 处，每个深度为 k 的节点的子节点位于深度 k+1 处。

 如果二叉树的两个节点深度相同，但 父节点不同 ，则它们是一对堂兄弟节点。

 我们给出了具有唯一值的二叉树的根节点 root ，以及树中两个不同节点的值 x 和 y 。

 只有与值 x 和 y 对应的节点是堂兄弟节点时，才返回 true 。否则，返回 false。
 */
func isCousins(_ root: TreeNode?, _ x: Int, _ y: Int) -> Bool {
    guard let root = root else {
        return false
    }
    var queue = [root],isEnd = 0b00
    func changMod(num:Int,mode:inout Int) {
        switch num {
            case x:mode |= 0b01
            case y:mode |= 0b10
            default:break
        }
    }
    while !queue.isEmpty,isEnd == 0b00 {
        var temp = [TreeNode]()
        for qN in queue {
            var cur = 0b00
            if let left = qN.left {
                temp.append(left)
                changMod(num: left.val, mode: &cur)
            }
            
            if let right = qN.right {
                temp.append(right)
                changMod(num: right.val, mode: &cur)
            }
            guard cur != 0b11 else {
                return false
            }
            isEnd |= cur
        }
        queue = temp
    }
    return isEnd == 0b11
}

//236. 二叉树的最近公共祖先
/**
 给定一个二叉树, 找到该树中两个指定节点的最近公共祖先。

 百度百科中最近公共祖先的定义为：“对于有根树 T 的两个节点 p、q，最近公共祖先表示为一个节点 x，满足 x 是 p、q 的祖先且 x 的深度尽可能大（一个节点也可以是它自己的祖先）。”
 */
func lowestCommonAncestor(_ root: TreeNode?, _ p: TreeNode?, _ q: TreeNode?) -> TreeNode? {
    func lowestAncestor(root:TreeNode?) -> TreeNode? {
        guard let root = root else {
            return root
        }
        if root.val == p!.val || root.val == q!.val {
            return root
        }
        
        let left = lowestAncestor(root: root.left)
        let right = lowestAncestor(root: root.right)
        if let left = left,let right = right {
            return root
        } else if let left = left {
            return left
        } else {
            return right
        }
    }
    return lowestAncestor(root: root)
}


//107. 二叉树的层序遍历 II
/**
 给你二叉树的根节点 root ，返回其节点值 自底向上的层序遍历 。 （即按从叶子节点所在层到根节点所在的层，逐层从左向右遍历）
 */
func levelOrderBottom(_ root: TreeNode?) -> [[Int]] {
    guard let root = root else {
        return []
    }
    var res = [[Int]](),queue = [root]
    while !queue.isEmpty {
        var temp = [TreeNode](),tRe = [Int]()
        for nod in queue {
            tRe.append(nod.val)
            if let left = nod.left {
                temp.append(left)
            }
            if let right = nod.right {
                temp.append(right)
            }
        }
        queue = temp
        res.append(tRe)
    }
    return res.reversed()
}

// 103. 二叉树的锯齿形层序遍历
/**
 给你二叉树的根节点 root ，返回其节点值的 锯齿形层序遍历 。（即先从左往右，再从右往左进行下一层遍历，以此类推，层与层之间交替进行）。
 */
func zigzagLevelOrder(_ root: TreeNode?) -> [[Int]] {
    guard let root = root else {
        return []
    }
    var queue = [root],res = [[root.val]]
    while !queue.isEmpty {
        var temp = [TreeNode](),ct = [Int]()
        let isF = res.count % 2 == 0
        for nod in queue.reversed() {
            if isF {
                if let left = nod.left {
                    ct.append(left.val)
                    temp.append(left)
                }
                
                if let right = nod.right {
                    ct.append(right.val)
                    temp.append(right)
                }
            } else {
                if let right = nod.right {
                    ct.append(right.val)
                    temp.append(right)
                }
                
                if let left = nod.left {
                    ct.append(left.val)
                    temp.append(left)
                }
            }
        }
        if !ct.isEmpty {
            res.append(ct)
        }
        
        queue = temp
    }
    return res
}


public class CNode {
     public var val: Int
     public var children: [CNode]
     public init(_ val: Int) {
         self.val = val
         self.children = []
     }
}

func levelOrder(_ root: CNode?) -> [[Int]] {
    var res = [[Int]]()
    guard let root = root else {
        return res
    }
    var queue = [root]
    while !queue.isEmpty {
        var temp = [CNode](),tr = [Int]()
        for node in queue {
            tr.append(node.val)
            temp.append(contentsOf: node.children)
        }
        if !tr.isEmpty {
            res.append(tr)
        }
        queue = temp
    }
    return res
}

// 313. 超级丑数
/**
 超级丑数 是一个正整数，并满足其所有质因数都出现在质数数组 primes 中。

 给你一个整数 n 和一个整数数组 primes ，返回第 n 个 超级丑数 。

 题目数据保证第 n 个 超级丑数 在 32-bit 带符号整数范围内。


 */
func nthSuperUglyNumber(_ n: Int, _ primes: [Int]) -> Int {
    let m = primes.count
    var numArr = Array(repeating: 0, count: m),res = Array(repeating: 0, count: n)
    res[0] = 1
    for i in 1..<n {
        var minN = Int.max,tempArr = Array(repeating: 0, count: m)
        res[i] = minN
        for j in 0..<m {
            tempArr[j] = res[numArr[j]] * primes[j]
            minN = min(minN,tempArr[j])
        }
        for j in 0..<m where tempArr[j] == minN {
            numArr[j] += 1
        }
    }
    return res[n-1]
}

// 2583. 二叉树中的第 K 大层和
/**
 给你一棵二叉树的根节点 root 和一个正整数 k 。

 树中的 层和 是指 同一层 上节点值的总和。

 返回树中第 k 大的层和（不一定不同）。如果树少于 k 层，则返回 -1 。

 注意，如果两个节点与根节点的距离相同，则认为它们在同一层。
 */
func kthLargestLevelSum(_ root: TreeNode?, _ k: Int) -> Int {
    
    func bindSearch(arr: [Int],target:Int) -> Int {
        var l = 0,r = arr.count
        while l < r {
            let mid = (l + r) >> 1
            if arr[mid] <= target {
                l = mid + 1
            } else {
                r = mid
            }
        }
        return l
    }
    guard let root = root else {
        return -1
    }
    var arr = [Int](),queue = [root]
    while !queue.isEmpty {
        var temp = [TreeNode](),res = 0
        for qN in queue {
            res += qN.val
            if let left = qN.left {
                temp.append(left)
            }
            if let right = qN.right {
                temp.append(right)
            }
        }
        let i = bindSearch(arr: arr, target: res)
        if i >= arr.count {
            arr.append(res)
        } else {
            arr.insert(res, at: i)
        }
        queue = temp
    }
    guard arr.count >= k else {
        return -1
    }
    return arr[arr.count-k]
}
