//
//  ViewController.swift
//  聴覚支援学校
//
//  Created by 清水直輝 on 2017/03/12.
//  Copyright © 2017年 清水直輝. All rights reserved.
//


import UIKit
//import LTMorphingLabel

// LTMorphingLabelDelegateを追加（これで機能を使えるようになる
class ViewController2: UIViewController, LTMorphingLabelDelegate {
    
    let _myLabel = LTMorphingLabel()
    var teachButton = ZFRippleButton()
    var studentButton = ZFRippleButton()
    var teachImage : UIImageView!
    var studentImage : UIImageView!
    var timer1 : Timer!
    var i:Int! = 0
    
    let application : AppDelegate = UIApplication.shared.delegate as! AppDelegate
    
    /**
     インスタンス化された時に動作する（初回のみ
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        
        teachButton = ZFRippleButton()
        studentButton = ZFRippleButton()
        
        teachButton.setTitle("先生", for: .normal)
        studentButton.setTitle("生徒", for: .normal)
        
        teachButton.titleLabel?.font = UIFont(name: "TimesNewRomanPSMT", size: 40)
        studentButton.titleLabel?.font = UIFont(name: "TimesNewRomanPSMT", size: 40)
        
        teachButton.setTitleColor(UIColor.white, for: .normal)
        studentButton.setTitleColor(UIColor.white, for: .normal)
        
        teachButton.setTitleColor(UIColor.gray, for: .highlighted)
        studentButton.setTitleColor(UIColor.gray, for: .highlighted)
        
        teachButton.backgroundColor = UIColor.rgb(r:240,g:155,b:132,alpha:1.0)
        studentButton.backgroundColor = UIColor.rgb(r:240,g:155,b:132,alpha:1.0)
        
        teachButton.frame = CGRect(x:0,y:0,width:self.view.bounds.width/2,height:self.view.bounds.height/10)
        studentButton.frame = CGRect(x:0,y:0,width:self.view.bounds.width/2,height:self.view.bounds.height/10)
        
        teachButton.layer.position = CGPoint(x:self.view.bounds.width/4,y:self.view.bounds.height/4)
        studentButton.layer.position = CGPoint(x:self.view.bounds.maxX-self.view.bounds.width/4,y:self.view.bounds.height/1.75)
        
        teachButton.addTarget(self, action: #selector(ViewController2.onclickbutton(sender:)), for: .touchUpInside)
        studentButton.addTarget(self, action: #selector(ViewController2.onclickbutton2(sender:)), for: .touchUpInside)
        
        teachButton.buttonCornerRadius = 10
        studentButton.buttonCornerRadius = 10
        
        self.view.addSubview(teachButton)
        self.view.addSubview(studentButton)
        
        // UIImageViewを作成.
        teachImage = UIImageView(frame: CGRect(x:0,y:0,width:self.view.bounds.width/2.25,height:self.view.bounds.height/5))
        
        teachImage.layer.position = CGPoint(x:self.view.bounds.maxX-self.view.bounds.width/4,y:self.view.bounds.height/4)
        
        // UIImageを作成.
        let myImage: UIImage = UIImage(named: "先生.png")!
        
        teachImage.backgroundColor = UIColor.white
        
        teachImage.layer.masksToBounds = true
        
        teachImage.layer.cornerRadius = 60
        
        // 画像をUIImageViewに設定する.
        teachImage.image = myImage
        
        self.view.addSubview(teachImage)
        
        // UIImageViewを作成.
        studentImage = UIImageView(frame: CGRect(x:0,y:0,width:self.view.bounds.width/2.25,height:self.view.bounds.height/5))
        
        studentImage.layer.position = CGPoint(x:self.view.bounds.width/4,y:self.view.bounds.height/1.75)
        
        // UIImageを作成.
        let myImage2: UIImage = UIImage(named: "生徒.png")!
        
        studentImage.backgroundColor = UIColor.white
        
        studentImage.layer.masksToBounds = true
        
        studentImage.layer.cornerRadius = 60
        
        // 画像をUIImageViewに設定する.
        studentImage.image = myImage2
        
        self.view.addSubview(studentImage)
        
        // ラベルの位置
        _myLabel.frame = CGRect(x:0,y:0,width:self.view.bounds.width,height:100)
        // ラベルをセンターに
        _myLabel.textAlignment = NSTextAlignment.center
        // ラベル内の文字数が多すぎて表示しきれない時に文字サイズを小さくするかどうか
        _myLabel.adjustsFontSizeToFitWidth = true
        // 文字サイズ
        _myLabel.font = UIFont(name: "TimesNewRomanPSMT", size: 30)
        
        _myLabel.layer.position = CGPoint(x:self.view.bounds.width/2,y:self.view.bounds.maxY-75)
        // エフェクト選択
        _myLabel.morphingEffect = .sparkle
        // テキストに文字
        self._myLabel.text = "どちらか選んでください"
        // 最下層のviewを黒に
        self.view.backgroundColor = UIColor.rgb(r:230,g:188,b:126,alpha:1.0)
        // テキストカラーを白に
        _myLabel.textColor = UIColor.white
        
        // viewにラベルを
        self.view.addSubview(_myLabel)
        
        timer1 = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.update), userInfo: nil, repeats: true)
        timer1.fire()
        
    }
    
    func degreesToRadians(degrees: Float) -> Float {
        return degrees * Float(M_PI) / 180.0
    }
    
    func update(sender:Timer){
        i=i+1
        if(i<=2){
            vibrated(vibrated: true, view: teachImage)
            vibrated(vibrated: true, view: studentImage)
        }
        else if(i>2){
            timer1.invalidate()
        }
    }
    
    func vibrated(vibrated:Bool, view: UIView) {
        if vibrated {
            var animation: CABasicAnimation
            animation = CABasicAnimation(keyPath: "transform.rotation")
            animation.duration = 0.45
            animation.fromValue = degreesToRadians(degrees: 15.0)
            animation.toValue = degreesToRadians(degrees: -15.0)
            animation.repeatCount = Float.infinity
            animation.autoreverses = true
            view.layer .add(animation, forKey: "VibrateAnimationKey")
        }
        else {
            view.layer.removeAnimation(forKey: "VibrateAnimationKey")
        }
    }
    
    func onclickbutton (sender:UIButton){
        // 次の遷移先のViewControllerインスタンスを生成する
        
        
        let defaults = UserDefaults.standard
        if defaults.bool(forKey: "deside") {
            
            let vc = TeachView()
            
            let className = UserDefaults.standard
            className.set("TeachView", forKey: "className")
            className.synchronize()
            
            // presentViewControllerメソッドで遷移する
            // ここで、animatedをtrueにするとアニメーションしながら遷移できる
            self.present(vc, animated: true, completion: nil)
            
            defaults.set(false, forKey: "deside")
        }
        
        
    }
    
    func onclickbutton2 (sender:UIButton){
        
        let defaults = UserDefaults.standard
        if defaults.bool(forKey: "deside") {
            
            // 次の遷移先のViewControllerインスタンスを生成する
            let vc = StudentView()
            
            let className = UserDefaults.standard
            className.set("StudentView", forKey: "className")
            className.synchronize()
            
            // presentViewControllerメソッドで遷移する
            // ここで、animatedをtrueにするとアニメーションしながら遷移できる
            self.present(vc, animated: true, completion: nil)
            
            defaults.set(false, forKey: "deside")
        }
        
        
    }
    // ボタンを押すとライブラリのテキストエフェクト開始
    
    /*
     memory warning
     */
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}


