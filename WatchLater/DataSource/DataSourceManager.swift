
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
    
    
    
}
