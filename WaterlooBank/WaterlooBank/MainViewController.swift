//
//  MainViewController.swift
//  WaterlooBank
//
//  Created by Jonathan Ellis on 24/06/2015.
//  Copyright (c) 2015 iProov Ltd. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    @IBOutlet var tokenLabel: UILabel!
    
    var token: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Your Account"
        
        // Do any additional setup after loading the view.
        
        tokenLabel.text = String(format: "Your token is %@", token)
    }


}
