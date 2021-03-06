//
//  GYZBaseVC.swift
//  flowers
//  基控制器
//  Created by gouyz on 2016/11/7.
//  Copyright © 2016年 gouyz. All rights reserved.

import UIKit
import MBProgressHUD

class GYZBaseVC: UIViewController {
    
    var hud : MBProgressHUD?
    var statusBarShouldLight = true
    /// 是否是白色返回键
    var isWhiteBack = true
    var loginFailureTimes: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = kBackgroundColor
        navBarBgAlpha = 1
        
        if !isWhiteBack {
            setNeedsStatusBarAppearanceUpdate()
        }
        if navigationController?.children.count > 1 {
            // 添加返回按钮,不被系统默认渲染,显示图像原始颜色
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: (isWhiteBack ? "icon_back_white" : "icon_back_black"))?.withRenderingMode(.alwaysOriginal), style: .done, target: self, action: #selector(clickedBackBtn))
        }
        
    }
    /// 重载设置状态栏样式
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if statusBarShouldLight {

            navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: kWhiteColor, NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 18)]

            navigationController?.navigationBar.barTintColor = kNavBarColor
            navigationController?.navigationBar.tintColor = kWhiteColor

            return .lightContent
        } else {

            navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: kBlackFontColor, NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 18)]

            navigationController?.navigationBar.barTintColor = kWhiteColor
            navigationController?.navigationBar.tintColor = kBlackFontColor

            return .default
        }
    }

    /// 设置状态栏样式为default
    func setStatusBarStyle(){

        statusBarShouldLight = false
        setNeedsStatusBarAppearanceUpdate()
    }
    /// 返回
    @objc func clickedBackBtn() {
        _ = navigationController?.popViewController(animated: true)
    }
    /// 关闭屏幕旋转
    override var shouldAutorotate: Bool{
        return false
    }
    /// 创建HUD
    func createHUD(message: String){
        if hud != nil {
            hud?.hide(animated: true)
            hud = nil
        }
        
        hud = MBProgressHUD.showHUD(message: message,toView: view)
    }

    
    ///获取用户信息
    func requestMemberInfo(){
        if !GYZTool.checkNetWork() {
            return
        }
        weak var weakSelf = self
        GYZNetWork.requestNetwork("Member/Login/getMemberInfo",parameters: nil,  success: {(response) in
            
            GYZLog(response)
            if response["result"].intValue == kQuestSuccessTag{//请求成功
                let userInfo = response["data"]["u"]
                let nick_name = userInfo["nick_name"].stringValue
                userDefaults.set(nick_name, forKey: "nickname")
                userDefaults.set(userInfo["avatar"].stringValue, forKey: "avatar")
                let member_id = userInfo["im_data"]["member_id"].stringValue
                let im_token = userInfo["im_data"]["im_token"].stringValue
            }
            
        }, failture: { (error) in
            
            GYZLog(error)
        })
    }
}
