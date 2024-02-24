//
//  day_string_4.swift
//  leetCode
//
//  Created by 陈晶泊 on 2023/8/21.
//

import Foundation

//2337. 移动片段得到字符串
/**
 给你两个字符串 start 和 target ，长度均为 n 。每个字符串 仅 由字符 'L'、'R' 和 '_' 组成，其中：

 字符 'L' 和 'R' 表示片段，其中片段 'L' 只有在其左侧直接存在一个 空位 时才能向 左 移动，而片段 'R' 只有在其右侧直接存在一个 空位 时才能向 右 移动。
 字符 '_' 表示可以被 任意 'L' 或 'R' 片段占据的空位。
 如果在移动字符串 start 中的片段任意次之后可以得到字符串 target ，返回 true ；否则，返回 false 。
 "_LL__R__R_", "L___L___RR"
 tl:  1
 l:  2
 kn: 1
 */
func canChange(_ start: String, _ target: String) -> Bool {
    let chars = Array(start),tChars = Array(target)
    let n = chars.count
    var l = 0,tl = 0
    while l < n,tl < n {
        while l < n,chars[l] == "_" {
            l += 1
        }
        
        while tl < n,tChars[tl] == "_" {
            tl += 1
        }
        if l < n,tl < n {
            if chars[l] != tChars[tl] {
                return false
            }
            if chars[l] == "L" && l < tl || chars[l] == "R" && l > tl {
                return false
            }
            tl += 1
            l += 1
        }
    }
    
    for i in l..<n where chars[i] != "_" {
        return false
    }
    
    for i in tl..<n where tChars[i] != "_" {
        return false
    }
   return true
}

//849. 到最近的人的最大距离
// 1 0 0 0 1

func maxDistToClosest(_ seats: [Int]) -> Int {
    var res = 0, last = -1
    for i in 0..<seats.count where seats[i] == 1 {
        if last == -1 {
            res = i
        } else {
            res = max((i-last)/2,res)
        }
        
        last = i
    }
    return max(seats.count-1-last,res)
}

// 2116. 判断一个括号字符串是否有效
// 如果 locked[i] 是 '1' ，你 不能 改变 s[i] 。
// 如果 locked[i] 是 '0' ，你 可以 将 s[i] 变为 '(' 或者 ')' 。
// 如果你可以将 s 变为有效括号字符串，请你返回 true ，否则返回 false
// "1100000000000010000100001000001101"
// "()))(()(()()()()(((())())((()((())"
func canBeValid(_ s: String, _ locked: String) -> Bool {
    guard s.count % 2 == 0 else { return false }
    let sArr = Array(s),lockArr = Array(locked),n = sArr.count
    var change = [Int](),noChange = [Int](),i = 0
    while i < n {
        if sArr[i] == "(" {
            lockArr[i] == "0" ?  change.append(i): noChange.append(i)
        } else if sArr[i] == ")" {
            if lockArr[i] == "0" {
                change.append(i)
            } else if !noChange.isEmpty {
                noChange.removeLast()
            } else if !change.isEmpty {
                change.removeLast()
            } else {
                return false
            }
        }
        i += 1
    }
    guard noChange.count <= change.count else {
        return false
    }
    var l = noChange.count-1,r = change.count-1
    while l >= 0,r >= 0 {
        if noChange[l] > change[r] {
            return false
        }
        l -= 1
        r -= 1
    }
    
    return true
}


func findRepeatedDnaSequences(_ s: String) -> [String] {
    guard s.count > 10 else {
        return []
    }
    let sChars = Array(s)
    var map = [String:Int]()
    var res = [String]()
    for i in 0..<(sChars.count-10) {
        let temp = String(sChars[i..<(i+10)])
        map[temp] = (map[temp] ?? 0) + 1
        if map[temp] == 2 {
            res.append(temp)
        }
    }
    
    return res
}

// 318. 最大单词长度乘积
// 给你一个字符串数组 words ，找出并返回 length(words[i]) * length(words[j]) 的最大值，并且这两个单词不含有公共字母。如果不存在这样的两个单词，返回 0 。words[i] 仅包含小写字母
func maxProduct(_ words: [String]) -> Int {
    func changWordToMode(word: String) -> UInt32 {
        let begin = UnicodeScalar("a").value
        var mode: UInt32 = 0b0
        for worC in word {
            mode |= 1 << (UnicodeScalar("\(worC)")!.value - begin)
        }
        return mode
    }
    let modeArr = words.map { changWordToMode(word: $0) }
    var res = 0
    for i in 0..<(words.count-1) {
        for j in (i+1)..<words.count where modeArr[i] & modeArr[j] == 0 {
            res = max(words[i].count * words[j].count,res)
        }
    }
    return res
}

//2609. 最长平衡子字符串 "00101"
func findTheLongestBalancedSubstring(_ s: String) -> Int {
    var res = 0,isZero = true,l = 0,resD = 0
    for sc in s.enumerated() {
        if sc.element == "0",isZero {
            res += 1
        } else if sc.element == "0",!isZero {
            resD = max(resD,2 * min(res,sc.offset - l - res))
            isZero = true
            l = sc.offset
            res = 1
        } else if sc.element == "1",isZero {
            isZero = false
        } else if sc.element == "1",!isZero {
            
        }
    }
    if !isZero {
        // 以1结尾
        resD = max(resD,2 * min(res,s.count - l - res))
    }
    
    return resD
}

//647. 回文子串
//  "aaa"
// 1 a 1 a 1 a 1
//
func countSubstrings(_ s: String) -> Int {
    var R = -1,C = -1 // 最大半径和中心
    let n = 2 * s.count + 1
    var sChars = [Character](),dp = Array(repeating: 0, count: n)
    sChars.reserveCapacity(n)
    sChars.append("#")
    for sC in s {
        sChars.append(sC)
        sChars.append("#")
    }
    var res = 0
    for i in 0..<n {
        var l = R > i ? min(R - i,dp[2 * C - i]) : 1
        while i - l >= 0,
              i + l < n,
              sChars[i - l] == sChars[i + l] {
            l += 1
        }
        if i + l > R {
            R = i + l
            C = i
        }
        dp[i] = l
        res += l / 2
    }
    return res
}

// 1410. HTML 实体解析器
/**
 HTML 里这些特殊字符和它们对应的字符实体包括：

 双引号：字符实体为 &quot; ，对应的字符是 " 。
 单引号：字符实体为 &apos; ，对应的字符是 ' 。
 与符号：字符实体为 &amp; ，对应对的字符是 & 。
 大于号：字符实体为 &gt; ，对应的字符是 > 。
 小于号：字符实体为 &lt; ，对应的字符是 < 。
 斜线号：字符实体为 &frasl; ，对应的字符是 / 。
 给你输入字符串 text ，请你实现一个 HTML 实体解析器，返回解析器解析后的结果。
 */
func entityParser(_ text: String) -> String {
    let textChar = Array(text),map = [
        "&quot;":"\"",
        "&apos;":"'",
        "&amp;":"&",
        "&gt;":">",
        "&lt;":"<",
        "&frasl;":"/",
    ],n = textChar.count
    var res = "",i = 0,begin = -1
    while i < n {
        if textChar[i] == "&" {
            var j = i
            i += 1
            while i < n {
                if textChar[i] == "&" {
                    j = i
                }
                if textChar[i] == ";" {
                    let temp = String(textChar[j...i])
                    if let cur = map[temp] {
                        res += String(textChar[(begin + 1)..<j]) + cur
                        begin = i
                    }
                    break
                }
                i+=1
            }
            
        }
        i += 1
    }
    if begin+1 < n {
        res += String(textChar[(begin + 1)..<n])
    }
    return res
}

// 1525. 字符串的好分割数目
func numSplits(_ s: String) -> Int {
    let sC = Array(s),n = sC.count
    guard n > 1 else {
        return 0
    }
    var arr = Array(repeating: 0, count: n),set = Set<Character>()
    for i in (0..<n).reversed() {
        set.insert(sC[i])
        arr[i] = set.count
    }
    set = [sC[0]]
    var res = 0
    for i in 1..<n {
        if set.count == arr[i] {
            res += 1
        }
        set.insert(sC[i])
    }
    return res
}

//2707. 字符串中的额外字符
func minExtraChar(_ s: String, _ dictionary: [String]) -> Int {
    let hasSet = Set(dictionary)
    
    func subString(b:Int,e:Int) -> String {
        let begin = s.index(s.startIndex, offsetBy: b)
        let end = s.index(s.startIndex, offsetBy: e)
        return String(s[begin..<end])
    }
    var d = Array(repeating: 0, count: s.count + 1)
    d[0] = 0
    for i in 1...s.count {
        d[i] = d[i-1] + 1
        for j in (0..<i).reversed() where hasSet.contains(subString(b: j, e: i)) {
            d[i] = min(d[i],d[j])
        }
    }
    return d[s.count]
}
// 2696. 删除子串后的字符串最小长度 删除任一 "AB" 或 "CD"
func minLength(_ s: String) -> Int {
    var char = [Character]()
    for sc in s {
        char.append(sc)
        let m = char.count
        if m >= 2,(char[m-1] == "B" && char[m-2] == "A") || (char[m-1] == "D" && char[m-2] == "C") {
            char.removeLast()
            char.removeLast()
        }
    }
    return char.count
}

// 72. 编辑距离
/**
 给你两个单词 word1 和 word2， 请返回将 word1 转换成 word2 所使用的最少操作数  。
 插入一个字符
 删除一个字符
 替换一个字符
 w1和w2
 dp[i][j] 表示 代表 word1 到 i 位置转换成 word2 到 j 位置需要最少步数
 dp[i-1][j-1], 相等
 dp[i-1][j] 删除  //w1的前i-1个和w2的前j个相等，w1的i再减1个，就和dp[i-1][j] 一样了
 dp[i][j-1] + 1 //w1的前i个和w2的前j-1个相等，再w1在加1个，等于w2的j位置了
 dp[i-1][j-1] + 1 // 替换，w1的第i个替换成w2的第j个
 dp[i][j] =  1.  dp[i-1][j-1]
 2. min(dp[i-1][j-1],dp[i-1][j],dp[i][j-1]) + 1
 */
func minDistance(_ word1: String, _ word2: String) -> Int {
    let w1 = Array(word1),w2 = Array(word2),m = w1.count,n = w2.count
    var dp = Array(repeating: Array(repeating: 0, count: n + 1), count: m + 1)
    for i in 0..<m { dp[i+1][0] = dp[i][0] + 1}
    for i in 0..<n { dp[0][i+1] = dp[0][i] + 1}
    for i in 0..<m {
        for j in 0..<n {
            if w1[i] == w2[j] {
                dp[i+1][j+1] = dp[i][j]
            } else {
                dp[i+1][j+1] = min(dp[i][j],dp[i+1][j],dp[i][j+1]) + 1
            }
        }
    }
    return dp[m][n]
}

//2645. 构造有效字符串的最少插入数
//给你一个字符串 word ，你可以向其中任何位置插入 "a"、"b" 或 "c" 任意次，返回使 word 有效 需要插入的最少字母数。
//如果字符串可以由 "abc" 串联多次得到，则认为该字符串 有效
// d[i]
func addMinimum(_ word: String) -> Int {
    let arrC = Array(word)
    
    var last:Character = arrC.first!
    var res = last == "a" ? 0:(last == "b" ? 1:2)
    for i in 1..<arrC.count {
        switch (arrC[i],last) {
        case ("a","b"):res += 1
        case ("a","a"):res += 2
        case ("b","c"):res += 1
        case ("b","b"):res += 2
        case ("c","a"):res += 1
        case ("c","c"):res += 2
        default:break
        }
        last = arrC[i]
    }
    return res + (last == "c" ? 0:(last == "b" ? 1:2))
}
// 动态规划做法
/**
 d[i]是i前面，最少拼接的数量
 
1. 以w[i] 为一组abc  d[i] = d[i-1] + 2
2. 以w[i-1] < w[i],那么i-1和i可以为一组abc  d[i] = d[i-1] - 1
 */
func addMinimum2(_ word: String) -> Int {
    let arrC = Array(word)
    var last = 0
    for i in 1...arrC.count {
        var temp = last + 2
        if i>1,arrC[i-1] > arrC[i-2] {
            temp = last - 1
        }
        last = temp
    }
    return last
}

//2182. 构造限制重复的字符串"cczazcc"
func repeatLimitedString(_ s: String, _ repeatLimit: Int) -> String {
    let begin = Int(UnicodeScalar("a").value)
    var fis = 0,sec = -1,timeDp = Array(repeating: 0, count: 26)
    for sc in s {
        let i =  Int(UnicodeScalar(String(sc))!.value) -  begin
        timeDp[i] += 1
        if i > fis {
            sec = fis
            fis = Int(i)
        } else if fis > i,i > sec {
            sec = Int(i)
        }
    }
    
    var res = ""
    while fis >= 0,timeDp[fis] > 0 {
        let cur =  Character(UnicodeScalar(fis + begin)!)
        if timeDp[fis] <= repeatLimit {
            res += String(Array(repeating: cur, count: timeDp[fis]))
            fis = sec
            sec = nextSec(sec: sec - 1)
        } else {
            timeDp[fis] -= repeatLimit
            res += String(Array(repeating: cur, count: repeatLimit))
            sec = nextSec(sec: sec)
            guard sec >= 0 else {
                break
            }
            res += String(Character(UnicodeScalar(sec + begin)!))
            timeDp[sec] -= 1
            sec = nextSec(sec: sec)
        }
    }
    
    func nextSec(sec:Int) -> Int {
        guard sec >= 0 else {
            return -1
        }
        guard timeDp[sec] == 0 else {
            return sec
        }
        for i in (0..<sec).reversed() where timeDp[i] > 0 {
            return i
        }
        return -1
    }
    return res
}

//2744. 最大字符串配对数目
func maximumNumberOfStringPairs(_ words: [String]) -> Int {
    var set = Set<String>(),res = 0
    for word in words.reversed() {
        if set.contains(String(word.reversed())) {
            res += 1
        } else {
            set.insert(word)
        }
    }
    return res
}

// 2788. 按分隔符拆分字符串
func splitWordsBySeparator(_ words: [String], _ separator: Character) -> [String] {
    var res = [String]()
    for word in words {
        res += word.split(separator: separator).map({ String($0) })
    }
    return res
}


//514. 自由之路
/**
 电子游戏“辐射4”中，任务 “通向自由” 要求玩家到达名为 “Freedom Trail Ring” 的金属表盘，并使用表盘拼写特定关键词才能开门。

 给定一个字符串 ring ，表示刻在外环上的编码；给定另一个字符串 key ，表示需要拼写的关键词。您需要算出能够拼写关键词中所有字符的最少步数。

 最初，ring 的第一个字符与 12:00 方向对齐。您需要顺时针或逆时针旋转 ring 以使 key 的一个字符在 12:00 方向对齐，然后按下中心按钮，以此逐个拼写完 key 中的所有字符。

 旋转 ring 拼出 key 字符 key[i] 的阶段中：

 您可以将 ring 顺时针或逆时针旋转 一个位置 ，计为1步。旋转的最终目的是将字符串 ring 的一个字符与 12:00 方向对齐，并且这个字符必须等于字符 key[i] 。
 如果字符 key[i] 已经对齐到12:00方向，您需要按下中心按钮进行拼写，这也将算作 1 步。按完之后，您可以开始拼写 key 的下一个字符（下一阶段）, 直至完成所有拼写。
 1 <= ring.length, key.length <= 100
 ring 和 key 只包含小写英文字母
 保证 字符串 key 一定可以由字符串  ring 旋转拼出
 // 当前是i，解决key中为j的长度
 a -> b  a < b (b - a) (n-1 - a + b + 1)
 f[i][j] = a[i] == k[j] (f[i][j-1] + 1)
       = f[i..0][j-1]
 f[0][0] = 0
 "godding" "gd"
 */
func findRotateSteps(_ ring: String, _ key: String) -> Int {
    let rArr = Array(ring),rN = rArr.count,
        kArr = Array(key),kN = kArr.count
    var dp = Array(repeating: Array(repeating: Int.max/2, count: rN), count: kN+1)
    for i in 0..<rN {
        dp[0][i] = min(i,rN-i)
    }
    
    func minLen(a:Int,b:Int) -> Int { //a到b的最小距离
        let maxA = max(a,b),minB = min(a,b)
        return min(maxA - minB,rN - maxA + minB)
    }
    for i in 1...kN { //key到了j个
        for j in 0..<rN {
            //当前a为j，b为z，由z转到a
            for z in 0..<rN where rArr[z] == kArr[i-1]{
                // 由z转换到i
                dp[i][j] = min(dp[i][j],dp[i-1][z] + minLen(a: j, b: z) + 1)
            }
        }
    }
    return dp[kN].min()!
}

// 71. 简化路径
/**
 给你一个字符串 path ，表示指向某一文件或目录的 Unix 风格 绝对路径 （以 '/' 开头），请你将其转化为更加简洁的规范路径。

 在 Unix 风格的文件系统中，一个点（.）表示当前目录本身；此外，两个点 （..） 表示将目录切换到上一级（指向父目录）；两者都可以是复杂相对路径的组成部分。任意多个连续的斜杠（即，'//'）都被视为单个斜杠 '/' 。 对于此问题，任何其他格式的点（例如，'...'）均被视为文件/目录名称。

 请注意，返回的 规范路径 必须遵循下述格式：

 始终以斜杠 '/' 开头。
 两个目录名之间必须只有一个斜杠 '/' 。
 最后一个目录名（如果存在）不能 以 '/' 结尾。
 此外，路径仅包含从根目录到目标文件或目录的路径上的目录（即，不含 '.' 或 '..'）。
 返回简化后得到的 规范路径 。
 */
func simplifyPath(_ path: String) -> String {
    var chars = [String](),begin = -1
    let paChars = Array(path + "/")
    for i in 0..<paChars.count {
        switch paChars[i] {
        case "/":
            if begin > -1 {
                let cu = String(paChars[begin..<i])
                if cu == ".." {
                    if !chars.isEmpty { chars.removeLast() }
                } else if cu == "." {
                    
                } else {
                    chars.append(cu)
                }
                begin = -1
            }
        default:
            if begin == -1 {
                begin = i
            }
        }
    }
    return "/" + chars.joined(separator: "/")
}
