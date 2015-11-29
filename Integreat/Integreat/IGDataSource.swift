import Foundation


@objc
class IGDataSource: NSObject {
    
    let managedObjectContext: NSManagedObjectContext
    let connectionManager = SlimConnectionManager()
    
    init(managedObjectContext: NSManagedObjectContext) {
        self.managedObjectContext = managedObjectContext
    }
    
    
    /// Fetches all locations
    func fetchLocations() -> RACSignal {
        return connectionManager.getLocations().map { [weak self] (json) -> AnyObject! in
            guard let self_ = self, json = json as? [String: AnyObject] else { return nil }
            return Location.locationWithJson(json, inContext: self_.managedObjectContext)
        }
    }
    
    /// Fetches all languages for a specific location
    func fetchLanguagesForLocation(location: Location) -> RACSignal {
        return connectionManager.getLanguagesForCity(location.resourceName).map { [weak self] (json) -> AnyObject! in
            guard let self_ = self, json = json as? [String: AnyObject] else { return nil }
            return Language.languageWithJson(json, inContext: self_.managedObjectContext)
        }
    }
    
    /// Fetches pages for a specific location and language
    func fetchPagesForLocation(location: Location, language: Language) -> RACSignal {
        let date = NSDate(timeIntervalSinceReferenceDate: 0)
        let pagesSignal = connectionManager.getPagesForLocation(location.resourceName, language: language.resourceName, sinceDate: date)
        return pagesSignal.map { [weak self] (json) -> AnyObject! in
            guard let self_ = self, json = json as? [String: AnyObject] else { return nil }
            return Page.pageWithJson(json, inContext: self_.managedObjectContext)
        }
    }

}
