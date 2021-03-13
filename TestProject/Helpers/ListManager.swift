import Foundation
import CoreGraphics

@objc protocol ListManagerProtocol {
    func indexPathIdentifier(for indexPath: IndexPath) -> String
    func itemIdentifier(for item: Any) -> String
    func item(for indexPath: IndexPath) -> Any?
    @objc optional func height(for item: Any) -> CGFloat
}

class ListManager: NSObject, ListManagerProtocol {

    func reloadData() {}

    var filteredItems: [[Any]] = [[]] {
        didSet {
            reloadData()
        }
    }

    var items: [[Any]] = [[]] {
        didSet {
            filteredItems = items
        }
    }

    func indexPathIdentifier(for indexPath: IndexPath) -> String {
        guard let item = item(for: indexPath) else {
            fatalError("item not found for certain indexPath")
        }
        return itemIdentifier(for: item)
    }

    func itemIdentifier(for item: Any) -> String {
        fatalError("override in child")
    }

    func item(for indexPath: IndexPath) -> Any? {
        return filteredItems[indexPath.section][indexPath.row]
    }

    @objc func height(for item: Any) -> CGFloat {
        return 52.0
    }
}
