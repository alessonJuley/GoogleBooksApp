//
//  GoogleBooks+CoreDataProperties.swift
//  AbaoProjectPartB
//
//  Created by Alesson Abao on 14/11/22.
//
//

import Foundation
import CoreData


extension GoogleBooks {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<GoogleBooks> {
        return NSFetchRequest<GoogleBooks>(entityName: "GoogleBooks")
    }

    @NSManaged public var title: String?
    @NSManaged public var language: String?
    @NSManaged public var publishedDate: String?
    @NSManaged public var pic: Data?

}

extension GoogleBooks : Identifiable {

}
