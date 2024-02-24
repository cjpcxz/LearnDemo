//
//  mathLeet_4.swift
//  leetCode
//
//  Created by 陈晶泊 on 2023/8/8.
//

import Foundation
//1749. 任意子数组和的绝对值的最大值
//求最大值和最小值
//
func maxAbsoluteSum(_ nums: [Int]) -> Int {
    let n = nums.count
    var res = nums[0],leftMax = res,leftMin = res
    for i in 1..<n {
        if leftMax > 0 {
            leftMax = nums[i] + leftMax
        } else {
            leftMax = nums[i]
        }
        if leftMin < 0 {
            leftMin = nums[i] + leftMin
        } else {
            leftMin = nums[i]
        }
        res = max(res,leftMax,-leftMin)
    }
    return abs(res)
}

//2682. 找出转圈游戏输家

func circularGameLosers(_ n: Int, _ k: Int) -> [Int] {
    guard n > 1 else {
        return []
    }
    var dp = Array(repeating: 0, count: n),i = 0,cur = 0
    dp[cur] += 1
    while true {
        cur = ((i + 1) * (k % n) % n + cur) % n
        i += 1
        dp[cur] += 1
        if dp[cur] > 1 {
            break
        }
    }
    var res = [Int]()
    res.reserveCapacity(n)
    for i in 0..<n where dp[i] == 0 {
        res.append(i+1)
    }
    return res
}

//56. 合并区间

func merge(_ intervals: [[Int]]) -> [[Int]] {
    let sortArr = intervals.sorted { arr1, arr2 in
        return arr1[0] < arr2[0]
    }
    var begin = -1,end = -1,res = [[Int]]()
    for sA in sortArr {
        if sA[0] > end {
            if end != -1 {
                res.append([begin,end])
            }
            begin = sA[0]
            end = sA[1]
        } else {
            end = max(end,sA[1])
        }
    }
    if end != -1 {
        res.append([begin,end])
    }
    return res
}

//57. 插入区间
/**
 给你一个 无重叠的 ，按照区间起始端点排序的区间列表。

 在列表中插入一个新的区间，你需要确保列表中的区间仍然有序且不重叠（如果有必要的话，可以合并区间）。
 /
 左边小于他的，  右边大于他的
 */
func insert(_ intervals: [[Int]], _ newInterval: [Int]) -> [[Int]] {
    //找到大于target
    var l = -1,r = intervals.count,lsum:Int?,rsum:Int?
    while (lsum == nil||rsum == nil),l < r {
        if lsum == nil {
            if l + 1 < r,newInterval[0] > intervals[l+1][1] {
                //[] []
                l += 1
            } else if l + 1 < r,case intervals[l+1][0]...intervals[l+1][1] = newInterval[0] {
                //在他们中间[[]]
                lsum = intervals[l+1][0]
            } else {
                //[][]
                lsum = newInterval[0]
            }
        }
        
        if rsum == nil {
            if r - 1 > l,newInterval[1] < intervals[r-1][0] {
                // [n] [o]
                r -= 1
            } else if r - 1 > l,case intervals[r-1][0]...intervals[r-1][1] = newInterval[1] {
                // [ [ ] ]
                rsum = intervals[r-1][1]
            } else {
                // [][]
                rsum = newInterval[1]
            }
        }
    }
    var res = [[Int]]()
    if l >= 0 {
        res.append(contentsOf: intervals[0...l])
    }
    if let lsum = lsum,let rsum = rsum {
        res.append([lsum,rsum])
    }
    
    if r < intervals.count {
        res.append(contentsOf: intervals[r..<intervals.count])
    }
    return res
}


//823. 带因子的二叉树
/**
 给出一个含有不重复整数元素的数组 arr ，每个整数 arr[i] 均大于 1。

 用这些整数来构建二叉树，每个整数可以使用任意次数。其中：每个非叶结点的值应等于它的两个子结点的值的乘积。

 满足条件的二叉树一共有多少个？答案可能很大，返回 对 109 + 7 取余 的结果。
 */

func numFactoredBinaryTrees(_ arr: [Int]) -> Int {
    var dpMap = [Int:Int]()
    let sorArr = arr.sorted(),mod = 1000000007,n = sorArr.count
    for a in arr {
        dpMap[a] = 1
    }
    var res = n
    var dp = Array(repeating: 0, count: n)
    for i in 1..<n {
        for j in 0..<i {
            for z in dp[j]..<i where sorArr[j] * sorArr[z] == sorArr[i] {
                let temp = dpMap[sorArr[j]]! * dpMap[sorArr[z]]!
                dpMap[sorArr[i]] = temp + dpMap[sorArr[i]]!
                res = (res + temp) % mod
                dp[j] = z
                break
            }
        }
    }
    return res
}

//2240. 买钢笔和铅笔的方案数

func waysToBuyPensPencils(_ total: Int, _ cost1: Int, _ cost2: Int) -> Int {
    let n = total / cost1 + 1
    var res = 0
    for i in 0..<n {
        res += (total - i * cost1) / cost2 + 1
    }
    return res
}

//1921. 消灭怪物的最大数量
func eliminateMaximum(_ dist: [Int], _ speed: [Int]) -> Int {
    let n = dist.count
    let sorArr: [Int] = Array(0..<n).map { i -> Int in
        (dist[i] / speed[i]) + (dist[i] % speed[i] == 0 ? 0:1)
    }.sorted()
    
    for i in 0..<n where sorArr[i] <= i {
        return i
    }
    return n
}

//2605. 从两个数字数组里生成最小数字

func minNumber(_ nums1: [Int], _ nums2: [Int]) -> Int {
    var numSet = Set<Int>(),min1 = Int.max,min2 = Int.max
    for num in nums1 {
        numSet.insert(num)
        min1 = min(min1,num)
    }
    
    for num in nums2 {
        if numSet.contains(num) {
            min2 =  min1 == min2 ? min(min2,num) : num
            min1 = min2
        } else if min2 != min1 {
            min2 = min(min2,num)
        }
    }
    guard min2 != min1 else {
        return min1
    }
    return min(min1,min2) * 10 + max(min1,min2)
}

//2594. 修车的最少时间
func repairCars(_ ranks: [Int], _ cars: Int) -> Int {
    var l = 1,r = ranks[0] * cars * cars
    while l < r {
        let mid = (r + l) >> 1
        if check(m: mid) {
            r = mid
        } else {
            l = mid + 1
        }
    }
    
    func check(m:Int) -> Bool {
        var cns = 0
        for rank in ranks {
            cns += Int(sqrt(Double(m/rank)))
        }
        return cns >= cars
    }
    return r
}


//LCP 50. 宝石补给
func giveGem(_ gem: [Int], _ operations: [[Int]]) -> Int {
    var maxN = Int.min,minN = Int.max,gem = gem
    for operation in operations {
        let a = operation[0],b = operation[1]
        let chang = gem[a]/2
        gem[a] -= chang
        gem[b] += chang
    }
    for num in gem {
        maxN = max(maxN,num)
        minN = max(minN,num)
    }
    return maxN - minN
}

// 2591. 将钱分给最多的儿童
// 1 1 1 1 1 1
// 8 8 8 8 5 5
func distMoney(_ money: Int, _ children: Int) -> Int {
    guard money >= children else {
        return -1
    }
    var maxN = money / 8,less = money % 8
    while maxN > 0,maxN + less < children {
        maxN -= 1
        less += 8
    }
    
    guard maxN > 0 else {
        return 0
    }
    if less == 4,maxN + 1 == children {
        return maxN - 1
    }
    if maxN > children {
        return children - 1
    }
    return maxN
}

//2582. 递枕头
// 3  2
// 1  2  3  2  1
 
// 2578. 最小和分割
func splitNum(_ num: Int) -> Int {
    var arr = [Int]()
    var num = num
    while num > 0 {
        arr.append(num % 10)
        num = num / 10
    }
    arr.sort()
    var l = 0,r = 0
    for i in stride(from: 0, to: arr.count, by: 2) {
        l = l * 10 + arr[i]
        if i + 1 < arr.count {
            r = r * 10 + arr[i+1]
        }
    }
    return l + r
}
// 2731. 移动机器人
// a b c d
// b - a + c - a + d - a
        // c - b + d - b
                // d - c
// 3 * d + 2 * c + b - 3 * a - 2 * b - 1 * c
func sumDistance(_ nums: [Int], _ s: String, _ d: Int) -> Int {
    let mode = 1000000007
    var res = nums
    for sC in s.enumerated() {
        res[sC.offset] =  (res[sC.offset] + (sC.element == "R" ? +d:-d))
    }
    let n = nums.count
    res.sort()
    var result = 0
    for i in 1..<n {
        // 以i为中心，左边有i ，右边有n-i
       result = (result + (res[i] - res[i-1]) * i % mode * (n-i) * mode) % mode
    }
    return result
}

// 2512. 奖励最顶尖的 K 名学生
// 一开始，每位学生分数为 0 。每个正面的单词会给学生的分数 加 3 分，每个负面的词会给学生的分数 减  1 分。
func topStudents(_ positive_feedback: [String], _ negative_feedback: [String], _ report: [String], _ student_id: [Int], _ k: Int) -> [Int] {
    guard k > 0 else {
        return []
    }
    let posSet = Set<String>(positive_feedback),negSet = Set<String>(negative_feedback)
    
    func studentScore(report: String) -> Int {
        let strArr = report.split(separator: " ")
        var res = 0
        for str in strArr {
            if posSet.contains(String(str)) {
                res += 3
            } else if negSet.contains(String(str)) {
                res -= 1
            }
        }
        return res
    }
    
    let reportArr = report.map { studentScore(report: $0) }
    let idArr = Array(0..<reportArr.count).sorted { i, j in
        if reportArr[i] == reportArr[j] {
            return student_id[i] < student_id[j]
        } else {
            return reportArr[i] > reportArr[j]
        }
    }
    return Array(idArr[0..<k]).map { student_id[$0] }
}

// 2562. 找出数组的串联值
func findTheArrayConcVal(_ nums: [Int]) -> Int {
    var l = -1,r = nums.count
    var res = 0
    while l < r {
        var temp = 0
        l = l + 1
        if l < r {
            temp = nums[l]
        }
        r = r - 1
        if l < r {
            var rN = nums[r]
            while rN > 0 {
                rN = rN / 10
                temp = 10 * temp
            }
            temp += nums[r]
        }
        res += temp
    }
    return res
}


// 1488. 避免洪水泛滥
/*
 [1,0,2,0,2,1]
 0-1    1 2
   1    2
*/
// [1,0,2,0,3,0,2,0,0,0,1,2,3]
func avoidFlood(_ rains: [Int]) -> [Int] {
    let n = rains.count
    var hasSet = [Int:Int]()
    var res = Array(repeating: 1, count: n),zeroH = [Int]()
    for i in 0..<n {
        if rains[i] == 0 {
            if !hasSet.isEmpty {
                zeroH.append(i)
            }
        } else {
            if let last = hasSet[rains[i]] {
                // 已经满了，需要
                guard zeroH.count > 0 else {
                    return []
                }
                guard zeroH.last! > last else {
                    return []
                }
                
                let num = find(l: 0, r: zeroH.count, target: last, arr: zeroH)
                
                res[zeroH[num]] = rains[i]
                zeroH.remove(at: num)
                hasSet[rains[i]] = i
                res[i] = -1
            } else {
                // 没有满
                res[i] = -1
                // 添加
                hasSet[rains[i]] = i
            }
            
        }
        
    }
    
    func find(l:Int,r:Int,target:Int,arr:[Int]) -> Int {
        var l = l,r = r
        while l < r {
            let mid = (l + r) >> 1
            if arr[mid] < target {
                l = mid + 1
            } else {
                r = mid
            }
        }
        return l
    }
    
    return res
}
/**
门电路真值表计算得到
 (00, 01 ,10,00),在遇到 1时的变化，遇到3个相同的，第二项就会变成0，因此可以通过ab,拆开表示
  // 这里 0 代表不同，1代表相同，最终答案时ab中的 b
  00  0   00
  00  1   01
  01  0   01
  01   1   10
  10   0   10
  10   1    00
   真值表，a = ~abx + a~b~x
                     b = ~a~bx + ~ab~x = ~a(b^x)
 */
// 137. 只出现一次的数字 II
// 除某个元素仅出现 一次 外，其余每个元素都恰出现 三次 。请你找出并返回那个只出现了一次的元素。
func singleNumber(_ nums: [Int]) -> Int {
    var a = 0,b = 0
    for num in nums {
        let nexta = (~a & b & num) | (a & ~b & ~num)
        let nextb = ~a & (b ^ num)
        (a,b) = (nexta,nextb)
    }
    return b
}

//给你一个整数数组 nums，其中恰好有两个元素只出现一次，其余所有元素均出现两次。 找出只出现一次的那两个元素。你可以按 任意顺序 返回答案。

// 你必须设计并实现线性时间复杂度的算法且仅使用常量额外空间来解决此问题。

// 260. 只出现一次的数字 III
// [1,2,1,3,2,5]    5 ^ 3   10
func singleNumber2(_ nums: [Int]) -> [Int] {
    var xor = 0
    for num in nums {
        xor ^= num
    }
    var res = [0,0]
    let mask = xor & (-xor)
    for num in nums {
        if mask & num == 1 {
            res[0] ^= num
        } else {
            res[1] ^= num
        }
    }
    return res
}

//1726. 同积元组
// l 1 1 -l > 2
func tupleSameProduct(_ nums: [Int]) -> Int {
    guard nums.count > 3 else {
        return 0
    }
    let nums = nums.sorted(),n = nums.count
    var res = 0,resHas = Set<Int>()
    for i in 0..<n-3 {
        for j in ((i+3)..<n).reversed() where !resHas.contains(nums[i] * nums[j]) {
            let temp = nums[i] * nums[j]
            var li = i+1,ri = j-1,rep = 0
            while li < ri {
                if nums[li] * nums[ri] == temp {
                    rep += 1
                    li += 1
                    ri -= 1
                } else if nums[li] * nums[ri] < temp {
                    li += 1
                } else {
                    ri -= 1
                }
            }
            if rep > 0 {
                res += Array(1...rep).reduce(0) { partialResult, num in
                    return partialResult + num * 8
                }
                resHas.insert(temp)
            }
            
        }
    }
    return res
}

// 1465. 切割后面积最大的蛋糕
func maxArea(_ h: Int, _ w: Int, _ horizontalCuts: [Int], _ verticalCuts: [Int]) -> Int {
    let horizontalCuts = horizontalCuts.sorted(),verticalCuts = verticalCuts.sorted()
    let n = horizontalCuts.count,m = verticalCuts.count,mode = 1000000007
    var maxWidth = 0,maxHeight = 0
    for i in 0...n {
        let cur = i == n ? (h - horizontalCuts[i-1]):(i == 0 ? horizontalCuts[i]:(horizontalCuts[i] - horizontalCuts[i-1]))
        maxHeight = max(maxHeight, cur)
    }
    
    for i in 0...m {
        let cur = i == m ? (w - verticalCuts[i-1]):(i == 0 ? verticalCuts[i]:(verticalCuts[i] - verticalCuts[i-1]))
        maxWidth = max(maxWidth, cur)
    }
    return (maxHeight * maxWidth) % mode
}

//2558. 从数量最多的堆取走礼物
func pickGifts(_ gifts: [Int], _ k: Int) -> Int {
    
    func heapInsert(i:Int,arr:inout [Int],size:Int) {
        var leftX = 2 * i + 1,i = i
        while leftX < size {
            let maxIndex = (leftX + 1 < size && arr[leftX + 1] > arr[leftX]) ? leftX + 1 : leftX
            let changIndex = arr[maxIndex] > arr[i] ? maxIndex:i
            guard changIndex != i else {
                break
            }
            (arr[maxIndex],arr[i]) = (arr[i],arr[maxIndex])
            i = changIndex
            leftX = 2 * i + 1
        }
    }
    
    func heapFind(i:Int,arr:inout [Int]) {
        var i = i
        while arr[i] > arr[(i-1) / 2] {
            (arr[i],arr[(i-1) / 2]) = (arr[(i-1) / 2],arr[i])
            i = (i-1) / 2
        }
    }
    let n = gifts.count
    var heapSort = [gifts[0]]
    for i in 1..<n {
        heapSort.append(gifts[i])
        heapFind(i: i, arr: &heapSort)
    }
    
    
    for _ in 0..<k {
        let temp = heapSort[0]
        guard temp > 1 else {
            return heapSort.count
        }
        heapSort[0] = Int(sqrt(Double(temp)))
        heapInsert(i: 0, arr: &heapSort, size: n)
    }
    
    return heapSort.reduce(0) {$0+$1}
}

// 274. H 指数
func hIndex(_ citations: [Int]) -> Int {
    let citations = citations.sorted(),n = citations.count
    var res = 0
    for i in 1...n {
        res = max(res,min(citations[i],n - i))
    }
    return res
}

// 275. H 指数 II
// citations 已经按照 升序排列 。计算并返回该研究者的 h 指数。
func hIndex2(_ citations: [Int]) -> Int {
    var l = 0,r = citations.count
    while l < r {
        let mid = (r + l) >> 1
        if citations[mid] < citations.count - mid {
            l = mid + 1
        } else {
            r = mid
        }
    }
    return citations.count - l
}


// 2607. 使子数组元素和相等
// [2,5,5,7]
// 12 17 14 14
//func makeSubKSumEqual(_ arr: [Int], _ k: Int) -> Int {
//    
//}

// 2258. 逃离火灾
/**
 [[0,0,0],[2,2,0],[1,2,0]]
 */
func maximumMinutes(_ grid: [[Int]]) -> Int {
    let INF = 1000000000,dirS = [(0,1),(1,0),(-1,0),(0,-1)],m = grid.count,n = grid[0].count
    func fireTime() -> [[Int]] {
        var brfDP = Array(repeating: Array(repeating: INF, count: n), count: m)
        var arr = [(Int,Int)]()
        for i in 0..<m {
            for j in 0..<n where grid[i][j] == 1 {
                arr.append((i,j))
            }
        }
        var time = 0
        while !arr.isEmpty {
            var temp = [(Int,Int)]()
            for ar in arr {
                brfDP[ar.0][ar.1] = time
                for dir in dirS {
                    let x = ar.0 + dir.0,y = ar.1 + dir.1
                    guard case 0..<m = x,
                       case 0..<n = y,
                       brfDP[x][y] == INF,
                       grid[x][y] != 2 else {
                        continue
                    }
                    temp.append((x,y))
                }
            }
            time += 1
            arr = temp
        }
        return brfDP
    }
    
    func check(fireTime:[[Int]],stayTime:Int) -> Bool {
        var arr = [(0,0,stayTime)]
        var visit = Array(repeating: Array(repeating: false, count: n), count: m)
        visit[0][0] = true
        while !arr.isEmpty {
            let cur = arr.removeFirst()
            for i in 0..<4 {
                let x = cur.0 + dirS[i].0,y = cur.1 + dirS[i].1
                guard case 0..<m = x,
                   case 0..<n = y,
                   !visit[x][y],
                   grid[x][y] != 2 else {
                    continue
                }
                if x == m - 1,
                   y == n - 1 {
                    return fireTime[x][y] >= (cur.2 + 1)
                }
                
                if fireTime[x][y] > cur.2 + 1 {
                    arr.append((x,y,cur.2 + 1))
                    visit[x][y] = true
                }
            }
            
        }
        return false
    }
   
    let fireTime = fireTime()
    var l = 0,r = m * n + 1,ans = -1
    while l < r {
        let mid = (l + r) / 2
        if check(fireTime: fireTime, stayTime: mid) {
            ans = mid
            l = mid + 1
        }  else {
            r = mid
        }
    }
    return ans >= m * n ? INF : ans
}

// 2300. 咒语和药水的成功对数
func successfulPairs(_ spells: [Int], _ potions: [Int], _ success: Int) -> [Int] {
    let potions = potions.sorted(),n = spells.count
    func check(target:Int) -> Int {
        var l = 0,r = potions.count
        while l < r {
            let mid = (r + l) / 2
            if target * potions[mid] < success {
                l = mid + 1
            } else {
                r = mid
            }
        }
        return potions.count - l
    }
    var res = Array(repeating: 0, count: n)
    for i in 0..<n {
        res[i] = check(target: spells[i])
    }
    return res
}


//765. 情侣牵手
//  [0,5,2,7,4,3,8,9,6,1]
//
func minSwapsCouples(_ row: [Int]) -> Int {
    
    class UnionFind {
        var parent:[Int]
        var count: Int = 0
        
        init(count: Int) {
            self.count = count
            self.parent = Array(0..<count)
        }
        
        func find(x:Int) -> Int {
            var x = x
            while x != parent[x] {
                parent[x] = parent[parent[x]]
                x = parent[x]
            }
            return x
        }
        
        func union(x:Int,y:Int) {
            let x = find(x: x)
            let y = find(x: y)
            if x == y {
                return
            }
            count -= 1
            parent[x] = y
        }
        
    }
    let len = row.count,N = len / 2
    let unionFind = UnionFind(count: N)
    for i in stride(from: 0, to: len, by: 2) {
        unionFind.union(x: row[i] / 2, y: row[i+1] / 2)
    }
    
    return N - unionFind.count
}
//   [1,1,1,1]
// [0,1,2,3,4]
//   [1,2,1,1]
// [0,1,3,4,5]
// [-1,0,2,3,4]
// 307. 区域和检索 - 数组可修改，树状数组
class NumArray2 {
    
    var tree: [Int]
        var nums: [Int]
        init(_ nums: [Int]) {
            self.nums = nums
            tree = Array(repeating: 0, count: nums.count + 1)
            for i in 0..<nums.count {
               add(x: i+1, u: nums[i])
            }
        }

        func add(x:Int,u:Int) {
            var i = x
            while i <= nums.count {
                tree[i] += u
                i += i & -i
            }
            
        }
        
        func update(_ index: Int, _ val: Int) {
            add(x:index + 1,u:val - nums[index])
            nums[index] = val
        }
        
        func query(x:Int) -> Int {
            var i = x,res = 0
            while i > 0 {
                res += tree[i]
                i -= i & -i
            }
            return res
        }
        
        func sumRange(_ left: Int, _ right: Int) -> Int {
            return query(x: right + 1) - query(x: left)
        }
}


//最长奇偶子数组, 1 0 1 0 1 0 1 0 1 0 10
func longestAlternatingSubarray(_ nums: [Int], _ threshold: Int) -> Int {
    var l = 0,r = 0,res = 1
    while r < nums.count,l < nums.count {
        if nums[l] % 2 == 0,nums[r] <= threshold {
            if r+1 < nums.count,
               nums[r] % 2 != nums[r+1] % 2 {
                r += 1
            } else {
                res = max(r - l + 1,res)
                l = r+1
            }
        } else {
            res = max(r - l + 1,res)
            l = r+1
            r = l
        }
    }
    return res
}

// 1657. 确定两个字符串是否接近
//  3  2  9
//  8  4  4 "uau" "ssx"
func closeStrings(_ word1: String, _ word2: String) -> Bool {
    guard word1.count == word2.count else {
        return false
    }
    var map1 = [Character:Int](),map2 = [Character:Int]()
    for wc in word1 {
        map1[wc] = 1 + (map1[wc] ?? 0)
    }
    for wc in word2 {
        map2[wc] = 1 + (map2[wc] ?? 0)
    }
    return map2.keys.sorted() == map1.keys.sorted() && map2.values.sorted() == map1.values.sorted()
}

/**
 [[5,1],
 [2,4],
 [6,3]]
 [6,2,3,1,4,5]
 */
// func firstCompleteIndex(_ arr: [Int], _ mat: [[Int]]) -> Int {
func firstCompleteIndex(_ arr: [Int], _ mat: [[Int]]) -> Int {
    let m = mat.count,n = mat[0].count
    var row = Array(repeating: n, count: m),
        col = Array(repeating: m, count: n)
    var dp = Array(repeating: 0, count: m * n + 1)
    for i in 0..<m {
        for j in 0..<n {
            dp[mat[i][j]] = n * i + j
        }
    }
    
    for z in 0..<arr.count {
        let i = dp[arr[z]] / n,j = dp[arr[z]] % n
        row[i] -= 1
        col[j] -= 1
        if row[i] == 0 || col[j] == 0 {
            return z
        }
    }
    return arr.count
}

// 1094. 拼车
// 0 <= fromi < toi <= 1000
func carPooling(_ trips: [[Int]], _ capacity: Int) -> Bool {
    var arr = Array(repeating: (0,0), count: 2 * trips.count)
    func heapInset(i:Int) {
        var i = i
        
        while iIsSmall(i: i, j: (i-1)/2) {
            (arr[i],arr[(i-1)/2]) = (arr[(i-1)/2],arr[i])
            i = (i-1)/2
        }
    }
    
    func heapFind(i:Int,len:Int) {
        var i = i,l = 2 * i + 1
        while l < len {
            let smallest = (l + 1 < len && iIsSmall(i: l+1, j: l)) ? l + 1 : l
            guard iIsSmall(i: smallest, j: i) else {
                return
            }
            (arr[i],arr[smallest]) = (arr[smallest],arr[i])
            i = smallest
            l = 2 * i + 1
        }
    }
    
    func iIsSmall(i:Int,j:Int) -> Bool {
        guard arr[i].0 < arr[j].0 else {
            return arr[i].0 == arr[j].0 ? arr[i].1 < arr[j].1 : false
        }
        return true
    }
    
    for i in 0..<trips.count {
        arr[2 * i] = (trips[i][1],trips[i][0])
        heapInset(i: 2 * i)
        arr[2 * i+1] = (trips[i][2],-trips[i][0])
        heapInset(i: 2 * i + 1)
    }
    var res = 0
    for i in 0..<arr.count {
        guard res <= capacity else {
            return false
        }
        res += arr[0].1
        arr[0] = arr[arr.count - 1 - i]
        heapFind(i: 0, len: arr.count - i - 1)
    }
    return true
}


// 1423. 可获得的最大点数
func maxScore(_ cardPoints: [Int], _ k: Int) -> Int {
    let n = cardPoints.count
    var cur = 0
    for i in (n-k)..<n {
        cur += cardPoints[i]
    }
    var res = cur
    for i in (n-k)..<n {
        cur += cardPoints[(i + n) % n] - cardPoints[i]
        res = max(res,cur)
    }
    return res
}


// 1631. 最小体力消耗路径  一条路径耗费的 体力值 是路径上相邻格子之间 高度差绝对值 的 最大值 决定的。请你返回从左上角走到右下角的最小 体力消耗值 。
/**
 [[1,2,3],
 [3,8,4],
 [5,3,5]] dp[i][j] = dp[i-1][j] dp[]
 */
func minimumEffortPath(_ heights: [[Int]]) -> Int {
    let m = heights.count,n = heights[0].count,steps = [(1,0),(0,1),(-1,0),(0,-1)]
    func dfs(midNum:Int,seen: inout [[Bool]]) {
        var queue = [(0,0)]
        seen[0][0] = true
        while !queue.isEmpty {
            let first = queue.removeFirst()
            for step in steps {
                let xn = step.0 + first.0,yn = step.1 + first.1
                if case 0..<m = xn,case 0..<n = yn,
                   abs(heights[first.0][first.1] - heights[xn][yn]) <= midNum,
                   !seen[xn][yn] {
                    seen[xn][yn] = true
                    queue.append((xn,yn))
                }
            }
        }
    }
    
    var l = 0,r = 1000000
    while l < r {
        let mid = (l + r) >> 1
        var seen = Array(repeating: Array(repeating: false, count: n), count: m)
       
        dfs(midNum: mid, seen: &seen)
        if seen[m-1][n-1] { // <=
            r = mid
        } else {
            l = mid + 1
        }
        
    }
    return l
}

// 最短路径算法
func minimumEffortPath2(_ heights: [[Int]]) -> Int {
    let steps = [(1,0),(0,1),(-1,0),(0,-1)],m = heights.count,n = heights[0].count
    var arr = [(0,0,0)],
        dirs = Array(repeating: Array(repeating: 1000000, count: n), count: m),
        seen = Array(repeating: Array(repeating: false, count: n), count: m)
    
    func heapFind(i:Int,arr:inout [(Int,Int,Int)],size:Int) {
        var leftX = 2 * i + 1,i = i
        while leftX < size {
            let minIndex = (leftX + 1 < size && arr[leftX + 1].2 < arr[leftX].2) ? leftX + 1 : leftX
            let changIndex = arr[minIndex].2 < arr[i].2 ? minIndex:i
            guard changIndex != i else {
                break
            }
            (arr[minIndex],arr[i]) = (arr[i],arr[minIndex])
            i = changIndex
            leftX = 2 * i + 1
        }
    }
    
    func heapInsert(i:Int,arr:inout [(Int,Int,Int)]) {
        var i = i
        while arr[i].2 < arr[(i-1) / 2].2 {
            (arr[i],arr[(i-1) / 2]) = (arr[(i-1) / 2],arr[i])
            i = (i-1) / 2
        }
    }
    dirs[0][0] = 0
    while let cur = arr.first {
        let x = cur.0,y = cur.1,d = cur.2
        arr[0] = arr[arr.count-1]
        arr.removeLast()
        heapFind(i: 0, arr: &arr, size: arr.count)
        guard !seen[x][y] else { continue }
        seen[x][y] = true
        if x == m-1,y == n-1 {
            break
        }
        
        for step in steps {
            let xn = step.0 + x,yn = step.1 + y
            if case 0..<m = xn,case 0..<n = yn,
               max(abs(heights[xn][yn] - heights[x][y]),d) < dirs[xn][yn] {
                dirs[xn][yn] = max(abs(heights[xn][yn] - heights[x][y]),d)
                arr.append((xn,yn,dirs[xn][yn]))
                heapInsert(i: arr.count-1, arr: &arr)
            }
        }
    }
    return dirs[m-1][n-1]
}

// 12. 整数转罗马数字
func intToRoman(_ num: Int) -> String {
    let nums = [(1,"I"),(4,"IV"),(5,"V"),(9,"IX"),(10,"X"),(40,"XL"),(50,"L"),(90,"XC"),(100,"C"),(400,"CD"),(500,"D"),(900,"CM"),(1000,"M")]
    //
    func find(l:Int,r:Int,target:Int) -> Int {
        var l = l-1, r = r
        while l + 1 != r {
            let mid = (r+l) >> 1
            if nums[mid].0 <= target {
                l = mid
            } else {
                r = mid
            }
        }
        return l
    }
    var res = num,end = nums.count,str = ""
    while res > 0 {
        let cur = find(l: 0, r: end, target: res)
        end = cur + 1
        str += nums[cur].1
        res -= nums[cur].0
    }
    return str
}

// 2132. 用邮票贴满网格图，二维差分，前缀和
//[1,1,1,1] [1,1,2,2]
//[1,1,0,0,-1] []
//[1,2,3,4]
// https://leetcode.cn/problems/stamping-the-grid/solutions/1/wu-nao-zuo-fa-er-wei-qian-zhui-he-er-wei-zwiu/
func possibleToStamp(_ grid: [[Int]], _ stampHeight: Int, _ stampWidth: Int) -> Bool {
    
    let m = grid.count,n = grid[0].count
    guard m >= stampHeight,n >= stampWidth else {
        for gs in grid {
            for g in gs where g == 0 {
                return false
            }
        }
        return true
    }
    // 计算grid的而且前缀和
    var s = Array(repeating: Array(repeating: 0, count: n+1), count: m+1)
    // 以i,j为矩形，的二维前锥和，0..<i,0..<j
    for i in 0..<m {
        for j in 0..<n {
            // 二维数组的和
            s[i+1][j+1] = s[i+1][j] + s[i][j+1] - s[i][j] + grid[i][j]
        }
    }
    
    // 计算二维差分
    // >= i,j内的数都加上d[i][j]，差分数组 + 2,有个前缀和后缀
    var d = Array(repeating: Array(repeating: 0, count: n+2), count: m+2)
    for i in stampHeight...m {
        for j in stampWidth...n {
            let i1 = i - stampHeight + 1
            let j1 = j - stampWidth + 1
            if s[i][j] - s[i][j1-1] - s[i1-1][j] + s[i1 - 1][j1 - 1] == 0 {
                d[i1][j1] += 1
                d[i1][j+1] -= 1
                d[i + 1][j1] -= 1
                d[i+1][j+1] += 1
            }
        }
    }
    
    // 还原二维差分矩阵对饮的计算矩阵
    for i in 0..<m {
        for j in 0..<n {
            // 前缀求当前值，看是否大于1，差分和前缀和逆向
            d[i+1][j+1] += d[i+1][j] + d[i][j + 1] - d[i][j]
            if grid[i][j] == 0,d[i+1][j+1] == 0 {
                return false
            }
        }
    }
    return true
}

// 162. 寻找峰值,返回任意一个你可以假设 nums[-1] = nums[n] = -∞ 。你必须实现时间复杂度为 O(log n) 的算法来解决此问题。
func findPeakElement(_ nums: [Int]) -> Int {
    var l = 0,r = nums.count - 1
    while l < r {
        let mid = (l + r) >> 1
        if nums[mid] > nums[mid + 1] {
            r = mid
        } else {
            l = mid + 1
        }
    }
    return l
}

// 1901. 寻找峰值 II
/**
 [[10,20,40,50,60,70],
 [1,4,2,3,500,80]]
 */
func findPeakGrid(_ mat: [[Int]]) -> [Int] {
    let m = mat.count
    func findMax(arr:[Int]) -> Int {
        var index = 0,max = 0
        for element in arr.enumerated() where element.element > max {
            index = element.offset
            max = element.element
        }
        return index
    }
    var l = 0,r = m
    while l < r {
        let mid = (l + r) >> 1
        let maxI = findMax(arr: mat[mid])
        if mid + 1 < m,mat[mid][maxI] < mat[mid + 1][maxI] {
            l = mid + 1
        } else {
            r = mid
        }
    }
    return [l,findMax(arr: mat[l])]
}

// 34. 在排序数组中查找元素的第一个和最后一个位置
func searchRange(_ nums: [Int], _ target: Int) -> [Int] {
    func find(l:Int,r:Int,target:Int) -> Int {
        var l = l,r = r
        while l < r {
            let mid = (l + r) >> 1
            if nums[mid] < target {
                l = mid + 1
            } else {
                r = mid
            }
        }
        return l
    }
    let begin = find(l: 0, r: nums.count, target: target)
    guard case 0..<nums.count = begin,
          nums[begin] == target else {
        return [-1,-1]
    }
    let end = find(l:begin+1,r:nums.count,target: target + 1)
    return [begin,end-1]
}

// 2866. 美丽塔 II [6,5,3,9,2,7],
func maximumSumOfHeights(_ maxHeights: [Int]) -> Int {
    let n = maxHeights.count
    var pre = Array(repeating: 0, count: n),suf = Array(repeating: 0, count: n)
    pre[0] = maxHeights[0]
    var queue = [0]
    for i in 1..<n {
        while let last = queue.last,maxHeights[last] > maxHeights[i] {
            queue.removeLast()
        }
        if let last = queue.last {
            pre[i] = pre[last] + (i - last) * maxHeights[i]
        } else {
            pre[i] = (i + 1) * maxHeights[i]
        }
        queue.append(i)
    }
    var res = 0
    queue = [Int]()
    for i in (0..<n).reversed() {
        while let last = queue.last,maxHeights[last] > maxHeights[i] {
            queue.removeLast()
        }
        if let last = queue.last {
            suf[i] = suf[last] + (last - i) * maxHeights[i]
        } else {
            suf[i] = (n - i) * maxHeights[i]
        }
        res = max(res,suf[i] + pre[i] - maxHeights[i])
        queue.append(i)
    }
    return res
}

// 1671. 得到山形数组的最少删除次数
func minimumMountainRemovals(_ nums: [Int]) -> Int {
    func getListArray(nums:[Int]) -> [Int] {
        let n = nums.count
        var dp = Array(repeating: 1, count: n)
        for i in 1..<n {
            for j in 0..<i where nums[i] > nums[j] {
                dp[i] = max(dp[i],dp[j] + 1)
            }
        }
        return dp
    }
    
    let pre = getListArray(nums: nums)
    let suf:[Int] = getListArray(nums: nums.reversed()).reversed()
    var res = 0
    for i in 0..<nums.count where pre[i] > 1 && suf[i] > 1 {
        res = max(res,pre[i] + suf[i] - 1)
    }
    return nums.count - res
}

// 1962. 移除石子使总数最小
func minStoneSum(_ piles: [Int], _ k: Int) -> Int {
    
    func heapInset(i: Int) {
        var i = i
        while tree[(i - 1) / 2] < tree[i] {
            (tree[(i - 1) / 2],tree[i]) = (tree[i],tree[(i - 1) / 2])
            i = (i - 1) / 2
        }
    }
    
    func heapFind(i:Int,size:Int) {
        var i = i,l = 2 * i + 1
        while l < size {
            let begI = l + 1 < size && tree[l+1] > tree[l] ? l + 1 : l
            guard tree[begI] > tree[i] else {
                return
            }
            (tree[begI],tree[i]) = (tree[i],tree[begI])
            i = begI
            l = 2 * i + 1
        }
    }
    let n = piles.count
    var tree = Array(repeating: 0, count: n),res = 0
    for i in 0..<n {
        tree[i] = piles[i]
        res += piles[i]
        heapInset(i: i)
    }
    
    for i in 0..<k {
        let temp = tree[0] / 2
        tree[0] -= temp
        res -= temp
        heapFind(i: 0, size: n)
    }
    return res
}

// 1954. 收集足够苹果的最小花园周长
/**
 (1 + 2) * 2 * 5 * 2   + 1 * 2 * 3* 2
(1 + 2 + 3 + n) * 2 * (2 * n + 1) * 2
(n + 1) * n  * (2 * n + 1) * 2
 res = 2 * n  * 4
 // 1 <= neededApples <= 10^15
 */
func minimumPerimeter(_ neededApples: Int) -> Int {
    
    func appletNum(n:Int) -> Int {
        return (n + 1) * n * (2 * n + 1) * 2
    }
    var l = 1,r = 100000
    while l < r {
        let mid = (l + r) >> 1
        if appletNum(n: mid) < neededApples {
            l = mid + 1
        } else {
            r = mid
        }
    }
    return 2 * l * 4
}

// 1276. 不浪费原料的汉堡制作方案
/**
 x + y = cheeseSlices
 4 * (x)  + 2 * (cheeseSlices - x) = tomatoSlices
 2 * x + 2 * cheeseSlices = tomatoSlices
 */
func numOfBurgers(_ tomatoSlices: Int, _ cheeseSlices: Int) -> [Int] {
    let cur = tomatoSlices - 2 * cheeseSlices
    guard cur >= 0,cur % 2 == 0 else {
        return []
    }
    let big = cur / 2
    guard big <= cheeseSlices else {
        return []
    }
    return [big,cheeseSlices - big]
}

// 1349. 参加考试的最大学生数
/**
 给你一个 m * n 的矩阵 seats 表示教室中的座位分布。如果座位是坏的（不可用），就用 '#' 表示；否则，用 '.' 表示。
 dp[i] = dp[i-1] & f(i)  ,f(i) + dp[i-2]
 1 0 0 0 1 0         010010   2
 1 1 1 1 1 1
 0 1 0 0 1 0
 */
//
func maxStudents(_ seats: [[Character]]) -> Int {
    let m = seats.count,n = seats[0].count
    var dp = Array(repeating: Array(repeating: 0, count: 1 << n), count: 2)
    for i in 0..<m {
        let row = i % 2
        for s in 0..<(1 << n) {
            var isOk = true
            // 当前行是否可用
            for j in 0..<n where ((s & (1 << j) > 0) && seats[i][j] == "#") || !isNoBetween(s: s,last: s){
                isOk = false
                break
            }
            guard isOk else {
                dp[row][s] = -1
                continue
            }
            // 判断上一行是否可用
            let num = s.nonzeroBitCount
            for last in 0..<(1 << n) where dp[1 - row][last] != -1 && isNoBetween(s: s,last: last) {
                dp[row][s] = max(dp[row][s],dp[1-row][last] + num)
            }
            
        }
    }

    func isNoBetween(s:Int,last:Int) -> Bool {
        guard (s << 1) & last == 0,(s >> 1) & last == 0 else {
            return false
        }
        return true
    }
    
    var res = 0
    for num in dp[(m-1) % 2] where num > res {
        res = num
    }
    return res
}

// 2660. 保龄球游戏的获胜者
func isWinner(_ player1: [Int], _ player2: [Int]) -> Int {
    let n = player1.count
    var l1 = 0,l2 = 0,n1 = 0,n2 = 0
    for i in 0..<n {
        l1 += (n1 > 0 ? 2:1) * player1[i]
        l2 += (n2 > 0 ? 2:1) * player2[i]
        n1 -= 1;n2 -= 1
        if player1[i] == 10 {
            n1 = 2
        }
        if player2[i] == 10 {
            n2 = 2
        }
    }
    guard l1 > l2 else {
        return l1 == l2 ? 0:2
    }
    return 1
}

// 2735. 收集巧克力
// [20,1,15],[1,2,0] 2
// [0,1,2,3]
// [1, 2, 3],times, timesNum
func minCost(_ nums: [Int], _ x: Int) -> Int {
    let n = nums.count
    var f = nums,res = nums.reduce(0){ $0 + $1 }
    for i in 1..<n {
        for j in 0..<n {
            f[j] = min(f[i],nums[(j+i) % n])
        }
        res = min(res,i * x + f.reduce(0){ $0 + $1 })
    }
    return res
}

func dayOfTheWeek(_ day: Int, _ month: Int, _ year: Int) -> String {
        let res = ["Sunday","Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
        var month = month,year = year
        if month == 1 || month == 12 {
            month += 12
            year -= 1
        }
        //基姆拉尔森计算
        let days = (day + 2 * month + 3 * (month + 1) / 5 + year + year / 4 - year / 100 + year / 400 + 1 ) % 7
        return res[days]
    }

//1154. 一年中的第几天
func dayOfYear(_ date: String) -> Int {
    let arr = date.split(separator: "-").compactMap { Int($0) }
    guard arr.count == 3 else {
        return 0
    }
    
    
    let month = [31,28,31,30,31,30,31,31,30,31,30,31]
    var res = arr[2]
    for i in 0..<(arr[1] - 1) {
        res += month[i]
    }
    guard arr[1] > 2 else {
        return res
    }
    return res + (((arr[0] % 4 == 0 && arr[0] % 100 != 0) || arr[0] % 400 == 0) ? 1:0)
}

// 2397. 被列覆盖的最多行数1 <= m, n <= 12
/**
 [[0,0,0],
 [1,0,1],
 [0,1,1],
 [0,0,1]]
 101
 1 0 1
 */
func maximumRows(_ matrix: [[Int]], _ numSelect: Int) -> Int {
    let rows = matrix.map { arr in
        var index = 0
        for i in 0..<arr.count where arr[i] == 1 {
            index |= 1 << i
        }
        return index
    }
    let m = matrix.count,n = matrix[0].count
    var res = 0
    for i in 1..<(1 << n) where i.nonzeroBitCount == numSelect {
        res = max(res,rows.reduce(0, { partialResult, num in
            guard (num - num & i) == 0 else {
                return partialResult
            }
            return partialResult + 1
        }))
    }
    return res
}

// 1944. 队列中可以看到的人数
// [1,10,2,6,8,5,20,9] 每个位置离右边最近的小
// [3,1,2,1,1,0]
// (5,5) (20,20)
//[0,1,1,1,2,1,4,1]
//  [1,4,1,1,2,1,1,0]
//  [10,6,8,5,11,9]
//  8 (5,5) (11,5)
// [3,1,2,1,1,0]
func canSeePersonsCount(_ heights: [Int]) -> [Int] {
    let n = heights.count
    var res = [0],queue:[(Int,Int)] = [(heights[n-1],heights[n-1])]
    for i in (0..<n-1).reversed() {
        var time = 0
        for qs in queue.reversed() {
            if qs.1 != qs.0,qs.1 > heights[i] {
                break
            }
            time += 1
            if qs.0 > heights[i] {
                break
            }
        }
        
        while let last = queue.last,last.0 < heights[i] {
            queue.removeLast()
            if !queue.isEmpty,queue[queue.count - 1].1 > last.1 {
                queue[queue.count - 1].1 = last.1
            }
        }
        queue.append((heights[i],heights[i]))
        res.append(max(1,time))
    }
    return res.reversed()
}

// 447. 回旋镖的数量1 2 3 4   1
func numberOfBoomerangs(_ points: [[Int]]) -> Int {
    func pLength(p1:(Int,Int),p2:(Int,Int)) -> Int {
        return (p1.0-p2.0) * (p1.0-p2.0) + (p1.1-p2.1) * (p1.1-p2.1)
    }
     
    let n = points.count
    var sideDict = Array(repeating: [Int:Int](), count: points.count)
    for i in 0..<(n-1) {
        let p1 = points[i]
        for j in (i+1)..<n {
            let p2 = points[j]
            let cur = pLength(p1: (p1[0],p1[1]), p2: (p2[0],p2[1]))
            sideDict[i][cur] = (sideDict[i][cur] ?? 0) + 1
            sideDict[j][cur] = (sideDict[j][cur] ?? 0) + 1
        }
    }
    var res = 0
    for sidD in sideDict {
        for sv in sidD.values { //以它为顶，有相同的变
            res += sv * (sv - 1)
        }
    }
    return res
}

// 2719. 统计整数数目
/**
 num1 <= x <= num2
 min_sum <= digit_sum(x) <= max_sum.
 请你返回好整数的数目。答案可能很大，请返回答案对 109 + 7 取余后的结果。
 190
 19
 注意，digit_sum(x) 表示 x 各位数字之和。11 (digit_sum(x) ) 2
 // 求出1 -- min_sum-1   和1 -- max_sum
 状态 d[i][j]表示还剩第 i 位到第 0位的数字未填.已填数位之后是j
 
 1 <= min_sum <= max_sum <= 400
 1 <= num1 <= num2 <= 10^22..数字过大，不能转Int
 */
func count(_ num1: String, _ num2: String, _ min_sum: Int, _ max_sum: Int) -> Int {
    let mod = 1000000007
    var dp = Array(repeating: Array(repeating: -1, count: 401), count: 23)
    var num = [Int]()
    
    func get(nums: [Int]) -> Int {
        num = nums.reversed()
        return dfs(i: nums.count - 1, j: 0, limit: true)
    }
    
    func sub(num:String) -> [Int] {
        var nums = Array(num).compactMap {Int(String($0))}
        var i = nums.count - 1
        while nums[i] == 0 {
            i-=1
        }
        nums[i] -= 1
        for j in (i+1)..<num.count {
            nums[j] = 9
        }
        return nums
    }
    
    
    func dfs(i:Int,j:Int,limit:Bool) -> Int {
        guard j <= max_sum else {
            return 0
        }
        
        guard i > -1 else {
            return j >= min_sum ? 1:0
        }
        if !limit && dp[i][j] != -1 {
            return dp[i][j]
        }
        var res = 0
        let up = limit ? num[i]:9
        for x in 0...up {
            res = (res + dfs(i: i-1, j: j+x, limit: limit && (x == up))) % mod
        }
        if !limit {
            dp[i][j] = res
        }
        return res
    }
    return ((get(nums: Array(num2).compactMap {Int(String($0))}) - get(nums: sub(num: num1))) + mod) % mod
}

// 2171. 拿出最少数目的魔法豆
func minimumRemoval(_ beans: [Int]) -> Int {
    let sordArr = beans.sorted(),n = beans.count
    var preArr = Array(repeating: 0, count: n + 1)
    for i in 1...n {
        preArr[i] = sordArr[i-1] + preArr[i-1]
    }
    var res = Int.max
    for i in 0..<n {
        let left = preArr[i],right = preArr[n] - preArr[i+1] - (n - i - 1) * sordArr[i]
        res = min(res,left + right)
    }
    return res
}


// 2809. 使数组和小于等于 x 的最少时间
/**
 给你两个长度相等下标从 0 开始的整数数组 nums1 和 nums2 。每一秒，对于所有下标 0 <= i < nums1.length ，nums1[i] 的值都增加 nums2[i] 。操作 完成后 ，你可以进行如下操作：

 选择任一满足 0 <= i < nums1.length 的下标 i ，并使 nums1[i] = 0 。
 同时给你一个整数 x 。

 请你返回使 nums1 中所有元素之和 小于等于 x 所需要的 最少 时间，如果无法实现，那么返回 -1 。
 //按增长最慢的来，遍历nums2.sort
 dp[i][j]是到i为止，操作J次，减少的最大值，J <= i
 1. 第i为不操作作，第i位操作
 dp[i][j] = max(dp[i-1][j],dp[i-1][j-1] + nums2[arr[i]] * i + nums1[arr[i]])
 */
func minimumTime(_ nums1: [Int], _ nums2: [Int], _ x: Int) -> Int {
    let n = nums1.count
    // nums2遍历，拿到nums2变化最慢的
    let arr = Array(0..<n).sorted { nums2[$0] < nums2[$1] }
    
    var dp = Array(repeating: Array(repeating: 0, count: n+1), count: n+1)
    for i in 1...n {
        let index = arr[i-1]
        for j in 1...i {
            dp[i][j] = max(dp[i-1][j],dp[i-1][j-1] + j * nums2[index] + nums1[index])
        }
    }
    let s1 = nums1.reduce(0, {$0+$1}),s2 = nums2.reduce(0, {$0+$1})
    for i in 0...n where s1 + s2 * i - dp[n][i] <= x { //满足小于x的最小值
        return i
    }
    
    return -1
}

//410. 分割数组的最大值
// 到i为止，分成k个的最大值的最小值
// 还可以用二分法，加贪心，left是，所有的最大值，right是所有之和
//1. max(dp[i-1][j],arr[i-1] + 前z个和,从z从第i-1...j的范围的，最小指
//dp[i][j] = min(1,2)
func splitArray(_ nums: [Int], _ k: Int) -> Int {
    let n = nums.count
    // 前i个数，分割为j段所得到的最大连续子数组和的最小值
    var dp = Array(repeating: Array(repeating: Int.max, count: k+1), count: n+1)
    var sub = Array(repeating: 0, count: n+1)
    for i in 1...n {
       sub[i] = sub[i-1] + nums[i-1]
       dp[i][1] = sub[i]
    }
    guard k > 1 else {
        return  dp[n][1]
    }
    
    for i in 2...n {
        for j in 2...min(i,k) { // 前i个数能分割最大的情况
            for z in (j-1)..<i { // 考虑,不包括前j-1个节点,以当前第j个节点开始是最后第i个小组的情况
                //sub[i] - sub[z] z j-1到i，即为j-1 。。。 i的节点之和
                dp[i][j] = min(dp[i][j],max(dp[z][j-1],sub[i] - sub[z]))
            }
        }
    }
    
    return dp[n][k]
}

// 范围内求值，考虑最大和最小值，在求解
// 二分法求解，最小是最大值，最大是和
func splitArray2(_ nums: [Int], _ k: Int) -> Int {
    var left = 0,right = 0
    for num in nums {
        right += num
        if num > left {
            left = num
        }
    }
    func checkNum(tag:Int) -> Bool {
        var cnt = 1,sum = 0
        for num in nums {
            if sum + num >= tag {
                sum = num
                cnt += 1
            } else {
                sum += num
            }
        }
        return cnt <= k
    }
    
    while left < right {
        let mid = (right + left) >> 1
        if checkNum(tag: mid) {
            right = mid
        } else {
            
            left = mid + 1
        }
    }
    return left

}

//33. 搜索旋转排序数组
func search(_ nums: [Int], _ target: Int) -> Int {
    var l = 0,r = nums.count-1
    while l <= r {
        let mid = (l+r) >> 1
        if nums[mid] == target {
            return mid
        } else if nums[mid] < nums[l] { //mid...r有序，mid在旋转的右边
            if nums[mid] < target,target <= nums[r] { //在有序的右边，否则，就在左边
                l = mid + 1
            } else {
                r = mid - 1
            }
        } else { // l...mid有序
            if nums[mid] > target,target >= nums[l] {
                r = mid - 1
            } else {
                l = mid + 1
            }
        }

    }
    return -1
}

// 153. 寻找旋转排序数组中的最小值
func findMin(_ nums: [Int]) -> Int {
    var l = 0,r = nums.count - 1
    while l <= r {
        let mid = (l + r) >> 1
        if nums[mid] < nums[r] { //否则在右边升序，最小值在左边
            r = mid
        } else { //否则在左边边升序
            l = mid + 1
        }
    }
    return nums[r]
}

// 2765. 最长交替子数组
// [6,7,6,5,6]
func alternatingSubarray(_ nums: [Int]) -> Int {
    var res = -1,nextN = true,last = 1
    for i in 1..<nums.count {
        let temp = nums[i] - nums[i-1]
        if abs(temp) == 1 {//
            let curN = temp > 0
            if curN == nextN {
                last += 1
                nextN = !curN
            } else if curN {
                res = max(res,last)
                last = 2
                nextN = !curN
            } else {
                res = max(res,last)
                last = 1
                nextN = true
            }
        } else {
            res = max(res,last)
            last = 1
            nextN = true
        }
    }
    
    res = max(last,res)
    return res == 1 ? -1:res
}

// 2865. 美丽塔 I
/**
 给你一个长度为 n 下标从 0 开始的整数数组 maxHeights 。

 你的任务是在坐标轴上建 n 座塔。第 i 座塔的下标为 i ，高度为 heights[i] 。

 如果以下条件满足，我们称这些塔是 美丽 的：

 1 <= heights[i] <= maxHeights[i]
 heights 是一个 山脉 数组。
 如果存在下标 i 满足以下条件，那么我们称数组 heights 是一个 山脉 数组：

 对于所有 0 < j <= i ，都有 heights[j - 1] <= heights[j]
 对于所有 i <= k < n - 1 ，都有 heights[k + 1] <= heights[k]
 请你返回满足 美丽塔 要求的方案中，高度和的最大值 。
单调栈
 */
func maximumSumOfHeights2(_ maxHeights: [Int]) -> Int {
    let n = maxHeights.count
    // 从左到右递增的情况，满足j的情况下
    var leftArr = Array(repeating: 0, count: n)
    var maxQueue = [Int]()
    for i in 0..<n {
        // 单调栈 单调栈中比maxHeights大的可以直接等于maxHeights，会直接到比他小的
        /**
            第一个比他小，则加上当前的值，加上上一个的值
         */
        while let last = maxQueue.last,maxHeights[last] > maxHeights[i] {
            maxQueue.removeLast()
        }
        if let last = maxQueue.last {
            leftArr[i] = leftArr[last] + (i-last) * maxHeights[i]
        } else {
            leftArr[i] = (i+1) * maxHeights[i]
        }
        maxQueue.append(i)
    }
    maxQueue = [Int]()
    var rightArr = Array(repeating: 0, count: n),res = 0
    for i in (0..<n).reversed() {
       
        while let last = maxQueue.last,maxHeights[last] > maxHeights[i] {
            maxQueue.removeLast()
        }
        if let last = maxQueue.last {
            rightArr[i] = rightArr[last] + (last - i) * maxHeights[i]
        } else {
            rightArr[i] = (n - i) * maxHeights[i]
        }
        maxQueue.append(i)
        res = max(res,rightArr[i] + leftArr[i] - maxHeights[i])
    }
    return res
}

// 2859. 计算 K 置位下标对应元素的和
//1 <= nums.length <= 1000
func sumIndicesWithKSetBits(_ nums: [Int], _ k: Int) -> Int {
    var res = 0
    func isAvailable(num: Int) -> Bool {
        var num = num
        // 分治思想
        // 右移，将两两的1进行了想加
        num = (num & 0b0101010101) + (num & 0b1010101010) >> 1
        // 将两个4位上的1进行了想加
        num = (num & 0b0011001100) >> 2 + (num & 0b1100110011)
        num = (num >> 8) + (num & 0b1111) + (num >> 4) & 0b1111
        return num == k
    }
    for i in 0..<nums.count where isAvailable(num: i) {
        res += nums[i]
    }
    return res
}


// 2861. 最大合金数，二分法实现
/**
 假设你是一家合金制造公司的老板，你的公司使用多种金属来制造合金。现在共有 n 种不同类型的金属可以使用，并且你可以使用 k 台机器来制造合金。每台机器都需要特定数量的每种金属来创建合金。

 对于第 i 台机器而言，创建合金需要 composition[i][j] 份 j 类型金属。最初，你拥有 stock[i] 份 i 类型金属，而每购入一份 i 类型金属需要花费 cost[i] 的金钱。

 给你整数 n、k、budget，下标从 1 开始的二维数组 composition，两个下标从 1 开始的数组 stock 和 cost，请你在预算不超过 budget 金钱的前提下，最大化 公司制造合金的数量。

 所有合金都需要由同一台机器制造。

 返回公司可以制造的最大合金数。
 1 <= composition[i][j] <= 100
 stock.length == cost.length == n
 0 <= stock[i] <= 108
 1 <= cost[i] <= 100
 */
func maxNumberOfAlloys(_ n: Int, _ k: Int, _ budget: Int, _ composition: [[Int]], _ stock: [Int], _ cost: [Int]) -> Int {
    var l = 0,r = ( budget / cost.min()!) + stock.min()!
    func isAvailable(num:Int) -> Bool {
        for com in composition {
            var res = 0
            for i in 0..<com.count {
                res += max(0,(num * com[i]  - stock[i]) * cost[i])
            }
            if res <= budget {
                return true
            }
        }
        return false
    }
    var res = 0
    while l <= r {
        let mid = (l + r) >> 1
        if isAvailable(num: mid) {
            l = 1 + mid
            res = mid
        } else {
            r = mid - 1
        }
    }
    return res
}

//365. 水壶问题
/**
 有两个水壶，容量分别为 jug1Capacity 和 jug2Capacity 升。水的供应是无限的。确定是否有可能使用这两个壶准确得到 targetCapacity 升。

 如果可以得到 targetCapacity 升水，最后请用以上水壶中的一或两个来盛放取得的 targetCapacity 升水。

 你可以：

 装满任意一个水壶
 清空任意一个水壶
 从一个水壶向另外一个水壶倒水，直到装满或者倒空
 3  5  4

 2 另一个 0 或者满
 1 另一个0或者满
 
 11  3  13
8 3
 
13 11 1
   9 4
 */
func canMeasureWater(_ jug1Capacity: Int, _ jug2Capacity: Int, _ targetCapacity: Int) -> Bool {
    guard jug1Capacity + jug2Capacity >= targetCapacity else {
        return false
    }
    func GCD(num1:Int,num2:Int) -> Int {
        var n1 = num1,n2 = num2
        while n2 != 0 {
            (n1,n2) = (n2,n1 % n2)
        }
        return n1
    }
    if jug1Capacity == 0 || jug2Capacity == 0 {
        return targetCapacity == 0 || jug1Capacity + jug2Capacity == targetCapacity
    }
    return targetCapacity % GCD(num1: jug1Capacity, num2: jug2Capacity) == 0
}


//2808. 使循环数组所有元素相等的最少秒数
/**
 给你一个下标从 0 开始长度为 n 的数组 nums 。

 每一秒，你可以对数组执行以下操作：

 对于范围在 [0, n - 1] 内的每一个下标 i ，将 nums[i] 替换成 nums[i] ，nums[(i - 1 + n) % n] 或者 nums[(i + 1) % n] 三者之一。
 注意，所有元素会被同时替换。

 请你返回将数组 nums 中所有元素变成相等元素所需要的 最少 秒数。
 // 计算没个数字的影响范围
 */
func minimumSeconds(_ nums: [Int]) -> Int {
    let n = nums.count
    var dic = [Int:[Int]]()
    for i in 0..<n {
        dic[nums[i]] = (dic[nums[i]] ?? []) + [i]
    }
    var res = Int.max
    for v in dic.values {
        var mx = v.first! + n - v.last!
        if v.count > 1 {
            for i in 1..<v.count {
                mx = max(mx,v[i] - v[i-1])
            }
        }
        res = min(res,mx/2)
    }
    return res
}

/*
 2670. 找出不同元素数目差数组
 
 给你一个下标从 0 开始的数组 nums ，数组长度为 n 。

 nums 的 不同元素数目差 数组可以用一个长度为 n 的数组 diff 表示，其中 diff[i] 等于前缀 nums[0, ..., i] 中不同元素的数目 减去 后缀 nums[i + 1, ..., n - 1] 中不同元素的数目。

 返回 nums 的 不同元素数目差 数组。

 注意 nums[i, ..., j] 表示 nums 的一个从下标 i 开始到下标 j 结束的子数组（包含下标 i 和 j 对应元素）。特别需要说明的是，如果 i > j ，则 nums[i, ..., j] 表示一个空子数组*/
func distinctDifferenceArray(_ nums: [Int]) -> [Int] {
    let n = nums.count
    var arr = Array(repeating: 0, count: n)
    var set = Set<Int>()
    for i in 0..<n {
        set.insert(nums[i])
        arr[i] = set.count
    }
    set = []
    var res = Array(repeating: 0, count: n)
    for i in (0..<n).reversed() {
        res[i] = arr[i] - set.count
        set.insert(nums[i])
    }
    return res
}

// 46. 全排列
/**
 给定一个不含重复数字的数组 nums ，返回其 所有可能的全排列 。你可以 按任意顺序 返回答案。

1 2 3 4
 4 * 3
 12
 6 4
 // 全排列
 */
func permute(_ nums: [Int]) -> [[Int]] {
    var res = [[Int]]()
    func permute(arr:inout [Int],i:Int,m:Int) {
        if i == m {
            res.append(arr)
        }
        
        for j in i..<m {
            (arr[j],arr[i]) = (arr[i],arr[j])
            permute(arr: &arr, i: i+1, m: m)
            (arr[j],arr[i]) = (arr[i],arr[j])
        }
    }
    var arr = nums
    permute(arr: &arr, i: 0, m: nums.count)
    return res
}

//73. 矩阵置零
/**
 给定一个 m x n 的矩阵，如果一个元素为 0 ，则将其所在行和列的所有元素都设为 0 。请使用 原地 算法。
 */
func setZeroes2(_ matrix: inout [[Int]]) {
    let m = matrix.count,n = matrix[0].count
    var col0 = false,row0 = false
    for i in 0..<m where matrix[i][0] == 0 {
        col0 = true
    }
    for i in 0..<n where matrix[0][i] == 0 {
        row0 = true
    }
    
    for i in 1..<m {
        for j in 1..<n where matrix[i][j] == 0 {
            matrix[i][0] = 0
            matrix[0][j] = 0
        }
    }
    for i in 1..<m {
        for j in 1..<n where matrix[i][0] == 0 || matrix[0][j] == 0 {
            matrix[i][j] = 0
        }
    }
    if col0 {
        for i in 0..<m {
            matrix[i][0] = 0
        }
    }
    
    if row0 {
        for i in 0..<n {
            matrix[0][i] = 0
        }
    }
    
}

//47. 全排列 II
/**
 给定一个可包含重复数字的序列 nums ，按任意顺序 返回所有不重复的全排列。
 [[0,0,0,1,9],[0,0,0,9,1],[0,0,1,0,9],[0,0,1,9,0],[0,0,9,0,1],[0,0,9,1,0],[0,1,0,0,9],[0,1,0,9,0],[0,1,9,0,0],[0,9,0,0,1],[0,9,0,1,0],[0,9,1,0,0],[1,0,0,0,9],[1,0,0,9,0],[1,0,9,0,0],[1,9,0,0,0],[9,0,0,0,1],[9,0,0,1,0],[9,0,1,0,0],[9,1,0,0,0]]
 
 [[0,0,0,1,9],[0,0,0,9,1],[0,0,1,0,9],[0,0,1,9,0],[0,0,9,1,0],[0,0,9,0,1],[0,1,0,0,9],[0,1,0,9,0],[0,1,9,0,0],[0,9,0,1,0],[0,9,0,0,1],[0,9,1,0,0],[0,9,0,1,0],[0,9,0,0,1],[1,0,0,0,9],[1,0,0,9,0],[1,0,9,0,0],[1,9,0,0,0],[9,0,0,1,0],[9,0,0,0,1],[9,0,1,0,0],[9,0,0,1,0],[9,0,0,0,1],[9,1,0,0,0],[9,0,0,1,0],[9,0,0,0,1],[9,0,1,0,0],[9,0,0,1,0],[9,0,0,0,1]]
 */
func permuteUnique(_ nums: [Int]) -> [[Int]] {
    let n = nums.count
    var res = [[Int]]()
    func permuteUnique(_ arr: inout [Int],i:Int) {
        guard i < n else {
            res.append(arr)
            return
        }
        var set = Set<Int>()
        for j in i..<n where set.contains(arr[j]){
            set.insert(arr[j])
            (arr[j],arr[i]) = (arr[i],arr[j])
            permuteUnique(&arr, i: i+1)
            (arr[j],arr[i]) = (arr[i],arr[j])
        }
    }
    var arr = nums
    permuteUnique(&arr, i: 0)
    return res
}

// 3014. 输入单词需要的最少按键次数 I
/**
 给你一个字符串 word，由 不同 小写英文字母组成。

 电话键盘上的按键与 不同 小写英文字母集合相映射，可以通过按压按键来组成单词。例如，按键 2 对应 ["a","b","c"]，我们需要按一次键来输入 "a"，按两次键来输入 "b"，按三次键来输入 "c"。

 现在允许你将编号为 2 到 9 的按键重新映射到 不同 字母集合。每个按键可以映射到 任意数量 的字母，但每个字母 必须 恰好 映射到 一个 按键上。你需要找到输入字符串 word 所需的 最少 按键次数。

 返回重新映射按键后输入 word 所需的 最少 按键次数。

 下面给出了一种电话键盘上字母到按键的映射作为示例。注意 1，*，# 和 0 不 对应任何字母。
 */
func minimumPushes(_ word: String) -> Int {
    let n = word.count,k = n / 8
    return (4 * k + (n % 8)) * (k + 1)
}

// 80. 删除有序数组中的重复项 II
func removeDuplicates(_ nums: inout [Int]) -> Int {
    var l = -1,last = nums[0],time = 1
    for i in 1..<nums.count {
        if last == nums[i] {
            time += 1
        } else {
            time = 1
        }
        if time == 3,l == -1 {
            l = i
        }
        if l > 0,time < 3 {
            nums[l] = nums[i]
            l += 1
        }
        last = nums[i]
    }
    return l == -1 ? nums.count:l
}

//134. 加油站
/**
 在一条环路上有 n 个加油站，其中第 i 个加油站有汽油 gas[i] 升。

 你有一辆油箱容量无限的的汽车，从第 i 个加油站开往第 i+1 个加油站需要消耗汽油 cost[i] 升。你从其中的一个加油站出发，开始时油箱为空。

 给定两个整数数组 gas 和 cost ，如果你可以按顺序绕环路行驶一周，则返回出发时加油站的编号，否则返回 -1 。如果存在解，则 保证 它是 唯一 的。
 [1,2,3,4,5]
 [3,4,5,1,2]
 -2,-2,8, -2,3,3
 
2 3 4
 
3 4 3
 */
func canCompleteCircuit(_ gas: [Int], _ cost: [Int]) -> Int {
    let n = gas.count
    var l = 0,r = 0,res = 0,i = 0
    repeat {
        res += gas[i] - cost[i]
        if res < 0 {
            l = (l - 1 + n) % n
            i = l
        } else {
            r = (r + 1 + n) % n
            i = r
        }
    } while l != r
    return res >= 0 ? l: -1
}
