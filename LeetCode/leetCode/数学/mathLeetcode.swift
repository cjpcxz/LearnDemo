//
//  mathLeetcode.swift
//  leetCode
//
//  Created by 陈晶泊 on 2022/8/16.
//

import Foundation
//二进制求和
func addBinary(_ a: String, _ b: String) -> String {
    let aArr = Array(a)
    let bArr = Array(b)
    let aCount = a.count
    let bCount = b.count
    let count = min(a.count,b.count)
    var flag = false
    var result = [Character]()
    for i in (1...count) {
        if aArr[aCount - i] == "1",bArr[bCount - i] == "1"{
            flag ? result.append("1"):result.append("0")
            flag = true
        } else if aArr[aCount - i] == "1" || bArr[bCount - i] == "1" {
            if flag {
                flag = true
                result.append("0")
            } else {
                flag = false
                result.append("1")
            }
            
        } else {
            flag ? result.append("1"):result.append("0")
            flag = false
        }
    }
    let maxArr = aCount > bCount ? aArr:bArr
    for i in (0..<(maxArr.count - count)).reversed() {
        if flag,maxArr[i]=="1"{
            result.append("0")
            flag = true
        } else if flag,maxArr[i]=="0"{
            result.append("1")
            flag = false
        } else {
            result.append(maxArr[i])
        }
    }
    if flag {
        result.append("1")
    }
    return String(result.reversed())
}

func lengthOfLastWord(_ s: String) -> Int {
    let sArr = Array(s)
    var num = 0
    for i in (0..<sArr.count).reversed() {
        if num > 0,sArr[i] == " " {
            break
        } else if sArr[i] != " " {
            num += 1
        }
    }
    return num
}

//119. 杨辉三角 II
func getRow(_ rowIndex: Int) -> [Int] {
    var temp = Array(repeating: 0, count: rowIndex+1)
    let count = temp.count-1
    for i in 0...rowIndex {
        var tempLast = 0
        for j in (0...i) {
            let temCur = tempLast
            tempLast = temp[count - j]
            if j == 0 || j == i{
                temp[count - j] = 1
            } else {
                temp[count - j] = temp[count - j]+temCur
            }
            
        }
    }
    return temp
}

//在既定时间做作业的学生人数
func busyStudent(_ startTime: [Int], _ endTime: [Int], _ queryTime: Int) -> Int {
    guard startTime.count == endTime.count else {
        return 0
    }
    var result = 0
    for i in 0..<startTime.count {
        if startTime[i] <= queryTime,queryTime <= endTime[i] {
            result += 1
        }
    }
    return result
}

//782. 变为棋盘
func movesToChessboard(_ board: [[Int]]) -> Int {
    let n = board.count
    var rowMask = 0,colMask = 0
    for i in 0..<n {
        rowMask = rowMask | (board[0][i] << i)
        colMask = colMask | (board[i][0] << i)
    }
    
    let reverseRowMask = ((1 << n) - 1) ^ rowMask
    let reverseColMask = ((1 << n) - 1) ^ colMask
    var rowCnt = 0,colCnt = 0
    for i in 0..<n {
        var currRowMask = 0
        var currColMask = 0
        for j in 0..<n {
            currRowMask = currRowMask | (board[i][j] << j)
            currColMask = currColMask | (board[j][i] << j)
            
        }
        /* 检测每一行的状态是否合法 */
        if currRowMask != rowMask && currRowMask != reverseRowMask {
            return -1
        } else if (currRowMask == rowMask) {
            rowCnt += 1
        }
        /* 检测每一列的状态是否合法 */
        if currColMask != colMask && currColMask != reverseColMask {
            return -1
        } else if (currColMask == colMask) {
            colCnt += 1
        }
    }
    let rowMoves = getMoves(rowMask, rowCnt, n);
    let colMoves = getMoves(colMask, colCnt, n);
    return (rowMoves == -1 || colMoves == -1) ? -1 : (rowMoves + colMoves)
}

func getMoves(_ mask:Int,_ count:Int,_ n:Int)->Int {
    let ones = numOne(mask)
    if (n & 1) == 1 {
        /* 如果 n 为奇数，则每一行中 1 与 0 的数目相差为 1，且满足相邻行交替 */
        if abs(n-2 * ones) != 1 || abs(n - 2*count) != 1 {
            return -1
        }
        if ones == (n >> 1) {
            //1的数量为偶数,(1010 1010 1010 1010 1010 1010 1010 1010)只保留偶数位的1
            return (n / 2 - numOne(mask & 0xAAAAAAAA))
        } else {
            return ((n + 1) / 2 - numOne(mask & 0x55555555))
        }
    } else {
        /* 如果 n 为偶数，则每一行中 1 与 0 的数目相等，且满足相邻行交替 */
        if ones != (n >> 1) || count != (n >> 1) {
            return -1
        }
        let count0 = (n / 2) - numOne(mask & 0xAAAAAAAA)
        let count1 = (n / 2) - numOne(mask & 0x55555555)
        return min(count0, count1)
    }
}

func numOne(_ mask:Int)->Int{
    var temp = mask
    var result = 0
    while temp > 0 {
        if (temp & 1) == 1 {
            result += 1
        }
        temp = temp >> 1
    }
    return result
}

//1460. 通过翻转子数组使两个数组相等
/*
 target.length == arr.length
 1 <= target.length <= 1000
 1 <= target[i] <= 1000
 1 <= arr[i] <= 1000
 */
func canBeEqual(_ target: [Int], _ arr: [Int]) -> Bool {
    var nums = Array(repeating: 0, count: 1001)
    for i in target {
        nums[i] = nums[i] + 1
    }
    for i in arr {
        let temp =  nums[i] - 1
        if temp == -1 {
            return false
        }
        nums[i] = temp
    }
    return true
}

//231. 2 的幂
func isPowerOfTwo(_ n: Int) -> Bool {
    
    return (n & (n - 1)) == 0
}

//658. 找到 K 个最接近的元素
func findClosestElements(_ arr: [Int], _ k: Int, _ x: Int) -> [Int] {
    guard arr.count > k else {
        return arr
    }
    var result = [Int]()
    let count = arr.count
    var num = k
    var left = 0,right = count - 1
    while left < right {
        let mid = (left + right) >> 1
        if arr[mid] >= x {
            right = mid
        } else {
            left = mid + 1
        }
    }
    right = left
    left = right - 1
    
    while num > 0 {
        if left >= 0,right < count {
            if (x - arr[left]) <= (arr[right] - x) {
                result = [arr[left]] + result
                left -= 1
            } else {
                result.append(arr[right])
                right += 1
            }
        } else if left >= 0 {
            result = [arr[left]] + result
            left -= 1
        } else if right < count {
            result.append(arr[right])
            right += 1
        }
        num -= 1
    }
    return result
}

//. 数组中两元素的最大乘积
func maxProduct(_ nums: [Int]) -> Int {
    let count = nums.count
    var frist,second:Int
    if nums[0] > nums[count-1] {
        frist = 0
        second = count-1
    } else {
        frist = count-1
        second = 0
    }
    for i in 1..<count-1 {
        if nums[i] > nums[frist] {
            second = frist
            frist = i
        } else if nums[i] > nums[second] {
            second = i
        }
    }
    return (nums[frist] - 1) * (nums[second] - 1)
}
//3. 阶乘函数后 K 个零
func preimageSizeFZF(_ k: Int) -> Int {
    var left = 4 &* k,right = 5 &* k
    while left < right {
        let mid = (right - left)>>1 + left
        if f(mid) >= k {
            right = mid
        } else {
            left = mid + 1
        }
    }
    return f(left) == k ? 5:0
}

func f(_ x:Int)->Int {
    var ans = 0
    var num = x
    while num != 0 {
        num = num / 5
        ans += num
    }
    return ans
}

//重新排列
func shuffle(_ nums: [Int], _ n: Int) -> [Int] {
    var num = nums
    var index = 0
    let mask = 1 << 10 - 1
    for i in 0..<n {
        num[index] = ((num[i] & mask) << 10) | (num[index] & mask)
        index += 1
        num[index]  = ((num[i+n] & mask) << 10) | (num[index] & mask)
        index += 1
    }
    for i in 0..<2*n {
        num[i] = num[i] >> 10
    }
    return num
}

///946. 验证栈序列
func validateStackSequences(_ pushed: [Int], _ popped: [Int]) -> Bool {
    let count =  popped.count
    var index = 0,poppedIndex = 0
    var arr = pushed
    for i in 0..<count {
        arr[index] = arr[i]
        index += 1
        while index > 0,arr[index - 1] == popped[poppedIndex] {
            index -= 1
            poppedIndex += 1
        }
    }
    return index == 0
}

///1475. 商品折扣后的最终价格
func finalPrices(_ prices: [Int]) -> [Int] {
    var num = Array(repeating: 0, count: prices.count)
    var queue = [Int]()
    for i in (0..<prices.count).reversed() {
        while let frist = queue.last,frist > prices[i] {
            queue.removeLast()
        }
        num[i] = prices[i] - (queue.last ?? 0)
        queue.append(prices[i])
    }
    return num
}

//202. 快乐数,最后数字会不断变小，1的话一直变也是1，快慢指针的思路
func isHappy(_ n: Int) -> Bool {
    var fast = n,low = n
    repeat {
        low = isHappyNum(low)
        fast = isHappyNum(fast)
        fast = isHappyNum(fast)
    } while fast != low
    return low == 1
}

func isHappyNum(_ n: Int)->Int {
    var num = n
    var result = 0
    while num > 0 {
        let temp = num % 10
        result += temp * temp
        num = num / 10
    }
    return result
}
///1582. 二进制矩阵中的特殊位置
func numSpecial(_ mat: [[Int]]) -> Int {
    //预处理为1的行列数
    let r = mat.count,c = mat[0].count
    var rows = Array(repeating: 0, count: r)
    var colum = Array(repeating: 0, count: c)
    
    for i in 0..<r {
        for j in 0..<c {
            rows[i] += mat[i][j]
            colum[j] += mat[i][j]
        }
    }
    var ams = 0
    for i in 0..<r {
        for j in 0..<c {
            if mat[i][j] == 1,rows[i]==1,colum[j]==1 {
                ams += 1
            }
        }
        
    }
    return ams
}
//205. 同构字符串
func isIsomorphic(_ s: String, _ t: String) -> Bool {
    let sA = Array(s),tA = Array(t)
    var map1 = [Character:Character]()
    var map2 = [Character:Character]()
    for i in 0..<sA.count {
        if let m1 = map1[sA[i]],let m2 = map2[tA[i]]{
            guard m1 == tA[i],m2 == sA[i] else {
                return false
            }
        } else if map1[sA[i]] == nil,map2[tA[i]] == nil{
            map1[sA[i]] = tA[i]
            map2[tA[i]] = sA[i]
        } else {
            return false
        }
    }
    return true
}

//169. 多数元素
func majorityElement(_ nums: [Int]) -> Int {
    var num = nums[0],c = 1
    for i in 1..<nums.count {
        if nums[i] == num {
           c += 1
        } else if c == 0{
            c += 1
            num = nums[i]
        } else {
            c -= 1
        }
    }
    return num
}

//667. 优美的排列 II
func constructArray(_ n: Int, _ k: Int) -> [Int] {
    var left = 1,right = n
    var result = [left]
    left += 1
    var k1 = k
    var leftEnd = true
    while left < right,k1 > 1{
        if left < right,k1 > 1 {
            result.append(right)
            k1 -= 1
            right -= 1
            leftEnd = false
        }
       
        if left < right,k1 > 1 {
            result.append(left)
            k1 -= 1
            left += 1
            leftEnd = true
        }
    }
    if leftEnd {
        for i in left...right {
            result.append(i)
        }
    } else {
        for i in (left...right).reversed() {
            result.append(i)
        }
    }
    return result

}

//219. 存在重复元素 II
func containsNearbyDuplicate(_ nums: [Int], _ k: Int) -> Bool {
    var map = [Int:Int]()
    var minX = Int.max
    for (i,num)in nums.enumerated() {
        guard let j = map[num] else {
            map[num] = i
            continue
        }
        minX = min(minX,i-j)
        map[num] = i
    }
 return minX <= k
}

///雇佣 K 名工人的最低成本
func mincostToHireWorkers(_ quality: [Int], _ wage: [Int], _ k: Int) -> Double {
    var wqArr = [[Double]]()
    for i in 0..<quality.count {
        let x = Double(quality[i]),y = Double(wage[i])
        let wq = y / x
        updateSort(&wqArr, [wq,Double(i)])
    }
    var toal = 0.0,result = Double(Int.max)
    
    var queue = [[Double]]()
    for  i in 0..<wqArr.count {
        let j = Int(wqArr[i][1])
        toal += Double(quality[j])
        updateSort(&queue, [Double(quality[j])])
        if i >= k {
            toal = toal - queue.removeLast()[0]
        }
        if i >= (k-1) {
            result = min(result,toal * wqArr[i][0])
        }
    }
   return result
}

func updateSort(_ arr:inout [[Double]],_ num:[Double]) {
    guard let frist = arr.first?.first,let last =  arr.last?.first else {
        arr.append(num)
        return
    }
    
    if frist < num[0],last > num[0] {
        //位于中间
        for i in 0..<arr.count {
            if arr[i][0] > num[0] {
                arr.insert(num, at: i)
                break
            }
        }
    } else if frist >= num[0] {
        //在左边
        arr.insert(num, at: 0)
    } else {
        //在右边，且在范围内
        arr.append(num)
    }
}


func specialArray(_ nums: [Int]) -> Int {
    var numArr = nums
    let count = numArr.count-1
    specialSort(&numArr, left: 0, right: count)
    for i in 0...count {
        if numArr[count - i] >= (i + 1),( (count - i == 0) || numArr[count - i - 1] < (i + 1)){
            return i + 1
        }
    
    }
    return -1
}

func specialSort(_ nums:inout [Int],left:Int,right:Int) {
    guard left < right else {
        return
    }
    var i = left-1,j = right+1,index = left,num = nums[left]
    while index < j {
        if nums[index] < num {
            let temp = nums[index]
            i += 1
            nums[index] = nums[i]
            nums[i] = temp
            index += 1
        } else if nums[index] == num {
            index += 1
        } else {
            let temp = nums[index]
           j -= 1
            nums[index] = nums[j]
            nums[j] = temp
        }
    }
    specialSort(&nums, left: left, right: i)
    specialSort(&nums, left: j, right: right)
}

func trimMean(_ arr: [Int]) -> Double {
    var sorArr = arr.sorted()
    let count = Int(Double(arr.count) * 0.05)
    var result = 0
    for i in (count..<(arr.count - count)) {
        result += sorArr[i]
    }
return Double(result) / Double(arr.count - 2 * count)
}

//672. 灯泡开关 Ⅱ
func flipLights(_ n: Int, _ presses: Int) -> Int {
    if (presses == 0) {
        return 1
    }
    //特殊情况处理
    if (n == 1) {
        return 2;
    } else if (n == 2) {
        //特殊情况
        return presses == 1 ? 3 : 4;
    } else {
        //n >= 3
        return presses == 1 ? 4 : presses == 2 ? 7 : 8;
    }
  
}
//850. 矩形面积 II
var sdaanum = 0
func rectangleArea(_ rectangles: [[Int]]) -> Int {
    let mod = Int(powl(10, 9)) + 7
    var rangNum = [Int]()
    for rectangle in rectangles {
        let temp1 = rectangle[0]
        let temp2 = rectangle[2]
        rangNum.append(contentsOf: [temp1,temp2])
        
    }
    rangNum.sort()
    var ans = 0
    let count = rectangles.count
    for i in 1..<rangNum.count {
        let a = rangNum[i - 1],b = rangNum[i],len = b - a
        guard len > 0 else {
            continue
        }
        var lins = [(Int,Int)]()
        for i in 0..<count {
            let arr = rectangles[i]
            if a >= arr[0],b <= arr[2] {
                lins.append((arr[1],arr[3]))
            }
            
        }
        
        lins.sort { infos1,infos2 in
            if infos1.0 < infos2.0 {
                return true
            } else if infos1.0 == infos2.0 {
                return infos1.1 < infos2.1
            }
            return false
        }
        var toal = 0,l = -1,r = -1
        for i in lins {
            if i.0 > r {
                toal += r - l
                l = i.0
                r = i.1
            } else if i.1 > r {
                r = i.1
            }
        }
        toal += r - l
        ans += toal * len
        ans %= mod
        
        
    }
    return ans
}

//827. 最大人工岛
func largestIsland(_ grid: [[Int]]) -> Int {
    let count = grid.count
    var hasLand = Array(repeating: Array(repeating: 0, count: count), count: count)
    var tag = 2
    var map = [Int:Int]()
    var maxResult = 0
    for i in 0..<count {
        for j in 0..<count {
            if grid[i][j] == 1,hasLand[i][j] == 0{
                var value = 0
                findLand(&hasLand, grid, i, j, &value, tag)
                map[tag] = value
                tag += 1
            } else if grid[i][j] == 0 {
                var maxTemp = 1,tagArr = [Int]()
                if i-1 >= 0,grid[i-1][j] == 1 {
                    let k = i-1,z = j
                    //左边的
                    if hasLand[k][z] != 0 {
                        //之前有存
                        tagArr.append(hasLand[k][z])
                        maxTemp += map[hasLand[k][z]]!
                    } else {
                        //之前有没存
                        var value = 0
                        findLand(&hasLand, grid, k, z, &value, tag)
                        map[tag] = value
                        tagArr.append(tag)
                        maxTemp += value
                        tag += 1
                    }
                }
                
                if i+1 < count,grid[i+1][j] == 1 {
                    let k = i+1,z = j
                    //右边的
                    if hasLand[k][z] != 0{
                        //之前有存
                        if !tagArr.contains(hasLand[k][z]) {
                            tagArr.append(hasLand[k][z])
                            maxTemp += map[hasLand[k][z]]!
                        }
                    } else {
                        //之前有没存
                        var value = 0
                        findLand(&hasLand, grid, k, z, &value, tag)
                        map[tag] = value
                        tagArr.append(tag)
                        maxTemp += value
                        tag += 1
                    }
                }
                
                if j-1 >= 0,grid[i][j-1] == 1 {
                    let k = i,z = j-1
                    //上边的
                    if hasLand[k][z] != 0 {
                        //之前有存
                        if !tagArr.contains(hasLand[k][z]) {
                            tagArr.append(hasLand[k][z])
                            maxTemp += map[hasLand[k][z]]!
                        }
                    } else {
                        //之前有没存
                        var value = 0
                        findLand(&hasLand, grid, k, z, &value, tag)
                        map[tag] = value
                        tagArr.append(tag)
                        maxTemp += value
                        tag += 1
                    }
                }
                
                if j+1 < count,grid[i][j+1] == 1 {
                    let k = i,z = j+1
                    //下边的
                    if hasLand[k][z] != 0 {
                        //之前有存
                        if !tagArr.contains(hasLand[k][z]) {
                            tagArr.append(hasLand[k][z])
                            maxTemp += map[hasLand[k][z]]!
                        }
                    } else {
                        //之前有没存
                        var value = 0
                        findLand(&hasLand, grid, k, z, &value, tag)
                        map[tag] = value
                        tagArr.append(tag)
                        maxTemp += value
                        tag += 1
                    }
                }
                maxResult = max(maxResult,maxTemp)
            }
        }
    }
    return maxResult != 0 ? maxResult:(count * count)
}

func findLand(_ hasLand: inout [[Int]],_ grid:[[Int]],_ i:Int,_ j:Int,_ value:inout Int,_ tag:Int){
    let count = grid.count
    guard case 0..<count = i,case 0..<count = j,grid[i][j] == 1,hasLand[i][j] != tag else {
        return
    }
    value += 1
    hasLand[i][j] = tag
    findLand(&hasLand,grid,i, j-1, &value,tag) //向左
    findLand(&hasLand,grid, i, j + 1, &value,tag) //向右
    findLand(&hasLand,grid,i+1, j, &value,tag) //向下
    findLand(&hasLand,grid,i-1, j, &value,tag) //向上
}

//1636. 按照频率将数组升序排序
func frequencySort(_ nums: [Int]) -> [Int] {
    var freMap = [Int:Int]()
    for num in nums {
        freMap[num] = (freMap[num] ?? 0) + 1
    }
    let keys = freMap.keys.sorted { key1, key2 in
        if freMap[key1]! < freMap[key2]! {
            return true
        } else if freMap[key1]! == freMap[key2]! {
            return key1 > key2
        }
        return false
    }
    var nums = [Int]()
    for key in keys {
        nums.append(contentsOf: Array(repeating: key, count: freMap[key]!))
    }
    return nums
}

//698. 划分为k个相等的子集
func canPartitionKSubsets(_ nums: [Int], _ k: Int) -> Bool {
    let total = nums.reduce(0) { partialResult, i in
        return partialResult + i
    }
    guard total % k == 0 else {
        return false
    }
    let num = total / k
    let count = nums.count
    let sorArr = nums.sorted()
    let vs = 1 << count - 1
    func dfs(_ idx: Int, _ cur: Int,_ cnt:Int,_ vs:Int)->Bool {
        if cnt == k {
            return true
        }
        if cur == num {
            return dfs(count-1, 0, cnt + 1, vs)
        }
        var s = vs
        var i = idx
        while i >= 0 {
            defer {
                i-=1
            }
            if ((s >> i) & 1 == 0) || (sorArr[i] + cur) > num {
                continue
            }
            s = s ^ (1 << i)
            if dfs(i - 1, cur + sorArr[i], cnt, s) {
                return true
            }
            s = s ^ (1 << i)
            if cur == 0 {
                return false
            }
        }
        return false
    }
    
    return dfs(count - 1, 0, 0, vs)
}


//1640. 能否连接形成数组
func canFormArray(_ arr: [Int], _ pieces: [[Int]]) -> Bool {
    var map = [Int:Int]()
    for (i,piece) in pieces.enumerated() {
        map[piece[0]] = i
    }
    var j = 0
    while j < arr.count {
        guard let index = map[arr[j]] else {
            return false
        }
        for num in pieces[index] {
            guard num == arr[j] else {
                return false
            }
            j += 1
        }
    }
    return true
}

//1652. 拆炸弹
func decrypt(_ code: [Int], _ k: Int) -> [Int] {
    let count = code.count
    if k == 0 {
        return Array(repeating: 0, count: count)
    } else if k > 0 {
        var sum = 0
        let count = code.count
        for i in 0..<k {
            sum += code[i]
        }
        var result = [Int]()
        for (i,v) in code.enumerated() {
            let add = code[(i+k) % count]
            sum += add - v
            result.append(sum)
        }
        return result
    } else {
        var sum = 0
        let l = count+k
        for i in l..<count {
            sum += code[i]
        }
        var result = [Int]()
        for (i,v) in code.enumerated() {
            result.append(sum)
            let sub = code[(l + i) % count]
            sum += v - sub
        }
        return result
    }
}

//258. 各位相加
func addDigits(_ num: Int) -> Int {
    var sum = num
    while sum > 9 {
        var temp = 0
        var tempSum = sum
        while tempSum > 0 {
            temp += tempSum % 10
            tempSum = tempSum / 10
        }
        sum = temp
    }
    return sum
    
}

//788. 旋转数字
func rotatedDigits(_ n: Int) -> Int {
    let numStr = String(n)
    let count = numStr.count
    var sum = 0
    var isAll = false
    for (i,v) in numStr.enumerated() {
        let temp = Int(String(v))!
        sum += rotatedDigits(temp, count - i, isAll)
        switch temp {
        case 2,5,6,9:
            isAll = true
            break
        case 3,4,7:
            return sum
        default:
            break
        }
    }
    
    func rotatedDigits(_ num:Int,_ index:Int,_ isAll:Bool)->Int {
        
        //解析100之下的数据
        if index == 1 {
            switch num {
            case 0:
                return isAll ? 1:0
            case 1:
                return isAll ? 2:0
            case 2..<5:
                return isAll ? 3:1
            case 5:
                return isAll ? 4:2
            case 6..<8:
                return isAll ? 5:3
            case 8:
                return isAll ? 6:3
            case 9:
                return isAll ? 7:4
            default:
                return 0
            }
        }
        
        switch num {
        case 1:
            return digitsNum(index-1, isAll)
        case 2:
            return 2 * digitsNum(index-1, isAll)
        case 3...5:
            return (2 * digitsNum(index-1, isAll) + digitsNum(index-1, true))
        case 6:
            return (2 * digitsNum(index-1, isAll) + 2 * digitsNum(index-1, true))
        case 7...8:
            return (2 * digitsNum(index-1, isAll) + 3 * digitsNum(index-1, true))
        case 9:
            return (3 * digitsNum(index-1, isAll) + 3 * digitsNum(index-1, true))
        default:
            return 0
        }
        
    }
    
    func digitsNum(_ index:Int,_ isALl:Bool)->Int {
        
        
        guard index > 1 else {
            return isALl ? 7:4
        }
        
        guard !isALl else {
            return Int(Int(powl(7, Float80(index))))
            
        }
        
        return (4 * digitsNum(index-1, true) + 3 * digitsNum(index-1, false))
    }
    return sum
}

//面试题 17.19. 消失的两个数字
func missingTwo(_ nums: [Int]) -> [Int] {
    let n = nums.count + 2
    var sum = (1 + n) * n / 2
    for num in nums {
        sum -= num
    }
    let t = sum / 2
    var tSum = (t + 1) * t / 2
    for num in nums where num <= t{
        tSum -= num
    }
    return [tSum,sum - tSum]
}

//263. 丑数
func isUgly(_ n: Int) -> Bool {
    guard n != 0 else {
        return false
    }
    var num = n
    while abs(num) > 0 {
        if num == 1 {
            return true
        }
        
        if num % 2 == 0 {
            num  /= 2
        } else if num % 3 == 0 {
            num  /= 3
        } else if num % 5 == 0 {
            num  /= 5
        } else {
            return false
        }
        
    }
    return true
}

//面试题 01.08. 零矩阵
//[[-5,7,2147483647,3],
// [0,3,6,-2147483648],
// [8,3,-3,-6],
// [-9,-9,8,0]]
func setZeroes(_ matrix: inout [[Int]]) {
    guard !matrix.isEmpty else {
        return
    }
    let row = matrix.count,col = matrix[0].count
    var rows = [Int]()
    var cols = [Int]()
    for i in 0..<row {
        for j in 0..<col where matrix[i][j] == 0 {
            rows.append(i)
            cols.append(j)
        }
    }
    
    for i in rows {
        for j in 0..<col {
            matrix[i][j] = 0
        }
    }
    for j in cols {
        for i in 0..<row {
            matrix[i][j] = 0
        }
    }
}

//190. 颠倒二进制位
func reverseBits(_ n: Int) -> Int {
    var num = n
    var result = 0
    var numi = [Int]()
    var i = 1
    while num > 0 {
        if num & 1 == 1{
            numi.append(i)
        }
        num = num >> 1
        i += 1
    }
    for j in numi {
        result += 1 << (32-j)
    }
    return result
}

//228. 汇总区间
func summaryRanges(_ nums: [Int]) -> [String] {
    guard !nums.isEmpty else {
        return []
    }
    guard nums.count > 1 else {
        return ["\(nums[0])"]
    }
    var lastNum = nums[0]
    var len = 1
    var result = [String]()
    for i in 1..<nums.count {
        if nums[i] - lastNum != 1 {
            add(&result, lastNum, len)
            len = 1
        } else {
            len += 1
        }
        lastNum = nums[i]
    }
    add(&result, lastNum, len)
    func add(_ arr:inout [String],_ lastNum:Int,_ len:Int){
        if len == 1 {
            arr.append("\(lastNum)")
        } else {
            arr.append("\(lastNum+1-len)->\(lastNum)")
        }
    }
    return result
}

//349. 两个数组的交集
func intersection(_ nums1: [Int], _ nums2: [Int]) -> [Int] {
    var map = [Int:Int]()
    for nus in nums1 {
        map[nus] = 1
    }
    var arr = Set<Int>()
    for nus in nums2 where map[nus] != nil{
        arr.insert(nus)
    }
    return Array(arr)
}
//268. 丢失的数字
func missingNumber(_ nums: [Int]) -> Int {
    let n = nums.count
    return (1 + n) * n / 2 - nums.reduce(0, { partialResult, i in
        return partialResult + i
    })
}

//927. 三等分[0,1,0,0,1,1,0,1,0,1,1,1,1,0,1,0,1,1,0,0,1,0,0,1,1,0,1,1,0,1,1,0,1,0,1,0,0,1,1,0,1,0,1,1,1,1,0,1,0,1,1,0,0,1,0,0,1,1,0,1,1,0,1,1,0,1,0,1,0,0,1,1,0,1,0,1,1,1,1,0,1,0,1,1,0,0,1,0,0,1,1,0,1,1,0,1,1,0,1,0]
func threeEqualParts(_ arr: [Int]) -> [Int] {
    var num1 = [Int:Int](),time = 1
    let count = arr.count
    for i in 0..<count where arr[i] == 1{
        num1[time] = i
        time += 1
    }
    guard num1.count > 0 else {
        return [0,arr.count - 1]
    }
    guard num1.count % 3 == 0 else {
        return [-1,-1]
    }
    let num = num1.count / 3
    let i = num1[1]!,j = num1[1 + num]!,k = num1[1 + 2 * num]!
    for z in k..<count where arr[i + (z - k)] != arr[z] || arr[j + (z - k)] != arr[z]{
        return [-1,-1]
    }
    return [i + count - k - 1,j + count - k]
}

func twoSum(_ nums: [Int], _ target: Int) -> [Int] {
    var numMap = [Int:[Int]]()
    for (i,v) in nums.enumerated() {
        numMap[v] = (numMap[v] ?? []) + [i]
    }
    for info in numMap where numMap[target - info.key] != nil {
        let temp = numMap[target - info.key]?.last
        if info.value.first! != temp! {
            return [info.value.first!,temp!]
        }
    }
    return [-1,1]
}

//1800. 最大升序子数组和
func maxAscendingSum(_ nums: [Int]) -> Int {
    var maxSum = 0
    var last = 0,lastSum = 0
    for num in nums {
        lastSum = num >= last ? (lastSum + num):num
        maxSum = max(maxSum,lastSum)
        last = num
        
    }
    return maxSum
}

func findPoisonedDuration(_ timeSeries: [Int], _ duration: Int) -> Int {
    var time = 0,expired = 0
    for series in timeSeries {
        if expired > series {
            time += series + (duration - expired)
        } else {
            time += duration
        }
        expired = series + duration
    }
    return time
}
//870. 优势洗牌
func advantageCount(_ nums1: [Int], _ nums2: [Int]) -> [Int] {
    guard nums1.count == nums2.count else {
        return []
    }
    let sorNum1 = nums1.sorted(),count = nums1.count
    var sorIndex2 = [Int](),left = 0,right = count-1
    for i in 0..<count {
        sorIndex2.append(i)
    }
    sorIndex2.sort { i, j in
        nums2[i] < nums2[j]
    }
    var nums = Array(repeating: 0, count: count)
    for i in sorNum1 {
        if i > nums2[sorIndex2[left]] {
            nums[sorIndex2[left]] = i
            left += 1
        } else {
            nums[sorIndex2[right]] = i
            right -= 1
        }
    }
    return nums
}

//801. 使序列递增的最小交换次数
/**
 2   5
 
 3   6
 
 6   7
 
 5   9
 7   6
 **/
func minSwap(_ nums1: [Int], _ nums2: [Int]) -> Int {
    var a = 0,b = 1
    for i in 1..<nums1.count {
        let a1 = nums1[i - 1],a2 = nums1[i],b1 = nums2[i-1],b2 = nums2[i]
        if a1 < a2,b1 < b2,b1 < a2,a1 < b2 {
            a = min(a,b)
            b = a + 1
        } else if a1 < a2,b1 < b2{
            b = b + 1
        } else {
            let temp = a
            a = b
            b = temp + 1
        }
    }
    return min(a,b)
}

//769. 最多能完成排序的块
func maxChunksToSorted2(_ arr: [Int]) -> Int {
    var sortArr = Array(repeating: 0, count: arr.count)
    for i in 0..<arr.count {
        sortArr[i] = i
    }
    sortArr.sort { i, j in
        return arr[i] < arr[j]
    }
    var minRight = 0
    var result = 0
    for (i,j) in sortArr.enumerated() {
        minRight = max(minRight,j)
        if minRight == i {
            result += 1
        }
        
    }
    return result
    
}

//1441. 用栈操作构建数组,target 严格递增
func buildArray(_ target: [Int], _ n: Int) -> [String] {
    let push = "Push",pop = "Pop"
    var index = 0,num = 1,result = [String]()
    result.reserveCapacity(target.count)
    while index < target.count,num <= n {
        defer {
            num += 1
        }
        guard target[index] != num else {
            index += 1
            result.append(push)
            continue
        }
        result.append(contentsOf: [push,pop])
    }
    
    return result
}

//509. 斐波那契数
/*
 F(0) = 0，F(1) = 1
 F(n) = F(n - 1) + F(n - 2)，其中 n > 1
 */
func fib(_ n: Int) -> Int {
    typealias Matrix = ((Int,Int),(Int,Int))
    guard n > 1 else {
        return n
    }
    
    func matrixMult(_ num1:Matrix,_ num2:Matrix)-> Matrix {
        let top = (num1.0.0 &* num2.0.0 &+ num1.0.1 &* num2.1.0,num1.0.0 &* num2.0.1 &+ num1.0.1 &* num2.1.1)
        let bottom = (num1.1.0 &* num2.0.0 &+ num1.1.1 &* num2.1.0,num1.1.0 &* num2.0.1 &+ num1.1.1 &* num2.1.1)
        return (top,bottom)
    }
    
    func fibPow(_ num:Matrix,_ n:Int)-> Matrix {
        var multNum = num,index = n,result = ((1,0),(0,1))
        while index > 0 {
            if index & 1 == 1 {
                result = matrixMult(result, multNum)
            }
            index = index >> 1
            multNum = matrixMult(multNum, multNum)
        }
        return result
    }

    let p = ((1,1),(1,0))
    let num = fibPow(p,n-1)
    return num.0.0
}

//886. 可能的二分法
func possibleBipartition(_ n: Int, _ dislikes: [[Int]]) -> Bool {
    var colors = Array(repeating: 0, count: n + 1),disArr = Array(repeating: [Int](), count: n + 1)
    for dislike in dislikes {
        let a = dislike[0],b = dislike[1]
        disArr[a] += [b]
        disArr[b] += [a]
    }
    
    func dfs(_ colors:inout [Int],_ newColor:Int,_ cur:Int,_ disArr:[[Int]])->Bool{
        colors[cur] = newColor
        for dis in disArr[cur] {
            if colors[dis] != 0,colors[dis] == colors[cur] {
                return false
            }
            if colors[dis] == 0,!dfs(&colors, 3 ^ newColor, dis, disArr) {
                return false
            }
            
        }
        return true
    }
    for i in 1..<(n + 1) {
        if colors[i] == 0,!dfs(&colors, 1, i, disArr) {
            return false
        }
    }
    return true
}

//904. 水果成篮
func totalFruit(_ fruits: [Int]) -> Int {
    var left = 0,frist:Int?,second:Int?,maxNum = 0
    for i in 0..<fruits.count {
        guard let fr = frist else {
            frist = i
            left = i
            continue
        }
        
        guard let sec = second else {
            if fruits[fr] == fruits[i] {
                frist = i
            } else {
                second = i
            }
            continue
        }
        
        if fruits[i] == fruits[fr] {
            frist = i
        } else if fruits[i] == fruits[sec] {
            second = i
        } else {
            maxNum = max(maxNum,i - left)
            let min = min(fr, sec)
            let max = max(fr, sec)
            left = min + 1
            frist = max
            second = i
            
        }
    }
    return max(maxNum,fruits.count - left)
}

//485. 最大连续 1 的个数
func findMaxConsecutiveOnes(_ nums: [Int]) -> Int {
    var one = 0,num = 0
    for i in nums {
        guard i == 0 else {
            one += 1
            continue
        }
        num = max(num,one)
        one = 0
    }
    return max(num,one)
}

//338. 比特位计数
func countBits(_ n: Int) -> [Int] {
    guard n > 1 else {
        return n == 0 ?[0]:[0,1]
    }
    var dp = Array(repeating: 0, count: n + 1)
    dp[0] = 0
    dp[1] = 1
    for i in 2...n {
        let num1 = i / 2
        let num2 = i % 2 == 0 ? num1:(num1 + 1)
        dp[i] = dp[num1] + dp[num2] - dp[num1 & num2]
    }
    return dp
}

//915. 分割数组
func partitionDisjoint(_ nums: [Int]) -> Int {
    let count = nums.count
    guard count > 2 else {
        return 1
    }
    var rigMin = Array(repeating: 0, count: count)
    var maxN = nums.first!,minN = nums.last!
    for i in 0..<count {
        minN = min(minN,nums[count - 1 - i])
        rigMin[count - 1 - i] = minN
    }
    for i in 0..<(count-1) {
        if maxN <= rigMin[i+1] {
            return i+1
        }
        maxN = max(maxN,nums[i])
        
    }
    return 0
}

//862. 和至少为 K 的最短子数组
func shortestSubarray(_ nums: [Int], _ k: Int) -> Int {
    class Queue {
        class Node {
            var next:Node?
            var pre:Node?
            let val:Int
            let sum:Int
            init(val: Int, sum: Int) {
                self.val = val
                self.sum = sum
            }
        }
        private var count = 0
        var frist:Node?
        var last:Node?
        
        var isEmpty:Bool {
            return count == 0
        }
        func append(i:Int,sum:Int){
            let node = Node(val: i, sum: sum)
            count += 1
            guard count > 1 else {
                frist = node
                last = node
                return
            }
            node.pre = last
            last?.next = node
            last = node
        }
        
        func removeFirst() {
            count -= 1
            guard count > 0 else {
                frist = nil
                last = nil
                return
            }
            let node = frist?.next
            node?.pre = nil
            frist?.next = nil
            frist = node
        }
        
        func removeLast() {
            count -= 1
            guard count > 0 else {
                frist = nil
                last = nil
                return
            }
            let node = last?.pre
            node?.next = nil
            last?.pre = nil
            last = node
        }
    }
    var minNum = nums.count + 1,sum = 0,queue = Queue()
    queue.append(i: 0, sum: 0)
    for (i,num) in nums.enumerated() {
        sum += num
        while !queue.isEmpty,sum-(queue.frist!.sum) >= k {
            minNum = min(minNum,i+1-queue.frist!.val)
            queue.removeFirst()
        }
        while !queue.isEmpty,queue.last!.sum >= sum {
            queue.removeLast()
        }
        queue.append(i: i+1, sum: sum)
    }
    return minNum > nums.count ? -1:minNum
    
}

//1822. 数组元素积的符号
func arraySign(_ nums: [Int]) -> Int {
    var sum = 0
    for num in nums {
        guard num != 0 else {
            return 0
        }
        if num < 0 {
            sum += 1
        }
    }
    return sum % 2 == 0 ? 1:-1
}

//342. 4的幂
func isPowerOfFour(_ n: Int) -> Bool {
    guard n > 0 else {
        return false
    }
    let cur = sqrt(Double(n))
    let num = Int(cur)
    guard cur - Double(num) == 0 else {
        return false
    }
    return ((num - 1)&num) == 0
}

//496. 下一个更大元素 I
func nextGreaterElement(_ nums1: [Int], _ nums2: [Int]) -> [Int] {
    var map = [Int:Int]()
    var arr = [Int]()
    for num in nums2.reversed() {
        if arr.isEmpty {
            map[num] = -1
            arr.append(num)
        } else {
            while let last = arr.last,last < num {
                arr.removeLast()
            }
            map[num] = arr.last ?? -1
            arr.append(num)
        }
    }
    return nums1.map { num in
        return map[num] ?? 0
    }
}


func bestCoordinate(_ towers: [[Int]], _ radius: Int) -> [Int] {
    func coordinate(_ x1:(Int,Int),_ x2:(Int,Int))->Double{
        return pow(Double(x1.0 - x2.0), 2) + pow(Double(x1.1 - x2.1), 2)
    }
    var maxX = -1,maxY = -1
    for tower in towers {
        maxX = max(maxX,tower[0])
        maxY = max(maxY,tower[1])
    }
    var cx = 0,cy = 0,maxSum = 0.0
    for x in 0...maxX {
        for y in 0...maxY {
            var tempSum = 0.0
            for tower in towers {
                let len = coordinate((tower[0],tower[1]), (x,y))
                guard len <= Double(radius * radius) else {
                    continue
                }
                tempSum += floor(Double(tower[2]) / (1 + sqrt(len)))
            }
            if tempSum > maxSum {
                cx = x
                cy = y
                maxSum = tempSum
            }
        }
    }
    return[cx,cy]
}

func findDisappearedNumbers(_ nums: [Int]) -> [Int] {
    let count = nums.count
    var nums = nums
    var result = [Int]()
    for i in 0..<count {
        let index = (nums[i] - 1) % count
        nums[index] += count
    }
    for i in 0..<count where nums[i] <= count{
        result.append(i+1)
    }
    return result
}

///754. 到达终点数字
func reachNumber(_ target: Int) -> Int {
    let target = abs(target)
    var step = 1,cur = 0
    while cur + step < target {
        cur += step
        step += 1
    }
    var less = cur + step - target
    while less % 2 != 0 {
        step += 1
        less += step
        
    }
    return step
}

//// 172. 阶乘后的零
func trailingZeroes(_ n: Int) -> Int {
    var num = n,sum = 0
    while num > 0 {
        num = num / 5
        sum += num
    }
    return sum
}

///463. 岛屿的周长
func islandPerimeter(_ grid: [[Int]]) -> Int {
    func isLand(_ grid:inout [[Int]],i:Int,j:Int) -> Int {
        guard case 0..<grid.count = i,case 0..<grid[i].count = j,grid[i][j] == 1 else {
            return 0
        }
        grid[i][j] = 2
        let sum = isLand(grid, i: i-1, j: j) + isLand(grid, i: i+1, j: j) + isLand(grid, i: i, j: j-1) + isLand(grid, i: i, j: j+1)
        let num1 = isLand(&grid, i: i-1, j: j)
        let num2 = isLand(&grid, i: i+1, j: j)
        let num3 = isLand(&grid, i: i, j: j-1)
        let num4 = isLand(&grid, i: i, j: j+1)
        return sum + num1 + num2 + num3 + num4
    }
    func isLand(_ grid:[[Int]],i:Int,j:Int) -> Int {
        guard case 0..<grid.count = i,case 0..<grid[i].count = j,grid[i][j] != 0 else {
            return 1
        }
        return 0
    }
    var grids = grid
    for i in 0..<grid.count {
        for j in 0..<grid[i].count where grid[i][j] == 1 {
           return isLand(&grids, i: i, j: j)
        }
    }
    return 0
}
///628. 三个数的最大乘积
func maximumProduct(_ nums: [Int]) -> Int {
    guard nums.count >= 3 else {
        return 0
    }
    
    let sorArr = nums.sorted()
    //有1个正数
    let frist = sorArr[0] * sorArr[1] * sorArr[nums.count-1]
    //只有两个正数，全部正数，0个正数
    let second = sorArr[nums.count-3] * sorArr[nums.count-2] * sorArr[nums.count-1]
    return max(frist,second)
}

//605. 种花问题
func canPlaceFlowers(_ flowerbed: [Int], _ n: Int) -> Bool {
    guard n > 0 else {
        return true
    }
    var last = flowerbed.first!,sum = 0,count = flowerbed.count
    for i in 0..<count {
        
        guard last == 0,flowerbed[i] == 0,(i + 1 >= count || (i + 1 < count && flowerbed[i + 1] == 0)) else {
                  last = flowerbed[i]
            continue
        }
                                                             sum += 1
                                                             last = 1
    }
    
    return sum >= n
}

///764. 最大加号标志，实际上求最大全1的奇数矩形
func orderOfLargestPlusSign(_ n: Int, _ mines: [[Int]]) -> Int {
    var dp = Array(repeating: Array(repeating: n, count: n), count: n)
    var set = Set<Int>()
    for mine in mines {
        set.insert(mine[0] * n + mine[1])
    }
    var ans = 0
    for i in 0..<n {
        //left
        var count = 0
        for j in 0..<n {
            if set.contains(i * n + j) {
                count = 0
            } else {
                count += 1
            }
            dp[i][j] = min(dp[i][j],count)
        }
        count = 0
        //right
        for j in (0..<n).reversed() {
            if set.contains(i * n + j) {
                count = 0
            } else {
                count += 1
            }
            dp[i][j] = min(dp[i][j],count)
        }
    }
    
    for j in 0..<n {
        var count = 0
        //up
        for i in 0..<n {
            if set.contains(i * n + j) {
                count = 0
            } else {
                count += 1
            }
            dp[i][j] = min(dp[i][j],count)
        }
        count = 0
        //down
        for i in (0..<n).reversed() {
            if set.contains(i * n + j) {
                count = 0
            } else {
                count += 1
            }
            dp[i][j] = min(dp[i][j],count)
            ans = max(dp[i][j],ans)
        }
    }
    return ans
}

//猜数字大小
func guessNumber(_ n: Int) -> Int {
    var left = 1,right = n
    func guess(_ num:Int) ->Int {
        return 0
    }
    while left < right {
        let mid = (left + right) / 2
        let temp = guess(mid)
        if temp == 1 {
            left = mid + 1
        } else if temp == -1 {
            right = mid
        } else {
            return mid
        }
    }
    return left
}

// 790. 多米诺和托米诺平铺
var numTileingMap = [Int:Int]()
func numTilings(_ n: Int) -> Int {
    guard n > 0 else {
        return 0
    }
    if n == 1 {
        return 1
    }
    if n == 2 {
        return 2
    }
    if let num = numTileingMap[n] {
        return num
    }
    let mod = Int(1e9 + 7)
    var num = (numTilings(n-1) + numTilings(n-2) + 2) % mod
    for i in 1..<(n-2) {
        num = (num + numTilings(i) * 2) % mod
    }
    
    numTileingMap[n] = num % mod
    return numTileingMap[n]!
}

///805. 数组的均值分割
func splitArraySameAverage(_ nums: [Int]) -> Bool {
    let n = nums.count,m = n / 2
    var sum = 0
    for num in nums {
        sum += num
    }
    var map = [Int:Set<Int>]()
    for i in 0..<(1<<m) {
        var tot = 0,cnt = 0
        for j in 0..<m {
            if (i >> j) & 1 == 1 {
                tot += nums[j]
                cnt += 1
            }
        }
        map[tot] = (map[tot] ?? Set<Int>()).union([cnt])
    }
    
    for i in 0..<(1<<(n-m)) {
        var tot = 0,cnt = 0
        for j in 0..<(n-m) {
            if (i >> j) & 1 == 1 {
                tot += nums[j+m]
                cnt += 1
            }
        }
        let begin = max(1, cnt)
        for i in begin..<n {
            guard (i * sum) % n == 0 else {
                continue
            }
            let t = (i * sum) / n
            guard let r = map[t - tot] else {
                continue
            }
            guard r.contains(i-cnt) else {
                continue
            }
            return true
        }
    }
    return false
    
}

//1710. 卡车上的最大单元数
func maximumUnits(_ boxTypes: [[Int]], _ truckSize: Int) -> Int {
    let soreBox = boxTypes.sorted { arr1, arr2 in
        return arr1[1] > arr2[1]
    }
    var num = truckSize,sum = 0
    for box in soreBox{
        guard  num > 0 else {
            break
        }
        let change = min(num, box[0])
        num -= change
        sum += change * box[1]
    }
    return sum
}

//441. 排列硬币
func arrangeCoins(_ n: Int) -> Int {
    let num = n << 1
    var begin = Int(sqrt(Double(num))) - 1
    while (begin + 1) * begin <= num {
        begin += 1
    }
    return begin - 1
}

///775. 全局倒置与局部倒置
func isIdealPermutation(_ nums: [Int]) -> Bool {
    guard nums.count > 1 else {
        return false
    }
    let count = nums.count
    var minDff = nums[count-1]
    for i in (0..<(count - 2)).reversed() {
        if nums[i] > minDff {
            return false
        }
        minDff = min(minDff,nums[i + 1])
    }
        return true
}


func sumSubseqWidths(_ nums: [Int]) -> Int {
    let (sortArr,count,mod) = (nums.sorted(),nums.count - 1,Int(1e9 + 7))
    var sum = 0,powArr = Array(repeating: 1, count: count+1)
    
    for i in 1...count {
        powArr[i] = (powArr[i-1] << 1) % mod
    }
    
    for (i,num) in sortArr.enumerated() {
        sum = ((powArr[i] - powArr[count - i]) * num + sum) % mod
    }
return (sum % mod + mod) % mod
}

//1732. 找到最高海拔
// i = xi+1 - xi
func largestAltitude(_ gain: [Int]) -> Int {
    var (maxN,begin) = (0,0)
    for g in gain {
        begin = begin + g
        maxN = max(maxN, begin)
    }
    return maxN
}
//455. 分发饼干
func findContentChildren(_ g: [Int], _ s: [Int]) -> Int {
    func exChage(_ g:inout [Int],i:Int,j:Int) {
        let temp = g[i]
        g[i] = g[j]
        g[j] = temp
    }
    func quickSort(_ g:inout [Int],i:Int,j:Int) {
        guard i < j else {
            return
        }
        let num = g[i]
        var (left,right,index) = (i-1,j+1,i)
        while index < right {
            if g[index] < num {
                left += 1
                exChage(&g, i: left, j: index)
                index += 1
            } else if g[index] > num {
                right -= 1
                exChage(&g, i: right, j: index)
            } else {
                index += 1
            }
        }
        quickSort(&g, i: i, j: left)
        quickSort(&g, i: right, j: j)
    }
    var (sorG,sorS,gi,si) = (g,s,0,0)
    quickSort(&sorG, i: 0, j: g.count-1)
    quickSort(&sorS, i: 0, j: s.count-1)
    while gi < g.count,si < s.count {
        while si < sorS.count,sorS[si] < sorG[gi] {
            si += 1
        }
        guard si < sorS.count else {
            return gi
        }
        gi += 1
    }
        return gi
}

func champagneTower(_ poured: Int, _ query_row: Int, _ query_glass: Int) -> Double {
    var arr = Array(repeating: Array(repeating: 0.0, count: query_row+2), count: query_row+2)
    arr[0][0] = Double(poured)
    for i in 0...query_row {
        for j in 0...i where arr[i][j] > 1{
            arr[i+1][j] += Double((arr[i][j] - 1.0) / 2.0)
            arr[i+1][j+1] += Double((arr[i][j] - 1.0) / 2.0)
        }
    }
    return min(arr[query_row][query_glass], 1.0)
}

//808. 分汤
/*
 提供 100ml 的 汤A 和 0ml 的 汤B 。
 提供 75ml 的 汤A 和 25ml 的 汤B 。
 提供 50ml 的 汤A 和 50ml 的 汤B 。
 提供 25ml 的 汤A 和 75ml 的 汤B
 汤A 先分配完的概率 +  汤A和汤B 同时分配完的概率 / 2
 */
func soupServings(_ n: Int) -> Double {
    let num = Int(ceil(Double(Double(n)/25.0)))
    if num >= 179 {
        return 1.0
    }
    var dp = Array(repeating: Array(repeating: 0.0, count: num+1), count: num+1)
    dp[0][0] = 0.5
    for i in 1..<(num+1) {
        dp[0][i] = 1.0
    }
    for i in 1..<((num+1)) {
        for j in 1...num {
            dp[i][j] = (dp[max(i-4,0)][j] + dp[max(i-3,0)][max(j-1,0)] + dp[max(i-2,0)][max(j-2,0)] + dp[max(i-1,0)][max(j-3,0)]) / 4.0
        }
    }
    return dp[num][num]
}

//1742. 盒子中小球的最大数量
func countBalls(_ lowLimit: Int, _ highLimit: Int) -> Int {
    func numBall(num:Int) -> Int {
        var (num,result) = (num,0)
        while num > 0 {
            result += num % 10
            num = num / 10
        }
        return result
        
    }
    var (boxMap,maxN) = ([Int:Int](),0)
    for i in lowLimit...highLimit {
        let num = numBall(num: i)
        boxMap[num] = (boxMap[num] ?? 0) + 1
        maxN = max(maxN,boxMap[num]!)
    }
    return maxN
}

//795. 区间子数组个数
//[73,55,36,5,55,14,9,7,72,52]

func numSubarrayBoundedMax(_ nums: [Int], _ left: Int, _ right: Int) -> Int {
    var (last1,last2,result) = (-1,-1,0)
    for (i,num) in nums.enumerated() {
        if case left...right = num {
            last1 = i
        } else if right < num {
            last2 = i
            last1 = -1
        }
        if last1 != -1 {
            result += last1 - last2
        }
            
    }
    return result
}

//809. 情感丰富的文字
func expressiveWords(_ s: String, _ words: [String]) -> Int {
    func isVailExpress(_ chars:[(Character,Int)],_ word:String) -> Bool {
        guard word.count >= chars.count else {
            return false
        }
        let words = Array(word)
        var (i,j) = (0,0)
        while i < chars.count {
            let cur = chars[i]
            var num = cur.1
            while j<words.count, num >= 0{
                if cur.0 == words[j] {
                    num -= 1
                } else {
                    break
                }
                j += 1
            }
            if num < 0 {
                //多了
                return false
            } else if num == cur.1 {
                //没动
                return false
            } else if cur.1 == 2,num != 0 {
                //2,1必须意义对应
                return false
            }
            i += 1
        }
        return i == chars.count && j == words.count
    }
    
    let chars = Array(s)
    var dataArr = [(Character,Int)]()
    for i in 0..<chars.count {
        guard dataArr.last?.0 == chars[i] else {
            dataArr.append((chars[i],1))
            continue
        }
        dataArr[dataArr.count - 1].1 += 1
    }
    var num = 0
    for word in words where isVailExpress(dataArr, word) {
        num += 1
    }
    return num
}

func check(_ nums: [Int]) -> Bool {
    guard nums.count > 0 else {
        return true
    }
    let begin = nums[0]
    var (last,change) = (begin,true)
    for i in 1..<nums.count {
        if nums[i] >= last {
            
        } else if change{
            change = false
        } else {
            return false
        }
        last = nums[i]
    }
    return change || begin >= nums[nums.count-1]
}


func largestSumOfAverages(_ nums: [Int], _ k: Int) -> Double {
    let n = nums.count
    var sum = Array(repeating: 0.0, count: n+10)
    for i in 1...n {
        sum[i] = sum[i - 1] + Double(nums[i - 1])
    }
    var dp = Array(repeating: Array(repeating: 0.0, count: n+10), count: n+10)
    for i in 1...n {
        for j in 1...(min(i,k)) {
            if j == 1 {
                dp[i][1] = sum[i] / Double(i)
            } else {
                for k in 2...i {
                    dp[i][j] = max(dp[i][j], dp[k-1][j-1] + (sum[i]-sum[k-1]) / Double(i-k+1))
                }
            }
        }
    }
    
    return dp[n][k]
}

//1781. 所有子字符串美丽值之和 "aabcbaa" "aabcba" 9  "aabcb" 5
////  0 0 1 1 3
/// a  a 1
/// 1 2
func beautySum(_ s: String) -> Int {
    func num(s:String) -> Int {
        return Int(UnicodeScalar(s)!.value - UnicodeScalar(String("a"))!.value)
    }
    let sArr = Array(s)
    var res = 0
    for i in 0..<sArr.count {
        var map = Array(repeating: 0, count: 26)
        var maxFre = 0
        for j in i..<sArr.count {
            let index = num(s: String(sArr[j]))
            map[index] += 1
            maxFre = max(maxFre,map[index])
            var minFre = s.count
            for value in map where value != 0 {
                minFre = min(minFre, value)
            }
            res += maxFre - minFre
        }
    }
    return res
}

//264. 丑数 II
/**
丑数必须有2 3 5 相乘，因此，通过3个指针，只想 2 3 5相乘的
 //同时能避免相同的情况
 **/
func nthUglyNumber(_ n: Int) -> Int {
    var a = 0,b = 0,c = 0,arr = Array(repeating: 0, count: n)
    arr[0] = 1
    for i in 1..<n {
        let n2 = arr[a] * 2,n3 = arr[b] * 3,n5 = arr[c] * 5
        arr[i] = min(n2,n3,n5)
        if arr[i] == n2 { a += 1 }
        if arr[i] == n3 { b += 1 }
        if arr[i] == n5 { c += 1 }
    }
    return arr[n-1]
}
