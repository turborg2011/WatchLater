
import UIKit

protocol IFavoritesInteractor: AnyObject {
    func getFavoritesFilms()
    func deleteAllFavFilms()
    func deleteFilm(_ filmID: Int)
    func saveFilm(_ filmID: Int)
}

final class FavoritesInteractor {
    
    weak var presenter: IFavoritesPresenter?
    private let apiManager: IAPIManager = APIManager()
    
}

extension FavoritesInteractor: IFavoritesInteractor {

    func getFavoritesFilms() {
        let films = DataSourceManager.shared.fetchFilms()
        var filmsCellModel: [FilmCellModel] = []
        
        films.forEach { filmCoreData in
            filmsCellModel.append(converCoreDataToFilmCellModel(coreDataModel: filmCoreData))
        }
        print("INTER: items in filmsCellModel == \(filmsCellModel.count)")
        self.presenter?.didLoadFavoriteFilms(filmsCellModel)
    }
    
    func deleteAllFavFilms() {
        DataSourceManager.shared.deleteAllFavFilms()
        self.presenter?.didDeleteAllFavFilms()
    }
    
    func saveFilm(_ filmID: Int) {
        
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
}

private extension FavoritesInteractor {
    func converCoreDataToFilmCellModel(coreDataModel: FilmModelCoreData) -> FilmCellModel {
        var posterImage: UIImage? = UIImage(systemName: "photo")
        
        if let posterData = coreDataModel.poster {
            posterImage = UIImage(data: posterData)
        }
        
        let rating = String(coreDataModel.rating)
        let year = String(coreDataModel.year)
        
        let filmCellModel = FilmCellModel(id: coreDataModel.id,
                                           cellFilmPoster: posterImage,
                                           cellFilmName: coreDataModel.name,
                                           filmDescription: coreDataModel.filmDescription,
                                           filmRating: rating,
                                           filmYear: year,
                                           filmGenre: coreDataModel.genre,
                                           isDownloaded: true)
        
        return filmCellModel
    }
}

