import UIKit

protocol IFilmCellModel {
    var id: Int { get }
    var cellFilmPoster: UIImage? { get set }
    var cellFilmName: String? { get set }
}

struct FilmCellModel: IFilmCellModel {
    var id: Int
    var cellFilmPoster: UIImage?
    var cellFilmName: String?
    
}
