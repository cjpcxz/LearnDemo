//
//  day_3.swift
//  leetCode
//
//  Created by 陈晶泊 on 2022/3/15.
//

import Foundation
func longestCommonPrefix(_ strs: [String]) -> String {
    guard strs.count > 0 else {
        return ""
    }
    
    return findLongestCommonPrefix(strs, 0, strs.count-1)
}

func findLongestCommonPrefix(_ strs: [String],_ start: Int,_ end: Int) -> String {
    if start >= end {
        return strs[start]
    }
    let mid = (start + end)/2
    let str1 = findLongestCommonPrefix(strs, start, mid)
    let str2 = findLongestCommonPrefix(strs, mid+1, end)
    return commonPrefix(Array(str1), Array(str2))
}

func commonPrefix(_ str1Arr: [Character],_ str2Arr: [Character]) -> String {
    let count = min(str1Arr.count, str2Arr.count)
    for i in 0..<count {
        if str1Arr[i] != str2Arr[i] {
            return String(str1Arr[0..<i])
        }
        
    }
    return  String(str1Arr[0..<count])
}

private class BaseCell: TCLShortcutsListItemStyle {
    var imageUrl: String {
        return ""
    }
    
    var title: String {
        return "BaseCell --- "
    }
    
    var subTitle: String {
        return "客厅"
    }
}

func testdsss() {
    let cell = BaseCell() // 0x00000001001ff6c0
    print("-----celll",cell)
}
