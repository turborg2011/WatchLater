
import UIKit

protocol IFavoritesPresenter: AnyObject {
    func viewDidLoad(_ view: IFavoritesView)
    func didLoadFavoriteFilms(_ films: [FilmCellModel])
    func viewDidAppear()
    func didDeleteAllFavFilms()
    func didDeleteFilm(_ filmID: Int)
    func didAddFilm(_ filmID: Int)
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
            let vc = self?.viewController as? UIViewController
            self?.favoritesRouter.showDetailFilmInfo(vc, filmID)
        }
        
        self.view?.tapAddToFavsButtonHandler = { [weak self] filmID in
            self?.favoritesInteractor.saveFilm(filmID)
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
        self.view?.reloadData()
    }
    
    func didDeleteAllFavFilms() {
        self.view?.films = []
        self.view?.reloadData()
    }
    
    func didDeleteFilm(_ filmID: Int) {
        self.view?.films.removeAll(where: { film in
            film.id == filmID
        })
        self.view?.reloadData()
    }
    
    func didAddFilm(_ filmID: Int) {
    }
}
