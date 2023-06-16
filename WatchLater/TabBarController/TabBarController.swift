
import UIKit

final class TabBarController: UITabBarController {
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension TabBarController {
    func configure() {
        let searchViewController = SearchModuleBuilder.buildSearchModule()
        let favoritesViewController = FavoritesModuleBuilder.buildFavoritesModule()
        
        searchViewController.title = "Search"
        favoritesViewController.title = "Favorites"
        
        let searchNavigation = UINavigationController(rootViewController: searchViewController)
        let favoritesNavigation = UINavigationController(rootViewController: favoritesViewController)
        
        searchNavigation.tabBarItem = UITabBarItem(title: "Search",
                                                       image: UIImage(systemName: "magnifyingglass"),
                                                       tag: 1)
        favoritesNavigation.tabBarItem = UITabBarItem(title: "Favorites",
                                                          image: UIImage(systemName: "star"),
                                                          tag: 2)
        setViewControllers([
            searchNavigation,
            favoritesNavigation
        ], animated: false)
    }
}
