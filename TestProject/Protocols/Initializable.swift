protocol Initializable {
    func initialize()
}

protocol Configurable {
    func addViews()
    func configureAppearance()
    func configureLayout()
    func bind()
}

extension Configurable {
    func addViews() {}
    func configureAppearance() {}
    func configureLayout() {}
    func bind() {}
}

extension Initializable where Self: Configurable {
    func initialize() {
        addViews()
        configureLayout()
        configureAppearance()
        bind()
    }
}

typealias InitializableElement = Initializable & Configurable
