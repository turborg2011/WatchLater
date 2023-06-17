
import UIKit

final class FavoritesModuleBuilder {
    public static func buildFavoritesModule() -> UIViewController {
        
        // зависимости для favorites модуля
        let interactor = FavoritesInteractor()
        let router = FavoritesRouter()
        let presenter = FavoritesPresenter(interactor: interactor, router: router)
        interactor.presenter = presenter
        let viewController = FavoritesViewController(presenter: presenter)
        presenter.viewController = viewController
        
        return viewController
    }
}
