//
//  LHSCustomAlertView.swift
//  LazyHuiService
//  自定义带输入框的alert
//  Created by gouyz on 2017/7/3.
//  Copyright © 2017年 gouyz. All rights reserved.
//

import UIKit

class LHSCustomAlertView: UIView,UITextViewDelegate {
    
    weak var delegate: CustomAlertViewDelegate?
    ///txtView 提示文字
    var placeHolder = ""
    ///输入内容
    var content: String = ""
    
    ///点击事件闭包
    var action:((_ alertView: LHSCustomAlertView,_ index: Int) -> Void)?
    
    /// 填充数据
    var dataModel : UNMediaModel?{
        didSet{
            if let model = dataModel {
                titleLab.text = model.app_name
                
                if model.type == "2" { // 图片
                    contentTxtView.isHidden = true
                    imgViews.isHidden = false
                    var imgArr:[String] = [String]()
                    if  let account = model.account {
                        imgArr = account.components(separatedBy: ";")
                    }
                    
                    if imgArr.count > 0 {
                        imgViews.imgHight = kPhotosImgHeight4Processing
                        imgViews.imgWidth = kPhotosImgHeight4Processing
                        imgViews.perRowItemCount = 3
                        imgViews.selectImgUrls = imgArr
                        let rowIndex = ceil(CGFloat.init((imgViews.selectImgUrls?.count)!) / CGFloat.init(imgViews.perRowItemCount))//向上取整
                        imgViews.snp.updateConstraints { (make) in
                            make.height.equalTo(imgViews.imgHight * rowIndex + kMargin * (rowIndex - 1))
                        }
                    }
                    
                }else{
                    contentTxtView.isHidden = false
                    imgViews.isHidden = true
                    contentTxtView.text = model.account
                }
                
            }
        }
    }

    // MARK: 生命周期方法
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    convenience init(){
        let rect = CGRect(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight)
        self.init(frame: rect)
        
        self.backgroundColor = UIColor.clear
        
        backgroundView.frame = rect
        backgroundView.backgroundColor = kBlackColor
        addSubview(backgroundView)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    fileprivate func setupUI(){
        
        bgView.backgroundColor = kWhiteColor
        bgView.cornerRadius = 10
        addSubview(bgView)
        
        bgView.addSubview(titleLab)
        bgView.addSubview(contentTxtView)
        bgView.addSubview(cancleBtn)
        bgView.addSubview(imgViews)
        
        bgView.snp.makeConstraints { (make) in
            make.left.equalTo(20)
            make.right.equalTo(-20)
            make.centerY.equalTo(self)
            make.height.equalTo(360)
        }
        
        titleLab.snp.makeConstraints { (make) in
            make.top.equalTo(bgView)
            make.height.equalTo(kTitleHeight)
            make.left.equalTo(kTitleHeight + 10)
            make.right.equalTo(cancleBtn.snp.left)
        }
        cancleBtn.snp.makeConstraints { (make) in
            make.top.height.equalTo(titleLab)
            make.right.equalTo(-kMargin)
            make.width.equalTo(kTitleHeight)
        }
        contentTxtView.snp.makeConstraints { (make) in
            make.top.equalTo(titleLab.snp.bottom).offset(kMargin)
            make.left.equalTo(kMargin)
            make.right.equalTo(-kMargin)
            make.bottom.equalTo(-kMargin)
        }
        
        imgViews.snp.makeConstraints { (make) in
            make.top.equalTo(titleLab.snp.bottom).offset(kMargin)
            make.left.equalTo(kMargin)
            make.right.equalTo(-kMargin)
            make.height.equalTo(0)
        }
        
    }
    ///整体背景
    lazy var backgroundView: UIView = UIView()
    
    lazy var bgView: UIView = UIView()
    /// 标题
    lazy var titleLab : UILabel = {
        let lab = UILabel()
        lab.font = k15Font
        lab.textColor = kBlackFontColor
        lab.backgroundColor = kWhiteColor
        lab.textAlignment = .center
        lab.text = "详情"
        
        return lab
    }()
    
    ///内容
    lazy var contentTxtView: UITextView = {
        let txtView = UITextView()
//        txtView.backgroundColor = kBackgroundColor
        txtView.font = k15Font
        txtView.textColor = kGaryFontColor
        txtView.isEditable = false
        
        return txtView
    }()
    /// 九宫格图片显示
    lazy var imgViews: GYZPhotoView = GYZPhotoView()
    /// 取消
    lazy var cancleBtn : UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.setImage(UIImage.init(named: "icon_close_x"), for: .normal)
        btn.addTarget(self, action: #selector(clickedBtn(btn:)), for: .touchUpInside)
        return btn
    }()
    
    /// 点击事件
    ///
    /// - Parameter btn:
    @objc func clickedBtn(btn: UIButton){
        
        let tag = btn.tag - 100
        
        delegate?.alertViewDidClickedBtnAtIndex(alertView: self, index: tag)
        if action != nil {
            action!(self, tag)
        }
        
        hide()
        
    }
    
    func show(){
        UIApplication.shared.keyWindow?.addSubview(self)
        
        showBackground()
        showAlertAnimation()
    }
    func hide(){
        bgView.isHidden = true
        hideAlertAnimation()
        self.removeFromSuperview()
    }
    
    fileprivate func showBackground(){
        backgroundView.alpha = 0.0
        UIView.beginAnimations("fadeIn", context: nil)
        UIView.setAnimationDuration(0.35)
        backgroundView.alpha = 0.6
        UIView.commitAnimations()
    }
    
    fileprivate func showAlertAnimation(){
        let popAnimation = CAKeyframeAnimation(keyPath: "transform")
        popAnimation.duration = 0.3
        popAnimation.values   = [
            NSValue.init(caTransform3D: CATransform3DMakeScale(0.9, 0.9, 1.0)),
            NSValue.init(caTransform3D: CATransform3DMakeScale(1.1, 1.1, 1.0)),
            NSValue.init(caTransform3D: CATransform3DMakeScale(1.0, 1.0, 1.0)),
            NSValue.init(caTransform3D: CATransform3DIdentity)
        ]
        
        popAnimation.isRemovedOnCompletion = true
        popAnimation.fillMode = CAMediaTimingFillMode.forwards
        bgView.layer.add(popAnimation, forKey: nil)
    }
    
    fileprivate func hideAlertAnimation(){
        UIView.beginAnimations("fadeIn", context: nil)
        UIView.setAnimationDuration(0.35)
        backgroundView.alpha = 0.0
        UIView.commitAnimations()
    }
    
}

protocol CustomAlertViewDelegate: NSObjectProtocol {
    /// 点击事件
    ///
    /// - Parameters:
    ///   - alertView: alertView
    ///   - index: 按钮索引
    func alertViewDidClickedBtnAtIndex(alertView: LHSCustomAlertView,index: Int)
}
