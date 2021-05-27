//
//  TopicModel.swift
//  UIPrototype
//
//  Created by Philipp on 21.05.21.
//

import Foundation
import CoreData
import CryptoKit

@objc(Topic)
public class Topic: NSManagedObject {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Topic> {
        return NSFetchRequest<Topic>(entityName: "Topic")
    }
   
    @NSManaged public var objects: NSOrderedSet?
    @NSManaged public var signatures: NSSet?
    @NSManaged public var pubCert: Data
    
    @NSManaged private var primitiveName: String
    @NSManaged private var primitiveCreated: Date
    
    @objc public var created: Date {
        return primitiveCreated
    }
    
    @objc public var name: String {
        get {
            return primitiveName
        }
        set {
            primitiveName = newValue
            primitiveCreated = Date()
        }
    }
    
    //Data Objects Methods
    @objc(insertObject:inObjectsAtIndex:)
    @NSManaged public func insertIntoObjects(_ value: DataObject, at idx: Int)

    @objc(removeObjectFromObjectsAtIndex:)
    @NSManaged public func removeFromObjects(at idx: Int)

    @objc(insertObjects:atIndexes:)
    @NSManaged public func insertIntoObjects(_ values: [DataObject], at indexes: NSIndexSet)

    @objc(removeObjectsAtIndexes:)
    @NSManaged public func removeFromObjects(at indexes: NSIndexSet)

    @objc(replaceObjectInObjectsAtIndex:withObject:)
    @NSManaged public func replaceObjects(at idx: Int, with value: DataObject)

    @objc(replaceObjectsAtIndexes:withObjects:)
    @NSManaged public func replaceObjects(at indexes: NSIndexSet, with values: [DataObject])

    @objc(addObjectsObject:)
    @NSManaged public func addToObjects(_ value: DataObject)

    @objc(removeObjectsObject:)
    @NSManaged public func removeFromObjects(_ value: DataObject)

    @objc(addObjects:)
    @NSManaged public func addToObjects(_ values: NSOrderedSet)

    @objc(removeObjects:)
    @NSManaged public func removeFromObjects(_ values: NSOrderedSet)

    //Sigantures methods
    @objc(addSignaturesObject:)
    @NSManaged public func addToSignatures(_ value: Signature)

    @objc(removeSignaturesObject:)
    @NSManaged public func removeFromSignatures(_ value: Signature)

    @objc(addSignatures:)
    @NSManaged public func addToSignatures(_ values: NSSet)

    @objc(removeSignatures:)
    @NSManaged public func removeFromSignatures(_ values: NSSet)

}
