
//
//  ViewController.swift
//  CocoaPods_Sample
//
//  Created by tarou yamasaki on 2015/02/16.
//  Copyright (c) 2017年 清水 直輝. All rights reserved.
//


import UIKit
import AudioToolbox
import UserNotifications
import MultipeerConnectivity

// LTMorphingLabelDelegateを追加（これで機能を使えるようになる
class TeachView: UIViewController, LTMorphingLabelDelegate,UITableViewDelegate, UITableViewDataSource,  UITextFieldDelegate, MCSessionDelegate,MCNearbyServiceBrowserDelegate, MCNearbyServiceAdvertiserDelegate, UIPickerViewDelegate,UIToolbarDelegate {
    
    var normalmessage = ZFRippleButton()
    var importantmessage = ZFRippleButton()
    var sousinnbutton = ZFRippleButton()
    var tourokubutton = ZFRippleButton()
    
    
    let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var naiyoutext = UITextField()
    private let myItems: NSMutableArray = []
    private var myTableView: UITableView!
    var id = 0
    let idValue = UserDefaults.standard
    var sendText : String = "true"
    
    
    var myTextField: UITextField!
    var whendaytext: UITextField!
    
    //ラベル
    var serviceLabelT : LTMorphingLabel!
    var myWindowButton = ZFRippleButton()
    var keyChangeButton = ZFRippleButton()
    var myWindow: UIWindow!
    
    // 接続キーを変える画面を表示する鍵ボタン
    var keyButton : UIButton!
    let buttonImageKey :UIImage? = UIImage(named:"Key-50.png")
    
    // 説明画面を表示するボタン
    var hatenaButton : UIButton!
    let buttonImagehatena :UIImage? = UIImage(named:"ヘルプ-48.png")
    
    var serviceAdvertiser : MCNearbyServiceAdvertiser!
    var serviceBrowser : MCNearbyServiceBrowser!
    var session : MCSession!
    
    let serviceSave = UserDefaults.standard
    
    
    var toolBar:UIToolbar!
    var myDatePicker: UIDatePicker!
    
    /*
     インスタンス化された時に動作する（初回のみ
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var ColorServiceType : String!
        
        // 一度だけ呼び出す！リロードした時も呼び出す
        if(appDelegate.connectFirst == true){
            
            
            if (serviceSave.object(forKey: "saveType") != nil) {
                print("データ有り")
                
                ColorServiceType = serviceSave.string(forKey: "saveType")
                
            }
            else{
                
            
                // serviceTypeの値を設定
                ColorServiceType = appDelegate.serviceTyper
            }

            // peer
            let myPeerId = MCPeerID(displayName: UIDevice.current.name)
        
            // session
            session = {
                let session = MCSession(peer: myPeerId, securityIdentity: nil, encryptionPreference: .required)
                session.delegate = self
                return session
            }()
        
            serviceAdvertiser = MCNearbyServiceAdvertiser(peer: myPeerId, discoveryInfo: nil, serviceType: ColorServiceType)
            
            serviceBrowser = MCNearbyServiceBrowser(peer: myPeerId, serviceType: ColorServiceType)
            
            serviceBrowser.delegate = self
            serviceAdvertiser.delegate = self
            
            // 受信開始
            serviceAdvertiser.startAdvertisingPeer()
            
            // 探索開始
            serviceBrowser.startBrowsingForPeers()
            
        }
        
        appDelegate.connectFirst = false
        
        print("SELECT")
        let db = FMDatabase(path: DatabaseClass().table)
        
        //let sql = "SELECT * FROM sample"
        let sql = "SELECT * FROM sample"
        // let sql = "SELECT user_name FROM sample ORDER BY user_id;"
        db?.open()
        
        let results = db?.executeQuery(sql, withArgumentsIn: nil)
        
        while (results?.next())! {
            
            // カラム名を指定して値を取得する方法
            let user_id = results?.int(forColumn: "user_id")
            
            // カラムのインデックスを指定して取得する方法
            let user_name = results?.string(forColumnIndex: 1)
            
            print("user_id = \(user_id!), user_name = \(user_name!)")
            
            myItems.add(user_name!)
        }
        
        db?.close()
        
        naiyoutext.frame = CGRect(x:0,y:0,width:self.view.bounds.width/1.25,height:self.view.bounds.height/14)
        
        naiyoutext.placeholder = "連絡する内容を記入してください"
        
        naiyoutext.layer.position = CGPoint(x:self.view.bounds.width/2.5,y:self.view.bounds.height/8)
        // 枠を表示する.
        naiyoutext.borderStyle = .roundedRect
        // クリアボタンを追加.
        naiyoutext.clearButtonMode = .whileEditing
        
        self.view.addSubview(naiyoutext)
        
        whendaytext = UITextField()
        
        whendaytext.frame = CGRect(x:0,y:0,width:self.view.bounds.width/1.25,height:self.view.bounds.height/14)
        
        whendaytext.placeholder = "日付を入力してください"
        
        whendaytext.layer.position = CGPoint(x:self.view.bounds.width/2.5,y:self.view.bounds.height/8)
        // 枠を表示する.
        whendaytext.borderStyle = .roundedRect
        // クリアボタンを追加.
        whendaytext.clearButtonMode = .whileEditing
        
        whendaytext.isHidden = true
        
        self.view.addSubview(whendaytext)
        
        // DatePickerを生成する.
        let myDatePicker: UIDatePicker = UIDatePicker()
        
        // datePickerを設定（デフォルトでは位置は画面上部）する.
        
        myDatePicker.datePickerMode = UIDatePickerMode.date
        // 値が変わった際のイベントを登録する.
        myDatePicker.addTarget(self, action: #selector(TeachView.onDidChangeDate(sender:)), for: .valueChanged)
        
        whendaytext.inputView = myDatePicker
        
        // UIToolBarの設定
        toolBar = UIToolbar(frame: CGRect(x:0,y: self.view.frame.size.height/6,width: self.view.frame.size.width,height: 40.0))
        toolBar.layer.position = CGPoint(x: self.view.frame.size.width/2, y: self.view.frame.size.height-20.0)
        toolBar.barStyle = .blackTranslucent
        toolBar.tintColor = UIColor.white
        toolBar.backgroundColor = UIColor.black
        //完了ボタンを設定tappedToolBarBtna
        let toolBarBtn = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: Selector(("toolBarBtnPush")))
        toolBar.items = [toolBarBtn]
        
        whendaytext.inputAccessoryView = toolBar
        
        normalmessage.setTitle("通常", for: .normal)
        importantmessage.setTitle("重要", for: .normal)
        sousinnbutton.setTitle("送信",for: .normal)
        tourokubutton.setTitle("登録",for: .normal)
        
        normalmessage.titleLabel?.font = UIFont(name: "TimesNewRomanPSMT", size: 40)
        importantmessage.titleLabel?.font = UIFont(name: "TimesNewRomanPSMT", size: 40)
        sousinnbutton.titleLabel?.font = UIFont(name: "TimesNewRomanPSMT", size: 30)
        tourokubutton.titleLabel?.font = UIFont(name: "TimesNewRomanPSMT", size: 40)
        
        normalmessage.setTitleColor(UIColor.white, for: .normal)
        importantmessage.setTitleColor(UIColor.white, for: .normal)
        sousinnbutton.setTitleColor(UIColor.white, for: .normal)
        tourokubutton.setTitleColor(UIColor.white, for: .normal)
        
        normalmessage.setTitleColor(UIColor.gray, for: .highlighted)
        importantmessage.setTitleColor(UIColor.gray, for: .highlighted)
        sousinnbutton.setTitleColor(UIColor.gray, for: .highlighted)
        tourokubutton.setTitleColor(UIColor.gray, for: .highlighted)
        
        normalmessage.backgroundColor = UIColor.rgb(r:138,g:159,b:230,alpha:1.0)
        importantmessage.backgroundColor = UIColor.rgb(r:217,g:130,b:182,alpha:1.0)
        sousinnbutton.backgroundColor = UIColor.rgb(r:240,g:155,b:132,alpha:1.0)
        tourokubutton.backgroundColor = UIColor.rgb(r:240,g:155,b:132,alpha:1.0)
        
        normalmessage.layer.cornerRadius = 20
        importantmessage.layer.cornerRadius = 20
        sousinnbutton.layer.cornerRadius = 20
        tourokubutton.layer.cornerRadius = 20
        
        normalmessage.frame = CGRect(x:0,y:0,width:self.view.bounds.width/2.5,height:self.view.bounds.height/12)
        importantmessage.frame = CGRect(x:0,y:0,width:self.view.bounds.width/2.5,height:self.view.bounds.height/12)
        sousinnbutton.frame = CGRect(x:0,y:0,width:self.view.bounds.width/5,height:self.view.bounds.height/14)
        tourokubutton.frame = CGRect(x:0,y:0,width:self.view.bounds.width,height:self.view.bounds.height/12)
        
        normalmessage.layer.position = CGPoint(x:self.view.bounds.width/4.5,y:self.view.bounds.height/3.5)
        importantmessage.layer.position = CGPoint(x:self.view.bounds.width-self.view.bounds.width/4.5,y:self.view.bounds.height/3.5)
        sousinnbutton.layer.position = CGPoint(x:self.view.bounds.width-self.view.bounds.width/10,y:self.view.bounds.height/8)
        tourokubutton.layer.position = CGPoint(x:self.view.bounds.width/2,y:self.view.bounds.height/1.1)
        
        tourokubutton.addTarget(self, action: #selector(TeachView.onclickbutton(sender:)), for: .touchUpInside)
        normalmessage.addTarget(self, action: #selector(TeachView.onclickbutton2(sender:)), for: .touchUpInside)
        importantmessage.addTarget(self, action: #selector(TeachView.onclickbutton3(sender:)), for: .touchUpInside)
        sousinnbutton.addTarget(self, action: #selector(TeachView.onclickbutton4(sender:)), for: .touchUpInside)
        
        normalmessage.alpha = 0.5
        importantmessage.alpha = 1.0
        
        self.view.addSubview(normalmessage)
        self.view.addSubview(importantmessage)
        self.view.addSubview(sousinnbutton)
        self.view.addSubview(tourokubutton)
        
        self.view.backgroundColor = UIColor.rgb(r:230,g:188,b:126,alpha:1.0)
        
        // Viewの高さと幅を取得する.
        let displayWidth: CGFloat = self.view.frame.width
        let displayHeight: CGFloat = self.view.frame.height/2
        
        // TableViewの生成(Status barの高さをずらして表示).
        myTableView = UITableView(frame: CGRect(x: 0, y: 0, width: displayWidth, height: displayHeight))
        
        myTableView.layer.position = CGPoint(x:self.view.bounds.width/2,y:self.view.bounds.height/1.65)
        
        // Cellの登録.
        myTableView.register(UITableViewCell.self, forCellReuseIdentifier: "MyCell")
        
        // DataSourceを自身に設定する.
        myTableView.dataSource = self
        
        // Delegateを自身に設定する.
        myTableView.delegate = self
        
        // 編集中のセル選択を許可.
        myTableView.allowsSelectionDuringEditing = true
        
        // Viewに追加する.
        self.view.addSubview(myTableView)
        
        myWindow = UIWindow()
        
        let posX: CGFloat = self.view.bounds.width
        let posY: CGFloat = self.view.bounds.height
        
        keyButton = UIButton()
        
        keyButton.frame = CGRect(x: posX/1.2, y: posY/6, width: posX/9, height: posY/14)
        keyButton.setTitleColor(UIColor.black, for: .highlighted)
        keyButton.tag = 2
        keyButton.addTarget(self, action: #selector(TeachView.windowButtonClick(sender:)), for: .touchUpInside)
        keyButton.setImage(buttonImageKey!, for: .normal)
        keyButton.imageView?.contentMode = UIViewContentMode.scaleAspectFit
        
        self.view.addSubview(keyButton)
        /*
        hatenaButton = UIButton()
        
        hatenaButton.frame = CGRect(x: posX/1.2, y: posY/6, width: posX/9, height: posY/14)
        hatenaButton.setTitleColor(UIColor.black, for: .highlighted)
        hatenaButton.tag = 3
        hatenaButton.addTarget(self, action: #selector(TeachView.windowButtonClick(sender:)), for: .touchUpInside)
        hatenaButton.setImage(buttonImageKey!, for: .normal)
        hatenaButton.imageView?.contentMode = UIViewContentMode.scaleAspectFit
        
        self.view.addSubview(hatenaButton)*/
        
        
    }
    
    // ボタンを押すとライブラリのテキストエフェクト開始
    
    /*
     memory warning
     */
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    // 「完了」を押すと閉じる
    func toolBarBtnPush(){
        print("アイウエオ")
        self.view.endEditing(true)
    }
    
    /*
     DatePickerが選ばれた際に呼ばれる.
     */
    func onDidChangeDate(sender: UIDatePicker){
        
        // フォーマットを生成.
        let myDateFormatter: DateFormatter = DateFormatter()
        myDateFormatter.dateFormat = "yyyy/MM/dd"
        
        // 日付をフォーマットに則って取得.
        let mySelectedDate: NSString = myDateFormatter.string(from: sender.date) as NSString
        whendaytext.text = mySelectedDate as String
    }

    
    func onclickbutton2(sender:UIButton){
        
        // 通常のメッセージ
        normalmessage.alpha = 0.5
        importantmessage.alpha = 1.0
        
        whendaytext.isHidden = true
        
        naiyoutext.layer.position = CGPoint(x:self.view.bounds.width/2.5,y:self.view.bounds.height/8)
        
        self.view.addSubview(naiyoutext)
        
        sendText = "true"
        
    }
    
    func onclickbutton3(sender:UIButton){
        
        // 重要なメッセージ
        
        normalmessage.alpha = 1.0
        importantmessage.alpha = 0.5
        
        whendaytext.isHidden = false
        
        naiyoutext.layer.position = CGPoint(x:self.view.bounds.width/2.5,y:self.view.bounds.height/5)
        
        self.view.addSubview(naiyoutext)
        
        sendText = "false"
        
    }
    
    //送信ボタン
    func onclickbutton4(sender:UIButton){
        
        naiyoutext.text = whendaytext.text! + "@" + naiyoutext.text!
        if(sendText == "true"){
            if(naiyoutext.text != ""){
                print("送信")
                // はじめにtrueかfirstかを判別
                sendfirst(boolText: sendText)
            
                // 内容を送信
                send(colorName: naiyoutext.text!)
                //addData(naiyoutext.text!)
                naiyoutext.text = ""
            }
        }
        else{
            if(naiyoutext.text != "" && whendaytext.text != ""){
            
                // はじめにtrueかfirstかを判別
                sendfirst(boolText: sendText)
            
                // 内容を送信
                send(colorName: naiyoutext.text!)
                //addData(naiyoutext.text!)
                naiyoutext.text = ""
                whendaytext.text = ""
            }
        }
        
    }
    
    func onclickbutton5(sender:UIButton){
        
        let vc = ServiceTypeClass()
        
        // presentViewControllerメソッドで遷移する
        // ここで、animatedをtrueにするとアニメーションしながら遷移できる
        self.present(vc, animated: true, completion: nil)
        
    }
    
    // 登録
    func onclickbutton(sender:UIButton){
        if(naiyoutext.text != "")
        {
            // myItemsに追加.
            myItems.add(naiyoutext.text!)
            
            //データの追加
            print("INSERT")
            let db = FMDatabase(path: DatabaseClass().table)
            let sql = "INSERT INTO sample (name) VALUES (?);"
            
            db?.open()
            
            // ?で記述したパラメータの値を渡す場合
            db?.executeUpdate(sql, withArgumentsIn: [naiyoutext.text!])
            // print("データベース　＝　\(db!)")
            db?.close()
            
        }
        
        naiyoutext.text = ""
        
        // TableViewを再読み込み.
        myTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Num: \(indexPath.row)")
        print("Value: \(myItems[indexPath.row])")
        naiyoutext.text = "\(myItems[indexPath.row])"
        naiyoutext.reloadInputViews()
    }
    
    
    // Cellの総数を返す.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyCell", for: indexPath as IndexPath)
        
        cell.textLabel?.text = "\(myItems[indexPath.row])"
        
        cell.textLabel?.textColor = UIColor.white
        
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
        
        var value : Int32!
        
        // 削除のとき.
        if editingStyle == UITableViewCellEditingStyle.delete {
            print("削除")
            
            let db = FMDatabase(path: DatabaseClass().table)
            
            //let sql = "SELECT * FROM sample"
            let sql = "SELECT * FROM sample"
            // let sql = "SELECT user_name FROM sample ORDER BY user_id;"
            db?.open()
            
            let results = db?.executeQuery(sql, withArgumentsIn: nil)
            
            while (results?.next())! {
                
                // カラム名を指定して値を取得する方法
                let user_id = results?.int(forColumn: "user_id")
                
                // カラムのインデックスを指定して取得する方法
                let user_name = results?.string(forColumnIndex: 1)
                
                print("user_id = \(user_id!), user_name = \(user_name!)")
                
                if(user_name! == String(describing: myItems[indexPath.row])){
                    value = user_id!
                    print(value)
                }
                
            }
            
            db?.close()
            
            //リムーブ処理
            let sqll = "DELETE FROM sample WHERE user_id = ?"
            
            db?.open()
            db?.executeUpdate(sqll, withArgumentsIn: [value])
            db?.close()
            //選択したセルの内容と保存してある内容が一致した場合のIDを削除するようにしゅるんでちゅ
            
            // 指定されたセルのオブジェクトをmyItemsから削除する.
            myItems.removeObject(at: indexPath.row)
            
            // TableViewを再読み込み.
            myTableView.reloadData()
        }
    }
    
    
    // UITextFieldが編集された直前に呼ばれる
    func textFieldDidBeginEditing(_ textField: UITextField) {
        print("textFieldDidBeginEditing: \(textField.text!)")
    }
    
    
    // UITextFieldが編集された直後に呼ばれる
    func textFieldDidEndEditing(_ textField: UITextField) {
        print("textFieldDidEndEditing: \(textField.text!)")
        
        if(textField.tag == 1){
        
            
        }
        
        else{
            
            appDelegate.serviceTyper = textField.text!
        }

    }
    
    /*
     改行ボタンが押された際に呼ばれる
     */
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print("textFieldShouldReturn \(textField.text!)")
        
        // 改行ボタンが押されたらKeyboardを閉じる処理.
        textField.resignFirstResponder()
        
        return true
    }
    
    // UIWindowを表示
    func makeMyWindow(){
        
        let posX = self.view.frame.width
        
        // 背景を白に設定する.
        myWindow.backgroundColor = UIColor.white
        myWindow.frame = CGRect(x:self.view.bounds.width - self.view.bounds.width/1.5, y:self.view.bounds.height/2, width:self.view.bounds.width/1.5, height:self.view.bounds.height/1.5)
        myWindow.layer.position = CGPoint(x:self.view.frame.width/2, y:self.view.frame.height/2)
        
        
        myWindow.layer.masksToBounds = true
        myWindow.layer.cornerRadius = posX/20
        
        //グラデーションの開始色
        let topColor = UIColorFromRGB(rgbValue: 0xf8f8ff)
        //グラデーションの開始色
        let bottomColor = UIColorFromRGB(rgbValue: 0xffdead)
        
        //グラデーションの色を配列で管理
        let gradientColors: [CGColor] = [topColor.cgColor, bottomColor.cgColor]
        
        //グラデーションレイヤーを作成
        let gradientLayer: CAGradientLayer = CAGradientLayer()
        
        //グラデーションの色をレイヤーに割り当てる
        gradientLayer.colors = gradientColors
        //グラデーションレイヤーをスクリーンサイズにする
        gradientLayer.frame = self.myWindow.bounds
        
        //グラデーションレイヤーをビューの一番下に配置
        self.myWindow.layer.insertSublayer(gradientLayer, at: 0)
        
        // myWindowをkeyWindowにする.
        myWindow.makeKey()
        
        // windowを表示する.
        self.myWindow.makeKeyAndVisible()
        
        let windowX : CGFloat = self.myWindow.frame.width
        let windowY : CGFloat = self.myWindow.frame.height
        
        
        myWindowButton.setTitle("閉じる",for: .normal)
        myWindowButton.titleLabel?.font = UIFont(name: "TimesNewRomanPSMT", size: 40)
        myWindowButton.setTitleColor(UIColor.white, for: .normal)
        myWindowButton.setTitleColor(UIColor.gray, for: .highlighted)
        myWindowButton.backgroundColor = UIColor.rgb(r:240,g:155,b:132,alpha:1.0)
        myWindowButton.layer.cornerRadius = 20
        myWindowButton.tag = 1
        myWindowButton.frame = CGRect(x:self.myWindow.frame.width/4, y:self.myWindow.frame.height/1.2, width:windowX/2, height:windowY/8)
        myWindowButton.addTarget(self, action: #selector(TeachView.windowButtonClick(sender:)), for: .touchUpInside)
        self.myWindow.addSubview(myWindowButton)
        
        keyChangeButton.setTitle("変更", for: .normal)
        keyChangeButton.titleLabel?.font = UIFont(name: "TimesNewRomanPSMT", size: 40)
        keyChangeButton.setTitleColor(UIColor.white, for: .normal)
        keyChangeButton.setTitleColor(UIColor.gray, for: .highlighted)
        keyChangeButton.backgroundColor = UIColor.rgb(r:138,g:159,b:230,alpha:1.0)
        keyChangeButton.layer.cornerRadius = 20
        keyChangeButton.tag = 4
        keyChangeButton.frame = CGRect(x:self.myWindow.frame.width/4, y:self.myWindow.frame.height/1.6, width:windowX/2, height:windowY/8)
        keyChangeButton.addTarget(self, action: #selector(TeachView.windowButtonClick(sender:)), for: .touchUpInside)
        self.myWindow.addSubview(keyChangeButton)
        
        
        // 説明ラベル「先生」
        serviceLabelT = LTMorphingLabel(frame: CGRect(x: windowX/4, y: windowY/4, width: windowX, height: windowY/10))
        serviceLabelT.text = "生徒との接続キー"
        serviceLabelT.font = UIFont.systemFont(ofSize: windowX/15)
        serviceLabelT.textColor = UIColor.rgb(r:240,g:155,b:132,alpha:1.0)
        serviceLabelT.textAlignment = NSTextAlignment.center
        self.myWindow.addSubview(serviceLabelT)
        
        
        myTextField = UITextField(frame: CGRect(x: windowX/6, y: windowY/3, width: windowX/1.5, height: windowY/10))
        myTextField.placeholder = "serviceTypeを入力"
        myTextField.tag = 2
        if(serviceSave.string(forKey: "saveType") != nil){
            
            myTextField.text = serviceSave.string(forKey: "saveType")
        }
        else{
            
            myTextField.text = appDelegate.serviceTyper
        }
        myTextField.delegate = self
        myTextField.borderStyle = .roundedRect
        myTextField.clearButtonMode = .whileEditing
        self.myWindow.addSubview(myTextField)
        
        
    }
    
    func windowButtonClick(sender:UIButton){
        
        // UIWindowButton
        if(sender.tag == 1){
            
            myWindow.isHidden = true
            
            
        }
            
            // keyButton
        else if(sender.tag == 2){
            
            
            // 受信終了
            self.serviceAdvertiser.stopAdvertisingPeer()
            
            // 探索終了
            self.serviceBrowser.stopBrowsingForPeers()
            
            session.disconnect()
            
            
            makeMyWindow()

            
        }
            
        else if(sender.tag == 3){
            
        }
        
        // 接続キーを変更したことを更新する
        else if(sender.tag == 4){
            
            myWindow.isHidden = true
            
            serviceSave.set(appDelegate.serviceTyper, forKey: "saveType")	// object
            
            appDelegate.connectFirst = true
            
            // viewDidLoadをリロード
            loadView()
            viewDidLoad()
            
        }
        else{
            print("終了！")
            
            // 受信終了
            self.serviceAdvertiser.stopAdvertisingPeer()
            
            // 探索終了
            self.serviceBrowser.stopBrowsingForPeers()
            
            session.disconnect()
            
            
        }
        
        
    }
    
    
    // 色を変更する実装して送信するメソッド
    func send(colorName : String) {
        NSLog("%@", "sendColor: \(colorName) to \(session.connectedPeers.count) peers")
        
        // このセッションに現在接続しているすべてのピアの配列の数が０以上なら条件に入る
        if session.connectedPeers.count > 0 {
            do {
                /* NSDataオブジェクトにカプセル化(オブジェクトの内部のデータ、振る舞い、
                 実際の型を隠蔽(隠す))されたメッセージを近くのピアに送信します。 */
                try self.session.send(colorName.data(using: .utf8)!, toPeers: session.connectedPeers, with: .reliable)
                
                // data : 送信するメッセージを含むオブジェクト。
                // toPeers : メッセージを受け取るべきピアを表すピアIDオブジェクトの配列。
                // with(mode) : 使用する伝送モード（信頼性の高いまたは信頼できない配信）。
                
            }
            catch let error {
                NSLog("%@", "Error for sending: \(error)")
            }
        }
        
    }
    
    func sendfirst(boolText : String){
        
        // このセッションに現在接続しているすべてのピアの配列の数が０以上なら条件に入る
        if session.connectedPeers.count > 0 {
            do {
                /* NSDataオブジェクトにカプセル化(オブジェクトの内部のデータ、振る舞い、
                 実際の型を隠蔽(隠す))されたメッセージを近くのピアに送信します。 */
                try self.session.send(boolText.data(using: .utf8)!, toPeers: session.connectedPeers, with: .reliable)
                
                // data : 送信するメッセージを含むオブジェクト。
                // toPeers : メッセージを受け取るべきピアを表すピアIDオブジェクトの配列。
                // with(mode) : 使用する伝送モード（信頼性の高いまたは信頼できない配信）。
                
            }
            catch let error {
                NSLog("%@", "Error for sending: \(error)")
            }
        }
    }
    
    // 接続されている端末が変わったら呼び出される
    func connectedDevicesChanged(connectedDevices: [String]) {
        OperationQueue.main.addOperation {
            print("接続 = \(connectedDevices)")
            
            /*
            let alert:UIAlertView? = UIAlertView(title: "接続されました",message: "接続端末：\(connectedDevices)", delegate: self as? UIAlertViewDelegate, cancelButtonTitle: nil, otherButtonTitles: "OK")
            alert?.show()
            */
            
        }
    }
    
    
    /************ Advertiser関数 ***********/
    //アドバタイズが開始できなかった場合に呼ばれる，エラー処理をここに書く
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didNotStartAdvertisingPeer error: Error) {
        NSLog("%@", "didNotStartAdvertisingPeer: \(error)")
    }
    
    //他端末から招待を受けた時に呼ばれる(実装必須)
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        NSLog("%@", "didReceiveInvitationFromPeer \(peerID)")
        
        //招待への返答(true/false)
        invitationHandler(true, session)
    }
    
    /************ Browser関数 ***********/
    //探索を開始出来ない場合に呼ばれる，エラー処理を書いても良し！
    func browser(_ browser: MCNearbyServiceBrowser, didNotStartBrowsingForPeers error: Error) {
        NSLog("%@", "探索が開始できない : \(error)")
    }
    
    //他端末の発見時に呼ばれる
    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
        NSLog("%@", "見つけたpeerID: \(peerID)")
        NSLog("%@", "招待されたpeerID: \(peerID)")
        
        // peerID : 招待する端末のMCPeerIDを渡す
        // toSession : どのSessionに対して招待を行うかを，先に作っておいたMCSessionのインスタンスを渡すことで知らせます
        // withContext : 相手に対して追加で提示する情報
        // timeout : 招待に対して返答がなかった場合，タイムアウトする時間の長さの設定
        browser.invitePeer(peerID, to: self.session, withContext: nil, timeout: 10)
    }
    
    //端末を見失った時に呼ばれる
    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        NSLog("%@", "端末を見失った: \(peerID)")
    }
    
    /************ Session関数 ***********/
    // 近くのピアの状態が変更されたときに呼び出されます。
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        NSLog("%@", "peer \(peerID) didChangeState: \(state)")
        connectedDevicesChanged(connectedDevices:
            session.connectedPeers.map{$0.displayName})
    }
    
    //近くのピアからNSDataオブジェクトが受信されたことを示します。
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        NSLog("%@", "受信データ: \(data)")
    }
    
    // 近くのピアがローカルピアへのバイトストリーム接続を開くときに呼び出されます。
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        NSLog("%@", "didReceiveStream")
    }
    
    // ローカルピアが近隣のピアからリソースを受信し始めたことを示します。
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        NSLog("%@", "didStartReceivingResourceWithName")
    }
    
    // ローカルピアが近くのピアからリソースを受信し終わったことを示します。
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL, withError error: Error?) {
        NSLog("%@", "didFinishReceivingResourceWithName")
    }
    
    
    //UIntに16進で数値をいれるとUIColorが戻る関数
    func UIColorFromRGB(rgbValue: UInt) -> UIColor {
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}
