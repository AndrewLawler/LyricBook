//
//  SongsViewController.swift
//  Lyric Maker
//
//  Created by Andrew Lawler on 07/11/2019.
//  Copyright © 2019 andrewlawler. All rights reserved.
//

import UIKit

// MARK: JSON Struct
// struct to model the JSON that gets returned
struct JSONSong: Decodable {
    var lyrics:String?
}

// MARK: View Controller
class SongsViewController: UIViewController {
    
    let mainVc = ViewController()
    
    // Outlets
    @IBOutlet var songNameLabel: UILabel!
    @IBOutlet weak var songLabel: UITextView!
    
    // Variables which get populated from the initial View Controller
    var band:String?
    var songName:String?

    override func viewDidLoad() {
        super.viewDidLoad()
        songLabel.isEditable = false
        setupTitle()
        getSong()
    }
    
    func setupTitle(){
        let artistText = "\(band!)"
        let artistAttributes = [NSAttributedString.Key.font : UIFont(name: "Helvetica-Bold", size: 20), NSAttributedString.Key.foregroundColor : UIColor.red]
        let attributedString = NSMutableAttributedString(string: artistText, attributes: artistAttributes as [NSAttributedString.Key : Any])
        let songText = " - \(songName!)"
        let songAttributes = [NSAttributedString.Key.font : UIFont(name: "Helvetica-Bold", size: 20), NSAttributedString.Key.foregroundColor : UIColor.black]
        let songString = NSMutableAttributedString(string: songText, attributes: songAttributes as [NSAttributedString.Key : Any])
        attributedString.append(songString)
        songNameLabel.attributedText = attributedString
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
            var song = try decoder.decode(JSONSong.self, from: jsonData)
            DispatchQueue.main.async {
                if song.lyrics == nil {
                    self.songLabel.text = "There are no lyrics for this song / This song does not exist"
                }
                else {
                    self.songLabel.text = song.lyrics
                }
            }
        } catch let jsonErr {
            print("Error decoding JSON", jsonErr)
        }
        }.resume()
        }
    }
    
    
}
