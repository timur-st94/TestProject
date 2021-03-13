import UIKit

struct CellItem {
    let type: Any
    let item: Any
}

enum CatsItemType {
    case catInfo
}

final class CatsViewTableManager: TableManager {
    override func registerCells() {
        [
            CatInfoCell.self
        ].forEach {
            tableView.register($0, forCellReuseIdentifier: className($0))
        }
    }
    
    override func itemIdentifier(for item: Any) -> String {
        guard let cellItem = item as? CellItem,
            let type = cellItem.type as? CatsItemType else {
            return .empty
        }

        switch type {
        case .catInfo:
            return className(CatInfoCell.self)
        }
    }
    
    override func height(for item: Any) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let superCell = super.tableView(tableView, cellForRowAt: indexPath)
        
        guard let cell = superCell as? CatInfoCell,
              let cellItem = item(for: indexPath) as? CellItem,
              let item = cellItem.item as? CatModel,
              let url = item.url else {
            
            return superCell
        }
        
        ImageLoader.loadImageIfNeeded(path: url) { image in
            DispatchQueue.main.async {
                if let image = image,
                   let updateCell = tableView.cellForRow(at: indexPath) as? CatInfoCell {
                    updateCell.updateImage(image)
                }
            }
        }
        
        return cell
    }
}
