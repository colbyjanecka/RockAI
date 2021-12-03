//
//  WelcomeViewController.swift
//  RockAnalyzer
//
//  Created by Colby Janecka on 12/1/21.
//

import Foundation


import UIKit

class WelcomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension WelcomeViewController {
    
    @IBAction func dismissPopup(sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
