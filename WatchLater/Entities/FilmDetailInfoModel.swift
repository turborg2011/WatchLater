import UIKit

struct FilmDetailInfoModel {
    var id: Int
    var name: String?
    var type: String?
    var description: String?
    var year: Int?
    var poster: UIImage?
    var genres: String?
    var countries: String?
    var rating: Float?
    var isDownloaded: Bool = false
    var commentary: String?
}
