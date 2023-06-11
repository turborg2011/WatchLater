import Foundation

struct FilmModel: Codable {
    var id: Int
    var name: String
    var description: String
    var poster: FilmPoster
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case description
        case poster
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(description, forKey: .description)
        try container.encode(poster, forKey: .poster)
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        description = try container.decode(String.self, forKey: .description)
        poster = try container.decode(FilmPoster.self, forKey: .poster)
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



