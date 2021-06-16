//
//  database.swift
//  animation practice
//
//  Created by 恭弘 on 2017/03/03.
//  Copyright © 2017年 恭弘. All rights reserved.
//

import Foundation

class DatabaseClass {
    var table : String {
        
        get{
            let paths = NSSearchPathForDirectoriesInDomains(
                .documentDirectory,
                .userDomainMask, true)
            let path = paths[0].stringByAppendingPathComponent(path: "sample.db")
            return path
        }
        
    }
    
    // 通常のメッセージを保存するデータベース
    var table2 : String {
        
        get{
            let paths = NSSearchPathForDirectoriesInDomains(
                .documentDirectory,
                .userDomainMask, true)
            let path = paths[0].stringByAppendingPathComponent(path: "sample2.db")
            return path
        }
    }
    
    // 重要なメッセージを保存するデータベース
    var table3 : String {
        
        get{
            let paths = NSSearchPathForDirectoriesInDomains(
                .documentDirectory,
                .userDomainMask, true)
            let path = paths[0].stringByAppendingPathComponent(path: "sample3.db")
            return path
        }
    }
 
}
