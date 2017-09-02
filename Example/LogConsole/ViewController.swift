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
        
        Logger.info("viewDidLoad")
    }
    
    deinit {
        Logger.info("ViewController Deinit")
    }
    
    @IBAction func addLogAction() {
        Logger.info("Hello Console")
    }
    
    @IBAction func printViewAction() {
        Logger.debug(self.view)
    }
    
    @IBAction func printAllLogType() {
        Logger.info("Info")
        Logger.debug("Debug")
        Logger.warning("Warning")
        Logger.error("Error")
    }
}

