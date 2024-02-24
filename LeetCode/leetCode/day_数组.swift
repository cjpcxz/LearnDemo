//
//  day_数组.swift
//  leetCode
//
//  Created by 陈晶泊 on 2022/5/26.
//

import Foundation
func subarraySum(_ nums: [Int], _ k: Int) -> Int {
    guard nums.count > 0 else {
        return 0
    }
    var sums = 0,times = 0
    var map:[Int:Int] = [0:1]
    for i in nums {
        sums += i
        let key = sums - k
        //遍历之前的表是否有
        if let keyValue = map[key] {
            times += keyValue
        }
        //打表,当前结果加入
        if let value = map[sums] {
            map[sums] = value + 1
        } else {
            map[sums] = 1
        }
    }
    return times
}
//杨辉三角
func generate(_ numRows: Int) -> [[Int]] {
    guard numRows > 0 else {
        return [[]]
    }
    guard numRows > 1 else {
        return [[1]]
    }
    var generArray = [[1],[1,1]]
    var lastArray = [1,1]
    var i = 2
    while i < numRows {
        var temp = [1]
        var left = lastArray[0]
        for j in 1..<lastArray.count {
            temp.append(lastArray[j] + left)
            left = lastArray[j]
        }
        temp.append(1)
        generArray.append(temp)
        lastArray = temp
        i += 1
    }
    return generArray
}
//有效的括号，只包含'('，')'，'{'，'}'，'['，']'
func isValid(_ s: String) -> Bool {
    var tempArr:[Character] = []
    for i in s {
        switch i {
        case "(":
            tempArr.append(")")
            break
        case "{":
            tempArr.append("}")
            break
        case "[":
            tempArr.append("]")
            break
        default:
            if let last = tempArr.popLast() {
                if last != i {
                    return false
                }
            } else {
                return false
            }
            break
        }
    }
    return tempArr.isEmpty
}
func numUniqueEmails(_ emails: [String]) -> Int {
    var set = [Substring]()
    for str in emails {
        let array = str.split(separator: "@")
        guard array.count == 2 else {
            return 0
        }
        var address = array[0]
        if let rang = address.range(of: "+") {
            address =  address[address.startIndex..<rang.lowerBound]
        }
        address = address.replacingOccurrences(of: ".", with: "") + "@" + array[1]
        if !set.contains(address) {
            set.append(address)
        }
       
    }
    return set.count
}

//复写零
func duplicateZeros(_ arr: inout [Int]) {
    var i = 0
    let count = arr.count
    var j = count-1
    var z = count - 1
    while i < j {
        if arr[i] == 0{
            j -= 1
        }
        i += 1
    }
    if i == j,arr[i]==0 {
        arr[z] = arr[j]
        j -= 1
        z -= 1
    }
    
    var change = z - j
    while change > 0,z >= 0,j>=0 {
        if arr[j] == 0,z-1>0 {
            arr[z] = arr[j]
            arr[z-1] = arr[j]
            change -= 1
            z -= 2
        } else {
            arr[z] = arr[j]
            z -= 1
        }
        j -= 1
    }
}

class RangeModule {
    class Node {
        var left:Int
        var right:Int
        var isCover = false
        var lazy = 0
        var leftChild:Node?,rightChild:Node?
        init(_ left:Int,_ right:Int){
            self.left = left
            self.right = right
        }
    }
    
    var root:Node
    
    init() {
        self.root = Node(1, 1000000000)
    }
    
    func update(_ root:Node, _ left: Int, _ right: Int,_ value:Int){
        if root.left > right || root.right < left {
            return
        }
        if root.left >= left && root.right <= right {
            root.lazy = value
            root.isCover = value != -1
        } else {
            lazyCreat(root)
            pushDownLazy(root)
            update(root.leftChild!, left, right, value)
            update(root.rightChild!, left, right, value)
            pushUP(root)
        }
    }
    
    func query(_ root:Node, _ left: Int, _ right: Int)->Bool{
        if left <= root.left && right >= root.right {
            return root.isCover
        }
        lazyCreat(root)
        pushDownLazy(root)
        let mid = root.leftChild!.right
        if right <= mid {
            return query(root.leftChild!, left, right)
        } else if left > mid {
            return query(root.rightChild!, left, right)
        } else {
            return query(root.leftChild!, left, mid) && query(root.rightChild!, mid + 1, right)
        }
    }
    
    func lazyCreat(_ root:Node){
        let mid = (root.right - root.left) >> 1 + root.left
        if root.leftChild == nil {
            root.leftChild = Node(root.left, mid)
        }
        
        if root.rightChild == nil {
            root.rightChild = Node(mid + 1, root.right)
        }
    }
    
    func pushDownLazy(_ root:Node) {
        if root.lazy == 0 {
            return
        }
        
        let value = root.lazy
        root.leftChild?.lazy  = value
        root.rightChild?.lazy = value
        if value == -1 {
            root.leftChild?.isCover = false
            root.rightChild?.isCover = false
        } else {
            root.leftChild?.isCover = true
            root.rightChild?.isCover = true
        }
        root.lazy = 0
    }
    
    func pushUP(_ root:Node){
        root.isCover = root.leftChild!.isCover && root.rightChild!.isCover
    }
    
    func addRange(_ left: Int, _ right: Int) {
        update(root, left, right - 1, 1)
    }
    
    
    
    func queryRange(_ left: Int, _ right: Int) -> Bool {
        query(root, left, right-1)
    }
    
    func removeRange(_ left: Int, _ right: Int) {
        update(root, left, right - 1, -1)
    }
}


func findDiagonalOrder(_ mat: [[Int]]) -> [Int] {
    guard mat.count > 1 else {
        return mat[0]
    }
    let vCount = mat.count - 1
    let hCount = mat[0].count - 1
    let count = vCount + hCount + 1
    var num = [Int]()
    var isDown = false
    for i in 0..<count {
        let x1 = i > hCount ? hCount : i
        let y1 = i > hCount ? (i - hCount) : 0
        let x2 = i > vCount ? (i - vCount) : 0
        let y2 = i > vCount ? vCount : i
        if isDown {
            var beginX = x1,beginY  = y1
            while beginX != x2,y2 != beginY {
                num.append(mat[beginY][beginX])
                if beginX != x2 {
                    beginX -= 1
                }
                
                if beginY != y2 {
                    beginY += 1
                }
            }
            num.append(mat[beginY][beginX])
        } else {
            var beginX = x2,beginY  = y2
            while beginX != x1,y1 != beginY {
                num.append(mat[beginY][beginX])
                if beginX != x1 {
                    beginX += 1
                }
                
                if beginY != y1 {
                    beginY -= 1
                }
            }
            num.append(mat[beginY][beginX])
        }
        isDown = !isDown
    }
    return num
    
}

func minimumAbsDifference(_ arr: [Int]) -> [[Int]] {
    var sorArr = arr
    sorArry(array: &sorArr, left: 0, right: sorArr.count - 1)
    var result = [[Int]]()
    var lastNum = sorArr[0]
    var minNum = Int.max
    for i in 1..<sorArr.count {
        let currNum = sorArr[i] - lastNum
        if currNum == minNum {
            result.append([lastNum,sorArr[i]])
        } else if currNum < minNum {
            result.removeAll()
            minNum = currNum
            result.append([lastNum,sorArr[i]])
        }
        lastNum = sorArr[i]
    }
    return result
}

func sorArry(array: inout [Int],left:Int,right:Int) {
    guard left < right else {
        return
    }
    var leftIndex = left,rightIndex = right
    let temp = array[left]
    while leftIndex < rightIndex {
        while array[rightIndex] >= temp && leftIndex < rightIndex{
            rightIndex -= 1
        }
        while array[leftIndex] <= temp && leftIndex < rightIndex {
            leftIndex += 1
        }
        if leftIndex < rightIndex {
            array[leftIndex] ^= array[rightIndex]
            array[rightIndex] ^= array[leftIndex]
            array[leftIndex] ^= array[rightIndex]
        }
    }
    array[left] = array[leftIndex]
    array[leftIndex] = temp
    sorArry(array: &array, left: left, right: leftIndex - 1)
    sorArry(array: &array, left: leftIndex + 1, right: right)
}

func minCostToMoveChips(_ position: [Int]) -> Int {
    var oddSum = 0,evenSum = 0
    for i in position {
        if i % 2 == 0 {
            evenSum += 1
        } else {
            oddSum += 1
        }
    }
    
    return oddSum > evenSum ? evenSum : oddSum
}

///最低加油次数
func minRefuelStops(_ target: Int, _ startFuel: Int, _ stations: [[Int]]) -> Int {
    var dp = Array(repeating: 0, count: stations.count + 1)
    dp[0] = startFuel
    for i in 0..<stations.count {
        for j in 0...i {
           let num = i - j
            if dp[num] >= stations[i][0] {
                dp[num + 1] = max(dp[num + 1], dp[num] + stations[i][1])
            }
        }
    }
    for i in 0..<dp.count {
        if dp[i] >= target {
            return i
        }
    }
    
    return -1
}

class MagicDictionary {
    var map = [Int:[String]]()
    init() {

    }
    
    func buildDict(_ dictionary: [String]) {
        for dic in dictionary {
            map[dic.count] = (map[dic.count] ?? []) + [dic]
        }
    }
    
    func search(_ searchWord: String) -> Bool {
        guard let dicArr = map[searchWord.count] else {
            return false
        }
        var isChange = false
        let searArr = Array(searchWord)
        loop:for str in dicArr {
            isChange = false
            if searchWord == str {
                continue
            }
            let tempArr = Array(str)
            for i in 0..<searchWord.count {
                if searArr[i] != tempArr[i] {
                    if isChange {
                        isChange = false
                        break
                    }
                    isChange = true
                }
                if i == searchWord.count-1 {
                    break loop
                }
            }
            
        }
        return isChange
    }
}

func oddCells(_ m: Int, _ n: Int, _ indices: [[Int]]) -> Int {
    var rMap = [Int:Int]()
    var cMap = [Int:Int]()
    for arr in indices {
        rMap[arr[0]] = (rMap[arr[0]] ?? 0) + 1
        cMap[arr[1]] = (cMap[arr[1]] ?? 0) + 1
    }
    var result = 0
    for i in 0..<m {
        let rTemp = rMap[i] ?? 0
        for j in 0..<n {
            let cTemp = cMap[j] ?? 0
            if (cTemp + rTemp) % 2 != 0 {
                result += 1
            }
        }
    }
    return result
}

func isPalindrome(_ x: Int) -> Bool {
    let intStr = String(x)
    let array = Array(intStr)
    var left = 0,right = array.count - 1
    while left < right {
        if array[left] != array[right] {
            return false
        }
        left += 1
        right -= 1
    }
    return true
}

func lengthOfLongestSubstring(_ s: String) -> Int {
    guard s.count > 0 else {
        return 0
    }
    let charArray = Array(s)
    var dp = Array(repeating: 0, count: s.count)
    var map = [Character:Int]()
    dp[0] = 1
    map[charArray[0]] = 0
    var maxNum = 1
    for i in 1..<charArray.count {
        let lastStart = i-1 - dp[i-1]
        let lastChat = map[charArray[i]] ?? -1
        if lastStart >= lastChat {
            dp[i] = dp[i-1]+1
        } else {
            dp[i] = i - lastChat
        }
        maxNum = max(maxNum, dp[i])
        map[charArray[i]] = i
    }

    return maxNum
}

func asteroidCollision(_ asteroids: [Int]) -> [Int] {
    var result = [Int]()
    var left = 0
    
    while left < asteroids.count {
        let value = asteroids[left]
        if  let lastValue = result.last {
            if value > lastValue || value * lastValue > 0{
                result.append(value)
            } else if value * lastValue < 0 {
                if abs(value) > abs(lastValue) {
                    result.removeLast()
                    continue
                } else if abs(value) == abs(lastValue) {
                    result.removeLast()
                }
            }
        } else {
            result.append(value)
        }
        left += 1
    }
    return result
}

func removeElement(_ nums: inout [Int], _ val: Int) -> Int {
    var left = 0,right = nums.count
    while left < right {
        if nums[left] == val {
            right -= 1
            let temp = nums[right]
            nums[right] = nums[left]
            nums[left] = temp
        } else {
            left += 1
        }
    }
    return right
}

class WordFilter {
    class Node {
        var nodeArr:[Node?] = Array(repeating: nil, count: 26)
        var indicesArr = [Int]()
    }
    var root:Node
    var tail:Node
    init(_ words: [String]) {
        root = Node()
        tail = Node()
        for (i,value) in words.enumerated() {
            let arr = Array(value)
            var prefix = root
            var suffix = tail
            for (j,char) in arr.enumerated() {
                var idx = indexChar(char)
                if prefix.nodeArr[idx] == nil {
                    prefix.nodeArr[idx] = Node()
                }
                prefix = prefix.nodeArr[idx]!
                prefix.indicesArr.append(i)
                idx = indexChar(arr[arr.count - j - 1])
                if suffix.nodeArr[idx] == nil {
                    suffix.nodeArr[idx] = Node()
                }
                suffix = suffix.nodeArr[idx]!
                suffix.indicesArr.append(i)
            }
        }
        
    }
    
    func f(_ pref: String, _ suff: String) -> Int {
        let preChar = Array(pref)
        var pre = root
        for char in preChar {
            if let node = pre.nodeArr[indexChar(char)] {
                pre = node
            } else {
                return -1
            }
        }
        let preindexArr = pre.indicesArr
        let suffChar = Array(suff)
        var suf = tail
        for char in suffChar.reversed() {
            if let node = suf.nodeArr[indexChar(char)] {
                suf = node
            } else {
                return -1
            }
        }
        let sufindexArr = suf.indicesArr
        var i = preindexArr.count - 1
        var j = sufindexArr.count - 1
        while i >= 0,j >= 0 {
            let a = preindexArr[i]
            let b = sufindexArr[j]
            if a == b {
                return a
            } else if a > b {
                i -= 1
            } else {
                j -= 1
            }
        }
        return -1
    }
    
    func indexChar(_ char:Character)->Int {
        return Int(char.unicodeScalars.first!.value - "a".unicodeScalars.first!.value)
    }
    
}


class MovingAverage {
    let size:Int
    var sum:Int
    var leftIndex:Int
    var numArr:[Int]
    init(_ size: Int) {
        self.size = size
        sum = 0
        leftIndex = 0
        numArr = []
    }
    
    @discardableResult
    func next(_ val: Int) -> Double {
        guard numArr.count == size else {
            sum += val
            numArr.append(val)
            return Double(sum) / Double(numArr.count)
        }
        leftIndex = leftIndex >= size ? 0:leftIndex
        sum += val - numArr[leftIndex]
        numArr[leftIndex] = val
        leftIndex += 1
        return Double(sum) / Double(size)
        
    }
}

func searchInsert(_ nums: [Int], _ target: Int) -> Int {
    guard target >= nums.first!,target <= nums.last! else {
        return target <= nums.first! ? 0:nums.count
    }
    var left = 0,right = nums.count-1
    while left < right {
        let mid = (right - left) >> 1 + left
        if nums[mid] < target {
            left = mid + 1
        } else if nums[mid] == target {
            return mid
        } else {
            right = mid
        }
    }
    
    return left
}
// 数组嵌套
func arrayNesting(_ nums: [Int]) -> Int {
    var tagNums = nums
    var j = 0,sumMax = 0
    while j < nums.count {
        defer {
            j += 1
        }
        if tagNums[j] == nums.count {
            continue
        }
        var i = j
        var temp = 0
        while tagNums[i] != nums.count {
            tagNums[i] = nums.count
            i = nums[i]
            temp += 1
        }
        sumMax = max(sumMax, temp)
    }
    return sumMax
}

class sol1133 {
    let dirs = [[0,1],[1,0],[0,-1],[-1,0]]
    var curWall = 0
    var rows = 0,cols = 0,result = 0
    func containVirus(_ isInfected: [[Int]]) -> Int {
        rows = isInfected[0].count
        cols = isInfected.count
        var grid = isInfected
        while true {
            let walls = getMaxAreaNeedWalls(&grid)
            if walls == 0 {
                break
            }
            result += walls
        }
        return result
    }
    
    
    func getMaxAreaNeedWalls(_ grid:inout [[Int]]) -> Int {
        var maxArea = 0,ans = 0,targetX = -1,targetY = -1,state = -3
        var visited = Array(repeating: Array(repeating: 0, count: rows), count: cols)
        for i in 0..<cols {
            for j in 0..<rows {
                if grid[i][j] == 1 && visited[i][j] == 0 {
                    curWall = 0
                    let curMaxArea = defs(grid, &visited, i, j, state)
                    if curMaxArea > maxArea {
                        maxArea = curMaxArea
                        ans = curWall
                        targetX = i
                        targetY = j
                    }
                    state -= 1
                }
            }
        }
        if targetX == -1 {return 0}
        modifyDead(&grid, targetX, targetY)
        visited = Array(repeating: Array(repeating: 0, count: rows), count: cols)
        for i in 0..<cols {
            for j in 0..<rows {
                if grid[i][j] == 1 && visited[i][j] == 0 {
                    spead(&grid, &visited, i, j)
                }
            }
        }
        return ans
    }
    
    func spead(_ grid: inout [[Int]],_ vist: inout [[Int]],_ x:Int,_ y:Int) {
        vist[x][y] = 1
        for i in 0..<4 {
            let newx = x + dirs[i][0]
            let newy = y + dirs[i][1]
            if newx >= 0 && newx < cols && newy >= 0 && newy < rows && vist[newx][newy] == 0 {
                if grid[newx][newy] == 0 {
                    grid[newx][newy] = 1
                    vist[newx][newy] = 1
                } else if grid[newx][newy] == 1 {
                    spead(&grid, &vist, newx, newy)
                }
            }
        }
    }
    
    func modifyDead(_ grid: inout [[Int]],_ x:Int, _ y:Int){
        grid[x][y] = -2
        for i in 0..<4 {
            let newx = x + dirs[i][0]
            let newy = y + dirs[i][1]
            if newx >= 0 && newx < cols && newy >= 0 && newy < rows && grid[newx][newy] == 1 {
                modifyDead(&grid, newx, newy)
            }
        }
    }
    func defs(_ grid: [[Int]],_ vist: inout [[Int]],_ x:Int,_ y:Int,_ state:Int)->Int{
        var curArea = 0
        vist[x][y] = 1
        for i in 0..<4 {
            let newx = x + dirs[i][0]
            let newy = y + dirs[i][1]
            if newx >= 0 && newx < cols && newy >= 0 && newy < rows && vist[newx][newy] != 1 {
                if grid[newx][newy] == 0 {
                    curWall += 1
                    if vist[newx][newy] != state {
                        curArea += 1
                        vist[newx][newy] = state
                    }
                } else if grid[newx][newy] == 1 {
                    curArea += defs(grid, &vist, newx, newy, state)
                }
            }
        }
        return curArea
    }
}

class MyCalendarTwo {
    var treeMapN = [Int:Int]()
    init() {

    }
    
    func book(_ start: Int, _ end: Int) -> Bool {
        treeMapN[start] = (treeMapN[start] ?? 0) + 1
        treeMapN[end] = (treeMapN[end] ?? 0) - 1
        var lastNum = 0
        let keyArray = treeMapN.keys.sorted()
        for k in keyArray {
            if k > end {
                break
            }
            lastNum = lastNum + treeMapN[k]!
            if lastNum >= 3 {
                break
            }
        }
        if lastNum >= 3 {
            treeMapN[start] = treeMapN[start]! - 1
            treeMapN[end] = treeMapN[end]! + 1
        }
        return true
    }
}

func shiftGrid(_ grid: [[Int]], _ k: Int) -> [[Int]] {
    var tempGrid = grid
    let m = grid.count,n = grid[0].count,mn = m * n
    for i in 0..<m {
        for j in 0..<n {
            let v = (i*n+j+k)%mn
            tempGrid[v/n][v%n] = grid[i][j]
        }
    }
    return tempGrid
}

func pruneTree(_ root: TreeNode?) -> TreeNode? {
    let canRemove = pruneTree1(root)
    return canRemove ? nil : root
}


func pruneTree1(_ root: TreeNode?) -> Bool {
    var canRemove = true
    if let left = root?.left {
        let leftCan = pruneTree1(left)
        if leftCan {
            root?.left = nil
        }
        canRemove = canRemove && leftCan
    }
    
    if let right = root?.right {
        let rightCan = pruneTree1(right)
        if rightCan {
            root?.right = nil
        }
        canRemove = canRemove && rightCan
    }
    if canRemove {
        return root?.val == 0
    }
    return canRemove
}

// 设置交集大小至少为2
func intersectionSizeTwo(_ intervals1: [[Int]]) -> Int {
    let intervals = intervals1.sorted { x, y in
        if x[0] == y[0] {
            return x[1] > y[1]
        } else {
            return x[0] < y[0]
        }
    }
    let n  = intervals1.count
    var leftIndex = intervals[n-1][0],rightIndex = leftIndex + 1
    var ans = 2
    for i in (0..<n-1).reversed() {
        let x = intervals[i][0],y = intervals[i][1]
        if y >= rightIndex {
            continue
        } else if y < leftIndex {
            leftIndex = x
            rightIndex = x + 1
            ans += 2
        } else {
            rightIndex = leftIndex
            leftIndex = x
            ans += 1
        }
    }
    return ans
}


func sequenceReconstruction(_ nums: [Int], _ sequences: [[Int]]) -> Bool {
    var treeMap = [Int:[Int]]()
    var numArr = Array(repeating: 0, count: nums.count + 1)
    for squ in sequences {
        for i in 0..<(squ.count-1) {
            let from = squ[i],to = squ[i+1]
            if let set = treeMap[from],set.contains(to){
                continue
            }
            treeMap[from] = (treeMap[from] ?? []) + [to]
            numArr[to] += 1
        }
    }
    var queue = [Int]()
    for i in 1..<numArr.count {
        if numArr[i] == 0 {
            queue.append(i)
        }
    }
    
    while !queue.isEmpty {
        if queue.count > 1 {
            return false
        }
        let from = queue.removeLast()
        guard let set = treeMap[from] else {
            return true
        }
        for i in set {
            numArr[i] -= 1
            if numArr[i] == 0 {
                queue.append(i)
            }
        }
    }
    return true
}

func distanceBetweenBusStops(_ distance: [Int], _ start: Int, _ destination: Int) -> Int {
    var s = start,e = destination,result1 = 0,result2 = 0,n = distance.count
    while s != e {
        let i = s % n
        result1 += distance[i]
         s = (i+1)%n
    }
    
    while s != start {
        let i = s % n
        result2 += distance[i]
        if result1 < result2 {
            return result1
        }
        s = (i+1)%n
    }
    
    return result1 > result2 ? result2:result1
}

func arrayRankTransform(_ arr: [Int]) -> [Int] {
    var sorArr = arr
    rankQuickSort(&sorArr, 0, arr.count-1)
    
    var lasIndex = 1
    var map = [Int:Int]()
    for num in sorArr{
        if map[num] == nil {
            map[num] = lasIndex
            lasIndex += 1
        }
    }
    var result = [Int]()
    for num in arr {
        result.append(map[num]!)
    }
    return result
}

func rankQuickSort(_ arr:inout [Int],_ left:Int,_ right:Int){
    guard left < right else {
        return
    }
    var i = left - 1,j = left,z = right + 1
    let temp = arr[left]
    while j < z {
        if arr[j] < temp {
            i += 1
            let temp1 = arr[i]
            arr[i] = arr[j]
            arr[j] = temp1
            j += 1
        } else if arr[j] == temp {
            j += 1
        } else {
            z -= 1
            let temp1 = arr[z]
            arr[z] = arr[j]
            arr[j] = temp1
        }
    }
    rankQuickSort(&arr, left, i)
    rankQuickSort(&arr, z, right)
}

func validSquare(_ p1: [Int], _ p2: [Int], _ p3: [Int], _ p4: [Int]) -> Bool {
    guard p1 != p2 else {
        return false
    }
    let pArr = [p1,p2,p3,p4]
    let sorArr = pArr.sorted { b, a in
        if b[0] > a[0] {
            return true
        } else if b[0]==a[0],b[1]>a[1]{
            return true
        } else {
            return false
        }
    }
    
    let hander:([Int],[Int])->Double = {(a:[Int],b:[Int]) in
        let x = pow(Double(abs(b[0]-a[0])), 2.00)
        let y = pow(Double(abs(b[1]-a[1])), 2.00)
        return sqrt(x+y)
    }
    
    
    let x = hander(sorArr[0],sorArr[3])
    let y = hander(sorArr[1],sorArr[2])
    if x == y {
        let z = hander(sorArr[0],sorArr[1])
        let j = hander(sorArr[1],sorArr[3])
        return z == j
    }
    return false
}

func exclusiveTime(_ n: Int, _ logs: [String]) -> [Int] {
    guard n > 1 else {
        let ss = exclusiveTime(logs.last!)
        return [(ss.2 + 1)]
    }
    var resultArr = Array(repeating: 0, count: n)
    var leftArr = [Int]()
    var lastNum = 0
    for log in logs {
        let ss = exclusiveTime(log)
        if ss.1 {
            if let last = leftArr.last {
                let temp = ss.2 - lastNum
                resultArr[last] += temp
            }
            leftArr.append(ss.0)
            lastNum = ss.2
        } else {
            let last = leftArr.removeLast()
            if last != ss.0 {
                print("添加删除有问题")
            }
            let temp = ss.2 - lastNum + 1
            resultArr[last] += temp
            lastNum = ss.2 + 1
        }
    }
    
    return resultArr
}

func exclusiveTime(_ str:String)->(Int,Bool,Int){
    let arry = str.split(separator: ":")
    return (Int(arry[0])!,arry[1] == "start",Int(arry[2])!)
}

func minStartValue(_ nums: [Int]) -> Int {
    var min = 1
    var sum = 1
    for num in nums {
        sum += num
        while sum <= 0 {
            min += 1
            sum += 1
        }
    }
    return min
}

//152. 乘积最大子数组
func maxProduct2(_ nums: [Int]) -> Int {
    let n = nums.count
    var dpArr = [1]
    var res = Int.min
    for i in 1...n {
        if nums[i-1] == 0 {
            if dpArr.count > 1 {
                res = max(res,maxBig(preNum: dpArr))
            }
            dpArr = [1]
            res = max(0,res)
        } else {
            dpArr.append(nums[i-1] * dpArr.last!)
        }
    }
    
    //不包含0开始的子数组
    func maxBig(preNum:[Int]) ->Int {
        let n = preNum.count
        guard n > 2 else {
            return preNum[1]
        }
        var res = Int.min
        for i in 0..<(n-1) {
            for j in (i+1)..<n {
                res = max(preNum[j] / preNum[i],res)
            }
        }
        return res
    }
    if dpArr.count > 1 {
        res = max(res,maxBig(preNum: dpArr))
    }
    return res
}
