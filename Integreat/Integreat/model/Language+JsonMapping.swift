import Foundation


extension Language {
    
    class func languageWithJson(json: [String: AnyObject], inContext context: NSManagedObjectContext) -> Language {
        let identifier = json["id"] as! String
        
        if let language = Language.findLanguageWithIdentifier(identifier, inContext: context) {
            updateLanguage(language, withJson: json)
            return language
        }
        else {
            let language = NSEntityDescription.insertNewObjectForEntityForName("Language", inManagedObjectContext: context)
                as! Language
            language.identifier = identifier
            updateLanguage(language, withJson: json)
            return language
        }
    }
    
    class func updateLanguage(language: Language, withJson json: [String: AnyObject]) {
        language.resourceName = json["code"] as? String
        language.nativeName = json["native_name"] as? String
        language.iconImageUrl = (json["country_flag_url"] as? String).flatMap(NSURL.init)
    }
    
}
