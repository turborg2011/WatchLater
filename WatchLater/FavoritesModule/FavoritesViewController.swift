
import UIKit

protocol IFavoritesViewController: AnyObject {
    
}

final class FavoritesViewController: UIViewController {
    
    private let favoritesView = FavoritesView()
    private let favoritesPresenter: IFavoritesPresenter
    
    init(presenter: IFavoritesPresenter) {
        self.favoritesPresenter = presenter
        super.init(nibName:nil, bundle:nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = self.favoritesView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.favoritesPresenter.viewDidLoad(favoritesView)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.favoritesPresenter.viewDidAppear()
    }
}

extension FavoritesViewController: IFavoritesViewController {}
