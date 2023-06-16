import Foundation
// uikit только чтобы поддерживать работу с его классами
import UIKit

protocol ISearchPresenter: AnyObject {
    func viewDidLoad(_ view: ISearchView)
    func didLoadFilmsSearch(filmsListSearch: [FilmCellModel])
    func didLoadFilmPoster(filmID: Int?, image: UIImage?)
    func didLoadFilmByID(film: FilmDetailInfoModel)
    func didAddFilm(_ filmID: Int)
    func didDeleteFilm(_ filmID: Int)
    func didLoadFilmFromCoreData(_ filmData: FilmDetailInfoModel)
    func viewDidAppear(_ text: String)
}

final class SearchPresenter {
    
    weak var view: ISearchView?
    weak var viewController: ISearchViewController?
    private let searchInteractor: ISearchInteractor
    private let searchRouter: ISearchRouter
    
    init(interactor: ISearchInteractor, router: ISearchRouter) {
        self.searchInteractor = interactor
        self.searchRouter = router
    }
}

extension SearchPresenter: ISearchPresenter {
    func viewDidLoad(_ view: ISearchView) {
        self.view = view
        
        // реализовать нажатие на кнопку поиска
        self.view?.tapSearchButtonHandler = { [weak self] text in
            guard let filmName = text else {
                return
            }
            
            self?.showSearchResults(filmName: filmName)
        }
        
        self.view?.tapAddToFavsHandler = { filmID in
            self.searchInteractor.saveFilm(filmID)
        }
        
        self.view?.tapCellHandler = { [weak self] filmID in
            self?.showDetailFilmInfo(filmID)
        }
        
        self.view?.tapDelFromFavsHandler = { [weak self] filmID in
            self?.searchInteractor.deleteFilm(filmID)
        }
        
    }
    
    func viewDidAppear(_ text: String) {
        self.showSearchResults(filmName: text)
    }
    
    func showSearchResults(filmName: String) {
        searchInteractor.getFilmSearchResultsByName(filmName)
    }
    
    func didLoadFilmsSearch(filmsListSearch: [FilmCellModel]) {
        self.view?.films = filmsListSearch
        self.view?.reloadData()
    }
    
    func didLoadFilmPoster(filmID: Int?, image: UIImage?) {
        if let id = filmID, let img = image {
            self.view?.reloadFilmPosterByID(filmID: id, image: img)
        }
    }
    
    func showDetailFilmInfo(_ filmID: Int) {
        searchInteractor.getFilmById(filmID)
    }
    
    func didLoadFilmByID(film: FilmDetailInfoModel) {
        // show detail modal info
        let vc = self.viewController as? UIViewController
        self.searchRouter.openModalDetailView(vc, film)
    }
    
    func didAddFilm(_ filmID: Int) {
    }
    
    func didDeleteFilm(_ filmID: Int) {
    }
    
    func didLoadFilmFromCoreData(_ filmData: FilmDetailInfoModel) {
        print("PRES: film loaded from core data")
        let vc = self.viewController as? UIViewController
        self.searchRouter.openModalDetailView(vc, filmData)
    }
}
