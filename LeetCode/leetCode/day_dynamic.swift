//
//  dynamic.swift
//  leetCode
//
//  Created by 陈晶泊 on 2022/5/5.
//

import Foundation
func climbStairs(_ n: Int) -> Int {
    guard n > 1 else {
        return 1
    }
    return climbStairs(n-1) + climbStairs(n - 2)
}

func climbStairsDP(_ n: Int) -> Int {
    guard n > 2 else {
        return n
    }
    var dp = Array.init(repeating: 0, count: n)
    dp[0] = 1
    dp[1] = 2
    for i in 2...n-1 {
        dp[i] = dp[i-1] + dp[i-2]
    }
    return dp[n-1]
}

func climbStairsFB(_ n: Int) -> Int {
    guard n > 2 else {
        return n
    }
    let sumArr = matrixMut([[1,1],[1,0]], n-2)
    
    return 2*sumArr[0][0] + sumArr[1][0]
}

func matrixMut(_ matr: [[Int]],_ pow: Int) -> [[Int]] {
    var sumMatr = [[1,0],[0,1]]
    guard pow > 0,matr.count == 2,matr[0].count == 2,matr[1].count == 2 else {
        return sumMatr
    }
    var i = pow
    var temp = matr
    while i > 0 {
        if i & 1 != 0 {
            sumMatr = matrixMut(sumMatr, temp)
        }
        i = i >> 1
        temp = matrixMut(temp, temp)
    }
    return sumMatr
}

func matrixMut(_ matr1: [[Int]],_ matr2: [[Int]]) -> [[Int]] {
    let result = Array(repeating: 0, count: matr1[0].count)
    var resultMatr = Array(repeating: result, count: matr1.count)
    for i in 0..<resultMatr.count {
        for j in 0..<resultMatr[i].count {
            var temp = 0
            for z in 0..<resultMatr[i].count {
                temp += matr1[i][z] * matr2[z][j]
            }
            resultMatr[i][j] = temp;
        }
    }
    return resultMatr
}

func maxProfit(_ prices: [Int]) -> Int {
    var result = 0
    var left = prices[0]
    var right = prices[0]
    for i in prices {
        if i > right {
            right = i
            result = max(result, right - left)
        }
        if i < left {
            left = i
            right = left
        }
    }
    return result
}

func maxSubArray(_ nums: [Int]) -> Int {
    var result = nums[0]
    var leftMax = nums[0]
    for i in 1..<nums.count {
        if leftMax > 0 {
            leftMax = nums[i] + leftMax
        } else {
            leftMax = nums[i]
        }
        result = max(result, leftMax)
    }
    return result
    
}
func rob(_ nums: [Int]) -> Int {
    var count = nums.count - 1
    guard count > 1 else {
        return max(nums.first!, nums.last!)
    }
    var temp2 = nums[count]
    var temp1 = max(nums[count - 1], nums[count])
    count = count - 2
    while count >= 0 {
        let temp = max(temp2 + nums[count], temp1)
        temp2 = temp1
        temp1 = temp
        count -= 1
    }
    return temp1
}

func rob(_ nums: [Int],index: Int) -> Int {
    guard index < nums.count else {
        return 0
    }
    return max(rob(nums, index: index + 2) + nums[index] , rob(nums, index: index + 1))
}


class Solution_1 {
    private let nums: [Int]
    init(_ nums: [Int]) {
        self.nums = nums
    }
    
    func reset() -> [Int] {
        return nums
    }
    
    func shuffle() -> [Int] {
        var tempNums = nums
        for i in 0..<tempNums.count {
            let j = Int.random(in: 0...i)
            sawp(nums: &tempNums, i: i, j: j)
        }
        return tempNums
    }
    
    private func sawp( nums: inout [Int],i: Int,j: Int) {
        if i != j {
            nums[i] ^= nums[j]
            nums[j] ^= nums[i]
            nums[i] ^= nums[j]
        }
    }
}

func isPowerOfThree(_ n: Int) -> Bool {
    guard n >= 0 else {
        return false
    }
    let i = 1162261467 % n
    print(i)
    return i == 0
}

func hammingWeight(_ n: Int) -> Int {
    var num = n
    var index = 0
    while num > 0 {
        index += 1
        num &= num - 1
    }
    return index
}

/// 1001,0111
func rightestNum(n: Int) -> Int {
    guard n > 0 else {
        return 0
    }
    return (~n + 1) & n
}

func countPrimes(_ n: Int) -> Int {
    guard n > 1 else {
        return 0
    }
    var isprime = Array(repeating: true, count: n)
    var prime = [Int]()
    var count = 0
    isprime[1] = false
    for i in 2..<n {
        if isprime[i] {
            prime.append(i)
            count+=1;
        }
        for j in 0..<count {
            guard i*prime[j] < n else {
                break
            }
            isprime[i*prime[j]] = false
            if i % prime[j] == 0 {
                break
            }
        }
    }
    return count
}

//并行课程 II
func minNumberOfSemesters(_ n: Int, _ relations: [[Int]], _ k: Int) -> Int {
    var dp = Array(repeating: Int.max, count: 1 << n)
    var need = Array(repeating: 0, count: 1 << n)
    for relation in relations {
        need[1 << (relation[1] - 1)] |= 1 << (relation[0]-1)
    }
    dp[0] = 0
    for i in 1..<(1 << n) {
        need[i] = need[i & (i-1)] | need[i & (-i)]
        if need[i] | i != i {
            continue
        }
        let valid = i ^ need[i]
        if valid.nonzeroBitCount <= k {
            dp[i] = min(dp[i],dp[i ^ valid] + 1)
        } else {
            var sub = valid
            while sub > 0 {
                sub = (sub - 1) & valid
                if sub.nonzeroBitCount <= k {
                    dp[i] = min(dp[i],dp[i ^ sub] + 1)
                }
            }
        }
    }
    return dp[1 << n - 1]
}

//2050. 并行课程 III
//[[1,3],[2,3],[1,2]]
// 3 [3,2,5]
func minimumTime(_ n: Int, _ relations: [[Int]], _ time: [Int]) -> Int {
    class Node {
        var cur:Int
        var nexts = [Int]()
        var num = 0
        init(cur:Int) {
            self.cur = cur
        }
    }
    let treeArr = [Node(cur: 0)] + time.map { Node(cur: $0) }
    var zeroArr = Set<Int>(Array(1...n))
    for relation in relations {
        treeArr[relation[0]].nexts.append(relation[1])
        treeArr[relation[1]].num += 1
        if treeArr[relation[0]].num == 0 {
            zeroArr.insert(relation[0])
        }
        if zeroArr.contains(relation[1]) {
            zeroArr.remove(relation[1])
        }
    }
    var res = 0,minZero = 1
    while !zeroArr.isEmpty {
        let temp = zeroArr,index = minZero
        minZero = Int.max
        for num in temp {
            treeArr[num].cur -= index
            if treeArr[num].cur == 0 {
                zeroArr.remove(num)
                for node in treeArr[num].nexts {
                    treeArr[node].num -= 1
                    if treeArr[node].num == 0 {
                        zeroArr.insert(node)
                        minZero = min(minZero,treeArr[node].cur)
                    }
                }
            } else {
                minZero = min(minZero,treeArr[num].cur)
            }
        }
        res += index
    }
    return res
}

//120. 三角形最小路径和
// dp[i] = dp[i-1],dp[i]
/**
 1 1 1 1 1 1
 1 1 1 1 1 1 1
 */
func minimumTotal(_ triangle: [[Int]]) -> Int {
    let n = triangle.count
    guard n > 1 else {
        return triangle[0][0]
    }
    var dp = Array(repeating: Int.max, count: n),res = Int.max
    dp[0] = triangle[0][0]
    for i in 1..<n {
        for j in (0...i).reversed() {
            dp[j] = triangle[i][j] + min(dp[j],j-1 < 0 ? Int.max:dp[j-1])
            if i == n-1 {
                res = min(res,dp[j])
            }
        }
    }
    return res
}

//买卖股票的最佳时机 IV
func maxProfit(_ k: Int, _ prices: [Int]) -> Int {
    let m = prices.count,n = min(k,m/2) + 1
    //最后购买一件
    var buy = Array(repeating: Array(repeating: Int.min/2, count: n), count: m)
    //最后不买一件
    var sel = Array(repeating: Array(repeating: Int.min/2, count: n), count: m)
    buy[0][0] = -prices[0]
    sel[0][0] = 0
    for i in 1..<n {
        sel[0][i] = Int.min/2
        buy[0][i] = sel[0][i]
    }
    for i in 1..<m {
        buy[i][0] = max(buy[i - 1][0], sel[i - 1][0] - prices[i])
        for j in 1..<n {
            buy[i][j] = max(buy[i-1][j],sel[i-1][j] - prices[i])
            sel[i][j] = max(sel[i-1][j],buy[i-1][j-1] + prices[i])
        }
    }
    return sel[m-1].max()!
}

// 309. 买卖股票的最佳时机含冷冻期
// dp[i][0],不持股且当天没卖出
// dp[i][1], 持股,(不一定是当天的股票)
// dp[i][2], 不持股且当天卖出了
/**
 dp[i][0] = max(dp[i-1][0],dp[i-1][2])
 dp[i][1] = max(dp[i-1][1],dp[i-1][0]-prices[i] )
 dp[i][2] = dp[i-1][1] + price[i]
 */
func maxProfit2(_ prices: [Int]) -> Int {
    let n = prices.count
    var dp = Array(repeating: Array(repeating: Int.min/2, count: 3), count: n)
    dp[0][0] = 0;dp[0][2] = 0;dp[0][1] = -prices[0]
    for i in 1..<n {
        dp[i][0] = max(dp[i-1][0],dp[i-1][2])
        dp[i][1] = max(dp[i-1][1],dp[i-1][0]-prices[i])
        dp[i][2] = dp[i-1][1] + prices[i]
    }
    return max(dp[n-1][0],dp[n-1][2])
}

// 714. 买卖股票的最佳时机含手续费
//
func maxProfit3(_ prices: [Int], _ fee: Int) -> Int {
    let n = prices.count
    var dp = Array(repeating: Array(repeating: Int.min/2, count: 2), count: n)
    // 这是购买了
    dp[0][0] = -prices[0]
    // 这是出售
    dp[0][1] = 0
    for i in 1..<n {
        dp[i][0] = max(dp[i-1][0],dp[i-1][1] - prices[i])
        dp[i][1] = max(dp[i-1][1],dp[i-1][0] + prices[i] - fee)
    }
    return dp[n-1][1]
}


// 746. 使用最小花费爬楼梯f(i) = min(f(i-1),f(i-2)) + c
// 2 <= cost.length <= 1000
func minCostClimbingStairs(_ cost: [Int]) -> Int {
    var lt = cost[1],llt = cost[0]
    guard cost.count > 2 else {
        return min(lt,llt)
    }
    for i in 2..<cost.count {
        let temp = lt
        lt = min(lt,llt) + cost[i]
        llt = temp
    }
    return min(lt,llt)
}
