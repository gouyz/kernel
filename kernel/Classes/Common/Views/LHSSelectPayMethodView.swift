//
//  LHSSelectPayMethodView.swift
//  LazyHuiUser
//  选择支付方式
//  Created by gouyz on 2018/1/16.
//  Copyright © 2018年 jh. All rights reserved.
//

import UIKit

class LHSSelectPayMethodView: UIView {

    /// 选择结果回调
    var selectPayTypeBlock:((_ isAliPay: Bool) -> Void)?
    // MARK: 生命周期方法
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setupUI(){
        self.backgroundColor = kWhiteColor
        
        let tieleLab: UILabel = UILabel()
        tieleLab.font = k15Font
        tieleLab.textColor = kGaryFontColor
        tieleLab.text = "支付方式"
        addSubview(tieleLab)
        
        tieleLab.snp.makeConstraints { (make) in
            make.left.equalTo(kMargin)
            make.top.equalTo(self)
            make.right.equalTo(-kMargin)
            make.height.equalTo(38)
        }
        let line1 = UIView()
        line1.backgroundColor = kGrayLineColor
        addSubview(line1)
        
        addSubview(alipayView)
        alipayView.addSubview(alipayIconView)
        alipayView.addSubview(alipayNameLab)
        alipayView.addSubview(alipayCheckBtn)
        addSubview(lineView)
        
        addSubview(weChatView)
        weChatView.addSubview(weChatIconView)
        weChatView.addSubview(weChatLab)
        weChatView.addSubview(weChatCheckBtn)
        
        alipayView.snp.makeConstraints { (make) in
            make.left.right.equalTo(self)
            make.top.equalTo(tieleLab.snp.bottom)
            make.height.equalTo(70)
        }
        alipayIconView.snp.makeConstraints { (make) in
            make.left.equalTo(alipayView).offset(20)
            make.centerY.equalTo(alipayView)
            make.size.equalTo(CGSize.init(width: 28, height: 28))
        }
        alipayNameLab.snp.makeConstraints { (make) in
            make.left.equalTo(alipayIconView.snp.right).offset(20)
            make.right.equalTo(alipayCheckBtn.snp.left).offset(-kMargin)
            make.top.bottom.equalTo(alipayView)
        }
        alipayCheckBtn.snp.makeConstraints { (make) in
            make.right.equalTo(alipayView).offset(-20)
            make.centerY.equalTo(alipayView)
            make.size.equalTo(CGSize.init(width: 15, height: 15))
        }
        
        lineView.snp.makeConstraints { (make) in
            make.left.right.equalTo(self)
            make.top.equalTo(alipayView.snp.bottom)
            make.height.equalTo(klineWidth)
        }
        
        weChatView.snp.makeConstraints { (make) in
            make.left.right.equalTo(alipayView)
            make.top.equalTo(lineView.snp.bottom)
            make.bottom.equalTo(self)
        }
        weChatIconView.snp.makeConstraints { (make) in
            make.left.equalTo(weChatView).offset(20)
            make.centerY.equalTo(weChatView)
            make.size.equalTo(alipayIconView)
        }
        weChatLab.snp.makeConstraints { (make) in
            make.left.equalTo(weChatIconView.snp.right).offset(20)
            make.right.equalTo(weChatCheckBtn.snp.left).offset(-kMargin)
            make.top.bottom.equalTo(weChatView)
        }
        weChatCheckBtn.snp.makeConstraints { (make) in
            make.right.equalTo(weChatView).offset(-20)
            make.centerY.equalTo(weChatView)
            make.size.equalTo(alipayCheckBtn)
        }
        line1.snp.makeConstraints { (make) in
            make.left.right.equalTo(self)
            make.top.equalTo(weChatView.snp.bottom)
            make.height.equalTo(klineWidth)
        }
        
        weChatView.addOnClickListener(target: self, action: #selector(onClickPayView(sender:)))
        weChatView.tag = 102
        alipayView.addOnClickListener(target: self, action: #selector(onClickPayView(sender:)))
        alipayView.tag = 101
        alipayCheckBtn.isSelected = true
        alipayCheckBtn.tag = 101
        weChatCheckBtn.tag = 102
        
        alipayCheckBtn.addTarget(self, action: #selector(onClickedPayBtn(sender:)), for: .touchUpInside)
        weChatCheckBtn.addTarget(self, action: #selector(onClickedPayBtn(sender:)), for: .touchUpInside)
        
    }
    
    lazy var alipayView: UIView = UIView()
    /// 图标
    lazy var alipayIconView: UIImageView = UIImageView.init(image: UIImage.init(named: "app_icon_pay_zhifubao"))
    /// 支付宝支付
    lazy var alipayNameLab : UILabel = {
        let lab = UILabel()
        lab.font = k15Font
        lab.textColor = kGaryFontColor
        lab.text = "支付宝支付"
        
        return lab
    }()
    /// 选择图标
    lazy var alipayCheckBtn : UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.setImage(UIImage.init(named: "app_icon_radio_no"), for: .normal)
        btn.setImage(UIImage.init(named: "app_icon_radio_yes"), for: .selected)
        return btn
    }()
    /// 线
    lazy var lineView: UIView = {
        let line = UIView()
        line.backgroundColor = kGrayLineColor
        
        return line
    }()
    
    lazy var weChatView: UIView = UIView()
    /// 图标
    lazy var weChatIconView: UIImageView = UIImageView.init(image: UIImage.init(named: "app_icon_pay_weixin"))
    /// 微信支付
    lazy var weChatLab : UILabel = {
        let lab = UILabel()
        lab.font = k15Font
        lab.textColor = kGaryFontColor
        lab.text = "微信支付"
        
        return lab
    }()
    /// 选择图标
    lazy var weChatCheckBtn : UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.setImage(UIImage.init(named: "app_icon_radio_no"), for: .normal)
        btn.setImage(UIImage.init(named: "app_icon_radio_yes"), for: .selected)
        return btn
    }()
    
    @objc func onClickPayView(sender: UITapGestureRecognizer){
        let tag = sender.view?.tag
        
        goPay(index: tag!)
    }
    
    @objc func onClickedPayBtn(sender: UIButton){
        let tag = sender.tag
        goPay(index: tag)
        
    }
    
    func goPay(index: Int){
        if index == 101 {// 支付宝支付
            alipayCheckBtn.isSelected = true
            weChatCheckBtn.isSelected = false
        } else {//微信支付
            alipayCheckBtn.isSelected = false
            weChatCheckBtn.isSelected = true
        }
        
        if selectPayTypeBlock != nil {
            selectPayTypeBlock!(alipayCheckBtn.isSelected)
        }
    }
}

