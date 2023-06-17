
import UIKit
import SnapKit

protocol IDetailView: AnyObject {
    var commentaryUpdateHandler: ((_ text: String) -> Void)? { get set }
    var commentarySaveFilmHandler: ((_ text: String) -> Void)? { get set }
    
    func setData(_ film: FilmDetailInfoModel)
}

final class DetailView: UIView {
    
    var commentaryUpdateHandler: ((_ text: String) -> Void)?
    var commentarySaveFilmHandler: ((_ text: String) -> Void)?
    
    private let filmPoster = UIImageView()
    private let filmNameLabel = UILabel()
    private let filmDescription = UITextView()
    private let filmRating = UILabel()
    private let filmYear = UILabel()
    private let filmGenres = UILabel()
    private let filmCountries = UILabel()
    private let filmType = UILabel()
    private let commentary = UITextField()
    private lazy var deleteButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemBlue
        button.setTitle("delete", for: .normal)
        
        return button
    }()
    
    private var isDownloaded: Bool = false
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        self.setupUIDetailView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension DetailView: IDetailView {
    func setData(_ film: FilmDetailInfoModel) {
        var config = UIImage.SymbolConfiguration(paletteColors: [.systemGray5])
        config = config.applying(UIImage.SymbolConfiguration(scale: .small))
        let imagePlaceHolder = UIImage(systemName: "photo", withConfiguration: config)
        
        filmPoster.image = film.poster ?? imagePlaceHolder
        filmNameLabel.text = film.name ?? "-"
        filmDescription.text = film.description ?? "No description"
        filmRating.text = "rating kp: ⭐️" + String(film.rating ?? 0)
        filmYear.text = "year: " + String(film.year ?? 0)
        filmGenres.text = "genre: " + (film.genres ?? "-")
        filmCountries.text = "country: " + (film.countries ?? "-")
        filmType.text = "type: " + (film.type ?? "-")
        commentary.text = film.commentary ?? ""
        isDownloaded = film.isDownloaded
    }
}

extension DetailView: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let text = textField.text {
            if isDownloaded {
                commentaryUpdateHandler?(text)
            } else {
                commentarySaveFilmHandler?(text)
            }
        }
    }
}

private extension DetailView {
    func setupUIDetailView() {
        self.backgroundColor = .systemBackground
        
        let mainView = UIView()
        
        self.addSubview(mainView)
        
        mainView.addSubview(filmNameLabel)
        
        // Film name label
        filmNameLabel.font = uiFonts.filmNameLabelFont
        filmNameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(detailViewUIConfig.insetsFromMain)
        }
        
        // Poster and details
        let posterAndDetailView = UIView()
        
        let detailStackView: UIStackView = {
            let stackView = UIStackView(arrangedSubviews: [filmRating,
                                                           filmType,
                                                          filmYear,
                                                          filmCountries,
                                                          filmGenres])
            stackView.axis = .vertical
            stackView.spacing = detailViewUIConfig.detailStackViewSpacing
            stackView.distribution = .fillEqually
            
            return stackView
        }()
        
        mainView.addSubview(posterAndDetailView)
        
        posterAndDetailView.addSubview(filmPoster)
        posterAndDetailView.addSubview(detailStackView)
        
        filmPoster.contentMode = .scaleAspectFit
        filmPoster.snp.makeConstraints { make in
            make.top.bottom.leading.equalToSuperview()
            make.width.equalTo(detailViewUIConfig.filmPosterWidth)
        }
        
        posterAndDetailView.snp.makeConstraints { make in
            make.height.equalTo(detailViewUIConfig.posterAndDetailViewHeight)
            make.leading.trailing.equalToSuperview().inset(detailViewUIConfig.posterAndDetailViewInsets)
            make.top.equalTo(filmNameLabel.snp.bottom).offset(detailViewUIConfig.posterAndDetailViewInsets)
        }
        
        detailStackView.snp.makeConstraints { make in
            make.top.bottom.trailing.equalToSuperview()
            make.leading.equalTo(filmPoster.snp.trailing).offset(detailViewUIConfig.posterAndDetailViewInsets)
            make.height.equalTo(detailViewUIConfig.posterAndDetailViewHeight)
        }
        
        // Description
        let descBackground = UIView()
        let descriptionLabel = UILabel()
        
        mainView.addSubview(descBackground)
        
        descBackground.backgroundColor = .clear
        descBackground.addSubview(descriptionLabel)
        descriptionLabel.text = "Description"
        descriptionLabel.font = uiFonts.descriptionLabelFont
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(detailViewUIConfig.descLabelInsets)
            make.leading.equalToSuperview().inset(detailViewUIConfig.descLabelInsets)
            make.height.equalTo(detailViewUIConfig.descriptionLabelHeight)
        }
        
        descBackground.addSubview(filmDescription)
        
        filmDescription.backgroundColor = .clear
        filmDescription.isEditable = false
        filmDescription.font = uiFonts.filmDescriptionFont
        filmDescription.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview().inset(detailViewUIConfig.filmDescriptionInsets)
            make.top.equalTo(descriptionLabel.snp.bottom)
        }
        
        descBackground.snp.makeConstraints { make in
            make.height.equalTo(detailViewUIConfig.descBackgroundHeight)
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(posterAndDetailView.snp.bottom).offset(detailViewUIConfig.descBackgroundTopOffset)
        }
        
        // Commentary
        let commBackground = UIView()
        let commLabel = UILabel()
        
        mainView.addSubview(commBackground)
        
        commBackground.backgroundColor = .systemBackground
        commBackground.addSubview(commLabel)
        commLabel.text = "Commentary"
        commLabel.font = uiFonts.commLabelFont
        commLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(detailViewUIConfig.commLabelTopInset)
            make.leading.equalToSuperview().inset(detailViewUIConfig.commLabelLeadingInset)
            make.height.equalTo(detailViewUIConfig.commLabelHeight)
        }
        
        commBackground.addSubview(commentary)

        commentary.placeholder = "Write your comment here"
        commentary.contentVerticalAlignment = UIControl.ContentVerticalAlignment.top
        commentary.delegate = self
        commentary.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview().inset(detailViewUIConfig.commentaryInsets)
            make.top.equalTo(commLabel.snp.bottom)
        }
        
        commBackground.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(descBackground.snp.bottom)
        }
        
        mainView.snp.makeConstraints { make in
            make.edges.equalTo(self.safeAreaLayoutGuide).inset(detailViewUIConfig.mainInsets)
        }
    }
}
