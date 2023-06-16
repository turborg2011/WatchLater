import UIKit
import Foundation

protocol ISearchInteractor: AnyObject {
    // рандомный фильм переделать
    func getRandomFilm() -> FilmModel?
    func getFilmSearchResultsByName(_ filmName: String)
    func getFilmById(_ filmID: Int)
    func saveFilm(_ filmID: Int)
    func deleteFilm(_ filmID: Int)
    func getFavoritesFilms() -> [FilmModel]
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
    
    func getFilmById(_ filmID: Int) {
        if let filmModelCoreData = DataSourceManager.shared.getFilmByID(filmID) {
            let filmInfoModel = converCoreDataToFilmModel(coreDataModel: filmModelCoreData)
            self.presenter?.didLoadFilmFromCoreData(filmInfoModel)
        }
        
        apiManager.getFilmByID(filmID: filmID) { [weak self] filmModel in
            if let film = filmModel {
                self?.convertFilmModelToDetailModel(film)
            } else {
                print("film == nil")
            }
        }
    }
    
    func saveFilm(_ filmID: Int) {
        
        // какой то странный код получился (может и нет):
        // сначала нужно получить film Model от апи
        // а потом получить картинку постера тоже от апи
        // и сохранить это все в кордату
        // возможно лучше эту всю логику унести в апи менеджер
        
        apiManager.getFilmByID(filmID: filmID) { [weak self] filmModel in
            if let film = filmModel {
                var posterImage: UIImage?
                let filmName = film.names?[0].name
                self?.apiManager.getPosterImageByURL(urlString: film.poster?.url) { [weak self] image in
                    posterImage = image
                    let posterImageData = posterImage?.jpegData(compressionQuality: 1)
                    let filmYear: Int = film.year ?? 0
                    if let filmID = film.id {
                        DataSourceManager.shared.createFilm(id: filmID,
                                                            name: filmName,
                                                            filmDescription: film.description,
                                                            type: film.type,
                                                            year: filmYear,
                                                            poster: posterImageData,
                                                            genre: film.genres?[0].name,
                                                            country: film.countries?[0].name,
                                                            rating: film.rating?.kp ?? 0)
                        print("filmsucsessfullySaved")
                        self?.presenter?.didAddFilm(filmID)
                    }
                }
            } else {
                print("film == nil")
            }
        }
    }
    
    func deleteFilm(_ filmID: Int) {
        DataSourceManager.shared.deleteFilm(filmID: filmID)
        self.presenter?.didDeleteFilm(filmID)
    }
    
    func getFavoritesFilms() -> [FilmModel] {
        
        return []
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
        
        var filmRating = "-"
        if let rating = searchModel.rating {
            filmRating = String(rating)
        }
        
        var filmYear = "-"
        if let year = searchModel.year {
            filmYear = String(year)
        }
        
        var filmGenre = "-"
        if let genre = searchModel.genres?[0] {
            filmGenre = genre
        }
        
        let filmCellModel = FilmCellModel(id: searchModel.id,
                                          cellFilmPoster: imagePlaceHolder,
                                          cellFilmName: searchModel.names?[0],
                                          filmDescription: searchModel.description,
                                          filmRating: filmRating,
                                          filmYear: filmYear,
                                          filmGenre: filmGenre
        )
        
        return filmCellModel
    }
    
    func converCoreDataToFilmModel(coreDataModel: FilmModelCoreData) -> FilmDetailInfoModel {
        var posterImage: UIImage? = nil
        
        if let posterData = coreDataModel.poster {
            posterImage = UIImage(data: posterData)
        }
        
        let filmModel = FilmDetailInfoModel(id: coreDataModel.id,
                                            name: coreDataModel.name,
                                            type: coreDataModel.type,
                                            description: coreDataModel.filmDescription,
                                            year: coreDataModel.year,
                                            poster: posterImage,
                                            genres: coreDataModel.genre,
                                            countries: coreDataModel.country,
                                            rating: coreDataModel.rating)
        
        return filmModel
    }
    
    func convertFilmModelToDetailModel(_ filmModel: FilmModel) {
        
        guard let filmID = filmModel.id else {
            return
        }
        
        apiManager.getPosterImageByURL(urlString: filmModel.poster?.url) { [weak self] filmPosterImage in
            let posterImage = filmPosterImage ?? UIImage(systemName: "photo")
            
            var genres = ""
            if let filmGenres = filmModel.genres {
                filmGenres.forEach { filmGenre in
                    genres = genres + ", " + filmGenre.name
                }
            }
            
            let filmDetailModel = FilmDetailInfoModel(id: filmID,
                                                      name: filmModel.names?[0].name,
                                                      type: filmModel.type,
                                                      description: filmModel.description,
                                                      year: filmModel.year,
                                                      poster: posterImage,
                                                      genres: genres,
                                                      countries: filmModel.countries?[0].name,
                                                      rating: filmModel.rating?.kp)

            self?.presenter?.didLoadFilmByID(film: filmDetailModel)
        }
    }
}

