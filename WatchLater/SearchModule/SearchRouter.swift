import UIKit

protocol ISearchRouter: AnyObject {
    func openModalDetailView()
}

final class SearchRouter { }

extension SearchRouter: ISearchRouter {
    func openModalDetailView() {
        // открытие окна с детальной инфой
    }
}
