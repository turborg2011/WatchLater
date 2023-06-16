
import UIKit

protocol IFavoritesRouter: AnyObject {
    func showDetailFilmInfo(_ viewController: UIViewController?, _ filmID: Int)
}

final class FavoritesRouter: IFavoritesRouter {
    func showDetailFilmInfo(_ viewController: UIViewController?, _ filmID: Int) {
        let infoViewController = DetailModuleBuilder.buildDefault(filmID)
        if let vc = viewController {
            vc.navigationController?.pushViewController(infoViewController, animated: true)
        }
    }
}
