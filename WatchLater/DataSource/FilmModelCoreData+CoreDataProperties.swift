
import Foundation
import CoreData


extension FilmModelCoreData {

    @NSManaged public var id: Int
    @NSManaged public var name: String?
    @NSManaged public var filmDescription: String?
    @NSManaged public var type: String?
    @NSManaged public var year: Int
    @NSManaged public var poster: Data?
    @NSManaged public var genre: String?
    @NSManaged public var country: String?
    @NSManaged public var rating: Float

}

extension FilmModelCoreData : Identifiable {

}
