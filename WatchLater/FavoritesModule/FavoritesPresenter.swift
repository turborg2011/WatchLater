
import UIKit

protocol IFavoritesPresenter: AnyObject {
    func viewDidLoad(_ view: IFavoritesView)
    func didLoadFavoriteFilms(_ films: [FilmCellModel])
    func viewDidAppear()
    func didDeleteAllFavFilms()
    func didDeleteFilm(_ filmID: Int)
}

final class FavoritesPresenter: IFavoritesPresenter {
    
    weak var view: IFavoritesView?
    weak var viewController: IFavoritesViewController?
    private let favoritesInteractor: IFavoritesInteractor
    private let favoritesRouter: IFavoritesRouter
    
    init(interactor: IFavoritesInteractor, router: IFavoritesRouter) {
        self.favoritesInteractor = interactor
        self.favoritesRouter = router
    }
    
    func viewDidLoad(_ view: IFavoritesView) {
        self.view = view
        
        self.view?.tapCellHandler = { [weak self] filmID in
            print("tap to some cell")
            let vc = self?.viewController as? UIViewController
            self?.favoritesRouter.showDetailFilmInfo(vc, filmID)
        }
        
        self.view?.tapDeleteButtonHandler = { [weak self] in
            self?.favoritesInteractor.deleteAllFavFilms()
        }
        
        self.view?.tapDeleteFromFavsButtonHandler = { [weak self] filmID in
            self?.favoritesInteractor.deleteFilm(filmID)
        }
    }
    
    func viewDidAppear() {
        self.favoritesInteractor.getFavoritesFilms()
    }
    
    func didLoadFavoriteFilms(_ films: [FilmCellModel]) {
        self.view?.films = films
        print("PRES: items in films == \(films.count)")
        self.view?.reloadData()
    }
    
    func didDeleteAllFavFilms() {
        self.view?.films = []
        print("PRES: items in films == 0")
        self.view?.reloadData()
    }
    
    func didDeleteFilm(_ filmID: Int) {
        print("PRES: film (id == \(filmID)) successfully deleted")
        self.view?.films.removeAll(where: { film in
            film.id == filmID
        })
        self.view?.reloadData()
    }
}
