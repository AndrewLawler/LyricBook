//
//  ViewController.swift
//  Lyric Maker
//
//  Created by Andrew Lawler on 07/11/2019.
//  Copyright © 2019 andrewlawler. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITextFieldDelegate {
    
    var currentCell = -1

    var songName: [String] = []
    var songArtist: [String] = []
    var songs: [NSManagedObject] = []

    @IBOutlet var btn: UIButton!
    @IBOutlet weak var btn2: UIButton!
    
    @IBOutlet var artistField: UITextField!
    @IBOutlet var songField: UITextField!
    
    @IBOutlet var tableView: UITableView!
    
    @IBOutlet weak var lyricLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        coreReload()
        setDelegates()
        setupUI()
    }
    
    func setDelegates(){
        tableView.delegate = self
        tableView.dataSource = self
        artistField.delegate = self
        songField.delegate = self
    }
    
    func clearCoreDataStore() {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let context = delegate.persistentContainer.viewContext

        for i in 0...delegate.persistentContainer.managedObjectModel.entities.count-1 {
            let entity = delegate.persistentContainer.managedObjectModel.entities[i]

            do {
                let query = NSFetchRequest<NSFetchRequestResult>(entityName: entity.name!)
                let deleterequest = NSBatchDeleteRequest(fetchRequest: query)
                try context.execute(deleterequest)
                try context.save()

            } catch let error as NSError {
                print("Error: \(error.localizedDescription)")
                abort()
            }
        }
        tableView.reloadData()
    }
    
    func coreSave(){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Song", in: context)
        let newSong = NSManagedObject(entity: entity!, insertInto: context)
        newSong.setValue(artistField.text!, forKey: "artist")
        newSong.setValue(songField.text!, forKey: "name")
        saveSong(song: newSong)
        do {
           try context.save()
          } catch {
           print("Failed saving")
        }
    }
    
    func saveSong(song: NSManagedObject){
        songs.append(song)
    }
    
    func coreReload(){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Song")
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject] {
                songArtist.append(data.value(forKey: "artist") as! String)
                songName.append(data.value(forKey: "name") as! String)
                songs.append(data)
          }
        } catch {
            print("Failed")
        }
    }
    
    func setupUI(){
        // title
        let firstText = "Lyric"
        let firstAttributes = [NSAttributedString.Key.font : UIFont(name: "Helvetica-Bold", size: 34), NSAttributedString.Key.foregroundColor : UIColor.red]
        let attributedString = NSMutableAttributedString(string: firstText, attributes: firstAttributes as [NSAttributedString.Key : Any])
        let secondText = "Book"
        let secondAttributes = [NSAttributedString.Key.font : UIFont(name: "Helvetica-Bold", size: 34), NSAttributedString.Key.foregroundColor : UIColor.black]
        let secondString = NSMutableAttributedString(string: secondText, attributes: secondAttributes as [NSAttributedString.Key : Any])
        attributedString.append(secondString)
        lyricLabel.attributedText = attributedString
        
        // text fields
        artistField.layer.borderColor = UIColor.red.cgColor
        songField.layer.borderColor = UIColor.black.cgColor
        
        // buttons
        btn.backgroundColor = .clear
        btn.layer.cornerRadius = 5
        btn.layer.borderWidth = 1
        btn.layer.borderColor = UIColor.black.cgColor
        btn.tintColor = UIColor.red
        btn2.backgroundColor = .clear
        btn2.layer.cornerRadius = 5
        btn2.layer.borderWidth = 1
        btn2.layer.borderColor = UIColor.black.cgColor
        btn2.tintColor = UIColor.black
    }
    
    // segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toSongView" {
            let secondViewController = segue.destination as! SongsViewController
            secondViewController.songName = songName[currentCell]
            secondViewController.band = songArtist[currentCell]
        }
    }
    
    // clear button
    @IBAction func clearBtn(_ sender: Any) {
        // clear all of the arrays and clear core data also
        songArtist = []
        songName = []
        clearCoreDataStore()
    }
    
    @IBAction func goBtn(_ sender: Any) {
        // check if the input is invalid and then add into the table
        if artistField.text != "" && songField.text != "" {
            coreSave()
            let band = artistField.text
            let songname = songField.text
            songName.insert(songname!, at: 0)
            songArtist.insert(band!, at: 0)
            tableView.reloadData()
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        hideKeyboard()
        return true
    }
       
    func hideKeyboard(){
        artistField.resignFirstResponder()
        songField.resignFirstResponder()
    }

}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return songName.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "myCell")
        cell.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator
        
        let artistText = "\(songArtist[indexPath.row]) "
        let artistAttributes = [NSAttributedString.Key.font : UIFont(name: "Helvetica-Bold", size: 15)]
        let attributedString = NSMutableAttributedString(string: artistText, attributes: artistAttributes as [NSAttributedString.Key : Any])
        
        let hyphenText = "-"
        let hyphenAttributes = [NSAttributedString.Key.font : UIFont(name: "Helvetica", size: 15)]
        let hyphenString = NSMutableAttributedString(string: hyphenText, attributes: hyphenAttributes as [NSAttributedString.Key : Any])
        attributedString.append(hyphenString)
        
        let songText = " \(songName[indexPath.row])"
        let songAttributes = [NSAttributedString.Key.font : UIFont(name: "Helvetica", size: 15), NSAttributedString.Key.foregroundColor : UIColor.black]
        let songString = NSMutableAttributedString(string: songText, attributes: songAttributes as [NSAttributedString.Key : Any])
        attributedString.append(songString)
        
        cell.textLabel!.attributedText = attributedString
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        currentCell = indexPath.row
        performSegue(withIdentifier: "toSongView", sender: nil)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt
    indexPath: IndexPath) {
        if editingStyle == .delete {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            tableView.beginUpdates()
            if songName.count > 0 || songArtist.count > 0 {
                songName.remove(at: indexPath.row)
                songArtist.remove(at: indexPath.row)
            }
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.endUpdates()
            if songName.count==0 {
                tableView.isHidden = true
            }
            tableView.reloadData()
            context.delete(songs[indexPath.row])
            // Commit the change
            do
            {
            try context.save()
            } catch {
                print("changes failed")
            }
        }
    }
    
}

