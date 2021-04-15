//
//  ViewController.swift
//  Demo
//
//  Created by 郑桂杰 on 2020/7/7.
//  Copyright © 2020 zgj. All rights reserved.
//

import UIKit

final class ViewController: UIViewController {
   
}

extension ViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .cyan
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(onClickBarItem(_:)))
    }
    
    @IBAction private func onClickBarItem(_ sender: UIBarButtonItem) {
        navigationController?.pushViewController(SViewController(), animated: true)
    }
}
