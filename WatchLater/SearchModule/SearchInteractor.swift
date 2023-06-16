import UIKit
import Foundation

protocol ISearchInteractor: AnyObject {
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
    
    func getFilmSearchResultsByName(_ filmName: String) {
        var searchResults: [FilmSearchModel] = []
        
        apiManager.getSearchResultsByFilmName(filmName: filmName) { films in
            searchResults = films
            
            let tableData = {
                var films: [FilmCellModel] = []
                
                for film in searchResults {
                    if let cellFilm = self.convertToFilmCellModel(film) {
                        films.append(cellFilm)
                    }
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
                self?.apiManager.getPosterImageByURL(urlString: film.poster?.url) { [weak self] image in
                    posterImage = image
                    let posterImageData = posterImage?.jpegData(compressionQuality: 1)
                    let filmYear: Int = film.year ?? 0
                    if let filmID = film.id {
                        
                        var genres = ""
                        if let filmGenres = film.genres {
                            filmGenres.forEach { filmGenre in
                                genres += filmGenre.name + ", "
                            }
                        }
                        
                        var name = ""
                        if let filmNames = film.names, filmNames.count != 0 {
                            name += filmNames[0].name
                        }
                        
                        var countries = ""
                        if let filmCountries = film.countries {
                            filmCountries.forEach { filmCountry in
                                countries += filmCountry.name + ", "
                            }
                        }
                        
                        DataSourceManager.shared.createFilm(id: filmID,
                                                            name: name,
                                                            filmDescription: film.description,
                                                            type: film.type,
                                                            year: filmYear,
                                                            poster: posterImageData,
                                                            genre: genres,
                                                            country: countries,
                                                            rating: film.rating?.kp ?? 0,
                                                            commentary: ""
                        )
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
    func convertToFilmCellModel(_ searchModel: FilmSearchModel) -> FilmCellModel? {
        
        if let filmID = searchModel.id {
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
            if let count = searchModel.genres?.count, count != 0{
                if let genre = searchModel.genres?[0] {
                    filmGenre = genre
                }
            }
            
            let isDownloaded: Bool = {
                var downloaded = false
                let filmsDownloadedIDs = DataSourceManager.shared.getSavedFilmsIDs()
                filmsDownloadedIDs.forEach { id in
                    if id == searchModel.id {
                        downloaded = true
                    }
                }
                
                return downloaded
            }()
            
            let filmCellModel = FilmCellModel(id: filmID,
                                              cellFilmPoster: imagePlaceHolder,
                                              cellFilmName: searchModel.names?[0],
                                              filmDescription: searchModel.description,
                                              filmRating: filmRating,
                                              filmYear: filmYear,
                                              filmGenre: filmGenre,
                                              isDownloaded: isDownloaded
            )
            
            return filmCellModel
        } else {
            return nil
        }
        

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
                                            rating: coreDataModel.rating,
                                            isDownloaded: true
        )
        
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
                    genres += filmGenre.name + ", "
                }
            }
            
            var name = ""
            if let filmNames = filmModel.names, filmNames.count != 0 {
                name += filmNames[0].name
            }
            
            var countries = ""
            if let filmCountries = filmModel.countries {
                filmCountries.forEach { filmCountry in
                    countries += filmCountry.name + ", "
                }
            }
            
            let filmDetailModel = FilmDetailInfoModel(id: filmID,
                                                      name: name,
                                                      type: filmModel.type,
                                                      description: filmModel.description,
                                                      year: filmModel.year,
                                                      poster: posterImage,
                                                      genres: genres,
                                                      countries: countries,
                                                      rating: filmModel.rating?.kp,
                                                      commentary: ""
            )

            self?.presenter?.didLoadFilmByID(film: filmDetailModel)
        }
    }
}

