//
//  SecondViewController.swift
//  PadMultiChecker
//
//  Created by ayanotakayuki on 2016/11/06.
//  Copyright © 2016年 ayanotakayuki. All rights reserved.
//

import UIKit
import AudioToolbox

class SecondViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var labelView1: UILabel!
    @IBOutlet weak var labelView2: UILabel!
    @IBOutlet weak var labelView3: UILabel!
    @IBOutlet weak var textView1: UITextView!
    @IBOutlet weak var textView2: UITextView!
    @IBOutlet weak var textView3: UITextView!
    @IBOutlet weak var urlPicker: UIPickerView!
    @IBOutlet weak var loadButton: UIButton!
    @IBOutlet weak var countProgress: UIProgressView!
    
    var urls:[String] = ["188", "141", "142", "150", "96", "149"]
    var urlLabels:[String] = ["レーダー総合","曜日","ゲリラ","コラボ","スペダン龍","チャレンジ系"]
    var url:String = "";
    
    var loadtimer: Timer!
    var countdowntimer: Timer!
    
    var mains:[String] = []
    var times:[String] = []
    var ids:[String] = []
    var lastId:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Picker準備
        urlPicker.delegate = self
        urlPicker.dataSource = self
        
        
        //初期化
        url = urls[0]
        
        //読み込みタイマー
        loadStart()
        
        //カウントダウンタイマー
        countdownStart()
        
    }
    
    func loadStart(){
        if loadtimer != nil { loadtimer.invalidate() }
        loadtimer = Timer.scheduledTimer(
            timeInterval: 10,
            target: self,
            selector: #selector(self.loaddata),
            userInfo: nil,
            repeats: true
        )
        loadtimer.fire()
    }
    
    @IBAction func load(_ sender: UIButton) {
        loadStart()
    }
    
    func loaddata(){
        mains.removeAll()
        times.removeAll()
        ids.removeAll()
        
        self.loadButton.isEnabled = false
        self.countProgress.progress = 0.0
        
        
        var firstId:String = ""
        let myurl:String = "https://xn--0ck4aw2h.gamewith.jp/bbs/matching/threads/show/"+self.url
        
        let config = URLSessionConfiguration.default // Session Configuration
        let session = URLSession(configuration: config) // Load configuration into Session
        let url = URL(string: myurl)!
        let task = session.dataTask(with: url, completionHandler: {
            (data, response, error) in
            
            if error != nil {
                
                print(error!.localizedDescription)
                
            } else {
                
                var str = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                var strs = str?.components(separatedBy: "<div class=\"bbs-post-body-block\">")
                if let ss = strs {
                    for i in 1..<(ss.count-1) {
                        let nsSentence = ss[i]
                        let nss = nsSentence.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
                        let nss2 = nss.components(separatedBy: "<div class=\"content-footer cf\">")
                        let main = self.trim(str: nss2[0])
                        let nss3 = nss2[1].components(separatedBy: "<span class=\"bbs-post-number\">")
                        let time = self.trim(str: nss3[0])
                        let id = self.trim(str: nss3[1])
                        print(main)
                        print(id)
                        self.mains.append(main)
                        self.times.append(time)
                        self.ids.append(id)
                        if firstId=="" { firstId = id }
                    }
                }
            }
            if(firstId != self.lastId){
                //更新があった
                self.lastId = firstId
                //通知したい
                // バイブレーション
                AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            }
            DispatchQueue.main.async {
                self.labelView1.text = self.times[0]
                self.labelView2.text = self.times[1]
                self.labelView3.text = self.times[2]
                self.textView1.text = self.mains[0]
                self.textView2.text = self.mains[1]
                self.textView3.text = self.mains[2]
                self.loadButton.isEnabled = true
                self.countProgress.progress = 1.0
            }
            
        })
        task.resume()
    }
    
    func trim(str:String) -> String{
        return str
            .replacingOccurrences(of: "<br />", with: "").replacingOccurrences(of: "<p class=\"bbs-post-body\">", with: "")
            .replacingOccurrences(of: "</span>", with: "").replacingOccurrences(of: "</h4>", with: "")
            .replacingOccurrences(of: "</p>", with: "").replacingOccurrences(of: "</div>", with: "")
            .replacingOccurrences(of: "<div class=\"fll\">", with: "").replacingOccurrences(of: "<span class=\"sub-info\">", with: "")
            .replacingOccurrences(of: "<span class=\"bbs-posted-time\">", with: "")
            .trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
    }
    
    func countdownStart(){
        countdowntimer = Timer.scheduledTimer(
            timeInterval: 0.5,
            target: self,
            selector: #selector(self.countdownStep),
            userInfo: nil,
            repeats: true
        )
        countdowntimer.fire()
    }
    
    func countdownStep(){
        if(self.countProgress.progress>=0.05){
            //self.countProgress.progress-=0.1
            self.countProgress.setProgress(self.countProgress.progress-0.05, animated: true)
        }
    }
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        return urls.count
    }
    
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?{
        return urlLabels[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.url = urls[row]
        loadStart()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

