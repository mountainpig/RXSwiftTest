//
//  ViewController.swift
//  RXSwiftTest
//
//  Created by 黄敬 on 2018/8/24.
//  Copyright © 2018年 hj. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

struct Course {
    let name: String
    init(name: String) {
        self.name = name
    }
}

struct CourseListViewModel {
    let data = Observable.just([
        Course(name: "ObservableViewController"),
        Course(name: "ObservableViewController"),
        Course(name: "ObservableViewController"),
        Course(name: "ObservableViewController"),
        ])
}


class ViewController: UIViewController {
    
    var tableView : UITableView! = nil
    
    let courseListViewModel = CourseListViewModel() //数据源
    
    let disposeBag = DisposeBag() //负责销毁

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView = UITableView.init(frame: self.view.bounds)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "courseCell")
        self.view.addSubview(tableView)
        
        courseListViewModel.data.bind(to: tableView.rx.items(cellIdentifier:"courseCell")) { _, course, cell in
            cell.textLabel?.text = course.name
            }.disposed(by: disposeBag)
        
        tableView.rx.modelSelected(Course.self).subscribe(onNext: { course in
            print("你选中的信息\(course.name)")
            
            let clz = NSClassFromString("RXSwiftTest." + course.name) as! UIViewController.Type
            let viewController = clz.init()
            self.navigationController?.pushViewController(viewController, animated: true)
            
        }).disposed(by: disposeBag)
     
//        let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String,Course>>()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

