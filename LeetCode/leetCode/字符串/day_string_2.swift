//
//  day_string_2.swift
//  leetCode
//
//  Created by 陈晶泊 on 2022/10/29.
//

import Foundation
//1773. 统计匹配检索规则的物品数量
func countMatches(_ items: [[String]], _ ruleKey: String, _ ruleValue: String) -> Int {
    let index:Int
    if ruleKey == "type" {
        index = 0
    } else if ruleKey == "color" {
        index = 1
    } else {
        index = 2
    }
    var map = [String:Int]()
    for item in items where item.count > index {
        let temp = item[index]
        map[temp] = (map[temp] ?? 0) + 1
    }
    return map[ruleValue] ?? 0
}

//784. 字母大小写全排列
func letterCasePermutation(_ s: String) -> [String] {
    func letterCasePermutation(_ char: [Character],_ left:Int) -> [String] {
        let count = char.count
        guard left < count else {
            return [""]
        }
        var i = left
        while i < char.count {
            if !CharacterSet.decimalDigits.contains(UnicodeScalar(String(char[i]))!) {
                //不包含数字
                let cur = String(char[left...i])
                let cur1 = cur.uppercased(),cur2 = cur.lowercased()
                return letterCasePermutation(char, i+1).flatMap { str in
                    return [cur1 + str,cur2 + str]
                }
                
            }
            i += 1
        }
        //到这。说明全是数字
        return [String(char[left..<count])]
    }
    let char = Array(s)
    return letterCasePermutation(char, 0)
}

//520. 检测大写字母
func detectCapitalUse(_ word: String) -> Bool {
    
    guard word.count > 1 else {
        return true
    }
    if word.uppercased() == word {
        return true
    } else if word.lowercased() == word {
        return true
    } else {
        let arr = Array(word)
        let temp = (arr[0].uppercased() + String(arr[1..<arr.count]).lowercased())
        return temp == word
    }
}

//1668. 最大重复子字符串
func maxRepeating(_ sequence: String, _ word: String) -> Int {
    
    func nexArray(_ word:String,_ char:[Character])->[Int]{
        var nexArr = Array(repeating: 0, count: word.count),cn = 0,i = 2
        nexArr[0] = -1
        while i < nexArr.count {
            if char[i-1] == char[cn] {
                cn += 1
                nexArr[i] = cn
                i+=1
            } else if cn > 0 {
                cn = nexArr[cn]
            } else {
                nexArr[i] = 0
                i += 1
            }
        }
        return nexArr
    }
    
    let count = sequence.count,len = word.count
    guard count >= len else {
        return 0
    }
    let nextStr = Array(repeating: word, count: Int(count/len)).joined(),wordChar = Array(nextStr),sqArr = Array(sequence)
    let nexArry = nexArray(nextStr,wordChar)
    
    var i = 0,j = 0,maxNum = 0
    while i < count,j < nexArry.count{
        if sqArr[i] == wordChar[j] {
            i += 1
            j += 1
            maxNum = max(maxNum,j)
        } else if nexArry[j] == -1 {
            i += 1
        } else {
            j = nexArry[j]
        }
    }
    return maxNum / len
}

//1106. 解析布尔表达式
func parseBoolExpr(_ expression: String) -> Bool {
    
    let count = expression.count
    guard count > 3 else {
        return expression == "f" ? false:true
    }
    //前二必为&(,最后为)
    let chars = Array(expression)
    var nums = [Int]() //标记位置
    var bools = [(Int,Bool)]()
    
    for i in 0..<chars.count {
        switch chars[i] {
        case "|","&","!":
            nums.append(i)
        case "f","t":
            bools.append((i,chars[i] == "t"))
        case ")":
            if let last = nums.last {
                let lastChar = chars[last]
                if lastChar == "!" {
                    bools[bools.count - 1].1 = !bools[bools.count - 1].1
                } else if lastChar == "&" {
                    var temp = true
                    while let lastN = bools.last,lastN.0 > last {
                        temp =  temp && (lastN.1)
                        bools.removeLast()
                    }
                    bools.append((last,temp))
                } else if lastChar == "|" {
                    var temp = false
                    while let lastN = bools.last,lastN.0 > last {
                        temp =  temp || (lastN.1)
                        bools.removeLast()
                    }
                    bools.append((last,temp))
                }
                nums.removeLast()
            }
        default:
            break
        }
    }
    return bools.first!.1
}

//1678. 设计 Goal 解析器
func interpret(_ command: String) -> String {
    command.replacingOccurrences(of: "()", with: "o").replacingOccurrences(of: "(al)", with: "al")
}

//816. 模糊坐标
func ambiguousCoordinates(_ s: String) -> [String] {
    func ambiguous(_ chasrs:[Character],_ left:Int,_ right:Int)->[String] {
        guard left < right else {
            return []
        }
        guard (right - left) > 1 else {
            return [String(chasrs[left])]
        }
        guard let num = Int("\(String(chasrs[left..<right]))"),num != 0 else {
            return []
        }
        
        if chasrs[left] == "0" {
            guard chasrs[right-1] != "0" else {
                return []
            }
            return ["0.\(String(chasrs[(left+1)..<right]))"]
        } else if chasrs[right-1] == "0" {
            return ["\(String(chasrs[left..<right]))"]
        } else {
            var strs = [String]()
            for i in left..<(right-1){
                strs.append("\(String(chasrs[left...i])).\(String(chasrs[(i + 1)..<right]))")
            }
            strs.append("\(String(chasrs[left..<right]))")
            return strs
        }
    }
    let chars = Array(s),count = chars.count-1
    let isOne = chars[1] != "0"
    var reslut = [String]()
    //从第2
    for i in 1..<(count - 1) {
        if isOne {
            //1。。。每一个都有
            let friArr = ambiguous(chars, 1, i+1)
            let sceArr = ambiguous(chars, i+1, count)
            reslut += friArr.flatMap { str1 in
                return sceArr.map { str2 in
                   return "(\(str1), \(str2))"
                }
            }
        } else if i == 1 || chars[i] != "0"{
            //0...开头,必须当前不是0
            let friArr = ambiguous(chars, 1, i+1)
            let sceArr = ambiguous(chars, i+1, count)
            reslut += friArr.flatMap { str1 in
                return sceArr.map { str2 in
                   return "(\(str1), \(str2))"
                }
            }
        }
    }
    
    return reslut
}

//1684. 统计一致字符串的数目
func countConsistentStrings(_ allowed: String, _ words: [String]) -> Int {
    var map = Set<Character>()
    for char in allowed {
        map.insert(char)
    }
    func isAllow(_ word:String,_ chars:Set<Character>)->Bool {
        for w in word where !chars.contains(w){
            return false
        }
        return true
    }
    var num = 0
    for word in words where isAllow(word, map){
        num += 1
    }
    return num
}

//791. 自定义字符串排序

func customSortString(_ order: String, _ s: String) -> String {
    var map = [Character:Int]()
    for sChar in s {
        map[sChar] = (map[sChar] ?? 0) + 1
    }
    var result = [Character]()
    let sds = "ssss".split(separator: "_")
    for oChar in order where map[oChar] != nil{
        result.append(contentsOf: Array(repeating: oChar, count: map[oChar]!))
        map.removeValue(forKey: oChar)
    }
    for dic in map {
        result.append(contentsOf: Array(repeating: dic.key, count: dic.value))
    }
    return String(result)
}

//1704. 判断字符串的两半是否相似
func halvesAreAlike(_ s: String) -> Bool {
    func isAvailed(_ char:Character)->Bool {
        switch char.lowercased() {
        case "a","e","i","o","u":return true
        default:return false
        }
    }
    let mid = s.count / 2
    var num = 0
    for char in s.enumerated() where isAvailed(char.element){
        guard char.offset < mid  else {
            num -= 1
            continue
        }
        num += 1
    }
    return num == 0
}

//792. 匹配子序列的单词数
func numMatchingSubseq(_ s: String, _ words: [String]) -> Int {
    func isSubseq(_ s:String,_ chars:[Character:[Int]]) -> Bool{
        var idx = -1
        for sC in s {
            guard let list = chars[sC] else {
                return false
            }
            var (left,right,mid) = (0,list.count-1,(list.count-1)/2)
            while left < right {
                mid = (right - left) >> 1 + left
                if list[mid] <= idx {
                    left = mid + 1
                } else {
                    right = mid
                }
            }
            guard list[left] > idx else {
                return false
            }
            idx = list[left]
        }
        return true
    }
    var (chars,result) = ([Character:[Int]](),0)
    chars.reserveCapacity(s.count)
    for (i,sChar) in s.enumerated() {
        chars[sChar] = (chars[sChar] ?? []) + [i]
    }
    for word in words where isSubseq(word, chars){
        result += 1
    }
    return result
}

func minOperations(_ s: String) -> Int {
    var (begin0,last0,begin1,last1) = (0,Character("0"),0,Character("1"))
    
    for sChar in s {
        if sChar != last0 {
            begin0 += 1
        }
        if sChar != last1 {
            begin1 += 1
        }
        let temp = last0
        last0 = last1
        last1 = temp
    }
    return min(begin0,begin1)
}

func minOperations(_ boxes: String) -> [Int] {
    var arr = [Int]()
    for (i,box) in boxes.enumerated() where box == "1" {
        arr.append(i)
    }
    var result = Array(repeating: 0, count: boxes.count)
    for i in 0..<boxes.count{
        result[i] = arr.reduce(0) { partialResult, j in
            return partialResult + abs(j-i)
        }
    }
    return result
}

//1796. 字符串中第二大的数字
func secondHighest(_ s: String) -> Int {
    var (i,j) = (-1,-1)
    for sChar in s where CharacterSet.decimalDigits.contains(UnicodeScalar(String(sChar))!) {
        let num = Int(String(sChar))!
        if num > j {
            i = j
            j = num
        } else if num < j,num > i {
            i = num
        }
    }
    return i
}

//1805. 字符串中不同整数的数目
func numDifferentIntegers(_ word: String) -> Int {
    let words = Array(word)
    func numWord(i:inout Int)->String {
        var numStr = ""
        var begin = false
        while i < words.count {
            let str = String(words[i])
            guard CharacterSet.decimalDigits.contains(UnicodeScalar(str)!) else {
                break
            }
            guard (begin || str != "0") else {
                i += 1
                continue
            }
            i += 1
            begin = true
            numStr += str
        }
        return numStr.isEmpty ? "0":numStr
    }
    var i = 0,numSet = Set<String>()
    while i < words.count {
        if CharacterSet.decimalDigits.contains(UnicodeScalar(String(words[i]))!){
            numSet.insert(numWord(i: &i))
        }
        i += 1
    }
    return numSet.count
}

func squareIsWhite(_ coordinates: String) -> Bool {
    let arr = Array(coordinates)
    let num1 = Int(UnicodeScalar(String(arr[0]))!.value - UnicodeScalar(String("a"))!.value) % 2
    let num2 = Int(String(arr[1]))! % 2
    
    return num1 == num2
}

func findTheDifference(_ s: String, _ t: String) -> Character {
    func num(s:String) -> Int {
        return Int(UnicodeScalar(s)!.value - UnicodeScalar(String("a"))!.value)
    }
    var arr = Array(repeating: 0, count: 26)
    for sC in s {
        arr[num(s: String(sC))] += 1
    }
    
    for tC in t {
        let i = num(s: String(tC))
        guard arr[i] > 0 else {
            return tC
        }
        arr[i] -= 1
    }
    return "a"
}


func checkIfPangram(_ sentence: String) -> Bool {
    let count = sentence.count
    guard count >= 26 else {
        return false
    }
    var hasSet = Set<String.Element>()
    for (i,sC) in sentence.enumerated() {
        guard hasSet.count < 26 else {
            return true
        }
        hasSet.insert(sC)
        guard (hasSet.count + count - 1 - i) >= 26 else {
            return false
        }
    }
    return hasSet.count >= 26
}

//1945. 字符串转化后的各位数字之和
func getLucky(_ s: String, _ k: Int) -> Int {
    
    func num1(_ sC: Character) -> Int {
        return Int(UnicodeScalar(String(sC))!.value - UnicodeScalar("a").value) + 1
    }

    func numTran(_ num:Int) -> Int {
        guard num >= 10 else {
            return num
        }
        var (num,res) = (num,0)
        while num > 0 {
            res += num % 10
            num = num / 10
        }
        return res
    }
    
    var num = 0
    for sc in s {
        let temp = num1(sc)
        num += numTran(temp)
    }
    for _ in 1..<k {
        num = numTran(num)
    }
     return num
 }


func largestMerge(_ word1: String, _ word2: String) -> String {
    let arr1 = Array(word1),arr2 = Array(word2)
    func isFristSelect(i:Int,j:Int) -> Bool {
        var chang = 0
        while i+chang < arr1.count,
              j+chang < arr2.count,
              arr1[i + chang] == arr2[j + chang] {
            chang += 1
        }
        if i+chang < arr1.count,
           j+chang < arr2.count {
            return arr1[i + chang] > arr2[j + chang]
        } else if i+chang < arr1.count {
            //1，更长
            return true
        } else if j+chang < arr2.count {
            return true
        } else {
            //都越界,随便选
            return true
        }
    }
    var i = 0,j = 0
    var res = ""
    while i < arr1.count,j < arr2.count {
        if isFristSelect(i: i, j: j) {
            res += String(arr1[i])
            i += 1
        } else {
            res += String(arr2[j])
            j += 1
        }
        
    }
    if i < arr1.count {
        res += String(arr1[i..<arr1.count])
    }
    
    if j < arr2.count {
        res += String(arr2[j..<arr2.count])
    }
    return res
}

//1759. 统计同构子字符串的数目
func countHomogenous(_ s: String) -> Int {
    let mod = 1000_000_007
    var last:Character?,num = 0,res = 0
    for sC in s {
        num = last == sC ? num+1:1
        last = sC
        res = (res + num) % mod
    }
    return res
}

func minimumMoves(_ s: String) -> Int {
let sChars = Array(s)
    var i = 0,res = 0
    while i < sChars.count {
        if sChars[i] == "X" {
            i += 3
            res += 1
        } else {
            i += 1
        }
    }
    return res
}


func minimumLength(_ s: String) -> Int {
    let sChars = Array(s)
    var i = 0,j = sChars.count-1
    while i < j {
        var ti = i,tj = j
        while ti < sChars.count,sChars[ti] == sChars[j] {
            ti += 1
        }
        
        while tj > 0,sChars[tj] == sChars[i] {
            tj -= 1
        }
        if ti == j || tj == j {
            return max(j - i + 1,0)
        }
        i = ti
        j = tj
    }
    return max(j - i + 1,0)
}

func repeatedCharacter(_ s: String) -> Character {
    var hasSet = Set<Character>()
    for sC in s {
        guard hasSet.contains(sC) else {
            hasSet.insert(sC)
            continue
        }
        return sC
    }
    return hasSet.first!
}
//409. 最长回文串
func longestPalindrome1(_ s: String) -> Int {
    var chars = [Character:Int]()
    for sChar in s {
        chars[sChar] = (chars[sChar] ?? 0) + 1
    }
    var res = 0,isNeedOdd = false
    for value in chars.values {
        if value % 2 == 0 {
            res += value
        } else if !isNeedOdd {
            isNeedOdd = true
            res += value
        } else {
            res += value - 1
        }
    }
    return res
}

func prefixCount(_ words: [String], _ pref: String) -> Int {
    let count = pref.count
    func subString(word:String)->String {
        let beign = word.startIndex
        let end = word.index(beign, offsetBy: count)
        return String(word[beign..<end])
    }
    var res = 0
    for word in words where word.count >= count && subString(word: word) == pref{
        res += 1
    }
    return res
}


//459. 重复的子字符串
//ababba
//
func repeatedSubstringPattern(_ s: String) -> Bool {
    func kmNextArr(needle:[Character])->[Int] {
        var arr = Array(repeating: -1, count: needle.count)
        for i in 1..<arr.count {
            var j = arr[i-1]
            while j != -1 && needle[j+1] != needle[i] {
                j = arr[j]
            }
            if needle[j+1] == needle[i] {
                arr[i] = j + 1
            }
        }
        return arr
    }
    
    //abaababaab
    //-1-1 1
    func creatNextArray(_ needle:[Character])->[Int] {
        var arr = Array(repeating: -1, count: needle.count),cn = 0,i = 1
        while i < needle.count {
            if cn >= 0,needle[i] == needle[cn] {
                cn += 1
                arr[i] = cn
                i += 1
            } else if cn > 0 {
                cn  = max(arr[cn-1],0)
            } else {
                i += 1
            }
        }
        return arr
    }
    let arr1 = kmNextArr(needle: Array(s))
    let arr = creatNextArray(Array(s))
    return arr[s.count-1] != -1 && s.count % (s.count - arr[s.count-1]-1) == 0
}

//2283. 判断一个数的数字计数是否等于数位的值
func digitCount(_ num: String) -> Bool {
    var arr = Array(num).map{Int(String($0))!}
    var sum = arr.reduce(0){ $0 + $1}
    guard sum == arr.count else {
        return false
    }
    let nums = arr
    for nu in nums {
        guard nu < arr.count,arr[nu] > 0 else {
            return false
        }
        arr[nu] -= 1
        sum -= 1
    }
    return sum == 0
}

//1807. 替换字符串中的括号内容
func evaluate(_ s: String, _ knowledge: [[String]]) -> String {
    func evaluateKey(sChars:[Character],index:inout Int) ->String {
        guard sChars[index] == "(" else {
            return ""
        }
        let begin = index + 1
        while index < sChars.count,sChars[index] != ")" {
            index += 1
        }
        guard sChars[index] == ")" else {
            return ""
        }
        return String(sChars[begin..<index])
    }
    var dic = [String:String]()
    for kno in knowledge {
        dic[kno[0]] = kno[1]
    }
    let sChars = Array(s)
    var index = 0,last = 0,res = ""
    while index < sChars.count {
        if sChars[index] == "(" {
            res += String(sChars[last..<index])
            let str = evaluateKey(sChars: sChars, index: &index)
            res += dic[str] ?? "?"
            last = index + 1
        }
        index += 1
    }
    res += String(sChars[last..<index])
    return res
}


func rearrangeCharacters(_ s: String, _ target: String) -> Int {
    var dic = [Character:Int]()
    for tc in target {
        dic[tc] = (dic[tc] ?? 0) + 1
    }
    var sDic = [Character:Int]()
    for sc in s where dic[sc] != nil {
        sDic[sc] = (sDic[sc] ?? 0) + 1
    }
    guard sDic.count == dic.count else {
        return 0
    }
    var res:Int?
    for (k,v) in sDic {
        guard let num = res else {
            res = v / dic[k]!
            continue
        }
        guard num > 0 else {
            return 0
        }
        res = min(v / dic[k]!,num)
    }
    return res ?? 0
    
}

//383. 赎金信
func canConstruct(_ ransomNote: String, _ magazine: String) -> Bool {
    var dic = [Character:Int]()
    for mc in magazine {
        dic[mc] = (dic[mc] ?? 0) + 1
    }
    for rc in ransomNote {
        guard let num = dic[rc],num > 0 else {
            return false
        }
        dic[rc] = num - 1
    }
    return true
}
//345. 反转字符串中的元音字母
//'a'、'e'、'i'、'o'、'u'
func reverseVowels(_ s: String) -> String {
    func isVowel(char:Character) -> Bool {
        let num = char.lowercased()
        switch num {
        case "a","e","i","o","u":return true
        default:return false
        }
    }
    var sChar = Array(s)
    var left = 0,right = s.count-1
    while left < right {
        while left < right,!isVowel(char: sChar[left]) {
            left += 1
        }
        
        while left < right,!isVowel(char: sChar[right]) {
            right -= 1
        }
        guard isVowel(char: sChar[left]),isVowel(char: sChar[right]) else {
            return String(sChar)
        }
        let temp = sChar[left]
        sChar[left] = sChar[right]
        sChar[right] = temp
        left += 1
        right -= 1
    }
    return String(sChar)
}
/*
 *它有至少 8 个字符。
 至少包含 一个小写英文 字母。
 至少包含 一个大写英文 字母。
 至少包含 一个数字 。
 至少包含 一个特殊字符 。特殊字符为："!@#$%^&*()-+" 中的一个。
 它 不 包含 2 个连续相同的字符（比方说 "aab" 不符合该条件，但是 "aba" 符合该条件）。
 */
//414. 第三大的数
func strongPasswordCheckerII(_ password: String) -> Bool {
    guard password.count >= 8 else {
        return false
    }
    let chars = CharacterSet(charactersIn: "!@#$%^&*()-+")
    var mode = 0x0,lasC:Character?
    for pasC in password {
        if lasC == pasC {
            return false
        }
        lasC = pasC
        if case "a"..."z" = pasC {
            mode |= 0x1
        }
        
        if case "A"..."Z" = pasC {
            mode |= 0x10
        }
        
        let scalar = UnicodeScalar(String(pasC))!
        if CharacterSet.decimalDigits.contains(scalar) {
            mode |= 0x100
        }
        if chars.contains(scalar) {
            mode |= 0x1000
        }
    }
    return mode == 0x1111
}

//412. Fizz Buzz
/**
 answer[i] == "FizzBuzz" 如果 i 同时是 3 和 5 的倍数。
 answer[i] == "Fizz" 如果 i 是 3 的倍数。
 answer[i] == "Buzz" 如果 i 是 5 的倍数。
 answer[i] == i （以字符串形式）如果上述条件全不满足。
 */
func fizzBuzz(_ n: Int) -> [String] {
    func fizzStr(_ i:Int) -> String {
        if i % 3 == 0,i % 5 == 0 {
            return "FizzBuzz"
        }
        if i % 3 == 0 {
            return "Fizz"
        }
        if i % 5 == 0 {
            return "Buzz"
        }
        return "\(i)"
    }
    var res = Array(repeating: "", count: n)
    for i in 1...n {
        res[i-1] = fizzStr(i)
    }
    return res
}

//2309. 兼具大小写的最好英文字母
func greatestLetter(_ s: String) -> String {
    var arr = Array(repeating: 0, count: 26)
    for sC in s {
        switch sC {
        case "a"..."z":
            arr[Int(UnicodeScalar(String(sC))!.value) - Int(UnicodeScalar("a").value)] |= 0x1
        case "A"..."Z":
            arr[Int(UnicodeScalar(String(sC))!.value) - Int(UnicodeScalar("A").value)] |= 0x10
        default:break
        }
    }
    for i in (0..<arr.count).reversed() where arr[i] == 0x11 {
        return UnicodeScalar(Int(UnicodeScalar("A").value) + i)!.description
    }
    return ""
}


func reverseWords(_ s: String) -> String {
    var chars = Array(s)
    func reverseWord(_ left:Int,_ right:Int){
        var l = left,r = right
        while l < r {
            let t = chars[l]
            chars[l] = chars[r]
            chars[r] = t
            l += 1
            r -= 1
        }
    }
    var l = 0
    for i in 0..<chars.count where chars[i] == " " {
        reverseWord(l, i-1)
        l = i+1
    }
    reverseWord(l, chars.count-1)
    return String(chars)
}

//2325. 解密消息
func decodeMessage(_ key: String, _ message: String) -> String {
    var arr = Array(repeating: -1, count: 26),i = 0
    let begin = Int(UnicodeScalar("a").value)
    for kc in key where kc != " " {
        let temp = Int(UnicodeScalar(String(kc))!.value) - begin
        guard arr[temp] == -1 else {
            continue
        }
        arr[temp] = i
        i += 1
    }
    var res = ""
    for mC in message {
        if mC == " " {
            res += " "
            continue
        }
        let temp = Int(UnicodeScalar(String(mC))!.value) - begin
        res += UnicodeScalar(arr[temp] + begin)!.description
    }
    return res
}

//1604. 警告一小时内使用相同员工卡大于等于三次的人
func alertNames(_ keyName: [String], _ keyTime: [String]) -> [String] {
    func numTime(str:String)->Int {
        return Int(str.replacingOccurrences(of: ":", with: "")) ?? 0
    }
    
    func subNum(time1:Int,time2:Int) -> Int {
        guard time1 > time2 else {
            return 0
        }
        //time1 > time2
        let minute = (time1 % 100) - (time2 % 100)
        let hour = (time1 / 100) - (time2 / 100)
        return hour * 60 + minute
    }
    
    func hasOneHour(times:[String]) -> Bool {
        var timeNums = times.map { numTime(str: $0)}
        timeNums.sort()
        var last = timeNums[0],le = 60,res = 1
        for i in 1..<timeNums.count {
            let temp = subNum(time1: timeNums[i], time2: last)
            if temp > le {
                (res,le) = (2,60 - temp)
            } else {
                le = le - temp
                res += 1
            }
            if res == 3 {
                return true
            } else if res + (timeNums.count - 1 - i) < 3 {
                return false
            }
            last = timeNums[i]
        }
        return false
    }
    
    var map = [String:[String]]()
    for i in 0..<keyName.count {
        map[keyName[i]] = (map[keyName[i]] ?? []) + [keyTime[i]]
    }
    var arr = [String]()
    for (key,value) in map where value.count > 2 &&  hasOneHour(times: value) {
        arr.append(key)
    }
    return arr.sorted()
}

//1233. 删除子文件夹
func removeSubfolders(_ folder: [String]) -> [String] {
    let foldSort = folder.sorted()
    var res = [foldSort[0]]
    for i in 1..<foldSort.count where !foldSort[i].hasPrefix("\(res.last!)/"){
        res.append(foldSort[i])
    }
    return res
}


//1138. 字母板上的路径
func alphabetBoardPath(_ target: String) -> String {
    func path(begin:String,to:String) -> String {
        let aNum = UnicodeScalar("a").value
        let beginNum = Int(UnicodeScalar(begin)!.value - aNum)
        let endNum = Int(UnicodeScalar(to)!.value - aNum)
        let (rowB,colB,rowE,colE) = (beginNum/5,beginNum % 5,endNum/5,endNum % 5)
        var colRes = "",rolRes = ""
        if colB != colE {
            colRes = Array(repeating: colE > colB ? "R":"L", count: abs(colB - colE)).joined()
        }
        if rowB != rowE {
            rolRes = Array(repeating: rowE > rowB ? "D":"U", count: abs(rowB - rowE)).joined()
        }
        
        if begin == "z" {
            return colRes + rolRes + "!"
        }
        return rolRes + colRes + "!"
    }
    var last = "a",res = ""
    for tChar in target {
        let temp = String(tChar)
        res += path(begin: last, to: temp)
        last = temp
    }
    return res
}

//1234. 替换子串得到平衡字符串
/**
 有一个只含有 'Q', 'W', 'E', 'R' 四种字符，且长度为 n 的字符串。

 假如在该字符串中，这四个字符都恰好出现 n/4 次，那么它就是一个「平衡字符串」。

  

 给你一个这样的字符串 s，请通过「替换一个子串」的方式，使原字符串 s 变成一个「平衡字符串」。

 你可以用和「待替换子串」长度相同的 任何 其他字符串来完成替换。

 请返回待替换子串的最小可能长度。

 如果原字符串自身就是一个平衡字符串，则返回 0。
 "RRWWR RRW   WEWR"
 "WWWEQRQEWWQQQWQQ QWEWEEWRRRRRWW QE"
 */
func balancedString(_ s: String) -> Int {
    let sChar = Array(s),count = sChar.count
    var tempArr = Array(repeating: count/4, count: 4),left = count
    func numIndex(char:Character) ->Int {
        switch char {
        case "Q":return 0
        case "W":return 1
        case "E":return 2
        case "R":return 3
        default:return -1
        }
    }
    for i in 0..<count {
        let index = numIndex(char: sChar[i])
        guard case 0..<4 = index,tempArr[index] > 0 else {
            left = i
            break
        }
        tempArr[index] -= 1
    }
    guard left < count else {
        return count - left
    }
    var res = left
    for i in (0..<count).reversed() {
        let index = numIndex(char: sChar[i])
        guard case 0..<4 = index else {
            return -1
        }
        tempArr[index] -= 1
        while tempArr[index] < 0,left > 0 {
            left -= 1
            tempArr[numIndex(char: sChar[left])] += 1
        }
        guard tempArr[index] >= 0 else {
            break
        }
        res = max(res,left + count - i)
    }
       return count - res
}
//680. 验证回文串 II
//  ebcbbececabbacecbbcbe
//给你一个字符串 s，最多 可以从中删除一个字符。
func validPalindrome(_ s: String) -> Bool {
    let chars = Array(s)
    func isVaild(l:Int,r:Int,change:Bool) -> Bool {
        var left = l,right = r
        while left < right {
            if chars[left] == chars[right] {
                left += 1
                right -= 1
            } else if change {
                return false
            } else {
                return isVaild(l: left, r: right-1, change: !change) || isVaild(l: left+1, r: right, change: !change)
            }
        }
        return true
    }
    
    return isVaild(l: 0, r: chars.count - 1, change: false)
}

//2347. 最好的扑克手牌
/**
 给你一个整数数组 ranks 和一个字符数组 suit 。你有 5 张扑克牌，第 i 张牌大小为 ranks[i] ，花色为 suits[i] 。

 下述是从好到坏你可能持有的 手牌类型 ：

 "Flush"：同花，五张相同花色的扑克牌。
 "Three of a Kind"：三条，有 3 张大小相同的扑克牌。
 "Pair"：对子，两张大小一样的扑克牌。
 "High Card"：高牌，五张大小互不相同的扑克牌。
 请你返回一个字符串，表示给定的 5 张牌中，你能组成的 最好手牌类型 。

 注意：返回的字符串 大小写 需与题目描述相同。
 [3,3,13,7,3]
 */
func bestHand(_ ranks: [Int], _ suits: [Character]) -> String {
    let count = min(ranks.count, ranks.count)
    var suitSet = Set<Character>(),ranSet = [Int:Int]()
    var maxSame = 0
    for i in 0..<count {
        suitSet.insert(suits[i])
        ranSet[ranks[i]] = (ranSet[ranks[i]] ?? 0) + 1
        maxSame = max(maxSame,ranSet[ranks[i]]!)
    }
    if suitSet.count == 1 {
        return "Flush"
    } else if maxSame > 2 {
        return "Three of a Kind"
    } else if ranSet.count < 5 {
        return "Pair"
    } else {
        return "High Card"
    }
}

//1247. 交换字符使得字符串相同
func minimumSwap(_ s1: String, _ s2: String) -> Int {
    let count = s1.count,arr1 = Array(s1),arr2 = Array(s2)
    var yx = 0,xy = 0
    for i in 0..<count where arr1[i] != arr2[i]{
        xy += arr1[i] == "x" ? 1:0
        yx += arr1[i] == "y" ? 1:0
    }
    let remain = xy % 2 + yx % 2
    guard remain % 2 == 0 else {
        return -1
    }
    return xy / 2 + yx / 2 + remain
}

//1255. 得分最高的单词集合
func maxScoreWords(_ words: [String], _ letters: [Character], _ score: [Int]) -> Int {
    let n = words.count
    func num(char:Character) -> Int {
        return Int(UnicodeScalar(String(char))!.value - UnicodeScalar("a").value)
    }
    var letterArr = Array(repeating: 0, count: 26)
    for letter in letters {
        letterArr[num(char: letter)] += 1
    }
    var maxRes = 0
outer: for i in 1..<(1 << n) {
        var wordArr = Array(repeating: 0, count: 26)
        for k in 0..<n where (i >> k) & 1 != 0{
            for wC in words[k] {
                wordArr[num(char: wC)] += 1
            }
        }
        var res = 0
        for (i,num) in wordArr.enumerated() where num != 0 {
            if num > letterArr[i] {
                continue outer
            }
            res += num * score[i]
        }
        maxRes = max(maxRes,res)
    }
    return maxRes
}

///1487. 保证文件名唯一
func getFolderNames(_ names: [String]) -> [String] {
    var map = [String:Int]()
    var res = Array(repeating: "", count: names.count)
    for i in 0..<names.count {
        if var num = map[names[i]] {
            num += 1
            while map["\(names[i])(\(num))"] != nil {
                num += 1
            }
            map[names[i]] = num
            if  map["\(names[i])(\(num))"] == nil {
                map["\(names[i])(\(num))"] = 0
            }
            res[i] = "\(names[i])(\(num))"
        } else {
            map[names[i]] = 0
            res[i] = names[i]
        }
    }
    return res
}
