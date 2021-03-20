//
//  LHSUserInfoModel.swift
//  LazyHuiService
//  用户信息model
//  Created by gouyz on 2017/6/21.
//  Copyright © 2017年 gouyz. All rights reserved.
//

import UIKit

@objcMembers
class LHSUserInfoModel: LHSBaseModel {
    /// 用户code
    var code : String? = ""
    /// 用户手机号
    var phone : String? = ""
    /// 用户的姓名（昵称）
    var uname : String? = ""
    /// 状态1为激活 0为没激活
    var state : String? = ""
    /// 头像
    var img : String? = ""
    /// 背景图片
    var bg_img : String? = ""
    ///     个性签名
    var remark : String? = ""
    
}
