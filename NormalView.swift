//
//  NormalView.swift
//  animation practice
//
//  Created by 恭弘 on 2017/01/28.
//  Copyright © 2017年 恭弘. All rights reserved.
//

//新しいファイル
import UIKit
import AudioToolbox
import UserNotifications
import MultipeerConnectivity

class NormalView: UIViewController,UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate {
    
    var date = NSDate()
    var timer = Timer()
    var DateLabel = UILabel()
    var collectionLabel : UILabel!
    var tableView : UITableView!
    var formatter = DateFormatter()
    var formatter2 = DateFormatter()
    var backButton : UIButton!
    var myTextField: UITextField!
    let myDays: NSMutableArray = []
    
    //var updateTimer: Timer!
    let idValue = UserDefaults.standard
    let application : AppDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var first : Bool = true
    
    var whatClass : Int = 0
    
    let studentAlert = StudentView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        application.stuTextAN = true
        
        self.view.backgroundColor = UIColor.rgb(r:230,g:188,b:126,alpha:1.0)
        
        backButton = UIButton()
        backButton.frame = CGRect(x:0,y:0,width:self.view.bounds.width/6,height:self.view.bounds.height/12.5)
        backButton.setTitle("戻る", for: .normal)
        backButton.layer.cornerRadius = 20
        backButton.titleLabel?.font = UIFont(name: "TimesNewRomanPSMT", size: 30)
        backButton.setTitleColor(UIColor.rgb(r:217,g:130,b:182,alpha:1.0), for: .normal)
        backButton.setTitleColor(UIColor.rgb(r:138,g:159,b:230,alpha:1.0), for: .highlighted)
        backButton.backgroundColor = UIColor.rgb(r:240,g:155,b:132,alpha:1.0)
        backButton.layer.position = CGPoint(x:self.view.bounds.width/11.5,y:self.view.bounds.height/13.5)
        backButton.addTarget(self, action: #selector(NormalView.onclickbutton(sender:)), for: .touchUpInside)
        self.view.addSubview(backButton)
        
        print(date)
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.update), userInfo: nil, repeats: true)
        timer.fire()
        
        formatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
        formatter2.dateFormat = "HH:mm:ss"
        let formattedDate = formatter.string(from: date as Date)
        
        DateLabel.frame = CGRect(x:0,y:0,width:self.view.bounds.width/1.2,height:self.view.bounds.height/13)
        
        DateLabel.layer.position = CGPoint(x:self.view.bounds.width/1.7,y:self.view.bounds.height/13.5)
        
        DateLabel.textAlignment = .center
        
        DateLabel.layer.cornerRadius = 20
        
        DateLabel.textColor = UIColor.rgb(r:138,g:159,b:230,alpha:1.0)
        
        // DateLabel.backgroundColor = UIColor.rgb(r:217,g:130,b:182,alpha:1.0)
        
        DateLabel.font = UIFont(name: "TimesNewRomanPSMT", size: 35)
        
        DateLabel.text = "\(formattedDate)"
        
        self.view.addSubview(DateLabel)
        
        // Viewの高さと幅を取得する.
        let displayWidth: CGFloat = self.view.frame.width
        let displayHeight: CGFloat = self.view.frame.height
        
        // TableViewの生成(Status barの高さをずらして表示).
        tableView = UITableView(frame: CGRect(x: 0, y: 0, width: displayWidth, height: displayHeight))
        
        tableView.layer.position = CGPoint(x:self.view.bounds.width/2,y:self.view.bounds.height/1.6)
        
        // Cellの登録.
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        // DataSourceを自身に設定する.
        tableView.dataSource = self
        
        // Delegateを自身に設定する.
        tableView.delegate = self
        
        // 編集中のセル選択を許可.
        tableView.allowsSelectionDuringEditing = true
        
        // Viewに追加する.
        self.view.addSubview(tableView)
        
        //updateTimer = Timer.scheduledTimer(timeInterval: 3, target: self, selector:#selector(NormalView.updateTime(_:)), userInfo: nil, repeats: true)
        
        
        print("SELECT")
        
        let db = FMDatabase(path: DatabaseClass().table2)
        
        //let sql = "SELECT * FROM sample"
        let sql = "SELECT * FROM sample2"
        // let sql = "SELECT user_name FROM sample ORDER BY user_id;"
        db?.open()
        
        let results = db?.executeQuery(sql, withArgumentsIn: nil)
        
        while (results?.next())! {
            
            // カラム名を指定して値を取得する方法
            let user_id = results?.int(forColumn: "user_id")
            
            // カラムのインデックスを指定して取得する方法
            let user_name = results?.string(forColumnIndex: 1)
            
            myDays.add(user_name!)
            
            print("user_id = \(user_id!), user_name = \(user_name!)")
            
            
        }
        
        db?.close()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func change(color: String){
        
        application.message = color
        
        print("Student = \(self.application.message)")
        
        // アクテッブ状態
        if(application.backHome == true){
            
            // アラート
            studentAlert.alertView(color)
        }
            // バックグラウンド状態
        else if (application.backHome == false){
            
            // 通知
            studentAlert.showNotification(color)
        }
    }
    
    func update(sender:Timer){
        date = NSDate()
        formatter = DateFormatter()
        formatter2 = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
        formatter2.dateFormat = "HH:mm:ss"
        let formattedDate = formatter.string(from: date as Date)
        let formettedDate2 = formatter2.string(from: date as Date)
        DateLabel.text = "\(formattedDate)"
        print("時間 = \(formettedDate2)")
        
        if(formettedDate2 == "08:30:00"){
            print("今日は\(application.classMuch)時間です。")
            // 何時間授業
            whatClass = application.classMuch
        }
    }
    
    // 選択されたら呼ばれる
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Num: \(indexPath.row)")
        print("Value: \(myDays[indexPath.row])")
        
        let str = myDays[indexPath.row] as! String
        
        application.navigationText = str
        
        let mySimiController: UIViewController = NormalNavigation()
        
        // アニメーションを設定する.
        mySimiController.modalTransitionStyle = .partialCurl
        
        // Viewの移動する.
        self.present(mySimiController, animated: true, completion: nil)
        
    }
    
    func onclickbutton(sender:UIButton){
        
        /* タイマーを破壊 */
        self.timer.invalidate()
        //self.updateTimer.invalidate()
        
        // 次の遷移先のViewControllerインスタンスを生成する
        let vc = StudentView()
        
        // presentViewControllerメソッドで遷移する
        // ここで、animatedをtrueにするとアニメーションしながら遷移できる
        self.present(vc, animated: true, completion: nil)
    }
    
    /*
     Cellの総数を返す.
     */
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myDays.count
    }
    
    // tableviewのcellに値を入れてる
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath as IndexPath)
        
        var str = myDays[indexPath.row] as! String
        
        cell.textLabel?.font = UIFont(name: "TimesNewRomanPSMT", size: 30)
        
        
        //内容の表示
        
        var com = str
        let startIndex = com.characters.index(of: "@")
        let endIndex = com.index(startIndex!, offsetBy: 1)
        let range = startIndex!..<endIndex
        //replaceSubrange
        com.replaceSubrange(range, with: "")
        
        cell.textLabel?.text = "\(com)"
        
        cell.textLabel?.textColor = UIColor.white
        
        cell.textLabel?.sizeToFit()
        
        cell.backgroundColor = UIColor.rgb(r:185,g:132,b:240,alpha:1.0)
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        var value : Int32!
        
        // 削除のとき.
        if editingStyle == UITableViewCellEditingStyle.delete {
            print("削除")
            
            let db = FMDatabase(path: DatabaseClass().table2)
            
            //let sql = "SELECT * FROM sample"
            let sql = "SELECT * FROM sample2"
            // let sql = "SELECT user_name FROM sample ORDER BY user_id;"
            db?.open()
            
            let results = db?.executeQuery(sql, withArgumentsIn: nil)
            
            while (results?.next())! {
                
                // カラム名を指定して値を取得する方法
                let user_id = results?.int(forColumn: "user_id")
                
                // カラムのインデックスを指定して取得する方法
                let user_name = results?.string(forColumnIndex: 1)
                
                print("user_id = \(user_id!), user_name = \(user_name!)")
                
                if(user_name! == String(describing: myDays[indexPath.row])){
                    value = user_id!
                    print(value)
                }
                
            }
            
            db?.close()
            
            //リムーブ処理
            let sqll = "DELETE FROM sample2 WHERE user_id = ?"
            
            db?.open()
            db?.executeUpdate(sqll, withArgumentsIn: [value])
            db?.close()
            //選択したセルの内容と保存してある内容が一致した場合のIDを削除するようにしゅるんでちゅ
            
            // 指定されたセルのオブジェクトをmyItemsから削除する.
            myDays.removeObject(at: indexPath.row)
            
            // TableViewを再読み込み.
            tableView.reloadData()
        }
    }
    
    
}
