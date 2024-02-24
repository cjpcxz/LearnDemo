//
//  day_图结构.swift
//  leetCode
//
//  Created by 陈晶泊 on 2022/5/31.
//

import Foundation
///剑指 Offer II 114. 外星文字典
var nodes = [Character:[Character]]()
var isVaild = true
var states = [Character:Int]()
var char = ""
func alienOrder(_ words: [String]) -> String {
    
    for str in words {
        for i in str {
            //初始化
            nodes[i] = []
        }
    }
    //初始化每个点的指向
    for i in 1..<words.count {
        addNode(before: words[i-1], after: words[i])
    }
    
    for key in nodes.keys {
        if !states.keys.contains(key) {
            dfs(key: key)
        }
    }
    
    if !isVaild {
        return ""
    }
    
    return char
}

func dfs(key:Character){
    states[key] = 1
    for i in nodes[key]! {
        if !states.keys.contains(i){
            dfs(key: i)
        } else if (states[i] == 1) {
            isVaild = false
            return
        }
    }
    states[key] = 2
    char.insert(key, at: char.startIndex)
}

func addNode(before:String,after:String){
    let length1 = before.count
    let length2 = after.count
    let minLength = min(length1, length2)
    var i = 0
    while i < minLength {
       let v1 = chatAt(str: before, index: i)
        let v2 = chatAt(str: after, index: i)
        if v1 != v2{
            nodes[v1] = nodes[v1]! + [v2]
            break
        }
        i += 1
    }
    if i == minLength && length1 > length2 {
        isVaild = false
    }
}

func chatAt(str:String,index:Int)->Character {
    return str[str.index(str.startIndex, offsetBy: index)]
}

