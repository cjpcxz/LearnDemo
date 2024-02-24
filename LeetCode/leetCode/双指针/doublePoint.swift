//
//  doublePoint.swift
//  leetCode
//
//  Created by 陈晶泊 on 2022/10/19.
//

import Foundation

func countStudents(_ students: [Int], _ sandwiches: [Int]) -> Int {
    let count = students.count
    var stud1 = 0,sand1 = 0
    for i in 0..<count {
        stud1 += students[i]
        sand1 += sandwiches[i]
    }
    guard stud1 != sand1 else {
        return 0
    }
    let tag = stud1 < sand1 ? 1:0
    var tagValue = stud1 < sand1 ? stud1:(count-stud1)
    for i in 0..<count where sandwiches[i] == tag {
        if tagValue == 0 {
            return count - i
        }
        tagValue -= 1
    }
    return 0
}

// 范围求和 II
func maxCount(_ m: Int, _ n: Int, _ ops: [[Int]]) -> Int {
    var minX = m,minY = n
    for op in ops {
        minX = min(op[0],minX)
        minY = min(op[1],minY)
    }
    return minY * minX
}


func kthGrammar(_ n: Int, _ k: Int) -> Int {
    guard k > 1 else {
        return 0
    }
    guard k > (1 << (n - 2)) else {
        return kthGrammar(n - 1, k)
    }
    return kthGrammar(n - 1, k - (1 << (n - 2)))
}


func swapPairs(_ head: ListNode?) -> ListNode? {
    let node:ListNode? = ListNode(0)
    node?.next = head
    var next = node
    while let cur = next?.next?.next {
        let temp = next?.next
        temp?.next = cur.next
        cur.next = temp
        next?.next = cur
        next = temp
    }
    return node?.next
}
