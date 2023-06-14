
import UIKit

protocol IFavoritesPresenter: AnyObject {
    func viewDidLoad(_ view: IFavoritesView)
    func didLoadFavoriteFilms(_ films: [FilmCellModel])
    
}

final class FavoritesPresenter: IFavoritesPresenter {
    
    weak var view: IFavoritesView?
    private let favoritesInteractor: IFavoritesInteractor
    private let favoritesRouter: IFavoritesRouter
    
    init(interactor: IFavoritesInteractor, router: IFavoritesRouter) {
        self.favoritesInteractor = interactor
        self.favoritesRouter = router
    }
    
    func viewDidLoad(_ view: IFavoritesView) {
        self.view = view
        
        self.view?.tapCellHandler = {
            print("tap to some cell")
        }
    }
    
    func didLoadFavoriteFilms(_ films: [FilmCellModel]) {
        
    }
}
