import UIKit
import SnapKit

final class CatsViewController: UIViewController {
    private let tableView = UITableView()
    private let tableManager = CatsViewTableManager()
    private let catsService: CatsService
    
    private let refreshControl = UIRefreshControl()
    private var catsInfo: [CatModel] = []
    
    var onSelectCat: ParameterBlock<CatModel?>?
    
    init(catsService: CatsService) {
        self.catsService = catsService
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
        catsRequest()
    }
}

extension CatsViewController: InitializableElement {
    func addViews() {
        view.addSubview(tableView)
    }
    
    func configureLayout() {
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    func configureAppearance() {
        title = .cats
        view.backgroundColor = .white
        
        tableView.insertSubview(refreshControl, at: 1)
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        
        tableManager.tableView = tableView
    }
    
    func bind() {
        tableManager.didSelect = { [weak self] item, indexPath in
            guard let self = self, let item = item as? CellItem,
                let catModel = item.item as? CatModel else {
                return
            }
            
            self.onSelectCat?(self.getCatResponseModel(by: catModel.id ?? .empty))
            self.tableView.deselectRow(at: indexPath, animated: true)
        }
    }
}

private extension CatsViewController {
    func tableViewItems() {
        var items: [CellItem] = []
        catsInfo.forEach {
            items.append(CellItem(type: CatsItemType.catInfo, item: $0))
        }
        
        tableManager.items = [items]
        tableManager.reloadData()
    }
    
    @objc func refresh() {
        catsRequest()
    }
    
    func showIndicator() {
        refreshControl.beginRefreshing()
    }
    
    func hideIndicator() {
        refreshControl.endRefreshing()
    }
    
    func showInfoDialog(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: .ok, style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

private extension CatsViewController {
    func catsRequest() {
        showIndicator()
        catsService.catsRequest { [weak self] (catResponseModels, error) in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.hideIndicator()
                if let error = error {
                    self.catsInfo = []
                    self.showInfoDialog(title: error.localizedDescription, message: .empty)
                } else if let catResponseModels = catResponseModels {
                    self.catsInfo = catResponseModels
                    self.tableViewItems()
                }
            }
        }
    }
    
    func getCatResponseModel(by id: String) -> CatModel? {
        return self.catsInfo.filter { $0.id == id }.first
    }
}
