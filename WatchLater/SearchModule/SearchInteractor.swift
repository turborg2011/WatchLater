import UIKit
import Foundation

protocol ISearchInteractor: AnyObject {
    func getRandomFilm() -> FilmModel?
    func getFilmSearchResultsByName(_ filmName: String)
}

final class SearchInteractor {
    weak var presenter: ISearchPresenter?
    private let apiManager: IAPIManager = APIManager()
}

extension SearchInteractor: ISearchInteractor {
    func getRandomFilm() -> FilmModel? {
        let randomFilm = apiManager.getRandomFilm()
        return randomFilm
    }
    
    func getFilmSearchResultsByName(_ filmName: String) {
        var searchResults: [FilmSearchModel] = []
        
        apiManager.getSearchResultsByFilmName(filmName: filmName) { films in
            searchResults = films
            print("FILMS COUNT IN COMPL = \(films.count)")
            
            let tableData = {
                var films: [FilmCellModel] = []
                
                for film in searchResults {
                    let cellFilm = self.convertToFilmCellModel(film)
                    films.append(cellFilm)
                }
                
                return films
            }()
            
            self.presenter?.didLoadFilmsSearch(filmsListSearch: tableData)
        }
    }
}

private extension SearchInteractor {
    func convertToFilmCellModel(_ searchModel: FilmSearchModel) -> FilmCellModel {
        
        apiManager.getPosterImageByURL(urlString: searchModel.poster) { image in
            self.presenter?.didLoadFilmPoster(filmID: searchModel.id, image: image)
        }
        
        
        var config = UIImage.SymbolConfiguration(paletteColors: [.systemGray5])
        config = config.applying(UIImage.SymbolConfiguration(scale: .small))
        let imagePlaceHolder = UIImage(systemName: "photo.fill", withConfiguration: config)
        
        let filmCellModel = FilmCellModel(id: searchModel.id, cellFilmPoster: imagePlaceHolder, cellFilmName: searchModel.name)
        
        return filmCellModel
    }
}

