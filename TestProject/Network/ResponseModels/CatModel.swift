import CoreGraphics

struct CatModel: Codable {
    let id: String?
    let url: String?
    let height: CGFloat?
    let width: CGFloat?
    
    var heightAndWidth: String {
        String(format: "%0.fx%0.f", height ?? 0, width ?? 0)
    }
}
