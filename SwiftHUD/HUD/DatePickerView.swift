//
//  DatePickerView.swift
//
//  Created by wangluguang on 16/3/14.
//  Copyright © 2016年 wangluguang. All rights reserved.
//

import UIKit

class DatePickerView: UIView, UIPickerViewDelegate, UIPickerViewDataSource {
    
    //  MARK: - Propertys
    typealias CallBack = (h: Int, m: Int) -> Void
    
    // picker
    private weak var pvDayPicker: UIPickerView!
    // 小时数据
    private lazy var hoursData: [String]! = {
        var hs: [String] = []
        for i in 0..<(24 * 11) {
            let str = NSString(format: "%02d", i%24) as String
            hs.append(str)
        }
        return hs
    }()
    // 分钟数据
    private lazy var minutesData: [String]! = {
        var ms: [String] = []
        for i in 0..<(60 * 5) {
            let str = NSString(format: "%02d", i%60) as String
            ms.append(str)
        }
        return ms
    }()
    
    // 回调
    private var callBack: CallBack?
    
    // 获取时间
    var date: (h: Int, m: Int) {
        get {
            let row0 = self.pvDayPicker.selectedRowInComponent(0)
            let row1 = self.pvDayPicker.selectedRowInComponent(1)
            
            let hour = Int(self.hoursData[row0])!
            let minute = Int(self.minutesData[row1])!
            
            return (h: hour, m: minute)
        }
        
        set (newValue){
            let h: Int = newValue.h <= 23 ? newValue.h : 23
            let m: Int = newValue.m <= 59 ? newValue.m : 59
            self.pvDayPicker.selectRow(h + (24 * 5), inComponent: 0, animated: false)
            self.pvDayPicker.selectRow(m + (60 * 2), inComponent: 1, animated: false)
        }
    }
    
    //  MARK: - init
    
    override init(frame: CGRect) {
        var newframe = frame
        if newframe.size.height < 164 { //picker最小164
            newframe.size.height = 164
        }
        super.init(frame: newframe)
        self.setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.setup()
    }
    
    func setup() {
        //添加各种view
        let pvDayPicker = UIPickerView()
        self.addSubview(pvDayPicker)
        pvDayPicker.translatesAutoresizingMaskIntoConstraints = false
        pvDayPicker.left(0).top(0).right(0).bottom(0)
        self.pvDayPicker = pvDayPicker
        
        self.pvDayPicker.dataSource = self
        self.pvDayPicker.delegate = self
        self.pvDayPicker.layer.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
    }
    
    // 添加回调
    func addSelectCallBack(blk: CallBack) {
        self.callBack = blk
    }
    
    
    // MARK: - functions
    
    //MARK: - UIPickerView
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return hoursData.count
        } else if component == 1 {
            return minutesData.count
        } else {
            return 0
        }
    }
    
    func pickerView(pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        let width = self.bounds.size.width * 0.8
        return width * 0.5
    }
    
    func pickerView(pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        let height =  pickerView.bounds.size.height / 5
        return height
    }
    

    
    func pickerView(pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        if component == 0 {
            let hour: String = self.hoursData[row] + "时"
            let attrStrH = NSAttributedString(string: hour, attributes: [
                NSFontAttributeName: UIFont.systemFontOfSize(14),
                NSForegroundColorAttributeName: UIColor.blackColor()
                ])
            return attrStrH
        } else {
            let minute: String = self.minutesData[row] + "分"
            let attrStrM = NSAttributedString(string: minute, attributes: [
                NSFontAttributeName: UIFont.systemFontOfSize(14),
                NSForegroundColorAttributeName: UIColor.blackColor()
                ])
            return attrStrM
        }
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let row0 = self.pvDayPicker.selectedRowInComponent(0)
        let row1 = self.pvDayPicker.selectedRowInComponent(1)
        let hour = Int(self.hoursData[row0])!
        let minute = Int(self.minutesData[row1])!
        self.callBack?(h: hour, m: minute)
    }

}
