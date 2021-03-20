//
//  GYZCustomTabbar.swift
//  unearby
//  自定义TabBar
//  Created by iMac on 2020/11/6.
//  Copyright © 2020 gouyz. All rights reserved.
//

import UIKit

class GYZCustomTabbar: UITabBar {
    /// 选择结果回调
    var btnClickBlock:((_ btn: UIButton) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.isTranslucent = false
        self.addSubview(button)
        button.set(image: UIImage.init(named: "icon_tabbar_nearby"), title: "我的Unearby", titlePosition: .bottom, additionalSpacing: 30, state: .normal)
        button.set(image: UIImage.init(named: "icon_tabbar_nearby_selected"), title: "我的Unearby", titlePosition: .bottom, additionalSpacing: 30, state: .selected)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        self.button.frame = CGRect.init(x: 0, y: 0, width: self.width/3.0, height: self.height - kNoStatusBarSafeTop)
        self.button.center = CGPoint.init(x: self.width/2.0, y: (self.height - kNoStatusBarSafeTop)/2.0)
    }
    //判断点是否在响应范围
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        if self.isHidden == false {
            let circle: UIBezierPath = UIBezierPath.init(arcCenter: self.button.center, radius: 30, startAngle: 0, endAngle: CGFloat(2 * Double.pi), clockwise: true)
            let tabbar: UIBezierPath = UIBezierPath.init(rect: self.bounds)
            if circle.contains(point) || tabbar.contains(point) {
                return true
            }
            return false
        }else{
            return super.point(inside: point, with: event)
        }
    }
    func setTabbarUI(views: [UIView], tabbar: UITabBar, topLineColor: UIColor,backgroundColor: UIColor){
        for obj in views {
            if obj.isKind(of: NSClassFromString("_UIBarBackground")!){
                if obj.viewWithTag(999) == nil {
                    let top: UIView = UIView.init(frame: CGRect.init(x: 0, y: -20, width: tabbar.bounds.size.width, height: 20))
                    top.isUserInteractionEnabled = false
                    top.backgroundColor = .clear
                    top.tag = 999
                    obj.addSubview(addTopViewToParentView(parent: top, topLineColor: topLineColor, backgroundColor: backgroundColor))
                }
            }
        }
    }
    
    func addTopViewToParentView(parent: UIView, topLineColor: UIColor,backgroundColor: UIColor) -> UIView{
        let path: UIBezierPath = UIBezierPath.init()
        let p0: CGPoint = CGPoint.init(x: 0.0, y: 20)
        let p1: CGPoint = CGPoint.init(x: parent.bounds.size.width/2.0 - 65, y: 20)
        let p: CGPoint = CGPoint.init(x: parent.bounds.size.width/2.0, y: 0)
        let p2: CGPoint = CGPoint.init(x: parent.bounds.size.width/2.0 + 65, y: 20)
        let p3: CGPoint = CGPoint.init(x: parent.bounds.size.width, y: 20)
        
        let v0: NSValue = NSValue.init(cgPoint: p0)
        let v1: NSValue = NSValue.init(cgPoint: p1)
        let v: NSValue = NSValue.init(cgPoint: p)
        let v2: NSValue = NSValue.init(cgPoint: p2)
        let v3: NSValue = NSValue.init(cgPoint: p3)
        let array:[NSValue] = [v0,v1,v,v2,v3]
        path.move(to: p0)
        for i in 0 ..< array.count - 3 {
            let t0: CGPoint = array[i + 0].cgPointValue
            let t1: CGPoint = array[i + 1].cgPointValue
            let t2: CGPoint = array[i + 2].cgPointValue
            let t3: CGPoint = array[i + 3].cgPointValue
            
            for index in 0 ..< 100 {
                let point: CGPoint = getPoint(t: CGFloat(index)/100.0, p0: t0, p1: t1, p2: t2, p3: t3)
                path.addLine(to: point)
            }
        }
        
        path.addLine(to: p3)
        
        let shapeLayer: CAShapeLayer = CAShapeLayer.init()
        shapeLayer.frame = CGRect.init(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight)
        shapeLayer.lineWidth = 0.5
        shapeLayer.lineCap = CAShapeLayerLineCap(rawValue: "round")
        shapeLayer.strokeColor = topLineColor.cgColor
        shapeLayer.fillColor = backgroundColor.cgColor
        shapeLayer.path = path.cgPath
        shapeLayer.strokeStart = 0.0
        shapeLayer.strokeEnd = 1.0
        parent.layer.addSublayer(shapeLayer)
        parent.isUserInteractionEnabled = false
        
        return parent
    }
    
    func getPoint(t:CGFloat,p0:CGPoint,p1:CGPoint,p2:CGPoint,p3:CGPoint) ->CGPoint{
        let t2: CGFloat = t*t
        let t3: CGFloat = t2*t
        
        let f0: CGFloat = -0.5*t3 + t2 - 0.5*t
        let f1: CGFloat = 1.5*t3 - 2.5*t2 + 1.0
        let f2: CGFloat = -1.5*t3 + 2.0*t2 + 0.5*t
        let f3: CGFloat = 0.5*t3 - 0.5*t2
        
        let x: CGFloat = p0.x*f0 + p1.x*f1 + p2.x*f2 + p3.x*f3
        let y:CGFloat = p0.y*f0 + p1.y*f1 + p2.y*f2 + p3.y*f3
        return CGPoint.init(x: x, y: y)
    }
    var button: UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.titleLabel?.font = k10Font
        btn.setTitleColor(kBlackFontColor, for: .normal)
        btn.setTitleColor(kBlueFontColor, for: .selected)
//        btn.setTitle("我的Unearby", for: .normal)
//        btn.setImage(UIImage.init(named: "icon_tabbar_nearby"), for: .normal)
//        btn.setImage(UIImage.init(named: "icon_tabbar_nearby_selected"), for: .selected)
        btn.addTarget(self, action: #selector(didBtnAction(sender:)), for: .touchUpInside)
        
        return btn
    }()
    
    @objc func didBtnAction(sender: UIButton){
        
        button.isSelected = true
        if btnClickBlock != nil {
            btnClickBlock!(sender)
        }
    }
}
