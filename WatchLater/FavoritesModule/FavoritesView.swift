
import UIKit
import SnapKit

protocol IFavoritesView: AnyObject {
    var tapCellHandler: ((_ filmID: Int) -> Void)? { get set }
    //var tapSearchButtonHandler: ((_ text: String?) -> Void)? { get set }
    var films: [IFilmCellModel] { get set }
    var tapDeleteButtonHandler: (() -> Void)? { get set }
    var tapDeleteFromFavsButtonHandler: ((_ filmID: Int) -> Void)? { get set }
    
    func reloadData()
}

final class FavoritesView: UIView {
    
    // этот хендлер сетится из презентера
    var tapCellHandler: ((_ filmID: Int) -> Void)?
    var tapDeleteButtonHandler: (() -> Void)?
    var tapDeleteFromFavsButtonHandler: ((_ filmID: Int) -> Void)?
    
    // в этот массив я просечиваю презентером данные для таблицы
    var films: [IFilmCellModel] = []
    
    private lazy var tableView: UITableView = {
        let table = UITableView()
        table.register(FavoritesFilmCellView.self, forCellReuseIdentifier: "\(FavoritesFilmCellView.self)")
        table.rowHeight = 141.42
        table.dataSource = self
        table.delegate = self
        
        return table
    }()
    
    private lazy var deleteButton: UIButton = {
       let button = UIButton()
        button.setTitle("Удалить все", for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 5
        button.addTarget(self, action: #selector(tapDeleteButton(_:)), for: .touchUpInside)
        
        return button
    }()
    
    @objc func tapDeleteButton(_ sender: UIButton!) {
        tapDeleteButtonHandler?()
    }
    
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
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "\(FavoritesFilmCellView.self)") as? FavoritesFilmCellView else {
            return UITableViewCell()
        }

        let filmCellModel = films[indexPath.row]
        cell.setDataToFilmCellView(filmCellModel)
        cell.delegate = self
        
        cell.contentView.isUserInteractionEnabled = false

        return cell
    }
}

extension FavoritesView: FavoritesFilmCellViewDelegate {
    func deleteFromFavsTapped(_ cell: FavoritesFilmCellView) {
        if let indexPath = tableView.indexPath(for: cell) {
            tapDeleteFromFavsButtonHandler?(films[indexPath.row].id)
        }
    }
}

private extension FavoritesView {
    func setupUIFavoritesView() {
        self.backgroundColor = .systemBackground
        
        self.addSubview(tableView)
        self.addSubview(deleteButton)
        
        deleteButton.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalTo(self.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(70)
        }
        
        tableView.snp.makeConstraints { make in
            make.leading.trailing.top.equalTo(self.safeAreaLayoutGuide)
            make.bottom.equalTo(deleteButton.snp.top).offset(-10)
        }
    }
}
