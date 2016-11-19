//
//  FirstViewController.swift
//  PadMultiChecker
//
//  Created by ayanotakayuki on 2016/11/06.
//  Copyright © 2016年 ayanotakayuki. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {

    @IBOutlet weak var webView: UIWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let url = NSURLRequest(url: NSURL(string:"https://xn--0ck4aw2h.gamewith.jp/bbs/matching/threads/show/82") as! URL)
        webView.loadRequest(url as URLRequest)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

