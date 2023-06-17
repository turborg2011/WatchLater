
import UIKit

protocol ISearchViewController: AnyObject {
    
}

final class SearchViewController: UIViewController {
    
    private let searchView = SearchView()
    private let searchPresenter: ISearchPresenter
    
    init(presenter: ISearchPresenter) {
        self.searchPresenter = presenter
        super.init(nibName:nil, bundle:nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = self.searchView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.searchPresenter.viewDidLoad(searchView)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let text = self.searchView.searchBarText
        self.searchPresenter.viewDidAppear(text)
    }
}

extension SearchViewController: ISearchViewController {}
