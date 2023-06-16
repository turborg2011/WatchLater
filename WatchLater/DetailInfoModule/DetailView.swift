
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
        let imagePlaceHolder = UIImage(systemName: "photo.fill", withConfiguration: config)
        
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
        mainView.addSubview(deleteButton)
        
        // film name label
        filmNameLabel.font = UIFont(name: "GeezaPro-bold", size: 18)
        filmNameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(10)
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
            stackView.spacing = 10
            stackView.distribution = .fillEqually
            
            return stackView
        }()
        
        mainView.addSubview(posterAndDetailView)
        
        posterAndDetailView.addSubview(filmPoster)
        posterAndDetailView.addSubview(detailStackView)
        
        filmPoster.contentMode = .scaleAspectFit
        filmPoster.snp.makeConstraints { make in
            make.top.bottom.leading.equalToSuperview()
            make.width.equalTo(100)
        }
        
        posterAndDetailView.snp.makeConstraints { make in
            make.height.equalTo(150)
            make.leading.trailing.equalToSuperview().inset(10)
            make.top.equalTo(filmNameLabel.snp.bottom).offset(10)
        }
        
        detailStackView.snp.makeConstraints { make in
            make.top.bottom.trailing.equalToSuperview()
            make.leading.equalTo(filmPoster.snp.trailing).offset(10)
            make.height.equalTo(150)
        }
        
        // Description
        let descBackground = UIView()
        let descriptionLabel = UILabel()
        
        mainView.addSubview(descBackground)
        
        descBackground.backgroundColor = .clear
        descBackground.layer.cornerRadius = 10
        descBackground.addSubview(descriptionLabel)
        //descriptionLabel.backgroundColor = .systemRed
        descriptionLabel.text = "Description"
        descriptionLabel.font = UIFont(name: "GeezaPro-bold", size: 16)
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(10)
            make.leading.equalToSuperview().inset(10)
            make.height.equalTo(20)
        }
        
        descBackground.addSubview(filmDescription)
        
        filmDescription.backgroundColor = .clear
        filmDescription.isEditable = false
        filmDescription.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview().inset(5)
            make.top.equalTo(descriptionLabel.snp.bottom)
        }
        
        descBackground.snp.makeConstraints { make in
            make.height.equalTo(170)
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(posterAndDetailView.snp.bottom).offset(10)
        }
        
        // Commentary
        let commBackground = UIView()
        let commLabel = UILabel()
        
        mainView.addSubview(commBackground)
        
        commBackground.backgroundColor = .systemBackground
        commBackground.layer.cornerRadius = 10
        commBackground.addSubview(commLabel)
        //commLabel.backgroundColor = .systemRed
        commLabel.text = "Commentary"
        commLabel.font = UIFont(name: "GeezaPro-bold", size: 16)
        commLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(5)
            make.leading.equalToSuperview().inset(10)
            make.height.equalTo(20)
        }
        
        commBackground.addSubview(commentary)
        
        //commentary.backgroundColor = .systemBlue
        commentary.placeholder = "Write your comment here"
        commentary.contentVerticalAlignment = UIControl.ContentVerticalAlignment.top
        commentary.delegate = self
        commentary.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview().inset(10)
            make.top.equalTo(commLabel.snp.bottom)
        }
        
        commBackground.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(descBackground.snp.bottom)
        }
        
        
        // Delete button
        deleteButton.layer.cornerRadius = 14
        deleteButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(commBackground.snp.bottom).offset(10)
        }
        
//        filmYear.backgroundColor = .systemGray
//        filmType.backgroundColor = .systemGray
//        filmRating.backgroundColor = .systemGray
//        filmCountries.backgroundColor = .systemGray
//        filmDescription.backgroundColor = .systemGray
//        filmNameLabel.backgroundColor = .systemGray
//        filmPoster.backgroundColor = .systemGray
//        filmGenres.backgroundColor = .systemGray
//        commentary.backgroundColor = .systemGray
        
//        guard let miniFont = UIFont(name: "GeezaPro", size: 18) else {
//            fatalError("""
//                Failed to load the "CustomFont-Light" font.
//                Make sure the font file is included in the project and the font name is spelled correctly.
//                """
//            )
//        }
        
        //filmRating.font = miniFont
        
        mainView.snp.makeConstraints { make in
            make.edges.equalTo(self.safeAreaLayoutGuide).inset(10)
        }
    }
}
