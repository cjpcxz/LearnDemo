//
//  day_three.swift
//  leetCode
//
//  Created by 陈晶泊 on 2022/4/10.
//

import Foundation
public class TreeNode {
    public var val: Int
    public var left: TreeNode?
    public var right: TreeNode?
    
    public init() { self.val = 0; self.left = nil; self.right = nil; }
    public init(_ val: Int) { self.val = val; self.left = nil; self.right = nil; }
    public init(_ val: Int, _ left: TreeNode?, _ right: TreeNode?) {
         self.val = val
         self.left = left
         self.right = right
    }
    
}

func maxDepth(_ root: TreeNode?) -> Int {
    guard root != nil else {
        return 0
    }
    let maxLeft = maxDepth(root?.left)
    let maxRight = maxDepth(root?.right)
    return max(maxLeft, maxRight) + 1
}

var preNode: TreeNode?
func isValidBST(_ root: TreeNode?) -> Bool {
    guard root != nil else {
        return true
    }
    if !isValidBST(root?.left) {
        return false
    }
    if let preValue = preNode?.val,let currentValue = root?.val,preValue >= currentValue {
        return false
    }
    preNode = root
    if !isValidBST(root?.right) {
        return false
    }
    return true
}

func isValidBST2(_ root: TreeNode?) -> Bool {
    guard root != nil else {
        return true
    }
    return isValidBST2(root, max: Int.max, min: Int.min)
}
///范围查询
func isValidBST2(_ root: TreeNode?,max:Int,min:Int) -> Bool {
    guard root != nil else {
        return true
    }
    guard let rootValue = root?.val,rootValue > min && rootValue < max else {
        return false
    }
    
    return isValidBST2(root?.left,max: rootValue,min: min) && isValidBST2(root?.right,max: max,min: rootValue)
}

func isSymmetric(_ root: TreeNode?) -> Bool {
    return isSymmetric(root?.left, root?.right)
}

func isSymmetric(_ left: TreeNode?,_ right: TreeNode?) -> Bool {
    guard left != nil || right != nil else {
        return true
    }
    guard let leftNode = left,let rightNode = right,leftNode.val == rightNode.val else {
        return false
    }
    return isSymmetric(left?.left, right?.right)&&isSymmetric(left?.right, right?.left)
}

func levelOrder(_ root: TreeNode?) -> [[Int]] {
    guard let rootNode = root else {
        return [[]]
    }
    var result: [[Int]] = []
    var queue = [rootNode]
    repeat {
        var tempQueue:[TreeNode] = []
        var currentResult:[Int] = []
        while !queue.isEmpty {
            let currentNode = queue[0]
            if let leftNode = currentNode.left {
                tempQueue.append(leftNode)
            }
            if let rightNode = currentNode.right {
                tempQueue.append(rightNode)
            }
            queue.remove(at: 0)
            currentResult.append(currentNode.val)
        }
        queue = tempQueue
        result.append(currentResult)
    } while !queue.isEmpty
    
    return result
}

func sortedArrayToBST(_ nums: [Int]) -> TreeNode? {
    guard nums.count > 0 else {
        return nil
    }
    return BSTThreeNode(nums, left: 0, right: nums.count-1)
}

func BSTThreeNode(_ nums: [Int],left: Int,right:Int) -> TreeNode?{
    guard left <= right else {
        return nil
    }
    let node = TreeNode()
    let middle = (right + left)/2
    node.val = nums[middle];
    node.left  = BSTThreeNode(nums,left: left, right: middle-1)
    node.right = BSTThreeNode(nums,left: middle+1, right: right)
    return node
}
//从根到叶的二进制数之和
func sumRootToLeaf(_ root: TreeNode?) -> Int {
    guard root != nil else {
        return 0
    }
    return sumRootToLeaf(root, sum: 0)
}

func sumRootToLeaf(_ root: TreeNode?,sum:Int) -> Int {
    guard let value = root?.val else {
        return sum
    }
    if root?.left != nil && root?.right != nil {
        return sumRootToLeaf(root?.right, sum: sum<<1 + value) + sumRootToLeaf(root?.left, sum:sum<<1 + value)
    } else if root?.right != nil {
        return sumRootToLeaf(root?.right, sum: sum<<1 + value)
    } else if root?.left != nil {
        return sumRootToLeaf(root?.left, sum: sum<<1 + value)
    } else {
        return sum<<1 + value
    }
}


func deleteNode(_ root: TreeNode?, _ key: Int) ->TreeNode? {
    return findDeleteNode(root, key)
}

func findDeleteNode(_ root: TreeNode?, _ key: Int) ->TreeNode? {
    guard let value = root?.val else {
        return nil
    }
    if value == key {
        guard let rightNode = root?.right else {
            let left = root?.left
            root?.left = nil
            return left
        }
        
        guard let leftNode = root?.left else {
            let right = root?.right
            root?.right = nil
            return right
        }
        guard rightNode.left != nil else {
            rightNode.left = leftNode
            root?.right = nil
            root?.left = nil
            return rightNode
        }
        var leftRightNode = root?.left
        while leftRightNode?.right != nil {
            leftRightNode = leftRightNode?.right
        }
        leftRightNode?.right = rightNode.left
        rightNode.left = leftNode
        return rightNode
    }
    root?.left = findDeleteNode(root?.left, key)
    root?.right = findDeleteNode(root?.right, key)
    return root
}

func findFrequentTreeSum(_ root: TreeNode?) -> [Int] {
    var map = [Int:Int]()
    findTreeSum(root, map: &map)
    var array = [Int]()
    var max = 0
    for key in map {
        if (key.value > max){
            array = []
            max = key.value
            array.append(key.key)
        } else if key.value == max {
            array.append(key.key)
        }
    }
    return array
}

@discardableResult
func findTreeSum(_ root: TreeNode?,map:inout [Int:Int])->Int {
    if root?.left == nil && root?.right==nil {
        let value = root!.val
        map[value] = (map[value] ?? 0) + 1
        return value
    }
    
    var rightValue = 0
    if let righ = root?.right {
        rightValue = findTreeSum(righ, map: &map)
    }
    
    var leftValue = 0
    if let left = root?.left {
        leftValue = findTreeSum(left, map: &map)
    }
    let value = root!.val + leftValue + rightValue
    map[value] = (map[value] ?? 0) + 1
    return value
}

//MARK: 找树左下角的值
func findBottomLeftValue(_ root: TreeNode?) -> Int {
    guard let curr  = root else {
        return 0
    }
    return findBottomLeftValue(curr).0
}

func findBottomLeftValue(_ root: TreeNode) -> (Int,Int){
    if root.left == nil,root.right == nil {
        return (root.val,1)
    }
    var leftValue = (0,0)
    if let left = root.left {
        leftValue = findBottomLeftValue(left)
    }
    
    var rightValue = (0,0)
    if let right = root.right {
        rightValue = findBottomLeftValue(right)
    }
    if leftValue.1  >= rightValue.1 {
        return (leftValue.0,leftValue.1 + 1)
    } else {
        return (rightValue.0,rightValue.1 + 1)
    }
    
    
}

class fourNode {
    class Node {
          public var val: Bool
          public var isLeaf: Bool
          public var topLeft: Node?
          public var topRight: Node?
          public var bottomLeft: Node?
          public var bottomRight: Node?
          public init(_ val: Bool, _ isLeaf: Bool) {
              self.val = val
              self.isLeaf = isLeaf
              self.topLeft = nil
              self.topRight = nil
              self.bottomLeft = nil
              self.bottomRight = nil
          }
      }

    func intersect(_ quadTree1: Node?, _ quadTree2: Node?) -> Node? {
        guard let tree1 = quadTree1,let tree2 = quadTree2 else {
            return quadTree1 == nil ? quadTree2:quadTree1
        }
        if !tree1.isLeaf && !tree2.isLeaf {
            //同时为false，再走下面
            let tleft = intersect(tree1.topLeft, tree2.topLeft)!
            let tright = intersect(tree1.topRight, tree2.topRight)!
            let bleft = intersect(tree1.bottomLeft, tree2.bottomLeft)!
            let bright = intersect(tree1.bottomRight, tree2.bottomRight)!
            if tleft.isLeaf && tright.isLeaf && bleft.isLeaf && bright.isLeaf,tright.val == tleft.val && bright.val == tleft.val && bleft.val == tleft.val{
                let node = Node(tleft.val, tleft.isLeaf)
                return node
            }
            let node = Node(false, false)
            node.bottomLeft = bleft
            node.bottomRight = bright
            node.topLeft = tleft
            node.topRight = tright
            return node
        } else {
            if tree1.isLeaf {
                return tree1.val ? tree1:tree2
            } else {
                return tree2.val ? tree2:tree1
            }
        }
    }
}

class CBTInserter {
    private let root:TreeNode?
    private var nodeArr = [TreeNode]()
    init(_ root: TreeNode?) {
        self.root = root
        var queue = [TreeNode]()
        if let node = root {
            queue.append(node)
            while !queue.isEmpty {
                let currNode = queue.removeFirst()
                var num = 0
                if let left = currNode.left{
                    queue.append(left)
                    num += 1
                }
                if let right = currNode.right {
                    queue.append(right)
                    num += 1
                }
                if num != 2 {
                    nodeArr.append(currNode)
                }
            }
        }
    }
    
    
    func insert(_ val: Int) -> Int {
        let frist = nodeArr.first!
        let node = TreeNode(val)
        nodeArr.append(node)
        if frist.left == nil {
            frist.left = node
        } else if frist.right == nil {
            frist.right = node
        }
        if frist.right != nil,frist.left != nil {
            nodeArr.removeFirst();
        }
        return frist.val
    }
    
    func get_root() -> TreeNode? {
        return root
    }
}

//中序遍历
func inorderTraversal(_ root: TreeNode?) -> [Int] {
    var arr = [Int]()
    inorder(root,arr: &arr)
    func inorder(_ root: TreeNode?,arr:inout [Int]){
        guard let node = root else {
            return
        }
        inorder(node.left,arr:&arr)
        arr.append(node.val)
        inorder(node.right,arr:&arr)
    }
    return arr
}


//验证是否相同树
func isSameTree(_ p: TreeNode?, _ q: TreeNode?) -> Bool {
    guard let p = p,let q = q,p.val == q.val else {
        return p == nil && q == nil
    }
    let leftSame = isSameTree(p.left, q.left)
    let rightSame = isSameTree(p.right, q.right)
    return leftSame && rightSame
}

func isBalanced(_ root: TreeNode?) -> Bool {
    return balanceTreeNum(root).1
}

func balanceTreeNum(_ root: TreeNode?)->(Int,Bool) {
    guard let node = root else {
        return (0,true)
    }
    let left = balanceTreeNum(node.left)
    let right = balanceTreeNum(node.right)
    let num = max(left.0, right.0) + 1
    if left.1,right.1 {
        return (num,labs(left.0-right.0) < 2)
    }
    return (num,false)
    
}

// 层数最深叶子节点的和
func deepestLeavesSum(_ root: TreeNode?) -> Int {
    guard let cur = root else {
        return 0
    }
    var topNodes = [cur]
    while !topNodes.isEmpty {
        var nextNodes = [TreeNode]()
        var deepestSum = 0
        for node in topNodes {
            deepestSum += node.val
            if let left = node.left {
                nextNodes.append(left)
            }
            
            if let right = node.right {
                nextNodes.append(right)
            }
        }
        if nextNodes.isEmpty {
           return deepestSum
        }
        topNodes = nextNodes
    }
    return cur.val
}


//二叉树的前序遍历
func preorderTraversal(_ root: TreeNode?) -> [Int] {
    var num = [Int]()
    preorderTraversal(root, &num)
    func preorderTraversal(_ root: TreeNode?,_ nums:inout [Int]){
        guard let root = root else {
            return
        }
        nums.append(root.val)
        preorderTraversal(root.left, &nums)
        preorderTraversal(root.right, &nums)
    }
    return num
}

//二叉树的后序遍历
func postorderTraversal(_ root: TreeNode?) -> [Int] {
    var num = [Int]()
    postorderTraversal(root, &num)
    func postorderTraversal(_ root: TreeNode?,_ nums:inout [Int]){
        guard let root = root else {
            return
        }
        postorderTraversal(root.left, &nums)
        postorderTraversal(root.right, &nums)
        nums.append(root.val)
    }
    return num
}

//最大二叉树

func constructMaximumBinaryTree2(_ nums: [Int]) -> TreeNode? {
    return constructMaximumBinaryTree2(nums, 0, nums.count-1)
}

func constructMaximumBinaryTree2(_ nums: [Int],_ left:Int,_ right:Int) ->TreeNode?{
    guard left < right else {
        if left == right {
            return TreeNode(nums[left])
        }
        return nil
    }
    var maxIndex = left
    for i in left...right {
        if nums[i] > nums[maxIndex] {
            maxIndex = i
        }
    }
    let node = TreeNode(nums[maxIndex])
    node.left = constructMaximumBinaryTree2(nums, left, maxIndex - 1)
    node.right = constructMaximumBinaryTree2(nums, maxIndex + 1, right)
    return node
}

func constructMaximumBinaryTree(_ nums: [Int]) -> TreeNode? {
    var queue = Array<TreeNode?>(repeating: nil, count: nums.count)
    var last = -1
    for i in nums{
        let temp = TreeNode(i)
        constructMaximumBinaryTree(&queue,&last, temp)
    }
    return queue[0]
}

func constructMaximumBinaryTree(_ nodes:inout [TreeNode?],_ index:inout Int,_ curNode:TreeNode){
    guard index >= 0 else {
        index += 1
        nodes[index] = curNode
        return
    }
    
    while index >= 0,nodes[index]!.val < curNode.val {
        curNode.left = nodes[index]
        index -= 1
    }
    if index >= 0,nodes[index]!.val > curNode.val {
        nodes[index]?.right = curNode
        index += 1
        nodes[index] = curNode
    } else {
        index += 1
        nodes[index] = curNode
    }
    
}

// 二叉树的最小深度
func minDepth(_ root: TreeNode?) -> Int {
    if root?.left == nil,root?.right == nil {
        return 0
    }
    var minX = Int.max
    if let left = root?.left {
        minX = min(minDepth(left) + 1, minX)
    }
    
    if let right = root?.right {
        minX = min(minDepth(right) + 1, minX)
    }
    return minX
}

//路径总和
func hasPathSum(_ root: TreeNode?, _ targetSum: Int) -> Bool {
    guard let root = root else {
        return false
    }

    if root.left == nil,root.right == nil {
        return root.val == targetSum
    }
    var result = false
    if let left = root.left {
        result = hasPathSum(left, targetSum - root.val)
    }
    
    if !result,let right = root.right {
        result = hasPathSum(right, targetSum - root.val)
    }
    return result
}


func printTree(_ root: TreeNode?) -> [[String]] {
    guard let root = root else {
        return [[]]
    }

    let m = treeHeight(root)
    let n = (1 << m) - 1
    var result = Array(repeating: Array(repeating: " ", count: n), count: m)
    
    dfs1(&result, root, 0, (n-1)/2, m-1)
    
    return result
}

func dfs1(_ dfs:inout [[String]],_ root:TreeNode,_ start:Int,_ endt:Int,_ height:Int){
    dfs[start][endt] = "\(root.val)"
    if let left = root.left {
        dfs1(&dfs, left, start + 1, endt - (1 << (height - start - 1)), height)
    }
    
    if let right = root.right {
        dfs1(&dfs, right, start + 1, endt + (1 << (height - start - 1)), height)
    }
}

func treeHeight(_ root: TreeNode?)->Int {
    guard let root = root else {
        return 0
    }
    var height = 1
    if let left = root.left {
        height = max(treeHeight(left)+1,height)
    }
    if let right = root.right {
        height = max(treeHeight(right)+1,height)
    }
    return height
}

//662. 二叉树最大宽度
var map = [Int:Int]()
var ans = 0
func widthOfBinaryTree(_ root: TreeNode?) -> Int {
    dfs(root, 1, 0)
    return ans
}

func dfs(_ node:TreeNode?,_ index:Int,_ depth:Int) {
    guard let node = node else {
        return
    }
    if map[depth] == nil {
        map[depth] = index
    }
    ans = max(ans,index - (map[depth] ?? 0) + 1)
    //溢出算法
    dfs(node.left, index &* 2 , depth + 1)
    dfs(node.right, index &* 2 &+ 1, depth + 1)
}

//998. 最大二叉树 II
func insertIntoMaxTree(_ root: TreeNode?, _ val: Int) -> TreeNode? {
    guard let root = root else {
        return TreeNode(val)
    }
    
    if root.val < val {
        let nodel = TreeNode(val)
        nodel.left = root
        return nodel
    } else {
        let right = insertIntoMaxTree(root.right, val)
        root.right = right
        return root
    }
}
// 最长同值路径
var maxPath = 0
func longestUnivaluePath(_ root: TreeNode?) -> Int {
    dfsLong(root)
    return maxPath
}

@discardableResult
func dfsLong(_ root: TreeNode?)->Int{
    guard let root = root else {
        return 0
    }
    var ans = 0,cur = 0,l = dfsLong(root.left),r = dfsLong(root.right)
    if let left = root.left,left.val == root.val {
        ans = l + 1
        cur += l + 1
    }
    if let right = root.right, right.val == root.val{
        ans = max(ans,r+1)
        cur += r + 1
    }
    maxPath = max(maxPath,cur)
    return ans
}

func findLongestChain(_ pairs: [[Int]]) -> Int {
    var sort = pairs.sorted { arr1, arr2 in
        if arr1[1] < arr2[1] {
            return true
        } else if arr1[1] == arr2[1] {
            return arr1[0] < arr2[0]
        } else {
            return false
        }
    }
    var num = 1
    var last = sort[0][1]
    for arr in sort {
        if arr[0] > last {
            last = arr[1]
            num += 1
        }
    }
    
    return num
    
}

//652. 寻找重复的子树
var duplicateMap = [String:Int]()
var duplicateList = [TreeNode]()
func findDuplicateSubtrees(_ root: TreeNode?) -> [TreeNode?] {
    @discardableResult
    func dfs(_ root:TreeNode?)->String {
        guard let root = root else {
            return " "
        }
        let key = "\(root.val)_\(dfs(root.left))\(dfs(root.right))"
        duplicateMap[key] = (duplicateMap[key] ?? 0) + 1
        if duplicateMap[key]! == 2 {
            duplicateList.append(root)
        }
        return key
    }
    dfs(root)
    return duplicateList
}

//669. 修剪二叉搜索树
func trimBST(_ root: TreeNode?, _ low: Int, _ high: Int) -> TreeNode? {
    guard let root = root else {
        return root
    }
    if root.val < low {
        //左节点全部去掉,根节点替换为右节点
        if let right = root.right {
            root.val = right.val
            root.left = right.left
            root.right = right.right
            return trimBST(root, low, high)
        }
        return nil
    } else if  root.val > high {
        //右节点全部去掉,根节点替换为左节点
        if let left = root.left {
            root.val = left.val
            root.left = left.left
            root.right = left.right
            return trimBST(root, low, high)
        }
        return nil
    }
    //当前层在范围之内
    root.left = trimBST(root.left, low, high)
    root.right = trimBST(root.right, low, high)
    return root
}

//257. 二叉树的所有路径
func binaryTreePaths(_ root: TreeNode?) -> [String] {
    guard let root = root else {
        return []
    }
    var arr = [String]()
    binaryTreePaths(root, [], &arr)
    return arr
}

func binaryTreePaths(_ root: TreeNode,_ vals:[String],_ arr:inout [String]) {
    let newVal = vals + [String(root.val)]
    if let left = root.left,let right = root.right {
        binaryTreePaths(left, newVal, &arr)
        binaryTreePaths(right, newVal, &arr)
    } else if let left = root.left {
        binaryTreePaths(left, newVal, &arr)
    } else if let right = root.right {
        binaryTreePaths(right, newVal, &arr)
    } else {
        arr.append(newVal.joined(separator: "->"))
    }
}

//226. 翻转二叉树
func invertTree(_ root: TreeNode?) -> TreeNode? {
    guard let root = root else {
        return nil
    }
    let right = root.right
    root.right = root.left
    root.left = right
    invertTree(root.left)
    invertTree(root.right)
    return root
}

//面试题 17.09. 第 k 个数
func getKthMagicNumber(_ k: Int) -> Int {
    class Heap {
       private(set)  var array = [Int]()
        
        private func sawp(nums: inout [Int],i: Int,j: Int) {
            if i != j {
                nums[i] ^= nums[j]
                nums[j] ^= nums[i]
                nums[i] ^= nums[j]
            }
        }
        
        
        private func heapFind(_ nums: inout [Int],_ begin:Int,_ headSize:Int) {
            var index = begin
            var left = 2 * index + 1
            while left < headSize {
                let minIndex = (left + 1) < headSize && (nums[left + 1] < nums[left]) ? left + 1:left
                let swapIndex = nums[index] > nums[minIndex] ? minIndex:index
                guard index != minIndex else {
                    return
                }
                sawp(nums: &nums, i: swapIndex, j: index)
                index = minIndex
                left = 2 * index + 1
            }
            
        }
        
        private func heapInsert(nums: inout [Int],begin: Int){
            var index = begin
            while nums[index] < nums[(index - 1) / 2] {
                sawp(nums: &nums, i: index, j: (index - 1) / 2)
                index = (index - 1) / 2
            }
        }
        
        func add(_ val:Int) {
            array.append(val)
            heapInsert(nums: &array, begin: array.count - 1)
        }
        
        func pop()->Int {
            guard !array.isEmpty else {
                return 0
            }
            sawp(nums: &array, i: 0, j: array.count - 1)
            let num = array.removeLast()
            heapFind(&array, 0, array.count)
            return num
        }
    }
    let heap = Heap()
    heap.add(1)
    var set = Set<Int>()
    let nums = [3,5,7]
    var i = k
    while i > 1 {
        let popNum = heap.pop()
        for num in nums where  i > 1 && !set.contains(popNum * num){
            heap.add(popNum * num)
            set.insert(popNum * num)
        }
        i -= 1
    }
    
    return heap.pop()
}
//700. 二叉搜索树中的搜索
func searchBST(_ root: TreeNode?, _ val: Int) -> TreeNode? {
    guard let root = root else {
        return root
    }
    if val > root.val {
        return searchBST(root.right, val)
    } else if val < root.val {
        return searchBST(root.left, val)
    } else {
        return root
    }
}

//617. 合并二叉树
func mergeTrees(_ root1: TreeNode?, _ root2: TreeNode?) -> TreeNode? {
    guard let r1 = root1,let r2 = root2 else {
        return root1 == nil ? root2:root1
    }
    r1.val = r1.val + r2.val
    r1.left = mergeTrees(r1.left, r2.left)
    r1.right = mergeTrees(r1.right, r2.right)
    return r1
}

//637. 二叉树的层平均值
func averageOfLevels(_ root: TreeNode?) -> [Double] {
    guard let root = root else {
        return []
    }
    var nodes = [root],result = [Double]()
    while !nodes.isEmpty {
        var tempNod = [TreeNode]()
        let count = nodes.count
        var sum = 0
        while let frist = nodes.first {
            nodes.removeFirst()
            if let left = frist.left {
                tempNod.append(left)
            }
            if let right = frist.right {
                tempNod.append(right)
            }
            sum += frist.val
        }
        result.append(Double(sum)/Double(count))
        nodes = tempNod
    }
    return result
}

//671. 二叉树中第二小的节点
func findSecondMinimumValue(_ root: TreeNode?) -> Int {
    func findSecondMinimumValue(_ root: TreeNode,_ key:Int) -> Int {
        guard let left = root.left,let right = root.right else {
            return root.val
        }
        var value = key
        if left.val == key,right.val == key {
            let second1 = findSecondMinimumValue(left, key)
            let second2 = findSecondMinimumValue(right, key)
            if second1 != key,second2 != key {
                value = min(second2,second1)
            } else {
                value = max(second1,second2)
            }
        } else if left.val == key {
            value = right.val
            let second = findSecondMinimumValue(left, key)
            if key != second {
                value = min(second,value)
            }
        } else if right.val == key {
            value = left.val
            let second = findSecondMinimumValue(right, key)
            if key != second {
                value = min(second,value)
            }
        }
        return value
    }
    guard let root = root else {
        return -1
    }
    let second = findSecondMinimumValue(root, root.val)
    return second == root.val ? -1:second
}

//404. 左叶子之和
func sumOfLeftLeaves(_ root: TreeNode?) -> Int {
    func sumOfLeftLeaves(_ root: TreeNode,_ isLeft:Bool) -> Int {
        if let left = root.left,let right = root.right {
            return sumOfLeftLeaves(left, true) + sumOfLeftLeaves(right, false)
        } else if let left = root.left {
            return sumOfLeftLeaves(left, true)
        } else if let right = root.right {
            return sumOfLeftLeaves(right, false)
        } else {
            return isLeft ? root.val:0
        }
    }
    guard let root = root else {
        return 0
    }
    return sumOfLeftLeaves(root, false)
}

//938. 二叉搜索树的范围和
func rangeSumBST(_ root: TreeNode?, _ low: Int, _ high: Int) -> Int {
    guard let root = root else {
        return 0
    }
    var result = 0
    if case low...high = root.val {
        result = root.val
    }
    if let left = root.left {
        result += rangeSumBST(left, low, high)
    }
    
    if let right = root.right {
        result += rangeSumBST(right, low, high)
    }
    return result
}

func diameterOfBinaryTree(_ root: TreeNode?) -> Int {
    var res = 0
    func diameTree(root:TreeNode?)->Int {
        guard let root = root else {
            return 0
        }
        let left = diameTree(root: root.left)
        let right = diameTree(root: root.right)
        res = max(res,left + right)
        return max(left,right) + 1
    }
    diameTree(root: root)
    return res
}


func isSubtree(_ root: TreeNode?, _ subRoot: TreeNode?) -> Bool {
    func isSametree(root:TreeNode?,_ subRoot:TreeNode?) -> Bool {
        if root == nil,subRoot == nil {
            return true
        }
        guard root?.val == subRoot?.val else {
            return false
        }
        return isSametree(root: root?.left, subRoot?.left) && isSametree(root: root?.right, subRoot?.right)
    }
    guard let subRoot = subRoot else {
        return true
    }
    guard let root = root else {
        return false
    }
    if root.val == subRoot.val,isSametree(root: root, subRoot){
        return true
    } else {
        return isSubtree(root.left, subRoot) || isSubtree(root.right, subRoot)
    }
}


//1145. 二叉树着色游戏
func btreeGameWinningMove(_ root: TreeNode?, _ n: Int, _ x: Int) -> Bool {
    func findNode(root:TreeNode?)->TreeNode? {
        guard let root = root else {
            return nil
        }
        if root.val == x {
            return root
        }
        if let node = findNode(root: root.left){
            return node
        }
        if let node = findNode(root: root.right){
            return node
        }
        return nil
    }
    
    func findNodeNum(root:TreeNode?)->(Int,Int) {
        guard let root = root else {
            return (0,0)
        }
        let left = findNodeNum(root: root.left).0
        let right = findNodeNum(root: root.right).0
        return (left+right+1,left)
    }
    guard let node = findNode(root: root) else {
        return true
    }
    
    let son = findNodeNum(root: node)
    return (n > 2 * son.0) || (2 * son.1 > n) || (2 * (son.0-son.1-1) > n)
}

//653. 两数之和 IV - 输入二叉搜索树
func findTarget(_ root: TreeNode?, _ k: Int) -> Bool {
    func preArr(_ root: TreeNode?,arr:inout [Int]) {
        guard let root = root else {
            return
        }
        preArr(root.left, arr: &arr)
        preArr(root.right, arr: &arr)
        arr.append(root.val)
    }
    var arr = [Int]()
    preArr(root, arr: &arr)
    print(arr)
    var l = 0,r = arr.count-1
    while l > r {
        if arr[l] + arr[r] < k {
            l += 1
        } else if arr[l] + arr[r] > k {
            r -= 1
        } else {
            return true
        }
    }
    return false
}


func evaluateTree(_ root: TreeNode?) -> Bool {
    func evalute(root:TreeNode) -> Bool {
        switch root.val {
        case 0:return false
        case 1:return true
        case 2:return evalute(root: root.left!) || evalute(root: root.right!)
        default:return evalute(root: root.left!) && evalute(root: root.right!)
        }
    }
    guard let root = root else {
        return false
    }
    return evalute(root: root)
}

//1026. 节点与其祖先之间的最大差值
func maxAncestorDiff(_ root: TreeNode?) -> Int {
    var res = 0
    func findMaxDiff(minN:Int,maxN:Int,root:TreeNode) {
        
        if let left = root.left {
            res = max(abs(left.val - minN),abs(left.val - maxN),res)
            findMaxDiff(minN: min(minN,left.val), maxN: max(maxN,left.val), root: left)
        }
        
        if let rignt = root.right {
            res = max(abs(rignt.val - minN),abs(rignt.val - maxN),res)
            findMaxDiff(minN: min(minN,rignt.val), maxN: max(maxN,rignt.val), root: rignt)
        }
    }
    
    guard let root = root else {
        return 0
    }
    findMaxDiff(minN: root.val, maxN: root.val, root: root)
    
    return res
}

//1080. 根到叶路径上的不足节点
/**
 给你二叉树的根节点 root 和一个整数 limit ，请你同时删除树中所有 不足节点 ，并返回最终二叉树的根节点。

 假如通过节点 node 的每种可能的 “根-叶” 路径上值的总和全都小于给定的 limit，则该节点被称之为 不足节点 ，需要被删除。
 */
func sufficientSubset(_ root: TreeNode?, _ limit: Int) -> TreeNode? {
    func sufficientSubset(_ root: TreeNode,sum:Int) -> Bool {
            if root.right == nil,root.left == nil {
                //叶子节点
                return root.val + sum >= limit
            }
            
            if let left = root.left {
                let temp = sufficientSubset(left, sum: root.val + sum)
                if !temp {
                    root.left = nil
                }
            }
            if let right = root.right {
                let temp = sufficientSubset(right, sum: root.val + sum)
                if !temp {
                    root.right = nil
                }
            }
            
            if root.right == nil,root.left == nil {
                //去除了两个节点
                return false
            }
            return true
        }
        
        return sufficientSubset(root!,sum: 0) ? root : nil
}

//1110. 删点成林

func delNodes(_ root: TreeNode?, _ to_delete: [Int]) -> [TreeNode?] {
    let hasSet = Set<Int>(to_delete)
    var res = [TreeNode]()
    func delNodes(_ root:TreeNode) -> Bool {
        if let left = root.left {
            let needD = delNodes(left)
            if needD {
                root.left = nil
            }
        }
        if let right = root.right {
            let needD = delNodes(right)
            if needD {
                root.right = nil
            }
        }
        if hasSet.contains(root.val) {
            //当前节点不能要
            if let left = root.left {
                res.append(left)
            }
            if let right = root.right {
                res.append(right)
            }
            return true
        }
        return false
        
    }
    if let root = root,!delNodes(root) {
        res.append(root)
    }
    return res
}


//1483. 树节点的第 K 个祖先
class TreeAncestor {
    let log = 16
    let dp:[[Int]]
    init(_ n: Int, _ parent: [Int]) {
        var ans = Array(repeating: Array(repeating: -1, count: log), count: n)
        for i in 0..<n {
            ans[i][0] = parent[i]
        }
        for j in 1..<log {
            for i in 0..<n where ans[i][j-1] != -1{
                ans[i][j] = ans[ans[i][j-1]][j-1]
            }
        }
        dp = ans
    }
    
    func getKthAncestor(_ node: Int, _ k: Int) -> Int {
        var node = node
        for j in 0..<log where k >> j & 1 != 0{
            node = dp[node][j]
            if node == -1 {
                return -1
            }
        }
        return node
    }
}


//979. 在二叉树中分配硬币

//func distributeCoins(_ root: TreeNode?) -> Int {
//    var res = 0
//    func distributeCoins1(_ root: TreeNode) -> (Int,Int,Int) {
//        var sum = (root.val,1)
//        if let right = root.right {
//            let temp = distributeCoins1(right)
//            if temp.0 < sum.0 {
//                
//            }
//        }
//        
//        if let left = root.left {
//            let temp = distributeCoins1(left)
//        }
//        return ()
//        
//    }
//    return res
//}

//1448. 统计二叉树中好节点的数目
//「好节点」X 定义为：从根到该节点 X 所经过的节点中，没有任何节点的值大于 X 的值。
func goodNodes(_ root: TreeNode?) -> Int {
    var res = 0
    func goodNum(root: TreeNode,maxNum:Int) {
        if root.val >= maxNum {
            res += 1
        }
        let maxN = max(maxNum,root.val)
        if let left = root.left {
            goodNum(root: left, maxNum: maxN)
        }
        
        if let right = root.right {
            goodNum(root: right, maxNum: maxN)
        }
    }
    
    goodNum(root: root!, maxNum: Int.min)
    return res
}

class Codec {
    // Encodes a tree to a single string.
    func serialize(_ root: TreeNode?) -> String {
        //前序
        guard let root = root else { return "" }
        return "\(root.val)_" + serialize(root.left) + serialize(root.right)
    }
    
    // Decodes your encoded data to tree.
    func deserialize(_ data: String) -> TreeNode? {
        let nodeArr = data.split(separator: "_").compactMap { Int($0) }
        return buildTreeNode(nodeArr: nodeArr, l: 0, r: nodeArr.count)
    }
    
    func buildTreeNode(nodeArr:[Int],l:Int,r:Int) -> TreeNode? {
        guard l < r else { return nil }
        let root = TreeNode(nodeArr[l])
        for i in (l+1)..<r where nodeArr[i] > nodeArr[l] {
            root.left = buildTreeNode(nodeArr: nodeArr, l: l+1, r: i)
            root.right = buildTreeNode(nodeArr: nodeArr, l: i, r: r)
            return root
        }
        root.left = buildTreeNode(nodeArr: nodeArr, l: l+1, r: r)
        return root
    }
}

//1123. 最深叶节点的最近公共祖
func lcaDeepestLeaves(_ root: TreeNode?) -> TreeNode? {
    func deepLeave(root:TreeNode,depth:Int) -> (TreeNode,Int) {
        var res = (root,depth)
        if let left = root.left {
            res = deepLeave(root: left, depth: depth + 1)
        }
        
        if let right = root.right {
           let temp = deepLeave(root: right, depth: depth + 1)
            if temp.1 == res.1 {
                //相同，取父节点
                res = (root,temp.1)
            } else if temp.1 > res.1 {
                res = temp
            }
        }
        return res
    }
    guard let root = root else {
        return nil
    }
    return deepLeave(root: root, depth: 0).0
}

//95. 不同的二叉搜索树 II
// l1 * n + r1 = l2 * n + r2

func generateTrees(_ n: Int) -> [TreeNode?] {
    
    func generateTrees(l:Int,r:Int) -> [TreeNode?] {
        if let res = map[l * n + r] {
            return res
        }
        guard l < r else {
            return [l == r ? TreeNode(l) : nil]
        }
        var res = [TreeNode?]()
        for i in l...r {
            let leftNodes = generateTrees(l: l, r: i-1)
            let rightNodes = generateTrees(l: i+1, r: r)
            for lN in leftNodes {
                for rN in rightNodes {
                    res.append(TreeNode(i,lN,rN))
                }
            }
        }
        map[l * n + r] = res
        return res
    }
    var map = [Int:[TreeNode?]]()
    return generateTrees(l: 1, r: n)
}

//337. 打家劫舍 III
func rob(_ root: TreeNode?) -> Int {
    var map = [String:Int]()
    func rob(root: TreeNode?,canSelect:Bool,index:Int) -> Int {
        let key = "\(index)_\(canSelect)"
        if let resN = map[key] {
            return resN
        }
        guard let root = root else {
            return 0
        }
        var res = canSelect ? root.val:0
        if canSelect {
            res = max(res,rob(root: root.left, canSelect: false,index: 2 * index + 1) + root.val + rob(root: root.right, canSelect: false,index: 2 * index + 2))
        }
        
        res = max(res,rob(root: root.left, canSelect: true,index: 2 * index + 1) + rob(root: root.right, canSelect: true,index: 2 * index + 2))
        map[key] = res
        return res
    }
    return rob(root: root, canSelect: true, index: 0)
}

// 1038. 从二叉搜索树到更大和树
func bstToGst(_ root: TreeNode?) -> TreeNode? {
    func bstToGst(_ root: TreeNode,lastNum:Int) -> Int {
        var res = root.val,lastNum = lastNum
        if let right = root.right {
            res += bstToGst(right,lastNum: lastNum)
        }
        lastNum = lastNum + res
        if let left = root.left {
            res += bstToGst(left,lastNum: lastNum)
        }
        root.val = lastNum
        return res
    }
    let _ = bstToGst(root!,lastNum: 0)
    return root
}



//2415. 反转二叉树的奇数层,完美树，每一层都是满节点
func reverseOddLevels(_ root: TreeNode?) -> TreeNode? {
    guard let root = root else { return root}
    var trees = [root],index = 0,temp = [TreeNode]()
    while !trees.isEmpty {
        defer {
            trees = temp
        }
        temp = []
        for tN in trees {
            if let left = tN.left {
                temp.append(left)
            }
            if let right = tN.right {
                temp.append(right)
            }
        }
        index += 1
        if index % 2 != 0 {
            var l = 0,r = temp.count-1
            while l < r {
                let cur = temp[l].val
                temp[l].val = temp[r].val
                temp[r].val = cur
                l += 1
                r -= 1
            }
        }
    }
    return root
}

// 310. 最小高度树
func findMinHeightTrees(_ n: Int, _ edges: [[Int]]) -> [Int] {
    var edgeArr = Array(repeating: [Int](), count: n)
    for edge in edges {
        edgeArr[edge[0]] += [edge[1]]
        edgeArr[edge[1]] += [edge[0]]
    }
    func findDeapTree(cur:Int,last:Int) -> [Int] {
        var temp = [Int]()
        for edge in edgeArr[cur] where edge != last {
            let tArr = findDeapTree(cur: edge, last: cur)
            if tArr.count > temp.count {
                temp = tArr
            }
        }
        return [cur] + temp
    }
    
    let bNode = findDeapTree(cur: 0, last: -1)
    let eNode = findDeapTree(cur: bNode.last!, last: -1)
    let m = eNode.count
    guard m % 2 == 0 else {
        return [eNode[m/2]]
    }
    
     return [eNode[m/2],eNode[m/2 - 1]]
}

// 590. N 叉树的后序遍历
/**
 给定一个 n 叉树的根节点 root ，返回 其节点值的 后序遍历 。

 n 叉树 在输入中按层序遍历进行序列化表示，每组子节点由空值 null 分隔（请参见示例）
 */
func postorder(_ root: Node?) -> [Int] {
    guard let root = root else {
        return []
    }
    var res = [Int]()
    for cN in root.children {
        res += postorder(cN)
    }
    return res + [root.val]
}

// 105. 从前序与中序遍历序列构造二叉树
/**
 给定两个整数数组 preorder 和 inorder ，其中 preorder 是二叉树的先序遍历， inorder 是同一棵树的中序遍历，请构造二叉树并返回其根节点。
 */
func buildTree(_ preorder: [Int], _ inorder: [Int]) -> TreeNode? {
    guard preorder.count > 0, inorder.count > 0 else {
        return nil
    }
    let l = inorder.firstIndex { $0 == preorder.first }!
    let root = TreeNode(preorder[0])
    if l > 0 {
        root.left = buildTree(Array(preorder[1...l]), Array(inorder[0..<l]))
    }
    
    if l + 1 < preorder.count{
        root.right = buildTree(Array(preorder[(l+1)..<preorder.count]), Array(inorder[(l+1)..<inorder.count]))
    }
    return root
}


// 106. 从中序与后序遍历序列构造二叉树
/**
 给定两个整数数组 inorder 和 postorder ，其中 inorder 是二叉树的中序遍历， postorder 是同一棵树的后序遍历，请你构造并返回这颗 二叉树 。
 [9,3,15,20,7]
 [9,15,7,20,3]
 */
func buildTree1(_ inorder: [Int], _ postorder: [Int]) -> TreeNode? {
    guard postorder.count > 0, inorder.count > 0 else {
        return nil
    }
    
    let l = inorder.firstIndex { $0 == postorder.last }!
    let root = TreeNode(postorder.last!)
    if l > 0 {
        root.left = buildTree1(Array(inorder[0..<l]), Array(postorder[0..<l]))
    }
    
    if l + 1 < inorder.count {
        root.right = buildTree1(Array(inorder[(l+1)..<inorder.count]), Array(postorder[l..<(postorder.count - 1)]))
    }
    
    return root
}


// 889. 根据前序和后序遍历构造二叉树
/**
 给定两个整数数组，preorder 和 postorder ，其中 preorder 是一个具有 无重复 值的二叉树的前序遍历，postorder 是同一棵树的后序遍历，重构并返回二叉树。

 如果存在多个答案，您可以返回其中 任何 一个。
 
 preorder = [1  ,2,4,5,3,6,7], postorder = [4,5,2,6,7,3 ,1]
 输出：[1,2,3,4,5,6,7]
 */
func constructFromPrePost(_ preorder: [Int], _ postorder: [Int]) -> TreeNode? {
    guard postorder.count > 1, preorder.count > 1 else {
        return preorder.count == 0 ? nil:TreeNode(preorder[0])
    }
    var l = postorder.firstIndex { $0 == preorder[1] }!
    let root = TreeNode(preorder[0])
    if l >= 0 {
        root.left = constructFromPrePost(Array(preorder[1...(1 + l)]), Array(postorder[0...l]))
    }
    
    if l < postorder.count - 1 {
        root.right = constructFromPrePost(Array(preorder[(2+l)..<preorder.count]), Array(postorder[(l+1)..<(postorder.count - 1)]))
    }
    return root
}

//2476. 二叉搜索树最近节点查询
/**
 给你一个 二叉搜索树 的根节点 root ，和一个由正整数组成、长度为 n 的数组 queries 。

 请你找出一个长度为 n 的 二维 答案数组 answer ，其中 answer[i] = [mini, maxi] ：

 mini 是树中小于等于 queries[i] 的 最大值 。如果不存在这样的值，则使用 -1 代替。
 maxi 是树中大于等于 queries[i] 的 最小值 。如果不存在这样的值，则使用 -1 代替。
 返回数组 answer 。
 */
func closestNodes(_ root: TreeNode?, _ queries: [Int]) -> [[Int]] {
    func preForeach(root:TreeNode) -> [Int] {
        var res = [root.val]
        if let left = root.left {
            res = preForeach(root: left) + res
        }
        if let right = root.right {
            res = res + preForeach(root: right)
        }
        return res
    }
    func binarySearch(arr:[Int],target:Int) -> [Int] {
        var l = 0,r = arr.count
        while l < r {
            let mid = (r + l) >> 1
            if arr[mid] < target {
                l = mid + 1
            } else {
                r = mid
            }
        }
        if l < arr.count,arr[l] == target {
            return [target,target]
        } else if l == arr.count {
            return [arr[l-1],-1]
        } else if l == 0 {
            return [-1,arr[l]]
        } else {
            return [arr[l-1],arr[l]]
        }
    }
    guard let root else {
        return Array(repeating: [-1,-1], count: queries.count)
    }
    let arr = preForeach(root: root)
    return queries.map { binarySearch(arr: arr, target: $0) }
}
