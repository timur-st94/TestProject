typealias Block<T, K> = (T) -> K

typealias EmptyBlock = () -> Void
typealias ResultBlock<T> = () -> T
typealias ParameterBlock<T> = (T) -> Void

func className(_ type: AnyClass) -> String {
    return String(describing: type)
}

