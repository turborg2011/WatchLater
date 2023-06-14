//
//  FilmModelCoreData+CoreDataProperties.swift
//  WatchLater
//
//  Created by Хайдар Даукаев on 13.06.2023.
//
//

import Foundation
import CoreData


extension FilmModelCoreData {

//    @nonobjc public class func fetchRequest() -> NSFetchRequest<FilmModelCoreData> {
//        return NSFetchRequest<FilmModelCoreData>(entityName: "FilmModelCoreData")
//    }

    @NSManaged public var id: Int64
    @NSManaged public var name: String?
    @NSManaged public var filmDescription: String?
    @NSManaged public var poster: Data?

}

extension FilmModelCoreData : Identifiable {

}
