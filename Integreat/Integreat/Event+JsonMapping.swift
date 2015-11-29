
import Foundation


extension Event {
    
    class func eventsWithJson(json: [[String: AnyObject]], inContext context: NSManagedObjectContext) -> [Event] {
        return json
            .sort { Int($0["id"] as! String)! < Int($1["id"] as! String)! }
            .map { eventWithJson($0, inContext: context) }
    }
    
    class func eventWithJson(json: [String: AnyObject], inContext context: NSManagedObjectContext) -> Event {
        let identifier = json["id"] as! String
        
        if let event = Event.findEventWithIdentifier(identifier, inContext: context) {
            updateEvent(event, withJson: json)
            return event
        }
        else {
            let event = NSEntityDescription.insertNewObjectForEntityForName("Event", inManagedObjectContext: context)
                as! Event
            event.identifier = identifier
            updateEvent(event, withJson: json)
            return event
        }
    }
    
    class func updateEvent(event: Event, withJson json: [String: AnyObject]) {
        event.address = json["address"] as? String
        event.content = json["content"] as? String
        event.startDate = json["startDate"] as? String
        event.startTime = json["startTime"] as? String
        event.lastModified = NSDate() // TODO: use modified_gmt
//        event.parentPage = (json["parent"] as? String).flatMap { parentId in
//            if (parentId == "0") { return nil; }
//            return Event.findEventWithIdentifier(parentId, inContext: page.managedObjectContext!)
//        }
    }
    
}
