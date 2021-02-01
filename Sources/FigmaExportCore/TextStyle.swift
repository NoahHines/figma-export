import Foundation

public enum DynamicTypeStyle: String, RawRepresentable, CaseIterable {
    case largeTitle = "Large Title"
    case title1 = "Title 1"
    case title2 = "Title 2"
    case title3 = "Title 3"
    case headline = "Headline"
    case body = "Body"
    case callout = "Callout"
    case subheadline = "Subhead"
    case footnote = "Footnote"
    case caption1 = "Caption 1"
    case caption2 = "Caption 2"

    public init?(_ descriptionString: String) {
        for item in descriptionString.split(separator: ",") {
            let trimmedItem = item.trimmingCharacters(in: .whitespacesAndNewlines)
            for dynamicTypeStyleCase in DynamicTypeStyle.allCases {
                if trimmedItem == dynamicTypeStyleCase.rawValue {
                    self = dynamicTypeStyleCase
                    return
                }
            }
        }
        return nil
    }
    
    public var textStyleName: String {
        switch self {
        case .largeTitle:
            return "largeTitle"
        case .title1:
            return "title1"
        case .title2:
            return "title2"
        case .title3:
            return "title3"
        case .headline:
            return "headline"
        case .body:
            return "body"
        case .callout:
            return "callout"
        case .subheadline:
            return "subheadline"
        case .footnote:
            return "footnote"
        case .caption1:
            return "caption1"
        case .caption2:
            return "caption2"
        }
    }
}

public struct FontSizeRange {
    public let compact: CGFloat
    public let regular: CGFloat

    /**
     Creates a range of font sizes to use for compact & regular UIUserInterfaceSizeClass

     - Parameter descriptionString: The string from the Description field of a Text Style in Figma.
                                    ex. "compact: 24, regular: 28, Title 1"

     - Returns: A FontSizeRange struct or nil if string format is invalid.
     */
    public init?(_ descriptionString: String) {

        let descriptionItems = descriptionString
            .replacingOccurrences(of: " ", with: "")
            .split(separator: ",")
            .reduce(into: [String: CGFloat]()) {
                let item = $1.split(separator: ":")
                if let key = item.first, let valueSubstring = item.last, let value = NumberFormatter().number(from: String(valueSubstring)) {
                    $0[String(key)] = CGFloat(value.floatValue)
                }
            }

        guard let compact = descriptionItems["compact"],
              let regular = descriptionItems["regular"] else { return nil }

        self.compact = compact
        self.regular = regular
    }

    public init(compact: CGFloat, regular: CGFloat) {
        self.compact = compact
        self.regular = regular
    }
}

public struct TextStyle {
    
    public let name: String
    public let fontName: String
    public let fontSize: Double
    public let fontSizeRange: FontSizeRange?
    public let fontStyle: DynamicTypeStyle?
    public let lineHeight: Double?
    public let letterSpacing: Double

    public init(
        name: String,
        fontName: String,
        fontSize: Double,
        fontSizeRange: FontSizeRange?,
        fontStyle: DynamicTypeStyle?,
        lineHeight: Double? = nil,
        letterSpacing: Double) {
        
        self.name = name
        self.fontName = fontName
        self.fontSize = fontSize
        self.fontStyle = fontStyle
        self.lineHeight = lineHeight
        self.letterSpacing = letterSpacing
        self.fontSizeRange = fontSizeRange
    }
}
