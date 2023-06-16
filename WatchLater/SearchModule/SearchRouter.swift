import UIKit

protocol ISearchRouter: AnyObject {
    func openModalDetailView(_ viewController: UIViewController?, _ film: FilmDetailInfoModel)
}

final class SearchRouter { }

extension SearchRouter: ISearchRouter {
    func openModalDetailView(_ viewController: UIViewController?, _ film: FilmDetailInfoModel) {
        // открытие окна с детальной инфой
        let infoViewController = DetailModuleBuilder.buildFromModel(film)
        if let vc = viewController {
            vc.navigationController?.pushViewController(infoViewController, animated: true)
        }
    }
}
