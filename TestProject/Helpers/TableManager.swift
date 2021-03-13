import UIKit

class TableManager: ListManager, UITableViewDataSource, UITableViewDelegate {
    private var headers = [Int: UIView]()
    private var footers = [Int: UIView]()
    
    var didSelect: ((Any, IndexPath) -> Void)?
    var didScroll: ParameterBlock<UITableView>?
    var sectionHeader: Block<Int, UIView?>?
    var sectionFooter: Block<Int, UIView?>?

    var tableView: UITableView! {
        didSet {
            tableView.dataSource = self
            tableView.delegate = self
            tableView.estimatedRowHeight = 92
            tableView.backgroundColor = .white
            registerCells()
        }
    }

    @objc func resignFirstResponder() {
        tableView.endEditing(true)
    }

    func registerCells() {}

    override func reloadData() {
        super.reloadData()

        tableView.reloadData()
    }

    func smoothReload() {
        if #available(iOS 11.0, *) {
            tableView.performBatchUpdates({})
        } else {
            tableView.beginUpdates()
            tableView.endUpdates()
        }
    }

    // MARK: - UITableViewDataSource

    func numberOfSections(in tableView: UITableView) -> Int {
        return filteredItems.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredItems[section].count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let item = item(for: indexPath) else {
            fatalError("item not found for certain indexPath")
        }
        let cellId = itemIdentifier(for: item)
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
            as? ConfigurableTableViewCell else {
            fatalError("TableManager required working with cells type of ConfigurableCell")
        }
        cell.configure(with: item)

        return cell
    }

    private func header(for section: Int) -> UIView? {
        var header = headers[section]
        if header == nil {
            header = sectionHeader?(section)
            headers[section] = header
        }
        header?.layoutIfNeeded()

        return header
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return header(for: section)
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard let header = header(for: section) else {
            return 0
        }
        header.layoutIfNeeded()

        return header.bounds.height
    }

    private func footer(for section: Int) -> UIView? {
        var footer = footers[section]
        if footer == nil {
            footer = sectionFooter?(section)
            footers[section] = footer
        }
        footer?.layoutIfNeeded()

        return footer
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return footer(for: section)
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return footer(for: section)?.bounds.height ?? 0
    }

    // MARK: - UITableViewDelegate

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let item = item(for: indexPath) else {
            return 0
        }
        return height(for: item)
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let item = item(for: indexPath) {
            didSelect?(item, indexPath)
        }
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        didScroll?(tableView)
    }
}

class ConfigurableTableViewCell: UITableViewCell {
    func configure(with _: Any) {}
}
