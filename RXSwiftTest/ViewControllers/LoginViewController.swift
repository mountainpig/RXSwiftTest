//
//  LoginViewController.swift
//  RXSwiftTest
//
//  Created by 黄敬 on 2018/8/28.
//  Copyright © 2018年 hj. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class LoginViewController: UIViewController {
    
    let disposeBag = DisposeBag() //负责销毁
    let accountTextField : UITextField = UITextField.init(frame: CGRect(x: 30, y: 100, width: 100, height: 40));
    let accountAlertLabel = UILabel.init(frame: CGRect(x: 140, y: 100, width: 200, height: 40))
    let passwordTextField = UITextField.init(frame: CGRect(x: 30, y: 160, width: 100, height: 40))
    let loginBtn = UIButton.init(frame: CGRect(x: 30, y: 220, width: 100, height: 40))

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.createUI()
        // Do any additional setup after loading the view.
        
        let usernameValid = accountTextField.rx.text.orEmpty.asObservable().map { (accountText) -> Bool in
            return accountText.count == 11;
        }.share(replay: 1)
        
        usernameValid.bind(to: accountAlertLabel.rx.isHidden).disposed(by: disposeBag)
        
        let passwordValid = passwordTextField.rx.text.orEmpty.asObservable().map { (passwordText) -> Bool in
            return passwordText.count >= 6;
        }
        
        let loginBtnValid = Observable.combineLatest(usernameValid,passwordValid) {
            $0 && $1
        }
        
        loginBtnValid.bind(to: loginBtn.rx.isEnabled).disposed(by: disposeBag)

        loginBtnValid.map({ (isEnable) -> NSMutableAttributedString in
            let attributeString = NSMutableAttributedString(string: "登录")
            attributeString.addAttribute(NSAttributedStringKey.foregroundColor,
                                         value: isEnable ? UIColor.black : UIColor.white, range: NSMakeRange(0, 2))
            return attributeString
        }).bind(to: loginBtn.rx.attributedTitle()).disposed(by: disposeBag)
        
        loginBtn.rx.tap.asObservable().bind {
            print("tap") }.disposed(by: disposeBag)
        
    }
    
    func createUI() {
        accountTextField.layer.borderWidth = 1
        accountTextField.layer.borderColor = UIColor.red.cgColor
        accountTextField.placeholder = "手机号码"
        self.view.addSubview(accountTextField);

        accountAlertLabel.text = "输入11位手机号"
        self.view.addSubview(accountAlertLabel)

        passwordTextField.layer.borderWidth = 1
        passwordTextField.layer.borderColor = UIColor.red.cgColor
        passwordTextField.placeholder = "密码"
        self.view.addSubview(passwordTextField);
        
        loginBtn.backgroundColor = UIColor.red
        loginBtn.setTitle("登录", for: UIControlState.normal)
        self.view.addSubview(loginBtn)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
