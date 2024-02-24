//
//  mainText.swift
//  leetCode
//
//  Created by 陈晶泊 on 2023/7/17.
//
/**
 43. 字符串相乘
 给定两个以字符串形式表示的非负整数 num1 和 num2，返回 num1 和 num2 的乘积，它们的乘积也表示为字符串形式。

 注意：不能使用任何内置的 BigInteger 库或直接将输入转换为整数。
两数相乘最大长度m+n,最小长度m+n-1
 */
func multiply(_ num1: String, _ num2: String) -> String {
    if num1 == "0" || num2 == "0" {
        return "0"
    }
    let num1Arr = Array(num1),num2Arr = Array(num2)
    let m = num1.count,n = num2.count
    var arr = Array(repeating: 0, count: m+n)
    for i in (0..<m).reversed() {
        let x = Int(String(num1Arr[i]))!
        for j in (0..<n).reversed() {
            let y = Int(String(num2Arr[j]))!
            arr[i+j+1] += x * y
        }
    }
    for i in (1..<arr.count).reversed() {
        arr[i-1] = arr[i-1] + arr[i] / 10
        arr[i] %= 10
    }
    var index = arr[0] == 0 ? 1:0,res = ""
    for i in index..<arr.count {
        res += "\(arr[i])"
    }
    return res
}


