//
//  GYZPhotoView.swift
//  TuAi
//  照片九宫格
//  Created by gouyz on 2018/3/8.
//  Copyright © 2018年 gyz. All rights reserved.
//

import UIKit
import Kingfisher

class GYZPhotoView: UIView {

    var imageViewsArray:[UIImageView] = []
    
    //默认4列，列间隔为10，距离屏幕边距左右各10
    var imgWidth: CGFloat = kPhotosImgHeight
    var imgHight: CGFloat = kPhotosImgHeight
    var perRowItemCount = 4
    
    /// 点击查看大图
    var onClickedImgDetailsBlock: ((_ index: Int,_ urls: [String]) -> Void)?
    
    ///本地图片
    var selectImgs: [UIImage]?{
        didSet{
            if let imgArr = selectImgs {
                
                for index in imgArr.count ..< imageViewsArray.count {
                    let imgView: UIImageView = imageViewsArray[index]
                    imgView.isHidden = true
                }
                
                
                
                let margin: CGFloat = 10
                for (index,item) in imgArr.enumerated() {
                    let columnIndex = index % perRowItemCount
                    let rowIndex = index/perRowItemCount
                    
                    let imgView: UIImageView = imageViewsArray[index]
                    imgView.isHidden = false
                    imgView.image = item
                    imgView.frame = CGRect.init(x: CGFloat.init(columnIndex) * (imgWidth + margin), y: CGFloat.init(rowIndex) * (imgHight + margin), width: imgWidth, height: imgHight)
                }
                
            }
        }
    }
    
    ///加载网络图片
    var selectImgUrls: [String]?{
        didSet{
            if let imgArr = selectImgUrls {
                
                /// 如果图片张数超出最大限制数，只取最大限制数的图片
                var imgCount : Int = imgArr.count
                if imgCount > kMaxSelectCount {
                    imgCount = kMaxSelectCount
                }
                for index in imgCount ..< imageViewsArray.count {
                    let imgView: UIImageView = imageViewsArray[index]
                    imgView.isHidden = true
                }
                
//                let perRowItemCount = 3
                let margin: CGFloat = 10
                for (index,item) in imgArr.enumerated() {
                    
                    /// 如果图片张数超出最大限制数，只取最大限制数的图片
                    if index >= imgCount {
                        break
                    }
                    let columnIndex = index % perRowItemCount
                    let rowIndex = index/perRowItemCount
                    
                    let imgView: UIImageView = imageViewsArray[index]
                    
                    imgView.isHidden = false
                    imgView.kf.setImage(with: URL.init(string: item), placeholder: UIImage.init(named: "icon_bg_square_default"))
                    
                    imgView.frame = CGRect.init(x: CGFloat.init(columnIndex) * (imgWidth + margin), y: CGFloat.init(rowIndex) * (imgHight + margin), width: imgWidth, height: imgHight)
                }
                
            }
        }
    }
    
    // MARK: 生命周期方法
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI(){
        
        for index in 0 ..< kMaxSelectCount{
            let imgView: UIImageView = UIImageView()
            imgView.backgroundColor = kHeightGaryFontColor
            imgView.contentMode = .scaleAspectFill
            /// 超出部分裁剪
            imgView.clipsToBounds = true
            addSubview(imgView)
            imgView.tag = index
            imgView.addOnClickListener(target: self, action: #selector(onClickedImgView(sender:)))
            imageViewsArray.append(imgView)
        }
    }
    
    /// 查看大图
    ///
    /// - Parameter sender:
    @objc func onClickedImgView(sender: UITapGestureRecognizer){
        if onClickedImgDetailsBlock != nil {
            onClickedImgDetailsBlock!((sender.view?.tag)!,selectImgUrls!)
        }
    }
}
