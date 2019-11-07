//
//  SongsViewController.swift
//  Lyric Maker
//
//  Created by Andrew Lawler on 07/11/2019.
//  Copyright © 2019 andrewlawler. All rights reserved.
//

import UIKit

class SongsViewController: UIViewController {
    
    @IBOutlet var songLabel: UILabel!
    @IBOutlet var songNameLabel: UILabel!
    
    var song:URL?
    var songName:String?

    override func viewDidLoad() {
        super.viewDidLoad()
        songLabel.numberOfLines = 0
        songNameLabel.text = songName
        makeRequest()
    }
    
    func makeRequest(){
        let request = URLRequest(url: song!)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if response != nil {
            if let data = data, var body = String(data: data, encoding: .utf8) {
                var i = 0
                while i<11 {
                    let index = body.index(body.startIndex, offsetBy: 0)
                    body.remove(at: index)
                    i += 1
                }
                i = 0
                while i<2 {
                    let index = body.index(body.endIndex, offsetBy: -1)
                    body.remove(at: index)
                    i += 1
                }
                DispatchQueue.main.async { // Correct
                    self.songLabel.text = body
                }
            }
          } else {
            print(error ?? "Unknown error")
          }
        }
        task.resume()
    }
    
}
