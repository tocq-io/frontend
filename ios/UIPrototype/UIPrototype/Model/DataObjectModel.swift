//
//  DataObjectModel.swift
//  UIPrototype
//
//  Created by Philipp on 27.05.21.
//

import Foundation
import CoreData

@objc(DataObject)
public class DataObject: NSManagedObject {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<DataObject> {
        return NSFetchRequest<DataObject>(entityName: "DataObject")
    }

    @NSManaged public var created: Date?
    @NSManaged public var data: Data?
    @NSManaged public var pubCert: Data?
    @NSManaged public var topic: Topic?

}
