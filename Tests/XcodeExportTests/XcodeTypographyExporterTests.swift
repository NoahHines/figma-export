import XCTest
import XcodeExport
import FigmaExportCore

final class XcodeTypographyExporterTests: XCTestCase {
    
    private var emptyTextStyles: [TextStyle] = []
    
    func testExportUIKitFonts() throws {
        let exporter = XcodeTypographyExporter(systemName: "DesignSystem")
        
        let styles = [
            makeTextStyle(name: "largeTitle", fontName: "PTSans-Bold", fontStyle: .largeTitle, fontSize: 34),
            makeTextStyle(name: "header", fontName: "PTSans-Bold", fontSize: 20, fontSizeRange: FontSizeRange(compact: 20, regular: 22)),
            makeTextStyle(name: "body", fontName: "PTSans-Regular", fontStyle: .body, fontSize: 16),
            makeTextStyle(name: "caption", fontName: "PTSans-Regular", fontStyle: .footnote, fontSize: 14, lineHeight: 20)
        ]
        let files = try exporter.exportFonts(textStyles: styles, fontExtensionURL: URL(string: "~/UIFont+extension.swift")!)
        
        let contents = """
        //
        //  The code generated using FigmaExport — Command line utility to export
        //  colors, typography, icons and images from Figma to Xcode project.
        //
        //  https://github.com/NoahHines/figma-export
        //
        //  Don’t edit this code manually to avoid runtime crashes
        //

        #if os(iOS)

        import UIKit

        public extension DesignSystem {

            public class Font {

                public static func largeTitle() -> UIFont {
                    customFont("PTSans-Bold", size: 34.0, textStyle: .largeTitle, scaled: true)
                }

                public static func header(_ traitCollection: UITraitCollection? = nil) -> UIFont {
                    customFont("PTSans-Bold", traitCollection: traitCollection, compact: 20.0, regular: 22.0)
                }

                public static func body() -> UIFont {
                    customFont("PTSans-Regular", size: 16.0, textStyle: .body, scaled: true)
                }

                public static func caption() -> UIFont {
                    customFont("PTSans-Regular", size: 14.0, textStyle: .footnote, scaled: true)
                }

                private static func customFont(
                    _ name: String,
                    size: CGFloat,
                    textStyle: UIFont.TextStyle? = nil,
                    scaled: Bool = false) -> UIFont {
                    return customFont(name,
                                      traitCollection: nil,
                                      compact: size,
                                      regular: size,
                                      textStyle: textStyle,
                                      scaled: scaled)
                }

                private static func customFont(
                    _ name: String,
                    traitCollection: UITraitCollection?,
                    compact: CGFloat,
                    regular: CGFloat,
                    textStyle: UIFont.TextStyle? = nil,
                    scaled: Bool = false) -> UIFont {

                    let size: CGFloat = {
                        let resolvedTraitCollection: UITraitCollection
                        if #available(iOS 13.0, *) {
                            resolvedTraitCollection = traitCollection ?? .current
                        } else {
                            resolvedTraitCollection = UITraitCollection(horizontalSizeClass: .compact)
                        }

                        switch resolvedTraitCollection.horizontalSizeClass {
                        case .regular:
                            return regular
                        case .compact,
                             .unspecified:
                            return compact
                        @unknown default:
                            return compact
                        }
                    }()

                    guard let font = UIFont(name: name, size: size) else {
                        print("Warning: Font \\(name) not found.")
                        return UIFont.systemFont(ofSize: size, weight: .regular)
                    }

                    if scaled, let textStyle = textStyle {
                        let metrics = UIFontMetrics(forTextStyle: textStyle)
                        return metrics.scaledFont(for: font)
                    } else {
                        return font
                    }
                }
            }
        }

        #endif

        """
        
        files.forEach {
            print(String(data: $0.data!, encoding: .utf8)!)
        }

        let newFiles = [
            FileContents(
                destination: Destination(
                    directory: URL(string: "~/")!,
                    file: URL(string: "UIFont+extension.swift")!
                ),
                data: contents.data(using: .utf8)!
            )
        ]
        
        XCTAssertEqual(
            files,
            newFiles
        )
    }
    
    func testExportSwiftUIFonts() throws {
        let exporter = XcodeTypographyExporter(systemName: "DesignSystem")
        
        let styles = [
            makeTextStyle(name: "largeTitle", fontName: "PTSans-Bold", fontStyle: .largeTitle, fontSize: 34),
            makeTextStyle(name: "header", fontName: "PTSans-Bold", fontSize: 20, fontSizeRange: FontSizeRange(compact: 20, regular: 22)),
            makeTextStyle(name: "body", fontName: "PTSans-Regular", fontStyle: .body, fontSize: 16),
            makeTextStyle(name: "caption", fontName: "PTSans-Regular", fontStyle: .footnote, fontSize: 14, lineHeight: 20)
        ]

        let files = try exporter.exportFonts(textStyles: styles, swiftUIFontExtensionURL: URL(string: "~/Font+extension.swift")!)
        
        let contents = """
        //
        //  The code generated using FigmaExport — Command line utility to export
        //  colors, typography, icons and images from Figma to Xcode project.
        //
        //  https://github.com/NoahHines/figma-export
        //
        //  Don’t edit this code manually to avoid runtime crashes
        //

        #if os(iOS)

        import SwiftUI

        @available(iOS 13.0, *)
        public extension Font {

            public static func largeTitle() -> Font {
                Font.custom("PTSans-Bold", size: 34.0)
            }
            public static func header() -> Font {
                Font.custom("PTSans-Bold", size: 20.0)
            }
            public static func body() -> Font {
                Font.custom("PTSans-Regular", size: 16.0)
            }
            public static func caption() -> Font {
                Font.custom("PTSans-Regular", size: 14.0)
            }
        }

        #endif

        """
        
        files.forEach {
            print(String(data: $0.data!, encoding: .utf8)!)
        }
        
        XCTAssertEqual(
            files,
            [
                FileContents(
                    destination: Destination(
                        directory: URL(string: "~/")!,
                        file: URL(string: "Font+extension.swift")!
                    ),
                    data: contents.data(using: .utf8)!
                )
            ]
        )
    }
    
    func testExportLabel() throws {
        let exporter = XcodeTypographyExporter(systemName: "DesignSystem")
        
        let styles = [
            makeTextStyle(name: "largeTitle", fontName: "PTSans-Bold", fontStyle: .largeTitle, fontSize: 34, lineHeight: nil),
            makeTextStyle(name: "header", fontName: "PTSans-Bold", fontSize: 20, lineHeight: nil),
            makeTextStyle(name: "body", fontName: "PTSans-Regular", fontStyle: .body, fontSize: 16, lineHeight: nil, letterSpacing: 1.2),
            makeTextStyle(name: "caption", fontName: "PTSans-Regular", fontStyle: .footnote, fontSize: 14, lineHeight: 20)
        ]
        let files = try exporter.exportLabels(textStyles: styles, labelsDirectory: URL(string: "~/")!)
        
        let contentsLabel = """
        //
        //  The code generated using FigmaExport — Command line utility to export
        //  colors, typography, icons and images from Figma to Xcode project.
        //
        //  https://github.com/NoahHines/figma-export
        //
        //  Don’t edit this code manually to avoid runtime crashes
        //

        #if os(iOS)

        import UIKit

        public extension DesignSystem {

            public class Label: UILabel {

                var style: LabelStyle? { nil }

                public override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
                    super.traitCollectionDidChange(previousTraitCollection)

                    if previousTraitCollection?.preferredContentSizeCategory != traitCollection.preferredContentSizeCategory {
                        updateText()
                    }
                }

                convenience init(text: String?, textColor: UIColor) {
                    self.init()
                    self.text = text
                    self.textColor = textColor
                }

                override init(frame: CGRect) {
                    super.init(frame: frame)
                    commonInit()
                }

                required init?(coder aDecoder: NSCoder) {
                    super.init(coder: aDecoder)
                    commonInit()
                    updateText()
                }

                private func commonInit() {
                    font = style?.font
                    adjustsFontForContentSizeCategory = true
                }

                private func updateText() {
                    text = super.text
                }

                public override var text: String? {
                    get {
                        guard style?.attributes != nil else {
                            return super.text
                        }

                        return attributedText?.string
                    }
                    set {
                        guard let style = style else {
                            super.text = newValue
                            return
                        }

                        guard let newText = newValue else {
                            attributedText = nil
                            super.text = nil
                            return
                        }

                        let attributes = style.attributes(for: textAlignment, lineBreakMode: lineBreakMode)
                        attributedText = NSAttributedString(string: newText, attributes: attributes)
                    }
                }

                public final class LargeTitleLabel: Label {

                    override var style: LabelStyle? {
                        LabelStyle(
                            font: DesignSystem.Font.largeTitle(),
                            fontMetrics: UIFontMetrics(forTextStyle: .largeTitle)
                        )
                    }
                }

                public final class HeaderLabel: Label {

                    override var style: LabelStyle? {
                        LabelStyle(
                            font: DesignSystem.Font.header()
                        )
                    }
                }

                public final class BodyLabel: Label {

                    override var style: LabelStyle? {
                        LabelStyle(
                            font: DesignSystem.Font.body(),
                            fontMetrics: UIFontMetrics(forTextStyle: .body),
                            tracking: 1.2
                        )
                    }
                }

                public final class CaptionLabel: Label {

                    override var style: LabelStyle? {
                        LabelStyle(
                            font: DesignSystem.Font.caption(),
                            fontMetrics: UIFontMetrics(forTextStyle: .footnote),
                            lineHeight: 20.0
                        )
                    }
                }

            }
        }

        #endif

        """
        
        let contentsLabelStyle = """
        //
        //  The code generated using FigmaExport — Command line utility to export
        //  colors, typography, icons and images from Figma to Xcode project.
        //
        //  https://github.com/NoahHines/figma-export
        //
        //  Don’t edit this code manually to avoid runtime crashes
        //

        #if os(iOS)

        import UIKit

        struct LabelStyle {

            let font: UIFont
            let fontMetrics: UIFontMetrics?
            let lineHeight: CGFloat?
            let tracking: CGFloat

            init(font: UIFont, fontMetrics: UIFontMetrics? = nil, lineHeight: CGFloat? = nil, tracking: CGFloat = 0) {
                self.font = font
                self.fontMetrics = fontMetrics
                self.lineHeight = lineHeight
                self.tracking = tracking
            }

            func attributes(for alignment: NSTextAlignment, lineBreakMode: NSLineBreakMode) -> [NSAttributedString.Key: Any] {

                let paragraphStyle = NSMutableParagraphStyle()
                paragraphStyle.alignment = alignment
                paragraphStyle.lineBreakMode = lineBreakMode

                var baselineOffset: CGFloat = .zero

                if let lineHeight = lineHeight {
                    let lineHeightMultiple = lineHeight / font.lineHeight
                    paragraphStyle.lineHeightMultiple = lineHeightMultiple

                    baselineOffset = 1 / lineHeightMultiple

                    let scaledLineHeight: CGFloat = fontMetrics?.scaledValue(for: lineHeight) ?? lineHeight
                    paragraphStyle.minimumLineHeight = scaledLineHeight
                    paragraphStyle.maximumLineHeight = scaledLineHeight
                }

                return [
                    NSAttributedString.Key.paragraphStyle: paragraphStyle,
                    NSAttributedString.Key.kern: tracking,
                    NSAttributedString.Key.baselineOffset: baselineOffset,
                    NSAttributedString.Key.font: font
                ]
            }
        }

        #endif

        """

        files.forEach {
            print(String(data: $0.data!, encoding: .utf8)!)
        }
        
        XCTAssertEqual(files.count, 2, "Must be generated 2 files but generated \(files.count)")
        XCTAssertEqual(
            files,
            [
                FileContents(
                    destination: Destination(
                        directory: URL(string: "~/")!,
                        file: URL(string: "Label.swift")!
                    ),
                    data: contentsLabel.data(using: .utf8)!
                ),
                FileContents(
                    destination: Destination(
                        directory: URL(string: "~/")!,
                        file: URL(string: "LabelStyle.swift")!
                    ),
                    data: contentsLabelStyle.data(using: .utf8)!
                )
            ]
        )
    }
    
    private func makeTextStyle(
        name: String = "name",
        fontName: String = "fontName",
        fontStyle: DynamicTypeStyle? = nil,
        fontSize: Double,
        fontSizeRange: FontSizeRange? = nil,
        lineHeight: Double? = nil,
        letterSpacing: Double = 0) -> TextStyle {
        
        return TextStyle(
            name: name,
            fontName: fontName,
            fontSize: fontSize,
            fontSizeRange: fontSizeRange,
            fontStyle: fontStyle,
            lineHeight: lineHeight,
            letterSpacing: letterSpacing)
    }
}
