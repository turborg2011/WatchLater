
import UIKit

protocol IFavoritesInteractor: AnyObject {
    func getAllFilms()
    func getFavoritesFilms()
    func deleteAllFavFilms()
    func deleteFilm(_ filmID: Int)
}

final class FavoritesInteractor {
    
    weak var presenter: IFavoritesPresenter?
    
}

extension FavoritesInteractor: IFavoritesInteractor {
    func getAllFilms() {
        //
    }
    
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
        
        let filmCellModel = FilmCellModel(id: coreDataModel.id,
                                          cellFilmPoster: posterImage,
                                          cellFilmName: coreDataModel.name,
                                          filmDescription: coreDataModel.filmDescription
        )
        
        return filmCellModel
    }
}

