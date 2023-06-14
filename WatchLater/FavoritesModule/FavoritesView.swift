
import UIKit
import SnapKit

protocol IFavoritesView: AnyObject {
    var tapCellHandler: (() -> Void)? { get set }
    //var tapSearchButtonHandler: ((_ text: String?) -> Void)? { get set }
    var films: [IFilmCellModel] { get set }
    
    func reloadData()
}

final class FavoritesView: UIView {
    // этот хендлер сетится из презентера
    var tapCellHandler: (() -> Void)?
    //var tapSearchButtonHandler: ((_ text: String?) -> Void)?
    
    // в этот массив я просечиваю презентером данные для таблицы
    var films: [IFilmCellModel] = []
    
    private lazy var tableView: UITableView = {
        let table = UITableView()
        table.register(FilmCellView.self, forCellReuseIdentifier: "\(FilmCellView.self)")
        table.rowHeight = 141.42
        table.dataSource = self
        table.delegate = self
        
        return table
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        self.setupUIFavoritesView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension FavoritesView: IFavoritesView {
    func reloadData() {
        self.tableView.reloadData()
    }
}

extension FavoritesView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tapCellHandler?()
    }
}

extension FavoritesView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return films.count
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        guard let cell = tableView.dequeueReusableCell(withIdentifier: "\(FilmCellView.self)") as? FavoritesFilmCellView else {
//            return UITableViewCell()
//        }
//
//        let filmCellModel = films[indexPath.row]
//        cell.setDataToFilmCellView(filmCellModel)
//
//        return cell
        return UITableViewCell()
    }
}

private extension FavoritesView {
    func setupUIFavoritesView() {
        self.backgroundColor = .systemBackground
        
        self.addSubview(tableView)
        
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(self.safeAreaLayoutGuide)
        }
    }
}
