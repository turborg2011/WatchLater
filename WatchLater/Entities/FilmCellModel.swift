import UIKit

protocol IFilmCellModel {
    var id: Int { get }
    var cellFilmPoster: UIImage? { get set }
    var cellFilmName: String? { get set }
    var filmDescription: String? { get set }
    var filmRating: String? { get set }
    var filmYear: String? { get set }
    var filmGenre: String? { get set }
    var isDownloaded: Bool { get set }
}

struct FilmCellModel: IFilmCellModel {
    var id: Int
    var cellFilmPoster: UIImage?
    var cellFilmName: String?
    var filmDescription: String?
    var filmRating: String?
    var filmYear: String?
    var filmGenre: String?
    var isDownloaded: Bool = false
}
