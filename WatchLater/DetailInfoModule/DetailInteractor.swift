
import UIKit

protocol IDetailInteractor: AnyObject {
    func getFilmByID(_ filmID: Int)
    func filmUpdateCommentary(_ filmID: Int, commentary: String?)
    func saveFilmAndCommentary(_ filmID: Int, commentary: String?)
}

final class DetailInteractor: IDetailInteractor {
    weak var presenter: IDetailPresenter?
    private let apiManager: IAPIManager = APIManager()
    
    func getFilmByID(_ filmID: Int) {
        let film = DataSourceManager.shared.getFilmByID(filmID)
        if let filmModelCoreData = film {
            let filmInfoModel = converCoreDataToFilmModel(coreDataModel: filmModelCoreData)
            self.presenter?.didLoadFilmFromCoreData(filmInfoModel)
        }
    }
    
    func filmUpdateCommentary(_ filmID: Int, commentary: String?) {
        DataSourceManager.shared.updateFilmCommentary(filmID: filmID, commentary: commentary)
        self.presenter?.didUpdateCommentary()
    }
    
    func saveFilmAndCommentary(_ filmID: Int, commentary: String?) {
        
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
                                                            commentary: commentary
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
}

private extension DetailInteractor {
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
                                            isDownloaded: true,
                                            commentary: coreDataModel.commentary
        )
        
        return filmModel
    }
}
