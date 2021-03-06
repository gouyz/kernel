//
//  GYZLabAndFieldView.swift
//  TuAi
//  label 和 textField View
//  Created by gouyz on 2018/3/7.
//  Copyright © 2018年 gyz. All rights reserved.
//

import UIKit

class GYZLabAndFieldView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = kWhiteColor
        setupUI()
    }
    convenience init(desName : String,placeHolder: String){
        self.init(frame: CGRect.zero)
        
        desLab.text = desName
        textFiled.placeholder = placeHolder
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setupUI(){
        // 添加子控件
        addSubview(desLab)
        addSubview(textFiled)
        
        // 布局子控件
        desLab.snp.makeConstraints { (make) in
            make.left.equalTo(kMargin)
            make.top.bottom.equalTo(self)
            make.width.equalTo(100)
        }
        
        textFiled.snp.makeConstraints { (make) in
            make.left.equalTo(desLab.snp.right).offset(kMargin)
            make.top.bottom.equalTo(self)
            make.right.equalTo(-kMargin)
        }
    }
    
    /// 描述
    lazy var desLab : UILabel = {
        let lab = UILabel()
        lab.textColor = kBlackFontColor
        lab.font = k15Font
        
        return lab
    }()
    /// 输入框
    lazy var textFiled : UITextField = {
        
        let textFiled = UITextField()
        textFiled.font = k15Font
        textFiled.textColor = kBlackFontColor
        textFiled.clearButtonMode = .whileEditing
        return textFiled
    }()
}
