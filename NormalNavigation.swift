//
//  NormalNavigation.swift
//  聴覚支援学校
//
//  Created by 清水直輝 on 2017/03/14.
//  Copyright © 2017年 清水直輝. All rights reserved.
//

import UIKit

class NormalNavigation : UIViewController {
    
    let application : AppDelegate = UIApplication.shared.delegate as! AppDelegate
    
    // アニメーションボタン
    var tourokubutton = ZFRippleButton()
    
    let buttonImageKey :UIImage? = UIImage(named:"リターン-50.png")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let width = self.view.frame.width
        let height = self.view.frame.height
        
        var text = application.navigationText
        
        
        
        
        let startIndex = text.index(text.startIndex, offsetBy: 0)
        text.remove(at: startIndex)
        
        // TextView生成する.
        let myTextView: UITextView = UITextView(frame: CGRect(x:width/12, y:height/5, width:width/1.2, height:height/1.5))
        
        // TextViewの背景を黃色に設定する.
        myTextView.backgroundColor = UIColor.white
        
        // 表示させるテキストを設定する.
        myTextView.text = text
        myTextView.layer.masksToBounds = true
        myTextView.layer.cornerRadius = 20.0
        myTextView.layer.borderWidth = 1
        myTextView.layer.borderColor = UIColor.black.cgColor
        myTextView.font = UIFont.systemFont(ofSize: width/15)
        myTextView.textColor = UIColor.black
        myTextView.textAlignment = NSTextAlignment.left
        myTextView.dataDetectorTypes = UIDataDetectorTypes.all
        myTextView.isEditable = false
        self.view.addSubview(myTextView)
        
        let label: UILabel = UILabel(frame: CGRect(x: width/9, y: height/8, width: width/1.3, height: height/20))
        label.textColor = UIColor.white
        label.font = UIFont.systemFont(ofSize: width/15)
        label.text = "先生からのメッセージ"
        label.textAlignment = NSTextAlignment.center
        self.view.addSubview(label)
        
        
        //tourokubutton.setTitle("戻る",for: .normal)
        //tourokubutton.titleLabel?.font = UIFont(name: "TimesNewRomanPSMT", size: width/8)
        tourokubutton.setTitleColor(UIColor.rgb(r:138,g:159,b:230,alpha:1.0), for: .normal)
        //tourokubutton.titleLabel?.font = UIFont.systemFont(ofSize: width/15)
        // tourokubutton.backgroundColor = UIColor.rgb(r:138,g:159,b:230,alpha:1.0)
        tourokubutton.setImage(buttonImageKey!, for: .normal)
        tourokubutton.imageView?.contentMode = UIViewContentMode.scaleAspectFit
        tourokubutton.frame = CGRect(x:width/40,y:height/20,width:self.view.bounds.width/7,height:self.view.bounds.height/15)
        tourokubutton.addTarget(self, action: #selector(NormalNavigation.onclickbutton(sender:)), for: .touchUpInside)
        self.view.addSubview(tourokubutton)
        
        // Viewの背景色を定義する.
        self.view.backgroundColor = UIColor.green
        
        // 背景色
        self.view.backgroundColor = UIColor.rgb(r: 230, g: 188, b: 126, alpha: 1.0)
        
    }
    
    func onclickbutton(sender : UIButton){
        
        // viewを閉じる
        self.dismiss(animated: true, completion: nil)
     
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
