
import UIKit

protocol IDetailPresenter: AnyObject {
    func viewDidLoad(_ view: IDetailView)
    func didLoadFilmFromCoreData(_ film: FilmDetailInfoModel)
}

final class DetailPresenter: IDetailPresenter {
    
    weak var view: IDetailView?
    private let detailInteractor: IDetailInteractor
    private let detailRouter: IDetailRouter
    private var filmID: Int?
    private var filmModel: FilmDetailInfoModel?
    
    init(interactor: IDetailInteractor, router: IDetailRouter, filmID: Int?, filmModel: FilmDetailInfoModel?) {
        self.detailInteractor = interactor
        self.detailRouter = router
        self.filmID = filmID
        self.filmModel = filmModel
    }
    
    func viewDidLoad(_ view: IDetailView) {
        self.view = view
        if let id = filmID {
            self.detailInteractor.getFilmByID(id)
        } else if let film = filmModel {
            self.view?.setData(film)
        } else {
            print("PRES: no film and filmID")
        }
    }
    
    func didLoadFilmFromCoreData(_ film: FilmDetailInfoModel) {
        self.view?.setData(film)
    }
}
