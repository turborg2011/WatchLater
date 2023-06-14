
import UIKit
import SnapKit

protocol IFavoritesFilmCellView: AnyObject {
    func setDataToFilmCellView(_ filmCellModel: IFilmCellModel)
}

class FavoritesFilmCellView: UITableViewCell {
    
    let filmPoster = UIImageView()
    let filmName = UILabel()
    
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
}

private extension FavoritesFilmCellView {
    private func setupCellUI() {
        self.addSubview(filmPoster)
        self.addSubview(filmName)
        
        filmPoster.contentMode = .scaleAspectFit
        filmPoster.clipsToBounds = true
        filmPoster.snp.makeConstraints { make in
            make.top.bottom.leading.equalToSuperview().inset(10)
            make.width.equalTo(100)
        }
        
        filmName.text = "FILM"
        filmName.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(filmPoster.snp.trailing).offset(20)
            make.trailing.equalToSuperview().inset(20)
        }
    }
}

