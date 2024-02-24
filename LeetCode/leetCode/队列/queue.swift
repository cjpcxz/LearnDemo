//
//  queue.swift
//  leetCode
//
//  Created by 陈晶泊 on 2022/9/30.
//

import Foundation
//225. 用队列实现栈请你仅使用两个队列实现一个后入先出（LIFO）的栈，并支持普通栈的全部四种操作（push、top、pop 和 empty）
class MyStack {
    var arr1 = [Int]()
    var arr2 = [Int]()
    init() {

    }
    
    func push(_ x: Int) {
        arr2.append(x)
        while !arr1.isEmpty {
            arr2.append(arr1.removeFirst())
        }
        let temp = arr1
        arr1 = arr2
        arr2 = temp
    }
    
    func pop() -> Int {
        return arr1.removeFirst()
    }
    
    func top() -> Int {
        return arr1.first ?? 0
    }
    
    func empty() -> Bool {
        return arr1.isEmpty
    }
}

