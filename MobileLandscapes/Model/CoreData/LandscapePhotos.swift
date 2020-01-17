//
//  LandscapePhotos.swift
//  MobileLandscapes
//
//  Created by Miroslav Djukic on 19/12/2019.
//  Copyright © 2019 Miroslav Djukic. All rights reserved.
//

import UIKit
import CoreData

// for core data
public class LandscapePhotos: NSObject {
  
    static func saveLandscapePhotoURL(_ photoUrl: String){

        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let managedContext = appDelegate.persistentContainer.viewContext

        let landscapeEntity = NSEntityDescription.entity(forEntityName: "Landscape", in: managedContext)!
        
        let landscape = NSManagedObject(entity: landscapeEntity, insertInto: managedContext)
        landscape.setValue(photoUrl, forKeyPath: "url")
        do {
            try managedContext.save()
            
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    static func cacheImage(_ imageData: Data, photoUrl: String) {
      
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
               
        let managedContext = appDelegate.persistentContainer.viewContext

        let imageCacheEntity = NSEntityDescription.entity(forEntityName: "ImageCache", in: managedContext)!

        let imageObject = NSManagedObject(entity: imageCacheEntity, insertInto: managedContext) as! ImageCache
        imageObject.setValue(photoUrl, forKeyPath: "url")
        imageObject.setValue(imageData, forKeyPath: "photo")
        do {
           try managedContext.save()
           
        } catch let error as NSError {
           print("Could not save. \(error), \(error.userInfo)")
        }
    }
  
    static func getImage(by url: String)->UIImage? {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return nil }

        let managedContext = appDelegate.persistentContainer.viewContext

        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ImageCache")
        let predicate = NSPredicate(format: "url == %@", url)
        fetchRequest.predicate = predicate
        do {
            let result = try managedContext.fetch(fetchRequest)
            if result.count > 0, let data = result[0] as? ImageCache, let photo = data.photo, let image = UIImage(data: photo) {
                return image
            } else {
              return nil
            }
        } catch {
            print("Failed")
            return nil
        }
    }
    
    static func retrieveLandscapePhotoURL()->[String] {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return [] }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Landscape")
        do {
            let result = try managedContext.fetch(fetchRequest)

            var landscapePhotoURLS: [String] = []
            for data in result as! [NSManagedObject] {
                if let url = data.value(forKey: "url") as? String {
                    landscapePhotoURLS.insert(url, at: 0)
                }
            }
            return landscapePhotoURLS
        } catch {
            print("Failed")
            return []
        }
    }
}
