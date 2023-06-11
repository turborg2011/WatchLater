
import UIKit
import SnapKit

protocol ISearchView: AnyObject {
    var tapCellHandler: (() -> Void)? { get set }
    var tapSearchButtonHandler: ((_ text: String?) -> Void)? { get set }
    var films: [IFilmCellModel] { get set }
    
    func reloadData()
    func reloadFilmPosterByID(filmID: Int, image: UIImage)
}

final class SearchView: UIView {
    
    // этот хендлер сетится из презентера
    var tapCellHandler: (() -> Void)?
    var tapSearchButtonHandler: ((_ text: String?) -> Void)?
    
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
    
    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.delegate = self
        
        searchBar.autocorrectionType = .no
        searchBar.spellCheckingType = .no
        searchBar.searchBarStyle = UISearchBar.Style.default
        searchBar.placeholder = "Введите название фильма"
        
        return searchBar
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        self.setupUISearchView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension SearchView: ISearchView {
    func reloadData() {
        self.tableView.reloadData()
        print(" ----- RELOAD DATA ----- \(films.count)")
    }
    
    func reloadFilmPosterByID(filmID: Int, image: UIImage) {
        for index in films.indices {
            if films[index].id == filmID {
                films[index].cellFilmPoster = image
            }
        }
        tableView.reloadData()
    }
}

extension SearchView: UITableViewDelegate { }

extension SearchView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return films.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "\(FilmCellView.self)") as? FilmCellView else {
            return UITableViewCell()
        }

        let filmCellModel = films[indexPath.row]
        cell.setDataToFilmCellView(filmCellModel)
        
        print("RELOAD DATA")
        
        return cell
    }
}

extension SearchView: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) { }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        tapSearchButtonHandler?(searchBar.text)
    }
}

private extension SearchView {
    
    func setupUISearchView() {
        self.backgroundColor = .systemBackground
        
        self.addSubview(tableView)
        self.addSubview(searchBar)
        
        searchBar.snp.makeConstraints { make in
            make.leading.trailing.top.equalTo(self.safeAreaLayoutGuide)
        }
        
        tableView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalTo(self.safeAreaLayoutGuide)
            make.top.equalTo(searchBar.snp.bottom)
        }
    }
}
