//
//  mathLeet_2.swift
//  leetCode
//
//  Created by 陈晶泊 on 2022/12/1.
//

import Foundation
func nearestValidPoint(_ x: Int, _ y: Int, _ points: [[Int]]) -> Int {
    var result = (-1,Int.max)
    for (i,point) in points.enumerated() where point[0] == x || point[1] == y{
        let temp = abs(point[0] - x) + abs(point[1] - y)
        if result.1 > temp {
            result = (i,temp)
        }
    }
    return result.0
}

func hasGroupsSizeX(_ deck: [Int]) -> Bool {
    func gcd(i:Int,j:Int) -> Int {
        return i == 0 ? j:gcd(i: j % i, j: i)
    }
    var map = [Int:Int]()
    for dec in deck {
        map[dec] = (map[dec] ?? 0) + 1
    }
    var num = -1
    for value in map.values {
        guard value > 1 else {
            return false
        }
        if num == -1 {
            num = value
        } else {
            num = gcd(i: num, j: value)
        }
    }
    return num > 1
}

//1774. 最接近目标价格的甜点成本
func closestCost(_ baseCosts: [Int], _ toppingCosts: [Int], _ target: Int) -> Int {
    var result = Int.max
    func closetCost(sum:Int,i:Int) {
        guard result != 0 else {
            return
        }
        let count = toppingCosts.count
        guard i < count else {
            let tempNum = target - sum
            if abs(result) > abs(tempNum) {
                result = tempNum
            } else if abs(result) == abs(tempNum) {
                result = max(result,tempNum)
            }
            return
        }
        for j in 0...2 {
            let temp = sum + j * toppingCosts[i]
            if temp >= target {
                let (num1,num2) = (target - sum,temp-target)
                let tempNum = num1 > num2 ? -num2:num1
                if abs(result) > abs(tempNum) {
                    result = tempNum
                } else if abs(result) == abs(tempNum) {
                    result = max(result,tempNum)
                }
            } else {
                closetCost(sum: temp, i: i+1)
            }
        }
    }
    
    for baseCost in baseCosts {
        if result == 0 {
            return target
        }
        closetCost(sum: baseCost, i: 0)
    }
    return target - result
}

//动态规划写法
func dfClosestCost(_ baseCosts: [Int], _ toppingCosts: [Int], _ target: Int) -> Int {
    let x = baseCosts.min()!
    guard x <= target else{
        return x
    }
    var dp = Array(repeating: false, count: target + 1)
    var res = 2 * target - x
    for baseCost in baseCosts {
        if baseCost <= target {
            dp[baseCost] = true
        } else {
            res = min(res,baseCost)
        }
    }
    for t in toppingCosts {
        for _ in 0..<2 {
            for i in (1...target).reversed() {
                if dp[i],i + t > target {
                    res = min(res,i+t)
                }
                if i - t > 0 {
                    dp[i] = dp[i] || dp[i - t]
                }
            }
        }
    }
    for i in 0..<(res - target + 1) {
        if dp[target - i] {
            return target - i
        }
    }
    return res
}

//1775. 通过最少操作次数使数组的和相等
func minOperations(_ nums1: [Int], _ nums2: [Int]) -> Int {
    //h2 > h1,sum,增加3和减少3一个意思，对于总和相等来说
    func help(h1:[Int],h2:[Int],diff:Int)->Int {
        var fre = Array(repeating: 0, count: 7)
        for i in 1...6 {
            fre[6-i] += h1[i]
            fre[i-1] += h2[i]
        }
        var res = 0,i = 5,diff = diff
        while i > 0,diff > 0 {
            let temp = min((diff + i - 1) / i, fre[i])
            res += temp
            diff -= temp * i
            i-=1
        }
        return res
    }
    let (m,n) = (nums1.count,nums2.count)
    if 6 * n < m || 6 * m < n {
        return -1
    }
    var (fre1,fre2) = (Array(repeating: 0, count: 7),Array(repeating: 0, count: 7))
    var diff = 0
    var i = 0
    while i < max(m,n) {
        if i < m {
            fre1[nums1[i]] += 1
            diff += nums1[i]
        }
        
        if i < n {
            fre2[nums2[i]] += 1
            diff -= nums2[i]
        }
        
        i += 1
    }
    
    if diff == 0 {
        return 0
    }
    if diff > 0 {
        return help(h1: fre2, h2: fre1, diff: diff)
    }
    return help(h1: fre1, h2: fre2, diff: -diff)
}

func checkPowersOfThree(_ n: Int) -> Bool {
    var max = Int.max,n = n
    while max > 0, n > 0 {
        var num = 1
        while n / num >= 3, num * 3 < max{
            num = num * 3
        }
        guard num < max else {
            return n == 0
        }
        n = n - num
        max = num
    }
    return n == 0
}

func minOperations(_ nums: [Int]) -> Int {
    guard nums.count > 1 else {
        return 0
    }
    var (sum,begin) = (0,nums[0])
    for i in 1..<nums.count {
        if nums[i] > begin {
            begin = nums[i]
        } else {
            begin += 1
            sum += begin - nums[i]
        }
    }
    return sum
}

// 1785. 构成特定和需要添加的最少元素
func minElements(_ nums: [Int], _ limit: Int, _ goal: Int) -> Int {
    let sum = nums.reduce(0) { $0 + $1 }
    let chang = goal - sum
    guard chang != 0 else {
        return 0
    }
    
    let temp = abs(chang) / limit
    let nee = abs(chang) % limit
    
    
    return nee == 0 ? temp:temp+1
}

//1764. 通过连接另一个数组的子数组得到一个数组
func canChoose(_ groups: [[Int]], _ nums: [Int]) -> Bool {
    func getNextArr(group:[Int]) -> [Int] {
        var nexArr = Array(repeating: 0, count: group.count),cn = 0,i = 2
        nexArr[0] = -1
        while i < nexArr.count {
            if group[i-1] == group[cn] {
                cn += 1
                nexArr[i] = cn
                i += 1
            } else if cn > 0 {
                cn = nexArr[cn]
            } else {
                nexArr[i] = 0
                i += 1
            }
        }
        return nexArr
    }
    var (i,j) = (0,0)
    while i < nums.count,j < groups.count {
        let cur = groups[j]
        var z = 0
        let nexts = getNextArr(group: cur)
        while i < nums.count,z < cur.count {
            if nums[i] == cur[z] {
                i += 1
                z += 1
            } else if nexts[z] == -1 {
                i += 1
            } else {
                z = nexts[z]
            }
        }
        guard z == cur.count else {
            return false
        }
        j += 1
    }
    return j == groups.count
}

//得到连续 K 个 1 的最少相邻交换次数
/*
 https://leetcode.cn/problems/minimum-adjacent-swaps-for-k-consecutive-ones/solutions/2024387/tu-jie-zhuan-huan-cheng-zhong-wei-shu-ta-iz4v/
 1.取中位数，最小，计算累加和
 si + si+k - 2si+k/2 - pi+k/2 * (k % 2)
*/
func minMoves(_ nums: [Int], _ k: Int) -> Int {
    var arr = [Int]()
    for (j,num) in nums.enumerated() where num == 1{
        arr.append(j-arr.count)
    }
    var s = Array(repeating: 0, count: arr.count + 1)
    for i in 0..<arr.count {
        s[i+1] = s[i] + arr[i]
    }
    var ans = Int.max
    for i in 0...(arr.count - k) {
        ans = min(ans,s[i] + s[i+k] - s[i + k/2] * 2 - arr[i + k/2] * (k % 2))
    }
    return ans
}

// 1753. 移除石子的最大得分
func maximumScore(_ a: Int, _ b: Int, _ c: Int) -> Int {
    let chang = a + b - c
    guard chang > 0 else {
        return a + b
    }
    //c被消除掉了
    let min = min(a,chang/2,b)
    return c + min
}


func twoOutOfThree(_ nums1: [Int], _ nums2: [Int], _ nums3: [Int]) -> [Int] {
    let a = Set(nums1),b = Set(nums2),c = Set(nums3)
    let numRes = a.intersection(b).union(a.union(b).intersection(c))
    return Array(numRes)
}

func hammingDistance(_ x: Int, _ y: Int) -> Int {
    var numX = x,numY = y,res = 0
    while numX > 0 || numY > 0 {
        if numX & 1 != numY & 1 {
            res += 1
        }
        numX = numX >> 1
        numY = numY >> 1
    }
    return res
}


class ExamRoom {
    var datArr = [Int]()
    var count:Int
    init(_ n: Int) {
        count = n-1
    }
    
    func seat() -> Int {
        guard !datArr.isEmpty else {
            datArr.append(0)
            return 0
        }
        
        guard datArr.count > 1 else {
            if datArr.first! - 0 >= count - datArr.first! {
                datArr.insert(0, at: 0)
                return 0
            } else {
                datArr.append(count)
                return count
            }
        }
       
        var res = 0,z = 0
        for i in 1..<datArr.count {
            let temp = (datArr[i] - datArr[i-1]) >> 1
            if temp > res {
                res = temp
                z = i
            }
        }
        if 0 < datArr.first!,(datArr.first! - 0) >= res {
            datArr.insert(0, at: 0)
            return 0
        }
        
        if count > datArr.last!,(count - datArr.last!) > res {
            datArr.append(count)
            return count
        }
        
        let cur = datArr[z-1] + res
        datArr.insert(cur, at: z)
        return cur
    }
    
    func leave(_ p: Int) {
        datArr = datArr.filter{ $0 != p}
    }
}

//2037. 使每位学生都有座位的最少移动次数
func minMovesToSeat(_ seats: [Int], _ students: [Int]) -> Int {
    let sorSeats = seats.sorted(),sorStud = students.sorted()
    var res = 0
    for i in 0..<seats.count {
        res += abs(sorSeats[i] - sorStud[i])
    }
    return res
}
///
///[[27,30,0],[10,10,1],[28,17,1],[19,28,0],[16,8,1],[14,22,0],[12,18,1],[3,15,0],[25,6,1]]
//1801. 积压订单中的订单总数
func getNumberOfBacklogOrders(_ orders: [[Int]]) -> Int {
    let mode = 1_000_000_007
    func insertSor(arr:inout [(Int,Int)],num:(Int,Int)) {
        if arr.isEmpty || num.0 > arr.last!.0 {
            arr.append(num)
        } else {
            for i in 0..<arr.count where arr[i].0 >= num.0{
                arr.insert(num, at: i)
                break
            }
        }
    }
    var buyA = [(Int,Int)](),selA = [(Int,Int)]()

    for order in orders {
        if order[2] == 0 {
            var temp = order[1],i = 0
            while temp > 0,i < selA.count {
                guard selA[i].0 <= order[0] else {
                    break
                }
                if selA[i].1 > temp {
                    selA[i] = (selA[i].0,selA[i].1 - temp)
                    temp = 0
                } else {
                    temp -= selA[i].1
                    selA.remove(at: i)
                }
            }
            if temp > 0 {
                insertSor(arr: &buyA, num: (order[0],temp))
            }
        } else if order[2] == 1 {
            var temp = order[1],i = buyA.count-1
            while temp > 0,i >= 0 {
                guard buyA[i].0 >= order[0] else {
                    break
                }
                if buyA[i].1 > temp {
                    buyA[i] = (buyA[i].0,buyA[i].1 - temp)
                    temp = 0
                } else {
                    temp -= buyA[i].1
                    buyA.remove(at: i)
                    i -= 1
                }
            }
            if temp > 0 {
                insertSor(arr: &selA, num: (order[0],temp))
            }
        }
    }
    var res = 0
    for buy in buyA {
        res = (res + buy.1) % mode
    }
    for sel in selA {
        res = (res + sel.1) % mode
    }
    return res
}

func areNumbersAscending(_ s: String) -> Bool {
    let chars = Array(s)
    func isNum(index:inout Int)->Int? {
        guard index < chars.count else {
            return nil
        }
       let begin = index
        while index < chars.count,CharacterSet.decimalDigits.contains( UnicodeScalar(String(chars[index]))!) {
            index += 1
        }
        guard index > begin else {
            return nil
        }
        return Int(String(chars[begin..<index]))
    }
    
    var index = 0,lastNum = -1
    while index < chars.count {
        guard let num = isNum(index: &index) else {
            index += 1
            continue
        }
        guard num > lastNum else {
            return false
        }
        lastNum = num
        index += 1
    }
    return true
}

//50. Pow(x, n)
func myPow(_ x: Double, _ n: Int) -> Double {
    guard n >= 0 else {
        return 1.0 / myPow(x, -n)
    }
    var res = 1.00,num = x,nNum = n
    while nNum > 0 {
        if nNum & 1 == 1 {
            res = res * num
        }
        nNum = nNum >> 1
        num = num * num
    }
    
    return res
}
/**
 1802. 有界数组中指定下标处的最大值
 begin = 1,  b1 = n - index,b2 = n - (count - index - 1)
 (b1 + n) * n  / 2   + (b2 + n) * n  /  2 = sum
 (b1 + 2 * n + b2) * n /2 = sum
 begin =
  1 1 1 1
    1
 0123454321000
 1 5 9
 4321
 */

func maxValue(_ n: Int, _ index: Int, _ maxSum: Int) -> Int {
    func valid(mid:Int) -> Bool {
        let l = index,r = n - index - 1
        return (Double(mid) + call(big: mid, l: l) + call(big: mid, l: r)) <= Double(maxSum)
    }
    
    func call(big:Int,l:Int) ->Double {
        if l + 1 < big {
            let small = big - l
            return Double((big - 1 + small) * l) / 2.0
        } else {
            let one = l + 1 - big
            return Double(big * (big - 1)) / 2.0 + Double(one)
        }
    }
    var left = 1,right = maxSum
    while left < right {
        let mid = (left + right + 1) >> 1
        if valid(mid: mid) {
            left = mid
        } else {
            right = mid - 1
        }
    }
    return left
}


//1803. 统计异或值在范围内的数对有多少
///[2,4,5,2,1,2,3]    5   14       4
///      1 0 , 110
//
func countPairs(_ nums: [Int], _ low: Int, _ high: Int) -> Int {
    func isXOR(num1:Int,num2:Int) ->Bool {
        if case low...high = (num1 ^ num2) {
            return true
        }
        return false
    }
    var res = 0, map = [Int:(Int,Int)]()
    for i in (0..<(nums.count - 1)).reversed() {
        var end = nums.count,temp = 0
       if let info = map[nums[i]] {
           end = info.0
           temp = info.1
        }
        for j in (i + 1)..<end where isXOR(num1: nums[i], num2: nums[j]){
            temp += 1
        }
        map[nums[i]] = (i,temp)
        res += temp
    }
    return res
}

func isPerfectSquare(_ num: Int) -> Bool {
    var l = 1,r = num,mid = (r + l) >> 1
    while l < r {
        if mid * mid >= num {
            r = mid
        } else {
            l = mid + 1
        }
        mid = (r + l) >> 1
    }
    return r * r == num
}

//2180. 统计各位数字之和为偶数的整数个数
//26 20 22 24 26
// 51 53 55
//  2 2 1 1 1 2 3
func countEven(_ num: Int) -> Int {
    //整数转 2000,不包括0
    func isEventNum1(_ numT:Int,less:Int,oldNum:Int)->Int {
        let even = numT / 2 + (numT % 2 == 0 ? 0:1) //不包括自己
        let odd = numT - even
        var res = 0
        if odd != 0 {
            res += eventNum(less, oldNum + 1, odd)
        }
        if even != 0 {
            res += eventNum(less, oldNum, even)
        }
        //如果之前是偶数，且，包括当前的,减去结果中包括的0
        return res + ((oldNum % 2 == 0) == (numT % 2 == 0) ? 1:0) + (oldNum % 2 == 0 ? -1:0)
    }
    //2000位以下
    func eventNum(_ i:Int,_ oddNum:Int,_ times:Int)->Int {
        guard i > 0 else {
            return oddNum % 2 == 0 ? times:0
        }
        return eventNum(i-1, oddNum + 1, 5 * times) + eventNum(i-1, oddNum, 5 * times)
    }
    let nums = Array(String(num))
    var res = 0,oldNum = 0
    for i in 0..<nums.count where Int(String(nums[i]))! != 0 {
        let temp = Int(String(nums[i]))!
        res += isEventNum1(temp, less: nums.count - 1 - i,oldNum: oldNum)
        oldNum += (temp % 2 == 0 ? 0:1)
    }
    //不要0
    return res
}

func minOperations(_ nums: [Int], _ x: Int) -> Int {
    var left = [0],right = [0:nums.count],res = 0
    for v in nums{
        res += v
        guard res <= x else {
            break
        }
        left.append(res)
    }
    res = 0
    for (k,v) in nums.enumerated().reversed() {
        res += v
        guard res <= x else {
            break
        }
        right[res] = k
    }
    res = nums.count + 1
    for (k,v) in left.enumerated() {
        guard let r = right[x - v],(k-1) < r else {
            continue
        }
        res = min(res,k + nums.count - r)
    }
    return res > nums.count ? -1:res
}

//1806. 还原排列的最少操作步数
/**
 如果 i % 2 == 0 ，那么 arr[i] = perm[i / 2]
 
 如果 i % 2 == 1 ，那么 arr[i] = perm[n / 2 + (i - 1) / 2]
 2 1
 
 */
func reinitializePermutation(_ n: Int) -> Int {
    var arr = [Int](),res = 0,times = 0
    for i in 0..<n {
        arr.append(i)
    }
    while times != n {
        let perm = arr
        times = 0
        res += 1
        for i in 0..<n {
            if i % 2 == 0 {
                arr[i] = perm[i >> 1]
            } else {
                arr[i] = perm[n/2 + (i-1)/2]
            }
            if arr[i] == i {
                times += 1
            }
        }
    }
    return res
}


func findingUsersActiveMinutes(_ logs: [[Int]], _ k: Int) -> [Int] {
    let sortLog = logs.sorted { l1, l2 in
        guard l1[0] == l2[0] else {
            return l1[0] < l2[0]
        }
        return l1[1] < l2[1]
    }
    var res = Array(repeating: 0, count: k),lastI = 0,temp = 0
    for i in 0..<sortLog.count {
        guard sortLog[lastI][0] == sortLog[i][0] else {
            res[temp-1] += 1
            lastI = i
            temp = 1
            continue
        }
        if i>0,sortLog[i][1] == sortLog[i-1][1] {
            continue
        }
        temp += 1
    }
    res[temp-1] += 1
    return res
}

//1824. 最少侧跳次数
func minSideJumps(_ obstacles: [Int]) -> Int {
    let count = obstacles.count
    var arr = Array(repeating: (count,count,count), count: count+1)
    for i in (0..<count).reversed() {
        arr[i] = arr[i+1]
        switch obstacles[i] {
        case 1:arr[i].0 = i
        case 2:arr[i].1 = i
        case 3:arr[i].2 = i
        default:break
        }
    }
    var cur = 2,res = 0
    for i in 0..<count where obstacles[i] == cur{
        res += 1
        var temp = 0
        if obstacles[i-1] != 1,(arr[i].0 - i) > temp {
            //选择1
            cur = 1
            temp = arr[i].0 - i
        }
        
        if obstacles[i-1] != 2,(arr[i].1 - i) > temp {
            //选择2
            cur = 2
            temp = arr[i].1 - i
        }
        
        if obstacles[i-1] != 3,(arr[i].2 - i) > temp  {
            //选择3
            cur = 3
            temp = arr[i].2 - i
        }
    }
    return res
}

//2303. 计算应缴税款总额
func calculateTax(_ brackets: [[Int]], _ income: Int) -> Double {
    var last = 0,res = 0.0
    for bracket in brackets {
        if bracket[0] >= income {
            res += Double((income - last) * bracket[1]) / 100.0
            return res
        } else {
            res += Double((bracket[0] - last) * bracket[1]) / 100.0
        }
        last = bracket[0]
    }
    return res
}

//1828. 统计一个圆中点的数目
func countPoints(_ points: [[Int]], _ queries: [[Int]]) -> [Int] {
    func isPoint(querie:[Int])->Int {
        var res = 0
        for point in points where sqrt(pow(Double(point[0] - querie[0]), 2) + pow(Double(point[1] - querie[1]), 2)) <= Double(querie[2]){
            res += 1
        }
        return res
    }
    var res = Array(repeating: 0, count: queries.count)
    for i in 0..<queries.count {
        res[i] = isPoint(querie: queries[i])
    }
    return res
}

//2319. 判断矩阵是否是一个 X 矩阵
func checkXMatrix(_ grid: [[Int]]) -> Bool {
    for i in 0..<grid.count {
        guard grid[i][i] != 0,grid[i][grid[i].count-i-1] != 0  else {
            return false
        }
        for j in 0..<grid[i].count where !(j == i || j == (grid[i].count-i-1)) && grid[i][j] != 0{
            return false
        }
    }
    return true
}

//697. 数组的度
func findShortestSubArray(_ nums: [Int]) -> Int {
    var map = [Int:(Int,Int,Int)](),max = (0,0,0)
    for i in 0..<nums.count {
        var temp = (i,i,1)
        if let chan = map[nums[i]] {
            temp.0 = chan.0
            temp.2 = chan.2 + 1
        }
        map[nums[i]] = temp
        if temp.2 > max.2 {
            max = temp
        } else if temp.2 == max.2,temp.1 - temp.0 < max.1 - max.0 {
            max = temp
        }
    }
    return max.1-max.0+1
}

//1798. 你能构造出连续值的最大数目
func getMaximumConsecutive(_ coins: [Int]) -> Int {
    func quickSort(array:inout [Int], left: Int, right: Int) {
        guard left < right else {
            return
        }
        var l = left - 1,r = right+1,i = left
        let mid = array[left]
        while i < r {
            if array[i] < mid {
                l += 1
                swap(array: &array, i: i, j: l)
                i += 1
            } else if array[i] > mid {
                r -= 1
                swap(array: &array, i: i, j: r)
            } else {
                i += 1
            }
        }
        quickSort(array: &array, left: left, right: l)
        quickSort(array: &array, left: r, right: right)
    }
    
    func swap(array:inout [Int], i: Int, j: Int) {
        let temp = array[i]
        array[i] = array[j]
        array[j] = temp
    }
    var sorCoin = coins
    quickSort(array: &sorCoin, left: 0, right: sorCoin.count-1)
    var res = 1
    for coin in sorCoin {
        guard res >= coin else {
            break
        }
        res += coin
    }
    return res
}

//2335. 装满杯子需要的最短总时长
func fillCups(_ amount: [Int]) -> Int {
    let change = amount[0] + amount[1] - amount[2]
    guard change > 0 else {
        return amount[2]
    }
    let minC = min(amount[0],amount[1],change/2)
    return amount[2] + change - minC
}

//1124. 表现良好的最长时间段
func longestWPI(_ hours: [Int]) -> Int {
    let count = hours.count

    var sum = 0,res = 0,map = [Int:Int]()
    for i in 0..<count {
        sum += (hours[i] > 8 ? 1:-1)
        if sum > 0 {
            res = max(res,i+1)
        } else if let j = map[sum-1]{
            res = max(res,i-j)
        }
        if map[sum] == nil {
            map[sum] = i
        }
    }
    return res
}
// 1250. 检查「好数组」
/**
 给你一个正整数数组 nums，你需要从中任选一些子集，然后将子集中每一个数乘以一个 任意整数，并求出他们的和。

 假如该和结果为 1，那么原数组就是一个「好数组」，则返回 True；否则请返回 False。
 
 裴蜀定理」的内容为：对于不全为零的任意整数 aaa 和 bbb，记 g=gcd⁡(a,b)g = \gcd(a,b)g=gcd(a,b)，其中 gcd⁡(a,b)\gcd(a, b)gcd(a,b) 为 aaa 和 bbb 的最大公约数，则对于任意整数 xxx 和 yyy 都满足 a×x+b×ya\times x+b \times ya×x+b×y 是 ggg 的倍数，特别地，存在整数 xxx 和 yyy 满足 a×x+b×y=ga \times x + b \times y = ga×x+b×y=g。

 「裴蜀定理」也可以推广到多个整数的情况。
 */
func isGoodArray(_ nums: [Int]) -> Bool {
    func GCD(num1:Int,num2:Int) -> Int {
        var n1 = num1,n2 = num2
        while n2 != 0 {
            let temp = n1
            n1 = n2
            n2 = temp % n2
        }
        return n1
    }
    var res = nums[0]
    for i in 1..<nums.count {
        res = GCD(num1: res, num2: nums[i])
        if res == 1 {
            break
        }
    }
    return res == 1
}

//2341. 数组能形成多少数对
func numberOfPairs(_ nums: [Int]) -> [Int] {
    var map = [Int:Int]()
    for num in nums {
        map[num] = (map[num] ?? 0) + 1
    }
    let res = map.reduce(0) { partialResult, info in
        return partialResult + (info.value % 2)
    }
    return [(nums.count - res) / 2,res]
}

//1237. 找出给定方程的正整数解
// f(x, y) == z 的解处于 1 <= x, y <= 1000 的范围内
class CustomFunction {
      // Returns f(x, y) for any given positive integers x and y.
      // Note that f(x, y) is increasing with respect to both x and y.
     // i.e. f(x, y) < f(x + 1, y), f(x, y) < f(x, y + 1)
      func f(_ x: Int, _ y: Int) -> Int { return x * y }
}
func findSolution(_ customfunction: CustomFunction, _ z: Int) -> [[Int]] {
    var res = [[Int]]()
    for  i in 1...1000 {
        var l = 1, r = 1000,mid = l,num = 0
        while l < r {
            mid = (l + r) >> 1
            num = customfunction.f(i, mid)
            if num > z {
                r = mid - 1
            } else if num < z{
                l = mid + 1
            } else {
                res.append([i,mid])
                break
            }
        }
    }
    return res
}

func largest1BorderedSquare(_ grid: [[Int]]) -> Int {
    let m = grid.count,n = grid[0].count
    var left = Array(repeating: Array(repeating: 0, count: n + 1), count: m + 1)
    var up = left
    var maxBorder = 0
    for i in 1...m {
        for j in 1...n {
            if grid[i-1][j-1] == 1 {
                left[i][j] = left[i][j-1] + 1
                up[i][j] = up[i-1][j] + 1
                var border = min(left[i][j], up[i][j])
                while(left[i - border + 1][j] < border || up[i][j - border + 1] < border) {
                    border -= 1
                }
                maxBorder = max(maxBorder,border)
            }
        }
    }
    return maxBorder * maxBorder
}


func maxAverageRatio(_ classes: [[Int]], _ extraStudents: Int) -> Double {
    let count = classes.count
    var nums = classes
    for i in 0..<count {
        heapInsert(begin: i)
    }
    var res = extraStudents
    while res > 0 {
        res -= 1
        nums[0] = [nums[0][0]+1,nums[0][1]+1]
        heapFind(begin: 0, heapSize: count)
    }
    var resD = 0.0
    for num in nums {
        resD += Double(num[0])/Double(num[1])
    }
    return resD / Double(count)
    func heapFind(begin:Int,heapSize: Int) {
        var index = begin,left = 2 * begin + 1
        while left < heapSize {
            let largest = ((left + 1) < heapSize && needChange(i: left + 1, j: left)) ? left+1:left
            let swapIndex = needChange(i: largest, j:index) ? largest:index
            guard swapIndex != index else {
                break
            }
            swap(i: largest, j: index)
            index = swapIndex
            left = 2 * index + 1
        }
    }
    
    func heapInsert(begin:Int) {
        var index = begin
        while needChange(i: index, j: (index-1)/2) {
            swap(i: index, j: (index-1)/2)
            index = (index-1)/2
        }
    }
    
    func needChange(i:Int,j:Int) -> Bool {
        let numI = Double(nums[i][0] + 1)/Double(nums[i][1] + 1) - Double(nums[i][0])/Double(nums[i][1])
        let numJ = Double(nums[j][0] + 1)/Double(nums[j][1] + 1) - Double(nums[j][0])/Double(nums[j][1])
        return numI > numJ
    }
    
    func swap(i:Int,j:Int) {
        let temp = nums[i]
        nums[i] = nums[j]
        nums[j] = temp
    }
}

//1326. 灌溉花园的最少水龙头数目
func minTaps(_ n: Int, _ ranges: [Int]) -> Int {
    var sortRangs = ranges.enumerated().compactMap { iter in
        return iter.element == 0 ? nil:(max(iter.offset - iter.element, 0),iter.offset + iter.element)
    }
    sortRangs.sort { info1, info2 in
        if info1.0 < info2.0 {
            return true
        } else if info1.0 == info2.0 {
            return info1.1 > info2.1
        }
        return false
    }
    
    guard sortRangs.count > 0 else {
        return -1
    }
    var res = 1,begin = sortRangs[0].0,end = sortRangs[0].1,i = 1,next = 1
    while i < sortRangs.count,end < n {
        if sortRangs[i].0 != begin,sortRangs[i].1 > end {
            if end >= sortRangs[i].0 {
                next = max(next,sortRangs[i].1)
            } else if next > sortRangs[i].0 {
                res += 1
                end = next
                next = max(next,sortRangs[i].1)
            } else {
                return -1
            }
           
        }
        i += 1
    }
    if end < n {
        res += 1
        end = next
    }
    
    return end < n ? -1:res
}

//1140. 石子游戏 II
/**
 爱丽丝和鲍勃轮流进行，爱丽丝先开始。最初，M = 1。

 在每个玩家的回合中，该玩家可以拿走剩下的 前 X 堆的所有石子，其中 1 <= X <= 2M。然后，令 M = max(M, X)。

 游戏一直持续到所有石子都被拿走。

 假设爱丽丝和鲍勃都发挥出最佳水平，返回爱丽丝可以得到的最大数量的石头
 1  2 3 4 5
 1 3 6
 */
func stoneGameII(_ piles: [Int]) -> Int {
    var map = [String:Int](),prefixSum = Array(repeating: 0, count: piles.count+1)
    for i in 0..<piles.count {
        prefixSum[i+1] = piles[i] + prefixSum[i]
    }
    
    func dp(i:Int,m:Int) -> Int {
        guard i < piles.count else {
            return 0
        }
        let key = "\(i)_\(m)"
        if let num = map[key] {
            return num
        }
        var maxVal = Int.min
        for j in 1...2*m {
            if i + j > piles.count {
                break
            }
            maxVal = max(maxVal,prefixSum[i+j] - prefixSum[i] - dp(i: i+j, m: max(m,j)))
        }
        map[key] = maxVal
        
        return maxVal
        
    }
    return (prefixSum.last! + dp(i: 0,m: 1))/2
}
// (010,110,111,101,100,000,001,011)
// 010 110 111 101,
// 101 格雷公式
func circularPermutation(_ n: Int, _ start: Int) -> [Int] {
    var res = [Int]()
    for i in 0..<(1 << n) {
        res.append((i >> 1) ^ i ^ start)
    }
    return res
}

//使数组中所有元素都等于零
func minimumOperations(_ nums: [Int]) -> Int {
    let sorNum = nums.sorted()
    var last = 0,res = 0
    for element in sorNum where last != element{
        res += 1
        last = element
    }
    return res
}

//1144. 递减元素使数组呈锯齿状
func movesToMakeZigzag(_ nums: [Int]) -> Int {
    var evenRes = 0,oddRes = 0
    for i in 0..<nums.count {
        let temp = min(i - 1 < 0 ? Int.max:nums[i-1], i+1 >= nums.count ? Int.max:nums[i+1])
        if i % 2 == 0 {
            oddRes += (nums[i] - temp) < 0 ? 0:(nums[i] - temp + 1)
        } else {
            evenRes += (nums[i] - temp) < 0 ? 0:(nums[i] - temp + 1)
        }
    }
    return min(evenRes,oddRes)
}


//2363. 合并相似的物品
func mergeSimilarItems(_ items1: [[Int]], _ items2: [[Int]]) -> [[Int]] {
    let sor1 = (items1 + items2).sorted {$0[0] < $1[0]}
    var res = [sor1[0]]
    for i in 1..<sor1.count {
        if res[res.count-1][0] == sor1[i][0] {
            res[res.count-1][1] += sor1[i][1]
        } else {
            res.append(sor1[i])
        }
    }
   return res
}

//2373. 矩阵中的局部最大值
func largestLocal(_ grid: [[Int]]) -> [[Int]] {
    let n = grid.count
    var res = Array(repeating: Array(repeating: 0, count: n-2), count: n-2)
    for i in 0..<(n-2) {
        for j in 0..<(n-2) {
            res[i][j] = max(grid[i][j...(j+2)].max()!,grid[i+1][j...(j+2)].max()!,grid[i+2][j...(j+2)].max()!)
        }
    }
    return res
}

//面试题 05.02. 二进制数转字符串
/**
 0.625的二进制，小数点二进制，0.625 * 2 = 1.25 —— 1。 0.25 * 2  = 0.5 —— 0，0.5 * 2 = 1 —— 1，0.101
 二进制数转字符串。给定一个介于0和1之间的实数（如0.72），类型为double，打印它的二进制表达式。如果该数字无法精确地用32位以内的二进制表示，则打印“ERROR”。
 */
func printBin(_ num: Double) -> String {
    var num = num,res = "0."
    while num > 0,res.count < 32 {
        num = 2 * num
        if num >= 1 {
            num -= 1
            res += "1"
        } else {
            res += "0"
        }
    }
    return num == 0 ? res:"ERROR"
}

//982. 按位与为零的三元组
/**
 给你一个整数数组 nums ，返回其中 按位与三元组 的数目。

 按位与三元组 是由下标 (i, j, k) 组成的三元组，并满足下述全部条件：

 0 <= i < nums.length
 0 <= j < nums.length
 0 <= k < nums.length
 nums[i] & nums[j] & nums[k] == 0 ，其中 & 表示按位与运算符。
 */
func countTriplets(_ nums: [Int]) -> Int {
    let count = nums.count
    var cnt = Array(repeating: 0, count: 1 << 16)
    for a in nums {
        for b in nums {
            cnt[a & b] += 1
        }
    }
    var res = 0
    for a in nums {
        var num = a ^ 0xFFFF
        while num != 0 {
            res += cnt[num]
            num = (num - 1) & a
        }
    }
    return res
}

//1599. 经营摩天轮的最大利润
// 返回最大化利润所需执行的 最小轮转次数 。 如果不存在利润为正的方案，则返回 -1 。

func minOperationsMaxProfit(_ customers: [Int], _ boardingCost: Int, _ runningCost: Int) -> Int {
    guard boardingCost * 4 > runningCost else {
        return -1
    }
    var res = boardingCost * min(4,customers[0]) - runningCost,wait = max(0, customers[0]-4),maxN = 0,i = 1
    while i < customers.count || wait > 0 {
        if i < customers.count { wait += customers[i] }
    
        let temp = res + boardingCost * min(4,wait) - runningCost
        wait = max(0, wait-4)
        if temp > res {
            maxN = i
            res = temp
        }
        i += 1
    }
    return res > 0 ? maxN+1:-1
}

//2379. 得到 K 个黑块的最少涂色次数
//'W' 要么是 'B'
func minimumRecolors(_ blocks: String, _ k: Int) -> Int {
    let arr = Array(blocks)
    var lastB = 0,res = Int.max
    for i in 0..<arr.count {
        if i >= k {
            res = min(lastB,res)
            lastB -= arr[i-k] == "W" ? 1:0
        }
        if arr[i] == "W" { lastB += 1 }
    }
    return min(lastB,res)
}


//1590. 使数组和能被 P 整除
func minSubarray(_ nums: [Int], _ p: Int) -> Int {
    let n = nums.count
    var x = 0
    for num in nums {
        x = (x+num) % p
    }
    guard x != 0 else {
        return 0
    }
    var map = [Int:Int](),y = 0,res = nums.count
    for i in 0..<n {
        map[y] = i
        y = (y + nums[i]) % p
        if let j = map[(y - x + p) % p] {
            res = min(res,i + 1 - j)
        }
    }
    
    return res == n ? -1:res
}

// 2383. 赢得比赛需要的最少训练时长
func minNumberOfHours(_ initialEnergy: Int, _ initialExperience: Int, _ energy: [Int], _ experience: [Int]) -> Int {
    var res = 0,ener = initialEnergy,exper = initialExperience
    for i in 0..<energy.count {
        if ener <= energy[i] {
            res += energy[i] + 1 - ener
            ener = energy[i] + 1
        }
        if exper <= experience[i] {
            res += experience[i] + 1 - exper
            exper = experience[i] + 1
        }
        ener -= energy[i]
        exper += experience[i]
    }
    return res
}

// 693. 交替位二进制数 100 011 101 010 111
func hasAlternatingBits(_ n: Int) -> Bool {
    var last = -1,num = n
    while num != 0 {
        if last == num & 1 {
            return false
        }
        last = num & 1
        num = num >> 1
    }
    return true
}

//1605. 给定行和列的和求可行矩阵
// [0,8],[4,4]
// 0 3
//
func restoreMatrix(_ rowSum: [Int], _ colSum: [Int]) -> [[Int]] {
    let col = colSum.count,row = rowSum.count
    var rowSum = rowSum,colSum = colSum
    var arr = Array(repeating: Array(repeating: 0, count: col), count: row)
    for i in 0..<row {
        for j in 0..<col {
            let temp = min(rowSum[i],colSum[j])
            rowSum[i] -= temp
            colSum[j] -= temp
            arr[i][j] = temp
        }
    }
    return arr
}

// 1615. 最大网络秩
func maximalNetworkRank(_ n: Int, _ roads: [[Int]]) -> Int {
    guard roads.count > 2 else {
        return roads.count
    }
    var arr = Array(repeating: 0, count: n),hasSet = Set<String>()
    for road in roads {
        arr[road[0]] += 1
        arr[road[1]] += 1
        hasSet.insert("\(road.min()!)_\(road.max()!)")
    }
    var res = 0
    for i in 0..<n {
        for j in (i+1)..<n {
            res = max(arr[i] + arr[j] - (hasSet.contains("\(i)_\(j)") ? 1:0),res)
        }
    }
    
    return res
}

//2488. 统计中位数为 K 的子数组
func countSubarrays(_ nums: [Int], _ k: Int) -> Int {
    //1  2
    var preArr = Array(repeating: 0, count: nums.count + 1),curI = 0
    for i in 1...nums.count {
        var temp = 0
        if nums[i-1] > k {
            temp = 1
        } else if nums[i-1] < k {
            temp = -1
        } else {
            curI = i
        }
        preArr[i] = preArr[i-1] + temp
    }
    var res = 0
    // (a,b]
    for i in curI...nums.count {
        for j in 0..<curI where preArr[i]-preArr[j] == 0 ||  preArr[i]-preArr[j] == 1{
            res += 1
        }
    }
    return res
}


//2389. 和有限的最长子序列
func answerQueries(_ nums: [Int], _ queries: [Int]) -> [Int] {
    var numArr = nums.sorted()
    for i in 1..<numArr.count {
        numArr[i] = numArr[i] + numArr[i-1]
    }
    var res = Array(repeating: 0, count: queries.count)
    for i in 0..<queries.count {
        var l = 0,r = numArr.count
        while l < r {
            let mid = (l + r) >> 1
            if numArr[mid] <= queries[i] {
                l = mid + 1
            } else {
                r = mid
            }
        }
        res[i] = r
    }
    return res
}

///1012. 至少有 1 位重复的数字
/// 给定正整数 n，返回在 [1, n] 范围内具有 至少 1 位 重复数字的正整数的个数。


func numDupDigitsAtMostN(_ n: Int) -> Int {
    let str = String(n)
    var dp = Array(repeating: Array(repeating: -1, count: 1 << 10), count:str.count)
    
    func f(mask:Int,sn:String,i:Int,same:Bool) -> Int {
        guard i < sn.count else {
            return 1
        }
        if !same && dp[i][mask] >= 0 {
            return dp[i][mask]
        }
        let sd = sn[sn.index(sn.startIndex, offsetBy: i)]
        var res = 0,t = same ? Int(String(sd))! : 9
        for k in 0..<(t + 1) where mask & (1 << k) == 0 {
            res += f(mask: mask == 0 && k == 0 ? mask : mask | (1 << k), sn: sn, i: i+1, same: same && k == t)
        }
        if !same {
            dp[i][mask] = res
        }
        return res
    }
    return n + 1 - f(mask:0,sn:str,i:0,same:true)
}

//2469. 温度转换
/**
 给你一个四舍五入到两位小数的非负浮点数 celsius 来表示温度，以 摄氏度（Celsius）为单位。

 你需要将摄氏度转换为 开氏度（Kelvin）和 华氏度（Fahrenheit），并以数组 ans = [kelvin, fahrenheit] 的形式返回结果。

 返回数组 ans 。与实际答案误差不超过 10-5 的会视为正确答案。

 注意：

 开氏度 = 摄氏度 + 273.15
 华氏度 = 摄氏度 * 1.80 + 32.00
 */
func convertTemperature(_ celsius: Double) -> [Double] {
    let ks =  celsius + 273.15
    let hs = celsius * 1.80 + 32.00
    return [ks,hs]
}


//643. 子数组最大平均数 I
func findMaxAverage(_ nums: [Int], _ k: Int) -> Double {
    var sum = 0,begin = 0,res = Int.min
    for i in 0..<nums.count  {
        if i - begin < k {
            sum += nums[i]
            continue
        }
        res = max(res,sum)
        sum -= nums[begin]
        begin += 1
        sum += nums[i]
    }
    res = max(res,sum)
    return Double(res) / Double(k)
}

//1626. 无矛盾的最佳球队
func bestTeamScore(_ scores: [Int], _ ages: [Int]) -> Int {
    //年龄小，分数高的排前面
    let sortI = scores.enumerated().sorted { elemt1, elemt2 in
        if elemt1.element < elemt2.element {
            return true
        } else if elemt1.element == elemt2.element {
            return ages[elemt1.offset] < ages[elemt2.offset]
        }
        return false
    }.map(\.offset)
    var res = 0
    var dp = Array(repeating: 0, count: sortI.count)
    for i in 0..<sortI.count {
        for j in (0..<i).reversed() {
            if ages[sortI[j]] <= ages[sortI[i]] {
                dp[i] = max(dp[i],dp[j])
            }
        }
        dp[i] += scores[sortI[i]]
        res = max(res,dp[i])
    }
    
    return res
}

//1630. 等差子数组
// [4,6,5,9,3,7], l = [0,0,2], r = [2,3,5]
// 3 4 5 6 7 9
// 4 0 2 1 6 3
func checkArithmeticSubarrays(_ nums: [Int], _ l: [Int], _ r: [Int]) -> [Bool] {
    var res = Array(repeating: false, count: l.count)
outer:for i in 0..<res.count {
        let left = l[i],right = r[i]
        var minv = nums[left],maxv = nums[left]
        for j in (left + 1)..<(right+1) {
            minv = min(nums[j],minv)
            maxv = max(nums[j],maxv)
        }
        guard minv != maxv else {
            res[i] = true
            continue
        }
        guard (maxv - minv) % (right - left) == 0 else {
            continue
        }
        let avg = (maxv - minv) / (right - left)
        var see = Array(repeating: false, count: right - left+1)
        for j in left...right {
            if (nums[j] - minv) % avg != 0 {
                continue outer
            }
            let t = (nums[j] - minv) / avg
            if see[t] {
                continue outer
            }
            see[t] = true
        }
         res[i] = true
        
    }
    
    return res
}


//1574. 删除最短的子数组使剩余数组有序，使得 arr 中剩下的元素是 非递减 的。
func findLengthOfShortestSubarray(_ arr: [Int]) -> Int {
    var r = arr.count - 1
   
    while r > 0,
        arr[r] >= arr[r-1] {
        r -= 1
    }
    
    if r == 0 { return 0 }
    var res = r
    for i in 0..<arr.count {
        while r < arr.count,arr[r] < arr[i] {
            r += 1
        }
        res = min(res,r - i - 1)
        if i + 1 < arr.count,arr[i] > arr[i+1] { break }
    }
    
    return res
}

//2395. 和相等的子数组
func findSubarrays(_ nums: [Int]) -> Bool {
    var set:Set<Int> = []
    for i in 0..<(nums.count-1) {
        if set.contains(nums[i] + nums[i+1]) {
            return true
        }
        set.insert(nums[i] + nums[i+1])
    }
    return false
}

//682. 棒球比赛
func calPoints(_ operations: [String]) -> Int {
    var res = 0,arr = [Int]()
    for operation in operations {
        switch operation {
        case "C": res -= arr.removeLast()
        case "D":
            arr.append(arr.last! * 2)
            res += arr.last!
        case "+":
            let n = arr.count-1
            arr.append(arr[n] + arr[n-1])
            res += arr.last!
        default:
            arr.append(Int(operation)!)
            res += arr.last!
        }
    }
    return res
}

//1637. 两点之间不包含任何点的最宽垂直区
//[[3,1],[9,0],[1,0],[1,4],[5,3],[8,8]]
// 1 3 5 8 9
func maxWidthOfVerticalArea(_ points: [[Int]]) -> Int {
    var sortPoint = points
    func quickSort(l:Int,r:Int) {
        guard l < r else { return }
        var left = l - 1,right = r + 1,i = l
        let mid = sortPoint[l][0]
        while i < right {
            if sortPoint[i][0] < mid {
                left += 1
                swap(i: left, j: i)
                i += 1
            } else if sortPoint[i][0] > mid {
                right -= 1
                swap(i: right, j: i)
            } else {
                i += 1
            }
        }
        quickSort(l: l, r: left)
        quickSort(l: right, r:r)
    }
    
    func swap(i:Int,j:Int) {
        (sortPoint[i],sortPoint[j]) = (sortPoint[j],sortPoint[i])
    }
    quickSort(l: 0, r: sortPoint.count-1)
    var res = 0
    for i in 1..<sortPoint.count {
        res = max(sortPoint[i][0] - sortPoint[i-1][0],res)
    }
    return res
}


//11. 盛最多水的容器
func maxArea(_ height: [Int]) -> Int {
    var l = 0,r = height.count - 1,res = 0
    while l < r {
        if height[l] > height[r] {
            res = max(res,height[r] * (r - l))
            r -= 1
        } else {
            res = max(res,height[l] * (r - l))
            l += 1
        }
    }
    return res
}

//2367. 算术三元组的数目
//[0,1,4,6,7,10], diff = 3
//
func arithmeticTriplets(_ nums: [Int], _ diff: Int) -> Int {
    var res = 0
    var map = Set<Int>()
    for num in nums {
        map.insert(num)
        if map.contains(num - diff),map.contains(num - diff - diff) {
            res += 1
        }
    }
    return res
}

func thirdMax(_ nums: [Int]) -> Int {
    let sorNum = nums.sorted()
    var res = sorNum.last!,index = 1
    for i in (0..<(sorNum.count - 1)).reversed() {
        guard index < 3 else {
            return res
        }
        if sorNum[i] < res {
            res = sorNum[i]
            index += 1
        }
    }
    return index == 3 ? res:sorNum.last!
}

//1039. 多边形三角剖分的最低得分
func minScoreTriangulation(_ values: [Int]) -> Int {
    let n = values.count
    var map = [Int:Int]()
    func dp(i:Int,j:Int) -> Int {
        guard i + 2 < j else {
            return i + 2 == j ? values[i] * values[i+1] * values[j] : 0
        }
        let key = i * n + j
        guard let num = map[key] else {
            var minScore = Int.max
            for k in (i+1)..<j {
                let temp = values[i] * values[j] * values[k]
                minScore = min(minScore,temp + dp(i: i, j: k) + dp(i: k, j: j))
            }
            map[key] = minScore
            return minScore
        }
        return num
    }
    return dp(i: 0, j: n-1)
}


//1053. 交换一次的先前排列
//给你一个正整数数组 arr（可能存在重复的元素），请你返回可在 一次交换（交换两数字 arr[i] 和 arr[j] 的位置）后得到的、按字典序排列小于 arr 的最大排列。
// 从后往前找到，非递减的第一个i,[i+1,n)是递增的，从n-1开始找到小于他的第一个参数即可

func prevPermOpt1(_ arr: [Int]) -> [Int] {
    let n = arr.count
    for i in (0..<(n-1)).reversed() {
        if arr[i] > arr[i + 1] {
            var j = n - 1
            while arr[j] >= arr[i] || arr[j] == arr[j-1] {
                j -= 1
            }
            var temp = arr
            (temp[i],temp[j]) = (arr[j],arr[i])
            return temp
        }
    }
    return arr
}

//1000. 合并石头的最低成本
func mergeStones(_ stones: [Int], _ k: Int) -> Int {
    guard (stones.count - k) % (k-1) == 0 else {
        return -1
    }
    //[i,j]
    var dp = Array(repeating: Array(repeating: Array(repeating: -1, count: stones.count), count: stones.count), count: k+1)
    var sum = Array(repeating: 0, count: stones.count+1)
    for i in 0..<stones.count{
        dp[1][i][i] = 0
        sum[i+1] = sum[i] + stones[i]
    }
    
    func dpArr(l:Int,r:Int,t:Int) -> Int {
        guard dp[t][l][r] == -1 else {
            return dp[t][l][r]
        }
        guard t <= r - l + 1 else {
            return Int.max
        }
        guard t == 1 else {
            var res = Int.max
            for p in stride(from: l, to: r, by: k-1) {
                res = min(res,dpArr(l: l, r: p, t: 1) + dpArr(l: p+1, r: r, t: t-1))
            }
            dp[t][l][r] = res
            return dp[t][l][r]
        }
        let res = dpArr(l: l, r: r, t: k)
        
        dp[t][l][r] = res == Int.max ? Int.max: (res + (sum[r+1] - (l == 0 ? 0 : sum[l])))
        return dp[t][l][r]
    }
    return dpArr(l: 0, r: stones.count-1, t: 1)
}

func commonFactors(_ a: Int, _ b: Int) -> Int {
    var res = 1,n = min(a, b)
    for i in 2..<(n+1) {
        if a % i == 0,b % i == 0 {
            res += 1
        }
    }
    return res
}

//移动石子直到连续 II
func numMovesStonesII(_ stones: [Int]) -> [Int] {
    let n = stones.count
    let sorStone = stones.sorted()
    guard sorStone[n-1] - sorStone[0] + 1 != n else {
        return [0,0]
    }
    let maxNum = max(sorStone[n-2] - sorStone[0] + 1,sorStone[n-1] - sorStone[1] + 1) - (n-1)
    var minNum = n
    var j = 0
    for i in 0..<n where j + 1 < n{
        while j + 1 < n,sorStone[j + 1] - sorStone[i] + 1 <= n {
            j += 1
        }
        
        if j-i+1 == n - 1,sorStone[j] - sorStone[i] + 1 == n-1 {
            minNum = min(minNum,2)
        } else {
            minNum = min(minNum,n - (j - i + 1))
        }
        
    }
    
    return [minNum,maxNum]
}

//1041. 困于环中的机器人
//每次最多四次
func isRobotBounded(_ instructions: String) -> Bool {
    let direc = [(0,1),(1,0),(0,-1),(-1,0)]
    var direcI = 0,x = 0,y = 0
    for inC in instructions {
        if inC == "G" {
            x += direc[direcI].0
            y += direc[direcI].1
        } else if inC == "L" {
            direcI = (direcI + 3) % 4
        } else {
            direcI = (direcI + 1) % 4
        }
    }
    return direcI != 0 || (x == 0 && y == 0)
}


//2404. 出现最频繁的偶数元素
func mostFrequentEven(_ nums: [Int]) -> Int {
    var map = [Int:Int](),res = -1
    for num in nums where num % 2 == 0{
        map[num] = (map[num] ?? 0) + 1
        guard res != -1 else {
            res = num
            continue
        }
        if map[num]! > map[res]! {
            res = num
        } else if map[num]! == map[res]! {
            res = min(num,res)
        }
    }
    return res
}


func gardenNoAdj(_ n: Int, _ paths: [[Int]]) -> [Int] {
    guard n > 4 else {
        return Array(1...n)
    }
    var res = Array(repeating: 0b1111, count: n)
    var map = [Int:[Int]]()
    for path in paths {
        map[path.min()!] = (map[path.min()!] ?? []) + [path.max()!]
    }
    for i in 1...n {
        //取最后一个1作为颜色
        let temp = res[i-1] & (~res[i-1] + 1)
        guard let arr = map[i] else {
            continue
        }
        for j in arr where res[j-1] & temp > 0 {
            res[j-1] ^= temp
        }
    }
    return res.map { num in
        return Int(log2(Double(num & (~num + 1)))) + 1
    }
}

// 918. 环形子数组的最大和
// 1 2 3
//[3,-1,2,-1]
// [-5,-2,5,6,-2,-7,0,2,8]
func maxSubarraySumCircular(_ nums: [Int]) -> Int {
    let n = nums.count
    var last = nums[0],z = 1,res = last
    for i in 1..<2 * n {
        if z == n {
            //删掉最左边的
            var temp = last - nums[(i - z) % n],maxTemp = (z-1,temp)
            
            for d in (1..<z).reversed() {
                temp -= nums[(i - d) % n]
                if temp > maxTemp.1 {
                    maxTemp = (d-1,temp)
                }
            }
            (z,last) = maxTemp
        }
        let cur = nums[i % n]
        if last >= 0 {
            z += 1
            last = cur + last
        } else {
            //小于0，则不要了,以当前开始
            z = 1
            last = cur
        }
        res = max(res,last)
    }
    return res
}


//1499. 满足不等式的最大值
func findMaxValueOfEquation(_ points: [[Int]], _ k: Int) -> Int {
    var res = Int.min
    var queue = [[Int]]()
    for point in points {
        let x = point[0],y = point[1]
        while !queue.isEmpty,x - queue.first![1] > k {
            queue.removeFirst()
        }
        if !queue.isEmpty {
            res = max(res, x + y + queue.first![0])
        }
        while !queue.isEmpty,y - x >= queue.last![0] {
            queue.removeLast()
        }
        queue.append([y-x,x])
    }
    return res
}


//860. 柠檬水找零
func lemonadeChange(_ bills: [Int]) -> Bool {
    var five = 0,ten = 0
    for bill in bills {
        switch bill {
        case 5:
            five += 1
        case 10:
            guard five > 0 else {
                return false
            }
            five -= 1
            ten += 1
        case 20:
            if ten > 0,five > 0 {
                ten -= 1
                five -= 1
            } else if five > 2 {
                five -= 3
            } else {
                return false
            }
        default:return false
        }
    }
    return true
}


// 49. 字母异位词分组
/**
 给你一个字符串数组，请你将 字母异位词 组合在一起。可以按任意顺序返回结果列表。

 字母异位词 是由重新排列源单词的所有字母得到的一个新单词。*/
func groupAnagrams(_ strs: [String]) -> [[String]] {
    var res = [[String]](),map = [String:Int]()
    func buildGroupKey(key:String) -> String {
        var arr = Array(repeating: 0, count: 26)
        let b = UnicodeScalar("a").value
        for kc in key {
            let t = Int(UnicodeScalar(String(kc))!.value - b)
            arr[t] += 1
        }
        return arr.reduce("") { "\($0)_\($1)" }
    }
    
    for str in strs {
        let key = buildGroupKey(key: str)
        if let index = map[key] {
            res[index].append(str)
        } else {
            map[key] = res.count
            res.append([str])
        }
    }
    return res
}

// 128. 最长连续序列
/**
 给定一个未排序的整数数组 nums ，找出数字连续的最长序列（不要求序列元素在原数组中连续）的长度。

 请你设计并实现时间复杂度为 O(n) 的算法解决此问题。
 */
func longestConsecutive(_ nums: [Int]) -> Int {
    var numDic: [Int:Int] = [:],res = 0
    for num in nums where numDic[num] == nil{ //去重
        let l = numDic[num-1,default: 0]
        let r = numDic[num+1,default: 0]
        let curL = 1 + l + r
        if curL > res {
            res = curL
        }
        numDic[num] = 1
        numDic[num - l] = curL
        numDic[num + r] = curL
    }
    return res
}
