//
//  DBViewController.swift
//  Presentation
//
//  Created by Shotiko Klibadze on 15.04.22.
//

import UIKit

public class DBViewController: UIViewController, Storyboarded {
    
    public override func viewWillAppear(_ animated: Bool) {
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.DBGreen()]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        navigationController?.navigationBar.largeTitleTextAttributes = textAttributes
        navigationController?.navigationBar.barTintColor = UIColor(named: "DBBackground")
    }
}


