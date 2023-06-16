
import UIKit
import Foundation
import CoreData

final class DataSourceManager: NSObject {
    public static let shared = DataSourceManager()
    private override init() {}
    
    private let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    
    private var context: NSManagedObjectContext {
        appDelegate.persistantContainer.viewContext
    }
    
    public func fetchFilms() -> [FilmModelCoreData] {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "FilmModelCoreData")
        do {
            return try context.fetch(fetchRequest) as! [FilmModelCoreData]
        } catch {
            print(error.localizedDescription)
        }
        
        return []
    }
    
    public func createFilm(id: Int,
                           name: String?,
                           filmDescription: String?,
                           type: String?,
                           year: Int,
                           poster: Data?,
                           genre: String?,
                           country: String?,
                           rating: Float
    ) {
        guard let filmEntityDescription = NSEntityDescription.entity(forEntityName: "FilmModelCoreData", in: context) else {
            return
        }
        
        deleteFilm(filmID: id)
        
        let filmCoreData = FilmModelCoreData(entity: filmEntityDescription, insertInto: context)
        filmCoreData.id = id
        filmCoreData.name = name
        filmCoreData.filmDescription = filmDescription
        filmCoreData.type = type
        filmCoreData.year = year
        filmCoreData.poster = poster
        filmCoreData.genre = genre
        filmCoreData.country = country
        filmCoreData.rating = rating
        
        appDelegate.saveContext()
    }
    
    public func deleteFilm(filmID: Int) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "FilmModelCoreData")
        do {
            guard let films = try? context.fetch(fetchRequest) as? [FilmModelCoreData],
                  let film = films.first(where: { $0.id == filmID }) else {
                return
            }
            context.delete(film)
        }
        
        appDelegate.saveContext()
    }
    
    public func deleteAllFavFilms() {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "FilmModelCoreData")
        do {
            let films = try? context.fetch(fetchRequest) as? [FilmModelCoreData]
            films?.forEach({ film in
                context.delete(film)
            })
        }
        
        appDelegate.saveContext()
    }
    
    public func getFilmByID(_ filmID: Int) -> FilmModelCoreData? {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "FilmModelCoreData")
        do {
            guard let films = try? context.fetch(fetchRequest) as? [FilmModelCoreData],
                  let film = films.first(where: { $0.id == filmID }) else {
                return nil
            }
            return film
        }
    }
    
}
