//
//  ViewController.swift
//  SideMenu
//
//  Created by Apple iMac on 31/1/23.
//

import UIKit

class SideMenuController: UIViewController {
    
    //MARK: Outlets
    @IBOutlet weak var colSidemenu: UICollectionView!
    
    //MARK: Declarations
    var SideMenuHeaderArr = Array<String>()
    var SideMenuDataArr = Array<Array<String>>()
    var isCollapsible = Array<Bool>()
    var indexo = [1,1]
    var menuSelection: ((Array<Int>)->())?
    var yPosition: CGFloat = 0
    var isOpen: Bool = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        colSidemenu.register(UINib(nibName: "HeaderCVCell", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "HeaderCVCell")
        colSidemenu.register(UINib(nibName: "MenuCVCell", bundle: nil), forCellWithReuseIdentifier: "MenuCVCell")
        for _ in 0..<SideMenuHeaderArr.count {
            SideMenuDataArr.append(Array<String>())
            isCollapsible.append(true)
        }
    }
    
    override func viewDidLayoutSubviews() {
        //userImage.layer?.cornerRadius = userImage.frame.width / 2
    }
    
    override func viewWillAppear(_ animated: Bool) {
        colSidemenu.reloadData()
    }
    
    //MARK: FUnctions
    func hideSideMneu() {
        self.isOpen = false
        self.view.backgroundColor = .clear
        UIView.animate(withDuration: 0.3, animations: { () -> Void in
            self.view.frame = CGRect(x: 0 - UIScreen.main.bounds.size.width, y: self.yPosition, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height) }, completion: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if touches.first!.view == self.view {
            hideSideMneu()
        }
    }
    
    @objc func handleTap(sender: UITapGestureRecognizer) {
        isCollapsible[sender.view!.tag] = !isCollapsible[sender.view!.tag]
        colSidemenu.reloadSections(IndexSet(integer: sender.view!.tag))
        indexo[1] = 0
        indexo[0] = sender.view!.tag + 1
        
        sender.view!.rippleEffect {
            if !(self.SideMenuDataArr[self.indexo[0] - 1].count >= 1) {
                self.hideSideMneu()
            }
            self.menuSelection?(self.indexo)
        }
    }
    
    func revealSideMenu() {
        isOpen = !isOpen
        if(isOpen){
            openSideMneu()
        }else{
            hideSideMneu()
        }
    }
    
    func openSideMneu(){
        self.isOpen = true
        UIApplication.shared.keyWindow?.addSubview(self.view)
        self.view.backgroundColor = .clear
        self.view.frame = CGRect(x: 0 - UIScreen.main.bounds.size.width, y: self.yPosition, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
        UIView.animate(withDuration: 0.3, animations: { () -> Void in
            self.view.frame = CGRect(x: 0, y: self.yPosition, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
        }, completion: { (Bool) in
            UIView.animate(withDuration: 0.5) {
                self.view.backgroundColor = UIColor.black.withAlphaComponent(0.15)
            }
        })
        self.view.layoutIfNeeded()
    }
    
    
}

extension SideMenuController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return SideMenuHeaderArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isCollapsible[section] == true { return 0 }
        else { return SideMenuDataArr[section].count }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: colSidemenu.bounds.width, height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let headerView = colSidemenu.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "HeaderCVCell", for: indexPath) as! HeaderCVCell
        
        let headerTap = UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:)))
        headerView.tag = indexPath.section
        headerView.addGestureRecognizer(headerTap)
        headerView.lblTitle.text = SideMenuHeaderArr[indexPath.section]
        
        if indexPath.section % 2 == 0 {
            headerView.backgroundColor = UIColor.white
        } else {
            headerView.backgroundColor = UIColor(red: 245/255, green: 247/255, blue: 248/255, alpha: 1.0)
        }
        headerView.imgArrow.isHidden = true
        headerView.lblTitle.textColor = UIColor.black
        
        if SideMenuDataArr[indexPath.section].count != 0 {
            headerView.imgArrow.isHidden = false
            if isCollapsible[indexPath.section] {
                UIView.animate(withDuration: 1) {
                    headerView.imgArrow.transform = CGAffineTransform.identity
                }
                headerView.lblTitle.textColor = UIColor.black
            } else {
                UIView.animate(withDuration: 1) {
                    headerView.imgArrow.transform = CGAffineTransform(rotationAngle: .pi)
                    
                }
                headerView.lblTitle.textColor = .lightGray
            }
        }
        return headerView
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = colSidemenu.dequeueReusableCell(withReuseIdentifier: "MenuCVCell", for: indexPath) as! MenuCVCell
        cell.lblTitle.text = SideMenuDataArr[indexPath.section][indexPath.row]
        if indexPath.section % 2 == 0 {
            cell.contentView.backgroundColor = UIColor.white
        } else {
            cell.contentView.backgroundColor = UIColor(red: 245/255, green: 247/255, blue: 248/255, alpha: 1.0)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        indexo[1] = indexPath.row + 1
        let cell = colSidemenu.cellForItem(at: indexPath)
        cell!.rippleEffect {
            self.hideSideMneu()
            self.menuSelection?(self.indexo)
        }
        
        //        NotificationCenter.default.post(name: Notification.Name("SideMenuTap"), object: indexo)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: colSidemenu.bounds.size.width, height: 50.0)
    }
}



//MARK: UIEXTENSION
extension UIView {
    func rippleEffect(effectColor: UIColor? = UIColor.lightGray,effectTime: Double? = 0.6 , completion: (() -> Void)?) {
        // Creates a circular path around the view
        let maxSizeBoundry = max(self.bounds.size.width, self.bounds.size.height)
        
        let path = UIBezierPath(ovalIn: CGRect(x: maxSizeBoundry / 4, y: maxSizeBoundry / 4, width: maxSizeBoundry / 2, height: maxSizeBoundry / 2))
        // Position where the shape layer should be
        let shapePosition = CGPoint(x: self.bounds.size.width / 2, y: self.bounds.size.height / 2)
        let rippleShape = CAShapeLayer()
        rippleShape.bounds = CGRect(x: 0, y: 0, width: maxSizeBoundry, height: maxSizeBoundry)
        rippleShape.path = path.cgPath
        rippleShape.fillColor = effectColor!.cgColor
        //rippleShape.strokeColor = effectColor!.cgColor
        //rippleShape.lineWidth = 4
        rippleShape.position = shapePosition
        rippleShape.opacity = 0
        
        // Add the ripple layer as the sublayer of the reference view
        self.layer.addSublayer(rippleShape)
        // Create scale animation of the ripples
        let scaleAnim = CABasicAnimation(keyPath: "transform.scale")
        scaleAnim.fromValue = NSValue(caTransform3D: CATransform3DIdentity)
        scaleAnim.toValue = NSValue(caTransform3D: CATransform3DMakeScale(2, 2, 1))
        // Create animation for opacity of the ripples
        let opacityAnim = CABasicAnimation(keyPath: "opacity")
        opacityAnim.fromValue = 1
        opacityAnim.toValue = nil
        // Group the opacity and scale animations
        let animation = CAAnimationGroup()
        animation.animations = [scaleAnim, opacityAnim]
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
        animation.duration = CFTimeInterval(effectTime!)
        animation.repeatCount = 1
        animation.isRemovedOnCompletion = true
        rippleShape.add(animation, forKey: "rippleEffect")
        self.clipsToBounds = true
        DispatchQueue.main.asyncAfter(deadline: .now() + (effectTime! - 0.2)) {
            completion?()
        }
    }
    
}
