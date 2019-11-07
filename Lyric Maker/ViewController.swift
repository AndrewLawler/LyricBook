//
//  ViewController.swift
//  Lyric Maker
//
//  Created by Andrew Lawler on 07/11/2019.
//  Copyright © 2019 andrewlawler. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var currentCell = -1
    
    var songsRequests: [URL] = []
    var songName: [String] = []
    var songArtist: [String] = []

    @IBOutlet var btn: UIButton!
    @IBOutlet var artistField: UITextField!
    @IBOutlet var songField: UITextField!
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        button()
    }
    
    func button(){
        artistField.layer.cornerRadius = 5
        artistField.layer.borderWidth = 1
        artistField.layer.borderColor = UIColor.orange.cgColor
        
        songField.layer.cornerRadius = 5
        songField.layer.borderWidth = 1
        songField.layer.borderColor = UIColor.orange.cgColor
        
        btn.backgroundColor = .clear
        btn.layer.cornerRadius = 5
        btn.layer.borderWidth = 1
        btn.layer.borderColor = UIColor.orange.cgColor
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toSongView" {
            let secondViewController = segue.destination as! SongsViewController
            secondViewController.song = songsRequests[currentCell]
            secondViewController.songName = "\(songArtist[currentCell]) - \(songName[currentCell])"
        }
    }
    
    @IBAction func goBtn(_ sender: Any) {
        if artistField.text != "" && songField.text != "" {
            let band = artistField.text
            let songname = songField.text
            let url = URL(string: "https://api.lyrics.ovh/v1/\(band!)/\(songname!)")!
            songsRequests.insert(url, at: 0)
            songName.insert(songname!, at: 0)
            songArtist.insert(band!, at: 0)
            tableView.reloadData()
        }
    }

}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return songsRequests.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "myCell")
        cell.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator
        cell.textLabel!.text = "\(songArtist[indexPath.row]) - \(songName[indexPath.row])"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        currentCell = indexPath.row
        performSegue(withIdentifier: "toSongView", sender: nil)
    }
    
    
    
    
    
}

