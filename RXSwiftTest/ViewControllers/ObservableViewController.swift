//
//  ObservableViewController.swift
//  RXSwiftTest
//
//  Created by 黄敬 on 2018/8/24.
//  Copyright © 2018年 hj. All rights reserved.
//

import UIKit
import RxSwift

class ObservableViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.view.backgroundColor = UIColor.white
        
        let textField = UITextField.init(frame: CGRect(x: 0, y: 84, width: 200, height: 40))
        self.view.addSubview(textField)
        
        let alertLabel = UILabel.init(frame: CGRect(x: 0, y: 150, width: 200, height: 40))
        alertLabel.text = "最少3个字"
        self.view.addSubview(alertLabel)
        /*
        textField.rx.text.orEmpty.asObservable().map {
            $0.characters.count >= 3
        }.bind(to: alertLabel.rx.isHidden)
*/
        textField.rx.text.orEmpty.asObservable().map { (str) -> Bool in
            return str.count >= 3
        }.bind(to: alertLabel.rx.isHidden)
        
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
