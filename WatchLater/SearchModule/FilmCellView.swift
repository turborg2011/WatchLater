
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
    let addFilmToFavoritesButton = UIButton()
    let delFilmFromFavoritesButton = UIButton()
    
    var delegate: FilmCellViewDelegate?
    
    private var isDownloaded: Bool = false
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        setupCellUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func tapAddToFavs(_ sender: UIButton!) {
        delegate?.addToFavsTapped(self)
        
        isDownloaded = true
        changeButtons()
    }
    
    @objc func delFromFavs(_ sender: UIButton!) {
        delegate?.deleteFromFavsTapped(self)
        
        isDownloaded = false
        changeButtons()
    }
}

extension FilmCellView: IFilmCellView {
    func setDataToFilmCellView(_ filmCellModel: IFilmCellModel) {
        filmPoster.image = filmCellModel.cellFilmPoster
        filmName.text = filmCellModel.cellFilmName
        filmRating.text = "⭐️" + (filmCellModel.filmRating ?? "-")
        filmYear.text = "Year " + (filmCellModel.filmYear ?? "-")
        filmGenre.text = "Genre " + (filmCellModel.filmGenre ?? "-")
        
        isDownloaded = filmCellModel.isDownloaded
        changeButtons()
    }
}

private extension FilmCellView {
    
    func changeButtons() {
        addFilmToFavoritesButton.isHidden = isDownloaded
        delFilmFromFavoritesButton.isHidden = !isDownloaded
    }
    
    func setupCellUI() {
        self.addSubview(filmPoster)
        self.addSubview(filmName)
        self.addSubview(addFilmToFavoritesButton)
        self.addSubview(filmYear)
        self.addSubview(filmRating)
        self.addSubview(filmGenre)
        self.addSubview(delFilmFromFavoritesButton)
        
        filmPoster.contentMode = .scaleAspectFit
        filmPoster.clipsToBounds = true
        filmPoster.snp.makeConstraints { make in
            make.top.bottom.leading.equalToSuperview().inset(filmCellUIConfig.filmPosterInsets)
            make.width.equalTo(filmCellUIConfig.filmPosterWidth)
        }
        
        filmName.font = uiFonts.cellFilmNameFont
        filmName.snp.makeConstraints { make in
            make.height.equalTo(filmCellUIConfig.filmNameHeight)
            make.top.equalToSuperview().inset(filmCellUIConfig.filmNameTopInset)
            make.leading.equalTo(filmPoster.snp.trailing).offset(filmCellUIConfig.filmNameLeadingTrailingInset)
            make.trailing.equalToSuperview().inset(filmCellUIConfig.filmNameLeadingTrailingInset)
        }
        
        filmYear.font = uiFonts.cellFilmYearRatingFont
        filmYear.snp.makeConstraints { make in
            make.width.equalTo(filmCellUIConfig.filmYearWidth)
            make.leading.equalTo(filmRating.snp.trailing).offset(filmCellUIConfig.filmYearLeadingOffset)
            make.top.equalTo(filmName.snp.bottom).offset(filmCellUIConfig.filmYearTopOffset)
            make.bottom.equalTo(filmRating)
        }
        
        filmRating.font = uiFonts.cellFilmYearRatingFont
        filmRating.snp.makeConstraints { make in
            make.top.equalTo(filmName.snp.bottom).offset(filmCellUIConfig.filmRatingTopOffset)
            make.trailing.equalTo(filmYear.snp.leading).offset(filmCellUIConfig.filmRatingTrailingOffset)
            make.leading.equalTo(filmPoster.snp.trailing).offset(filmCellUIConfig.filmRatingLeadingOffset)
        }
        
        filmGenre.font = uiFonts.cellFilmYearRatingFont
        filmGenre.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(filmCellUIConfig.filmGenreTrailingInset)
            make.top.equalTo(filmRating.snp.bottom).offset(filmCellUIConfig.filmGenreTopOffset)
            make.leading.equalTo(filmPoster.snp.trailing).offset(filmCellUIConfig.filmGenreLeadingOffset)
        }
        
        changeButtons()
        
        addFilmToFavoritesButton.backgroundColor = .systemBlue
        addFilmToFavoritesButton.setTitle("add to favs", for: .normal)
        addFilmToFavoritesButton.layer.cornerRadius = filmCellUIConfig.addDelButtonCornerRadius
        addFilmToFavoritesButton.addTarget(self, action: #selector(tapAddToFavs(_:)), for: .touchUpInside)
        addFilmToFavoritesButton.snp.makeConstraints { make in
            make.top.equalTo(filmGenre.snp.bottom).offset(filmCellUIConfig.addDelButtonTopBottomOffset)
            make.bottom.equalToSuperview().inset(filmCellUIConfig.addDelButtonTopBottomOffset)
            make.trailing.equalToSuperview().inset(filmCellUIConfig.addDelButtonTrailingInset)
            make.leading.equalTo(filmPoster.snp.trailing).offset(filmCellUIConfig.addDelButtonLeadingOffset)
        }
        
        delFilmFromFavoritesButton.backgroundColor = .systemRed
        delFilmFromFavoritesButton.setTitle("delete from favs", for: .normal)
        delFilmFromFavoritesButton.layer.cornerRadius = filmCellUIConfig.addDelButtonCornerRadius
        delFilmFromFavoritesButton.addTarget(self, action: #selector(delFromFavs(_:)), for: .touchUpInside)
        delFilmFromFavoritesButton.snp.makeConstraints { make in
            make.top.equalTo(filmGenre.snp.bottom).offset(filmCellUIConfig.addDelButtonTopBottomOffset)
            make.bottom.equalToSuperview().inset(filmCellUIConfig.addDelButtonTopBottomOffset)
            make.trailing.equalToSuperview().inset(filmCellUIConfig.addDelButtonTrailingInset)
            make.leading.equalTo(filmPoster.snp.trailing).offset(filmCellUIConfig.addDelButtonLeadingOffset)
        }
    }
}
