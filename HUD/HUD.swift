//
//  HUD.swift
//
//  Created by wangluguang on 16/3/14.
//  Copyright © 2016年 wangluguang. All rights reserved.
//

import UIKit

class HUD: NSObject {
    
    //  MARK: - Internal defination type
    
    enum HUDType {
        case Msg
        case HorizontalMsgImg
        case HorizontalMsgImgs
        case VerticalMsgOK
        case VerticalMsgOKCancel
        case Process
        case MsgOKCancel
        
        // 简单弹出的几种View
        case View
        case Image
        case Activity       //菊花
        case UserGuide1     //新手引导(首页)
        case UserGuide2     //新手引导(功能也)
        case Loading        //加载动画
        
        //  俩Custom的Picker
        case DatePicker
        case VolumePicker
        
        //  ActionSheet
        case ActionSheet
        
        // add more type here ...
        case Common    // 通用类型，代表上述所有类型, 一般是按钮回调时用这个类型
        case Hidden     // 当前HUD已隐藏
    }
    
    /// 自定义block
    typealias HUDBlock = (info: [String: Any]?) -> Void
    /// 用于保存一些操作的block
    typealias HUDStoreFuncBlock = () -> [String: Any]?
    /// 内部用的Window子类
    class HUDView: UIView {
        /// 用于存储内部操作的block
        private var blockStoredFunctions: HUDStoreFuncBlock? = nil
        /// 确定
        var blockOK: HUDBlock? = nil
        /// 取消
        var blockCancel: HUDBlock? = nil
        /// 进度条完成后的blk
        var finishBlk: HUDBlock? = nil
        /// onOKClick | onCancelClick 响应时，需不需要自动隐藏HUD
        var hiddenWhenClick: Bool = true
        //动画的代理
        override func animationDidStop(anim: CAAnimation, finished flag: Bool) {
            if flag == true {
                HUD.lyProcess?.strokeStart = 0
                HUD.lyProcess?.strokeEnd = HUD.process
                HUD.lyProcess?.removeAllAnimations()
                // 达到100% 自动隐藏
                if HUD.process >= 1 {
                    HUD.hiddenHUD(.Process)
                }
            }
        }
        
        /// 点击 确定
        func onOKClick() {
            self.endEditing(true)
            // 可能有操作，先执行一下，把信息拿出来
            let info = self.blockStoredFunctions?()
            // 把可能有的信息传出去
            self.blockOK?(info: info)
            if hiddenWhenClick == true {
                HUD.hiddenHUD(.Common)
            }
        }
        /// 点击 取消
        func onCancelClick() {
            self.endEditing(true)
            self.blockCancel?(info: nil)
            if hiddenWhenClick == true {
                HUD.hiddenHUD(.Common)
            }
        }
    }
    
    /// 内部类Button
    class HUDButton: UIButton {
        /// 回调blk
        private var blk: (() -> Void)?
        
        /// 添加一个事件
        func addAction(title: String, titleColor: UIColor, font: UIFont, blk:() -> Void) {
            self.blk = blk
            self.setTitle(title, forState: .Normal)
            self.setTitleColor(titleColor, forState: .Normal)
            self.titleLabel?.font = font
            self.addTarget(self, action: "onAction", forControlEvents: .TouchUpInside)
        }
        
        /// 回调
        func onAction() {
            blk?()
        }
        
    }
    
    //  MARK: - Static Propertys
    /// 默认显示动画时间
    private static let showDuration: NSTimeInterval = 0.25
    /// 默认消失时间
    private static let autoHideTime: NSTimeInterval = 2.5
    /// 按钮H
    private static let btnH: CGFloat = 54/2
    /// 按钮W
    private static let btnW: CGFloat = 176/2
    /// 边距S
    private static let marginS: CGFloat = 30/2
    /// 边距L
    private static let marginL: CGFloat = 50/2
    /// 圆角
    private static let cornerRadius: CGFloat = 10/2
    /// 最大宽度S
    private static let maxWidthS: CGFloat = 350/2
    /// 最大宽度L
    private static let maxWidthL: CGFloat = 516/2
    /// 字号12
    private static let font12: CGFloat = 12
    /// 字号14
    private static let font14: CGFloat = 14
    /// 字号16
    private static let font16: CGFloat = 16
    /// 字号18
    private static let font18: CGFloat = 18
    /// 线条宽度
    private static let lineWidth: CGFloat = 5
    /// 线条背景颜色
    private static let lineColorBg: UIColor = UIColor.grayColor()
    /// 线条颜色
    private static let lineColor: UIColor = UIColor.blackColor()
    /// 圆形外直径
    private static let diameter: CGFloat = 144/2
    /// 圆形内直径
    private static let diameterInner: CGFloat = HUD.diameter - 2 * (HUD.lineWidth + HUD.lineWidth)
    /// 灰色layer背景
    private static var lyProcessBg: CAShapeLayer? = nil
    /// 蓝色layer
    private static var lyProcess: CAShapeLayer? = nil
    /// 一个动态变内容的提示
    private static var lbHint: UILabel? = nil
    /// 进度
    private static var process: CGFloat = 0
    /// 一个新的view
    private static let baseView: HUDView = {
        let v: HUDView = HUDView(frame: UIScreen.mainScreen().bounds)
        v.userInteractionEnabled = true
        v.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        v.alpha = 0
        return v
    }()
    
    //  MARK: - Privated function
    
    /// 当前HUD的显示类型
    private static var hudType: HUDType = .Hidden
    /// 获取当前的HUD类型
    static var currentHUDType: HUDType {
        return hudType
    }
    
    private static let baseWin: UIWindow = {
        let win = UIApplication.sharedApplication().windows.first!
        return win
    }()
    
    /// 所有的show方法都要调用这个function
    private static func initial(type: HUDType, autoHidden: Bool = true) {
        // 标记当前状态
        hudType = type
        // 隐藏键盘 如果有的话
        if let responder = UIResponder.currentFirstResponder() {
            responder.resignFirstResponder()
        }
        // 是否自动隐藏
        if autoHidden == true {
            let delay: NSTimeInterval = HUD.autoHideTime
            let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay * Double(NSEC_PER_SEC)))
            dispatch_after(time, dispatch_get_main_queue(), { () -> Void in
                self.hiddenHUD(type)
            })
        }
    }
    /// 线性动画
    private static func animationLinear(duration: NSTimeInterval = showDuration, completion: ((Bool) -> Void)? = nil) {
        baseWin.addSubview(baseView)
        baseView.alpha = 0
        
        UIView.animateWithDuration(duration, animations: { () -> Void in
            baseView.alpha = 1
            }, completion: completion)
    }
    /// 弹性动画
    private static func animationSpring(duration: NSTimeInterval = showDuration, completion: ((Bool) -> Void)? = nil) {
        baseWin.addSubview(baseView)
        baseView.alpha = 1
        baseView.subviews.last?.transform = CGAffineTransformMakeScale(0.5, 0.5)
        UIView.animateWithDuration(duration, delay: 0.0, usingSpringWithDamping: 0.4, initialSpringVelocity: 0.0, options: [], animations: { () -> Void in
            baseView.subviews.last?.transform = CGAffineTransformIdentity
            }, completion: completion)
    }
    
    //  MARK: - Can invoke functions
    
    /// 隐藏HUD 类型必须对应上
    static func hiddenHUD(type: HUDType, animated: Bool = true) {
        // 当前是 匹配 | 通用 的类型，就能隐藏
        guard type == hudType || type == .Common else {
            return
        }
        // 标记当前为隐藏状态
        hudType = .Hidden
        
        // 移除subView
        let _ = baseView.subviews.map { $0.removeFromSuperview() }
        // 重置相关静态变量
        lyProcessBg?.removeFromSuperlayer()
        lyProcess?.removeFromSuperlayer()
        lbHint = nil
        baseView.blockOK = nil
        baseView.blockCancel = nil
        baseView.finishBlk = nil
        baseView.blockStoredFunctions = nil
        baseView.hiddenWhenClick = true
        // 移除相关手势
        if let gests = baseView.gestureRecognizers {
            for gest in gests {
                baseView.removeGestureRecognizer(gest)
            }
        }
        
        if animated == true {
            // 隐藏动画
            UIView.animateWithDuration(0.25, animations: { () -> Void in
                baseView.alpha = 0
                }) { (finish) -> Void in
                    if finish == true {
                        baseView.removeFromSuperview()
                    }
            }
        } else {
            baseView.alpha = 0
            baseView.removeFromSuperview()
        }
    }
    
    /// 显示Msg
    static func showMsg(msg: String, autoHidden: Bool = true) {
        // 标记当前win的显示状态
        guard hudType == .Hidden else {
            // 必须是相同类型的 才能动态改变文本内容
            guard hudType == .Msg else { return }
            lbHint?.text = msg
            baseView.setNeedsUpdateConstraints()
            return
        }
        // init
        self.initial(.Msg, autoHidden: autoHidden)
        // setup
        let v = baseView.createSubView()
        v.centerX().centerY()
        v.backgroundColor = UIColor.whiteColor()
        v.clipsToBounds = true
        v.layer.cornerRadius = cornerRadius
        
        lbHint = v.createSubLabel()
        lbHint?.left(marginS).top(marginS).right(marginS).bottom(marginS)
        lbHint?.preferredMaxLayoutWidth = maxWidthL - 2 * marginS
        lbHint?.text = msg
        lbHint?.numberOfLines = 0
        lbHint?.textColor = UIColor.blackColor()
        lbHint?.textAlignment = .Center
        lbHint?.font = UIFont.systemFontOfSize(font14)
        
        self.animationSpring()
    }
    
    /// 显示Msg & Img (横排)
    static func showHorizontalMsg(msg: String, img: UIImage, autoHidden: Bool = true) {
        // 标记当前win的显示状态
        guard hudType == .Hidden else {
            return
        }
        self.initial(.HorizontalMsgImg, autoHidden: autoHidden)
        
        let v = baseView.createSubView()
        v.centerX().centerY()
        v.backgroundColor = UIColor.whiteColor()
        v.clipsToBounds = true
        v.layer.cornerRadius = cornerRadius
        
        let btn = v.createSubButton()
        btn.left(marginS).top(marginS).right(marginS).bottom(marginS)
        btn.userInteractionEnabled = false
        btn.setTitle(msg, forState: .Normal)
        btn.setTitleColor(UIColor.blackColor(), forState: .Normal)
        btn.setImage(img, forState: .Normal)
        
        self.animationSpring()
    }
    
    /// 显示Msg & Imges (横排)
    static func showHorizontalMsg(msg: String, imgs: [UIImage],autoHidden: Bool = true) {
        // 标记当前win的显示状态
        guard hudType == .Hidden else {
            return
        }
        self.initial(.HorizontalMsgImgs, autoHidden: autoHidden)
        
        let v = baseView.createSubView()
        v.centerX().centerY()
        v.backgroundColor = UIColor.whiteColor()
        v.clipsToBounds = true
        v.layer.cornerRadius = cornerRadius
        
        let iv = v.createSubImageView()
        iv.left(marginS).top(marginS).width(46/2).height(46/2).bottom(marginS)
        iv.animationImages = imgs
        let img = imgs.last
        iv.animationRepeatCount = 1
        
        let lb = v.createSubLabel()
        lb.right(marginS, toItem: iv).alignTop(toItem: iv).right(marginS)
        lb.text = msg
        lb.numberOfLines = 1
        lb.textColor = UIColor.lightGrayColor()
        lb.textAlignment = .Center
        lb.font = UIFont(name: "STXihei", size: font14)
        
        self.animationSpring { [weak iv] (finish) -> Void in
            if finish == true {
                iv?.image = img
                iv?.startAnimating()
            }
        }
    }
    
    /// 显示Msg & Img (竖排)
    static func showVerticalAttrMsg(msg: NSAttributedString, subAttrMsg: NSAttributedString? = nil, titleOK: String, blockOK: HUDBlock) {
        // 标记当前win的显示状态
        guard hudType == .Hidden else {
            return
        }
        self.initial(.VerticalMsgOK, autoHidden: false)
        
        // 保存blockOK
        baseView.blockOK = blockOK
        
        let v = baseView.createSubView()
        v.centerX().centerY().width(maxWidthL)
        v.backgroundColor = UIColor.whiteColor()
        v.clipsToBounds = true
        v.layer.cornerRadius = cornerRadius
        
        let lb1 = v.createSubLabel()
        lb1.top(marginL).centerX()
        lb1.preferredMaxLayoutWidth = maxWidthL - 2 * marginS
        lb1.attributedText = msg
        lb1.textAlignment = .Center
        lb1.numberOfLines = 0
        
        
        var lb2: UILabel?
        if let subMsg = subAttrMsg {
            lb2 = v.createSubLabel()
            lb2?.alignLeading(toItem: lb1).bottom(30/2, toItem: lb1).right(marginS)
            lb2?.preferredMaxLayoutWidth = maxWidthL - 2 * marginS
            lb2?.attributedText = subMsg
            lb2?.numberOfLines = 0
            lb2?.textAlignment = .Left
        }
        
        let btn = v.createSubButton()
        btn.centerX().bottom(38/2, toItem: lb2 ?? lb1).width(120).height(40).bottom(marginS)
        btn.setTitle(titleOK, forState: .Normal)
        btn.titleLabel?.font = UIFont.systemFontOfSize(font14)
        btn.addTarget(self.baseView, action: "onOKClick", forControlEvents: .TouchUpInside)
        
        self.animationSpring()
    }
    
    /// 显示圆形进度 (100%后会自动隐藏)
    static func showProcess(pro: CGFloat?, image img: UIImage? = nil, hint hintStr: String? = nil) {
        let lastProcess = self.process
        self.process = pro ?? self.process
        self.process = self.process <= 1 ? self.process : 1
        
        guard hudType == .Hidden else {
            guard hudType == .Process else {
                return
            }
            if hintStr != nil {
                lbHint?.text = hintStr
                lbHint?.hidden = false
                lbHint?.setNeedsUpdateConstraints()
            }
            // 动画
            let animate = CABasicAnimation(keyPath: "strokeEnd")
            animate.delegate = baseView
            animate.fromValue = lastProcess
            animate.toValue = process
            animate.duration = NSTimeInterval(2.0 * (process - lastProcess))
            lyProcess?.addAnimation(animate, forKey: "process")
            return
        }
        
        HUD.initial(.Process, autoHidden: false)
        
        // 白背景
        let vContent = baseView.createSubView()
        vContent.centerX().centerY().width(diameter).height(diameter)
        vContent.backgroundColor = UIColor.whiteColor()
        vContent.clipsToBounds = true
        vContent.layer.cornerRadius = diameter / 2
        
        // 进度条
        let path: CGPath = UIBezierPath(arcCenter: CGPointMake(diameter/2, diameter/2), radius: diameterInner/2 + lineWidth/2, startAngle: CGFloat(-M_PI_2), endAngle: CGFloat(3 * M_PI_2), clockwise: true).CGPath
        // 灰色
        lyProcessBg = CAShapeLayer()
        vContent.layer.addSublayer(lyProcessBg!)
        lyProcessBg!.path = path
        lyProcessBg!.lineWidth = lineWidth
        lyProcessBg!.strokeColor = lineColorBg.CGColor
        lyProcessBg!.fillColor = UIColor.clearColor().CGColor
        lyProcessBg!.strokeStart = 0
        lyProcessBg!.strokeEnd = 1
        // 蓝色
        lyProcess = CAShapeLayer()
        vContent.layer.addSublayer(lyProcess!)
        lyProcess!.path = path
        lyProcess!.lineWidth = lineWidth
        lyProcess!.strokeColor = lineColor.CGColor
        lyProcess!.fillColor = UIColor.clearColor().CGColor
        lyProcess!.lineCap = "round"
        lyProcess!.strokeStart = 0
        lyProcess!.strokeEnd = 0
        
        // 图片
        let ivIcon = baseView.createSubImageView()
        ivIcon.centerX().centerY().width(diameterInner).height(diameterInner)
        ivIcon.image = img
        ivIcon.clipsToBounds = true
        ivIcon.layer.cornerRadius = diameterInner / 2
        
        // 提示（有可能隐藏）
        lbHint = baseView.createSubLabel()
        lbHint?.centerX().bottom(20, toItem: vContent)
        lbHint?.preferredMaxLayoutWidth = maxWidthL
        lbHint?.backgroundColor = UIColor.clearColor()
        lbHint?.numberOfLines = 0
        lbHint?.text = hintStr
        lbHint?.textColor = UIColor.whiteColor()
        lbHint?.font = UIFont.systemFontOfSize(15)
        lbHint?.textAlignment = .Center
        lbHint?.hidden = hintStr == nil ? true : false
        
        // 动画
        HUD.animationLinear { (flag) -> Void in
            guard flag == true else { return }
            let animate = CABasicAnimation(keyPath: "strokeEnd")
            animate.delegate = baseView
            animate.fromValue = 0
            animate.toValue = self.process
            animate.autoreverses = false
            animate.repeatCount = 0
            animate.fillMode = "forwards"
            animate.removedOnCompletion = false
            animate.duration = NSTimeInterval(2.0 * self.process)
            self.lyProcess?.addAnimation(animate, forKey: "process")
        }   // animate
    }
    
    /**
     attrMsg: 提示内容
     titleOK: 确定标题
     blkOK: 确定Block
     titleCancel: 取消标题(可为nil)
     blkCancel: 取消Block(可为nil)
     */
    static func showAttrMsg(attrMsg: NSAttributedString, alignment: NSTextAlignment = .Left, titleOK: String, blkOK: HUDBlock, titleCancel: String? = nil, blkCancel: HUDBlock? = nil) {
        // 标记当前win的显示状态
        guard hudType == .Hidden else {
            return
        }
        self.initial(.MsgOKCancel, autoHidden: false)
        
        // 保存block
        baseView.blockOK = blkOK
        baseView.blockCancel = blkCancel
        
        // UI
        let vContain = baseView.createSubView()
        vContain.centerX().centerY().width(maxWidthL)
        vContain.backgroundColor = UIColor.whiteColor()
        vContain.clipsToBounds = true
        vContain.layer.cornerRadius = cornerRadius
        
        let lb = vContain.createSubLabel()
        lb.centerX().top(marginL).width(maxWidthL - 2 * marginL)
        lb.preferredMaxLayoutWidth = maxWidthL - 2 * marginL
        lb.attributedText = attrMsg
        lb.numberOfLines = 0
        lb.textAlignment = alignment
        
        // btn UI & 约束
        let btnOK = vContain.createSubButton()
        btnOK.setTitle(titleOK, forState: .Normal)
        btnOK.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        btnOK.setTitleColor(UIColor.whiteColor(), forState: .Highlighted)
        btnOK.setBackgroundImage(UIImage(named: "btn_jieshou"), forState: .Normal)
        btnOK.setBackgroundImage(UIImage(named: "btn_jieshou"), forState: .Highlighted)
        btnOK.addTarget(baseView, action: "onOKClick", forControlEvents: .TouchUpInside)
        btnOK.titleLabel?.font = UIFont.systemFontOfSize(font16)
        if let ttlCncl = titleCancel { // 0202 14:25 delete: let _ = blkCancel
            btnOK.right(marginL).bottom(marginL, toItem: lb).height(btnH).width(btnW).bottom(marginL)
            
            let btnCancel = vContain.createSubButton()
            btnCancel.left(marginL).alignTop(toItem: btnOK).width(btnW).height(btnH)
            btnCancel.setTitle(ttlCncl, forState: .Normal)
            btnCancel.setTitleColor(UIColor.blackColor(), forState: .Normal)
            btnCancel.setTitleColor(UIColor.blackColor(), forState: .Highlighted)
            btnCancel.titleLabel?.font = UIFont.systemFontOfSize(font16)
            btnCancel.addTarget(baseView, action: "onCancelClick", forControlEvents: .TouchUpInside)
        } else {
            btnOK.centerX().bottom(marginL * 2, toItem: lb).width(btnW).height(btnH).bottom(marginL)

        }
        // show
        self.animationSpring()
    }
    
    
    /**
     弹出一个任意的View，大小、位置自己定义
     
     - parameter type:       显示的类型
     - parameter autoHidden: 是否自动隐藏
     - parameter setupView:  一个block，含有vContain参数作为容器，内容可以放里边，另外还有一个可选的返回值block，把需要的操作放入这个类型的block中，[String: Any]是可能需要的知道的值，在点击vContain后，会作为参数回传回来
     - parameter tapBlock:   点击的后的回调，参数是(() -> [String: Any]?) block的返回值
     */
    static func showView(type: HUDType, hiddenWhenClick: Bool = true, animation: Bool = true, @noescape setupView: (vContain: UIView) -> (() -> [String: Any]?)?, tapBlock: HUDBlock?) {
        // 标记当前win的显示状态
        guard hudType == .Hidden else {
            return
        }
        self.initial(type, autoHidden: false)
        self.baseView.hiddenWhenClick = hiddenWhenClick
        
        // 容器View
        let vContain = self.baseView.createSubView()
        vContain.backgroundColor = UIColor.whiteColor()
        
        // 保存block
        self.baseView.blockOK = tapBlock
        // 添加tap手势给view，目标是baseView的blockOK
        let tap = UITapGestureRecognizer(target: self.baseView, action: "onOKClick")
        self.baseView.addGestureRecognizer(tap)
        
        self.baseView.blockStoredFunctions = setupView(vContain: vContain)
        
        if animation == true {
            self.animationSpring()
        } else {
            self.animationSpring(0, completion: nil)
        }
    }
    
    /**
     显示一个image
     
     - parameter image:      image
     - parameter imgSize:    image尺寸，默认为(w: 140, h: 140)
     - parameter autoHidden: 自动隐藏
     - parameter tapBlock:   点击后的回调
     */
    static func showImage(image: UIImage, title: String? = nil, imgSize: CGSize? = nil, tapBlock: HUDBlock?) {
        
        self.showView(.Image, setupView: { (vContain) -> (() -> [String : Any]?)? in
            
            // 在容器视图vContain搭建样式
            let w = imgSize?.width ?? image.size.width
            let h = imgSize?.height ?? image.size.height
            
            vContain.centerX().centerY().width(w).height(h)
            vContain.backgroundColor = UIColor.whiteColor()
            
            let iv = vContain.createSubImageView()
            iv.left(0).right(0).top(0).bottom(0)
            iv.userInteractionEnabled = true
            iv.image = image
            iv.contentMode = .Redraw
            
            if let ttl = title {
                let lb = vContain.createSubLabel()
                lb.centerX().top(marginS, toItem: iv)
                lb.text = ttl
                lb.font = UIFont.systemFontOfSize(14)
                lb.textAlignment = .Center
                lb.textColor = UIColor.whiteColor()
            }
            // 不需要存储额外的操作
            return nil
            
            }, tapBlock: tapBlock)
    }
    
    /**
     显示一个菊花
     
     - parameter hiddenWhenClick: 点击后是否自动隐藏
     - parameter clickBlock:      点击后的回调，不自动隐藏是，要手动调 HUD.hidden(.Activity)
     */
    static func showActivity(animation: Bool, hiddenWhenClick: Bool = true, clickBlock: HUDBlock?) {
        self.showView(.Activity, hiddenWhenClick: hiddenWhenClick, setupView: { (vContain) -> (() -> [String : Any]?)? in
            vContain.centerX().centerY()
            
            vContain.layer.cornerRadius = self.cornerRadius
            vContain.clipsToBounds = true
            vContain.layer.shadowColor = UIColor.blackColor().CGColor
            vContain.layer.shadowOffset = CGSize(width: 5, height: 5)
            vContain.layer.shadowOpacity = 0.5
            
            let activity = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.WhiteLarge)
            activity.color = UIColor.grayColor()
            activity.hidesWhenStopped = true
            vContain.addSubview(activity)
            activity.translatesAutoresizingMaskIntoConstraints = false
            activity.left(marginL).top(marginL).right(marginL).bottom(marginL)
            activity.startAnimating()
            return nil
            }, tapBlock: clickBlock)
    }
    
//---------------------------------- pickers --------------------------------------
    
    /// picker的高
    private static var pickerH: CGFloat = 0
    /// 向上弹的动画
    private static func animationPopUp(completion: ((Bool) -> Void)? = nil) {
        baseWin.addSubview(baseView)
        
        baseView.alpha = 1
        let v = baseView.subviews.last
        v?.transform = CGAffineTransformMakeTranslation(0, pickerH)
        UIView.animateWithDuration(0.25, animations: { () -> Void in
            v?.transform = CGAffineTransformIdentity
        }, completion: completion)
    }
    
    ///  用于显示Picker的基础方法，定义了样式，但内容没定, title: 标题， height: 内容高度, setupView中含有一个配置好的容器，子View放里面，点击确定按钮想执行的操作存在HUDStoreFuncBlock中，并返回，HUDStoreFuncBlock中的返回值会在blkOK中作为参数传回
    private static func showPicker(title: String, height: CGFloat, type: HUDType, @noescape setupView: (vContent: UIView) -> (() -> [String: Any]?)?, blkOK: HUDBlock?, blkCancel: HUDBlock?) {
        // 标记当前win的显示状态
        guard hudType == .Hidden else {
            return
        }
        self.initial(type, autoHidden: false)
        
        // 保存block
        self.baseView.blockOK = blkOK
        self.baseView.blockCancel = blkCancel
        
        // 先把picker的height保存下来，之后的动画会用
        let barH: CGFloat = 40
        self.pickerH = height + barH  // 40是bar的高度
        
        // 布局UI
        let vContain = self.baseView.createSubView()
        vContain.left(0).right(0).bottom(0).height(pickerH)
        vContain.backgroundColor = UIColor.clearColor()
        
        let ivBar = vContain.createSubImageView()
        ivBar.left(0).top(0).right(0).height(barH)
        ivBar.image = UIImage(named: "pic_xuanzekuang")
        ivBar.userInteractionEnabled = true
        
        let btnCancel = ivBar.createSubButton()
        btnCancel.left(5).centerY().width(barH).height(barH)
        btnCancel.titleLabel?.font = UIFont.systemFontOfSize(14)
        btnCancel.setTitle("取消", forState: .Normal)
        btnCancel.setTitleColor(UIColor.lightGrayColor(), forState: .Normal)
        btnCancel.addTarget(self.baseView, action: "onCancelClick", forControlEvents: .TouchUpInside)
        
        let btnOK = ivBar.createSubButton()
        btnOK.right(5).centerY().width(barH).height(barH)
        btnOK.titleLabel?.font = UIFont.systemFontOfSize(14)
        btnOK.setTitle("确定", forState: .Normal)
        btnOK.setTitleColor(UIColor.lightGrayColor(), forState: .Normal)
        btnOK.addTarget(self.baseView, action: "onOKClick", forControlEvents: .TouchUpInside)
        
        let lbTitle = ivBar.createSubLabel()
        lbTitle.centerX().centerY()
        lbTitle.text = title
        lbTitle.textAlignment = .Center
        lbTitle.textColor = UIColor.lightGrayColor()
        lbTitle.font = UIFont.systemFontOfSize(14)

        let vContent = vContain.createSubView()
        vContent.left(0).bottom(0, toItem: ivBar).right(0).bottom(0)
        vContent.backgroundColor = UIColor.whiteColor()
        
        // 把搭好的容器传给setupView这个block，并将setupView返回的操作存起来
        self.baseView.blockStoredFunctions = setupView(vContent: vContent)
        
        self.animationPopUp()
    }
    
    
    /// 显示2个datePicker, 返回的值在ok回调info里，key: String = start | end, value: String (如: 12.23, 表示12:23)
    static func showDatePicker(blkOK blkOK: HUDBlock?, blkCancel: HUDBlock?) {
        
        // 调用上面通用显示picker的方法，回调里会给一个配置好容器View，在里边随便加上面都行
        self.showPicker("设定开关机时间", height: 235, type: .DatePicker, setupView: { (vContent) -> (() -> [String: Any]?)? in
            let screenW = UIScreen.mainScreen().bounds.width
            let vPowerOnContain = vContent.createSubView()
            vPowerOnContain.left(0).top(0).bottom(0).width(screenW/2)
            vPowerOnContain.backgroundColor = UIColor.whiteColor()
            
            let vPowerOffContain = vContent.createSubView()
            vPowerOffContain.right(0).top(0).bottom(0).width(screenW/2)
            vPowerOffContain.backgroundColor = UIColor.whiteColor()
            
            // 开机时间
            let lbPowerOn = vPowerOnContain.createSubLabel()
            lbPowerOn.left(0).right(0).top(0).height(40)
            lbPowerOn.text = "开机时间"
            lbPowerOn.textAlignment = .Center
            lbPowerOn.textColor = UIColor.grayColor()
            lbPowerOn.font = UIFont.systemFontOfSize(20)
            
            let dpPowerOn = DatePickerView()
            vPowerOnContain.addSubview(dpPowerOn)
            dpPowerOn.translatesAutoresizingMaskIntoConstraints = false
            dpPowerOn.left(0).bottom(0, toItem: lbPowerOn).right(0).bottom(0)
            
            // 关机时间
            let lbPowerOff = vPowerOffContain.createSubLabel()
            lbPowerOff.left(0).top(0).right(0).height(40)
            lbPowerOff.text = "关机时间"
            lbPowerOff.textAlignment = .Center
            lbPowerOff.textColor = UIColor.grayColor()
            lbPowerOff.font = UIFont.systemFontOfSize(20)
            
            let dpPowerOff = DatePickerView()
            vPowerOffContain.addSubview(dpPowerOff)
            dpPowerOff.translatesAutoresizingMaskIntoConstraints = false
            dpPowerOff.left(0).right(0).bottom(0, toItem: lbPowerOff).bottom(0)
            
            // 存储 获取时间的操作
            let storeBlock: HUDStoreFuncBlock = { [weak dpPowerOff, weak dpPowerOn] () -> [String: Any]? in
                var info: [String: Any] = [:]
                if let start = dpPowerOn?.date {
                    info["start"] = String(format: "%02d:%02d", arguments: [start.h, start.m])
                }
                
                if let end = dpPowerOff?.date {
                    info["end"] = String(format: "%02d:%02d", arguments: [end.h, end.m])
                }
                return info
            }
            
            return storeBlock

            }, blkOK: blkOK, blkCancel: blkCancel)
    }
    
    // 显示音量的Picker，值在blkOK的回调info里，key: String volume, value: Int 0~3 (对应enum Volume)
    static func showVolumePicker(blkOK blkOK: HUDBlock?, blkCancel: HUDBlock?) {
        
        self.showPicker("设定提醒音量",height: 150, type: .VolumePicker, setupView: { (vContent) -> (() -> [String: Any]?)? in
            
            let vp = VolumePickerView()
            vContent.addSubview(vp)
            vp.translatesAutoresizingMaskIntoConstraints = false
            vp.left(0).top(0).right(0).bottom(0)
            
            let storeFunc = { [weak vp]() -> [String: Any] in
                var info: [String: Any] = [:]
                if let volume = vp?.volume {
                    info["volume"] = volume
                }
                return info
            }
            return storeFunc
            
            }, blkOK: blkOK, blkCancel: blkCancel)
        
    }
    
    
//------------------------------------- ActionSheet ------------------------------------
    /**
    显示一个ActionSheet, 从下向上排的
    
    - parameter cancelButtonTitle:      取消按钮 index: 0
    - parameter destructiveButtonTitle: 红色按钮 index: 1
    - parameter clickOnBlock:           回调
    */
    static func showActionSheet(cancelBtnTitle: String, destructiveBtnTitle: String?, clickOnBlock: (index: Int, title: String) -> Void ) {
        self.showActionSheetPrivate(cancelBtnTitle, destructiveButtonTitle: destructiveBtnTitle, otherButtonTitles: [], clickOnBlock: clickOnBlock)
    }
    
    /**
     显示一个ActionSheet, 从下向上排的
     
     - parameter cancelButtonTitle:      取消按钮 index: 0
     - parameter destructiveButtonTitle: 红色按钮 index: 1
     - parameter otherButtonTitles:      白色按钮 index: 1~  (没有红色按钮), 2~ （有红色按钮)
     - parameter clickOnBlock:           回调
     */
    static func showActionSheet(cancelButtonTitle: String, destructiveButtonTitle: String?, otherButtonTitles: String..., clickOnBlock: (index: Int, title: String) -> Void ) {
        self.showActionSheetPrivate(cancelButtonTitle, destructiveButtonTitle: destructiveButtonTitle, otherButtonTitles: otherButtonTitles, clickOnBlock: clickOnBlock)
    }
    
    /**
    显示一个ActionSheet, 从下向上排的
    
    - parameter cancelButtonTitle:      取消按钮 index: 0
    - parameter destructiveButtonTitle: 红色按钮 index: 1
    - parameter otherButtonTitles:      白色按钮 index: 1~  (没有红色按钮), 2~ （有红色按钮)
    - parameter clickOnBlock:           回调
    */
    private static func showActionSheetPrivate(cancelButtonTitle: String, destructiveButtonTitle: String?, otherButtonTitles: [String], clickOnBlock: (index: Int, title: String) -> Void ) {
        
        self.showView(.ActionSheet, hiddenWhenClick: false, setupView: { (vContain) -> (() -> [String : Any]?)? in
            
            vContain.backgroundColor = UIColor.clearColor()
            vContain.bottom(0).left(0).right(0)

            // 取消按钮
            let btnCancel = HUDButton(type: UIButtonType.RoundedRect)
            vContain.addSubview(btnCancel)
            btnCancel.translatesAutoresizingMaskIntoConstraints = false
            btnCancel.bottom(36).left(50).right(50).height(45)
            btnCancel.layer.cornerRadius = 5
            btnCancel.layer.masksToBounds = true
            btnCancel.tag = 0
            btnCancel.backgroundColor = UIColor.darkGrayColor()
            btnCancel.addAction(cancelButtonTitle, titleColor: UIColor.lightGrayColor(), font: UIFont.systemFontOfSize(16), blk: { () -> Void in
                clickOnBlock(index: 0, title: cancelButtonTitle)
            })
            
            // 上部的几个按钮的容器
            let vGroup = vContain.createSubView()
            vGroup.top(15, toItem: btnCancel).left(50).right(50).top(0)
            vGroup.layer.cornerRadius = 5
            vGroup.layer.masksToBounds = true
            vGroup.backgroundColor = UIColor.clearColor()
            
            // 容器中的红色按钮
            var btnDestructive: HUDButton?
            if let destructiveTlt = destructiveButtonTitle {
                btnDestructive = HUDButton(type: UIButtonType.RoundedRect)
                vGroup.addSubview(btnDestructive!)
                btnDestructive!.translatesAutoresizingMaskIntoConstraints = false
                btnDestructive!.bottom(0).left(0).right(0).height(45)
                btnDestructive!.backgroundColor = UIColor.redColor()
                btnDestructive!.tag = 1
                btnDestructive!.addAction(destructiveTlt, titleColor: UIColor.lightGrayColor(), font: UIFont.systemFontOfSize(16), blk: { () -> Void in
                    clickOnBlock(index: 1, title: destructiveTlt)
                })
            }
            
            // 剩下的几个选择按钮
            var btnOtherLast: HUDButton? = btnDestructive
            for (index, otherTlt) in otherButtonTitles.enumerate() {
                let btnOther = HUDButton()
                vGroup.addSubview(btnOther)
                btnOther.translatesAutoresizingMaskIntoConstraints = false
                var tag = 0
                if let _ = btnOtherLast {
                    btnOther.top(0, toItem: btnOtherLast!).left(0).right(0).height(45)
                    tag = index + 2
                    btnOther.tag = tag
                } else {
                    btnOther.bottom(0).left(0).right(0).height(45)
                    tag = index + 1
                    btnOther.tag = tag
                }
                btnOther.backgroundColor = UIColor.whiteColor()
                btnOther.addAction(otherTlt, titleColor: UIColor.lightGrayColor(), font: UIFont.systemFontOfSize(16), blk: { () -> Void in
                    clickOnBlock(index: tag, title: otherTlt)
                })
                btnOtherLast = btnOther
                let vLine = btnOtherLast?.createSubView()
                vLine?.left(0).right(0).height(0.5).bottom(0)
                vLine?.backgroundColor = UIColor.lightGrayColor()
            }
            btnOtherLast?.top(0)
            
            return nil
            }) { (info) -> Void in
                
        }
        
    }
    
}
