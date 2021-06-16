//
//  AppDelegate.swift
//  聴覚支援学校
//
//  Created by 清水直輝 on 2017/03/12.
//  Copyright © 2017年 清水直輝. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    var backgroundTaskID : UIBackgroundTaskIdentifier = 0
    
    // バックグラウンドかアクテッブかを判断する変数
    var backHome : Bool!
    
    var navigationText : String = ""
    
    var classMuch : Int = 0
    
    var className : UIViewController!
    
    var message : String!
    
    var receveMessage : String!
    
    var connectBool : Bool!
    
    // 先生と繋ぐためのserviceType変数
    var serviceTyper : String = "teacher"
    // 生徒と繋ぐためのserviceType変数
    var serviceType : String = "student"
    
    var connectFirst : Bool = true
    
    // 通常画面にいるのか、重要画面にいるのか、または生徒画面のままでいるのかを判別するための変数
    var stuTextAN : Bool? = nil
    
    // テーブルを作成する関数
    func createTable(){
        
        // DatabaseClassのtableに書いてる
        let db = FMDatabase(path: DatabaseClass().table)
        
        let db2 = FMDatabase(path: DatabaseClass().table2)
        let db3 = FMDatabase(path: DatabaseClass().table3)
 
        let sql = "CREATE TABLE IF NOT EXISTS sample (user_id INTEGER PRIMARY KEY, name TEXT);"
        
        let sql2 = "CREATE TABLE IF NOT EXISTS sample2 (user_id INTEGER PRIMARY KEY, name TEXT);"
        let sql3 = "CREATE TABLE IF NOT EXISTS sample3 (user_id INTEGER PRIMARY KEY, name TEXT);"
        
        db?.open()
        
        db2?.open()
        db3?.open()
        
        // SQL文を実行
        let ret = db?.executeUpdate(sql, withArgumentsIn: nil)
        
        let ret2 = db2?.executeUpdate(sql2, withArgumentsIn: nil)
        let ret3 = db3?.executeUpdate(sql3, withArgumentsIn: nil)
        
        if ret! {
            print("テーブル1の作成に成功")
        } else {
            print("テーブル1作成に失敗")
        }
        
        if ret2! {
            print("テーブル2の作成に成功")
        } else {
            print("テーブル2作成に失敗")
        }
        
        if ret3! {
            print("テーブル3の作成に成功")
        } else {
            print("テーブル3作成に失敗")
        }
 
        
        db?.close()
        
        db2?.close()
        db3?.close()
 
    }
    
    
    // アプリ起動時に呼ばれる
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        
        createTable()
        
        /* 初期化処理 */
        let first = UserDefaults.standard
        let def = ["firstLaunch": true]
        let deside = ["deside" : true]
        first.register(defaults: def)
        first.register(defaults: deside)
        
        
        // はじめはtrue
        backHome = true
        
        connectBool = false
        
        
        return true
    }
    
    
    
    // アプリがバックグラウンドになる直前に呼ばれる
    func applicationWillResignActive(_ application: UIApplication) {
        
        
        self.backgroundTaskID = application.beginBackgroundTask(expirationHandler:{
            [weak self] in
            application.endBackgroundTask((self?.backgroundTaskID)!)
            self?.backgroundTaskID = UIBackgroundTaskInvalid
        })
    }
    
    
    // アプリがバックグラウンドになった時に呼ばれる
    func applicationDidEnterBackground(_ application: UIApplication) {
        
        print("バックグラウンド")
        
        // バックグラウンドになった時はfalse
        backHome = false
    }
    
    // アプリがフォアグラウンドになった時に呼ばれる
    func applicationWillEnterForeground(_ application: UIApplication) {
        
        print("フォアグラウンド")
    }
    
    
    // アプリがアクティブになった時に呼ばれる
    func applicationDidBecomeActive(_ application: UIApplication) {
        
        print("アクティブ")
        
        // アプリ内にいる時はtrue
        backHome = true
    }
    
    
    
    // アプリが終了する直前に呼ばれる
    func applicationWillTerminate(_ application: UIApplication) {
        
        // タスクの終了を知らせる
        application.endBackgroundTask(self.backgroundTaskID)
    }

}



extension UIColor{
    class func rgb(r:Int,g:Int,b:Int,alpha: CGFloat)-> UIColor{
        return UIColor(red:CGFloat(r)/255.0,green:CGFloat(g)/255.0,blue:CGFloat(b)/255.0,alpha: alpha)
    }
}

// Stringに機能を追加
extension String {
    var lastPathComponent: String {
        get {
            return (self as NSString).lastPathComponent
        }
    }
    var pathExtension: String {
        get {
            return (self as NSString).pathExtension
        }
    }
    var stringByDeletingLastPathComponent: String {
        get {
            return (self as NSString).deletingLastPathComponent
        }
    }
    var stringByDeletingPathExtension: String {
        get {
            return (self as NSString).deletingPathExtension
        }
    }
    var pathComponents: [String] {
        get {
            return (self as NSString).pathComponents
        }
    }
    func stringByAppendingPathComponent(path: String) -> String {
        return (self as NSString).appendingPathComponent(path)
    }
    func stringByAppendingPathExtension(ext: String) -> String? {
        return (self as NSString).appendingPathExtension(ext)
    }
}


