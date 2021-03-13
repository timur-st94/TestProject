import UIKit

final class CatInfoCoordinator: NavigationStartable {
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        showCatsScreen()
    }
    
    private func showCatsScreen() {
        let catsService = CatsService()
        let controller = CatsViewController(catsService: catsService)
        controller.onSelectCat = { [weak self] (сatModel) in
            guard let model = сatModel else {
                return assertionFailure("CatModel cannot be nil")
            }
            
            self?.showCatInfoDetailsScreen(with: model)
        }
        
        navigationController.pushViewController(controller, animated: false)
    }
    
    private func showCatInfoDetailsScreen(with model: CatModel) {
        let controller = CatInfoDetailsViewController(catResponseModel: model)
        navigationController.pushViewController(controller, animated: true)
    }
}
