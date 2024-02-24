//
//  LGTeacher.swift
//  leetCode
//
//  Created by 陈晶泊 on 2023/2/11.
//

import Foundation
class LGTeacher {
    @objc var age:Int = 18
    
    @objc func teach() {
        print("teach")
    }
    
    @objc func test1() {
        print("test1")
    }
}

func test() {
    var methodCount: UInt32 = 0
    let methodList = class_copyMethodList(LGTeacher.self, &methodCount)
    for i in 0..<numericCast(methodCount) {
        if let method = methodList?[i] {
            let methodName = method_getName(method)
            print("方法列表:\(methodName)")
        } else {
            print("not found method")
        }
    }
   
    if  let  method1 = class_getInstanceMethod(LGTeacher.self, NSSelectorFromString("test1")),
        let  method2 = class_getInstanceMethod(LGTeacher.self, NSSelectorFromString("teach")) {
        method_exchangeImplementations(method1, method2)
    }
    
    var count:UInt32 = 0
    let proList = class_copyPropertyList(LGTeacher.self, &count)
    for  i in 0..<numericCast(count) {
        if let proerty = proList?[i] {
            let proertyName = property_getName(proerty)
            print("成员属性：\(proertyName)")
        } else {
            print("not found property")
        }
    }
}


