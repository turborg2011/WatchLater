
import Foundation
import UIKit

enum endpointsAPI {
    
    // из переменных среды
    
    private static var infoDict: [String: Any] {
        if let dict = Bundle.main.infoDictionary {
            print("\(dict)")
            return dict
        } else {
            fatalError("Info Plist file not found")
            
        }
    }
    
    static let token = infoDict["apiToken"] as! String
    
    static let randomFilmURL = "https://api.kinopoisk.dev/v1.3/movie/random"
    static let searchURL = "https://api.kinopoisk.dev/v1.2/movie/search"
    static let getFilmByIDURL = "https://api.kinopoisk.dev/v1.3/movie/"
    
}
