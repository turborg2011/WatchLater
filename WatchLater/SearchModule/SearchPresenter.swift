import Foundation
// uikit только чтобы поддерживать работу с его классами
import UIKit

protocol ISearchPresenter: AnyObject {
    func viewDidLoad(_ view: ISearchView)
    func didLoadFilmsSearch(filmsListSearch: [FilmCellModel])
    func didLoadFilmPoster(filmID: Int?, image: UIImage?)
}

final class SearchPresenter {
    
    weak var view: ISearchView?
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
        
        
        // взять модель из интерактора - возможно из локальной памяти
        
        // задать обработчик нажатия на ячейку (вызввать его в table delegate)
        
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
}
