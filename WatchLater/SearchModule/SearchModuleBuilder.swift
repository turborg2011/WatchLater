
import UIKit

final class SearchModuleBuilder {
    static func buildSearchModule() -> SearchViewController {
        let interactor = SearchInteractor()
        let router = SearchRouter()
        let presenter = SearchPresenter(interactor: interactor, router: router)
        interactor.presenter = presenter
        let viewController = SearchViewController(presenter: presenter)
        presenter.viewController = viewController
        
        return viewController
    }
}
