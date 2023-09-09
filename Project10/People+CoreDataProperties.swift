//
//  People+CoreDataProperties.swift
//  Project10
//
//  Created by Adarsh Singh on 31/08/23.
//
//

import Foundation
import CoreData


extension People {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<People> {
        return NSFetchRequest<People>(entityName: "People")
    }

    @NSManaged public var image: String?
    @NSManaged public var name: String?

}

extension People : Identifiable {

}
