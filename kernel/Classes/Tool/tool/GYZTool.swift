//
//  GYZTool.swift
//  LazyHuiSellers
//  通用功能
//  Created by gouyz on 2016/12/15.
//  Copyright © 2016年 gouyz. All rights reserved.
//

import UIKit
import AudioToolbox
import MJRefresh
import Foundation
import MBProgressHUD

///小于运算符
func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool
{
    switch (lhs, rhs)
    {
    case let (l?, r?):
        return l < r
    case (nil, _?):
        return true
    default:
        return false
    }
}
///等于运算符
func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool
{
    switch (lhs, rhs)
    {
    case let (l?, r?):
        return l > r
    default:
        return rhs < lhs
    }
}

class GYZTool: NSObject {

    
    ///1.单例
    static let shareTool = GYZTool()
    private override init() {}

    
    /// 播放声音
    ///这个只能播放不超过30秒的声音，它支持的文件格式有限，具体的说只有CAF、AIF和使用PCM或IMA/ADPCM数据的WAV文件
    /// - Parameter sound: 声音文件名称
    class func playAlertSound(sound:String)
    {
        //声音地址
        guard let soundPath = Bundle.main.path(forResource: sound, ofType: nil)  else { return }
        guard let soundUrl = NSURL(string: soundPath) else { return }
        //建立的systemSoundID对象
        var soundID:SystemSoundID = 0
        //赋值
        AudioServicesCreateSystemSoundID(soundUrl, &soundID)
        //播放声音
        AudioServicesPlaySystemSound(soundID)
    }
    
    ///MARK -添加上拉/下拉刷新
        
        /// 添加下拉刷新
        ///
        /// - Parameters:
        ///   - scorllView: 添加下拉刷新的视图
        ///   - pullRefreshCallBack: 刷新回调
        class func addPullRefresh(scorllView : UIScrollView?,pullRefreshCallBack : MJRefreshComponentAction?){
            
            if scorllView == nil || pullRefreshCallBack == nil {
                return
            }
    //        weak var weakScrollView = scorllView
            let refreshHeader : MJRefreshNormalHeader = MJRefreshNormalHeader.init {
                
                pullRefreshCallBack!()
                
    //            if weakScrollView?.mj_footer.isHidden == false {
    //                weakScrollView?.mj_footer.resetNoMoreData()
    //            }
            }
            
            scorllView?.mj_header = refreshHeader
        }
        /// 添加上拉刷新
        ///
        /// - Parameters:
        ///   - scorllView: 添加上拉刷新的视图
        ///   - loadMoreCallBack: 刷新回调
        class func addLoadMore(scorllView : UIScrollView?,loadMoreCallBack : MJRefreshComponentAction?){
            if scorllView == nil || loadMoreCallBack == nil {
                return
            }
            
            let loadMoreFooter = MJRefreshAutoNormalFooter.init {
                loadMoreCallBack!()
            }
            //空数据时，设置文字为空
            loadMoreFooter.setTitle("", for: .idle)
            loadMoreFooter.setTitle("正在为您加载数据", for: .refreshing)
            loadMoreFooter.setTitle("没有更多了~", for: .noMoreData)
    //        loadMoreFooter?.isAutomaticallyRefresh = false
            scorllView?.mj_footer = loadMoreFooter
        }
        /// 停止下拉刷新
        class func endRefresh(scorllView : UIScrollView?){
            scorllView?.mj_header!.endRefreshing()
        }
        
        /// 停止上拉加载
        class func endLoadMore(scorllView : UIScrollView?){
            scorllView?.mj_footer!.endRefreshing()
        }
        
        /// 提示没有更多数据的情况
        class func noMoreData(scorllView : UIScrollView?){
            scorllView?.mj_footer!.endRefreshingWithNoMoreData()
        }
        /// 重置没有更多数据的情况
        class func resetNoMoreData(scorllView : UIScrollView?){
            scorllView?.mj_footer!.resetNoMoreData()
        }
    
    /// 拨打电话
    ///
    /// - Parameter phone: 电话号码
    class func callPhone(phone: String){
        if phone.isEmpty {
            return
        }
        //有提示  iOS 10之后推荐使用下面的方法
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(URL(string: "tel:" + phone)!, options: [:]) { (success) in
                //OpenSuccess=选择 呼叫 为 1  选择 取消 为0
            }
        } else {
            UIApplication.shared.openURL(URL(string: "telprompt://"+phone)!)
        }
    }
    /// 跳转到safari
    ///
    /// - Parameter url:
    class func openSafari(url: String){
        //有提示  iOS 10之后推荐使用下面的方法
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(URL(string: url)!, options: [:]) { (success) in
                //OpenSuccess
            }
        } else {
            UIApplication.shared.openURL(URL(string: url)!)
        }
    }
    
    /// 退出登录时，移除用户信息
    class func removeUserInfo(){
        userDefaults.removeObject(forKey: kIsLoginTagKey)
        userDefaults.removeObject(forKey: "userCode")//用户token
        userDefaults.removeObject(forKey: "phone")//用户昵称
        userDefaults.removeObject(forKey: "uname")//用户头像
        userDefaults.removeObject(forKey: "header")//用户ID
        
    }
    
    /// 字典或数组转json字符串
    ///
    /// - Parameter data: 字典或数组
    /// - Returns: 字符串
    class func convertDictionaryToString(data: Any) -> String{
        var result:String = ""
        do {
            //如果设置options为JSONSerialization.WritingOptions.prettyPrinted，则打印格式更好阅读
            let jsonData = try JSONSerialization.data(withJSONObject: data, options: JSONSerialization.WritingOptions.init(rawValue: 0))
            
            if let JSONString = String(data: jsonData, encoding:.utf8) {
                result = JSONString
            }
            
        } catch {
            result = ""
        }
        return result
    }
    
    
    //MARK: 计算天数差 
    static func dateDifference(_ endDate:Date, from startDate:Date) -> Double {
        let interval = endDate.timeIntervalSince(startDate)
        return interval/86400  //24*60*60
        
    }
    /// 得到当前时间之前和之后N天的日期
    ///
    /// - Parameters:
    ///   - currDate: 当前日期
    ///   - dayNum: 当前时间之前和之后N天，之前的传负数，之后传正数
    /// - Returns: 日期
    static func getBehindDay(currDate: Date,dayNum: Int) -> Date?{
        
        var date  = currDate
        if dayNum != 0 {
            let oneDay = TimeInterval(86400*dayNum)
            date = currDate.addingTimeInterval(oneDay)
        }
        
        return date
    }
    /*
     * 根据日期格式字符串返回日期代表星期几
     * 参数：date  日期
     * 返回值：日期代表星期几，Int类型，星期一到星期日分别表示为：1～7
     */
    static func getWeekDay(date: Date ) -> Int{
        
        let interval = Int(date.timeIntervalSince1970) + NSTimeZone.local.secondsFromGMT()
        
        let days = Int(interval/86400) // 24*60*60
        let weekday = ((days + 4)%7+7)%7
        ///星期一到星期日分别表示为：1～7
//        return weekday == 0 ? 7 : weekday
        /// 周日到周六分别表示为：0～6
        return weekday
    }
    
    /// 设置label/textView行间距
    ///
    /// - Parameters:
    ///   - str: 字符串
    ///   - lineSpace: 行间距
    /// - Returns:
    static func getAttributeStringWithString(str: String,lineSpace:CGFloat
        ) -> NSAttributedString{
        
        let attributedString = NSMutableAttributedString(string: str)
        let paragraphStye = NSMutableParagraphStyle()
        
        //调整行间距
        paragraphStye.lineSpacing = lineSpace
        let rang = NSMakeRange(0, str.count)
        attributedString .addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStye, range: rang)
        
        return attributedString
        
    }
    
    //MARK: - 获取IP
    //获取本机ip
    static func getIPAddresses() -> String? {
        
        var address: String?
        
        // get list of all interfaces on the local machine
        
        var ifaddr: UnsafeMutablePointer<ifaddrs>? = nil
        
        guard getifaddrs(&ifaddr) == 0 else {
            return nil
        }
        
        guard let firstAddr = ifaddr else {
            return nil
        }
        
        for ifptr in sequence(first: firstAddr, next: { $0.pointee.ifa_next }) {
            
            let interface = ifptr.pointee
            
            // Check for IPV4 or IPV6 interface
            
            let addrFamily = interface.ifa_addr.pointee.sa_family
            
            if addrFamily == UInt8(AF_INET) || addrFamily == UInt8(AF_INET6) {
                
                // Check interface name
                let name = String(cString: interface.ifa_name)
                if name == "en0" {
                    
                    // Convert interface address to a human readable string
                    
                    var addr = interface.ifa_addr.pointee
                    
                    var hostName = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                    
                    getnameinfo(&addr, socklen_t(interface.ifa_addr.pointee.sa_len),
                                &hostName, socklen_t(hostName.count), nil, socklen_t(0), NI_NUMERICHOST)
                    
                    address = String(cString: hostName)
                }
            }
        }
        
        freeifaddrs(ifaddr)
        return address
    }
    
    /// 禁止输入emoji
    ///
    /// - Parameter text:
    static func disableEmoji(text: String) -> String{
        
        do{
            let regex: NSRegularExpression = try NSRegularExpression.init(pattern: "[^\\u0020-\\u007E\\u00A0-\\u00BE\\u2E80-\\uA4CF\\uF900-\\uFAFF\\uFE30-\\uFE4F\\uFF00-\\uFFEF\\u0080-\\u009F\\u2000-\\u201f\r\n]", options: .caseInsensitive)
            
            let modifiedString: String = regex.stringByReplacingMatches(in: text, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSRange.init(location: 0, length: text.count), withTemplate: "")
            
            return modifiedString
            
        }catch{
            return text
        }
    }
    
    /// 检测网络状态
    ///
    /// - Returns: 有网络返回true
    static func checkNetWork() -> Bool{
        if !(networkManager?.isReachable)! {
            MBProgressHUD.showCustomTimeHUD(message: kNoNetWork, time: 3.0)
            return false
        }
        return true
    }
    
    ///保存用户信息
//    static func saveUserInfo(userModel: LHSUserInfoModel){
//        ///保存用户信息
//        let model = NSKeyedArchiver.archivedData(withRootObject: userModel)
//        userDefaults.set(model, forKey: USERINFO)
//    }
    /**
     字典转换为JSONString
     
     - parameter dictionary: 字典参数
     
     - returns: JSONString
     */
    static func getJSONStringFromDictionary(dictionary:[String: Any]) -> String {
        if (!JSONSerialization.isValidJSONObject(dictionary)) {
            print("无法解析出JSONString")
            return ""
        }
        let data : NSData! = try? JSONSerialization.data(withJSONObject: dictionary, options: []) as NSData
        let JSONString = NSString(data:data as Data,encoding: String.Encoding.utf8.rawValue)
        return JSONString! as String
        
    }
    /**
     字典|数组 转Data
     
     - parameter object: 参数
     
     - returns: Data
     */
    static func ObjectToData(object: Any) -> Data? {
        do {
            //如果设置options为JSONSerialization.WritingOptions.prettyPrinted，则打印格式更好阅读
            return try JSONSerialization.data(withJSONObject: object, options: JSONSerialization.WritingOptions.prettyPrinted)
        } catch {
            print(error)
        }
        return nil
        
    }
    /// 根据图片原url及缩略图url获取图片宽高比
    ///
    /// - Parameters:
    ///   - url: 图片原url
    ///   - thumbUrl: 缩略图url
    /// - Returns: 图片宽高比
    static func getThumbScale(url:String,thumbUrl: String)-> Double{
        if thumbUrl.isEmpty {
            return 0
        }
        let str = thumbUrl.subString(start: url.count + 1)
        let strSize = str.subString(start: 0, length: str.count - 4)
        
        let strArr = strSize.components(separatedBy: "x")
        if strArr.count > 0 {
            return Double.init(strArr[1])! / Double.init(strArr[0])!
        }
        
        return 0
    }
    /// 根据图片原url及缩略图url获取图片宽高size
    ///
    /// - Parameters:
    ///   - url: 图片原url
    ///   - thumbUrl: 缩略图url
    /// - Returns: 图片宽高比
    static func getThumbSize(url:String,thumbUrl: String)-> CGSize{
        if thumbUrl.isEmpty {
            return CGSize.zero
        }
        let str = thumbUrl.subString(start: url.count + 1)
        let strSize = str.subString(start: 0, length: str.count - 4)
        
        let strArr = strSize.components(separatedBy: "x")
        if strArr.count > 0 {
            return CGSize.init(width: Double.init(strArr[0])!, height: Double.init(strArr[1])!)
        }
        
        return CGSize.zero
    }
    //获取拼音首字母（大写字母）
    func findFirstLetterFromString(aString: String) -> String {
        //转变成可变字符串
        let mutableString = NSMutableString.init(string: aString)
        
        //将中文转换成带声调的拼音
        CFStringTransform(mutableString as CFMutableString, nil,      kCFStringTransformToLatin, false)
        
        //去掉声调
        let pinyinString = mutableString.folding(options:          String.CompareOptions.diacriticInsensitive, locale:   NSLocale.current)
        
        //将拼音首字母换成大写
        let strPinYin = polyphoneStringHandle(nameString: aString,    pinyinString: pinyinString).uppercased()
        
        //截取大写首字母
        let firstString = strPinYin.substring(to:     strPinYin.index(strPinYin.startIndex, offsetBy: 1))
        
        //判断首字母是否为大写
        let regexA = "^[A-Z]$"
        let predA = NSPredicate.init(format: "SELF MATCHES %@", regexA)
        return predA.evaluate(with: firstString) ? firstString : "#"
    }
    
    //多音字处理，根据需要添自行加
    func polyphoneStringHandle(nameString: String, pinyinString: String) -> String {
        if nameString.hasPrefix("长") {return "chang"}
        if nameString.hasPrefix("沈") {return "shen"}
        if nameString.hasPrefix("厦") {return "xia"}
        if nameString.hasPrefix("地") {return "di"}
        if nameString.hasPrefix("重") {return "chong"}
        return pinyinString
    }
}
