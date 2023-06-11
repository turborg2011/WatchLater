import Foundation

struct FilmSearchResults: Codable {
    var docs: [FilmSearchModel]
    var total: Int
    
    enum CodingKeys: String, CodingKey {
        case docs
        case total
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(docs, forKey: .docs)
        try container.encode(total, forKey: .total)
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        docs = try container.decode([FilmSearchModel].self, forKey: .docs)
        total = try container.decode(Int.self, forKey: .total)
    }
}

struct FilmSearchModel: Codable {
    var id: Int
    var name: String?
    var description: String?
    var poster: String?
    
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
        name = try container.decode(String?.self, forKey: .name)
        description = try container.decode(String?.self, forKey: .description)
        poster = try container.decode(String?.self, forKey: .poster)
    }
}
