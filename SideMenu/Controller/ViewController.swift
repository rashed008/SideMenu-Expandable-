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
//        menuVC.SideMenuHeaderArr = ["Products","Add a Shop","Upload Products,Reviews","Document", "Offer Zone","Support Ticket","Settings & Security","Log out"]
        menuVC.SideMenuDataArr = [[],[],["Food","Grocery","Water","Water","Liquor"],[],[],[],["Other-1","Other-2"]]
        
       
        
        let dataArray: [SideMenuDataArray] = [
            .init(title: "Products"),
            .init(title: "Add a Shop"),
            .init(title: "Upload Products,Reviews", children: [
                .init(title: "Food1"),
                .init(title: "Grocery1"),
                .init(title: "Water1"),
                .init(title: "Liquor1")
            ])
        ]
        
        menuVC.SideMenuHeaderArr = dataArray.compactMap{$0.title}
        menuVC.SideMenuDataArr[2] += dataArray
            .flatMap { $0.children ?? [] }
            .map { $0.title }

        
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

struct SideMenuDataArray {
    var id = UUID()
    let title: String
    var children: [SideMenuDataArray]? = nil
}
