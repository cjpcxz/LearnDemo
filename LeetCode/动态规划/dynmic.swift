//
//  dynmic.swift
//  leetCode
//
//  Created by 陈晶泊 on 2022/10/22.
//

import Foundation

//1235. 规划兼职工作
func jobScheduling(_ startTime: [Int], _ endTime: [Int], _ profit: [Int]) -> Int {
    let count = startTime.count
    var sorNum = [Int]()
    for i in 0..<count {
        sorNum.append(i)
    }
    sorNum.sort { i, j in
        endTime[i] < endTime[j]
    }
    let orign:(right:Int,num:Int) = (0,0)
    var dp = Array(repeating: orign, count: count)
    dp[0] = (endTime[sorNum[0]],profit[sorNum[0]])
outLoop:for i in 1..<count {
        //要当前位置的，最大选择
        let temp = sorNum[i]
        let left = startTime[temp]
        var tempNum = profit[temp]
        for j in (0..<i).reversed() where dp[j].right <=  left{
            tempNum += dp[j].num
            break
        }
    if tempNum > dp[i-1].num {
        dp[i].num = tempNum
        dp[i].right = endTime[temp]
    } else if tempNum == dp[i-1].num {
        dp[i].num = tempNum
        dp[i].right = min(endTime[temp],dp[i-1].right)
    } else {
        dp[i] = dp[i-1]
    }
    }
    return dp[count - 1].num
}
//[15,44,15,47,11,18, 5,41,38,25,19,25]
//
//[33,48,20,49,37,22,32,48,39,37,38,40]
//
//[18,19,16,1, 5, 12,17, 7,19,9, 18, 9]


//907. 子数组的最小值之和
func sumSubarrayMins(_ arr: [Int]) -> Int {
    let count = arr.count, mode = Int(1e9 + 7)
    var left = Array(repeating: 0, count: count)
    var right = Array(repeating: 0, count: count)
    var sum = 0
    var sorArr = [Int]()
    for (i,v) in arr.enumerated() {
        while !sorArr.isEmpty,arr[sorArr.last!] > v {
            sorArr.removeLast()
        }
        if sorArr.isEmpty {
            left[i] = -1
        } else {
            left[i] = sorArr.last!
        }
        sorArr.append(i)
    }
    sorArr = []
    for i in (0..<count).reversed() {
        while !sorArr.isEmpty,arr[sorArr.last!] >= arr[i] {
            sorArr.removeLast()
        }
        if sorArr.isEmpty {
            right[i] = count
        } else {
            right[i] = sorArr.last!
        }
        sorArr.append(i)
    }
    for i in 0..<count {
        sum = (sum + (i - left[i]) * (right[i] - i) * arr[i]) % mode
    }
    return sum
}

//864. 获取所有钥匙的最短路径
/**
 '.' 代表一个空房间
 '#' 代表一堵
 '@' 是起点
 小写字母代表钥匙
 大写字母代表锁
 */
func shortestPathAllKeys(_ grid: [String]) -> Int {
    var arr = grid.map { str in
        return Array(str)
    }
    
    return 3
}


//1223. 掷骰子模拟
func dieSimulator(_ n: Int, _ rollMax: [Int]) -> Int {
    let mod = Int(1e9  + 7)
    var dp = Array(repeating: Array(repeating: Array(repeating: 0, count: 16), count: 6), count: 2)
    for i in 0..<6 {
        dp[1][i][1] = 1
    }
    
    for i in 2..<(n+1) {
        let t = i & 1
        dp[t] = Array(repeating: Array(repeating: 0, count: 16), count: 6)
        for j in 0..<6 {

            for k in 1...rollMax[j] {
                for p in 0..<6 {
                    if p != j {
                        dp[t][p][1] = (dp[t][p][1] + dp[t ^ 1][j][k]) % mod
                    } else if k + 1 <= rollMax[j] {
                        dp[t][p][k+1] = (dp[t][p][k + 1] + dp[t ^ 1][j][k]) % mod
                    }
                }
            }
        }
    }
    
    var res = 0
    for j in 0..<6 {
        for k in 1...rollMax[j] {
            res = (res + dp[n & 1][j][k]) % mod
        }
    }

    return res
}

func generateParenthesis(_ n: Int) -> [String] {
    guard n > 2 else {
        return n == 1 ? ["()"]:["(())","()()"]
    }
    var dp = Array(repeating: [String](), count: n + 1)
    dp[1] = ["()"]
    dp[2] = ["()()","(())"]
    for i in 3..<(n + 1) {
        var tempSet = Set<String>()
        for j in 1..<(i/2 + 1) {
            for num1 in dp[j] {
                for num2 in dp[i-j] {
                    tempSet.insert("\(num1)\(num2)")
                    tempSet.insert("\(num2)\(num1)")
                    if num1 == "()" { tempSet.insert("(\(num2))") }
                }
            }
        }
        dp[i] = Array(tempSet)
    }
    return dp[n]
}

func tilingRectangle(_ n: Int, _ m: Int) -> Int {
    var res = n * m,filed = Array(repeating: 0, count: n)
    func dfs(i:Int,j:Int,t:Int) {
        var i = i,j = j
        if j == m {
            i += 1
            j = 0
        }
        if i == n {
            res = t
            return
        }
        if filed[i] >> j & 1 == 1 {
            dfs(i: i, j: j+1, t: t)
        } else if t + 1 < res {
            var r = 0,c = 0
            for k in i..<n  {
                if filed[k] >> j & 1 == 1 {
                    break
                }
                r += 1
            }
            for k in j..<m  {
                if filed[i] >> k & 1 == 1 {
                    break
                }
                c += 1
            }
            let mx = min(r,c)
            for w in 1..<(mx + 1) {
                for k in 0..<w {
                    filed[i+w-1] |= 1 << (j+k)
                    filed[i+k] |= 1 << (j+w-1)
                }
                dfs(i: i, j: j+w, t: t+1)
            }
            for x in i..<(i+mx) {
                for y in j..<(j+mx) {
                    filed[x] ^= 1 << y
                }
            }
        }
    }
    
    dfs(i: 0, j: 0, t: 0)
    return res
}

//动态规划 + 状态压缩
func minimumIncompatibility(_ nums: [Int], _ k: Int) -> Int {
    let n  = nums.count,group = n / k
    var dp = Array(repeating: Int.max, count: 1 << n)
    dp[0] = 0
    var value = [Int:Int]()
    //求出所有满足子集的mask
    for mask in 1..<(1<<n) where mask.nonzeroBitCount == group {
        var mn = 20,mx = 0
        var cur = Set<Int>()
        for i in 0..<n where mask & (1 << i) != 0{
            if cur.contains(nums[i]) {
                break
            }
            cur.insert(nums[i])
            mn = min(mn,nums[i])
            mx = max(mx,nums[i])
        }
        if cur.count == group {
            value[mask] = mx-mn
        }
    }
    
    for mask in 0..<(1<<n) where dp[mask] != Int.max {
        var seen = [Int:Int]()
        for i in 0..<n where mask & 1<<i == 0{
            seen[nums[i]] = i
        }
        guard seen.count >= group else {
            continue
        }
        var sub = 0
        for v in seen.values {
            sub |= 1 << v
        }
        var next = sub
        //遍历，求出
        while next > 0 {
            if let nexv = value[next] {
                dp[mask | next] = min(dp[mask | next],dp[mask] + nexv)
            }
            next = (next - 1) & sub
        }
    }
    return dp[(1 << n)-1] < Int.max ? dp[(1 << n)-1]:-1
    
}


//39. 组合总和
//1 <= target <= 40,1 <= candidates.length <= 30
func combinationSum(_ candidates: [Int], _ target: Int) -> [[Int]] {
    var cacheDP = [Int:[[Int]]]()
    func combinationSum(i:Int,target: Int) -> [[Int]] {
        guard i < candidates.count,target > 0 else {
            return []
        }
        if let arr = cacheDP[100 * i + target] {
            return arr
        }
       let n = target / candidates[i] + 1
        var res = [[Int]]()
        for j in 0..<n {
            let curTarget = target - candidates[i] * j
            if curTarget == 0 {
                res += [Array(repeating: candidates[i], count: j)]
            } else {
                let temp = combinationSum(i: i+1, target: curTarget)
                if !temp.isEmpty {
                    if j == 0 {
                        res += temp
                    } else {
                        let cur = Array(repeating: candidates[i], count: j)
                        res += temp.map{ cur + $0}
                    }
                }
                
            }
        }
        cacheDP[100 * i + target] = res
        return res
    }
    
    return combinationSum(i: 0, target: target)
}

//131. 分割回文串
//给你一个字符串 s，请你将 s 分割成一些子串，使每个子串都是 回文串 。返回 s 所有可能的分割方案。
//回文串 是正着读和反着读都一样的字符串。
// f(i,j) = f(i+1,j-1) & s[i] == s[i+1]

func partition(_ s: String) -> [[String]] {
    let n = s.count,sChar = Array(s)
    var dp = Array(repeating: [[String]](), count: n)
    var partinDP = Array(repeating: Array(repeating: true, count: n), count: n)
    
    for i in (0..<n-1).reversed() {
        for j in (i+1)..<n {
            partinDP[i][j] = partinDP[i+1][j-1] && sChar[i] == sChar[j]
        }
    }
    func partins(i:Int) -> [[String]] {
        guard i < n else {
            return [[]]
        }
        guard dp[i].isEmpty else {
            return dp[i]
        }
        var res = [[String]]()
        for j in i..<n where partinDP[i][j]{
            let temp = [String(sChar[i..<(j+1)])]
            res += partins(i: j+1).map{ temp + $0}
        }
        dp[i] = res
        return res
    }
    return partins(i:0)
}

//2178. 拆分成最多数目的正偶数之和
func maximumEvenSplit(_ finalSum: Int) -> [Int] {
    guard finalSum % 2 == 0 else {
        return []
    }
    var res = [Int](),sum = finalSum
    for i in stride(from: 2, through: finalSum, by: 2) {
        guard sum - i >= 0 else {
            break
        }
        res.append(i)
        sum -= i
    }
    if sum > 0 {
        res[res.count-1] = res.last! + sum
    }
    return res
}


//55. 跳跃游戏
func canJump(_ nums: [Int]) -> Bool {
    let n = nums.count
    var last = n - 1
    for i in (0..<(n-1)).reversed() {
        if nums[i] + i >= last {
            last = i
        }
    }
    return last == 0
}

//64. 最小路径和
/**
 给定一个包含非负整数的 m x n 网格 grid ，请找出一条从左上角到右下角的路径，使得路径上的数字总和为最小。
 每次只能向下或者向右移动一步。
 dp[i][j] = min(dp[i][j-1],dp[i-1][j]) + grid[i][j]
 [[1,2],[1,1]]
 */
func minPathSum(_ grid: [[Int]]) -> Int {
    let m = grid.count,n = grid[0].count
    var dp = grid[0]
    for j in 1..<n {
        dp[j] += dp[j-1]
    }
    for i in 1..<m {
        for j in 0..<n {
            dp[j] = min(j>0 ? dp[j-1]:Int.max,dp[j]) + grid[i][j]
        }
    }
    return dp[n-1]
}


//139. 单词拆分
//给你一个字符串 s 和一个字符串列表 wordDict 作为字典。请你判断是否可以利用字典中出现的单词拼接出 s 。

// 注意：不要求字典中出现的单词全部都使用，并且字典中的单词可以重复使用。
func wordBreak(_ s: String, _ wordDict: [String]) -> Bool {
    let n = s.count,chars = Array(s)
    var dp = Array(repeating: 0, count: n)
    let words = wordDict.sorted { $0.count > $1.count }
    
    func breakWord(end:Int) -> Bool {
        guard end > 0 else {
            return true
        }
        guard dp[end-1] == 0 else {
            return dp[end - 1] == 1
        }
        for word in words {
            if end >= word.count,word == String(chars[(end-word.count )..<end]),breakWord(end: end-word.count) {
                dp[end-1] = 1
                return true
            }
        }
        dp[end-1] = 2
        return false
    }
    return breakWord(end: n)
}

//96. 不同的二叉搜索树
func numTrees(_ n: Int) -> Int {
    if n == 1 || n == 2 {
        return n
    }
    var dp = Array(repeating: 0, count: n+1)
    dp[0] = 1
    dp[1] = 1
    dp[2] = 2
    for i in 3..<n {
        for j in 0..<i {
            dp[i] += dp[i-j-1] * dp[j]
        }
    }
    return dp[n]
}

//1289. 下降路径最小和 II
/**
 给你一个 n x n 整数矩阵 grid ，请你返回 非零偏移下降路径 数字和的最小值。

 非零偏移下降路径 定义为：从 grid 数组中的每一行选择一个数字，且按顺序选出来的数字中，相邻数字不在原数组的同一列。
 */
func minFallingPathSum2(_ grid: [[Int]]) -> Int {
    let m = grid.count,n = grid[0].count
    var dp = Array(repeating: 0, count: n),minS = 0,minF = 0,minIn = -1
    for i in 0..<m {
        var tempS = Int.max,tempF = Int.max,tempIn = -1
        for j in 0..<n {
            dp[j] = (j == minIn ? minS:minF) + grid[i][j]
            if tempF > dp[j] {
                tempS = tempF
                tempF = dp[j]
                tempIn = j
            } else if tempS > dp[j] {
                tempS = dp[j]
            }
        }
        minS = tempS
        minF = tempF
        minIn = tempIn
    }
    return minF
}

func diagonalSum(_ mat: [[Int]]) -> Int {
    let n = mat.count/2
    var res = 0
    for i in 0..<n {
        res += mat[i][i] + mat[i][mat.count-1-i] + mat[mat.count-1-i][i] + mat[mat.count-1-i][mat.count-1-i]
    }
    return res + (mat.count % 2 == 0 ? 0:mat[n][n])
}


//40. 组合总和 II
func combinationSum2(_ candidates: [Int], _ target: Int) -> [[Int]] {
    var map = [Int:[[Int]]]()
    let candidates = candidates.sorted()
    func combinationSum(i:Int,lastSum:Int) -> [[Int]] {
        guard lastSum > 0 else {
            return []
        }
        guard i >= 0 else {
            return []
        }
        let key = 1000 * i + lastSum
        if let arr = map[key] {
            return arr
        }
        var res = [[Int]]()
        for j in (0...i).reversed() {
            if j + 1 <= i,candidates[j + 1] == candidates[j] {
                continue
            }
            if candidates[j] == lastSum {
                res.append([candidates[j]])
            } else if candidates[j] < lastSum {
                let temp = combinationSum(i: j-1, lastSum: lastSum-candidates[j])
                if !temp.isEmpty {
                    res += temp.map{$0 + [candidates[j]]}
                }
            }
        }
        map[key] = res
        return res
    }
    return combinationSum(i: candidates.count-1, lastSum: target)
}

//1 6 1 2 8 1 6 1 2 8
//213. 打家劫舍 II，包含最开始的1，则不能包含最后的
// 不包含0的最大值，1..<n, 包含0的最大值 0..<n-1
func rob1(_ nums: [Int]) -> Int {
    func job2(l:Int,r:Int) -> Int {
        guard r > l else {
            return max(nums[l],nums[r])
        }
        var r = r
        var pre = nums[r]
        var cur = max(pre,nums[r-1])
        r -= 2
        while r >= l {
            let temp = max(pre + nums[r],cur)
            pre = cur
            cur = temp
            r -= 1
        }
        return cur
    }
    let n = nums.count
    guard n > 1 else {
        return nums.first ?? 0
    }
    return max(job2(l: 0, r: n-2),job2(l: 1, r: n-1))
}

//62. 不同路径
/**
 一个机器人位于一个 m x n 网格的左上角 （起始点在下图中标记为 “Start” ）。

 机器人每次只能向下或者向右移动一步。机器人试图达到网格的右下角（在下图中标记为 “Finish” ）。

 问总共有多少条不同的路径？
 dp[i][j] = dp[i-1][j] + dp[i][j-1]
 
 dp[i][j] = dp[j][i]
 */
func uniquePaths(_ m: Int, _ n: Int) -> Int {
    var dp = Array(repeating: 1, count: n)
    for _ in 1..<m {
        for j in 1..<n {
            dp[j] = dp[j-1] + dp[j]
        }
    }
    return dp.last!
}

//1654. 到家的最少跳跃次数
/**
 有一只跳蚤的家在数轴上的位置 x 处。请你帮助它从位置 0 出发，到达它的家。

 跳蚤跳跃的规则如下：

 它可以 往前 跳恰好 a 个位置（即往右跳）。
 它可以 往后 跳恰好 b 个位置（即往左跳）。
 它不能 连续 往后跳 2 次。
 它不能跳到任何 forbidden 数组中的位置。
 跳蚤可以往前跳 超过 它的家的位置，但是它 不能跳到负整数 的位置。
 a x - b y = z
 [14,4,18,1,15], a = 3, b = 15, x = 9
 3  0
 [8,3,16,6,12,20], a = 15, b = 16, x = 22
 14 15
 [1,6,2,14,5,17,4], a = 16, b = 9, x = 7
 16  7
 给你一个整数数组 forbidden ，其中 forbidden[i] 是跳蚤不能跳到的位置，同时给你整数 a， b 和 x ，请你返回跳蚤到家的最少跳跃次数。如果没有恰好到达 x 的可行方案，请你返回 -1 。
dp[x] = min(dp[x+b],dp[x-a]) + 1
 */
func minimumJumps(_ forbidden: [Int], _ a: Int, _ b: Int, _ x: Int) -> Int {
    var queue = [(Int,Int,Int)]()
    var visited = Set<Int>()
    queue.append((0,1,0))
    visited.insert(0)
    let low = 0,upper =  max(forbidden.max()! + a, x) + b,foSet = Set<Int>(forbidden)
    while !queue.isEmpty {
        let temp = queue.removeFirst()
        let position = temp.0,direction = temp.1,step = temp.2
        if position == x {
            return step
        }
        var nextPosition = position + a
        var nextDirection = 1
        if case low...upper = nextPosition,!visited.contains(nextPosition * nextDirection),!foSet.contains(nextPosition) {
            visited.insert(nextPosition * nextDirection)
            queue.append((nextPosition,nextDirection,step + 1))
        }
        if direction == 1 {
            nextPosition = position - b
            nextDirection = -1
            if case low...upper = nextPosition,!visited.contains(nextPosition * nextDirection),!foSet.contains(nextPosition) {
                visited.insert(nextPosition * nextDirection)
                queue.append((nextPosition,nextDirection,step + 1))
            }
        }
    }
    return -1
    
}

//63. 不同路径 II

/**
 一个机器人位于一个 m x n 网格的左上角 （起始点在下图中标记为 “Start” ）。

 机器人每次只能向下或者向右移动一步。机器人试图达到网格的右下角（在下图中标记为 “Finish”）。

 现在考虑网格中有障碍物。那么从左上角到右下角将会有多少条不同的路径？

 网格中的障碍物和空位置分别用 1 和 0 来表示。
 dp[i][j] = (f([i-1][j] != 1]) dp[i-1][j] + dp[i][j-1]  (f([i][j-1] != 1])
 [[0,0,0],[0,1,0],[0,0,0]]

 */
func uniquePathsWithObstacles(_ obstacleGrid: [[Int]]) -> Int {
    let n = obstacleGrid.count,m = obstacleGrid[0].count
    var dp = Array(repeating: 0, count: m)
    for i in 0..<n {
        for j in 0..<m {
            if obstacleGrid[i][j] == 1 {
                dp[j] = 0
            } else if i == 0 {
                dp[j] = j > 0 ? dp[j-1] : 1
            } else if j == 0{
                dp[j] = dp[j]
            } else {
                dp[j] = dp[j] + dp[j-1]
            }
        }
    }

    return dp.last!
}

//45. 跳跃游戏 II

func jump(_ nums: [Int]) -> Int {
    let n = nums.count
    var maxPotision = 0
    var end = 0,step = 0
    for i in 0..<(n-1) {
        maxPotision = max(maxPotision,i + nums[i])
        if i == end {
            end = maxPotision
            step += 1
        }
    }
    return step
}

//630. 课程表 III
//[[100,200],[200,1300],[1000,1250],[2000,3200]]
func scheduleCourse(_ courses: [[Int]]) -> Int {
    let n = courses.count,sorArr = courses.sorted { $0[0] < $1[0] }//需要最少的排在最前面
    var dp = Array(repeating: (0,0), count: n+1)
    for i in 1...n {
        let temp = sorArr[i-1][1] - sorArr[i-1][0]
        //当前的大于最晚的，当前的无法接入,找到第一个小于等于temp
        let fi = find(l: 0, ri: i, target: temp, arr: &dp) //包含他的
        if fi >= 0,dp[fi].1 + 1 > dp[i-1].1 {
            dp[i] = (dp[fi].0 + sorArr[i-1][0],dp[fi].1 + 1)
        } else if fi >= 0,dp[fi].1 + 1 == dp[i-1].1 {
            dp[i] = (min(dp[fi].0 + sorArr[i-1][0],dp[fi].0),dp[fi].1 + 1)
        } else {
            dp[i] = dp[i-1]
        }
    }
    
    func find(l:Int,ri:Int,target:Int,arr:inout [(Int,Int)]) -> Int {
        var l = l,r = ri
        while l < r {
            let mid = (r + l) >> 1
            if arr[mid].0 < target {
                l = mid + 1
            } else {
                r = mid
            }
        }
        guard arr[l].0 <= target else {
            return l-1
        }
        return l < ri ? l:ri-1
    }
    
    return dp[n].1
}


//2560. 打家劫舍 IV
/**
 给你一个整数数组 nums 表示每间房屋存放的现金金额。形式上，从左起第 i 间房屋中放有 nums[i] 美元。

 另给你一个整数 k ，表示窃贼将会窃取的 最少 房屋数。小偷总能窃取至少 k 间房屋。

 返回小偷的 最小 窃取能力。
 0...(n-k)
 [2,3,5,   9]
 4
0      k
  1
   1
n     ?
 k > i,-1
 
 dp[i][k] = min(dp[i-2][k-1] + num[i],dp[i-1][k])
 [2,3,5,9]
 0    0    0
 0    2    0
 0    2    0
 0    2
 0
 [9,6,20,21,8]
 1 4 0 2 3
 4个连续的，取两个，3个去1，5个取 3个，
 [7,3,9,5]
 // 二分法 ，因为二分法，会找到满足小于k的最小值，如果这个mid值不在nums中，那么，会存在mid-1的更小值，也会满足小于k，与二分法矛盾，因此mid一定在里面
 */
func minCapability(_ nums: [Int], _ k: Int) -> Int {
    var lower = nums.min()!,upper = nums.max()!
    while lower < upper {
        let mid = (upper + lower) >> 1
        var visit = false,count = 0
        for num in nums {
            if num <= mid,!visit {
                visit = true
                count += 1
            } else {
                visit = false
            }
            
        }
        if count < k {
            lower = mid + 1
        } else {
            upper = mid
        }
    }
    return lower
}


//1155. 掷骰子等于目标和的方法数
// 动态规划
// dp[i][j],第i个，总共j个,dp[0][0] = 1,dp[i][j] = dp[i-1][j-1]
func numRollsToTarget(_ n: Int, _ k: Int, _ target: Int) -> Int {
    let mode = 1000000007
    var dp = Array(repeating: 0, count: target+1)
    dp[0] = 1
    for _ in 1...n {
        var temp = Array(repeating: 0, count: target+1)
        for j in 0...target {
            for z in 1...k where j-z >= 0 {
                temp[j] = (temp[j] + dp[j-z]) % mode
            }
        }
        dp = temp
    }
    return dp[target]
}


// 2216. 美化数组的最少删除数
func minDeletion(_ nums: [Int]) -> Int {
    let n = nums.count
    var res = 0,check = true
    for i in 0..<(n-1) {
        if nums[i] == nums[i+1],check {
            res += 1
        } else {
            check = !check
        }
    }
    return (n - res) % 2 == 0 ? res : (res + 1)
    
}

// 2008. 出租车的最大盈利,end
// dp[x] = dp[start] - (end - start)
func maxTaxiEarnings(_ n: Int, _ rides: [[Int]]) -> Int {
    
    let rides = rides.sorted { a, b in
        if a[1] < b[1] {
            return true
        } else if a[1] == b[1] {
            return a[0] < b[0]
        } else {
            return false
        }
    }
    var res = 0
    var dp = [(0,0)]
    for ride in rides {
        let s = ride[0],e = ride[1],t = ride[2]
        var cur = dp.last!.1 == e ? dp.last! : (0,e)
        for num in dp.reversed() where num.1 <= s {
            cur.0 = max(cur.0,e - s + t + num.0)
        }
        dp.append(cur)
        res = max(cur.0,res)
    }
    return res
}

//1686. 石子游戏 VI
/**
 Alice 和 Bob 轮流玩一个游戏，Alice 先手。

 一堆石子里总共有 n 个石子，轮到某个玩家时，他可以 移出 一个石子并得到这个石子的价值。Alice 和 Bob 对石子价值有 不一样的的评判标准 。双方都知道对方的评判标准。

 给你两个长度为 n 的整数数组 aliceValues 和 bobValues 。aliceValues[i] 和 bobValues[i] 分别表示 Alice 和 Bob 认为第 i 个石子的价值。

 所有石子都被取完后，得分较高的人为胜者。如果两个玩家得分相同，那么为平局。两位玩家都会采用 最优策略 进行游戏。

 请你推断游戏的结果，用如下的方式表示：

 如果 Alice 赢，返回 1 。
 如果 Bob 赢，返回 -1 。
 如果游戏平局，返回 0 。
 【3,4】
 [3,10,11]
 [6,5,1,2,10,6]
 [7,7,7,7,3,7]
 13 12 8 9 13 13
 6 6 2
 0 4
 3 7
 */

func stoneGameVI(_ aliceValues: [Int], _ bobValues: [Int]) -> Int {
    let n = aliceValues.count
    var arr = Array(repeating: 0, count: n)
    func heapInsert(i:Int,compere:(Int,Int)->Bool) {
        var i = i
        while compere(arr[i],arr[(i-1) / 2]) {
            let j = (i-1) / 2
            (arr[i],arr[j]) = (arr[j],arr[i])
            i = j
        }
    }
    
    func heapFind(i:Int,size:Int,compere:(Int,Int)->Bool) {
        var i=i,l = 2 * i + 1
        while l < size {
            let bigI = l + 1 < size && compere(arr[l+1],arr[l]) ? l+1:l
            guard compere(arr[bigI],arr[i]) else {
                break
            }
            (arr[i],arr[bigI]) = (arr[bigI],arr[i])
            i = bigI
            l = 2 * i + 1
        }
    }
    
    for i in 0..<n {
        arr[i] = i
        heapInsert(i: i) { i, j in
            aliceValues[i] + bobValues[i] > aliceValues[j] + bobValues[j]
        }
    }
    
    var l = 0,r = 0,isL = true
    for i in 0..<n {
        if isL {
            l += aliceValues[arr[0]]
        } else {
            r += bobValues[arr[0]]
        }
        isL = !isL
        arr[0] = arr[n-i-1]
        heapFind(i: 0, size: n-i-1) { i, j in
            aliceValues[i] + bobValues[i] > aliceValues[j] + bobValues[j]
        }
    }
    return l > r ? 1 : (l == r ? 0:-1)
}


func stoneGameVII(_ stones: [Int]) -> Int {
    let n = stones.count
    var dp = [Int:Int](),pre = Array(repeating: 0, count: n+1) // [i,j)
    for i in 1...n {
        pre[i] = pre[i-1] + stones[i-1]
    }
    func key(_ i:Int,_ j:Int) -> Int {
        return i * 1000 + j
    }
    func df(i:Int,j:Int) -> Int {
        guard i > j else {
            return 0
        }
        let key = key(i,j)
        if let num = dp[key] {
            return num
        }
        // 0 1 2 3 [i+1,j)
        let maxN = max(pre[j] - pre[i+1] - df(i: i+1, j: j),pre[j-1] - pre[i] - df(i: i, j: j-1))
        dp[key] = maxN
        return maxN
    }
    return df(i: 0, j: n)
}

//1696. 跳跃游戏 VI
/**
 给你一个下标从 0 开始的整数数组 nums 和一个整数 k 。

 一开始你在下标 0 处。每一步，你最多可以往前跳 k 步，但你不能跳出数组的边界。也就是说，你可以从下标 i 跳到 [i + 1， min(n - 1, i + k)] 包含 两个端点的任意位置。

 你的目标是到达数组最后一个位置（下标为 n - 1 ），你的 得分 为经过的所有数字之和。

 请你返回你能得到的 最大得分 。
 [1,-5,-20,4,-1,3,-6,-3]
 // 双端队列加动态规划
 */
func maxResult(_ nums: [Int], _ k: Int) -> Int {
    let n = nums.count
    var dp = Array(repeating: 0, count: n)
    var queue = [0]
    
    dp[0] = nums[0]
    for i in 1..<n {
        while i - queue.first! > k {
            queue.removeFirst()
        }
        dp[i] = dp[queue.first!] + nums[i]
        while let last = queue.last,dp[last] < dp[i] {
            queue.removeLast()
        }
        queue.append(i)
    }
    return dp[n-1]
}

/**
 221. 最大正方形
 在一个由 '0' 和 '1' 组成的二维矩阵内，找到只包含 '1' 的最大正方形，并返回其面积
 m == matrix.length
 n == matrix[i].length
 1 <= m, n <= 300
 matrix[i][j] 为 '0' 或 '1'
 */
func maximalSquare(_ matrix: [[Character]]) -> Int {
    let m = matrix.count,n = matrix[0].count
    var res = 0,dp = Array(repeating: Array(repeating: 0, count: n), count: m)
    for i in 0..<m {
        for j in 0..<n where matrix[i][j] == "1" {
            if i == 0 || j == 0 {
                dp[i][j] = 1
            } else {
                dp[i][j] = min(dp[i-1][j-1],dp[i-1][j],dp[i][j-1]) + 1
            }
            res = max(dp[i][j],res)
        }
    }
    return res * res
}
