//
//  GlyphsViewController.swift
//  FontList
//
//  Created by Ming on 2020/7/20.
//  Copyright © 2020 Hiuson. All rights reserved.
//

import UIKit
import SnapKit

class GlyphsViewController: UIViewController {

    private let orginalFont: UIFont
    
    init(_ font: UIFont) {
        orginalFont = font
        super.init(nibName: nil, bundle: nil)
        title = font.fontName
        navigationItem.rightBarButtonItem = rightNavBarBtn
    }
     
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white

        view.addSubview(backLinesView)
        view.addSubview(containerScrollView)
        containerScrollView.addSubview(contentView)
        contentView.addSubview(fontLabel)
        
        
        //奇怪的layout
        containerScrollView.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalTo(view)
        }
        
        contentView.snp.makeConstraints { (make) in
            make.edges.equalTo(containerScrollView)
            make.centerY.equalTo(containerScrollView)
        }
        
        backLinesView.snp.makeConstraints { (make) in
            make.top.equalTo(fontLabel)
            make.leading.trailing.equalToSuperview()
        }
        
        fontLabel.snp.makeConstraints { (make) in
            make.leading.trailing.centerY.equalTo(contentView)
        }
    }
    
    private lazy var containerScrollView: UIScrollView = {
        let view = UIScrollView()
        return view
    }()
    
    private lazy var contentView: UIView = {
        let view = UIView()
        return view
    }()
    
    private lazy var backLinesView: BackLinesView = {
        let view = BackLinesView(self.orginalFont)
        view.isUserInteractionEnabled = false
        return view
    }()
    
    private lazy var fontLabel: UILabel = {
        let label = UILabel()
        label.font = self.orginalFont
        label.text = "AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890!@#$%^&*()_+|-=\\[]{};':\",./<>?"
        return label
    }()
    
    private lazy var rightNavBarBtn: UIBarButtonItem = {
        let item = UIBarButtonItem(title: "More", style: .plain, target: self, action: #selector(moreBtnClicked))
        return item
    }()
    
    @objc func moreBtnClicked() {
        let alert = UIAlertController(title: "More Action", message: nil, preferredStyle: .actionSheet)
        
        let info = UIAlertAction(title: "Font Info", style: .default) { (alert) in
            self.showFontInfo()
        }
        alert.addAction(info)
        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func showFontInfo() {
        let info =
        """
        familyName: \(self.orginalFont.familyName)
        fontName: \(self.orginalFont.fontName)
        pointSize: \(self.orginalFont.pointSize)
        ascender: \(self.orginalFont.ascender)
        descender: \(self.orginalFont.descender)
        capHeight: \(self.orginalFont.capHeight)
        xHeight: \(self.orginalFont.xHeight)
        lineHeight: \(self.orginalFont.lineHeight)
        leading: \(self.orginalFont.leading)
        """
        let alert = UIAlertController(title: "Font Info", message: info, preferredStyle: .alert)
        alert.addAction(UIAlertAction.init(title: "已阅", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class BackLinesView: UIView {
    private let orginalFont: UIFont
    
    init(_ font: UIFont) {
        orginalFont = font
        super.init(frame: .zero)
        backgroundColor = .init(white: 0, alpha: 0.1)
        
        addSubview(ascenderLine)
        addSubview(descenderLine)
        addSubview(capLine)
        addSubview(xLine)
        addSubview(leadingLine)
        addSubview(centerLine)
        addSubview(lineHeightLine)
        
        ascenderLine.snp.makeConstraints { (make) in
            make.top.equalTo(orginalFont.ascender)
            make.leading.trailing.equalToSuperview()
        }
        
        descenderLine.snp.makeConstraints { (make) in
            make.bottom.equalTo(ascenderLine).offset(-font.descender)
            make.leading.trailing.equalToSuperview()
        }
        
        capLine.snp.makeConstraints { (make) in
            make.top.equalTo(ascenderLine).offset(-font.capHeight)
            make.leading.trailing.equalToSuperview()
        }
        
        xLine.snp.makeConstraints { (make) in
            make.top.equalTo(ascenderLine).offset(-font.xHeight)
            make.leading.trailing.equalToSuperview()
        }
        
        leadingLine.snp.makeConstraints { (make) in
            make.top.equalTo(descenderLine).offset(font.leading)
            make.leading.trailing.equalToSuperview()
        }
        
        centerLine.snp.makeConstraints { (make) in
            make.centerY.leading.trailing.equalToSuperview()
        }
        
        lineHeightLine.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview().offset(-font.lineHeight)
            make.leading.trailing.equalToSuperview()
        }
    }
    
    private lazy var ascenderLine: ColorLineView = {
        return ColorLineView(.red, "baseLine")
    }()
    
    private lazy var descenderLine: ColorLineView = {
        return ColorLineView(.orange, "descender")
    }()
    
    private lazy var capLine: ColorLineView = {
        return ColorLineView(.yellow, "capHeight")
    }()
    
    private lazy var xLine: ColorLineView = {
        return ColorLineView(.green, "xHeight")
    }()
    
    private lazy var leadingLine: ColorLineView = {
        return ColorLineView(.cyan, "leading")
    }()
    
    private lazy var centerLine: ColorLineView = {
        return ColorLineView(.blue, "center")
    }()
    
    private lazy var lineHeightLine: ColorLineView = {
        return ColorLineView(.purple, "lineHeight")
    }()
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: UIView.noIntrinsicMetric, height:orginalFont.lineHeight)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class ColorLineView: UIView {
    private let title: String
    private let color: UIColor
    
    init(_ color: UIColor, _ title: String) {
        self.title = title
        self.color = color
        super.init(frame: .zero)
        backgroundColor = color
        
        addSubview(titleLabel)
        
        setUpConstraints()
    }
    
    func setUpConstraints() {
        titleLabel.snp.makeConstraints { (make) in
            make.leading.bottom.equalToSuperview()
        }
    }
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = self.title
        label.font = .systemFont(ofSize: 15)
        label.textColor = self.color.withAlphaComponent(0.7)
        label.text = self.title
        return label
    }()
    
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: UIView.noIntrinsicMetric, height:0.5)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class VerticalColorLine: ColorLineView {
    override func setUpConstraints() {
        titleLabel.snp.makeConstraints { (make) in
            make.leading.top.equalToSuperview()
        }
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: 0.5, height: UIView.noIntrinsicMetric)
    }
}
