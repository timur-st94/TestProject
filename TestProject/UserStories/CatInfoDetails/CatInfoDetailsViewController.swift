import UIKit

final class CatInfoDetailsViewController: UIViewController {
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let catImageView = UIImageView()
    private let jsonLabel = UILabel()
    
    private let catResponseModel: CatModel
    
    init(catResponseModel: CatModel) {
        self.catResponseModel = catResponseModel
        super.init(nibName: nil, bundle: nil)
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadImage()
        
        let jsonData = try! JSONEncoder().encode(catResponseModel)
        jsonLabel.text = jsonData.prettyPrintedJSONString
    }
    
    private func loadImage() {
        guard let path = catResponseModel.url else {
            return
        }
        
        ImageLoader.loadImage(path: path, needCaching: false) { [weak self] image in
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.catImageView.backgroundColor = .clear
                self.catImageView.image = image
            }
        }
    }
}

extension CatInfoDetailsViewController: InitializableElement {
    
    func addViews() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubviews(catImageView, jsonLabel)
    }
    
    func configureLayout() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        contentView.snp.makeConstraints { make in
            make.top.bottom.equalTo(scrollView)
            make.leading.trailing.equalTo(view)
        }
        
        catImageView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(270)
        }
        
        jsonLabel.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.equalTo(catImageView.snp.bottom).offset(16)
            make.bottom.lessThanOrEqualToSuperview().inset(8)
        }
    }
    
    func configureAppearance() {
        view.backgroundColor = .white
        catImageView.backgroundColor = .red
        catImageView.contentMode = .scaleAspectFit
        jsonLabel.numberOfLines = 0
        
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
    }
}
