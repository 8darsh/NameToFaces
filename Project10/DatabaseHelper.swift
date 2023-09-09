//
//  DatabaseHelper.swift
//  Project10
//
//  Created by Adarsh Singh on 31/08/23.
//

import Foundation
import UIKit
import CoreData

class DatabaseHelper{
    
    static var shareInstance = DatabaseHelper()
    
    let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
    
    func save(object: [String:String]){
        
        let people = NSEntityDescription.insertNewObject(forEntityName: "People", into: context!) as! People
        
        people.image = object["image"]
        people.name = object["name"]
        
        do{
           try context?.save()
        }catch{
            print("Not saved")
        }
    }
    func getData() -> [People]{
        var people = [People]()
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "People")
        
        do{
            people = try context?.fetch(fetchRequest) as! [People]
        }catch{
            print("Pura thela LAAL HAI")
        }
        
        return people
    }
    func deleteData(index:Int) -> [People]{
        var person = getData()
        context?.delete(person[index])
        person.remove(at: index)
        
        do{
            try context?.save()
        }catch{
            print("Can't get Data")
        }
        
        return person
    }
    
}
