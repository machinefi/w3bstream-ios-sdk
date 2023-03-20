//
//  ViewController.swift
//  w3bstream
//
//  Created by zanyfly on 03/17/2023.
//  Copyright (c) 2023 zanyfly. All rights reserved.
//

import UIKit
import w3bstream

class ViewController: UIViewController {
    var w3bStream: W3bStream?
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        if let url = URL(string: "https://w3bstream-shake-demo.onrender.com/api/data") {
            w3bStream = W3bStream(urls: [url])
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

