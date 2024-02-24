//
//  heap_1.swift
//  leetCode
//
//  Created by 陈晶泊 on 2022/12/20.
//

import Foundation
func heapSort(nums: inout [Int]){
    var count = nums.count-1
    for i in 0...count {
        heapInsert(nums: &nums, begin: i)
    }
    while count > 0 {
        sawp(nums: &nums, i: 0, j: count)
        count = count - 1
        heapFind(nums: &nums, begin: 0, heapSize: count)
    }
    
    func heapFind(nums: inout [Int],begin: Int,heapSize: Int){
        var index = begin
        var left = 2 * index + 1
        while left < heapSize {
            let lagerest = ((left + 1) < heapSize) && (nums[left + 1] > nums[left]) ? left+1 : left
            let sawpIndex =  nums[lagerest] > nums[index] ? lagerest : index;
            guard sawpIndex != index else {
                break
            }
            sawp(nums: &nums, i: sawpIndex, j: index)
            index = lagerest
            left = 2 * index + 1
        }
    }
    
    func heapInsert(nums: inout [Int],begin: Int){
        var index = begin
        while nums[index] > nums[(index - 1) / 2] {
            sawp(nums: &nums, i: index, j: (index - 1) / 2)
            index = (index - 1) / 2
        }
    }
    
    
    func sawp( nums: inout [Int],i: Int,j: Int) {
        if i != j {
            nums[i] ^= nums[j]
            nums[j] ^= nums[i]
            nums[i] ^= nums[j]
        }
    }
}

//1760. 袋子里最少数目的球
/**
 给你一个整数数组 nums ，其中 nums[i] 表示第 i 个袋子里球的数目。同时给你一个整数 maxOperations 。

 你可以进行如下操作至多 maxOperations 次：

 选择任意一个袋子，并将袋子里的球分到 2 个新的袋子中，每个袋子里都有 正整数 个球。
 比方说，一个袋子里有 5 个球，你可以把它们分到两个新袋子里，分别有 1 个和 4 个球，或者分别有 2 个和 3 个球。
 你的开销是单个袋子里球数目的 最大值 ，你想要 最小化 开销。

 请你返回进行上述操作后的最小开销。
 */
func minimumSize(_ nums: [Int], _ maxOperations: Int) -> Int {
    var left = 1,right = nums.max()!,mid = (left + right) / 2
    while left <= right {
        var ops = 0
        for num in nums {
            //不需要分的减1，则不会加
            ops += (num - 1) / mid
        }
        if ops <= maxOperations {
            right = mid
        } else {
            left = mid + 1
        }
        mid = (left + right) / 2
    }
    return right
}

