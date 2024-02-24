//
//  day_sort.swift
//  leetCode
//
//  Created by 陈晶泊 on 2022/4/17.
//

import Foundation
//88. 合并两个有序数组

func merge(_ nums1: inout [Int], _ m: Int, _ nums2: [Int], _ n: Int) {
    guard m > 0, n > 0 else {
        if n > 0 {
            for i in 0..<n {
                nums1[i] = nums2[i]
            }
        }
        return
    }
    var mIndex = m-1,nIndex = n-1
    var numIndex = nums1.count - 1
    while mIndex >= 0,nIndex >= 0 {
        if nums1[mIndex] < nums2[nIndex] {
            nums1[numIndex] = nums2[nIndex]
            nIndex -= 1
        } else {
            nums1[numIndex] = nums1[mIndex]
            mIndex -= 1
        }
        numIndex -= 1
    }
    if numIndex >= 0 {
        if mIndex < 0 {
            while numIndex >= 0,nIndex >= 0 {
                nums1[numIndex] = nums2[nIndex]
                nIndex -= 1
                numIndex -= 1
            }
        }
    }
    
}



func heightChecker(_ heights: [Int]) -> Int {
    let sortArray = heights.sorted()
    var sum = 0
    for i in 0..<heights.count {
        if heights[i] != sortArray[i] {
            sum += 1
        }
    }
    return sum
}

func quickSort(array: inout [Int],left:Int,right:Int) {
    guard left < right else {
        return
    }
    var less = left-1,more = right + 1,leftIndex = left
    let temp = array[left]
    while leftIndex < more {
        if array[leftIndex] < temp {
            less += 1
            swap(array: &array, i: less, j: leftIndex)
            leftIndex += 1
        } else if array[leftIndex] > temp {
            more -= 1
            swap(array: &array, i: more, j: leftIndex)
        } else {
            leftIndex += 1
        }
    }
    quickSort(array: &array, left: left, right: less)
    quickSort(array: &array, left: more, right: right)
}

func swap(array:inout [Int],i:Int,j:Int){
    let temp =  array[i]
    array[i] = array[j]
    array[j] = temp
    //不相等，才能这样交互，不然有相等的，交换后会为0
//    array[i] ^= array[j]
//    array[j] ^= array[i]
//    array[i] ^= array[j]
}

func maxChunksToSorted(_ arr: [Int]) -> Int {
    var sortArr = arr
    quickSort2(array: &sortArr, left: 0, right: arr.count-1)
    var map = [Int:[Int]]()
    for (index,value) in sortArr.enumerated() {
        map[value] = (map[value] ?? []) + [index]
    }
    var minRight = 0
    var result = 0
    for (i,j) in arr.enumerated() {
        let index = map[j]!.removeFirst()
        minRight = max(minRight,index)
        if minRight == i {
            result += 1
        }
        
    }
    return result
    
}

func quickSort2(array: inout [Int],left:Int,right:Int) {
    guard left < right else {
        return
    }
    var less = left - 1,more = right + 1,i = left
    let temp = array[left]
    while i < more {
        if array[i] < temp {
            less += 1
            swap(array: &array, i: less, j: i)
            i+=1
        } else if array[i] == temp {
            i += 1
        } else {
            more -= 1
            swap(array: &array, i: more, j: i)
        }
    }
    quickSort2(array: &array, left: left, right: less)
    quickSort2(array: &array, left: more, right: right)
}


