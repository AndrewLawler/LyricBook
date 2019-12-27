//
//  Song+CoreDataProperties.swift
//  Lyric Maker
//
//  Created by Andrew Lawler on 27/12/2019.
//  Copyright © 2019 andrewlawler. All rights reserved.
//
//

import Foundation
import CoreData


extension Song {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Song> {
        return NSFetchRequest<Song>(entityName: "Song")
    }

    @NSManaged public var artist: String?
    @NSManaged public var name: String?

}
