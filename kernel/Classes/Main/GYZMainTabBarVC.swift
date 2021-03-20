//
//  GYZMainTabBarVC.swift
//  baking
//  底部导航控制器
//  Created by gouyz on 2017/3/23.
//  Copyright © 2017年 gouyz. All rights reserved.
//

import UIKit

class GYZMainTabBarVC: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        setUp()
    }
    
    func setUp(){
        tabBar.tintColor = kOrangeFontColor
        /// 解决iOS12.1 子页面返回时底部tabbar出现了错位
        tabBar.isTranslucent = false
        //tabbar去掉顶部黑线
        tabBar.backgroundImage = UIImage()
        tabBar.shadowImage = UIImage()
        tabBar.barTintColor = kWhiteColor
        delegate = self
        
        
        customTabbar.btnClickBlock = {[unowned self] (btn) in
            self.selectedIndex = 1
        }
        self.setValue(customTabbar, forKeyPath: "tabBar")
        
        addViewController(UNMenuVC(), title: "菜单", normalImgName: "icon_tabbar_home")
        let unearbyVC = UNMyUnearbyVC()
        let nav = GYZBaseNavigationVC.init(rootViewController: unearbyVC)
        addChild(nav)
        
        addViewController(UNMineVC(), title: "我的", normalImgName: "icon_tabbar_mine")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        customTabbar.setTabbarUI(views: self.tabBar.subviews, tabbar: self.tabBar, topLineColor: kGrayLineColor, backgroundColor: kWhiteColor)
    }
    override var shouldAutorotate: Bool{
        return self.selectedViewController?.shouldAutorotate ?? false
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    var customTabbar: GYZCustomTabbar = GYZCustomTabbar()
    // 添加子控件
    fileprivate func addViewController(_ childController: UIViewController, title: String,normalImgName: String) {
        let nav = GYZBaseNavigationVC.init(rootViewController: childController)
        addChild(nav)
        childController.tabBarItem.title = title

        // 设置 tabbarItem 选中状态的图片(不被系统默认渲染,显示图像原始颜色)
        childController.tabBarItem.image = UIImage(named: normalImgName)?.withRenderingMode(.alwaysOriginal)
        childController.tabBarItem.selectedImage = UIImage(named: normalImgName + "_selected")?.withRenderingMode(.alwaysOriginal)
    }
}
extension GYZMainTabBarVC: UITabBarControllerDelegate{
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if selectedIndex != 1{
            self.customTabbar.button.isSelected = false
        }else{
            self.customTabbar.button.isSelected = true
        }
        
    }
}
