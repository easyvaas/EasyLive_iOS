//
//  EVConfigBeautyLevelViewController.swift
//  EVSDKDemo
//
//  Created by Lcrnice on 2017/8/10.
//  Copyright © 2017年 cloudfocous. All rights reserved.
//

import UIKit

class EVConfigBeautyLevelViewController: UIViewController {
  
  var index: Int = 2
  var isBeautyEnable = false
		
  var segValueChanged: ((Int) -> Void)?
  var switchValueChanged: ((Bool) -> Void)?
  
  @IBOutlet weak var switchBtn: UISwitch!
  @IBOutlet weak var seg: UISegmentedControl!
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    seg.selectedSegmentIndex = index
    switchBtn.isSelected = isBeautyEnable
    switchBtn.isOn = isBeautyEnable
    seg.isEnabled = isBeautyEnable
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  class func instanceVC() -> EVConfigBeautyLevelViewController {
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    return storyboard.instantiateViewController(withIdentifier: "EVConfigBeautyLevelViewController") as! EVConfigBeautyLevelViewController
  }
  
  func showInViewController(parentViewController vc: UIViewController) {
    if self.parent == vc {
      return
    }
    
    vc.addChildViewController(self)
    self.view.alpha = 0
    self.view.frame = vc.view.frame
    vc.view.addSubview(self.view)
    
    self.didMove(toParentViewController: vc)
    
    UIView.animate(withDuration: 0.25, animations: {
      self.view.alpha = 1
    })
  }
  
  private func dismissVC() {
    UIView.animate(withDuration: 0.25, animations: {
      self.view.alpha = 0
    }, completion: { finished in
      self.willMove(toParentViewController: nil)
      self.view .removeFromSuperview()
      self .removeFromParentViewController()
    })
  }
  
  @IBAction func onBackgroundTouchDown(_ sender: Any) {
    self.dismissVC()
  }
  
  @IBAction func switchChanged(_ sender: UISwitch) {
    sender.isSelected = !sender.isSelected
    seg.isEnabled = sender.isSelected
    
    if switchValueChanged != nil {
      switchValueChanged!(sender.isSelected)
    }
    
    if sender.isSelected {
      seg.selectedSegmentIndex = 2
      if segValueChanged != nil {
        segValueChanged!(3)
      }
    }
  }
  
  @IBAction func segChanged(_ sender: UISegmentedControl) {
    let index = sender.selectedSegmentIndex
    if segValueChanged != nil {
      segValueChanged!(index)
    }
  }
  /*
   // MARK: - Navigation
   
   // In a storyboard-based application, you will often want to do a little preparation before navigation
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
   // Get the new view controller using segue.destinationViewController.
   // Pass the selected object to the new view controller.
   }
   */
  
}
