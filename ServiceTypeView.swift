//
//  ServiceTypeView.swift
//  peer
//
//  Created by 清水直輝 on 2017/05/01.
//  Copyright © 2017年 清水直輝. All rights reserved.
//

import UIKit
class ServiceTypeClass: UIViewController, UITextFieldDelegate {
    
    let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
    
    
    private var myTextField: UITextField!
    private var myButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let posX: CGFloat = self.view.bounds.width
        let posY: CGFloat = self.view.bounds.height
        
        myTextField = UITextField(frame: CGRect(x: posX/4, y: posY/2, width: posX/2, height: posY/15))
        myTextField.text = ""
        myTextField.placeholder = "serviceTypeを入力"
        myTextField.delegate = self
        myTextField.borderStyle = .roundedRect
        myTextField.clearButtonMode = .whileEditing
        self.view.addSubview(myTextField)

        self.view.backgroundColor = UIColor.white
        
        
        myButton = UIButton()
        myButton.frame = CGRect(x: posX/2, y: posY/1.5, width: posX/2, height: posY/12)
        myButton.backgroundColor = UIColor.red
        myButton.layer.masksToBounds = true
        myButton.layer.cornerRadius = 20.0
        myButton.setTitle("ボタン(通常)", for: .normal)
        myButton.setTitleColor(UIColor.white, for: .normal)
        myButton.setTitle("ボタン(押された時)", for: .highlighted)
        myButton.setTitleColor(UIColor.black, for: .highlighted)
        myButton.tag = 1
        myButton.addTarget(self, action: #selector(ServiceTypeClass.onClickMyButton(sender:)), for: .touchUpInside)
        self.view.addSubview(myButton)
    }
    
    func onClickMyButton(sender:UIButton){
        
        let vc = TeachView()
        
        // presentViewControllerメソッドで遷移する
        // ここで、animatedをtrueにするとアニメーションしながら遷移できる
        self.present(vc, animated: true, completion: nil)
        
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
        
        appDelegate.serviceTyper = textField.text!
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
}
