//
//  day_dync.swift
//  leetCode
//
//  Created by 陈晶泊 on 2022/6/25.
//

import Foundation
func minCost(_ costs: [[Int]]) -> Int {
    let count = costs.count
    let costL = costs[0].count
    let arr = Array(repeating: 0, count: count)
    var dp = Array(repeating: arr, count: costL)
    for i in 0..<costL {
        dp[i][0] = costs[0][i]
    }
    for j in 1..<count {
        for i in 0..<costL {
            let l = (i+1) >= costL ? 0:(i+1)
            let r = (i-1) < 0 ? (costL - 1):(i-1)
            dp[i][j] = costs[j][i] + min(dp[l][j-1], dp[r][j-1])
        }
    }
    return min(dp[0][count - 1], dp[1][count - 1], dp[2][count - 1])
}

func minCost(_ costs: [[Int]],_ last:Int,_ index:Int)->Int {
    guard index < costs.count else {
        return 0
    }
    let cur = costs[index]
    var result = Int.max
    for i in 0..<cur.count {
        if i != last {
            result = min(cur[i]+minCost(costs, i, index + 1),result)
        }
    }
    return result
}

func lenLongestFibSubseq(_ arr: [Int]) -> Int {
    var map = [Int:Int]()
    
    for (index,element) in arr.enumerated() {
        map[element] = index
    }
    var dp = Array(repeating: Array(repeating: 0, count: arr.count), count: arr.count)
    var maxSum = 0
    for i in 2..<arr.count {
        for j in (0..<i).reversed(){
            if let z = map[arr[i] - arr[j]],z < j {
                dp[i][j] = max(dp[j][z] + 1,3)
            }
            maxSum = max(dp[i][j], maxSum)
        }
    }
    return maxSum
}

///741. 摘樱桃
func cherryPickup(_ grid: [[Int]]) -> Int {
    let N = grid.count
    var dp = Array(repeating: Array(repeating: Array(repeating: Int.min, count: N), count: N), count: (2 * N - 1))
    dp[0][0][0] = grid[0][0]
    for i in 1..<(2*N-1){
        var x1 = max(i - N + 1, 0)
        while x1 <= min(i, N-1) {
            let y1 = i - x1
            if grid[x1][y1] != -1 {
               var x2 = x1
                while x2 <= min(i, N-1) {
                    let y2 = i - x2
                    if grid[x2][y2] != -1 {
                        var res = dp[i-1][x1][x2]
                        if x1 > 0 {
                            res = max(res, dp[i-1][x1-1][x2])
                        }
                        if x2 > 0 {
                            res = max(res, dp[i-1][x1][x2-1])
                        }
                        
                        if x1 > 0,x2 > 0 {
                            res = max(res, dp[i-1][x1-1][x2-1])
                        }
                        
                        res += grid[x1][y1]
                        if x2 != x1 {
                            res += grid[x2][y2]
                        }
                        dp[i][x1][x2] = res
                    }
                    x2 += 1
                }
            }
            
            x1 += 1
        }
        
    }
    return max(dp[2 * N - 2][N-1][N-1],0)
}

// 求一个整数的惩罚数

func punishmentNumber(_ n: Int) -> Int {
    var res = 0
    for i in 1...n where dfs(sum: Array(String(i * i)),i:0,tot: 0, target: i){
        res += i * i
    }
    
    func dfs(sum:[Character],i: Int,tot:Int,target:Int) -> Bool {
        guard i < sum.count else {
            return tot == target
        }
        var temp = 0
        for j in i..<sum.count {
            temp = temp * 10 + Int(String(sum[j]))!
            if dfs(sum: sum, i:j+1,tot: tot + temp, target: target) {
                return true
            }
        }
        
        return false
    }
    return res
}

