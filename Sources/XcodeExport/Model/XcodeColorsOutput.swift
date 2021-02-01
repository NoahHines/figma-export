import Foundation

public struct XcodeColorsOutput {

    public let assetsColorsURL: URL?
    public let assetsInMainBundle: Bool
    public let colorSwiftURL: URL?
    public let swiftuiColorSwiftURL: URL?
    public let colorClassName: String?
    public let systemName: String
    
    public init(assetsColorsURL: URL?, assetsInMainBundle: Bool, colorSwiftURL: URL? = nil, swiftuiColorSwiftURL: URL? = nil, colorClassName: String? = nil, systemName: String) {
        self.assetsColorsURL = assetsColorsURL
        self.assetsInMainBundle = assetsInMainBundle
        self.colorSwiftURL = colorSwiftURL
        self.swiftuiColorSwiftURL = swiftuiColorSwiftURL
        self.colorClassName = colorClassName
        self.systemName = systemName
    }
}
