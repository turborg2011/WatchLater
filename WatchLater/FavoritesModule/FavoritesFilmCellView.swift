
import UIKit
import SnapKit

protocol FavoritesFilmCellViewDelegate: AnyObject {
    func deleteFromFavsTapped(_ cell: FavoritesFilmCellView)
}

protocol IFavoritesFilmCellView: AnyObject {
    func setDataToFilmCellView(_ filmCellModel: IFilmCellModel)
}

class FavoritesFilmCellView: UITableViewCell {
    
    let filmPoster = UIImageView()
    let filmName = UILabel()
    let deleteFromFavsButton = UIButton()
    
    var delegate: FavoritesFilmCellViewDelegate?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        setupCellUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension FavoritesFilmCellView: IFavoritesFilmCellView {
    func setDataToFilmCellView(_ filmCellModel: IFilmCellModel) {
        filmPoster.image = filmCellModel.cellFilmPoster
        filmName.text = filmCellModel.cellFilmName
    }
    
    @objc func delFromFavs(_ sender: UIButton!) {
        delegate?.deleteFromFavsTapped(self)
    }
}

private extension FavoritesFilmCellView {
    private func setupCellUI() {
        self.addSubview(filmPoster)
        self.addSubview(filmName)
        self.addSubview(deleteFromFavsButton)
        
        filmPoster.contentMode = .scaleAspectFit
        filmPoster.backgroundColor = .systemBackground
        filmPoster.clipsToBounds = true
        filmPoster.snp.makeConstraints { make in
            make.top.bottom.leading.equalToSuperview().inset(10)
            make.width.equalTo(100)
        }

        filmName.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(filmPoster.snp.trailing).offset(20)
            make.trailing.equalToSuperview().inset(20)
        }
        
        deleteFromFavsButton.backgroundColor = .systemBlue
        deleteFromFavsButton.setTitle("del from favs", for: .normal)
        deleteFromFavsButton.layer.cornerRadius = 5
        deleteFromFavsButton.addTarget(self, action: #selector(delFromFavs(_:)), for: .touchUpInside)
        deleteFromFavsButton.snp.makeConstraints { make in
            make.width.equalTo(100)
            make.top.equalTo(filmName.snp.bottom).offset(10)
            make.bottom.equalToSuperview().inset(20)
            make.trailing.equalToSuperview().inset(20)
        }
    }
}

