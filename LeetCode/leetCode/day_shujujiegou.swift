//
//  day_shujujiegou.swift
//  leetCode
//
//  Created by 陈晶泊 on 2022/8/15.
//

import Foundation
class MyCircularDeque {
    private var left:Int,right:Int
    private var qeueArr:[Int]
    init(_ k: Int) {
        qeueArr = Array(repeating: 0, count: k)
        left = -1
        right = k
    }
    
    func insertFront(_ value: Int) -> Bool {
        let index = left + 1
        guard index < right else {
            return false
        }
        qeueArr[index] = value
        left = index
        return true
        
    }
    
    func insertLast(_ value: Int) -> Bool {
        let index = right - 1
        guard left < index else {
            return false
        }
        qeueArr[index] = value
        right = index
        return true
    }
    
    func deleteFront() -> Bool {
        guard !isEmpty() else {
            return false
        }
        if left > -1 {
            left -= 1
        } else {
            for i in (right..<qeueArr.count).reversed() {
                qeueArr[i] = qeueArr[i-1]
            }
            right += 1
        }
        
        return true
    }
    
    func deleteLast() -> Bool {
        guard !isEmpty() else {
            return false
        }
        if right < qeueArr.count {
            right += 1
        } else {
            
            for i in 0..<left {
                qeueArr[i] = qeueArr[i+1]
            }
            left -= 1
        }
        return true
    }
    
    func getFront() -> Int {
        guard !isEmpty() else {
            return -1
        }
        if left > -1 {
            return qeueArr[left]
        } else {
            return qeueArr[qeueArr.count - 1]
        }
        
    }
    
    func getRear() -> Int {
        guard !isEmpty() else {
            return -1
        }
        if right < qeueArr.count {
            return qeueArr[right]
        } else {
            return qeueArr[0]
        }
    }
    
    func isEmpty() -> Bool {
        return (right - left) == (qeueArr.count + 1)
    }
    
    func isFull() -> Bool {
        return (right - left) == 1
    }
}

//设计有序流
class OrderedStream {
    var streamArr:[String]
    var ptr:Int
    init(_ n: Int) {
        streamArr = Array(repeating: "", count: n + 1)
        ptr = 1
    }
    
    func insert(_ idKey: Int, _ value: String) -> [String] {
        guard idKey < streamArr.count else {
            return []
        }
        streamArr[idKey] = value
        guard ptr == idKey else {
            return []
        }
        var result = [String]()
        while ptr < streamArr.count {
            if streamArr[ptr] == "" {
                break
            }
            result.append(streamArr[ptr])
            ptr += 1
        }
        return result
    }
}
