//
//  UNLoginVC.swift
//  unearby
//
//  Created by iMac on 2020/11/6.
//  Copyright © 2020 gouyz. All rights reserved.
//

import UIKit
import MBProgressHUD

class UNLoginVC: GYZBaseVC {
    
    var phoneCode: String = "+86"
    var codeAreaArr:[String] = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navBarBgAlpha = 0
        self.view.backgroundColor = kWhiteColor
        requestPhoneCode()
        
        setUpUI()
        
    }
    func setUpUI(){
        
        view.addSubview(bgImgView)
        bgImgView.addSubview(welcomeLab)
        bgImgView.addSubview(desLab)
        view.addSubview(phoneDesLab)
        view.addSubview(phoneView)
        phoneView.addSubview(codePhoneBtn)
        phoneView.addSubview(lineView)
        phoneView.addSubview(phoneFiled)
        view.addSubview(codeDesLab)
        view.addSubview(codeFiled)
        view.addSubview(codeBtn)
        view.addSubview(loginBtn)
        
        
        bgImgView.snp.makeConstraints { (make) in
            make.top.left.right.equalTo(self.view)
            make.height.equalTo(kScreenWidth * 0.6)
        }
        
        welcomeLab.snp.makeConstraints { (make) in
            make.left.right.equalTo(desLab)
            make.bottom.equalTo(desLab.snp.top)
            make.height.equalTo(kTitleHeight)
        }
        desLab.snp.makeConstraints { (make) in
            make.left.equalTo(20)
            make.right.equalTo(-20)
            make.bottom.equalTo(-50)
            make.height.equalTo(30)
        }
        phoneDesLab.snp.makeConstraints { (make) in
            make.top.equalTo(bgImgView.snp.bottom).offset(30)
            make.left.equalTo(40)
            make.right.equalTo(-40)
            make.height.equalTo(30)
        }
        phoneView.snp.makeConstraints { (make) in
            make.left.right.equalTo(phoneDesLab)
            make.top.equalTo(phoneDesLab.snp.bottom).offset(5)
            make.height.equalTo(kTitleHeight)
        }
        codePhoneBtn.snp.makeConstraints { (make) in
            make.left.equalTo(8)
            make.top.bottom.equalTo(phoneView)
            make.width.equalTo(60)
        }
        lineView.snp.makeConstraints { (make) in
            make.left.equalTo(codePhoneBtn.snp.right).offset(5)
            make.centerY.equalTo(phoneView)
            make.size.equalTo(CGSize.init(width: klineWidth, height: 24))
        }
        phoneFiled.snp.makeConstraints { (make) in
            make.left.equalTo(lineView.snp.right).offset(5)
            make.right.equalTo(-8)
            make.top.bottom.equalTo(phoneView)
        }
        codeDesLab.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(phoneDesLab)
            make.top.equalTo(phoneFiled.snp.bottom).offset(30)
        }
        codeFiled.snp.makeConstraints { (make) in
            make.top.equalTo(codeDesLab.snp.bottom).offset(5)
            make.left.equalTo(codeDesLab)
            make.right.equalTo(codeBtn.snp.left).offset(-kMargin)
            make.height.equalTo(phoneFiled)
        }
        codeBtn.snp.makeConstraints { (make) in
            make.right.height.equalTo(phoneFiled)
            make.top.equalTo(codeFiled)
            make.width.equalTo(84)
        }
        loginBtn.snp.makeConstraints { (make) in
            make.left.right.equalTo(phoneFiled)
            make.top.equalTo(codeFiled.snp.bottom).offset(50)
            make.height.equalTo(kUIButtonHeight)
        }
        
    }
    
    /// logo
    lazy var bgImgView: UIImageView = UIImageView.init(image: UIImage.init(named: "icon_login_bg"))
    ///
    lazy var welcomeLab : UILabel = {
        let lab = UILabel()
        lab.textColor = kWhiteColor
        lab.font = UIFont.boldSystemFont(ofSize: 26)
        lab.text = "欢迎使用"
        
        return lab
    }()
    ///
    lazy var desLab : UILabel = {
        let lab = UILabel()
        lab.textColor = kWhiteColor
        lab.font = k16Font
        lab.text = "请先登录"
        
        return lab
    }()
    ///
    lazy var phoneDesLab : UILabel = {
        let lab = UILabel()
        lab.textColor = kBlackFontColor
        lab.font = k15Font
        lab.text = "手机号"
        
        return lab
    }()
    ///
    lazy var phoneView : UIView = {
        let line = UIView()
        line.backgroundColor = kGrayBackGroundColor
        line.cornerRadius = 8
        return line
    }()
    /// 区号代码
    lazy var codePhoneBtn : UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.titleLabel?.font = k13Font
        btn.setTitleColor(kBlackFontColor, for: .normal)
        btn.addTarget(self, action: #selector(onClickedSelectCode), for: .touchUpInside)
        return btn
    }()
    /// 分割线
    lazy var lineView : UIView = {
        let line = UIView()
        line.backgroundColor = UIColor.UIColorFromRGB(valueRGB: 0xdbdbdb)
        return line
    }()
    /// 手机号
    lazy var phoneFiled : UITextField = {
        
        let textFiled = UITextField()
        textFiled.font = k15Font
        textFiled.textColor = kBlackFontColor
        textFiled.clearButtonMode = .whileEditing
        textFiled.backgroundColor = kGrayBackGroundColor
        textFiled.placeholder = " 请输入手机号"
        textFiled.keyboardType = .numberPad
        return textFiled
    }()
    ///
    lazy var codeDesLab : UILabel = {
        let lab = UILabel()
        lab.textColor = kBlackFontColor
        lab.font = k15Font
        lab.text = "验证码"
        
        return lab
    }()
    /// 验证码
    lazy var codeFiled : UITextField = {
        
        let textFiled = UITextField()
        textFiled.font = k15Font
        textFiled.textColor = kBlackFontColor
        textFiled.clearButtonMode = .whileEditing
        textFiled.backgroundColor = kGrayBackGroundColor
        textFiled.placeholder = " 请输入验证码"
        textFiled.keyboardType = .numberPad
        return textFiled
    }()
    /// 获取验证码
    lazy var codeBtn : UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.setTitleColor(kWhiteColor, for: .normal)
        btn.setTitle("获取验证码", for: .normal)
        btn.titleLabel?.font = k12Font
        btn.backgroundColor = kBtnClickBGColor
        btn.cornerRadius = 8
        
        btn.addTarget(self, action: #selector(clickedGetCodeBtn), for: .touchUpInside)
        
        return btn
    }()
    /// 获取验证码
    lazy var loginBtn : UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.setTitleColor(kWhiteColor, for: .normal)
        btn.setTitle("登录", for: .normal)
        btn.titleLabel?.font = k16Font
        btn.backgroundColor = kBtnClickBGColor
        btn.cornerRadius = 8
        
        btn.addTarget(self, action: #selector(clickedLoginBtn), for: .touchUpInside)
        
        return btn
    }()
    /// 选择地区代码
    @objc func onClickedSelectCode(){
        if codeAreaArr.count > 0 {
            UsefulPickerView.showSingleColPicker("选择地区代码", data: codeAreaArr, defaultSelectedIndex: nil) {[unowned self] (index, value) in
                
                self.phoneCode = value
                self.codePhoneBtn.set(image: UIImage.init(named: "icon_down"), title: self.phoneCode, titlePosition: .left, additionalSpacing: 5, state: .normal)
            }
        }
        
    }
    /// 登录
    @objc func clickedLoginBtn(){
        if phoneFiled.text!.isEmpty {
            MBProgressHUD.showAutoDismissHUD(message: "请输入手机号")
            return
        }
//        else if !phoneFiled.text!.isMobileNumber(){
//            MBProgressHUD.showAutoDismissHUD(message: "请输入正确的手机号")
//            return
//        }
        if codeFiled.text!.isEmpty {
            MBProgressHUD.showAutoDismissHUD(message: "请输入验证码")
            return
        }
        requestLogin()
    }
    /// 获取验证码
    @objc func clickedGetCodeBtn(){
        if phoneFiled.text!.isEmpty {
            MBProgressHUD.showAutoDismissHUD(message: "请输入手机号")
            return
        }
//        else if !phoneFiled.text!.isMobileNumber(){
//            MBProgressHUD.showAutoDismissHUD(message: "请输入正确的手机号")
//            return
//        }
        codeBtn.startSMSWithDuration(duration: 60)
        requestCode()
    }
    
    /// 登录
    func requestLogin(){
        
        weak var weakSelf = self
        createHUD(message: "登录中...")
        
        GYZNetWork.requestNetwork("users/addUser",isToken:false, parameters: ["phone":phoneFiled.text!,"code": codeFiled.text!],  success: { (response) in
            
            weakSelf?.hud?.hide(animated: true)
            GYZLog(response)
            if response["status"].intValue == kQuestSuccessTag{//请求成功
                
                let data = response["data"]
//                userDefaults.set(self.phoneFiled.text!, forKey: "defaultAccount")//记录登录的账号
                userDefaults.set(true, forKey: kIsLoginTagKey)//是否登录标识
                userDefaults.set(data["code"].stringValue, forKey: "userCode")//用户code
                userDefaults.set(data["phone"].stringValue, forKey: "phone")//用户电话
                userDefaults.set(data["uname"].stringValue, forKey: "uname")//用户名称
                userDefaults.set(data["img"].stringValue, forKey: "header")//头像
                
                KeyWindow.rootViewController = GYZMainTabBarVC()
            }else{
                MBProgressHUD.showAutoDismissHUD(message: response["msg"].stringValue)
            }
            
        }, failture: { (error) in
            weakSelf?.hud?.hide(animated: true)
            GYZLog(error)
        })
    }
    
    ///获取验证码
    func requestCode(){
        if !GYZTool.checkNetWork() {
            return
        }
        
        weak var weakSelf = self
        createHUD(message: "获取中...")
        
        GYZNetWork.requestNetwork("Login/sms_send", parameters: ["phone":phoneFiled.text!,"area_code":phoneCode],  success: { (response) in
            
            weakSelf?.hud?.hide(animated: true)
            GYZLog(response)
            MBProgressHUD.showAutoDismissHUD(message: response["msg"].stringValue)
            if response["status"].intValue == kQuestSuccessTag{//请求成功

            }
            
        }, failture: { (error) in
            weakSelf?.hud?.hide(animated: true)
            GYZLog(error)
        })
    }
    
    ///获取国际短信地区号
    func requestPhoneCode(){
        if !GYZTool.checkNetWork() {
            return
        }
        
        weak var weakSelf = self
        createHUD(message: "获取中...")
        
        GYZNetWork.requestNetwork("nfc/area_code", success: { (response) in
            
            weakSelf?.hud?.hide(animated: true)
            GYZLog(response)
            if response["status"].intValue == kQuestSuccessTag{//请求成功
                guard let data = response["data"].array else { return }
                for item in data{
                    weakSelf?.codeAreaArr.append(item["area_code"].stringValue)
                }
                if weakSelf?.codeAreaArr.count > 0 {
                    weakSelf?.phoneCode = (weakSelf?.codeAreaArr[0])!
                    weakSelf?.codePhoneBtn.set(image: UIImage.init(named: "icon_down"), title: (weakSelf?.phoneCode)!, titlePosition: .left, additionalSpacing: 5, state: .normal)
                }
            }else{
                MBProgressHUD.showAutoDismissHUD(message: response["msg"].stringValue)
            }
            
        }, failture: { (error) in
            weakSelf?.hud?.hide(animated: true)
            GYZLog(error)
        })
    }
}
