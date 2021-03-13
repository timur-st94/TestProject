import UIKit

final class AppCoordinator: Startable {
    private let catInfoCoordinator: CatInfoCoordinator
    
    private let rootNavigationController = UINavigationController()
    
    init(window: UIWindow) {
        catInfoCoordinator = CatInfoCoordinator(navigationController: rootNavigationController)
        window.rootViewController = rootNavigationController
        window.makeKeyAndVisible()
    }
    
    func start() {
        catInfoCoordinator.start()
    }
}
