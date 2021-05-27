//
//  SignatureModel.swift
//  UIPrototype
//
//  Created by Philipp on 27.05.21.
//

import Foundation
import CoreData

@objc(Signature)
public class Signature: NSManagedObject {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Signature> {
        return NSFetchRequest<Signature>(entityName: "Signature")
    }

    @NSManaged public var signature: Data
    @NSManaged public var sharedTopicID: String
    @NSManaged public var topic: Topic

}
