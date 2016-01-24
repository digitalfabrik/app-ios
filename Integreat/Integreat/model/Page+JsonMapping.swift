import Foundation


extension Page {
    
    class func pagesWithJson(json: [[String: AnyObject]], inContext context: NSManagedObjectContext) -> [Page] {
        return json
            .sort {
                ($0["id"] as? Int) ?? Int.max < ($1["id"] as? Int) ?? Int.max
            }
            .map { pageWithJson($0, inContext: context) }
    }
    
    class func pageWithJson(json: [String: AnyObject], inContext context: NSManagedObjectContext) -> Page {
        let identifier = (json["id"] as? Int) ?? 0
        
        if let page = Page.findPageWithIdentifier(identifier, inContext: context) {
            updatePage(page, withJson: json)
            return page
        }
        else {
            let page = NSEntityDescription.insertNewObjectForEntityForName("Page", inManagedObjectContext: context)
                as! Page
            page.identifier = identifier
            updatePage(page, withJson: json)
            return page
        }
    }
    
    class func updatePage(page: Page, withJson json: [String: AnyObject]) {
        page.excerpt = json["excerpt"] as? String
        page.content = json["content"] as? String
        page.title = json["title"] as? String
        page.order = json["order"] as? String
        page.thumbnailImageUrl = (json["thumbnail"] as? String).flatMap(NSURL.init)
        page.lastModified = NSDate() // TODO: use modified_gmt
        page.parentPage = (json["parent"] as? Int).flatMap { parentId in
            if (parentId == 0) { return nil; }
            return Page.findPageWithIdentifier(parentId, inContext: page.managedObjectContext!)
        }
    }
    
}
