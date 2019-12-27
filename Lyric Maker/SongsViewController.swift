//
//  SongsViewController.swift
//  Lyric Maker
//
//  Created by Andrew Lawler on 07/11/2019.
//  Copyright © 2019 andrewlawler. All rights reserved.
//

import UIKit

struct JSONSong: Decodable {
    let lyrics: String
}

class SongsViewController: UIViewController {
    
    @IBOutlet var songNameLabel: UILabel!
    @IBOutlet weak var songLabel: UITextView!
    
    var band:String?
    var songName:String?
    var songTitle:String?

    override func viewDidLoad() {
        super.viewDidLoad()
        songNameLabel.text = songTitle
        songLabel.isEditable = false
        getSong()
    }
    
    func getSong(){
        // get the string and create a URL, then start a session and start a dataTask to get the JSON data
        let nameOfband = band!.replacingOccurrences(of: " ", with: "_")
        let nameOfSong = songName!.replacingOccurrences(of: " ", with: "_")
        if let url = URL(string: "https://api.lyrics.ovh/v1/\(nameOfband)/\(nameOfSong)") {
        let session = URLSession.shared
        session.dataTask(with: url) { (data, response, err) in
        guard let jsonData = data else {
        return }
        do{
            // decode the JSON and populate an array
            let decoder = JSONDecoder()
            let shops = try decoder.decode(JSONSong.self, from: jsonData)
            // populate internal array with the shops
            DispatchQueue.main.async {
                self.songLabel.text = shops.lyrics
            }
        } catch let jsonErr {
            print("Error decoding JSON", jsonErr)
        }
        }.resume()
        }
    }
    
    
}
