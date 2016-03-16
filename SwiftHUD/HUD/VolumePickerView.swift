//
//  VolumePickerView.swift
//
//  Created by wangluguang on 16/3/14.
//  Copyright © 2016年 wangluguang. All rights reserved.
//

import UIKit

class VolumePickerView:
    UIView,
    UIPickerViewDelegate,
    UIPickerViewDataSource
{
    //  MARK: - Internal defination
    // 音量
    enum Volume: Int {
        case Mute = 0   // 静音
        case Low
        case Medium
        case High
        
        // ...
        
        case TotalCount
    }
    

    // MARK: - Propertys
    
    // PickerView
    private weak var pvVolume: UIPickerView!
    
    // 当前的PickerView的值
    var volume: Volume.RawValue? {
        get {
            let row = self.pvVolume.selectedRowInComponent(0)
            return Volume(rawValue: row)?.rawValue
        }
    }
    
    // MARK: - init
    convenience init() {
        self.init(frame: CGRectZero)
        
        let pvVolume = UIPickerView()
        self.addSubview(pvVolume)
        pvVolume.translatesAutoresizingMaskIntoConstraints = false
        pvVolume.left(0).top(0).right(0).bottom(0)
        pvVolume.delegate = self
        pvVolume.dataSource = self
        self.pvVolume = pvVolume
    }

    // MARK: - UIPickerViewDataSource

    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return Volume.TotalCount.rawValue
    }

    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch row {
        case Volume.Mute.rawValue:
            return "静音"
        case Volume.Low.rawValue:
            return "低"
        case Volume.Medium.rawValue:
            return "中"
        case Volume.High.rawValue:
            return "高"
        default:
            return ""
        }
    }

}
