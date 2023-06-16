
import UIKit

protocol IDetailInteractor: AnyObject {
    func getFilmByID(_ filmID: Int)
}

final class DetailInteractor: IDetailInteractor {
    weak var presenter: IDetailPresenter?
    
    func getFilmByID(_ filmID: Int) {
        let film = DataSourceManager.shared.getFilmByID(filmID)
        if let filmModelCoreData = film {
            let filmInfoModel = converCoreDataToFilmModel(coreDataModel: filmModelCoreData)
            self.presenter?.didLoadFilmFromCoreData(filmInfoModel)
        }
        // обработать случай если фильма нет в кордате (хотя этого не может произойти)
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
                                            rating: coreDataModel.rating)
        
        return filmModel
    }
}
