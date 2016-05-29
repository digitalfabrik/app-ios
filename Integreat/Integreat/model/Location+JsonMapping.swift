import Foundation


extension Location {
    
    class func locationWithJson(json: [String: AnyObject], inContext context: NSManagedObjectContext) -> Location {
        let identifier = json["id"] as! String
        
        if let location = Location.findLocationWithIdentifier(identifier, inContext: context) {
            updateLocation(location, withJson: json)
            return location
        }
        else {
            let location = NSEntityDescription.insertNewObjectForEntityForName("Location", inManagedObjectContext: context) as! Location
            location.identifier = identifier
            updateLocation(location, withJson: json)
            return location
        }
    }
    
    class func updateLocation(location: Location, withJson json: [String: AnyObject]) {
        location.resourceName = (json["path"] as? String).flatMap {
            $0.componentsSeparatedByString("/")[2]
        }
        location.color = json["color"] as? String
        location.name = json["name"] as? String
        location.iconImageUrl = (json["icon"] as? String).flatMap(NSURL.init)
    }
    
}
