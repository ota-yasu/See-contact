//
//  ViewController.swift
//  peer
//
//  Created by 清水直輝 on 2017/04/02.
//  Copyright © 2017年 清水直輝. All rights reserved.
//

import UIKit
import MultipeerConnectivity

class ColorSwitchViewController: UIViewController {
    
    // クラスのインスタンス(クラス（設計図）を具現化したもの（実体）)を作成
    let colorService = ColorServiceManager()
    
    // 接続した端末を表示するラベル
    @IBOutlet weak var connectionsLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        colorService.delegate = self
    }
    
    @IBAction func redTapped() {
        
        self.change(color: .red)
        colorService.send(colorName: "red")
    }
    
    @IBAction func yellowTapped() {
        
        self.change(color: .yellow)
        colorService.send(colorName: "yellow")
    }
    
    
    // アニメーションを加えながら背景色を変えるメソッド
    func change(color : UIColor) {
        UIView.animate(withDuration: 0.2) {
            self.view.backgroundColor = color
        }
    }
    
}

extension ColorSwitchViewController : ColorServiceManagerDelegate {
    
    // 接続されている端末が変わったら呼び出される
    func connectedDevicesChanged(manager: ColorServiceManager, connectedDevices: [String]) {
        OperationQueue.main.addOperation {
            self.connectionsLabel.text = "Connections: \(connectedDevices)"
        }
    }
    
    func colorChanged(manager: ColorServiceManager, colorString: String) {
        OperationQueue.main.addOperation {
            switch colorString {
            case "red":
                self.change(color: .red)
            case "yellow":
                self.change(color: .yellow)
            default:
                NSLog("%@", "Unknown color value received: \(colorString)")
            }
        }
    }
    
}

class ColorServiceManager : NSObject{
    
    // serviceTypeの値を設定
    private let ColorServiceType = "con-school"
    
    // peer
    private let myPeerId = MCPeerID(displayName: UIDevice.current.name)
    
    private let serviceAdvertiser : MCNearbyServiceAdvertiser
    private let serviceBrowser : MCNearbyServiceBrowser
    
    lazy var session : MCSession = {
        let session = MCSession(peer: self.myPeerId, securityIdentity: nil, encryptionPreference: .required)
        session.delegate = self
        return session
    }()
    
    
    var delegate : ColorServiceManagerDelegate?
    
    // オブジェクトが生成されたら呼ばれる
    override init() {
        
        self.serviceAdvertiser = MCNearbyServiceAdvertiser(peer: myPeerId, discoveryInfo: nil, serviceType: ColorServiceType)
        self.serviceBrowser = MCNearbyServiceBrowser(peer: myPeerId, serviceType: ColorServiceType)
        
        super.init()
        
        self.serviceAdvertiser.delegate = self
        
        // 受信開始
        self.serviceAdvertiser.startAdvertisingPeer()
        
        self.serviceBrowser.delegate = self
        
        // 探索開始
        self.serviceBrowser.startBrowsingForPeers()
    }
    
    // オブジェクトが破棄されたら呼ばれる
    deinit {
        
        // 受信終了
        self.serviceAdvertiser.stopAdvertisingPeer()
        
        // 探索終了
        self.serviceBrowser.stopBrowsingForPeers()
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
    
}

extension ColorServiceManager : MCNearbyServiceAdvertiserDelegate {
    
    //アドバタイズが開始できなかった場合に呼ばれる，エラー処理をここに書く
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didNotStartAdvertisingPeer error: Error) {
        NSLog("%@", "didNotStartAdvertisingPeer: \(error)")
    }
    
    //他端末から招待を受けた時に呼ばれる(実装必須)
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        NSLog("%@", "didReceiveInvitationFromPeer \(peerID)")
        
        //招待への返答(true/false)
        invitationHandler(true, self.session)
    }
    
}

extension ColorServiceManager : MCNearbyServiceBrowserDelegate {
    
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
    
}


extension ColorServiceManager : MCSessionDelegate {
    
    // 近くのピアの状態が変更されたときに呼び出されます。
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        NSLog("%@", "peer \(peerID) didChangeState: \(state)")
        self.delegate?.connectedDevicesChanged(manager: self, connectedDevices:
            session.connectedPeers.map{$0.displayName})
    }
    
    //近くのピアからNSDataオブジェクトが受信されたことを示します。
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        NSLog("%@", "didReceiveData: \(data)")
        let str = String(data: data, encoding: .utf8)!
        self.delegate?.colorChanged(manager: self, colorString: str)
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
    
}

// UIにサービスイベントを通知する
protocol ColorServiceManagerDelegate {
    
    func connectedDevicesChanged(manager : ColorServiceManager, connectedDevices: [String])
    func colorChanged(manager : ColorServiceManager, colorString: String)
    
}





