//
//  day_字符串.swift
//  leetCode
//
//  Created by 陈晶泊 on 2022/5/28.
//

import Foundation
func removeOuterParentheses(_ s: String) -> String {
    var times = 0
    var result = ""
    var temps:[Character] = []
    for i in s {
        if i == "(" {
            times += 1
        } else {
            times -= 1
        }
        temps.append(i)
        if times == 0 {
            if temps.count > 2 {
                result += String(temps[1..<temps.count-1])
            }
            temps = []
        }
    }
    return result
}

func selfDividingNumbers(_ left: Int , _ right: Int) -> [Int] {
    var result = [Int]()
    for i in left...right {
        var isNeed = true
        if i > 0,i < 10 {
            isNeed = true
        } else {
            var temp = i
            while temp > 0 {
                let j = temp % 10
                if j == 0 || i % j != 0 {
                    isNeed = false
                    break
                }
                temp = temp / 10
            }
        }
        if isNeed {
            result.append(i)
        }
    }
    return result
}

func findClosest(_ words: [String], _ word1: String, _ word2: String) -> Int {
    var result = Int.max,p = -1,q = -1
    for i in 0..<words.count {
        if words[i] == word1 {
           p = i
        } else if words[i] == word2 {
            q = i
        }
        if q != -1,p != -1 {
            result = min(result, abs(p-q))
        }
    }
    return result
}
//罗马数转整数
func romanToInt(_ s: String) -> Int {
    var last:Character?,sum = 0
    for i in s {
        var num = 0
        switch i {
        case "I":
            num = 1
        case "V":
            num = changeByLastNum(needChange: last == "I", num: 5,chang: 1)
            break
        case "X":
            num = changeByLastNum(needChange: last == "I", num: 10,chang: 1)
            break
        case "L":
            num = changeByLastNum(needChange: last == "X", num: 50,chang: 10)
            break
        case "C":
            num = changeByLastNum(needChange: last == "X", num: 100,chang: 10)
            break
        case "D":
            num = changeByLastNum(needChange: last == "C", num: 500,chang: 100)
            break
        case "M":
            num = changeByLastNum(needChange: last == "C", num: 1000,chang: 100)
            break
        default:
            break
        }
        sum += num
        last = i
    }
    return sum
}

func changeByLastNum(needChange:Bool,num:Int,chang:Int)->Int {
    guard needChange else {
        return num
    }
    return num - 2 * chang
}

//ip69地址判断
func validIPAddress(_ queryIP: String) -> String {
    let result = "Neither"
    let array:[Substring]
    if queryIP.contains(":"){
        array = queryIP.split(separator: ":",omittingEmptySubsequences: false)
    } else {
        array = queryIP.split(separator: ".",omittingEmptySubsequences: false)
    }
    if array.count == 4 {
        for i in array {
            guard i.count < 5 && i.count > 0,let temp = Int(i),temp<255 && temp>=0,hasPreZero(str: i, value: temp) else {
                return result
            }
        }
        return "IPv4"
    } else if array.count == 8 {
        for i in array {
            guard i.count < 5 && i.count > 0,isVaildIPV6Str(str: i) else {
                return result
            }
        }
        return "IPv6"
    }
    return result
}
func isVaildIPV6Str(str:Substring)->Bool{
    for i in str {
        guard (i >= "0" && i <= "9")||(i >= "a" && i <= "f")||(i >= "A" && i <= "F") else {
            return false
        }
    }
    return true
}

func hasPreZero(str:Substring,value:Int)->Bool {
    guard value > 0 else {
        //等于0
        return str.count == 1
    }
    var nums = 0
    var values = value
    while values > 0 {
        nums += 1
        values /= 10
    }
    return str.count == nums
}

// 火柴拼正方形
func makesquare(_ matchsticks: [Int]) -> Bool {
    let sum = matchsticks.reduce(0) { partialResult, x in
        return partialResult + x
    }
    guard sum % 4 == 0 else {
        return false
    }
    var sorArr = matchsticks
    let avNum = sum/4
    quickSort(array: &sorArr, left: 0, right: sorArr.count - 1)
    guard sorArr[0] <= avNum else {
        return false
    }
    var edge = Array(repeating: 0, count: 4)
    let sss = dfsSort(edges: &edge, index: 0, sortArray: sorArr, length: avNum)
    return sss
}

func dfsSort(edges:inout [Int],index:Int,sortArray:[Int],length:Int)->Bool{
    if index == sortArray.count {
        return true
    }
    for i in 0..<edges.count {
        edges[i] += sortArray[index]
        if edges[i] <= length && dfsSort(edges: &edges, index: index+1, sortArray: sortArray, length: length) {
            return true
        }
        edges[i] -= sortArray[index]
    }
    return false
}


/*
 给定一个字符串 s，返回 s 中不同的非空「回文子序列」个数 。

 通过从 s 中删除 0 个或多个字符来获得子序列。

 如果一个字符序列与它反转后的字符序列一致，那么它是「回文字符序列」

 */
func countPalindromicSubsequences(_ s: String) -> Int {
    guard s.count > 1 else {
        return 1
    }
    let mod = 1000000007
    let count = s.count
    var num1 = Array(repeating: -1, count: 4)
    var pre = Array(repeating: num1, count: count)
    var next = Array(repeating: num1, count: count)
    let strArr:[Character] = Array(s)
    //预处理
    for i in 0..<count {
        for j in 0..<4 {
            pre[i][j] = num1[j]
        }
        num1[Int(UnicodeScalar(String(strArr[i]))!.value - UnicodeScalar("a").value)] = i
    }
    var i = count - 1
    num1 = Array(repeating: count, count: 4)
    while i >= 0 {
        for j in 0..<4 {
            next[i][j] = num1[j]
        }
        num1[Int(UnicodeScalar(String(strArr[i]))!.value - UnicodeScalar("a").value)] = i
        i -= 1
    }
    
    let num = Array(repeating: 0, count: count)
    var dp = Array(repeating: num, count: count)
    //初始化
    for i in 0..<count {
        dp[i][i] = 1
    }
    for len in 2...count {
        var i = 0
        while (i + len) <= count {
            let j = i + len - 1
            if strArr[i] == strArr[j] {
                let left = next[i][Int(UnicodeScalar(String(strArr[i]))!.value - UnicodeScalar("a").value)]
                let right = pre[j][Int(UnicodeScalar(String(strArr[i]))!.value - UnicodeScalar("a").value)]
                if left > right {
                    dp[i][j] = (dp[i+1][j-1] * 2 + 2)%mod
                } else if left == right {
                    dp[i][j] = (dp[i+1][j-1] * 2 + 1)%mod
                } else {
                    dp[i][j] = ((dp[i+1][j-1] * 2 - dp[left+1][right-1])%mod+mod)%mod
                }
            } else {
                dp[i][j] = ((dp[i+1][j] + dp[i][j-1] - dp[i+1][j-1])%mod + mod)%mod
            }
            i += 1
            
        }
    }
    
    return dp[0][count-1]
}

func minFlipsMonoIncr(_ s: String) -> Int {
    var num0 = [Int]()
    var num1 = [Int]()
    var lasSum0 = 0
    var lasSum1 = 0
    var lasChar = Character("0")
    for i in s {
        if i == "0" {
            lasSum0+=1
            if lasChar != i {
                num1.append(lasSum1)
            }
        } else {
            lasSum1+=1
            if lasChar != i {
                num0.append(lasSum0)
            }
        }
        lasChar = i
    }
    if lasChar == "0" {
        num0.append(lasSum0)
    } else {
        num1.append(lasSum1)
    }
    var mins = Int.max
    let max0 = num0[num0.count-1]
    for i in 0..<num0.count {
        let j = i - 1
        var chang0 = 0
        if j >= 0,j<num1.count {
            chang0 = num1[j]
        }
        let temp = max0 - num0[i] + chang0
        mins = min(temp,mins)
    }
    
    return mins
}

func findAndReplacePattern(_ words: [String], _ pattern: String) -> [String] {
    var repeatChar = [Int]()
    var changeChar = [Int]()
    var latChar = Character("&")
    var charMap = [Character:Int]()
    var repeate = 0
    //预处理
    for i in pattern {
        if latChar != i {
            var chang = charMap.count
            if let index = charMap[i] {
                chang = index
            } else {
                charMap[i] = chang
            }
            changeChar.append(chang)
            if repeate > 0 {
                repeatChar.append(repeate)
            }
            repeate = 0
        }
        repeate += 1
        latChar = i
    }
    repeatChar.append(repeate)
    guard repeatChar.count == changeChar.count else {
        return []
    }
    var result = [String]()
    let count = repeatChar.count
    for word in words {
        var charMap = [Character:Int]()
        var index = 0
        var latChar = Character("&")
        var repeatC = repeatChar[index]
        var char = changeChar[index]
        var repeate = 0
        for i in word {
            if latChar != i {
                var chang = charMap.count
                if let index = charMap[i] {
                    chang = index
                } else {
                    charMap[i] = chang
                }
                if chang != char {
                    break
                }
                index += 1
                if index < count {
                    char = changeChar[index]
                }
                if repeate > 0 {
                    if repeate != repeatC {
                        break
                    }
                    repeatC = repeatChar[index-1]
                }
                repeate = 0
            }
            repeate += 1
            latChar = i
        }
        if index == count,repeate == repeatC {
            result.append(word)
        }
        
    }
   return result
}


func defangIPaddr(_ address: String) -> String {
    var newStr = ""
    for str in address {
        newStr += str == "." ? "[.]" : String(str)
    }
    return newStr
}

func findSubstring12(_ s: String, _ words: [String]) -> [Int] {
    guard !s.isEmpty && !words.isEmpty else {
        return []
    }
    var count = 0
    for word in words {
        count += word.count
    }
    guard s.count > count else {
        return []
    }
    
    
    
    let sArray = Array(s)
    var array = [[Int:Int]]()
    for word in words {
        var nextArray = Array(repeating: 0, count: word.count)
        let needChars = Array(word)
        var tempMap = [Int:Int]()
        creatNextArray(needChars, &nextArray)
        var i=0,j = 0
        while i < needChars.count,j<sArray.count {

            if needChars[i] == sArray[j] {
                j += 1
                i += 1
            } else if nextArray[i] == -1 {
                j += 1
            } else {
                i = nextArray[i]
            }
            if i == word.count {
                //[j-1,j)
                tempMap[j-i] = j
                i = 0
            }
        }
        if tempMap.isEmpty {
            return []
        }
        array.append(tempMap)
    }
    guard array.count > 1 else {
        let arr = Array(array[0].keys)
        return arr
    }
    let temp = array[0]
    var result = [Int]()
    for map in temp {
        find(array: array, index: 1, left: map.key, right: map.value, length: count, result: &result)
    }
    return result
    
}

func find(array:[[Int:Int]],index:Int,left:Int,right:Int,length:Int,result:inout [Int]){
    guard index < array.count else {
        if right - left == length {
            result.append(left)
        }
        return
    }
    let temp = array[index]
    for map in temp {
        if map.key == right {
            find(array: array, index: index + 1, left: left, right: map.value, length: length, result: &result)
        }
        
        if map.value == left {
            find(array: array, index: index + 1, left: map.key, right: right, length: length, result: &result)
        }
    }
}

func sameStr(_ haystack: String, _ needle: String) -> Int {
    if needle.isEmpty {
        return 0
    }
        
    if haystack.isEmpty || needle.count > haystack.count{
        return -1
    }
    var nextArray = Array(repeating: 0, count: needle.count)
    let needChars = Array(needle)
    let hayStackArray = Array(haystack)
    creatNextArray(needChars, &nextArray)
    
    var i=0,j=0
    while i < needChars.count,j < hayStackArray.count {
        if needChars[i] == hayStackArray[j] {
            i += 1
            j += 1
        } else if nextArray[i] == -1 {
            j += 1
        } else {
            i = nextArray[i]
        }
    }
    if i == needChars.count {
        return j-i
    }
    return -1

}

func creatNextArray(_ needle:[Character],_ nextArray:inout [Int]) {
    var cn = 0
    var i = 2
    nextArray[0] = -1
    while i < needle.count {
        if needle[i-1] == needle[cn] {
            cn += 1
            nextArray[i] = cn
            i += 1
        } else if cn > 0 {
            cn  = nextArray[cn]
        } else {
            nextArray[i] = 0
            i += 1
        }
    }
}

// 30. 串联所有单词的子串
func findSubstring(_ s: String, _ words: [String]) -> [Int] {

        var dicts:[String:Int] = [:]
        for w in words {
            dicts[w, default:0] += 1
        }

        var result = [Int]()
        let singleLen = words[0].count
        let totalLen = words.count * singleLen
        let cArray = Array(s)

        for i in 0..<singleLen {
            var start = i
            while start + totalLen <= cArray.count {
                var mDicts = dicts
                var curLen = 0
                let end = start + totalLen
                while curLen < totalLen {
                    let str = String(cArray[end-curLen-singleLen..<end-curLen])
                    if let val = mDicts[str] {
                        if val > 0 {
                            curLen += singleLen
                            mDicts[str] = val - 1
                            continue
                        }
                    }
                    break
                }
                if curLen == totalLen {
                    result.append(start)
                    start += singleLen //如果符合直接移动一截
                } else {
                    start = end - curLen
                }
            }
        }
        return result
   }
func findLUSlength(_ strs: [String]) -> Int {
    var maxLength = -1
    for i in 0..<strs.count {
        var isLus = false
        for j in 0..<strs.count {
            if i == j {
                continue
            }
            if strs[i].count <= strs[j].count,isLusStr(strs[i], strs[j]) {
                isLus = true
                break
            }
        }
        if !isLus {
            maxLength = max(maxLength, strs[i].count)
        }
    }
    return maxLength
}

//str1子序列，str2目标字符串
func isLusStr(_ str1:String,_ str2:String)->Bool {
    guard str1.count < str2.count else {
        return str1 == str2
    }
    let strArr1 = Array(str1)
    let strArr2 = Array(str2)
    var i = 0,j = 0
    while i<strArr1.count,j<str2.count {
        if strArr1[i] == strArr2[j] {
            i += 1
            j += 1
        } else {
            j += 1
        }
    }
    return i == strArr1.count
}


func fractionAddition(_ expression: String) -> String {
    let charArr = Array(expression)
    var index = 0
    var num1 = (0,1)
    var lastIsNegative = 1
    while index < charArr.count {
        var temp = fractionNum(charArr, &index)
        let right1 = num1.1,temp1 = temp.1
        if right1 != temp1 {
            let numRight = right1 * temp1
            temp = (temp.0 * right1,numRight)
            num1 = (num1.0 * temp1,numRight)
            
        }
        num1 = (num1.0 + (lastIsNegative * temp.0),num1.1)
        if index < charArr.count {
            lastIsNegative = charArr[index] == "-" ? -1:1
        }
        index += 1
    }
    if num1.0 % num1.1 == 0 {
        num1 = (num1.0/num1.1,1)
    } else if num1.1 % num1.0 == 0 {
        num1 = (num1.0/abs(num1.0),num1.1/abs(num1.0))
    } else {
        var left = num1.0,right = num1.1
        let min1 = min(abs(left),right)
        var i = 2
        while i < min1,i < min(abs(left),right) {
            while left % i == 0,right % i == 0 {
                left  = left / i
                right = right / i
            }
            i+=1
        }
        num1 = (left,right)
    }
    return "\(num1.0)/\(num1.1)"
}

func fractionNum(_ expChar:[Character],_ index:inout Int)->(Int,Int){
   var isNegative = 1
    if expChar[index] == "-" {
        index += 1
        isNegative = -1
    }
    let left = numStr(expChar,&index)
    var right = 1
    if expChar[index] == "/" {
        index += 1
        right = numStr(expChar,&index)
    }
    return (isNegative * left,right)
}

func numStr(_ expChar:[Character],_ index:inout Int)->Int {
    var num = ""
    while index<expChar.count,CharacterSet.decimalDigits.contains(UnicodeScalar(String(expChar[index]))!){
        num += String(expChar[index])
        index += 1
    }
    return Int(num)!
}

//"x+5-3+x=6+x-2+3x+8+2"
//求解一个给定的方程，将x以字符串 "x=#value" 的形式返回。该方程仅包含 '+' ， '-' 操作，变量 x 和其对应系数。
func solveEquation(_ equation: String) -> String {
    let strArr = equation.split(separator: "=")
    let left = XandNumWithStr(strArr[0])
    let right = XandNumWithStr(strArr[1])
    let x = left.0 - right.0
    let y = right.1 - left.1
    
    if x == 0 ,y == 0{
        return "Infinite solutions"
    } else if x == 0 {
        return "No solution"
    }
    return "x=\(y / x)"
}

func XandNumWithStr(_ equation: Substring)->(Int,Int){
    let charArray = Array(equation)
    var left = 0
    var right = 0
    var index = 0
    while index < charArray.count {
        var negative = 1
        if charArray[index] == "-" {
            negative = -1
            index += 1
        } else if charArray[index] == "+" {
            index += 1
        }
        let num = numWithCharArr(charArray, &index)
        if index < charArray.count,charArray[index] == "x"{
            left += num * negative
            index += 1
        } else {
            right += num * negative
        }
    }
    return (left,right)
}

func numWithCharArr(_ charArray:[Character],_ index:inout Int) -> Int{
    guard index < charArray.count else {
        return 0
    }
    var str = ""
    
    while index < charArray.count,CharacterSet.decimalDigits.contains(UnicodeScalar(String(charArray[index]))!){
        str += String(charArray[index])
        index += 1
    }
    guard let num = Int(str) else {
        return (index < charArray.count) && (charArray[index] == "x") ? 1 : 0
    }
    return num
}

func reformat(_ s: String) -> String {
    let array = Array(s)
    var num = [Character]()
    var char = [Character]()
    for i in array {
        if CharacterSet.decimalDigits.contains(UnicodeScalar(String(i))!) {
            num.append(i)
        } else {
            char.append(i)
        }
    }
   
       
    if abs(num.count - char.count) <= 1 {
        let frist = num.count > char.count ? num:char
        let second = num.count <= char.count ? num:char
        var result = [Character]()
        for i in 0..<frist.count {
            result.append(frist[i])
            if i < second.count {
                result.append(second[i])
            }
        }
        return String(result)
    }
    return ""
}

func maxScore(_ s: String) -> Int {
    let charArr = Array(s)
    var zeroArr = [Int]()
    var oneArr = [Int]()
    var one = 0,zero = 0
    for char in charArr {
        if char == "1" {
            one += 1
        } else {
            zero += 1
        }
        zeroArr.append(zero)
        oneArr.append(one)
    }
    var result = max(zeroArr[0] + (one - oneArr[0]),zeroArr[oneArr.count-2] + (one - oneArr[oneArr.count-2]))
    for i in 1..<(oneArr.count-1) {
        result = max(result,zeroArr[i] + (one - oneArr[i]))
    }
    return result
}

//检查单词是否为句中其他单词的前缀
func isPrefixOfWord(_ sentence: String, _ searchWord: String) -> Int {
    let strArr = sentence.split(separator: " ")
    let serchWord = Array(searchWord)
    for (index,value) in strArr.enumerated() {
        if value.count < searchWord.count {continue}
        if isPreString(Array(value), serchWord) {
            return index + 1
        }
    }
    return -1
}

func isPreString(_ orign:[Character],_ pre:[Character])->Bool {
    for i in 0..<pre.count {
        if orign[i] != pre[i] {
            return false
        }
    }
    return true
}

//828. 统计子串中的唯一字符
func uniqueLetterString(_ s: String) -> Int {
    let chars = Array(s)
    let n = s.count
    var ans = 0
    var l = Array(repeating: 0, count: n)
    var r = Array(repeating: 0, count: n)
    var idex = Array(repeating: -1, count: 26)
    for i in 0..<n {
        let index = uniqueNum(chars[i])
        l[i] = idex[index]
        idex[index] = i
    }
    idex = Array(repeating: n, count: 26)
    for i in (0..<n).reversed() {
        let index = uniqueNum(chars[i])
        r[i] = idex[index]
        idex[index] = i
    }
    
    for i in 0..<n {
        ans += (i - l[i]) * (r[i] - i)
    }
    return ans
}


func uniqueNum(_ char:Character)->Int {
    
    return Int(UnicodeScalar(String(char))!.value - UnicodeScalar("A").value)
}

//1592. 重新排列单词间的空格
func reorderSpaces(_ text: String) -> String {
    func numSpace(_ num:Int)->String {
        var str = ""
        for _ in 0..<num {
            str += " "
        }
        return str
    }
    let charArr = Array(text)
    var spaceNum = 0
    let count = text.count
    var i = 0
    var strArr = [String]()
    while i < count {
        var tempArr = [Character]()
        while i < count,charArr[i] != " " {
            tempArr.append(charArr[i])
            i += 1
        }
        if i <  count {
            spaceNum += 1
            i += 1
        }
        if !tempArr.isEmpty {
            strArr.append(String(tempArr))
        }
    }
    if strArr.count == 1 {
        return "\(strArr[0])\(numSpace(spaceNum))"
    } else {
        let num = spaceNum / (strArr.count - 1)
        let last = spaceNum % (strArr.count - 1)
        return "\(strArr.joined(separator: numSpace(num)))\(numSpace(last))"
    }
    
}

func convertToTitle(_ columnNumber: Int) -> String {
    var num = columnNumber
    var str = ""
    let begin = Int(Unicode.Scalar("A").value)
    while num > 0 {
        num -= 1
        let num1 = num % 26
        num = num / 26
        str = String(Character(Unicode.Scalar(num1 + begin)!)) + str
    }
    
    return str
}

//171. Excel 表列序号
func titleToNumber(_ columnTitle: String) -> Int {
    let arr = Array(columnTitle)
    let begin = Int(Unicode.Scalar("A").value)
    var num = 0
    var nums = 1
    for i in (0..<arr.count).reversed() {
        let num2 = Int(Unicode.Scalar(String(arr[i]))!.value) - begin + 1
        num += num2 * nums
        nums *= 26
    }
    return num
}

//1598. 文件夹操作日志搜集器
func minOperations(_ logs: [String]) -> Int {
    var result = 0
    for log in logs {
        switch log {
        case "../":
            result -= 1
            result = result < 0 ?0:result
            break
        case "./":
            break
        default:
            result += 1
            break
        }
    }
    return result
}

//1624. 两个相同字符之间的最长子字符串
func maxLengthBetweenEqualCharacters(_ s: String) -> Int {
    let sArr = Array(s)
    var map = [Character:Int]()
    var maxT = -1
    for (i,v) in sArr.enumerated() {
        guard let j = map[v] else {
            map[v] = i
            continue
        }
        maxT = max(i-j-1,maxT)
        map[v] = i
    }
    return maxT
}


//854. 相似度为 K 的字符串
/*
 "adccee"
 "aeeccd"
 */
func kSimilarity(_ s1: String, _ s2: String) -> Int {
    let s2Arr = Array(s2)
    var queue = [s1:0]
    var visist = [s1]
    var step = 0
    let count = s1.count
    while !queue.isEmpty {
        let keys = queue.keys
        for key in keys {
            var post =  queue.removeValue(forKey: key)!
            if key == s2 {
                return step
            }
            let s1Arr = Array(key)
            while post < count,s2Arr[post] == s1Arr[post] {
                post += 1
            }
            if post + 1 < count{
                for i in (post + 1)..<count {
                    if s2Arr[i] == s1Arr[i] {
                        continue
                    }
                    if s1Arr[i] == s2Arr[post] {
                        
                        let s = swap(s1Arr, i: i, j: post)
                        if !visist.contains(s) {
                            visist.append(s)
                            queue[s] = post + 1
                        }
                        
                    }
                }
            }
        }
        step += 1
    }
    
    func swap(_ cur: [Character], i:Int, j:Int)->String {
            var char = cur
            let c = char[i]
            char[i] = char[j]
            char[j] = c
        return String(char)
    }
    return step
}

func calculate(_ s: String) -> Int {
    func numStr(_ expChar:[Character],_ index:inout Int)->Int {
        var num = ""
        while index<expChar.count,CharacterSet.whitespaces.contains(UnicodeScalar(String(expChar[index]))!){
            index += 1
        }
        while index<expChar.count,CharacterSet.decimalDigits.contains(UnicodeScalar(String(expChar[index]))!){
            num += String(expChar[index])
            index += 1
        }
        while index<expChar.count,CharacterSet.whitespaces.contains(UnicodeScalar(String(expChar[index]))!){
            index += 1
        }
        return Int(num) ?? 1
    }
    let char = Array(s)
    var index = 0
    var sum = numStr(char, &index)
    while index < char.count {
        switch char[index] {
        case "-":
            sum -= fractionNum(char, &index)
            break
        case "+":
             sum += fractionNum(char, &index)
            break
        case "*":
            index += 1
            sum *= numStr(char, &index)
            
        case "/":
            index += 1
            sum /= numStr(char, &index)
        default:
            break
        }
    }
    
    func fractionNum(_ expChar:[Character],_ index:inout Int)->Int{
        index += 1
        guard index < expChar.count else {
            return 0
        }
        var cur = numStr(expChar, &index)
        guard index < expChar.count else {
            return cur
        }
        while index < char.count {
            switch expChar[index] {
            case "-","+":
                return cur
            case "*":
                index += 1
                cur *= numStr(expChar, &index)
            case "/":
                index += 1
                 cur /= numStr(expChar, &index)
            default:
                return 0
            }
        }
        return cur
    }
    return sum
}

//01.02. 判定是否互为字符重排
func CheckPermutation(_ s1: String, _ s2: String) -> Bool {
    guard s1.count == s2.count else {
        return false
    }
    var charMap = [Character:Int]()
    let chars1 = Array(s1)
    let chars2 = Array(s2)
    for i in 0..<s1.count {
        let c1 = chars1[i],c2 = chars2[i]
        charMap[c1] = (charMap[c1] ?? 0) - 1
        charMap[c2] = (charMap[c2] ?? 0) + 1
    }
    for value in charMap.values where value != 0 {
        return false
    }
    return true
}

//面试题 01.09. 字符串轮转
func isFlipedString(_ s1: String, _ s2: String) -> Bool {
    guard s1.count == s2.count else {
        return false
    }
    guard s1 != s2 else {
        return true
    }
    let count = s1.count - 1
    let char1s = Array(s1),char2s = Array(s2)
    for i in 0..<count where char1s[0] == char2s[count - i] {
        let temps1 = String(char1s[0...i])
        let temps2 = String(char2s[(count - i)...count])
        let temps3 = String(char1s[(i+1)...count])
        let temps4 = String(char2s[0..<(count - i)])
        if temps1 == temps2,temps3 == temps4 {
            return true
        }
    }
    return false
}

//1694. 重新格式化电话号码
func reformatNumber(_ number: String) -> String {
    let str = number.replacingOccurrences(of: " ", with: "").replacingOccurrences(of: "-", with: "")
    let strArr = Array(str)
    var i = 3
    var strs = [String]()
    let cout = strArr.count % 3 == 0 ?strArr.count:(strArr.count - 2)
    while i <= cout {
        strs.append(String(strArr[(i-3)..<i]))
        i += 3
    }
    i -= 1
    while i <= strArr.count {
        strs.append(String(strArr[(i-2)..<i]))
        i += 2
    }
    return strs.joined(separator: "-")
}
//777. 在LR字符串中交换相邻字符,把L放左边，把R放右边
//"RXXLRXRXL"
//"XRLXXRRLX"
func canTransform(_ start: String, _ end: String) -> Bool {
    guard start.replacingOccurrences(of: "X", with: "") == end.replacingOccurrences(of: "X", with: "") else {
        return false
    }
    var i = 0
    var j = 0
    let sChars = Array(start)
    let eChars = Array(end)
    let count = sChars.count
    while i < count,j < count {
        while i < count,sChars[i] == "X" {
            i += 1
        }
        while j < count,eChars[j] == "X" {
            j += 1
        }
        if i < count,j < count {
            guard sChars[i] == eChars[j] else {
                return false
            }
            if sChars[i] == "L",i < j {
                return false
            } else if sChars[i] == "R",i > j {
                return false
            }
            i += 1
            j += 1
        }
    }
    while i < count  {
        guard sChars[i] == "X" else {
            return false
        }
        i += 1
    }
    while j < count  {
        guard eChars[j] == "X" else {
            return false
        }
        j += 1
    }
    return true
}

//使括号有效的最少添加
func minAddToMakeValid(_ s: String) -> Int {
    var left = 0,right = 0
    let sChars = Array(s)
    for s in sChars {
        if s == "(" {
            left += 1
        }
        
        if s == ")" {
            guard left > 0 else {
                right += 1
                continue
            }
            left -= 1
        }
    }
    return left + right
}

//811. 子域名访问计数
func subdomainVisits(_ cpdomains: [String]) -> [String] {
    var map = [Substring:Int]()
    for cpdomain in cpdomains {
        let temp = cpdomain.split(separator: " ")
        if let value = Int(temp.first ?? ""),let str = temp.last {
            let strArr = str.split(separator: ".")
            var tempStr = strArr[strArr.count - 1]
            map[tempStr] = (map[tempStr] ?? 0) + value
            map[str] = (map[str] ?? 0) + value
            for i in (1..<strArr.count-1).reversed() {
                tempStr = strArr[i] + "." + tempStr
                map[tempStr] = (map[tempStr] ?? 0) + value
            }
        }
    }
    var strArr = [String]()
    for (i,v) in map {
        strArr.append("\(v) \(i)")
    }
    return strArr
}


//856. 括号的分数
/*
 () 得 1 分。
 AB 得 A + B 分，其中 A 和 B 是平衡括号字符串。
 (A) 得 2 * A 分，其中 A 是平衡括号字符串。
 "(()(()))"
 */
func scoreOfParentheses(_ s: String) -> Int {
    guard s.count > 2 else {
        return 1
    }
    var bal = 0,n = s.count,len = 0
    let chars = Array(s)
    for i in 0..<n {
        bal += chars[i] == "(" ? 1:-1
        if bal == 0 {
            len = i + 1
            break
        }
    }
    if len == n {
        return 2 * scoreOfParentheses(String(chars[1..<(n-1)]))
    } else {
        return scoreOfParentheses(String(chars[0..<len])) + scoreOfParentheses(String(chars[len..<n]))
    }
}

//5. 最长回文子串
func longestPalindrome(_ s: String) -> String {
    var R = -1,C = -1//已经处理过的最大半径和中心
    var chars:[Character] = ["#"]
    for char in s {
        chars.append(char)
        chars.append("#")
    }
    var rArr = Array(repeating: 0, count: chars.count)
    var maxsIndex = 0
    for i in 0..<chars.count {
        let l = R > i ? min(rArr[2 * C - i], R-i):1//s已经处理过的长度
        var r = l
        while i - r >= 0,i + r < chars.count,chars[i-r] == chars[i + r] {
            r += 1
        }
        rArr[i] = r
        if i + r > R {
            R = i + r
            C = i
        }
        if rArr[maxsIndex] < r {
            maxsIndex = i
        }
        
    }
    var result = [Character]()
    let begin = maxsIndex - (rArr[maxsIndex] - 1),end = maxsIndex + (rArr[maxsIndex] - 1)
    
    for j in begin...end where chars[j] != "#"{
        result.append(chars[j])
    }
    return String(result)
}

// 仅执行一次字符串交换能否使两个字符串相等
func areAlmostEqual(_ s1: String, _ s2: String) -> Bool {
    guard s1 != s2 else {
        return true
    }
    var index1 = [Int]()
    let chars1 = Array(s1),chars2 = Array(s2)
    for i in 0..<chars1.count where chars1[i] != chars2[i]{
        index1.append(i)
    }
    guard index1.count == 2 else {
        return false
    }
    return chars1[index1[0]] == chars2[index1[1]] && chars1[index1[1]] == chars2[index1[0]]
}

//940. 不同的子序列 II
func distinctSubseqII(_ s: String) -> Int {
    let mode = 1000000007
    var map = [Character:Int]()
    var f = Array(repeating: 1, count: s.count)
    for (i,char) in s.enumerated() {
        for j in map.values{
            f[i] = (f[i] + f[j]) % mode
        }
        map[char] = i
    }
    return map.values.reduce(0) { partialResult, i in
        return (partialResult + f[i]) % mode
    }
}

//541. 反转字符串 II
func reverseStr(_ s: String, _ k: Int) -> String {
    var chars = Array(s),i = 0
    let count = chars.count
    while i < count {
        let rig = (i + k > count) ? count:(i+k)
        reverseStr(&chars, i, rig-1)
        i += 2 * k
    }
    
    func reverseStr(_ chars:inout [Character],_ left:Int,_ right:Int) {
        guard left < right,left >= 0,right < chars.count else {
            return
        }
        var i = 0
        while left + i < right - i {
            let temp = chars[left + i]
            chars[left + i] = chars[right - i]
            chars[right - i] = temp
            i += 1
        }
    }
    return String(chars)
}

//902. 最大为 N 的数字组合
func atMostNGivenDigitSet(_ digits: [String], _ n: Int) -> Int {
    let count = digits.count
    let numDig = digits.map { num in
        return Int(num) ?? 0
    }
    //只接受200000,30,之类的，
    func digitNum(_ digis:[Int],_ n:Int)->Int {
        guard n > 10 else {
            return digis.reduce(0) { partialResult, i in
                partialResult + (i>n ? 0:1)
            }
        }
        var num = n,sum = 0,chang = 1
        while num >= 10 {
            chang = chang * count
            sum += chang
            num /= 10
        }
        if num > 1 {
            let temp = digis.reduce(0) { partialResult, i in
                partialResult + (i>=num ? 0:1)
            }
            sum += temp * chang
        }
        return sum
    }
    
    //和n同长度的书
    func digitNum2(_ digis:[Int],_ n:Int,_ pow:Int) ->Int {
        guard pow > 0 else {
            return digis.reduce(0) { partialResult, i in
                partialResult + (i>n ? 0:1)
            }
        }
        let temp = numDig.reduce(0) { partialResult, i in
            partialResult + (i>=n ? 0:1)
        }
        return temp * Int(powl(Float80(digis.count), Float80(pow)))
    }
    let nStr = String(n),maxLeng = nStr.count - 1
    var sum = 0
    for (i,char) in nStr.enumerated() {
        guard let numN = Int(String(char)) else {
            continue
        }
        if i == 0 {
            let temp = numN * Int(powl(10, Float80(maxLeng - i)))
            sum += digitNum(numDig, temp)
        } else if numN >= numDig[0]{
            sum += digitNum2(numDig, numN, maxLeng - i)
        } else {
            break
        }
        if !numDig.contains(numN) {
            break
        }
        
    }
    return sum
}

func atMostNGivenDigitSet2(_ digits: [String], _ n: Int) -> Int {
    let count = digits.count,nStr = Array(String(n)),maxLeng = nStr.count
    var dp = Array(repeating: [0,0], count: maxLeng + 1)
    dp[0][1] = 1
    for i in 1...maxLeng {
        for j in 0..<count {
            if digits[j] == String(nStr[i-1]) {
                dp[i][1] = dp[i-1][1]
            } else if digits[j] < String(nStr[i-1]) {
                dp[i][0] += dp[i-1][1]
            } else {
                break
            }
        }
        if i > 1 {
            dp[i][0] += count + dp[i - 1][0] * count
        }
    }
    return dp[maxLeng][0] + dp[maxLeng][1]
}

//1768. 交替合并字符串
func mergeAlternately(_ word1: String, _ word2: String) -> String {
    let chars1 = Array(word1),chars2 = Array(word2),count = min(chars1.count, chars2.count)
    var chars = [Character]()
    chars.reserveCapacity(2 * count)
    for i in 0..<count {
        chars.append(chars1[i])
        chars.append(chars2[i])
    }
    if count < chars1.count {
        return String(chars) + String(chars1[count..<chars1.count])
    }
    
    if count < chars2.count {
        return String(chars) + String(chars2[count..<chars2.count])
    }
    return String(chars)
}

//判断子序列
func isSubsequence(_ s: String, _ t: String) -> Bool {
    let count = s.count
    guard s.count > 0 else {
        return true
    }
    let chars = Array(s)
    var i = 0
    for j in t where i<count && chars[i] == j {
        i += 1
    }
    return i == s.count
}

//290. 单词规律
func wordPattern(_ pattern: String, _ s: String) -> Bool {
    let strArr = s.split(separator: " ")
    guard strArr.count == pattern.count else {
        return false
    }
    var map = [String:Int]()
    var map1 = [Character:Int]()
    var index = 0
    for (i,pa) in pattern.enumerated() {
        let str2 = String(strArr[i])
        guard let z = map1[pa],let j = map[str2] else {
            guard map1[pa] == nil,map[str2] == nil else {
                return false
            }
            map1[pa] = index
            map[str2] = index
            index += 1
            continue
        }
        guard z != j else {
            continue
        }
        return false
    }
    return true
}

func magicalString(_ n: Int) -> Int {
    
    var arr = [1,2,2]
    var index = 2
    var sum = 1
    while arr.count < n {
        let num = arr.last! == 1 ? 2:1
        if num == 1 {
            sum += num * arr[index]
            if arr.count == n + 1 {
                sum -= 1
            }
        }
        arr.append(num)
        if arr[index] == 2 {
            arr.append(num)
        }
        index += 1
    }
    return sum
}

