//
//  StudentTabBarController.swift
//  DinnerSystem
//
//  Created by Sean on 2020/1/9.
//  Copyright © 2020 DinnerSystem Team. All rights reserved.
//

import UIKit


class StudentTabBarController: UITabBarController, UITabBarControllerDelegate, UIAdaptivePresentationControllerDelegate{
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {                    //preventing from swipe to dismiss
            self.isModalInPresentation = true
        }
        //self.navigationController?.presentationController?.delegate = self
        self.presentationController?.delegate = self
    }
    
    
    func presentationControllerShouldDismiss(_ presentationController: UIPresentationController) -> Bool {
        return false
    }
    func presentationControllerDidAttemptToDismiss(_ presentationController: UIPresentationController) {
        let alert = UIAlertController(title: "確定登出？", message: "你確定要離開午餐系統？", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "登出", style: .destructive, handler: { _ in
            logout()
            self.dismiss(animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
        present(alert, animated: true)
    }
}
