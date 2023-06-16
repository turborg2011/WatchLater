
import UIKit
import SnapKit

protocol IDetailView: AnyObject {
    func setData(_ film: FilmDetailInfoModel)
}

final class DetailView: UIView {
    
    private let filmPoster = UIImageView()
    let filmNameLabel = UILabel()
    private let filmDescription = UITextView()
    private let filmRating = UILabel()
    private let filmYear = UILabel()
    private let filmGenres = UILabel()
    private let filmCountries = UILabel()
    private let filmType = UILabel()
    private let commentary = UITextView()
    private lazy var deleteButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemRed
        button.setTitle("удалить из избранных", for: .normal)
        
        return button
    }()
    
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
        filmPoster.image = film.poster ?? UIImage(systemName: "photo")
        filmNameLabel.text = film.name ?? "-"
        filmDescription.text = "desc: " + (film.description ?? "-")
        filmRating.text = "rating: " + String(film.rating ?? 0)
        filmYear.text = "year: " + String(film.year ?? 0)
        filmGenres.text = "genre: " + (film.genres ?? "-")
        filmCountries.text = "country: " + (film.countries ?? "-")
        filmType.text = "type: " + (film.type ?? "-")
        commentary.text = "commentary: "
    }
}

private extension DetailView {
    func setupUIDetailView() {
        self.backgroundColor = .systemBackground
        
        let posterAndDetailView = UIView()
        lazy var detailStackView: UIStackView = {
            let stackView = UIStackView(arrangedSubviews: [filmRating,
                                                           filmType,
                                                          filmYear,
                                                          filmCountries])
            stackView.axis = .vertical
            stackView.spacing = 10
            stackView.distribution = .fillEqually
            
            return stackView
        }()
        
        posterAndDetailView.addSubview(filmPoster)
        posterAndDetailView.addSubview(detailStackView)
        
        filmPoster.snp.makeConstraints { make in
            make.top.bottom.leading.equalToSuperview()
            make.width.equalTo(100)
        }
        
        posterAndDetailView.snp.makeConstraints { make in
            make.height.equalTo(150)
        }
        
        detailStackView.snp.makeConstraints { make in
            make.top.bottom.trailing.equalToSuperview()
            make.leading.equalTo(filmPoster.snp.trailing).offset(10)
            make.height.equalTo(150)
        }
        
        deleteButton.snp.makeConstraints { make in
            make.height.equalTo(70)
        }
        
        filmDescription.snp.makeConstraints { make in
            make.height.equalTo(300)
        }
        
        commentary.snp.makeConstraints { make in
            make.height.equalTo(100)
        }
        
        
        
        lazy var mainStackView: UIStackView = {
            let stackView = UIStackView(arrangedSubviews: [filmNameLabel,
                                                           posterAndDetailView,
                                                           filmDescription,
                                                          commentary,
                                                          deleteButton])
            stackView.axis = .vertical
            stackView.spacing = 10
            stackView.distribution = .fillProportionally
            
            return stackView
        }()
        
//        filmNameLabel.backgroundColor = .systemGray
//        filmNameLabel.snp.makeConstraints { make in
//            make.height.equalTo(70)
//        }
//        
        filmYear.backgroundColor = .systemGray
        filmType.backgroundColor = .systemGray
        filmRating.backgroundColor = .systemGray
        filmCountries.backgroundColor = .systemGray
        filmDescription.backgroundColor = .systemGray
        filmNameLabel.backgroundColor = .systemGray
        filmPoster.backgroundColor = .systemGray
        commentary.backgroundColor = .systemGray
        
        self.addSubview(mainStackView)
        
        //mainStackView.backgroundColor = .systemGray
        mainStackView.snp.makeConstraints { make in
            make.leading.trailing.equalTo(self.safeAreaLayoutGuide)
            make.top.equalTo(self.safeAreaLayoutGuide)
            make.bottom.equalTo(self.safeAreaLayoutGuide).inset(10)
            //make.leading.trailing.equalToSuperview().inset(0)
        }
    }
}
