//
//  day_随机.swift
//  leetCode
//
//  Created by 陈晶泊 on 2022/6/9.
//

import Foundation

class Solution1 {
    let radius:Double
    let x_center:Double
    let y_center:Double
    init(_ radius: Double, _ x_center: Double, _ y_center: Double) {
        self.radius = radius
        self.x_center = x_center
        self.y_center = y_center
    }
    
    func randPoint() -> [Double] {
        
        let angle = Double.random(in: 0...(2*Double.pi))
        //面积随机，如果是半径，则是一个个环随机
        let randR = Double.random(in: 0...(radius*radius))
        return [(x_center + sqrt(randR)*cos(angle)),(y_center + sqrt(randR)*sin(angle))]
    }
}
///非重叠矩形中的随机点
class Solution2 {
    let currentRect:[[Int]]
    let sum:[Int]
    let n:Int
    init(_ rects: [[Int]]) {
        currentRect = rects
        n = rects.count
        var sum = [0]
        //整数点数量前缀和。（找所有数量下覆盖的点的矩形）
        for i in 1...n {
            if let lastData = sum.last {
                let rect = rects[i - 1]
                let temp = (rect[3] - rect[0] + 1) * (rect[2] - rect[1] + 1)
                sum.append(lastData + temp)
            }
        }
        self.sum = sum
    }
    
    func pick() -> [Int] {
        let randomRect = Int.random(in: 0..<sum[n]) + 1
        var left = 0,right = n
        while left < right {
            let mid = (right + left) / 2
            if randomRect <= sum[mid] {
                right = mid
            } else {
                left = mid + 1
            }
        }
        let rect = currentRect[right - 1]
        let x = rect[2] - rect[0] + 1
        let y = rect[3] - rect[1] + 1
        let randX = Int.random(in: 0..<x) + rect[0]
        let randY = Int.random(in: 0..<y) + rect[1]
        return [randX,randY]
    }
}
///. 黑名单中的随机数
class Solution3 {
    let begin:[Int]
    let sum:[Int]
    let n:Int
    init(_ n: Int, _ blacklist: [Int]) {
        var begin = [Int]()
        var sum = [Int]()
        var lasSum = 0
        var beginNUm = 0
        let black = blacklist.sorted()
        for i in 0..<black.count {
            let temp = black[i]
            if temp == beginNUm {
                beginNUm = temp + 1
                continue
            }
            begin.append(beginNUm)
            lasSum += temp - beginNUm
            sum.append(lasSum)
            beginNUm = temp + 1
        }
        if beginNUm < n {
            begin.append(beginNUm)
            lasSum += n - beginNUm
            sum.append(lasSum)
        }
        self.begin = begin
        self.sum = sum
        self.n = n
    }
    
    func pick() -> Int {
        let count = sum.count-1
        let maxSum = sum[count]
        let random = Int.random(in: 1...maxSum)
        var left = 0,right = count
        while left < right {
            let mid = (right - left) >> 1 + left
            if random > sum[mid] {
                left = mid + 1
            } else {
                right = mid
            }
        }
        var lasNum = 0
        if left > 0 {
            lasNum = sum[left - 1]
        }
        let step = random - lasNum
        let begin = begin[left] + step - 1
        return begin
    }
}
