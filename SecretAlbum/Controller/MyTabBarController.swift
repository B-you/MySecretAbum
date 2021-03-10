//
//  MyTabBarController.swift
//  SecretAlbum
//
//  Created by 100 on 05.03.2021.
//

import UIKit

class MyTabBarController: UITabBarController,UITabBarControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        // Do any additional setup after loading the view.
    }
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
//        if viewController is ViewController {
//            print("hellooooo")
            if let firstvc = viewController as? ViewController {
                print("hellooooo")
                if #available(iOS 11.0, *) {
                    firstvc.addButtons()
                } else {
                    // Fallback on earlier versions
                }
                
                
            }
//        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
