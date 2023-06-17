
import UIKit
import Alamofire
import Kingfisher
import Foundation

protocol IAPIManager: AnyObject {
    func getRandomFilm() -> FilmModel?
    func getSearchResultsByFilmName(filmName: String, completion: @escaping ([FilmSearchModel]) -> Void)
    func getPosterImageByURL(urlString: String?, completion: @escaping (UIImage?) -> Void)
    func getFilmByID(filmID: Int, completion: @escaping (FilmModel?) -> Void)
}

class APIManager: IAPIManager {
    
    func getRandomFilm() -> FilmModel? {
        var randomFilm: FilmModel?
        
        let url = endpointsAPI.randomFilmURL
        let headers: HTTPHeaders = [
            "accept": "application/json",
            "X-API-KEY": endpointsAPI.token
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
            completion(nil)
            return
        }
        
        let resource = ImageResource(downloadURL: url)
        let cache = ImageCache.default
        cache.clearMemoryCache()
        
        KingfisherManager.shared.retrieveImage(with: resource, options: nil, progressBlock: nil) { result in
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

        let url = endpointsAPI.searchURL
        let headers: HTTPHeaders = [
            "accept": "application/json",
            "X-API-KEY": endpointsAPI.token
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
                }
            case .failure(let error):
                print(error.errorDescription ?? "some error")
            }
        }
    }
    
    func getFilmByID(filmID: Int, completion: @escaping (FilmModel?) -> Void) {
        
        let url = endpointsAPI.getFilmByIDURL + "\(filmID)"
        let headers: HTTPHeaders = [
            "accept": "application/json",
            "X-API-KEY": endpointsAPI.token
        ]
        
        AF.request(url, method: .get, parameters: nil, encoding: URLEncoding.default, headers: headers).responseData { response in
            switch response.result {
            case .success(let data):
                if (response.response?.statusCode == 200) {
                    let film = try! JSONDecoder().decode(FilmModel.self, from: data)
                    completion(film)
                }
            case .failure(let error):
                print(error.errorDescription ?? "some error")
            }
        }
    }
}
