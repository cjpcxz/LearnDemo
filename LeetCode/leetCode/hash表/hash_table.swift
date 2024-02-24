//
//  hash_table.swift
//  leetCode
//
//  Created by 陈晶泊 on 2022/8/18.
//

import Foundation
//1224. 最大相等频率
func maxEqualFreq(_ nums: [Int]) -> Int {
    var freq = [Int:Int]()//出现次数的数量
    var count = [Int:Int]()//该数出现的次数
    var res  = 0,maxFreq = 0
    for (i,v) in nums.enumerated() {
        if let times = count[v],let fre = freq[times],fre > 0 {
            freq[times] = fre - 1
        }
        let temp = (count[v] ?? 0) + 1
        count[v] = temp
        freq[temp] = (freq[temp] ?? 0) + 1
        maxFreq = max(temp,maxFreq)
       
        if maxFreq == 1 || (((freq[maxFreq] ?? 0) * maxFreq + (freq[maxFreq - 1] ?? 0) * (maxFreq - 1) == i + 1) && freq[maxFreq] == 1) || (((freq[maxFreq] ?? 0) * maxFreq + 1 == i + 1)&&(freq[1] ?? 0)==1){
            res = max(res,i+1)
        }
    }
    return res
}
