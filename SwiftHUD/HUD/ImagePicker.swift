//
//  ImagePickerViewController.swift
//
//  Created by wangluguang on 16/3/14.
//  Copyright © 2016年 wangluguang. All rights reserved.
//

import UIKit

import AVFoundation

class ImagePicker:
    NSObject,
    UIImagePickerControllerDelegate,
    UINavigationControllerDelegate
{
    /// 完成的回调
    private var callBack: ((UIImage?) -> Void)? = nil
    /// 图片是否可编辑
    var allowEditting: Bool = true
    /// 打开的图片源
    var sourceType: UIImagePickerControllerSourceType = .PhotoLibrary
    
    override init() {
        super.init()
    }

    /**
     弹出一个ImagePicker
     
     - parameter vc:       在哪个vc上弹出
     - parameter callBack: 完成后的回调
     
     - returns: 打开imagePick是否成功
     */
    func getImage(vc: UIViewController, callBack: (image: UIImage?) -> Void) -> Bool {
        guard UIImagePickerController.isSourceTypeAvailable(self.sourceType) == true else { return false }
        
        self.callBack = callBack
        
        let picker = UIImagePickerController()
        picker.sourceType = self.sourceType
        picker.allowsEditing = self.allowEditting
        picker.delegate = self
        vc.presentViewController(picker, animated: true, completion: nil)
        
        return true
    }
    
    //MARK: - UIImagePickerControllerDelegate
    @objc func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        let image: UIImage? = info[self.allowEditting ? UIImagePickerControllerEditedImage : UIImagePickerControllerOriginalImage] as? UIImage
        self.callBack?(image)
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @objc func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        picker.dismissViewControllerAnimated(true, completion: nil)
        self.callBack?(nil)
    }
    
}

extension ImagePicker {
    /**
     快速打开图片库
     */
    func showImagePicker(vc: UIViewController, callBack: (image: UIImage?) -> Void) {
        HUD.showActionSheet("取消", destructiveButtonTitle: nil, otherButtonTitles: "相册", "照相机") { [weak self, vc] (index, title) -> Void in
            HUD.hiddenHUD(.ActionSheet, animated: false)
            guard let _ = self else { return }
            
            if index == 0 { // 取消
                return
            } else if index == 1 { // 相册
                self!.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
            } else {    // 照相机
                self!.sourceType = UIImagePickerControllerSourceType.Camera
            }
            
            self?.getImage(vc, callBack: callBack)            
        }
    }
}
