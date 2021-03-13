import UIKit

typealias PresentingStartable = Presenting & Startable
typealias NavigationStartable = Navigation & Startable

protocol Startable {
    func start()
}

protocol Presenting: class {
    var presentingViewController: UIViewController { get }

    init(presentingViewController: UIViewController)
}

protocol Navigation {
    var navigationController: UINavigationController { get }

    init(navigationController: UINavigationController)
}
