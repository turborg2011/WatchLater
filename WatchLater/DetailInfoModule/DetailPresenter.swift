
import UIKit

protocol IDetailPresenter: AnyObject {
    func viewDidLoad(_ view: IDetailView)
    func didLoadFilmFromCoreData(_ film: FilmDetailInfoModel)
    func didUpdateCommentary()
    func didAddFilm(_ filmID: Int)
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
            self.filmID = film.id
            print("PRES: isD")
            self.view?.setData(film)
        } else {
            print("PRES: no film and filmID")
        }
        
        self.view?.commentaryUpdateHandler = { [weak self] text in
            if text != "", let id = self?.filmID {
                self?.detailInteractor.filmUpdateCommentary(id, commentary: text)
            }
        }
        
        self.view?.commentarySaveFilmHandler = { [weak self] text in
            if text != "", let id = self?.filmID {
                self?.detailInteractor.saveFilmAndCommentary(id, commentary: text)
            }
        }
    }
    
    func didLoadFilmFromCoreData(_ film: FilmDetailInfoModel) {
        self.view?.setData(film)
    }
    
    func didUpdateCommentary() {
        print("PRES: okkkk")
    }
    
    func didAddFilm(_ filmID: Int) {
        print("PRES: film with id == \(filmID) - saved")
    }
}
