//
//  ViewController.swift
//  FontList
//
//  Created by Ming on 2020/7/14.
//  Copyright © 2020 Hiuson. All rights reserved.
//

import UIKit

class FontListViewController: UIViewController {
    
    private var dataList: Array<Section> = []
    
    init() {
        super.init(nibName: nil, bundle: nil)
        title = "Font List"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadData()
        view.addSubview(tableView)
        tableView.reloadData()
    }
    
    override func viewDidLayoutSubviews() {
        tableView.frame = view.bounds
        print(tableView.contentInset)
    }
    
    func loadData() {
        dataList = UIFont.familyNames.map {
            Section(title: $0, contents: UIFont.fontNames(forFamilyName: $0).compactMap {
                UIFont(name: $0, size: 20)
            })
        }
    }

    private lazy var tableView: UITableView = {
        let tableView = UITableView.init(frame: self.view.bounds, style: .grouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.sectionHeaderHeight = 20
        return tableView
    }()
    
    required init?(coder: NSCoder) {
           fatalError("init(coder:) has not been implemented")
    }
}

extension FontListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.dataList.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.dataList[section].title
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataList[section].contents.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let font = self.dataList[indexPath.section].contents[indexPath.row]
        cell.textLabel?.font = font
        cell.textLabel?.text = "\(font.fontName)\n124578ABWIHLabwhil\nZCXWAjkads3690-"
        cell.textLabel?.numberOfLines = 3
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let font = self.dataList[indexPath.section].contents[indexPath.row]
        let vc = GlyphsViewController(UIFont(name: font.fontName, size: 200) ?? font)
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

struct Section {
    var title: String
    var contents : Array<UIFont>
}
