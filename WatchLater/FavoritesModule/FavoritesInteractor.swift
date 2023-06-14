
import UIKit

protocol IFavoritesInteractor: AnyObject {
    func getAllFilms()
}

final class FavoritesInteractor {
    
    weak var presenter: IFavoritesPresenter?
    // var data manager
    
}

extension FavoritesInteractor: IFavoritesInteractor {
    func getAllFilms() {
        //
    }
}

