//
//  day.swift
//  leetCode
//
//  Created by 陈晶泊 on 2023/3/6.
//

import Foundation
//1653. 使字符串平衡的最少删除次数
/**
 给你一个字符串 s ，它仅包含字符 'a' 和 'b'​​​​ 。

 你可以删除 s 中任意数目的字符，使得 s 平衡 。当不存在下标对 (i,j) 满足 i < j ，且 s[i] = 'b' 的同时 s[j]= 'a' ，此时认为 s 是 平衡 的。
aaaabbb
 请你返回使 s 平衡 的 最少 删除次数。
 bbaaaaabb
 */
func minimumDeletions(_ s: String) -> Int {
    let chars = Array(s)
    //包括他，左边有多少个b
    var bArr = Array(repeating: 0, count: chars.count),last = 0
    for i in 0..<bArr.count {
        if chars[i] == "b" {
           last += 1
        }
        bArr[i] = last
    }
    guard last != 0 || last != chars.count else {
        return 0
    }
    last = 0
    var res = Int.max
    for i in (0..<bArr.count).reversed() {
        guard bArr[i] > 0 else {
            return min(res,last)
        }
        if i+1 < bArr.count,chars[i+1] == "a" {
           last += 1
        }
        //以当前节点为中心，左边a(包括当前点是a)，右边b
        res = min(res,bArr[i] + last)
    }
    return min(res,last)
}


//1096. 花括号展开 II
func braceExpansionII(_ expression: String) -> [String] {
    var set = Set<String>()
    func dfs(str:String) {
        guard let end = str.firstIndex(of: "}"),
              let start = str[str.startIndex..<end].lastIndex(of: "{") else {
            set.insert(str)
            return
        }
        
        let a = str[str.startIndex..<start]
        let c = str[str.index(after: end)..<str.endIndex]
        let b = str[str.index(after: start)..<end].split(separator: ",")
        for str in b {
            dfs(str: "\(a)\(str)\(c)")
        }
    }
    dfs(str: expression)
    return Array(set).sorted()
}

//面试题 17.05. 字母与数字
func findLongestSubarray(_ array: [String]) -> [String] {
    var arr = Array(repeating: 0, count: array.count + 1),r = 0,l = 0
    for i in 1...array.count {
        
        arr[i] = arr[i-1] + (Int(array[i-1]) != nil ? 1:-1)
        if arr[i] == 0 {
            r = i
        }
    }
    guard r < array.count else {
        return array
    }
    var i = 1
    while i < array.count - (r - l) {
        for j in (r-l+i+1)..<arr.count where (arr[j]-arr[i]) == 0{
            r = j
            l = i
        }
        i += 1
    }
    return Array(array[l..<r])
}

//1616. 分割两个字符串得到回文串
func checkPalindromeFormation(_ a: String, _ b: String) -> Bool {
    let aChars = Array(a),bChars = Array(b)
    guard aChars.count == bChars.count else {
        return false
    }
    func isPreArr(lChars:[Character],l: Int,rChars:[Character],r: Int,isChange:Bool) -> Bool {
        guard l < r else {
            return true
        }
        var l = l,r = r
        while l < r {
            if lChars[l] != rChars[r] {
                guard !isChange else {
                    return false
                }
                return isPreArr(lChars: lChars, l: l, rChars: lChars, r: r, isChange: true) || isPreArr(lChars: rChars, l: l, rChars: rChars, r: r, isChange: true)
            }
            l += 1
            r -= 1
        }
        return true
    }
    return isPreArr(lChars: aChars, l: 0, rChars: bChars, r: aChars.count-1, isChange: false) || isPreArr(lChars: bChars, l: 0, rChars: aChars, r: aChars.count-1, isChange: false)
}

// 1625. 执行操作后字典序最小的字符串
func findLexSmallestString(_ s: String, _ a: Int, _ b: Int) -> String {
    let n = s.count
    var vis = Array(repeating: false, count: n)
    let res = Array(s + s).map{ Int(String($0))! }
    var i = 0
    var res1 = s
    while !vis[i] {
        vis[i] = true
        for j in 0..<10 {
            let kLimit = b % 2 == 0 ? 1:10
            for k in 0..<kLimit {
                
                var t = Array(res[i..<(i+n)])
                for p in stride(from: 1, to: n, by: 2) {
                    t[p] = (j * a + t[p]) % 10
                }
                
                for p in stride(from: 0, to: n, by: 2) {
                    t[p] = (k * a + t[p]) % 10
                }
                let str = t.reduce(""){ "\($0)\($1)" }
                if str < res1 {
                    res1 = str
                }
            }
            
        }
        i = (i + b) % n
    }
    
    return res1
}

//1032. 字符流
class StreamChecker {
    class Node {
        var children:[Node?] = Array(repeating: nil, count: 26)
        var isEnd = false
        var fail:Node?
    }
    var root:Node
    var temp:Node?
    init(_ words: [String]) {
        root = Node()
        for word in words {
            var cur = root
            for w in word {
                let index = Int(UnicodeScalar(String(w))!.value - UnicodeScalar("a").value)
                if cur.children[index] == nil {
                    cur.children[index] = Node()
                }
                cur = cur.children[index]!
            }
            cur.isEnd = true
        }
        root.fail = root
        var arr = [Node]()
        for i in 0..<26 {
            guard let nod = root.children[i] else {
                root.children[i] = root
                continue
            }
            nod.fail = root
            arr.append(nod)
        }
        while !arr.isEmpty {
            let curNode = arr.removeFirst()
            curNode.isEnd = curNode.isEnd || (curNode.fail?.isEnd ?? false)
            for i in 0..<26 {
                guard let nod = curNode.children[i] else {
                    curNode.children[i] = curNode.fail?.children[i]
                    continue
                }
                nod.fail = curNode.fail?.children[i]
                arr.append(nod)
            }
        }
        temp = root
    }
    
    func query(_ letter: Character) -> Bool {
        let index = Int(UnicodeScalar(String(letter))!.value - UnicodeScalar("a").value)
        temp = temp?.children[index]
        return temp?.isEnd ?? false
    }
}

//1638. 统计只差一个字符的子串数目
func countSubstrings(_ s: String, _ t: String) -> Int {
    let sChars = Array(s),tChars = Array(t)
    var res = 0,arr = Array(repeating: [Int](), count: 26)
    for i in 0..<tChars.count {
        arr[num(char: tChars[i])].append(i)
    }
    
    for i in 0..<sChars.count {
        res += onlyOneDifferenceNum(i: i)
    }
    
    func num(char:Character) -> Int {
        return Int(UnicodeScalar(String(char))!.value - UnicodeScalar("a").value)
    }
    //从i,j,开始对比，是否可以改变
    func onlyOneDifferenceNum(i:Int,j:Int,isChange:Bool) -> Int {
        guard i < sChars.count,j < tChars.count else { return 0 }
        var res = 0
        if sChars[i] == tChars[j] {
            if isChange {
                res += 1 + onlyOneDifferenceNum(i: i+1, j: j+1, isChange: isChange)
            } else {
                res += onlyOneDifferenceNum(i: i+1, j: j+1, isChange: isChange)
            }
        } else if !isChange {
            res += 1 + onlyOneDifferenceNum(i: i+1, j: j+1, isChange: !isChange)
        }
        return res
    }
        
    //从i开始
    func onlyOneDifferenceNum(i:Int) -> Int {
        var res = 0
        let temp = arr[num(char: sChars[i])]
        if temp.isEmpty {
            //一开始没有匹配的，第一个必须变
            res += tChars.count
            for z in 0..<tChars.count {
                res += onlyOneDifferenceNum(i: i+1, j: z+1, isChange: true)
            }
        } else {
            //一开始有匹配的
            for z in 0..<tChars.count {
                if temp.contains(z) {
                    res += onlyOneDifferenceNum(i: i+1, j: z+1, isChange: false)
                } else {
                    res += 1 + onlyOneDifferenceNum(i: i+1, j: z+1, isChange: true)
                }
            }
        }
    return res
    }
    
    return res
}


//1092. 最短公共超序列
//str1 = "abac", str2 = "cab"
//"abac" "cab"
//  ca b ac
func shortestCommonSupersequence(_ str1: String, _ str2: String) -> String {
    let minChars = Array(str2),maxChars = Array(str1)
    
    func maxSameSequence() -> String {
        //公共子序列
        var dp = Array(repeating: Array(repeating: "", count: minChars.count+1), count: maxChars.count+1)
        for i in 1...maxChars.count {
            for j in 1...minChars.count {
                if maxChars[i-1] == minChars[j-1] {
                    dp[i][j] = dp[i-1][j-1] + "\(maxChars[i-1])"
                } else {
                    dp[i][j] = dp[i-1][j].count > dp[i][j-1].count ? dp[i-1][j]:dp[i][j-1]
                }
            }
        }
        return dp[maxChars.count][minChars.count]
    }
    
    //相同子序列
    let sameSeques = maxSameSequence()
    var res = [Character](),i = 0,j = 0
    for se in sameSeques {
        while i < minChars.count,minChars[i] != se {
            res.append(minChars[i])
            i+=1
        }
        while j < maxChars.count,maxChars[j] != se {
            res.append(maxChars[j])
            j+=1
        }
        i += 1
        j += 1
        res.append(se)
    }
    if i < minChars.count {
        res.append(contentsOf: minChars[i..<minChars.count])
    }
    if j < maxChars.count {
        res.append(contentsOf: maxChars[j..<maxChars.count])
    }
    return String(res)
}


//1641. 统计字典序元音字符串的数目
//给你一个整数 n，请返回长度为 n 、仅由元音 (a, e, i, o, u) 组成且按 字典序排列 的字符串数量。
 
func countVowelStrings(_ n: Int) -> Int {
    var dp = Array(repeating: Array(repeating: 0, count: 5), count: n+1)
    for i in 0..<5 {
        dp[0][i] = 1
    }
    for i in 1...n {
        for j in 0..<5 {
            for z in 0...j {
                dp[i][j] += dp[i-1][z]
            }
        }
    }
    return dp[n][4]
}


//831. 隐藏个人信息
//给你一条个人信息字符串 s ，可能表示一个 邮箱地址 ，也可能表示一串 电话号码 。返回按如下规则 隐藏 个人信息后的结果：
func maskPII(_ s: String) -> String {
    guard let index = s.lastIndex(of: "@") else {
        var res = ""
        for sc in s.reversed() {
            switch sc {
            case "0"..."9":
                guard res.count >= 4 else {
                    res = "\(sc)" + res
                    break
                }
                res = res.count % 4 == 0 ? "*-\(res)": "*\(res)"
            default:break
            }
        }
        
        return res.count > 12 ? "+\(res)":res
    }
    
    let last = s[s.index(before: index)..<index].lowercased()
    let domain = s[s.index(after: index)..<s.endIndex].lowercased()
    return "\(s.first!.lowercased())*****\(last)@\(domain)"
}


//1017. 负二进制转换
//    1 0 0  0
//        1 0
// 1 0 1 1 0
func baseNeg2(_ n: Int) -> String {
    var isOdd = true,res = "",needCarry = false
    var num =  n
    while num > 0 {
        let cur = num & 1
        num = num >> 1
        if isOdd {
            if cur == 1 {
                if !needCarry {
                    //不需要进位，直接加1
                    res = "1" + res
                } else {
                    //往上传进位
                    res = "0" + res
                }
            } else {
                if needCarry {
                    res = "1" + res
                    needCarry = false
                } else {
                    res = "0" + res
                }
            }
        } else {
            //偶数位是减
            if cur == 1 {
                if needCarry {
                    res = "0" + res
                } else {
                    //减一，迫使进位
                    res = "1" + res
                    needCarry = true
                }
            } else  {
                if needCarry {
                    res = "1" + res
                } else {
                    //减一，迫使进位
                    res = "0" + res
                }
            }
            
        }
        isOdd = !isOdd
    }
    
    if needCarry {
        res = (isOdd ? "1": "11") + res
    }
    
    return res.isEmpty ? "0":res
}

///1125. 最小的必要团队
func smallestSufficientTeam(_ req_skills: [String], _ people: [[String]]) -> [Int] {
    let n = req_skills.count
    var map = [String:Int]()
    for i in 0..<req_skills.count {
        map[req_skills[i]] = i
    }
    //n个技能下，有多少人会
    var skilArr = Array(repeating: [Int](), count: n)
    for i in 0..<people.count {
        for ps in people[i] {
            if let sk = map[ps] {
                skilArr[sk].append(i)
            }
        }
    }
    
    var res = Array(repeating: 0, count: people.count)
    func dfs(mod:Int,resArr:[Int]) {
        guard mod > 0 else {
            if res.count >= resArr.count {
                res = resArr
            }
            return
        }
        
        // 111
        let cur = Int(log2(Double(mod & (~mod + 1))))
        //找到所有需要cur技能的人遍历
        let pe = skilArr[cur]
        
        for i in pe {
            //当前人有额外技能
            var curMod = mod
            for sk in people[i] {
                if let j = map[sk],curMod & (1 << j) != 0 {
                    curMod = curMod ^ (1 << j)
                }
            }
            dfs(mod: curMod, resArr: resArr + [i])
        }
    }
    dfs(mod: 1 << n - 1, resArr: [])
    return res
}

//2399. 检查相同字母间的距离
func checkDistances(_ s: String, _ distance: [Int]) -> Bool {
    let sChars = Array(s)
    var mod = (1 << s.count) - 1
    func charNum(char:Character)->Int {
        return Int(UnicodeScalar(String(char))!.value -  UnicodeScalar("a").value)
    }
    var cur = 0
    while mod != 0 {
        cur = mod & (~mod + 1)
        mod = mod ^ (cur)
        cur = Int(log2(Double(cur)))
        let next = cur + distance[charNum(char: sChars[cur])] + 1
        //开始判断
        guard next < sChars.count,sChars[next] == sChars[cur] else {
            return false
        }
        mod = mod ^ (1 << next)
    }
    return true
}

//1147. 段式回文,L  r
func longestDecomposition(_ text: String) -> Int {
    let textChar = Array(text)
    var l = 0,r = textChar.count,i = r-1,res = 0
    while l < i {
        if textChar[i] == textChar[l],
           String(textChar[i..<r]) == String(textChar[l..<(r - i + l)]) {
            res += 2
            l = r - i + l
            r = i
        }
        i -= 1
    }
    if l < r {
        res += 1
    }
    return res
}


//1023. 驼峰式匹配
func camelMatch(_ queries: [String], _ pattern: String) -> [Bool] {
    let pattChars = Array(pattern)
    func isCamel(str:String) -> Bool {
        var i = 0
        for sc in str {
            if sc.isUppercase {
                guard i < pattChars.count,pattChars[i] == sc else {
                    return false
                }
                i += 1
            } else if i < pattChars.count,pattChars[i] == sc {
                i += 1
            }
        }
        return i == pattChars.count
    }
    return queries.map { isCamel(str: $0) }
}

//2409. 统计共同度过的日子数
func countDaysTogether(_ arriveAlice: String, _ leaveAlice: String, _ arriveBob: String, _ leaveBob: String) -> Int {
    
    
    func dateNum(dateStr:String) -> (Int,Int) {
        let arr = dateStr.split(separator: "-")
        return (Int(arr[0])!,Int(arr[1])!)
    }
    
    var maxArrive:(Int,Int) {
        let aA = dateNum(dateStr: arriveAlice),aB = dateNum(dateStr: arriveBob)
        if aA.0 > aB.0 {
            return aA
        } else if aA.0 == aB.0 {
            return aA.1 > aB.1 ? aA:aB
        } else {
            return aB
        }
    }
    
    var minLeve:(Int,Int) {
        let aA = dateNum(dateStr: leaveAlice),aB = dateNum(dateStr: leaveBob)
        if aA.0 < aB.0 {
            return aA
        } else if aA.0 == aB.0 {
            return aA.1 < aB.1 ? aA:aB
        } else {
            return aB
        }
    }
    
    let month = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
    let maxA = maxArrive,minL = minLeve
    if maxA.0 > minL.0 {
        return 0
    } else if maxA.0==minL.0,maxA.1 > minL.1 {
        return 0
    } else if maxA.0==minL.0 {
        return minL.1-maxA.1 + 1
    } else {
        var res = month[maxA.0-1] - maxA.1 + 1 + minL.1
        for i in maxA.0..<(minL.0-1) {
            res += month[i]
        }
        return res
    }
}


//1163. 按字典序排在最后的子串
func lastSubstring(_ s: String) -> String {
    let sChars = Array(s)
    let n = sChars.count
    var i = 0,j = 1
    while j < n {
        var k = 0
        while j + k < n, sChars[i+k] == sChars[j+k] {
            k += 1
        }
        if j + k < n,sChars[i+k] < sChars[j+k] {
            i = i + k + 1
            if i >= j {
                j = i + 1
            }
        } else {
            j = j + k + 1
        }
    }
    return String(sChars[i..<n])
}

func countTime(_ time: String) -> Int {
    let chars = time.components(separatedBy: ":")
    func hour(char:String) -> Int {
        let hours = Array(char)
        switch (hours[0],hours[1]) {
        case ("?","?"):return 24
        case (_,"?"):
            let num = Int(String(hours[0]))!
            return num == 2 ? 4:10
        case ("?",_):
            let num = Int(String(hours[1]))!
            return num < 4 ? 3:2
        default:return 1
        }
    }
    
    func minute(char:String) -> Int {
        let minutes = Array(char)
        switch (minutes[0],minutes[1]) {
        case ("?","?"):return 60
        case (_,"?"):
            return 10
        case ("?",_):
            return 6
        default:return 1
        }
    }
    
    return hour(char: chars[0]) * minute(char: chars[1])
}


//2446. 判断两个事件是否存在冲突
/**
 e1  < s2
 
 event1 = [startTime1, endTime1] 且
 event2 = [startTime2, endTime2]
 事件的时间为有效的 24 小时制且按 HH:MM 格式给出。
 */
func haveConflict(_ event1: [String], _ event2: [String]) -> Bool {
    func isFeature(time1:String,time2:String) -> Bool {
        let timeArr1 = time1.components(separatedBy: ":").map{Int($0)!}
        let timeArr2 = time2.components(separatedBy: ":").map{Int($0)!}
        guard timeArr1.count == 2,timeArr2.count == timeArr1.count else {
            return false
        }
        if timeArr1[0] > timeArr2[0] {
            return true
        } else if timeArr1[0] == timeArr2[0] {
            return timeArr1[1] >= timeArr2[1]
        }
        return false
    }
    if !isFeature(time1: event1[1], time2: event2[0]) ||  !isFeature(time1: event2[1], time2: event1[0]) {
        return false
    }
    return true
}


//活字印刷 回溯法
func numTilePossibilities(_ tiles: String) -> Int {
    var map = [Character:Int]()
    for tc in tiles {
        map[tc] = (map[tc] ?? 0) + 1
    }
    let tile = Set(map.keys)
    func dfs(i:Int) -> Int {
        if i == 0 { return 1}
        var res = 1
        for t in tile {
            if map[t]! > 0 {
                map[t] = map[t]! - 1
                res += dfs(i: i-1)
                map[t] = map[t]! + 1
            }
        }
        return res
    }
    return dfs(i: tiles.count) - 1
}


func maxSumBST(_ root: TreeNode?) -> Int {
    var maxNum = 0
    func maxSumBsT(_ root:TreeNode) -> (Int,Int,Bool,Int) {
        var res = (Int.max,Int.min,true,root.val)
        if let left = root.left {
            let temp = maxSumBsT(left)
            if res.2,temp.2,temp.1 < root.val{
                res = (min(res.0,temp.0),max(res.1,temp.1),true,res.3 + temp.3)
            } else {
                res.2 = false
            }
        }
        
        if let right = root.right {
            let temp = maxSumBsT(right)
            if res.2,temp.2,temp.0 > root.val {
                res = (min(res.0,temp.0),max(res.1,temp.1),true,res.3 + temp.3)
            } else {
                res.2 = false
            }
        }
        //说明是合格的
        if (res.2) {
            maxNum = max(maxNum,res.3)
        }
        
        return (min(res.0,root.val),max(res.1,root.val),res.2,res.3)
    }
    
    let _ = maxSumBsT(root!)
    return maxNum
}


//2380. 二进制字符串重新安排顺序需要的时间
//0110101
//1111111
//1011010
func secondsToRemoveOccurrences(_ s: String) -> Int {
    var res = 0,cnt = 0
    for sc in s {
        if sc == "0" {
            cnt += 1
        } else if cnt > 0 {
            res = max(res+1,cnt)
        }
    }
    return res
}


//2559. 统计范围内的元音字符串数
func vowelStrings(_ words: [String], _ queries: [[Int]]) -> [Int] {
    
    func isVowel(chars:String) ->Bool {
        return isVowel(char: chars.first!) && isVowel(char: chars.last!)
    }
    
    func isVowel(char:Character) -> Bool {
        switch char {
            case "a","e","i","o","u":return true
            default: return false
        }
    }
    //0 0-1 0-2, 0-3,0-4
    var preArr = Array(repeating: 0, count: words.count + 1)
    for i in 0..<words.count {
        preArr[i+1] = preArr[i] + (isVowel(chars: words[i]) ? 1:0)
    }

    var res = Array(repeating: 0, count: queries.count)
    for i in 0..<queries.count {
        res[i] = preArr[queries[i][1]+1] - preArr[queries[i][0]]
    }
    return res
}


//1156. 单字符重复子串的最大长度
//"aaabaaa"
func maxRepOpt1(_ text: String) -> Int {
    var rep = [(Character,Int)](),charNums = [Character:Int]()
    for t in text {
        if let last = rep.last,last.0 == t {
            rep[rep.count-1] = (last.0,last.1 + 1)
        } else {
            rep.append((t,1))
        }
        charNums[t] = (charNums[t] ?? 0) + 1
    }
    var res = 0
    let n = rep.count
    for i in 0..<n {
        let sum = charNums[rep[i].0]!
        res = max(rep[i].1,res)
        if sum > rep[i].1 {
            if i + 1 < n {
                var temp = rep[i].1
                if rep[i+1].1 == 1,
                   i + 2 < n,
                   rep[i+2].0 == rep[i].0 {
                    temp += rep[i+2].1
                    if temp < sum { temp += 1 }
                } else {
                    temp += 1
                }
                res = max(temp,res)
            }
            if i-1 >= 0 {
                var temp = rep[i].1
                if rep[i-1].1 == 1,
                   i - 2 >= 0,
                   rep[i-2].0 == rep[i].0 {
                    temp += rep[i-2].1
                    if temp < sum { temp += 1 }
                } else {
                    temp += 1
                }
                res = max(temp,res)
            }
        }
        
    }
    return res
}

//1170. 比较字符串最小字母出现频次
func numSmallerByFrequency(_ queries: [String], _ words: [String]) -> [Int] {
    func f(_ s:String) -> Int {
        var cur = Character("z"),num = 0
        for sc in s {
            if sc < cur {
                cur = sc
                num = 1
            } else if sc == cur {
                num += 1
            }
        }
        return num
    }
    //找到大于tag的最小值，左边界
    func find(arr:[Int],tag:Int) -> Int {
        var l = 0,r = arr.count
        while l < r {
            let temp = (r - l) >> 1 + l
            if arr[temp] <= tag {
                l = temp + 1
            } else {
                r = temp
            }
        }
        return arr.count - l
    }
    let numsArr = words.map{f($0)}.sorted()
    var res = Array(repeating: 0, count: queries.count)
    for i in 0..<queries.count {
        let cur = f(queries[i])
        res[i] = find(arr: numsArr, tag: cur)
    
    }
    return res
}

// a b c b e    a # b # c # d # a
// 0 1 2 3 4 4  0   2   4   6   8
func canMakePaliQueries(_ s: String, _ queries: [[Int]]) -> [Bool] {
    let sc = Array(s)
    var preArr = Array(repeating: 0, count: s.count + 1)
    for i in 0..<s.count {
        preArr[i+1] = preArr[i] ^ (1 << (Int(UnicodeScalar(String(sc[i]))!.value -  UnicodeScalar("a").value)))
    }
    
    return queries.map { querie in
        let l = querie[0],r = querie[1]
        var k = 0,x = preArr[r+1] ^ preArr[l]
        while x > 0 {
            x &= x - 1
            k += 1
        }
        return 2 * querie[2] + 1 >= k
    }
}


//2496. 数组中字符串的最大值
func maximumValue(_ strs: [String]) -> Int {
    func findNum(str:String) -> Int {
        return Int(str) ?? str.count
    }
    var res = 0
    for str in strs {
        res = max(res,findNum(str: str))
    }
    return res
}

//2490. 回环句
func isCircularSentence(_ sentence: String) -> Bool {
    let sChars = Array(sentence)
    guard sChars[0] == sChars.last else {
        return false
    }
    for i in 0..<(sChars.count-1) where sChars[i] == " " && sChars[i-1] != sChars[i+1] {
        return false
    }
    return true
}

//722. 删除注释
// 多行shi z
func removeComments(_ source: [String]) -> [String] {
    func nextComments(i:inout Int,_ multiLine:Bool = false) -> String {
        let chars = Array(source[i])
        var multiLine = multiLine,begin = 0,res = "",j = 1
        while j < chars.count {
            if !multiLine,chars[j-1] == "/",chars[j] == "/" {
                //单行隐藏,不是多行
                return res + String(chars[begin..<j-1])
            } else if !multiLine,chars[j-1] == "/",chars[j] == "*" {
                //多行开始
                res += String(chars[begin..<j-1])
                j += 1
                multiLine = true
            } else if multiLine,chars[j-1] == "*",chars[j] == "/" {
                //多行结束
                multiLine = false
                j += 1
                begin = j
            }
            j += 1
        }
        
        if multiLine {
            i += 1
            return res + nextComments(i: &i,true)
        }
        return res + String(chars[begin..<chars.count])
    }
    var res = [String](),i = 0
    while i < source.count {
        let temp = nextComments(i: &i)
        i += 1
        if !temp.isEmpty {
            res.append(temp)
        }
    }
    return res
}

//833. 字符串中的查找与替换
//
func findReplaceString(_ s: String, _ indices: [Int], _ sources: [String], _ targets: [String]) -> String {
    let chars = Array(s),n = chars.count
    let sorIndex = Array(0..<indices.count).sorted { indices[$0] < indices[$1] }
    var res = "",lastI = 0
    for index in sorIndex {
        let i = indices[index],cur = sources[index]
        if i+cur.count <= n,cur == String(chars[i..<(cur.count + i)]) {
            res += chars[lastI..<i] + targets[index]
            lastI = i + cur.count
        }
    }
    return res
}
