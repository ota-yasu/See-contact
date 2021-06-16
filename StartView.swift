//
//  StartView.swift
//  animation practice
//
//  Created by 恭弘 on 2017/01/21.
//  Copyright © 2017年 恭弘. All rights reserved.
//

import UIKit
//import LTMorphingLabel

class StartView: UIViewController {
    
    private var myView: UIView!
    private var myButton: UIButton!
    var timer: Timer!
    var ColorValue : CGFloat! = 0
    private var myImageView: UIImageView!
    let StartLabel = LTMorphingLabel()
    
    // View切り替え用フラグ.
    var viewFlag = true
    
    let application : AppDelegate = UIApplication.shared.delegate as! AppDelegate
    
    
    let idValue = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
            
            // 背景を青色に設定.
            self.view.backgroundColor = UIColor.black
        
        // UIImageViewを作成.
        myImageView = UIImageView(frame: CGRect(x:0,y:0,width:self.view.bounds.width/1.1,height:self.view.bounds.height/2.2))
        
        myImageView.layer.position = CGPoint(x:self.view.bounds.width/2,y:self.view.bounds.height/2)
        
        // UIImageを作成.
        let myImage: UIImage = UIImage(named: "聴覚支援学校の起動時の画像.png")!
        
        myImageView.alpha = 0
        
        // 画像をUIImageViewに設定する.
        myImageView.image = myImage
        
        self.view.addSubview(myImageView)
        
        timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(self.update), userInfo: nil, repeats: true)
        timer.fire()
        
        // ラベルの位置
        StartLabel.frame = CGRect(x:0,y:0,width:self.view.bounds.width,height:100)
        // ラベルをセンターに
        StartLabel.textAlignment = NSTextAlignment.center
        // ラベル内の文字数が多すぎて表示しきれない時に文字サイズを小さくするかどうか
        StartLabel.adjustsFontSizeToFitWidth = true
        // 文字サイズ
        StartLabel.font = UIFont(name: "TimesNewRomanPSMT", size: 40)
        
        StartLabel.layer.position = CGPoint(x:self.view.bounds.width/2,y:self.view.bounds.height-self.view.bounds.height/5)
        
        StartLabel.alpha = 0
        // テキストに文字
        self.StartLabel.text = "学校生活をよりよく"
        // テキストカラーを白に
        StartLabel.textColor = UIColor.rgb(r:240,g:155,b:132,alpha:1.0)
        
        // viewにラベルを
        self.view.addSubview(StartLabel)
        
        
        // 初期化処理
        let first = UserDefaults.standard
        if(first.object(forKey: "firstLaunch") as! Bool == true){
            
            idValue.set(0, forKey: "arrayID")
            idValue.set(0, forKey: "dataID")
            
            first.set(false, forKey: "firstLaunch")
            
        }
        
        }
    
        func update(tm: Timer) {
        // do something
            
            ColorValue = ColorValue + 0.01
            if (ColorValue >= 0.5){
                myImageView.alpha = myImageView.alpha + 0.05
                StartLabel.alpha = StartLabel.alpha + 0.05
            }
            if (ColorValue >= 0.8){
            // エフェクト選択
                StartLabel.morphingEffect = .sparkle
            }
            self.view.backgroundColor = UIColor.rgb(r:230,g:188,b:126,alpha: ColorValue)
            if (ColorValue >= 1){
                timer.invalidate()
                timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.update2), userInfo: nil, repeats: true)
                timer.fire()
                ColorValue = 0

            }
        }
    
        func update2(tm: Timer){
            ColorValue = ColorValue + 1
            if(ColorValue == 3){
                timer.invalidate()
                myImageView.isHidden = true
                // 次の遷移先のViewControllerインスタンスを生成する
                
                let n = UserDefaults.standard
                
                if(n.bool(forKey: "deside") == false){
                    
                    
                    if(n.string(forKey: "className") == "TeachView"){
                        
                        let vc = TeachView()
                        
                        // presentViewControllerメソッドで遷移する
                        // ここで、animatedをtrueにするとアニメーションしながら遷移できる
                        self.present(vc, animated: true, completion: nil)
                    }
                    else{
                        
                        let vc = StudentView()
                        
                        
                        
                        // presentViewControllerメソッドで遷移する
                        // ここで、animatedをtrueにするとアニメーションしながら遷移できる
                        self.present(vc, animated: true, completion: nil)
                    }
                }
                else{
                    
                    let vc = ViewController2()
                    
                    
                    
                    // presentViewControllerメソッドで遷移する
                    // ここで、animatedをtrueにするとアニメーションしながら遷移できる
                    self.present(vc, animated: true, completion: nil)
                }
                
                
                
            }
        }
    
        override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
        }
}
