
import UIKit
import Alamofire
import Kingfisher
import Foundation

protocol IAPIManager: AnyObject {
    func getRandomFilm() -> FilmModel?
    func getSearchResultsByFilmName(filmName: String, completion: @escaping ([FilmSearchModel]) -> Void)
    func getPosterImageByURL(urlString: String?, completion: @escaping (UIImage?) -> Void)
}

class APIManager: IAPIManager {
    
    func getRandomFilm() -> FilmModel? {
        var randomFilm: FilmModel?
        
        // вынести url в userdefaults
        let url = "https://api.kinopoisk.dev/v1.3/movie/random"
        let headers: HTTPHeaders = [
            "accept": "application/json",
            // вынести ключ в keychain
            "X-API-KEY": "WTTWJV6-NQAMM86-MQ32AR1-DHB6A03"
        ]
        
        AF.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers).responseData { response in
            switch response.result {
            case .success(let data):
                if (response.response?.statusCode == 200) {
                    let film = try! JSONDecoder().decode(FilmModel.self, from: data)
                    randomFilm = film
                }
            case .failure(let error):
                print(error.errorDescription ?? "some error")
            }
        }
        
        return randomFilm
    }
    
    func getPosterImageByURL(urlString: String?, completion: @escaping (UIImage?) -> Void) {
        
        var image: UIImage?
        
        
        guard let url = URL.init(string: urlString ?? "") else {
            return
        }
        let resource = ImageResource(downloadURL: url)
        
        let cache = ImageCache.default
        cache.clearMemoryCache()
        
        let processor = RoundCornerImageProcessor(cornerRadius: 30)
        
        KingfisherManager.shared.retrieveImage(with: resource, options: [.processor(processor)], progressBlock: nil) { result in
            switch result {
            case .success(let value):
                image = value.image
                completion(image)
            case .failure(let error):
                print("Error: \(error)")
            }
        }
    }
    
    func getSearchResultsByFilmName(filmName: String, completion: @escaping ([FilmSearchModel]) -> Void) {
        var filmSearchResults: [FilmSearchModel] = []
        
        // вынести url в userdefaults
        let url = "https://api.kinopoisk.dev/v1.2/movie/search"
        //let url = ""
        let headers: HTTPHeaders = [
            "accept": "application/json",
            // вынести ключ в keychain
            "X-API-KEY": "WTTWJV6-NQAMM86-MQ32AR1-DHB6A03"
        ]
        
        let parameters: Parameters = [
            "page": "1",
            "limit": "10",
            "query": "\(filmName)"
        ]
        
        AF.request(url, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: headers).responseData { response in
            switch response.result {
            case .success(let data):
                if (response.response?.statusCode == 200) {
                    let films = try! JSONDecoder().decode(FilmSearchResults.self, from: data)
                    filmSearchResults = films.docs
                    completion(filmSearchResults)
                    print(filmSearchResults.count)
                    //print(filmSearchResults)
                }
            case .failure(let error):
                print(error.errorDescription ?? "some error")
            }
        }
        
        //return filmSearchResults
    }
}
