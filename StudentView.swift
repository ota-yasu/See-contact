//
//  StudentView.swift
//  animation practice
//
//  Created by 恭弘 on 2017/01/27.
//  Copyright © 2017年 恭弘. All rights reserved.
//

import UIKit
import AudioToolbox
import UserNotifications
import MultipeerConnectivity

class StudentView: UIViewController, UITextFieldDelegate, MCSessionDelegate,MCNearbyServiceBrowserDelegate,MCNearbyServiceAdvertiserDelegate {
    
    var normalmessage = ZFRippleButton()
    var importantmessage = ZFRippleButton()
    
    let application : AppDelegate = UIApplication.shared.delegate as! AppDelegate
    var first : Bool = true
    
    var date = NSDate()
    var formatter = DateFormatter()
    var formatter2 = DateFormatter()
    
    
    var teacherTextField: UITextField!
    var studentTextField: UITextField!
    
    var myWindowButton: UIButton!
    var myWindow: UIWindow!
    
    var timer = Timer()
    
    var i = 0
    var firstmessage : Int! = 0
    
    var read : Bool = false
    var label: UILabel!
    
    // 先生ラベル
    var serviceLabelT : LTMorphingLabel!
    
    // 生徒ラベル
    var serviceLabelS : LTMorphingLabel!
    
    // 接続状態を表示する
    var connectionLabel : LTMorphingLabel!
    
    var serviceAdvertiser : MCNearbyServiceAdvertiser!
    var serviceBrowser : MCNearbyServiceBrowser!
    
    var session : MCSession!
    
    var keyButton : UIButton!
    let buttonImageKey : UIImage? = UIImage(named:"Key-50.png")
        
    let serviceSave = UserDefaults.standard
    
    var sendbool : Bool = true
    
    var keyChangeButton = ZFRippleButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        var TeacherServiceType : String!
        var StudentServiceType : String!
        
        
        let posX: CGFloat = self.view.bounds.width
        let posY: CGFloat = self.view.bounds.height
        
        // 開いた時に一回だけ接続
        if(application.connectFirst == true){
            
            // 先生と生徒のserviceType
            if (serviceSave.object(forKey: "saveType") != nil) {
                
                // 先生との通信に使うserviceTypeを入れる
                TeacherServiceType = serviceSave.string(forKey: "saveType")
            }
            else{
                
                // 先生との通信に使うserviceTypeを入れる
                TeacherServiceType = application.serviceTyper
            }
            
            // 生徒同士のserviceType
            if (serviceSave.object(forKey: "saveTypeS") != nil) {
                print("データ有り")
                
                // 先生との通信に使うserviceTypeを入れる
                StudentServiceType = serviceSave.string(forKey: "saveTypeS")
            }
            else{
                
                
                // 先生との通信に使うserviceTypeを入れる
                StudentServiceType = application.serviceType
            }
            
            // peer
            let myPeerId = MCPeerID(displayName: UIDevice.current.name)
            
            session = {
                let session = MCSession(peer: myPeerId, securityIdentity: nil, encryptionPreference: .required)
                session.delegate = self
                return session
            }()
            
            // 先生のメッセージを受信
            serviceAdvertiser = MCNearbyServiceAdvertiser(peer: myPeerId, discoveryInfo: nil, serviceType: TeacherServiceType)
            
            // 生徒に発信！
            serviceBrowser = MCNearbyServiceBrowser(peer: myPeerId, serviceType: StudentServiceType)
            
            // 発信と受信の処理を委任！
            serviceAdvertiser.delegate = self
            serviceBrowser.delegate = self
            
            // 受信開始
            serviceAdvertiser.startAdvertisingPeer()
            
            // 探索開始
            serviceBrowser.startBrowsingForPeers()
            
            application.stuTextAN = nil
            
       }
        
        application.connectFirst = false
        
        
        connectionLabel = LTMorphingLabel(frame: CGRect(x: posX/4, y: posY/14, width: posX/2, height: posY/20))
        connectionLabel.text = "接続台数：0台"
        connectionLabel.font = UIFont.systemFont(ofSize: posX/16)
        connectionLabel.textColor = UIColor.white
        connectionLabel.textAlignment = NSTextAlignment.center
        
        if(application.connectBool == true){
            
            // connectionLabelのラベルに保存
            if (self.serviceSave.object(forKey: "connectionCount") != nil) {
                
                let deviceCount = self.serviceSave.integer(forKey: "connectionCount")
                print("データ有り = \(deviceCount)")
                
                self.connectionLabel.text = "接続台数：\(deviceCount)台"
            }
            else{
                
                self.connectionLabel.text = "接続台数：0台"
            }
        }
        
        self.view.addSubview(connectionLabel)
        
        
        myWindow = UIWindow()
        myWindowButton = UIButton()
        
        formatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
        formatter2.dateFormat = "HH:mm:ss"
        
        normalmessage.setTitle("通常", for: .normal)
        importantmessage.setTitle("重要", for: .normal)
        
        normalmessage.titleLabel?.font = UIFont(name: "TimesNewRomanPSMT", size: 40)
        importantmessage.titleLabel?.font = UIFont(name: "TimesNewRomanPSMT", size: 40)
        
        normalmessage.setTitleColor(UIColor.white, for: .normal)
        importantmessage.setTitleColor(UIColor.white, for: .normal)
        
        normalmessage.setTitleColor(UIColor.gray, for: .highlighted)
        importantmessage.setTitleColor(UIColor.gray, for: .highlighted)
        
        normalmessage.backgroundColor = UIColor.rgb(r:240,g:155,b:132,alpha:1.0)
        importantmessage.backgroundColor = UIColor.rgb(r:138,g:159,b:230,alpha:1.0)
        
        normalmessage.layer.masksToBounds = true
        importantmessage.layer.masksToBounds = true
        
        normalmessage.layer.cornerRadius = posX/20
        importantmessage.layer.cornerRadius = posX/20
        
        normalmessage.frame = CGRect(x:0,y:0,width:self.view.bounds.width/1.2,height:self.view.bounds.height/2.5)
        importantmessage.frame = CGRect(x:0,y:0,width:self.view.bounds.width/1.2,height:self.view.bounds.height/2.5)
        
        normalmessage.layer.position = CGPoint(x:self.view.bounds.width/2,y:self.view.bounds.height/3.0)
        importantmessage.layer.position = CGPoint(x:self.view.bounds.width/2,y:self.view.bounds.height/1.3)
        
        normalmessage.addTarget(self, action: #selector(StudentView.onclickbutton(sender:)), for: .touchUpInside)
        importantmessage.addTarget(self, action: #selector(StudentView.onclickbutton2(sender:)), for: .touchUpInside)
        normalmessage.addTarget(self, action: #selector(StudentView.onclickbutton3(sender:)), for: .touchDown)
        importantmessage.addTarget(self, action: #selector(StudentView.onclickbutton4(sender:)), for: .touchDown)
        
        self.view.backgroundColor = UIColor.rgb(r:230,g:188,b:126,alpha:1.0)
        
        self.view.addSubview(normalmessage)
        self.view.addSubview(importantmessage)
        
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector:#selector(StudentView.time(_:)), userInfo: nil, repeats: true)
        
        // Notificationの表示許可をもらう.
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound]) { (granted, error) in
            
        }

        
        keyButton = UIButton()
        keyButton.frame = CGRect(x: posX/1.2, y: posY/20, width: posX/9, height: posY/14)
        keyButton.layer.masksToBounds = true
        keyButton.layer.cornerRadius = 20.0
        keyButton.setTitleColor(UIColor.black, for: .highlighted)
        keyButton.tag = 2
        keyButton.addTarget(self, action: #selector(StudentView.windowButtonClick(sender:)), for: .touchUpInside)
        keyButton.setImage(buttonImageKey!, for: .normal)
        keyButton.imageView?.contentMode = UIViewContentMode.scaleAspectFit
        self.view.addSubview(keyButton)
        
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // 通常画面に移動
    func onclickbutton(sender:UIButton){
        
        // 次の遷移先のViewControllerインスタンスを生成する
        let vc = NormalView()
        
        // presentViewControllerメソッドで遷移する
        // ここで、animatedをtrueにするとアニメーションしながら遷移できる
        
        UIView.animate(withDuration: 0.06,
                                   
                                   // アニメーション中の処理.
            animations: { () -> Void in
                
                // 縮小用アフィン行列を作成する.
                self.normalmessage.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
                
            })
        { (Bool) -> Void in
            
        }
        
        UIView.animate(withDuration: 0.1,
                                   
                                   // アニメーション中の処理.
            animations: { () -> Void in
                
                // 拡大用アフィン行列を作成する.
                self.normalmessage.transform = CGAffineTransform(scaleX: 0.4, y: 0.4)
                
                // 縮小用アフィン行列を作成する.
                self.normalmessage.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                
            })
        { (Bool) -> Void in
            
        }
        
        self.present(vc, animated: true, completion: nil)
    }
    
    // 重要画面に移動
    func onclickbutton2(sender:UIButton){
        
        /* タイマーを破壊 */
        self.timer.invalidate()
        // 次の遷移先のViewControllerインスタンスを生成する
        let vc = importantView()
        
        // presentViewControllerメソッドで遷移する
        // ここで、animatedをtrueにするとアニメーションしながら遷移できる
        
        UIView.animate(withDuration: 0.1,
                       
                       // アニメーション中の処理.
            animations: { () -> Void in
                
                // 拡大用アフィン行列を作成する.
                self.importantmessage.transform = CGAffineTransform(scaleX: 0.4, y: 0.4)
                
                // 縮小用アフィン行列を作成する.
                self.importantmessage.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                
            })
        { (Bool) -> Void in
            
        }
        
        self.present(vc, animated: true, completion: nil)
    }
    
    // 通常ボタンが押されたら
    func onclickbutton3(sender:UIButton){
        UIView.animate(withDuration: 0.06,
                       
                       // アニメーション中の処理
            animations: { () -> Void in
                
                // 縮小用アフィン行列を作成する
                self.normalmessage.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
                
            })
        { (Bool) -> Void in
            
        }
    }
    
    // 重要ボタンが押されたら
    func onclickbutton4(sender:UIButton){
        UIView.animate(withDuration: 0.06,
                       
                       // アニメーション中の処理.
            animations: { () -> Void in
                
                // 縮小用アフィン行列を作成する.
                self.importantmessage.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
                
            })
        { (Bool) -> Void in
            
        }
    }
    
    func time(_ timer: Timer){
        
    }
    
    func device(eee : [String]){
        
        label.text = String(describing: eee)
        
    }
    
    /*
     UITextFieldが編集された直前に呼ばれる
     */
    func textFieldDidBeginEditing(_ textField: UITextField) {
        print("textFieldDidBeginEditing: \(textField.text!)")
    }
    
    /*
     UITextFieldが編集された直後に呼ばれる
     */
    func textFieldDidEndEditing(_ textField: UITextField) {
        print("textFieldDidEndEditing: \(textField.text!)")
        
        if(textField.tag == 2){
            
            application.serviceTyper = textField.text!
        }
        else if(textField.tag == 3){
            
            application.serviceType = textField.text!
        }
    }
    
    
    // 改行ボタンが押された際に呼ばれる
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print("textFieldShouldReturn \(textField.text!)")
        
        // 改行ボタンが押されたらKeyboardを閉じる処理
        textField.resignFirstResponder()
        
        return true
    }
    
    // UIWindowを表示
    func makeMyWindow(){
        
        let posX = self.view.frame.width
        
        normalmessage.isEnabled = false
        importantmessage.isEnabled = false
        
        // 背景を白に設定する.
        myWindow.frame = CGRect(x:self.view.bounds.width - self.view.bounds.width/1.5, y:self.view.bounds.height/2, width:self.view.bounds.width/1.5, height:self.view.bounds.height/1.5)
        myWindow.layer.position = CGPoint(x:self.view.frame.width/2, y:self.view.frame.height/2)
        
        myWindow.layer.masksToBounds = true
        myWindow.layer.cornerRadius = posX/20
        
        // myWindowをkeyWindowにする.
        myWindow.makeKey()
        
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
        myWindowButton.addTarget(self, action: #selector(StudentView.windowButtonClick(sender:)), for: .touchUpInside)
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
        serviceLabelT = LTMorphingLabel(frame: CGRect(x: windowX/4, y: windowY/6, width: windowX, height: windowY/10))
        serviceLabelT.text = "送信側との接続キー"
        serviceLabelT.font = UIFont.systemFont(ofSize: windowX/15)
        serviceLabelT.textColor = UIColor.rgb(r:240,g:155,b:132,alpha:1.0)
        serviceLabelT.textAlignment = NSTextAlignment.center
        self.myWindow.addSubview(serviceLabelT)
        
        // 先生
        teacherTextField = UITextField(frame: CGRect(x: windowX/10, y: windowY/4, width: windowX/1.2, height: windowY/10))
        teacherTextField.text = ""
        if (serviceSave.object(forKey: "saveType") != nil) {
            print("データ有り")
            
            teacherTextField.text = serviceSave.string(forKey: "saveType")
        }
        else{
            
            teacherTextField.text = application.serviceTyper
            
        }
        teacherTextField.placeholder = "serviceTypeを入力"
        teacherTextField.delegate = self
        teacherTextField.tag = 2
        teacherTextField.borderStyle = .roundedRect
        teacherTextField.clearButtonMode = .whileEditing
        self.myWindow.addSubview(teacherTextField)
        
        // 説明ラベル「生徒」
        serviceLabelS = LTMorphingLabel(frame: CGRect(x: windowX/4, y: windowY/2.5, width: windowX, height: windowY/10))
        serviceLabelS.text = "受信側との接続キー"
        serviceLabelS.font = UIFont.systemFont(ofSize: windowX/15)
        serviceLabelS.textColor = UIColor.rgb(r:138,g:159,b:230,alpha:1.0)
        serviceLabelS.textAlignment = NSTextAlignment.center
        self.myWindow.addSubview(serviceLabelS)
        
        studentTextField = UITextField(frame: CGRect(x: windowX/10, y: windowY/2, width: windowX/1.2, height: windowY/10))
        
        studentTextField.text = ""
        
        // 生徒同士のserviceType
        if (serviceSave.object(forKey: "saveTypeS") != nil) {
            print("データ有り")
            
            studentTextField.text = serviceSave.string(forKey: "saveTypeS")
            
        }
        else {
            
            studentTextField.text = application.serviceType
            
        }
        
        studentTextField.delegate = self
        studentTextField.tag = 3
        studentTextField.borderStyle = .roundedRect
        studentTextField.clearButtonMode = .whileEditing
        self.myWindow.addSubview(studentTextField)
        
        
        
        
    }

    // UIWindowにあるボタンのイベント
    func windowButtonClick(sender:UIButton){
        
        // UIWindowButton
        if(sender.tag == 1){
            
            myWindow.isHidden = true
            
            normalmessage.isEnabled = true
            importantmessage.isEnabled = true
        }
            
        // keyButtn
        else if(sender.tag == 2){
            
            
            makeMyWindow()
            
        }
        
        // 接続キー更新ボタン
        else if(sender.tag == 4){
            
            // 先生と繋ぐのに使うserviceTypeを保存
            serviceSave.set(application.serviceTyper, forKey: "saveType")
            
            serviceSave.set(application.serviceType, forKey: "saveTypeS")
            
            myWindow.isHidden = true
            
            normalmessage.isEnabled = true
            importantmessage.isEnabled = true
            
            
            application.connectFirst = true
            
            // viewDidLoadをリロード
            loadView()
            viewDidLoad()
        }
        
        
        
        
    }
    
    // 接続されている端末が変わったら呼び出される
    func connectedDevicesChanged(connectedDevices: [String]) {
        OperationQueue.main.addOperation {
            print("接続 = \(connectedDevices)")
            
            self.serviceSave.set(connectedDevices.count, forKey: "connectionCount")
            
            self.application.connectBool = true
            
            self.connectionLabel.text = "接続台数：\(connectedDevices.count)台"
            
            
            
            /*
            let alert:UIAlertView? = UIAlertView(title: "接続されました",message: "接続端末：\(connectedDevices)", delegate: self as? UIAlertViewDelegate, cancelButtonTitle: nil, otherButtonTitles: "OK")
            alert?.show()
            */
            
        }
    }
    
    // 受信した時に呼ばれるメソッド
    func colorChanged( colorString: String) {
        OperationQueue.main.addOperation {
            
            if(self.application.backHome == true){
                
                // アラート
                self.alertView(colorString)
                
                
            }
            else{
                
                self.showNotification(colorString)
                
            }
            
        }
    }
    
    // 生徒に送る関数
    func sendStudent(sendMessage : String){
        NSLog("%@", "sendColor: \(sendMessage) to \(session.connectedPeers.count) peers")
        
        // このセッションに現在接続しているすべてのピアの配列の数が０以上なら条件に入る
        if session.connectedPeers.count > 0 {
            do {
                /* NSDataオブジェクトにカプセル化(オブジェクトの内部のデータ、振る舞い、
                 実際の型を隠蔽(隠す))されたメッセージを近くのピアに送信します。 */
                try self.session.send(sendMessage.data(using: .utf8)!, toPeers: session.connectedPeers, with: .reliable)
                
                // data : 送信するメッセージを含むオブジェクト。
                // toPeers : メッセージを受け取るべきピアを表すピアIDオブジェクトの配列。
                // with(mode) : 使用する伝送モード（信頼性の高いまたは信頼できない配信）。
                
            }
            catch let error {
                NSLog("%@", "Error for sending: \(error)")
            }
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
        NSLog("受信したデータ : \(data) どこ？：\(String(describing: application.stuTextAN))")
        let str = String(data: data, encoding: .utf8)!
        
        
        
        if(firstmessage == 1){
            
            
            
            colorChanged(colorString: str)
            sendStudent(sendMessage: str)
            
            //データの追加（通常）
            let db = FMDatabase(path: DatabaseClass().table2)
            let sql = "INSERT INTO sample2 (name) VALUES (?);"
            
            db?.open()
            
            // ?で記述したパラメータの値を渡す場合
            db?.executeUpdate(sql, withArgumentsIn: [str])
            // print("データベース　＝　\(db!)")
            db?.close()
            
            firstmessage = 0
        }
            
        else if(firstmessage == 2){
            
            
            colorChanged(colorString: str)
            sendStudent(sendMessage: str)
            
            //内容が来た時
            //データの追加（重要）
            let db = FMDatabase(path: DatabaseClass().table3)
            let sql = "INSERT INTO sample3 (name) VALUES (?);"
            
            db?.open()
            // ?で記述したパラメータの値を渡す場合
            db?.executeUpdate(sql, withArgumentsIn: [str])
            // print("データベース　＝　\(db!)")
            db?.close()
            
            firstmessage = 0
        }
        
        // trueならfirstmessageを1
        if(str == "true")
        {
            firstmessage = 1
            sendbool = true
            
        }
        
        // trueならfirstmessageを2
        else if(str == "false"){
            firstmessage = 2
            sendbool = false
        }

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
    
    // 通知
    func showNotification(_ message: String) {
        
        // Notificationを生成.
        let content = UNMutableNotificationContent()
        
        // Titleを代入する.
        content.title = "先生からの連絡"
        
        var com = message
        let startIndex = com.characters.index(of: "@")
        let endIndex = com.index(startIndex!, offsetBy: 1)
        let range = startIndex!..<endIndex
        
        if(sendbool == true) {
            com.remove(at: startIndex!)
        }
        else{
            
            com.replaceSubrange(range, with: "　　")
        }
        
        // Bodyを代入する.
        content.body = com
        
        // 音を設定する.
        content.sound = UNNotificationSound.default()
        
        // Requestを生成する.
        let request = UNNotificationRequest.init(identifier: "Title1", content: content, trigger: nil)
        
        // Noticationを発行する.
        let center = UNUserNotificationCenter.current()
        center.add(request) { (error) in
            print("通知エラー : \(String(describing: error))")
        }
    }
    
    // アプリ内の時はAlertControllerで表示
    func alertView(_ comment : String){
        
        var com = comment
        let startIndex = com.characters.index(of: "@")
        let endIndex = com.index(startIndex!, offsetBy: 1)
        let range = startIndex!..<endIndex
        
        if(sendbool == true) {
            com.remove(at: startIndex!)
        }
        else{
            
            com.replaceSubrange(range, with: "　　")
        }
        
        
        
        let alert:UIAlertView? = UIAlertView(title: "先生からの連絡",message: "\(com)", delegate: self as? UIAlertViewDelegate, cancelButtonTitle: nil, otherButtonTitles: "OK")
        alert?.show()
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
