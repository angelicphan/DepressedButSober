//
//  AboutViewController.swift
//  DepressedButSober
//
//  Created by Angelic Phan on 8/4/20.
//  Copyright © 2020 Angelic Phan. All rights reserved.
//
//  This is the about screen that displays information aout
//  the app/game.

import UIKit

class AboutViewController: UIViewController {

    // ****************************************************************
    // MARK: View Lifecycle
    // ****************************************************************
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Will show the navigation bar for about screen
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
}
