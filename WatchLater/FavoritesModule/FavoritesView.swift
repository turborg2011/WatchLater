
import UIKit
import SnapKit

protocol IFavoritesView: AnyObject {
    var tapCellHandler: ((_ filmID: Int) -> Void)? { get set }
    //var tapSearchButtonHandler: ((_ text: String?) -> Void)? { get set }
    var films: [IFilmCellModel] { get set }
    var tapDeleteFromFavsButtonHandler: ((_ filmID: Int) -> Void)? { get set }
    var tapAddToFavsButtonHandler: ((_ filmID: Int) -> Void)? { get set }
    
    func reloadData()
}

final class FavoritesView: UIView {
    
    // этот хендлер сетится из презентера
    var tapCellHandler: ((_ filmID: Int) -> Void)?
    var tapDeleteFromFavsButtonHandler: ((_ filmID: Int) -> Void)?
    var tapAddToFavsButtonHandler: ((_ filmID: Int) -> Void)?
    
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
        print("VIEW: REload data, films = \(films.count)")
    }
}

extension FavoritesView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tapCellHandler?(films[indexPath.row].id)
    }
}

extension FavoritesView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return films.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "\(FilmCellView.self)") as? FilmCellView else {
            return UITableViewCell()
        }

        let filmCellModel = films[indexPath.row]
        cell.setDataToFilmCellView(filmCellModel)
        cell.delegate = self
        cell.selectionStyle = .none
        
        cell.contentView.isUserInteractionEnabled = false

        return cell
    }
}

extension FavoritesView: FilmCellViewDelegate {
    func addToFavsTapped(_ cell: FilmCellView) {
        if let indexPath = tableView.indexPath(for: cell) {
            tapAddToFavsButtonHandler?(films[indexPath.row].id)
        }
    }
    
    func deleteFromFavsTapped(_ cell: FilmCellView) {
        if let indexPath = tableView.indexPath(for: cell) {
            tapDeleteFromFavsButtonHandler?(films[indexPath.row].id)
        }
    }
}

private extension FavoritesView {
    func setupUIFavoritesView() {
        self.backgroundColor = .systemBackground
        
        self.addSubview(tableView)
        
        tableView.snp.makeConstraints { make in
            make.leading.trailing.top.bottom.equalTo(self.safeAreaLayoutGuide)
        }
    }
}
