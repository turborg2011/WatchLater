
import UIKit

final class DetailModuleBuilder {
    public static func buildDefault(_ filmID: Int) -> UIViewController {
        
        let interactor = DetailInteractor()
        let router = DetailRouter()
        let presenter = DetailPresenter(interactor: interactor, router: router, filmID: filmID, filmModel: nil)
        interactor.presenter = presenter
        let viewController = DetailViewController(presenter: presenter)
        
        return viewController
    }
    
    public static func buildFromModel(_ filmModel: FilmDetailInfoModel) -> UIViewController {
        
        let interactor = DetailInteractor()
        let router = DetailRouter()
        let presenter = DetailPresenter(interactor: interactor, router: router, filmID: nil, filmModel: filmModel)
        interactor.presenter = presenter
        let viewController = DetailViewController(presenter: presenter)
        
        return viewController
    }
}
 
