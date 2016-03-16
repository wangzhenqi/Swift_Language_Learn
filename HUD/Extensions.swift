//
//  Extensions.swift
//
//  Created by wangluguang on 16/3/14.
//  Copyright © 2016年 wangluguang. All rights reserved.
//

import UIKit

// MARK: - UIView

private var xoAssociationKey1: UInt8 = 10
private var xoAssociationKey2: UInt8 = 11
private var xoAssociationKey3: UInt8 = 12

extension UIView {
    
    // MARK: Construction
    
    func createSubView() -> UIView {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.opaque = true
        self.addSubview(v)
        return v
    }
    
    func createSubButton() -> UIButton {
        let b = UIButton(type: UIButtonType.Custom)
        b.translatesAutoresizingMaskIntoConstraints = false
        b.opaque = true
        self.addSubview(b)
        return b
    }
    
    func createSubWebView() -> UIWebView {
        let wv = UIWebView()
        wv.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(wv)
        return wv
    }
    
    func createSubLabel() -> UILabel {
        let lb = UILabel()
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.opaque = true
        self.addSubview(lb)
        return lb
    }
    
    func createSubImageView() -> UIImageView {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.opaque = true
        self.addSubview(iv)
        return iv
    }
    
    func createSubTableView() -> UITableView {
        let tb = UITableView()
        tb.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(tb)
        return tb
    }
    
    func createSubCollectionView(flowLayout: UICollectionViewFlowLayout) -> UICollectionView {
        let coll = UICollectionView(frame: CGRectZero, collectionViewLayout: flowLayout)
        coll.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(coll)
        return coll
    }
    
    func createSubTextView() -> UITextView {
        let tv = UITextView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(tv)
        return tv
    }
    
    func createSubTextField() -> UITextField {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(tf)
        return tf
    }
    
    func createSubSearchBar() -> UISearchBar {
        let sb = UISearchBar()
        sb.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(sb)
        return sb
    }
    
    
    func createSubScrollView() -> UIScrollView {
        let scv = UIScrollView()
        scv.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(scv)
        return scv
    }
    
    func createSubPageControl() -> UIPageControl {
        let pc = UIPageControl()
        pc.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(pc)
        return pc
    }
    
    func createSubSwitch() -> UISwitch {
        let swt = UISwitch()
        swt.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(swt)
        return swt
    }
    
    
    // MARK: Basic
    
    func top(value: CGFloat, toItem: UIView? = nil) -> UIView {
        if toItem == nil {
            if !checkAndModify("top", value: value) {
                let constraint = NSLayoutConstraint(
                    item: self,
                    attribute: .Top,
                    relatedBy: .Equal,
                    toItem: self.superview,
                    attribute: .Top,
                    multiplier: 1.0,
                    constant: value
                )
                self._addSaveContraint("top", constraint: constraint)
            }
        } else {
            if !checkAndModify("top:", value: -value) {
                let constraint = NSLayoutConstraint(
                    item: self,
                    attribute: .Bottom,
                    relatedBy: .Equal,
                    toItem: toItem,
                    attribute: .Top,
                    multiplier: 1.0,
                    constant: -value
                )
                self._addSaveContraint("top:", constraint: constraint)
            }
        }
        return self
    }
    
    func fill(value: CGFloat = 0) -> UIView {
        return self.left(value).right(value).top(value).bottom(value)
    }
    
    func left(value: CGFloat, toItem: UIView? = nil) -> UIView {
        if toItem == nil {
            if !checkAndModify("left", value: value) {
                let constraint = NSLayoutConstraint(
                    item: self,
                    attribute: .Left,
                    relatedBy: .Equal,
                    toItem: self.superview,
                    attribute: .Left,
                    multiplier: 1.0,
                    constant: value
                )
                self._addSaveContraint("left", constraint: constraint)
            }
        } else {
            if !checkAndModify("left:", value: -value) {
                let constraint = NSLayoutConstraint(
                    item: self,
                    attribute: .Right,
                    relatedBy: .Equal,
                    toItem: toItem,
                    attribute: .Left,
                    multiplier: 1.0,
                    constant: -value
                )
                self._addSaveContraint("top:CGFloat", constraint: constraint)
            }
        }
        return self
    }
    
    func right(value: CGFloat, toItem: UIView? = nil) -> UIView {
        if toItem == nil {
            if !checkAndModify("right", value: -value) {
                let constraint = NSLayoutConstraint(
                    item: self,
                    attribute: .Right,
                    relatedBy: .Equal,
                    toItem: self.superview,
                    attribute: .Right,
                    multiplier: 1.0,
                    constant: -value
                )
                self._addSaveContraint("right", constraint: constraint)
            }
        } else {
            if !checkAndModify("right:", value: value) {
                let constraint = NSLayoutConstraint(
                    item: self,
                    attribute: .Left,
                    relatedBy: .Equal,
                    toItem: toItem,
                    attribute: .Right,
                    multiplier: 1.0,
                    constant: value
                )
                self._addSaveContraint("right:", constraint: constraint)
            }
        }
        return self
    }
    
    func bottom(value: CGFloat, toItem: UIView?=nil) -> UIView {
        if toItem == nil {
            if !checkAndModify("bottom", value: -value) {
                let constraint = NSLayoutConstraint(
                    item: self,
                    attribute: .Bottom,
                    relatedBy: .Equal,
                    toItem: self.superview,
                    attribute: .Bottom,
                    multiplier: 1.0,
                    constant: -value
                )
                self._addSaveContraint("bottom", constraint: constraint)
            }
        } else {
            if !checkAndModify("bottom:", value: value) {
                let constraint = NSLayoutConstraint(
                    item: self,
                    attribute: .Top,
                    relatedBy: .Equal,
                    toItem: toItem,
                    attribute: .Bottom,
                    multiplier: 1.0,
                    constant: value
                )
                self._addSaveContraint("bottom:", constraint: constraint)
            }
        }
        return self
    }
    
    func ratio(value: CGFloat) -> UIView {
        if !checkAndModify("ratio", value: value) {
            let constraint = NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Height, multiplier: value, constant: 0)
            self._addSaveContraint("ratio", constraint: constraint)
        }
        
        return self
    }
    
    func width(width: CGFloat)->UIView {
        if !checkAndModify("width", value: width) {
            let constraint = NSLayoutConstraint(
                item: self,
                attribute: .Width,
                relatedBy: .Equal,
                toItem: nil,
                attribute: .NotAnAttribute,
                multiplier: 1.0,
                constant: width
            )
            self._addSaveContraint("width", constraint: constraint)
        }
        return self
    }
    
    func equalWidth(toItem toItem: UIView, ratio: CGFloat = 1.0, offset: CGFloat = 0.0) -> UIView {
        if !checkAndModify("equalWidth", value: 0) {
            let constraint = NSLayoutConstraint(
                item: self,
                attribute: .Width,
                relatedBy: .Equal,
                toItem: toItem,
                attribute: .Width,
                multiplier: ratio,
                constant: offset
            )
            self._addSaveContraint("equalWidth", constraint: constraint)
        }
        return self
    }
    
    func equalHeight(toItem toItem: UIView, ratio: CGFloat = 1.0, offset: CGFloat = 0.0) -> UIView {
        if !checkAndModify("equalHeight", value: 0) {
            let constraint = NSLayoutConstraint(
                item: self,
                attribute: .Height,
                relatedBy: .Equal,
                toItem: toItem,
                attribute: .Height,
                multiplier: ratio,
                constant: offset
            )
            self._addSaveContraint("equalHeight", constraint: constraint)
        }
        return self
    }
    
    func height(height: CGFloat) -> UIView {
        if !checkAndModify("height", value: height) {
            let constraint = NSLayoutConstraint(
                item: self,
                attribute: .Height,
                relatedBy: .Equal,
                toItem: nil,
                attribute: .NotAnAttribute,
                multiplier: 1.0,
                constant: height
            )
            self._addSaveContraint("height", constraint: constraint)
        }
        
        return self
    }
    
    func size(sideLength sideLength: CGFloat) -> UIView {
        self.width(sideLength).height(sideLength)
        return self
    }
    
    func size(size: CGSize) -> UIView {
        self.width(size.width).height(size.height)
        return self
    }
    
    func minWidth(width: CGFloat) -> UIView {
        if !checkAndModify("minWidth", value: width) {
            let constraint = NSLayoutConstraint(
                item: self,
                attribute: .Width,
                relatedBy: NSLayoutRelation.GreaterThanOrEqual,
                toItem: nil,
                attribute: .NotAnAttribute,
                multiplier: 1.0,
                constant: width
            )
            self._addSaveContraint("minWidth", constraint: constraint)
        }
        
        return self
    }
    
    func minHeight(height: CGFloat) -> UIView {
        if !checkAndModify("minHeight", value: height) {
            let constraint = NSLayoutConstraint(
                item: self,
                attribute: .Height,
                relatedBy: NSLayoutRelation.GreaterThanOrEqual,
                toItem: nil,
                attribute: .NotAnAttribute,
                multiplier: 1.0,
                constant: height
            )
            self._addSaveContraint("minHeight", constraint: constraint)
        }
        
        return self
    }
    
    func maxHeight(height: CGFloat) -> UIView {
        if !checkAndModify("maxHeight", value: height) {
            let constraint = NSLayoutConstraint(
                item: self,
                attribute: .Height,
                relatedBy: NSLayoutRelation.LessThanOrEqual,
                toItem: nil,
                attribute: .NotAnAttribute,
                multiplier: 1.0,
                constant: height
            )
            self._addSaveContraint("maxHeight", constraint: constraint)
        }
        
        return self
    }
    
    func centerX(offset: CGFloat = 0) -> UIView {
        let constraint = NSLayoutConstraint(
            item: self,
            attribute: .CenterX,
            relatedBy: .Equal,
            toItem: self.superview,
            attribute: .CenterX,
            multiplier: 1.0,
            constant: offset
        )
        self.addConstraintByType("centerX", constraint: constraint)
        return self
    }
    
    func centerY(offset: CGFloat = 0) -> UIView {
        let constraint = NSLayoutConstraint(
            item: self,
            attribute: .CenterY,
            relatedBy: .Equal,
            toItem: self.superview,
            attribute: .CenterY,
            multiplier: 1.0,
            constant: offset
        )
        self.addConstraintByType("centerY", constraint: constraint)
        return self
    }
    
    func alignLeading(value: CGFloat = 0, toItem: UIView, attr: NSLayoutAttribute? = nil) -> UIView {
        if !checkAndModify("alignLeading", value: value) {
            let constraint = NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.Leading, relatedBy: NSLayoutRelation.Equal, toItem: toItem, attribute: attr ?? .Leading, multiplier: 1, constant: value)
            self._addSaveContraint("alignLeading", constraint: constraint)
        } else {
            if let former = self._constraints?["alignLeading"] as? NSLayoutConstraint {
                self.removeConstraint(former)
            }
            let constraint = NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.Leading, relatedBy: NSLayoutRelation.Equal, toItem: toItem, attribute: attr ?? .Leading, multiplier: 1, constant: value)
            self._addSaveContraint("alignLeading", constraint: constraint)
        }
        
        return self
    }
    
    func alignTrailing(value: CGFloat = 0, toItem: UIView, attr: NSLayoutAttribute? = nil) -> UIView {
        if !checkAndModify("alignTrailing", value: value) {
            let constraint = NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.Trailing, relatedBy: NSLayoutRelation.Equal, toItem: toItem, attribute: attr ?? .Trailing, multiplier: 1, constant: value)
            self._addSaveContraint("alignTrailing", constraint: constraint)
        } else {
            if let former = self._constraints?["alignTrailing"] as? NSLayoutConstraint {
                self.removeConstraint(former)
            }
            let constraint = NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.Leading, relatedBy: NSLayoutRelation.Equal, toItem: toItem, attribute: attr ?? .Leading, multiplier: 1, constant: value)
            self._addSaveContraint("alignTrailing", constraint: constraint)
        }
        
        return self
    }
    
    func alignTop(value: CGFloat = 0, toItem: UIView, attr: NSLayoutAttribute? = nil) -> UIView {
        if !checkAndModify("alignTop", value: value) {
            let constraint = NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: toItem, attribute: attr ?? .Top, multiplier: 1, constant: value)
            self._addSaveContraint("alignTop", constraint: constraint)
        } else {
            if let former = self._constraints?["alignTop"] as? NSLayoutConstraint {
                self.removeConstraint(former)
            }
            let constraint = NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.Leading, relatedBy: NSLayoutRelation.Equal, toItem: toItem, attribute: attr ?? .Leading, multiplier: 1, constant: value)
            self._addSaveContraint("alignTop", constraint: constraint)
        }
        
        return self
    }
    
    func alignBottom(value: CGFloat = 0, toItem: UIView, attr: NSLayoutAttribute? = nil) -> UIView {
        if !checkAndModify("alignBottom", value: value) {
            let constraint = NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: toItem, attribute: attr ?? .Bottom, multiplier: 1, constant: value)
            self._addSaveContraint("alignBottom", constraint: constraint)
        } else {
            if let former = self._constraints?["alignBottom"] as? NSLayoutConstraint {
                self.removeConstraint(former)
            }
            let constraint = NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.Leading, relatedBy: NSLayoutRelation.Equal, toItem: toItem, attribute: attr ?? .Leading, multiplier: 1, constant: value)
            self._addSaveContraint("alignBottom", constraint: constraint)
        }
        
        return self
    }
    
    // MARK: Contraint Cache
    
    private func _clearSaveContraint(type: String) {
        if let con = self._constraints?[type] as? NSLayoutConstraint {
            self.superview?.removeConstraint(con)
        }
    }
    
    private func _addSaveContraint(type: String, constraint: NSLayoutConstraint) {
        var cons:[String: AnyObject]? = self._constraints
        if cons == nil {
            cons = [:]
        }
        cons![type] = constraint
        self._constraints = cons
        constraint.priority = 999
        self.superview?.addConstraint(constraint)
    }
    
    private func addConstraintByType(type: String, constraint: NSLayoutConstraint) {
        //clear first
        self._clearSaveContraint(type)
        // then add
        self._addSaveContraint(type, constraint: constraint)
    }
    
    private func checkAndModify(type: String, value: CGFloat) -> Bool {
        //这里的逻辑是 看看 这个约束是不是已经有了. 如果已经有了, 就只修改const
        //这样的性能会好些
        if let con = self._constraints?[type] as? NSLayoutConstraint {
            if ["ratio", "equalWidth", "equalHeight"].contains(type) {
                self._constraints?.removeValueForKey(type)
                self.removeConstraint(con)
                return false
            }
            
            con.constant = value
            return true
        }
        return false
    }

    
    
    var _constraints: [String: AnyObject]? {
        get {
            if let obj = objc_getAssociatedObject(self, &xoAssociationKey3) {
                return obj as? [String: AnyObject]
            } else {
                return nil
            }
        }
        
        set(newValue) {
            objc_setAssociatedObject(self, &xoAssociationKey3, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_COPY)
        }
    }

}

// MARK: - UIResponder
/// 获取当前的firstResponder
extension UIResponder {
    private weak static var _currentFirstResponder: UIResponder? = nil
    
    public class func currentFirstResponder() -> UIResponder? {
        UIResponder._currentFirstResponder = nil
        // The object to receive the action message. If target is nil, the app sends the message to the first responder, from whence it progresses up the responder chain until it is handled.
        UIApplication.sharedApplication().sendAction("findFirstResponder:", to: nil, from: nil, forEvent: nil)
        return UIResponder._currentFirstResponder
    }
    
    internal func findFirstResponder(sender: AnyObject) {
        UIResponder._currentFirstResponder = self
    }
}


