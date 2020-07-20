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
        label.text = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890!@#$%^&*()_+|-=\\[]{};':\",./<>?"
        return label
    }()
    
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
//        addSubview(lineHeightLine)
        
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
        
//        lineHeightLine.snp.makeConstraints { (make) in
//            make.top.equalToSuperview()
//            make.height.equalTo(font.lineHeight)
//            make.leading.equalToSuperview().offset(30)
//        }
    }
    
    private lazy var ascenderLine: ColorLineView = {
        return ColorLineView(.red, "ascender")
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
    
//    private lazy var lineHeightLine: VerticalColorLine = {
//        return VerticalColorLine(.purple, "lineHeight")
//    }()
    
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
        label.textColor = self.color.withAlphaComponent(0.5)
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
