//
//  SelectMutiAdapter.swift
//  SelectMutiPhotoFrameWork
//
//  Created by larvata_ios on 2018/3/15.
//  Copyright © 2018年 ntubimdbirc. All rights reserved.
//

import UIKit
public class SelectMutiPhotoAdapter{
    public init(){
        print("Class has been initialised")
    }
    public func presenterVC(delegate : SelectMutiPhotoDelegate)-> UINavigationController{
        let navi = UIStoryboard.init(name: "SelectMutiPhotoViewController", bundle: Bundle(identifier: "ntubimdbirc.SelectMutiPhotoFrameWork")).instantiateViewController(withIdentifier: "navi") as! UINavigationController
        let vc = navi.topViewController as! SelectMutiPhotoViewController
        vc.delegate = delegate
        return navi
    }
}
