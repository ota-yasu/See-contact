//
//  importantView.swift
//  animation practice
//
//  Created by 恭弘 on 2017/02/03.
//  Copyright © 2017年 恭弘. All rights reserved.
//

import UIKit
import AudioToolbox
import UserNotifications
import MultipeerConnectivity

class importantView : UIViewController,UITableViewDelegate, UITableViewDataSource {
    
    var date = NSDate()
    var timer = Timer()
    var DateLabel = UILabel()
    var collectionLabel : UILabel!
    var tableView : UITableView!
    var formatter = DateFormatter()
    let myDays: NSMutableArray = []
    var updataed : NSMutableArray = []
    var changeval : Bool! = true
    var backButton : UIButton!
    var updateTimer = Timer()
    let idValue = UserDefaults.standard
    let application : AppDelegate = UIApplication.shared.delegate as! AppDelegate
    var first : Bool = true
    
    let userDef = UserDefaults.standard
    
    
    var reslut : [String] = []
    var yearH : [String] = []
    var monthH : [String] = []
    var dayH : [String] = []
    var Rdate : [String] = []
    var Rmemo : [String] = []
    var TorF : [Bool] = []
    var cup : String!
    
    let studentAlert = StudentView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userDef.set("test", forKey: "student")
        
        self.view.backgroundColor = UIColor.rgb(r:230,g:188,b:126,alpha:1.0)
        
        /*        //変数updataedに値を入れる
         updataed = []
         //いくつのデータがあるかカウントする
         maxvalue = updataed.count
         
         //for inを使う
         for i in 0 ..< maxvalue {
         //データを取ってくる変数を用意し、配列にその変数の値を代入する（今回は仮にupdatadとする）
         myDays[i] = updataed[i]
         }*/
        
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
        let formattedDate = formatter.string(from: date as Date)
        
        DateLabel.frame = CGRect(x:0,y:0,width:self.view.bounds.width/1.2,height:self.view.bounds.height/13)
        DateLabel.layer.position = CGPoint(x:self.view.bounds.width/1.7,y:self.view.bounds.height/13.5)
        DateLabel.layer.cornerRadius = 20
        DateLabel.textColor = UIColor.rgb(r:138,g:159,b:230,alpha:1.0)
        //      DateLabel.backgroundColor = UIColor.rgb(r:217,g:130,b:182,alpha:1.0)
        DateLabel.textAlignment = .center
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
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "MyCell")
        // DataSourceを自身に設定する.
        tableView.dataSource = self
        // Delegateを自身に設定する.
        tableView.delegate = self
        // 編集中のセル選択を許可.
        tableView.allowsSelectionDuringEditing = true
        // Viewに追加する.
        self.view.addSubview(tableView)
        
        print("SELECT")
        
        let db = FMDatabase(path: DatabaseClass().table3)
        
        //let sql = "SELECT * FROM sample"
        let sql = "SELECT * FROM sample3"
        // let sql = "SELECT user_name FROM sample ORDER BY user_id;"
        db?.open()
        
        let results = db?.executeQuery(sql, withArgumentsIn: nil)
        
        while (results?.next())! {
            
            // カラム名を指定して値を取得する方法
            let user_id = results?.int(forColumn: "user_id")
            
            // カラムのインデックスを指定して取得する方法
            let user_name = results?.string(forColumnIndex: 1)
            
            print("user_id = \(user_id!), user_name = \(user_name!)")
            
            var str = String(describing: user_name!)
            var startIndex = str.index(str.startIndex, offsetBy: 0)
            var endIndex = str.characters.index(of: "/")
            var range = startIndex..<endIndex!
            let year = str.substring(with: range) // 年の取得
            print("year = \(year)")
            yearH.append(year)
            str.removeSubrange(range)
            let Index = str.index(str.startIndex, offsetBy: 0)
            str.remove(at: Index)
            startIndex = str.index(str.startIndex,offsetBy:0)
            endIndex = str.characters.index(of: "/")
            range = startIndex..<endIndex!
            let month = str.substring(with: range)// "月の取得"
            monthH.append(month)
            str.removeSubrange(range)
            let SIndex = str.index(str.startIndex, offsetBy: 0)
            str.remove(at: SIndex)
            startIndex = str.index(str.startIndex,offsetBy:0)
            endIndex = str.characters.index(of: "@")
            range = startIndex..<endIndex!
            let day = str.substring(with: range) // 日の取得
            dayH.append(day)
            str.removeSubrange(range)
            (str as NSString).substring(from: 0)
            print("x:\(year), y:\(month), z:\(day)")
            myDays.add(user_name!)
            print("SELECTしたデータ = \(user_name!)")
        }
        
        db?.close()
        
        //年の並び替え
        for i in 0..<yearH.count {
            for j in 0..<yearH.count {
                print("並び替え\(yearH[i])   \(yearH[j])")
                if(Int(yearH[i])! > Int(yearH[j])!){
                    //年の入れ替えをする
                    cup = yearH[i]
                    yearH[i] = yearH[j]
                    yearH[j] = cup
                    //月の入れ替えをする
                    cup = monthH[i]
                    monthH[i] = monthH[j]
                    monthH[j] = cup
                    //日の入れ替えをする
                    cup = dayH[i]
                    dayH[i] = dayH[j]
                    dayH[j] = cup
                    //日付と内容を入れ替えする
                    cup = myDays[i] as! String
                    myDays[i] = myDays[j]
                    myDays[j] = cup
                }
            }
        }
        
        //並び替えた年を今度は月を見ながら並び替え
        for i in 0..<yearH.count {
            for j in 0..<yearH.count {
                if(Int(yearH[i])! == Int(yearH[j])!){
                    if(Int(monthH[i])! > Int(monthH[j])!){
                        //月の入れ替えをする
                        cup = monthH[i]
                        monthH[i] = monthH[j]
                        monthH[j] = cup
                        //日の入れ替えをする
                        cup = dayH[i]
                        dayH[i] = dayH[j]
                        dayH[j] = cup
                        //日付と内容を入れ替えする
                        cup = myDays[i] as! String
                        myDays[i] = myDays[j]
                        myDays[j] = cup
                        
                    }
                }
            }
        }
        
        //並び替えた月を今度は日を見ながら並び替え
        for i in 0..<yearH.count {
            for j in 0..<yearH.count {
                if(Int(yearH[i])! == Int(yearH[j])!){
                    if(Int(monthH[i])! == Int(monthH[j])!){
                        if(Int(dayH[i])! > Int(dayH[j])!){
                            /*
                             //日の入れ替えをする
                             cup = dayH[i]
                             dayH[i] = dayH[j]
                             dayH[j] = cup
                             */
                            //日付と内容を入れ替えする
                            cup = myDays[i] as! String
                            myDays[i] = myDays[j]
                            myDays[j] = cup
                        }
                    }
                }
            }
        }
        //内容が被った時の回数を変数にカウントする
        var oth : Int! = 0
        var startsamememo : Bool! = true
        //最後の配列(i*2-oth)から一つ前の日付までどのくらい差があるか計算する
        var beforeday : Int! = 2
        for i in 0..<myDays.count {
            var str = String(describing: myDays[i])
            let startIndex = str.index(str.startIndex, offsetBy: 0)
            let endIndex = str.characters.index(of: "@")
            let range = startIndex..<endIndex!
            let date = str.substring(with: range)
            
            
            //日付の追加
            if(startsamememo == false && date == reslut[i*2-oth-beforeday]){
                print("清水\(i*2-oth-beforeday)　個数\(reslut.count)")
                //日付が被っているものを統一する
                //内容の追加
                str.removeSubrange(range)
                let memo = str
                reslut.append(memo)
                TorF.append(true)
                oth = oth + 1
                beforeday = beforeday + 1
            }
            else{
                print("来ちゃったよーー")
                //日付が被っていない時は別々にする
                //内容の追加
                reslut.append(date)
                TorF.append(false)
                str.removeSubrange(range)
                let memo = str
                reslut.append(memo)
                TorF.append(true)
                beforeday = 2
                startsamememo = false
            }
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func update(sender:Timer){
        
        date = NSDate()
        formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
        let formattedDate = formatter.string(from: date as Date)
        DateLabel.text = "\(formattedDate)"
        //session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID)
        
        /*
         if(application.receveMessage != nil){
         if(userDef.string(forKey: "student") != application.receveMessage){
         print("太田ちゃん太田ちゃん太田ちゃん")
         changeImportant(color: application.receveMessage)
         userDef.set(application.receveMessage, forKey: "student")
         }
         }
         */
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        print("Num: \(indexPath.row)")
        print("Value: \(reslut[indexPath.row])")
        
        var str = reslut[indexPath.row]
        
        let startIndex = str.characters.index(of: "/") // ←「/」のインデックスを戻す
        print("/は？　＝　\(String(describing: startIndex))")
        if(startIndex != nil){
            
            let endIndex = str.index(str.endIndex, offsetBy: 0)
            let range = startIndex!..<endIndex
            str.replaceSubrange(range, with: "")
        }
        
        let naiyou = str
        
        if var year =  Int(naiyou) {
            
            print("変換可能！")
            
            
        } else {
            print("変換できません")
            application.navigationText = reslut[indexPath.row]
            
            let mySimiController: UIViewController = NormalNavigation()
            
            // アニメーションを設定する.
            mySimiController.modalTransitionStyle = .partialCurl
            
            // Viewの移動する.
            self.present(mySimiController, animated: true, completion: nil)
            
        }
        
    }
    
    func onclickbutton(sender:UIButton){
        
        /* タイマーを破壊 */
        self.timer.invalidate()
        self.updateTimer.invalidate()
        
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
        return reslut.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyCell", for: indexPath as IndexPath)
        
        cell.textLabel?.font = UIFont(name: "TimesNewRomanPSMT", size: 30)
        
        var str = reslut[indexPath.row]
        
        if(str[str.startIndex] == "@"){
            
            //内容の表示
            
            let SIndex = str.index(str.startIndex, offsetBy: 0)
            
            str.remove(at: SIndex)
            
            /*
            var com = str
            let startIndex = com.characters.index(of: "@")
            let endIndex = com.index(startIndex!, offsetBy: 1)
            let range = startIndex!..<endIndex
            //replaceSubrange
            com.replaceSubrange(range, with: "　")*/
            
            cell.textLabel?.text = "\(str)"
            
            cell.textLabel?.textColor = UIColor.white
            
        }
            
        else{
            
            //日付の表示
            
            cell.textLabel?.text = "\(reslut[indexPath.row])"
            
            cell.textLabel?.textColor = UIColor.blue
            
        }
        
        cell.textLabel?.sizeToFit()
        
        cell.backgroundColor = UIColor.rgb(r:185,g:132,b:240,alpha:1.0)
        
        return cell
        
    }
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        // アニメーションの作成
        let animation = CABasicAnimation(keyPath: "transform.scale")
        animation.fromValue = 0.0
        animation.toValue = 1.0
        animation.duration = 1.0
        animation.beginTime = CACurrentMediaTime() + 0.15
        
        // アニメーションが開始される前からアニメーション開始地点に表示
        animation.fillMode = kCAFillModeBackwards
        
        // セルのLayerにアニメーションを追加
        cell.layer.add(animation, forKey: nil)
        
        // アニメーション終了後は元のサイズになるようにする
        cell.layer.transform = CATransform3DIdentity
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        var values : Int32!
        var count : Int! = 0
        var valueh : [Int32]! = []
        var deldata : [Int]! = []
        var seletyan : Bool! = true
        
        // 削除のとき.
        if editingStyle == UITableViewCellEditingStyle.delete {
            print("削除")
            
            let db = FMDatabase(path: DatabaseClass().table3)
            
            //let sql = "SELECT * FROM sample"
            let sql = "SELECT * FROM sample3"
            // let sql = "SELECT user_name FROM sample ORDER BY user_id;"
            db?.open()
            
            let results = db?.executeQuery(sql, withArgumentsIn: nil)
            
            while (results?.next())! {
                
                // カラム名を指定して値を取得する方法
                let user_id = results?.int(forColumn: "user_id")
                
                // カラムのインデックスを指定して取得する方法
                let user_name = results?.string(forColumnIndex: 1)
                
                print("user_id = \(user_id!), user_name = \(user_name!)")
                
                //日付から次の日付までいくらあるか求めるのに使う
                var loco : Int! = 1
                
                //内容の判定
                if(TorF[indexPath.row] == true){
                    //その内容の日付はいつか求める
                    print("❤️来たね\(TorF[indexPath.row - loco])")
                    while(TorF[indexPath.row - loco] == true){
                        loco = loco + 1
                    }
                    print("\(user_name!) == \(reslut[indexPath.row - loco] + reslut[indexPath.row])")
                    if(user_name! == reslut[indexPath.row - loco] + reslut[indexPath.row]){
                        values = user_id!
                        print("三角形\(values)")
                        print(values)
                    }
                    
                    seletyan = true
                }
                    
                    //日付の判定
                else if(TorF[indexPath.row] == false){
                    print("⭐️来たね")
                    //次の日付までいくらあるか求める
                    while(TorF[indexPath.row + loco] == true){
                        
                        if(user_name == reslut[indexPath.row] + reslut[indexPath.row + loco]){
                            
                            deldata.append(indexPath.row + loco)
                            valueh.append(user_id!)
                            print("deldata = \(deldata)")
                            print(valueh)
                        }
                        loco = loco + 1
                        if(indexPath.row + loco > TorF.count - 1){
                            break
                        }
                        for i in 0..<deldata.count{
                            for j in 0..<deldata.count{
                                if(deldata[i] > deldata[j]){
                                    count = deldata[i]
                                    deldata[i] = deldata[j]
                                    deldata[j] = count
                                }
                            }
                        }
                        print(deldata)
                    }
                    seletyan = false
                }
            }
            
            db?.close()
            
            //リムーブ処理
            let sqll = "DELETE FROM sample3 WHERE user_id = ?"
            
            db?.open()
            
            if(seletyan == true){
                var onlymemo : Bool! = true
                print("values == \(values)")
                db?.executeUpdate(sqll, withArgumentsIn: [values])
                // 指定されたセルのオブジェクトをmyItemsから削除する.
                if(indexPath.row == reslut.count - 1){
                    if(TorF[indexPath.row - 1] ==  false){
                        onlymemo = false
                    }
                }
                
                else if(TorF[indexPath.row + 1] == false && TorF[indexPath.row - 1] == false){
                    onlymemo = false
                }
                reslut.remove(at: indexPath.row)
                TorF.remove(at: indexPath.row)
                print("どぴゅ〜♬")
                print("reslut = \(reslut)\nTorF = \(TorF)")
                if(onlymemo == false){
                    reslut.remove(at: indexPath.row - 1)
                    TorF.remove(at: indexPath.row - 1)
                    print("ブリュリュリュリュ〜♬")
                }
            }
            else if(seletyan == false){
                print("パンパンreslut = \(reslut)\nTorF = \(TorF)")
                for i in 0..<valueh.count{
                    db?.executeUpdate(sqll, withArgumentsIn: [valueh[i]])
                    // 指定されたセルのオブジェクトをmyItemsから削除する.
                    reslut.remove(at: deldata[i])
                    TorF.remove(at: deldata[i])
                    print("太田が〜ばい〜よ〜♬")
                }
                reslut.remove(at: indexPath.row)
                TorF.remove(at: indexPath.row)
                print("ジョーギリ〜♬")
            }
            db?.close()
            // TableViewを再読み込み.
            tableView.reloadData()
            print("TorF = \(TorF)")
            
            
        }
    }
    
    
    
    
}
