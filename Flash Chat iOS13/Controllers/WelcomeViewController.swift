//
//  WelcomeViewController.swift
//  Flash Chat iOS13
//
//  Created by Angela Yu on 21/10/2019.
//  Copyright © 2019 Angela Yu. All rights reserved.
//

import UIKit

class WelcomeViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.isNavigationBarHidden = false
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = K.appName
        
        titleLabel.text=""
        let title = K.appName
        var timeInterval = 0.0
        
        for char in title {
            
            Timer.scheduledTimer(withTimeInterval: timeInterval * 0.1 , repeats: false) { (timer) in
                
                self.titleLabel.text?.append(char)
            }
            
            timeInterval += 1
        }
        
    }
    
    func name(max:(Int,Int)->Int ,opretion : Int ) -> Int {
        
        return max(opretion,opretion)
    }
    
    func mini(mini:(Int,Int)->Int , opamb: Int) -> Int {
        
        return mini(opamb,opamb)
    }
    
    
}
