import UIKit

final class CatInfoCell: ConfigurableTableViewCell {
    private let catImageView = UIImageView()
    private let imageSizeInfoLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        catImageView.image = nil
        catImageView.backgroundColor = .red
    }
    
    override func configure(with item: Any) {
        guard let cellItem = item as? CellItem,
            let item = cellItem.item as? CatModel else {
                assertionFailure("Wrong cell item")
                return
        }

        configure(with: item)
    }
    
    private func configure(with model: CatModel) {
        imageSizeInfoLabel.text = model.heightAndWidth
                
        let width = (CGFloat(Constants.cellImageHeight) * (model.width ?? 0)) / (model.height ?? 1)
        let sizeInfo = String(format: "%@ (%0.fx%0.f)", model.heightAndWidth,
                              Constants.cellImageHeight, width)
        
        updateImage(width: width)
        imageSizeInfoLabel.text = sizeInfo
    }
    
    private func updateImage(width: CGFloat) {
        catImageView.snp.updateConstraints { (make) in
            make.width.equalTo(width)
        }
    }
    
    func updateImage(_ image: UIImage) {
        catImageView.image = image
        catImageView.backgroundColor = .clear
    }
}

extension CatInfoCell: InitializableElement {
    func addViews() {
        contentView.addSubviews(catImageView, imageSizeInfoLabel)
    }
    
    func configureLayout() {
        catImageView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(6)
            make.bottom.equalToSuperview().inset(6)
            make.leading.equalToSuperview().inset(16)
            make.height.width.equalTo(Constants.cellImageHeight)
        }
        
        imageSizeInfoLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(catImageView.snp.trailing).inset(-16)
            make.trailing.equalToSuperview().inset(16)
            make.centerY.equalTo(catImageView)
        }
    }
    
    func configureAppearance() {
        catImageView.backgroundColor = .red
        catImageView.contentMode = .scaleAspectFit
        imageSizeInfoLabel.numberOfLines = 0
    }
}
