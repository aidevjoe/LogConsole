//
//  ViewController.swift
//  LogConsole
//
//  Created by Joe on 08/31/2017.
//  Copyright (c) 2017 Joe. All rights reserved.
//

import UIKit
import LogConsole

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        SKLog.info("viewDidLoad")
    }
    
    deinit {
        SKLog.info("ViewController Deinit")
    }
    
    @IBAction func addLogAction() {
        SKLog.info("Hello Console")
    }
    
    @IBAction func printViewAction() {
        SKLog.debug(self.view)
    }
    
    @IBAction func printAllLogType() {
        SKLog.info("Info")
        SKLog.debug("Debug")
        SKLog.warning("Warning")
        SKLog.error("Error")
    }
}

