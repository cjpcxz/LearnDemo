//
//  day_2.swift
//  leetCode
//
//  Created by 陈晶泊 on 2022/3/14.
//

import Foundation

func countAndSay(_ n: Int) -> String {
    guard n > 1 else {
        return "1"
    }
    var resultStr = "1"
    for _ in 2...n {
        resultStr = nextStr(Array(resultStr))
    }
    return resultStr
}

func nextStr(_ strs: [Character]) -> String {
    var resultStr = ""
    var i = 0
    while i<strs.count {
        var count = 1
        let currentStr = strs[i]
        i+=1
        while i<strs.count && strs[i] == currentStr {
            count+=1
            i+=1
        }
        resultStr += String(count) + String(currentStr)
    }
    return resultStr
}
protocol TCLShortcutsListItemStyle {
    var imageUrl:String { get }
    var title: String { get }
    var subTitle: String { get }
}
extension TCLShortcutsListItemStyle {
    var subTitle: String {
        return ""
    }
}

private class BaseCell: TCLShortcutsListItemStyle {
    var imageUrl: String {
        return ""
    }
    
    var title: String {
        return "ddsaaaaaaaa"
    }
    
    var subTitle: String {
        return "客厅"
    }
}
func testdsss2() {
    let cell = BaseCell() // 0x0000000100200168
    print("-----celll",cell)
}
