//
//  ViewController.swift
//  HUD
//
//  Created by wangluguang on 16/3/14.
//  Copyright © 2016年 wangluguang. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var ivHeader: UIImageView!
    
    var pk = ImagePicker()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap = UITapGestureRecognizer(target: self, action: "onTap")
        self.ivHeader.addGestureRecognizer(tap)
    }
  
    @IBAction func popUp(sender: UIButton) {
        HUD.showMsg("hahahah")
        print("\(__FUNCTION__)")
    }
    
    func onTap() {
        self.pk.showImagePicker(self) { (image) -> Void in
            self.ivHeader.image = image
        }
        print("\(__FUNCTION__)")
    }

    @IBAction func onPan(sender: UIPanGestureRecognizer) {
        print("\(__FUNCTION__)")
    }
}

