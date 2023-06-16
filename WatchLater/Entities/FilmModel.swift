import Foundation

struct FilmModel: Codable {
    var id: Int?
    var name: String?
    var names: [FilmName]?
    var type: String?
    var description: String?
    var year: Int?
    var poster: FilmPoster?
    var genres: [FilmGenre]?
    var countries: [FilmCountries]?
    var rating: FilmRating?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case names
        case type
        case description
        case year
        case poster
        case genres
        case countries
        case rating
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(names, forKey: .names)
        try container.encode(type, forKey: .type)
        try container.encode(description, forKey: .description)
        try container.encode(year, forKey: .year)
        try container.encode(poster, forKey: .poster)
        try container.encode(genres, forKey: .genres)
        try container.encode(countries, forKey: .countries)
        try container.encode(rating, forKey: .rating)
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int?.self, forKey: .id)
        name = try container.decode(String?.self, forKey: .name)
        names = try container.decode([FilmName]?.self, forKey: .names)
        type = try container.decode(String?.self, forKey: .type)
        description = try container.decode(String?.self, forKey: .description)
        year = try container.decode(Int?.self, forKey: .year)
        poster = try container.decode(FilmPoster?.self, forKey: .poster)
        genres = try container.decode([FilmGenre]?.self, forKey: .genres)
        countries = try container.decode([FilmCountries]?.self, forKey: .countries)
        rating = try container.decode(FilmRating?.self, forKey: .rating)
    }
}

struct FilmPoster: Codable {
    var url: String
    var previewUrl: String
    
    enum CodingKeys: String, CodingKey {
        case url
        case previewUrl
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(url, forKey: .url)
        try container.encode(previewUrl, forKey: .previewUrl)
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        url = try container.decode(String.self, forKey: .url)
        previewUrl = try container.decode(String.self, forKey: .previewUrl)
    }
}

struct FilmName: Codable {
    var name: String
}

struct FilmGenre: Codable {
    var name: String
}

struct FilmCountries: Codable {
    var name: String
}

struct FilmRating: Codable {
    var kp: Float?
    var imdb: Float?
}
