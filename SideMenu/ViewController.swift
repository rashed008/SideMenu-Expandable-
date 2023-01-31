//
//  ViewController.swift
//  SideMenu
//
//  Created by Apple iMac on 31/1/23.
//

import UIKit

class ViewController: UIViewController {
    
    //MARK: Declarations
    var menuVC = SideMenuController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        menuVC = self.storyboard!.instantiateViewController(withIdentifier: "SideMenuController") as! SideMenuController
        menuVC.SideMenuHeaderArr = ["Home & Loader","Service","Animation, Alert & Calender","CollectionView Flow Layout","Privacy Policy","Education","Other"]
        menuVC.SideMenuDataArr = [[],[],[],[],[],[],["Other-1","Other-2"]]
        
        // Handle SideMenu Click event from Below Closure Code
        menuVC.menuSelection = { selection in
            print(selection)
        }
    }
    func sideMenuTapped() {
        
    }
    
    @IBAction func onTapSideMenu(_ sender: Any) {
        //hide this below 1 line of code to see the
        //menuVC.yPosition = self.navigationController?.navigationBar.frame.maxY ?? 0.0  // set value if top gap needed
        menuVC.revealSideMenu()
    }
    
}
