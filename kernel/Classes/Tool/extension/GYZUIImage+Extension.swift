//
//  GYZUIImage+Extension.swift
//  LazyHuiSellers
//  图片扩展
//  Created by gouyz on 2016/12/15.
//  Copyright © 2016年 gouyz. All rights reserved.
//

import UIKit
import CoreImage


extension UIImage
{
    /**
     1.识别图片二维码
     
     - returns: 二维码内容
     */
    func recognizeQRCode() -> String?
    {
        
        let detector = CIDetector(ofType: CIDetectorTypeQRCode, context: nil, options: [CIDetectorAccuracy : CIDetectorAccuracyHigh])
        let features = detector?.features(in: CoreImage.CIImage(cgImage: self.cgImage!))
        guard (features?.count)! > 0 else { return nil }
        let feature = features?.first as? CIQRCodeFeature
        return feature?.messageString
        
    }
    
    //2.获取圆角图片
    func getRoundRectImage(size:CGFloat,radius:CGFloat) -> UIImage
    {
        
        return getRoundRectImage(size: size, radius: radius, borderWidth: nil, borderColor: nil)
        
    }
    
    //3.获取圆角图片(带边框)
    func getRoundRectImage(size:CGFloat,radius:CGFloat,borderWidth:CGFloat?,borderColor:UIColor?) -> UIImage
    {
        let scale = self.size.width / size ;
        
        //初始值
        var defaultBorderWidth : CGFloat = 0
        var defaultBorderColor = UIColor.clear
        
        if let borderWidth = borderWidth { defaultBorderWidth = borderWidth * scale }
        if let borderColor = borderColor { defaultBorderColor = borderColor }
        
        let radius = radius * scale
        let react = CGRect(x: defaultBorderWidth, y: defaultBorderWidth, width: self.size.width - 2 * defaultBorderWidth, height: self.size.height - 2 * defaultBorderWidth)
        
        //绘制图片设置
        UIGraphicsBeginImageContextWithOptions(self.size, false, UIScreen.main.scale)
        
        let path = UIBezierPath(roundedRect:react , cornerRadius: radius)
        
        //绘制边框
        path.lineWidth = defaultBorderWidth
        defaultBorderColor.setStroke()
        path.stroke()
        
        path.addClip()
        
        //画图片
        draw(in: react)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!;
        
    }
    
    
    /// 图片压缩
    ///
    /// - Parameter newSize: 大小
    /// - Returns: 图片
    func scaleImgToSize(newSize:CGSize) -> UIImage{
        // Create a graphics image context
        UIGraphicsBeginImageContext(newSize)
        // Tell the old image to draw in this new context, with the desired
        // new size
        self.draw(in: CGRect.init(x: 0, y: 0, width: newSize.width, height: newSize.height))
        // Get the new image from the context
        let newImg: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        // End the context
        UIGraphicsEndImageContext()
        return newImg
    }
    // 将UIView转成UIImage
    static func getImageFromView(theView : UIView) -> UIImage{
        let orgSize: CGSize = theView.bounds.size
        UIGraphicsBeginImageContextWithOptions(orgSize, false, 1)
        theView.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        // End the context
        UIGraphicsEndImageContext()
        return image!
    }
    // 图片灰度化
    func grayImage() -> UIImage{
        //        获得原图像的尺寸属性
        let imageSize = self.size
        //        获得宽度和高度数值
        let width = Int(imageSize.width)
        let height = Int(imageSize.height)
        
        //        创建灰度色彩空间对象，各种设备对待颜色的方式都不一样，颜色必须有一个相关的色彩空间
        let spaceRef = CGColorSpaceCreateDeviceGray()
        //        参数data指向渲染的绘制内存的地址，bitsOerComponent表示内存中像素的每个组件的位数,bytesPerRow表示每一行在内存中占的比特数，space表示使用的颜色空间，bitmapInfo表示是否包含alpha通道
        let context = CGContext(data: nil, width: width, height: height, bitsPerComponent: 8, bytesPerRow: 0, space: spaceRef, bitmapInfo: CGBitmapInfo().rawValue)!
        //        然后创建一个和原视图同样尺寸的空间
        let rect = CGRect(x: 0, y: 0, width: imageSize.width, height: imageSize.height)
        
        //        在灰度上下文中画入图片
        context.draw(self.cgImage!, in: rect)
        //        从上下文中获取并生成专为灰度的图片
        let grayImage = UIImage(cgImage: context.makeImage()!)
        
        return grayImage
    }
}
