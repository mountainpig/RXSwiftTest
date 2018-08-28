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


class ViewController: UIViewController,UITableViewDelegate {
    
    var tableView : UITableView! = nil
    
    let courseListViewModel = CourseListViewModel() //数据源
    
    let disposeBag = DisposeBag() //负责销毁
    
    let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, Course>>(
        configureCell: { (_, tv, indexPath, element) in
            let cell = tv.dequeueReusableCell(withIdentifier: "courseCell")!
            cell.textLabel?.text = "\(element.name) @ row \(indexPath.row)"
            return cell
    },
        titleForHeaderInSection: { dataSource, sectionIndex in
            return dataSource[sectionIndex].model
    }
    )

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView = UITableView.init(frame: self.view.bounds)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "courseCell")
        self.view.addSubview(tableView)
        
        
        
        let dataSource = self.dataSource
        
        let items = Observable.just([
            SectionModel(model: "First section", items: [
                Course(name: "ObservableViewController"),
                Course(name: "LoginViewController"),
                Course(name: "ObservableViewController")
                ]),
            SectionModel(model: "Second section", items: [
                Course(name: "ObservableViewController"),
                Course(name: "ObservableViewController"),
                Course(name: "ObservableViewController")
                ]),
            SectionModel(model: "Third section", items: [
                Course(name: "ObservableViewController"),
                Course(name: "ObservableViewController"),
                Course(name: "ObservableViewController")
                ])
            ])
        
        
        
        items.bind(to: tableView.rx.items(dataSource: dataSource)).disposed(by: disposeBag)
        

        
        tableView.rx
            .itemSelected
            .map { indexPath in
                return (indexPath, dataSource[indexPath])
            }
            .subscribe(onNext: { pair in
                let clz = NSClassFromString("RXSwiftTest." +  pair.1.name) as! UIViewController.Type
                let viewController = clz.init()
                self.navigationController?.pushViewController(viewController, animated: true)
                
            })
            .disposed(by: disposeBag)
        
        tableView.rx
            .setDelegate(self)
            .disposed(by: disposeBag)
        

        /*
         courseListViewModel.data.bind(to: tableView.rx.items(cellIdentifier:"courseCell")) { _, course, cell in
         cell.textLabel?.text = course.name
         }.disposed(by: disposeBag)
         
         tableView.rx.modelSelected(Course.self).subscribe(onNext: { course in
         print("你选中的信息\(course.name)")
         
         let clz = NSClassFromString("RXSwiftTest." + course.name) as! UIViewController.Type
         let viewController = clz.init()
         self.navigationController?.pushViewController(viewController, animated: true)
         
         }).disposed(by: disposeBag)
         
         */
        

 

    }

    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return .none
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

