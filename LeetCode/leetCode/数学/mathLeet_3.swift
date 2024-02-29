//
//  mathLeet_3.swift
//  leetCode
//
//  Created by 陈晶泊 on 2023/4/16.
//

import Foundation

class MajorityChecker {
    let loc:[Int:[Int]]
    let arr:[Int]
    let k = 20
    
    init(_ arr: [Int] = [1,1,1,1,1,1,1]) {
        var loc = [Int:[Int]]()
        for i in 0..<arr.count {
            loc[arr[i]] = (loc[arr[i]] ?? []) + [i]
        }
        self.arr = arr
        self.loc = loc
    }

    //[left,right] map[r]- l[l-1]
    func query(_ left: Int, _ right: Int, _ threshold: Int) -> Int {
        let lenth = right - left + 1
        for _ in 0..<k {
            let x = arr[Int.random(in: left...right)]
            let pos = loc[x]!
            let occ = searchEnd(pos: pos, tag: right) - searchStrat(pos: pos, tag: left)
            if occ >= threshold {
                return x
            } else if occ * 2 >= lenth {
                return -1
            }
        }
        return -1
    }
    
    func searchEnd(pos:[Int],tag:Int) -> Int {
        var l = 0,r = pos.count
        while l < r {
            let mid = (r - l) / 2 + l
            if pos[mid] <= tag {
                l = 1 + mid
            } else {
                r = mid
            }
        }
        return l
    }
    
    func searchStrat(pos:[Int],tag:Int) -> Int {
        var l = 0,r = pos.count
        while l < r {
            let mid = (r - l) / 2 + l
            if pos[mid] < tag {
                l = 1 + mid
            } else {
                r = mid
            }
        }
        return l
    }
    
    
}



//1043. 分隔数组以得到最大和
func maxSumAfterPartitioning(_ arr: [Int], _ k: Int) -> Int {
    var dp = Array(repeating: 0, count: arr.count+1)
    for i in 1...arr.count {
        var maxValue = arr[i-1]
        var j = i-1
        while i - j <= k,j >= 0 {
            
            dp[i] = max(dp[i],dp[j] + maxValue * (i-j))
            if j > 0 { maxValue = max(maxValue,arr[j-1]) }
            j-=1
        }
    }
    return dp[arr.count]
}

//1187. 使数组严格递增
func makeArrayIncreasing(_ arr1: [Int], _ arr2: [Int]) -> Int {
    let arr2 = Array(Set<Int>(arr2)).sorted()
    
    let n = arr1.count,m = arr2.count
    var dp = Array(repeating: Array(repeating: Int.max, count: min(n,m) + 1), count: n+1)
    dp[0][0] = -1
    for i in 1...n {
        for j in 0...(min(i,m)) {
            if arr1[i-1] > dp[i-1][j] {
                dp[i][j] = arr1[i-1]
            }
            if j > 0 && dp[i-1][j-1] != Int.max {
                //查找严格大于 dp[i-1][j-1]的最小值
                let idx = binarySearch(l: j-1, tagert: dp[i-1][j-1])
                if idx !=  m {
                    dp[i][j] = min(dp[i][j],arr2[idx])
                }
            }
            if i == n && dp[i][j] != Int.max {
                return j;
            }
        }
    }
    
    
    func binarySearch(l:Int,r:Int = arr2.count,tagert:Int) ->Int {
        var l = l,r = r
        while l < r {
            let mid = (r - l) >> 1 + l
            if arr2[mid] > tagert {
                r = mid
            } else {
                l = mid + 1
            }
        }
        return l
    }
    return -1
}

//二分法
func search1(_ nums: [Int], _ target: Int) -> Int {
    var l = -1,r = nums.count
    while l+1 != r {
        let mid = (r - l) >> 1 + l
        if nums[mid] > target {
            r = mid
        } else {
            l = mid
        }
    }
    guard l >= 0 else {
        return -1
    }
    return nums[l] != target ? -1:l
}

//1027. 最长等差数列
func longestArithSeqLength(_ nums: [Int]) -> Int {
    func maxSeqL(i:Int) -> Int {
        guard i < nums.count else {
            return 0
        }
        var res = 2
        for j in (i+1)..<nums.count {
            let space = nums[j] - nums[i]
            var d = 2
            for z in (j+1)..<nums.count where nums[z] - nums[i] == d * space {
                d += 1
            }
            res = max(res,i)
        }
        return res
    }
    
    var res = 0
    for i in 0..<nums.count {
        if i + res >= nums.count {
            return res
        }
        res = max(maxSeqL(i: i),res)
    }
    return res
}
//动态规划
func longestArithSeqLength2(_ nums: [Int]) -> Int {
    let maxv = nums.max()!
    let minv = nums.min()!
    let diff = maxv - minv
    var res = 1
    for d in (-diff)...diff {
        var dp = Array(repeating: -1, count: maxv+1)
        for num in nums {
            let prev = num - d
            if case minv...maxv = prev,dp[prev] != -1 {
                dp[num] = max(dp[prev] + 1,dp[num])
                res = max(res,dp[num])
            }
            dp[num] = max(dp[num],1)
        }
    }
    return res
}

//1105. 填充书架
//前i个数，最小层数
func minHeightShelves(_ books: [[Int]], _ shelfWidth: Int) -> Int {
    let n = books.count
    var dp = Array(repeating: 1000000, count: n+1)
    dp[0] = 0
    for i in 0..<n {
        var maxHeight = 0,curWidth = 0
        for j in (0..<(i+1)).reversed() {
            curWidth += books[j][0]
            if curWidth > shelfWidth {
                break
            }
            maxHeight = max(maxHeight,books[j][1])
            dp[i+1] = min(dp[i+1],dp[j] + maxHeight)
        }
    }
    
    return dp[n]
}

//2418. 按身高排序
func sortPeople(_ names: [String], _ heights: [Int]) -> [String] {
    Array(0..<heights.count).sorted{heights[$0] > heights[$1]}.map{names[$0]}
}

//1031. 两个非重叠子数组的最大和
func maxSumTwoNoOverlap(_ nums: [Int], _ firstLen: Int, _ secondLen: Int) -> Int {
    let n = nums.count
    guard firstLen + secondLen < n else {
        return nums.reduce(0){$0 + $1}
    }
    //前i项
    var preSum = Array(repeating: 0, count: n+1)
    //第一项目，从i结尾处的最大值,不包括i
    var firstPreMax = Array(repeating: 0, count: n+1)
    //以0开始的，包括i
    var firstSufMax = Array(repeating: 0, count: n+1)
    for i in 1...n {
        preSum[i] = preSum[i-1] + nums[i-1]
        if i >= firstLen {
            firstPreMax[i] = max(preSum[i] - preSum[i-firstLen],firstPreMax[i-1])
        }
    }
    //0,1,2..n-firstlen,包括i
    for i in (0...(n-firstLen)).reversed() {
        firstSufMax[i] = max(preSum[i+firstLen] - preSum[i],firstSufMax[i+1])
    }
    
    var res = 0
    for i in secondLen...n {
        var first = 0
        if i - secondLen >= firstLen {
            first = max(first,firstPreMax[i-secondLen])
        }
        
        if n - i >= firstLen {
            first = max(first,firstSufMax[i])
        }
        res = max(res,preSum[i]-preSum[i-secondLen] + first)
    }
    
    return res
    
}


//2106. 摘水果
func maxTotalFruits(_ fruits: [[Int]], _ startPos: Int, _ k: Int) -> Int {
    var leftPos = Array(repeating: 0, count: k+2)
    var rightPos = Array(repeating: 0, count: k+2)
    let n = fruits.count
    let curIndex = binarySearch(left: 0, right: n, target: startPos)
    var l = fruits[curIndex][0] > startPos ? curIndex - 1:curIndex
    var r = curIndex
    for i in 1...(k + 1) {
        rightPos[i] = rightPos[i-1]
        leftPos[i] = leftPos[i-1]
        if r < n,startPos + i - 1 == fruits[r][0] {
            rightPos[i] = fruits[r][1] + rightPos[i-1]
            r += 1
        }
        
        if l > -1,startPos - i + 1 == fruits[l][0] {
            leftPos[i] = fruits[l][1] + leftPos[i-1]
            l -= 1
        }
    }
    
    func binarySearch(left:Int,right:Int,target:Int) -> Int {
        var l = left,r = right,mid = (right - left) >> 1 + left
        while l < r {
            mid = (r - l) >> 1 + l
            if fruits[mid][0] >= target {
                r = mid
            } else {
                l = mid + 1
            }
        }
        guard case left..<right = l else {
            return l < left ? left:right-1
        }
        return l
    }
    var res = max(leftPos.last!,rightPos.last!)
    guard k > 0 else {
        return res
    }
    for i in 1...k/2 {
        //最长右r，k = i + i + r,k = r + r + i
        r = max(k-2*i,(k-i) / 2)
        res = max(res,leftPos[i+1] + rightPos[r + 1] - rightPos[1])
    }
    return res
}

//2432. 处理用时最长的那个任务的员工
func hardestWorker(_ n: Int, _ logs: [[Int]]) -> Int {
    var res = (0,0),last = 0
    for log in logs {
        if res.0 < (log[1] - last) {
            res = (log[1] - last,log[0])
        } else if res.0 == (log[1] - last) {
            res.1 = min(res.1,log[0])
        }
        last = log[1]
    }
    return res.1
}

//1419. 数青蛙
//croakOfFrogs 不是由若干有效的 "croak" 字符混合而成返回 -1
func minNumberOfFrogs(_ croakOfFrogs: String) -> Int {
    let chars = Array(croakOfFrogs)
    var tag = Array(repeating: 0, count: 5)
    guard chars[0] == "c" else {
        return -1
    }
    tag[0] = 1
    for j in 1..<chars.count {
        let i = numIndex(char: chars[j])
        if i == 0 {
            if tag.last != 0 {
                //同一只青蛙
                tag = tag.map{$0-1}
            }
            tag[i] += 1
        } else {
            guard tag[i-1] > tag[i] else {
                return -1
            }
           tag[i] += 1
        }
    }
    
    
    func numIndex(char:Character) -> Int {
        switch char {
        case "c":return 0
        case "r":return 1
        case "o":return 2
        case "a":return 3
        case "k":return 4
        default:
            return 0
        }
    }
    return tag.first == tag.last ? tag.first!:-1
}


//1010. 总持续时间可被 60 整除的歌曲
// 得到所有的余数，再进行计算
func numPairsDivisibleBy60(_ time: [Int]) -> Int {
    var cnt = Array(repeating: 0, count: 60)
    for t in time {
        cnt[t % 60] += 1
    }
    
    var res = cnt[0] * (cnt[0] - 1) / 2 + cnt[30] * (cnt[30] - 1) / 2
    for i in 1..<30 {
        res += cnt[i] * cnt[60 - i]
    }
    return res
}



func smallestRepunitDivByK(_ k: Int) -> Int {
    guard k % 2 != 0 else {
        return -1
    }
    var res = 1 % k,i = 1
    var hasSet = Set<Int>()
    while res != 0 {
        res = (res * 10 + 1) % k
        i += 1
        guard !hasSet.contains(res) else {
            return -1
        }
        hasSet.insert(res)
    }
    return i
}


func queryString(_ s: String, _ n: Int) -> Bool {
    for i in (n/2 + 1)...n where !s.contains(String(i,radix: 2)){
        return false
    }
    var i = n
    while i > n / 2 {
        if !s.contains(String(i,radix: 2)) {
            return false
        }
        i -= 1
    }
    return true
}

//2441. 与对应负数同时存在的最大正整数
func findMaxK(_ nums: [Int]) -> Int {
    let sorNums = nums.sorted()
    var l = 0,r = nums.count-1
    while l < r {
        let temp = sorNums[l] + sorNums[r]
        if temp == 0 {
            return sorNums[r]
        } else if temp > 0 {
            r -= 1
        } else {
            l -= 1
        }
    }
    return -1
}


//1054. 距离相等的条形码
//6 3 0 1 2 3 4 5 6 7 8 9 10 11 12
// 0 1 2 3 4  5(2 * i + 1) % 6
// 0 1 2 4 5 6 ,7
// 0 2 4 6
func rearrangeBarcodes(_ barcodes: [Int]) -> [Int] {
    var map = [Int:Int]()
    for barcode in barcodes {
        map[barcode] = (map[barcode] ?? 0) + 1
    }
    let sorArr = map.keys.sorted{ map[$0]! > map[$1]!}
    let n = barcodes.count,mod = n % 2 == 0 ? 1:0
    var arr = Array(repeating: 0, count: n),z = 0,last = map[sorArr[z]]!
    for i in 0..<n {
        last -= 1
        if 2 * i < n {
            arr[2 * i] = sorArr[z]
        } else {
            arr[(2 * i + mod) % n] = sorArr[z]
        }
        if last == 0,z+1 < sorArr.count {
            z = z + 1
            last = map[sorArr[z]]!
        }
        
    }
    return arr
}

//1072. 按列翻转得到最大值等行数
func maxEqualRowsAfterFlips(_ matrix: [[Int]]) -> Int {
    var res = 0
    var map = [String:Int]()
    let m = matrix.count,n = matrix[0].count
    for i in 0..<m {
        var key1 = "",key2 = ""
        for j in 0..<n {
            if matrix[i][j] == 0 {
                key1 += "_\(j)"
            } else {
                key2 += "_\(j)"
            }
        }
        map[key1] = (map[key1] ?? 0) + 1
        map[key2] = (map[key2] ?? 0) + 1
        res = max(map[key1]!,map[key2]!,res)
    }
    return res
    
}

//1335. 工作计划的最低难度
/**
 你需要制定一份 d 天的工作计划表。工作之间存在依赖，要想执行第 i 项工作，你必须完成全部 j 项工作（ 0 <= j < i）。

 你每天 至少 需要完成一项任务。工作计划的总难度是这 d 天每一天的难度之和，而一天的工作难度是当天应该完成工作的最大难度。

 给你一个整数数组 jobDifficulty 和一个整数 d，分别代表工作难度和需要计划的天数。第 i 项工作的难度是 jobDifficulty[i]。

 返回整个工作计划的 最小难度 。如果无法制定工作计划，则返回 -1 。
 */
func minDifficulty(_ jobDifficulty: [Int], _ d: Int) -> Int {
    let n = jobDifficulty.count
    guard n >= d else {
        return -1
    }
    var dp = Array(repeating: Array(repeating: d * 1000, count: n), count: d)
    var ma = 0
    for i in 0..<n {
        ma = max(ma,jobDifficulty[i])
        dp[0][i] = ma
    }
    for i in 1..<d {
        for j in i..<n {
            ma = 0
            for k in (i...j).reversed() {
                ma = max(ma,jobDifficulty[k])
                dp[i][j] = min(dp[i][j],ma + dp[i-1][k-1])
            }
        }
    }
       
    return dp[d-1][n-1]
}
//空间优化
func minDifficulty1(_ jobDifficulty: [Int], _ d: Int) -> Int {
    let n = jobDifficulty.count
    guard n >= d else {
        return -1
    }
    var dp = Array(repeating: 0, count: n)
    var ma = 0
    for i in 0..<n {
        ma = max(ma,jobDifficulty[i])
        dp[i] = ma
    }
    for i in 1..<d {
        var ndp = Array(repeating: d * 1000, count: n)
        for j in i..<n {
            ma = 0
            for k in (i...j).reversed() {
                ma = max(ma,jobDifficulty[k])
                ndp[j] = min(ndp[j],ma + dp[k-1])
            }
        }
        dp = ndp
    }
       
    return dp[n-1]
}

//1073. 负二进制数相加
// 1111 111
//    0    -1
func addNegabinary(_ arr1: [Int], _ arr2: [Int]) -> [Int] {
    var res = [Int](),last = 0,cur = 0
    let m = arr1.count,n = arr2.count
    let b = min(m,n)
    for i in 1...b {
        let temp = (i % 2 == 0 ? -1:1) * (arr1[m-i] + arr2[n-i]) + last
        cur = temp % 2
        last = temp / 2
        res.insert(abs(cur), at: 0)
    }
    let maxArr = m > n ? arr1:arr2
    for i in 1..<(maxArr.count-b+1) {
        let temp = ((i + b) % 2 == 0 ? -1:1) * maxArr[maxArr.count - i - b] + last
        cur = temp % 2
        last = temp / 2
        res.insert(abs(cur), at: 0)
    }
    if last != 0 {
        if maxArr.count % 2 == 0 {
            //下一个是偶数
            return last > 0 ? [1] + res:[1] + res
        } else {
            //下一个是奇数数
            return last > 0 ? [1,1] + res:[1] + res
        }
    }
    for i in 0..<res.count where res[i] != 0 {
        return Array(res[i..<res.count])
    }
    return [0]
}

//LCP 33. 蓄水
func storeWater(_ bucket: [Int], _ vat: [Int]) -> Int {
    let n = bucket.count
    let maxK = vat.max()!
    guard maxK > 0 else {
        return 0
    }
    var res = Int.max
    for k in 1...maxK {
        guard k < res else {
            break
        }
        var t = k
        for i in 0..<n {
           t += max(0,(vat[i] + k - 1)/k - bucket[i])
        }
        res = min(res,t)
        
    }
    return res
}

func largestValsFromLabels(_ values: [Int], _ labels: [Int], _ numWanted: Int, _ useLimit: Int) -> Int {
    let n = values.count
    let sortValues = Array(0..<n).sorted { values[$0] > values[$1] }
    var map = [Int:Int](),res = 0,index = 0
    for i in sortValues  {
        let temp = map[labels[i]] ?? 0
        if temp < useLimit {
            map[labels[i]] = temp + 1
            res += values[i]
            index += 1
        }
        if index == numWanted {
            return res
        }
    }
    return res
}

func oddString(_ words: [String]) -> String {
    func charNum(char1:Character,char2:Character) -> Int {
        return Int(UnicodeScalar(String(char1))!.value) - Int(UnicodeScalar(String(char2))!.value)
    }
    
    let arr = words.map{Array($0)}
    let n = arr.count,m = arr[0].count
    var last = 0,diff = -1,time = 0
    for i in 0..<m {
        last = charNum(char1: arr[0][i+1], char2: arr[0][i])
        time = 1
        for j in 1..<n {
            if charNum(char1: arr[j][i+1], char2: arr[j][i]) == last {
                time += 1
            } else {
                diff = j
            }
            
        }
        if time < n {
            return time == 1 ? words[0]:words[diff]
        }
    }
    return words[0]
}


//1091. 二进制矩阵中的最短路径
func shortestPathBinaryMatrix(_ grid: [[Int]]) -> Int {
    let m = grid.count,n = grid[0].count
    let modes = [(1,0),(-1,0),(0,1),(0,-1),(1,1),(-1,-1),(1,-1),(-1,1)]
    var tempGrid = grid
    guard tempGrid[0][0] == 0,tempGrid[m-1][n-1] == 0 else {
        return -1
    }
    tempGrid[0][0] = 1
    var res = [(0,0)],times = 1
    while tempGrid[m-1][n-1] == 0,!res.isEmpty {
        var tempArr = [(Int,Int)]()
        for temp in res {
            for mode in modes {
                if case 0..<m = mode.0 + temp.0
                    ,case 0..<n = mode.1 + temp.1
                    , tempGrid[mode.0 + temp.0][mode.1 + temp.1] == 0 {
                    tempGrid[mode.0 + temp.0][mode.1 + temp.1] = 1
                    tempArr.append((mode.0 + temp.0,mode.1 + temp.1))
                }
            }
        }
        times += 1
        res = tempArr
    }
    return tempGrid[m-1][n-1] == 0 ? -1:times
}

//1093. 大样本统计

func sampleStats(_ count: [Int]) -> [Double] {
    let n = count.count
    var l = 0,r = n - 1,mode = (0,0),sum = 0,lt = 0,rt = 0
    var res = [Double]()
    while l < r {
        while l < r,count[l] == 0 {
            l += 1
        }
        
        while l < r,count[r] == 0 {
            r -= 1
        }
        if res.isEmpty {
            res.append(Double(l))
            if l != r {
                res.append(Double(r))
            }
            
        }
        if mode.1 < count[l] {
            mode = (l,count[l])
        }
        lt += count[l]
        sum += count[l] * l
        if l != r {
            rt += count[r]
            sum += count[r] * r
            if mode.1 < count[r] {
                mode = (r,count[r])
            }
        }
        
    }
    res.append(Double(sum) / Double(lt + rt))
    var temp = (rt - lt) / 2
    while temp != 0 {
        if temp > 0 {
            l += 1
            temp  = max(0,temp-count[l])
        } else {
            l -= 1
            temp  = max(0,temp+count[l])
        }
    }
    res.append(Double(l))
    res.append(Double(mode.0))
    return res
}

//1439. 有序矩阵中的第 k 个最小数组和
func kthSmallest(_ mat: [[Int]], _ k: Int) -> Int {
    func heapInsert(heap:inout [[Int]],i:Int) {
        var j = i
        while heap[(j-1)/2][2] > heap[j][2] {
            (heap[j],heap[(j-1)/2]) = (heap[(j-1)/2],heap[j])
            j = (j-1)/2
        }
    }
    
    func heapFind(heap:inout [[Int]],i:Int) {
        var j = i
        var temp = 2 * j + 1
        while case 0..<heap.count = temp {
            let minN = temp + 1 < heap.count && heap[temp+1][2] < heap[temp][2] ? temp + 1:temp
            if heap[minN][2] > heap[j][2] {
                return
            }
            (heap[j],heap[minN]) = (heap[minN],heap[j])
            j = minN
            temp = 2 * j + 1
        }
    }
    
    func merge(f:[Int],g:[Int]) -> [Int] {
        if g.count > f.count {
            return merge(f: g, g: f)
        }
        var queueMid = [[Int]]()
        for z in 0..<g.count {
            queueMid.append([0,z,f[0] + g[z]])
        }
        var res = [Int]()
        var temp = k
        while temp > 0,!queueMid.isEmpty {
            let entry = queueMid[0]
            queueMid[0] = queueMid.last!
            queueMid.removeLast()
            res.append(entry[2])
            heapFind(heap: &queueMid, i: 0)
            if entry[0] + 1 < f.count {
                queueMid.append([entry[0] + 1,entry[1],f[entry[0] + 1] + g[entry[1]]])
                heapInsert(heap: &queueMid, i: queueMid.count-1)
            }
            temp -= 1
        }
        return res
        
    }
    let m = mat.count
    var pre = mat[0]
    for i in 1..<m {
        pre = merge(f: pre, g: mat[i])
    }
    return pre[k-1]
}

//1130. 叶值的最小代价生成树
func mctFromLeafValues(_ arr: [Int]) -> Int {
    let n = arr.count
    var dp = Array(repeating: Array(repeating: Int.max/4, count: n), count: n)
    var maval = Array(repeating: Array(repeating: 0, count: n), count: n)
    for i in 0..<n {
        maval[i][i] = arr[i]
        dp[i][i] = 0
        for j in (0..<i).reversed() {
            maval[j][i] = max(arr[i],maval[j+1][i])
            for k in j..<i {
                dp[j][i] = min(dp[j][i],dp[j][k] + dp[k+1][i] + maval[j][k] * maval[k+1][i])
            }
        }
    }
    return dp[0][n-1]
}

//2517. 礼盒的最大甜蜜度

//二分排序。竟然用的二分发
/**
 给你一个正整数数组 price ，其中 price[i] 表示第 i 类糖果的价格，另给你一个正整数 k 。

 商店组合 k 类 不同 糖果打包成礼盒出售。礼盒的 甜蜜度 是礼盒中任意两种糖果 价格 绝对差的最小值。

 返回礼盒的 最大 甜蜜度。
 */
func maximumTastiness(_ price: [Int], _ k: Int) -> Int {
    let sortArr = price.sorted()
    var l = 0,r = sortArr.last!-sortArr.first!
    while l < r {
        let mid = (r + l) / 2
        if check(tag: mid) {
            l = mid + 1
        } else {
            r = mid
        }
    }
    
    func check(tag:Int) -> Bool {
        var prev = Int.min / 2
        var cnt = 0
        for num in sortArr {
            if (num - prev >= tag) {
                cnt += 1
                prev = num
            }
            
        }
        return cnt >= k
    }
    return l
}


func distinctAverages(_ nums: [Int]) -> Int {

    func sortAverage(left:Int,right:Int,nums:inout [Int]) {
        guard right - left > 1 else {
            //中间有数
            return
        }
        var l = left,r = right,i = left+1
        let mid = nums[i]
        while i < r {
            if nums[i] < mid {
                l += 1
                (nums[l],nums[i]) = (nums[i],nums[l])
                i += 1
            } else if nums[i] == mid {
                i += 1
            } else {
                r -= 1
                (nums[r],nums[i]) = (nums[i],nums[r])
            }
        }
        sortAverage(left: left, right: l+1, nums: &nums)
        sortAverage(left: r-1, right: right, nums: &nums)
    }
    var sorNums = nums
    sortAverage(left: -1, right: sorNums.count, nums: &sorNums)
    var set = Set<Double>(),l = 0,r = sorNums.count-1
    while l < r {
        set.insert(Double(sorNums[l] + sorNums[r])/2.0)
        l += 1
        r -= 1
    }
    return set.count
}

//2460. 对数组执行操作
func applyOperations(_ nums: [Int]) -> [Int] {
    let n = nums.count
    var res = Array(repeating: 0, count: n),j = 0,i = 0
    while i < n - 1 {
        if nums[i] != 0,nums[i] == nums[i+1] {
            res[j] = 2 * nums[i]
            j += 1
            i += 1
        } else if nums[i] != 0 {
            res[j] = nums[i]
            j += 1
        }
        i += 1
    }
    if i < n { res[j] = nums[i] }
    return res
}

//2352. 相等行列对
func equalPairs(_ grid: [[Int]]) -> Int {
    let n = grid.count
    var hasSet = [[Int]:Int]()
    for i in 0..<n {
        hasSet[grid[i]] = (hasSet[grid[i]] ?? 0) + 1
    }
    var res = 0
    for i in 0..<n {
        let keyArr = Array(0..<n).map{ grid[$0][i] }
        if let num = hasSet[keyArr] {
            res += num
        }
        
    }
    return res
}

//2611. 老鼠和奶酪
//[1,1,3,4], reward2 = [4,4,1,1], k = 2
// -3 -3 2 3
func miceAndCheese(_ reward1: [Int], _ reward2: [Int], _ k: Int) -> Int {
    let n = reward1.count
    var res = 0,minA = Array(repeating: 0, count: n)
    for i in 0..<n {
        res += reward2[i]
        minA[i] = reward1[i] - reward2[i]
    }
    minA.sort()
    for i in 1...(k + 1) {
        res += minA[n-i]
    }
    return res
}

//2475. 数组中不等三元组的数目
//  1 2 3   2 1
// 1 2 3 4  3 2 1
func unequalTriplets(_ nums: [Int]) -> Int {
    var res = 0
    let sorArr = nums.sorted(),n = nums.count
    var i = 0,j = 0
    while i < n {
        while j < n,sorArr[i] == sorArr[j] {
            j += 1
        }
        res += i * (j-i) * (n-j)
        i = j
    }
    return res
}


func numTimesAllBlue(_ flips: [Int]) -> Int {
    var lastMax = 0,res = 0
    for i in 0..<flips.count {
        lastMax = max(lastMax,flips[i])
        if i + 1 == lastMax {
            res += 1
        }
    }
    return res
}

//2481. 分割圆的最少切割次数
func numberOfCuts(_ n: Int) -> Int {
    guard n > 1 else {
        return 0
    }
    guard n % 2 != 0 else {
        return n / 2
    }
    return n
}

//1262. 可被三整除的最大和
func maxSumDivThree(_ nums: [Int]) -> Int {
    let sorNum = nums.sorted()
    var arr = Array(repeating: [Int](), count: 3),res = 0
    for i in 0..<sorNum.count {
        switch sorNum[i] % 3  {
        case 1:
            arr[1].append(i)
            break
        case 2:
            arr[2].append(i)
            break
        default:
            break
        }
        res += sorNum[i]
    }
    let change = res % 3
    guard change > 0 else {
        return res
    }
    // 1 1 22 2 11 2
    
    switch change {
    case 0:
        return res
    case 1:
        var temp = Int.max
        if arr[1].count > 0 {
            temp = sorNum[arr[1][0]]
        }
        if arr[2].count > 1 {
            temp = min(sorNum[arr[2][0]] + sorNum[arr[2][1]],temp)
        }
        return res - temp
    case 2:
        var temp = Int.max
        if arr[1].count > 1 {
            temp = sorNum[arr[1][0]] + sorNum[arr[1][1]]
        }
        if arr[2].count > 0 {
            temp = min(sorNum[arr[2][0]],temp)
        }
        return res - temp
    default:
        return res
    }
    
}

//1401. 圆和矩形是否有重叠
// (y - y1)2 + (x - x1)2 = rad
//x = x1 x2 y = y1 y2
//1, 1, 1, 1, -3, 2, -1
func checkOverlap(_ radius: Int, _ xCenter: Int, _ yCenter: Int, _ x1: Int, _ y1: Int, _ x2: Int, _ y2: Int) -> Bool {
    var dist  = 0
    if xCenter < x1 || xCenter > x2 {
     dist += min((x1 - xCenter) * (x1 - xCenter), (x2 - xCenter) * (x2 - xCenter));
    }
    if yCenter < y1 || yCenter > y2 {
        dist += min((y1 - yCenter) * (y1 - yCenter),(y2 - yCenter) * (y2 - yCenter));
    }
    return dist <= radius * radius
}

//2485. 找出中枢整数
func pivotInteger(_ n: Int) -> Int {
    var l = 1,r = n + 1
    while l < r {
        let mid = (r + l) >> 1
        if (1 + mid) * mid < (mid + n) * (n-mid+1) {
            l = mid + 1
        } else {
            r = mid
        }
    }
    if l <= n,(1 + l) * l == (l + n) * (n-l+1) {
        return l
    }
    return -1
}

//1186. 删除一次得到子数组最大和
// [1,-2,-2,3]  -2 -2

func maximumSum(_ arr: [Int]) -> Int {
    guard arr.count > 1 else {
        return arr.first!
    }
    let n = arr.count
    
    func maxR(j:Int) -> (Int,Int) {
        var r = 0,maxSum = Int.min,last = 0
        for i in j..<n {
            last += arr[i]
            if last > maxSum {
                maxSum = last
                r = i
            }
        }
        return (r,maxSum)
    }
    
    func maxL(j:Int) -> (Int,Int) {
        var r = 0,maxSum = Int.min,last = 0
        for i in (0..<(j+1)).reversed() {
            last += arr[i]
            if last > maxSum {
                maxSum = last
                r = i
            }
        }
        return (r,maxSum)
    }
    
    var preArrMax = Array(repeating: 0, count: n) // 以这个开始最大的值
    var sufArrMax = Array(repeating: 0, count: n) // 以这个结束最大的值
    var r = 0,i = 0,res = Int.min
    while i < n {
        let temp = maxR(j: i)
        r = temp.0
        var maxS = temp.1
        for z in i...r{
            res = max(res,maxS)
            preArrMax[z] = maxS
            maxS -= arr[z]
            
        }
        i = r + 1
    }
    var l = n-1
    i = l
    while i >= 0 {
        let temp = maxL(j: i)
        l = temp.0
        var maxS = temp.1
        for z in (l...i).reversed(){
            res = max(res,maxS)
            sufArrMax[z] = maxS
            maxS -= arr[z]
            
        }
        i = l - 1
    }
    for i in 0..<n where arr[i] < 0 {
        res = max(res,(i>0 ? sufArrMax[i-1] : 0) + (i < n-1 ? preArrMax[i+1]:0))
    }
    return res
}

//动态规划，求以i结尾的最大值
// dp[i][0] = max(0,dp[i-1][0]) + arr[i]
// dp[i][1] = max(dp[i-1][1] + arr[i],dp[i-1][0])
func maximumSum1(_ arr: [Int]) -> Int {
   var dp0 = arr[0],dp1 = 0,res = dp0
    for i in 1..<arr.count {
        dp1 = max(dp1+arr[i],dp0)
        dp0 = max(0,dp0) + arr[i]
        res = max(res,dp0,dp1)
    }
    return res
}


//1253. 重构 2 行二进制矩阵
func reconstructMatrix(_ upper: Int, _ lower: Int, _ colsum: [Int]) -> [[Int]] {
    let n = colsum.count
    var arr = Array(repeating: Array(repeating: 0, count: n), count: 2),upper = upper,lower = lower,less = 0
    for i in 0..<n {
        switch colsum[i] {
        case 1:less += 1
        case 2:
            upper -= 1
            lower -= 1
            arr[0][i] = 1
            arr[1][i] = 1
        default:break
        }
    }
    guard lower >= 0,upper >= 0,less == lower + upper else {
        return []
    }
    var l = 0,r = n-1
    while l <= r,upper > 0 {
        if colsum[l] == 1 {
            arr[0][l] = 1
            upper -= 1
        }
        l += 1
    }
    
    while l <= r,lower > 0 {
        if colsum[r] == 1 {
            arr[1][r] = 1
            lower -= 1
        }
        r -= 1
    }
    guard upper == 0,lower == 0 else {
        return []
    }
    return arr
}

//2679. 矩阵中的和
func matrixSum(_ nums: [[Int]]) -> Int {
    let arr = nums.map{ $0.sorted() }
    let m = arr.count,n = arr[0].count
    var res = 0
    for i in 0..<n {
        var lMax = 0
        for j in 0..<m {
            lMax = max(lMax,arr[j][i])
        }
        res += lMax
    }
    return res
}

//2600. K 件物品的最大和
func kItemsWithMaximumSum(_ numOnes: Int, _ numZeros: Int, _ numNegOnes: Int, _ k: Int) -> Int {
    switch k {
    case 0...numOnes:return k
    case numOnes...(numOnes+numZeros):return numOnes
    case (numOnes+numZeros)...(numOnes+numZeros+numNegOnes):return numOnes - (k-numOnes-numZeros)
    default:return -1
    }
}


//167. 两数之和 II - 输入有序数组
func twoSum2(_ numbers: [Int], _ target: Int) -> [Int] {
    
    var l = 0,r = numbers.count-1
    while l < r {
        let cur = numbers[l] + numbers[r]
        switch cur {
        case target:return [l+1,r+1]
        case ..<target:
            l += 1
        case (target+1)...:
            r -= 1
        default:
            return []
        }
        
    }
    return []
}

//排序 + 双指针
func threeSum(_ nums: [Int]) -> [[Int]] {
    let n = nums.count,numSor = nums.sorted()
    var res = [[Int]]()
    for i in 0..<n {
        guard numSor[i] <= 0 else {
            return res
        }
        if i > 0,numSor[i] == numSor[i-1] {
            continue
        }
        var l = i+1,r = n-1
        while l < r {
            if numSor[i] + numSor[l] + numSor[r] == 0 {
                res.append([numSor[i],numSor[l],numSor[r]])
                while l < r,numSor[l] == numSor[l+1] {
                    l = l+1
                }
                while l < r,numSor[r] == numSor[r-1] {
                    r = r-1
                }
                l = l+1
                r = r-1
            } else if numSor[i] + numSor[l] + numSor[r] > 0 {
                r = r-1
            } else {
                l = l+1
            }
        }
    }
    return res
}

//18. 四数之和
//[1,0,-1,0,-2,2]
// -2,-1,0,0,1,2
func fourSum(_ nums: [Int], _ target: Int) -> [[Int]] {
    let n = nums.count
    guard n >= 4 else {
        return []
    }
    let numSor = nums.sorted()
    var res = [[Int]](),a = 0
    while a < n-3 {
        var b = a+1
        while b < n - 2 {
            var l = b+1,r = n-1
            while l < r {
                if numSor[a] + numSor[b] + numSor[l] + numSor[r] == target {
                    res.append([numSor[a],numSor[b],numSor[l],numSor[r]])
                    while l < r,numSor[l] == numSor[l+1] {
                        l = l+1
                    }
                    while l < r,numSor[r] == numSor[r-1] {
                        r = r-1
                    }
                    l = l+1
                    r = r-1
                } else if numSor[a] + numSor[b] + numSor[l] + numSor[r] > target {
                    r -= 1
                } else {
                    l += 1
                }
            }
            while b < n - 2,numSor[b] == numSor[b+1] {
                b = b+1
            }
            b += 1
        }
        while a < n - 3,numSor[a] == numSor[a+1] {
            a = a+1
        }
        a += 1
    }
    
    return res
}


//16. 最接近的三数之和
func threeSumClosest(_ nums: [Int], _ target: Int) -> Int {
    let n = nums.count,numSor = nums.sorted()
    var best = 10000000
    for i in 0..<n {
        if i > 0,numSor[i] == numSor[i-1] {
            continue
        }
        var l = i+1,r = n-1
        while l < r {
            let sum = numSor[i] + numSor[l] + numSor[r]
            if sum == target {
                return target
            }
            if abs(sum - target) < abs(best - target) {
                best = sum
            }
            if sum > target {
                repeat {
                    r -= 1
                } while l < r-1 && numSor[r-1] == numSor[r]
            } else {
                repeat {
                    l += 1
                } while l + 1 < r && numSor[l + 1] == numSor[l]
            }
            
        }
    }
    return best
}

//1911. 最大子序列交替和

func maxAlternatingSum(_ nums: [Int]) -> Int {
    let n = nums.count
    var last = nums[0],add = true,res = 0
    for i in 1..<n {
        if nums[i] > last,!add{
            //需要减的，取这段区间的最小值
            res -= last
            add = !add
        } else if nums[i] < last,add {
            res += last
            add = !add
        }
        last = nums[i]
    }
    if add {
        res += last
    }
    return res
}

//2544. 交替数字和

func alternateDigitSum(_ n: Int) -> Int {
    var res = 0,n = n,cg = true
    while n > 0 {
        res +=  (n % 10) * (cg ? 1:-1)
        n = n / 10
        cg = !cg
    }
    return (cg ? -1:1) * res
}


//931. 下降路径最小和
/**
 位置 (row, col) 的下一个元素应当是 (row + 1, col - 1)、(row + 1, col) 或者 (row + 1, col + 1)
 1 1 1 1 1 1
 1 1 1 1 1 1
 f(r,c) = min(f(r+1,c-1)、f(r+1,c)、f(r+1,c+1)) + f(row)
 */
func minFallingPathSum(_ matrix: [[Int]]) -> Int {
    let m = matrix.count,n = matrix[0].count
    var dp = Array(repeating: matrix[m-1], count: 2),next = 0
    for i in (0..<(m-1)).reversed() {
        for j in 0..<n {
            var minS = Int.max
            for z in -1...1 {
                if case 0..<n = j + z {
                    if j+z < j {
                        minS = min(minS,dp[next][j+z])
                    } else {
                        minS = min(minS,dp[next][j+z])
                    }
                }
            }
            
            dp[(next + 1) % 2][j] = minS + matrix[i][j]
        }
        next = (next + 1) % 2
    }
    return dp[next].min()!
}

//415. 字符串相加

func addStrings(_ num1: String, _ num2: String) -> String {
    let arr1 = Array(num1),arr2 = Array(num2)
    var add = 0,i = arr1.count-1,j = arr2.count-1,res = [String]()
    while i >= 0 || j >= 0 || add != 0 {
        let x = i >= 0 ? Int(String(arr1[i]))!:0
        let y = j >= 0 ? Int(String(arr2[j]))!:0
        let temp = x + y + add
        i -= 1;j -= 1
        res.append("\(temp % 10)")
        add = temp / 10
    }
    return res.reversed().joined()
}

//17. 电话号码的字母组合
func letterCombinations(_ digits: String) -> [String] {
    func findLetter(str:Character) -> [String] {
        switch str {
        case "2":return ["a","b","c"]
        case "3":return ["d","e","f"]
        case "4":return ["g","h","i"]
        case "5":return ["j","k","l"]
        case "6":return ["m","n","o"]
        case "7":return ["p","q","r","s"]
        case "8":return ["t","u","v"]
        case "9":return ["w","x","y","z"]
        default:return []
        }
    }
    guard digits.count > 0 else {
        return []
    }
    
    return Array(digits).reduce([""]) { partialResult, char in
        findLetter(str:char).flatMap { cur in
            partialResult.map { $0 + cur }
        }
    }
}


//[[1,4],[2,4],[2,8],[3,6],[3,8],[4,4]]
// [4,4] [2,4] [1,4] [3,6] [3,8]
/**
    [4 ,4] 2 3 4 5
 */

func minInterval(_ intervals: [[Int]], _ queries: [Int]) -> [Int] {
    let qindex = Array(0..<queries.count).sorted { queries[$0] < queries[$1] }
    let interSor = intervals.sorted { $0[0] < $1[0] }
    var queue = Array(repeating: [Int](), count: intervals.count),j = 0
    var res = Array(repeating: -1, count: queries.count),i = 0
    
    func heapInsert(nums: inout [[Int]],begin: Int){
        var index = begin
        while nums[index][0] < nums[(index - 1) / 2][0] {
            (nums[index],nums[(index - 1) / 2]) = (nums[(index - 1) / 2],nums[index])
            index = (index - 1) / 2
        }
    }
    
    func heapFind(nums: inout [[Int]],begin: Int,heapSize: Int){
        var index = begin
        var left = 2 * index + 1
        while left < heapSize {
            let lagerest = ((left + 1) < heapSize) && (nums[left + 1][0] < nums[left][0]) ? left+1 : left
            let sawpIndex =  nums[lagerest][0] < nums[index][0] ? lagerest : index;
            guard sawpIndex != index else {
                break
            }
            (nums[index],nums[sawpIndex]) = (nums[sawpIndex],nums[index])
            index = lagerest
            left = 2 * index + 1
        }
    }
    
    for qi in qindex {
        while i < interSor.count,interSor[i][0] <= queries[qi] {
            queue[j] = [interSor[i][1] - interSor[i][0] + 1 ,interSor[i][0],interSor[i][1]]
            heapInsert(nums: &queue, begin: j)
            j+=1
            i+=1
        }
        while j > 0,queue[0][2] < queries[qi] {
            (queue[j-1],queue[0]) = (queue[0],queue[j-1])
            j -= 1
            heapFind(nums: &queue, begin: 0, heapSize: j)
        }
        if j > 0 {
            res[qi] = queue[0][0]
        }
    }
    
    return res
}

//42. 接雨水
//[0,1,0,2,1,0,1,3,2,1,2,1]
func trap(_ height: [Int]) -> Int {
    guard height.count > 2 else {
        return 0
    }
    var lmax = height.first!,rmax = height.last!,l = 0,r = height.count-1,res = 0
    while l <= r {
        if lmax < rmax {
            res += max(0,lmax - height[l])
            lmax = max(height[l],lmax)
            l += 1
        } else {
            res += max(0,rmax - height[r])
            rmax = max(height[r],rmax)
            r -= 1
        }
    }
    return res
}

// 771. 宝石与石头

func numJewelsInStones(_ jewels: String, _ stones: String) -> Int {
    var hasSe = Set<Character>()
    for ch in jewels {
        hasSe.insert(ch)
    }
    var res = 0
    for st in stones where hasSe.contains(st) {
        res += 1
    }
    return res
}

//2208. 将数组和减半的最少操作次数
// 0
//1 2
func halveArray(_ nums: [Int]) -> Int {
    func heapInsert(nums:inout [Double],i:Int) {
        //尾到头,最大堆
        var begin = i
        while nums[(begin - 1) / 2] < nums[begin] {
            (nums[(begin - 1) / 2],nums[begin]) = (nums[begin],nums[(begin - 1) / 2])
            begin = (begin - 1) / 2
        }
    }
    
    func heapFind(nums:inout [Double], i:Int,size:Int) {
        var index = i,left = 2 * index + 1
        while left < size {
            let maxIndex = left + 1 < size && nums[left + 1] > nums[left] ? (left + 1) : left
            let sawpIndex = nums[index] > nums[maxIndex] ? index:maxIndex
            guard index != sawpIndex else {
                break
            }
            (nums[index],nums[sawpIndex]) = (nums[sawpIndex],nums[index])
            index = sawpIndex
            left = 2 * index + 1
        }
    }
    var arrHeap = [Double](),sum = 0.0
    for i in 0..<nums.count {
        arrHeap.append(Double(nums[i]))
        sum += arrHeap.last!
        heapInsert(nums: &arrHeap, i: i)
    }
    let result = Double(sum) / 2.0
    var index = 0
    while sum > result {
        arrHeap[0] = arrHeap[0] / 2.0
        sum -= arrHeap[0]
        heapFind(nums: &arrHeap, i: 0, size: arrHeap.count)
        index += 1
    }
    return index
}

//2500. 删除每行中的最大值

func deleteGreatestValue(_ grid: [[Int]]) -> Int {
    let grid = grid.map{ $0.sorted() },m = grid.count,n = grid[0].count
    var res = 0
    for i in 0..<n {
        var maxN = Int.min
        for j in 0..<m {
            maxN = max(maxN,grid[j][i])
        }
        res += maxN
    }
    return res
}

/*
 'A' -> "1"
 'B' -> "2"
 ...
 'Z' -> "26"
 */
// 1010 dp[1] = 1 dp[2] =
 // 11106  dp[1] = 1 dp[2] = 2 dp[3] = dp[2] (当前符合) + dp[1](加前一个符合) dp[4] = dp[2] dp[5] = dp[4]
//91. 解码方法
func numDecodings(_ s: String) -> Int {
    func isAvaild(str:String) -> Bool {
        switch str.count {
            case 1:
                guard case 1...9 = Int(str)! else {
                    return false
                }
                return true
            case 2:
                guard case 10...26 = Int(str)! else {
                    return false
                }
                return true
            default:return false
        }
    }
    let chars = Array(s)
    guard chars[0] != "0" else {
        return 0
    }
    var dp = Array(repeating: 0, count: chars.count + 1)
    dp[0] = 1
    dp[1] = 1
    for i in 2..<dp.count {
        if isAvaild(str: String(chars[i-1])) {
            dp[i] += dp[i-1]
        }
        if isAvaild(str: String(chars[(i-2)...(i-1)])) {
            dp[i] += dp[i-2]
        }
    }
    return dp.last!
}

//2681. 英雄的力量
//[1,2,3,4,5]
// [1 ,2 ,3 ,4,5]
//[1 ,2 ,3 ,4,5]
//2个 5 * (1 + 2 + 3 + 4) + 4 * (1 + 2 + 3) + 3 * (1 + 2) + 2 * 1
// [6,3,1]
//3个 5 * (f(3) + f(2) + f(1)) + 4 * (f(2) + f(1))   3 * (f(1))
// [1]
// 5 *  4 + f(1)
// f(2) = 1 f(3) = d(1) + d(2) + f(1) f(4) = 1 + 2 + 3 + f(3)
//[1,2,4]
// [1,2,3,4]
// 4 * (1 + 2 + 3) + 3 * (1 + 2) + 2 * 1
// 3 * (1) + 4 * (1 + 2 + 1)
//4 * ( 1 )
func sumOfPower(_ nums: [Int]) -> Int {
    let mode = Int(1e9 + 7),nums = nums.sorted(),n = nums.count
    var sum = 0
    var last = 0,lasDP = 0
    for j in 0..<n {
        lasDP = (nums[j] + last) % mode
        last = (lasDP + last) % mode
        sum = (sum + ((nums[j] * nums[j]) % mode) * lasDP % mode) % mode
        if sum < 0 {
            sum += mode
        }
        
    }
    return sum
}

//822. 翻转卡片游戏
// [1,2,4,4,7]  [1,3,2,1,3]
//  0 1 2 3 4            [0,3,1,4,2]
//
func flipgame(_ fronts: [Int], _ backs: [Int]) -> Int {
    let n = fronts.count
    var res = Int.max,set = Set<Int>()
    for i in 0..<n {
        if fronts[i] == backs[i] {
            set.insert(fronts[i])
        }
    }
    for i in 0..<n {
        if !set.contains(fronts[i]) {
            res = min(res,fronts[i])
        }
        if !set.contains(backs[i]) {
            res = min(res,backs[i])
        }
    }
    return res == Int.max ? 0:res
}

//1281. 整数的各位积和之差
func subtractProductAndSum(_ n: Int) -> Int {
    var num = n,cRes = 1,aRes = 0
    while num > 0 {
        let temp = num % 10
        num = num / 10
        cRes *= temp
        aRes += temp
    }
    return cRes - aRes
}


func quickSort(arr: inout [Int],l:Int,r:Int) {
    guard l < r else {
        return
    }
    var l = l,ls = l-1,lb = r
    let tag = arr[l]
    while l < lb {
        if arr[l] < tag {
            ls += 1
            (arr[ls],arr[l]) = (arr[l],arr[ls])
            l += 1
        } else if arr[l] > tag {
            lb -= 1
            (arr[lb],arr[l]) = (arr[l],arr[lb])
        } else {
            l += 1
        }
    }
    quickSort(arr: &arr, l: l, r: ls+1)
    quickSort(arr: &arr, l: lb, r: r)
}

// 124. 二叉树中的最大路径和
/**
 二叉树中的 路径 被定义为一条节点序列，序列中每对相邻节点之间都存在一条边。同一个节点在一条路径序列中 至多出现一次 。该路径 至少包含一个 节点，且不一定经过根节点。

 路径和 是路径中各节点值的总和。

 给你一个二叉树的根节点 root ，返回其 最大路径和 。
 */
func maxPathSum(_ root: TreeNode?) -> Int {
    class Node {
        
    }
    var ds = [Node:Int]()
    var maxSum = Int.min
    func maxGain(_ node: TreeNode?) -> Int {
        guard let node = node else {
            return 0
        }
        
        // 递归计算左右子节点的最大贡献值
        // 只有在最大贡献值大于0才会选取
        let leftGain = max(maxGain(node.left),0)
        let rightGain = max(maxGain(node.right),0)
        
        let preNewPath = node.val + leftGain + rightGain
        maxSum = max(maxSum,preNewPath)
        
        return node.val + max(leftGain,rightGain)
    }
    maxGain(root)
    return maxSum
}
