//
//  day_1.swift
//  leetCode
//
//  Created by 陈晶泊 on 2022/3/13.
//

import Foundation
func myAtoi(_ s: String) -> Int {
    if s.isEmpty {
        return 0
    }
    let characterArr = s.utf8CString
    let limitArr = " +-09".utf8CString;
    var num = 0
    var i = 0
    var isPosit = 1
    while limitArr[0] == characterArr[i] {
        i+=1
    }
    if limitArr[1] == characterArr[i] || limitArr[2] == characterArr[i] {
        isPosit = limitArr[1] == characterArr[i] ? 1 : -1
        i+=1
    }
    
    for index in i..<characterArr.count {
        guard characterArr[index] >= limitArr[3] && characterArr[index] <= limitArr[4] else {
            break
        }
        let nuChar = characterArr[index] - limitArr[3]
        guard num < (Int32.max/10) || (num == (Int32.max/10)&&(Int(nuChar) <= (isPosit == 1 ? 7:8))) else {
            return Int(isPosit == 1 ? Int32.max:Int32.min)
        }
        num = num * 10 + Int(nuChar)
    }
    return num * isPosit;
}

func strStr(_ haystack: String, _ needle: String) -> Int {
    if needle.isEmpty {
        return 0
    }
        
    if haystack.isEmpty || needle.count > haystack.count{
        return -1
    }
    
    var nextArr:[Int] = Array(repeating: 0, count: needle.count)
    let needleArr = Array(needle)
    let hayArr = Array(haystack)
    getNextArray(needleArr, nextArr: &nextArr)
//    creatNextArray(needleArr, &nextArr)
    var i = 0,j = 0
    while i<needleArr.count,j<hayArr.count {
        if needleArr[i] == hayArr[j] {
            i += 1
            j += 1
        } else if nextArr[i] == -1 {
            j += 1
        } else {
            i = nextArr[i]
        }
    }
    
    if i == needle.count {
        return j-i
    }
    return -1
}

func getNextArray (_ masArray: [Character], nextArr: inout Array<Int>) {
    nextArr[0] = -1
    var i = 2
    var cn = 0
    while i < nextArr.count {
        if masArray[i-1] == masArray[cn] {
            cn += 1
            nextArr[i] = cn
            i+=1
        } else if (cn > 0) {
            cn = nextArr[cn]
        } else {
            nextArr[i] = 0
            i+=1
        }
    }
    
}


// kmp算法
func strStr1(_ haystack: String, _ needle: String) -> Int {
    let hayStackArr = Array(haystack),needleArr = Array(needle)
    var nextArr = Array(repeating: 0, count: needle.count)
    func creatNextArray() {
        nextArr[0] = -1
        var i = 2,cn = 0
        // 前缀相等的长度
        while i < needleArr.count {
            if needleArr[i-1] == needleArr[cn] {
                cn += 1
                nextArr[i] = cn
                i += 1
            } else if cn > 0 {
                cn = nextArr[cn]
            } else {
                i += 1
            }
        }
    }
    
    var i = 0,j = 0
    creatNextArray()
    while i < hayStackArr.count,j < needleArr.count {
        if hayStackArr[i] == needleArr[j] {
            i += 1
            j += 1
        } else if nextArr[j] != -1 {
            j = nextArr[j]
        } else {
            i += 1
        }
    }
    if j == needle.count {
        return i-j
    }
    return -1
}
