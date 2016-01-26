import UIKit


class RootNavigationController: UINavigationController {
    
    var apiService: IGApiService?
    var languagePickedObserver: NSObjectProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateRootVC()
        
        languagePickedObserver = NSNotificationCenter.defaultCenter().addObserverForName(IGLanguagePickedNotification,
            object: nil,
            queue: NSOperationQueue.mainQueue(),
            usingBlock: { [weak self] _ in self?.updateRootVC(animated: true) }
        )
    }
    
    deinit {
        if let observer = languagePickedObserver {
            NSNotificationCenter.defaultCenter().removeObserver(observer,
                name: IGLanguagePickedNotification,
                object: nil
            )
        }
    }
    
    @IBAction func showCityPicker(_: AnyObject?) {
        let cityPickerVC = instantiateCityPickerVC()
        setViewControllers([ cityPickerVC ], animated: true)
    }
    
    private func updateRootVC(animated animated: Bool = false) {
        let selection = getSelectedLocationAndLanguage()
        
        // Show pages
        if let location = selection.0, language = selection.1 {
            let pagesListVC = instantiatePagesListVCWithLocation(location, language: language)
            setViewControllers([ pagesListVC ], animated: animated)
        }
        // Pick city + language
        else {
            let cityPickerVC = instantiateCityPickerVC()
            setViewControllers([ cityPickerVC ], animated: animated)
        }
    }
    
    private func instantiateCityPickerVC() -> IGCityPickerVCCollectionViewController {
        let cityPickerVC = self.storyboard?.instantiateViewControllerWithIdentifier("CityPickerVC")
            as! IGCityPickerVCCollectionViewController
        cityPickerVC.apiService = apiService
        return cityPickerVC
    }
    
    private func instantiatePagesListVCWithLocation(location: Location, language: Language) -> IGPagesListVC {
        let pagesListVC = self.storyboard?.instantiateViewControllerWithIdentifier("PagesListVC")
            as! IGPagesListVC
        pagesListVC.apiService = apiService
        pagesListVC.selectedLocation = location
        pagesListVC.selectedLanguage = language
        return pagesListVC
    }
    
    private func getSelectedLocationAndLanguage() -> (Location?, Language?) {
        let location = NSUserDefaults.standardUserDefaults().stringForKey("location").flatMap { locationId in
            (self.apiService?.context).flatMap { context in
                Location.findLocationWithIdentifier(locationId, inContext: context)
            }
        }
        let language = NSUserDefaults.standardUserDefaults().stringForKey("language").flatMap { languageId in
            (self.apiService?.context).flatMap { context in
                Language.findLanguageWithIdentifier(languageId, inContext: context)
            }
        }
        return (location, language)
    }
    
}
