
import UIKit
import SnapKit

protocol FilmCellViewDelegate: AnyObject {
    func addToFavsTapped(_ cell: FilmCellView)
    func deleteFromFavsTapped(_ cell: FilmCellView)
}

protocol IFilmCellView: AnyObject {
    func setDataToFilmCellView(_ filmCellModel: IFilmCellModel)
}

class FilmCellView: UITableViewCell {
    
    let filmPoster = UIImageView()
    let filmName = UILabel()
    let filmRating = UILabel()
    let filmYear = UILabel()
    let filmGenre = UILabel()
    let addDelFilmToFavoritesButton = UIButton()
    
    var delegate: FilmCellViewDelegate?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        setupCellUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func tapAddToFavs(_ sender: UIButton!) {
        delegate?.addToFavsTapped(self)
    }
    
    @objc func delFromFavs(_ sender: UIButton!) {
        delegate?.deleteFromFavsTapped(self)
    }
}

extension FilmCellView: IFilmCellView {
    func setDataToFilmCellView(_ filmCellModel: IFilmCellModel) {
        filmPoster.image = filmCellModel.cellFilmPoster
        filmName.text = filmCellModel.cellFilmName
        filmRating.text = "⭐️" + (filmCellModel.filmRating ?? "-")
        filmYear.text = "Year " + (filmCellModel.filmYear ?? "-")
        filmGenre.text = "Genre " + (filmCellModel.filmGenre ?? "-")
    }
}

private extension FilmCellView {
    func setupCellUI() {
        self.addSubview(filmPoster)
        self.addSubview(filmName)
        self.addSubview(addDelFilmToFavoritesButton)
        self.addSubview(filmYear)
        self.addSubview(filmRating)
        self.addSubview(filmGenre)
        
        filmPoster.contentMode = .scaleAspectFit
        filmPoster.clipsToBounds = true
        filmPoster.snp.makeConstraints { make in
            make.top.bottom.leading.equalToSuperview().inset(10)
            make.width.equalTo(100)
        }
        
        guard let customFont = UIFont(name: "GeezaPro-Bold", size: 20) else {
            fatalError("""
                Failed to load the "CustomFont-Light" font.
                Make sure the font file is included in the project and the font name is spelled correctly.
                """
            )
        }
        
        guard let miniFont = UIFont(name: "GeezaPro", size: 15) else {
            fatalError("""
                Failed to load the "CustomFont-Light" font.
                Make sure the font file is included in the project and the font name is spelled correctly.
                """
            )
        }
        
        filmName.font = customFont
        //filmName.backgroundColor = .systemGray
        filmName.snp.makeConstraints { make in
            make.height.equalTo(30)
            make.top.equalToSuperview().inset(10)
            make.leading.equalTo(filmPoster.snp.trailing).offset(20)
            make.trailing.equalToSuperview().inset(20)
        }
        
        filmYear.font = miniFont
        //filmYear.backgroundColor = .systemGray
        filmYear.snp.makeConstraints { make in
            make.width.equalTo(130)
            make.leading.equalTo(filmRating.snp.trailing).offset(10)
            make.top.equalTo(filmName.snp.bottom).offset(7)
            make.bottom.equalTo(filmRating)
        }
        
        filmRating.font = miniFont
        //filmRating.backgroundColor = .systemGray
        filmRating.snp.makeConstraints { make in
            make.top.equalTo(filmName.snp.bottom).offset(7)
            make.trailing.equalTo(filmYear.snp.leading).offset(-10)
            make.leading.equalTo(filmPoster.snp.trailing).offset(20)
        }
        
        filmGenre.font = miniFont
        //filmGenre.backgroundColor = .systemGray
        filmGenre.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(20)
            make.top.equalTo(filmRating.snp.bottom).offset(7)
            make.leading.equalTo(filmPoster.snp.trailing).offset(20)
        }
        
        addDelFilmToFavoritesButton.backgroundColor = .systemBlue
        addDelFilmToFavoritesButton.setTitle("add to favs", for: .normal)
        addDelFilmToFavoritesButton.layer.cornerRadius = 15
        addDelFilmToFavoritesButton.addTarget(self, action: #selector(tapAddToFavs(_:)), for: .touchUpInside)
        addDelFilmToFavoritesButton.snp.makeConstraints { make in
            make.top.equalTo(filmGenre.snp.bottom).offset(10)
            make.bottom.equalToSuperview().inset(10)
            make.trailing.equalToSuperview().inset(20)
            make.leading.equalTo(filmPoster.snp.trailing).offset(20)
        }
    }
}
