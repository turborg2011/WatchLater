
import UIKit

protocol IDetailViewController: AnyObject {
    
}

final class DetailViewController: UIViewController {
    private let detailView = DetailView()
    private let detailPresenter: IDetailPresenter
    
    init(presenter: IDetailPresenter) {
        self.detailPresenter = presenter
        super.init(nibName:nil, bundle:nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = self.detailView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.detailPresenter.viewDidLoad(detailView)
        self.title = self.detailView.filmNameLabel.text
    }
}

extension DetailViewController: IDetailViewController { }
