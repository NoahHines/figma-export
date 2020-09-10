import XCTest
import XcodeExport
import FigmaExportCore
import Diff

final class XcodeTypographyExporterTests: XCTestCase {
    
    private var emptyTextStyles: [TextStyle] = []
    
    func testExportFonts() throws {
        let exporter = XcodeTypographyExporter()
        
        let styles = [
            makeTextStyle(name: "largeTitle", fontName: "PTSans-Bold", fontStyle: .largeTitle, fontSize: 34),
            makeTextStyle(name: "header", fontName: "PTSans-Bold", fontSize: 20),
            makeTextStyle(name: "body", fontName: "PTSans-Regular", fontStyle: .body, fontSize: 16),
            makeTextStyle(name: "caption", fontName: "PTSans-Regular", fontStyle: .footnote, fontSize: 14, lineHeight: 20)
        ]
        let files = try exporter.exportFonts(textStyles: styles, fontExtensionDirectory: "~/")
        
        let contents = """
        import UIKit

        extension UIFont {
            
            static func largeTitle() -> UIFont {
            
                customFont("PTSans-Bold", size: 34.0, textStyle: .largeTitle, scaled: true)
            
            }
            
            static func header() -> UIFont {
            
                customFont("PTSans-Bold", size: 20.0)
            
            }
            
            static func body() -> UIFont {
            
                customFont("PTSans-Regular", size: 16.0, textStyle: .body, scaled: true)
            
            }
            
            static func caption() -> UIFont {
            
                customFont("PTSans-Regular", size: 14.0, textStyle: .footnote, scaled: true)
            
            }
            
            private static func customFont(
                _ name: String,
                size: CGFloat,
                textStyle: UIFont.TextStyle? = nil,
                scaled: Bool = false) -> UIFont {

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
        """
        
        XCTAssertEqual(
            files,
            [
                FileContents(
                    destination: Destination(
                        directory: URL(string: "~/")!,
                        file: URL(string: "UIFont+extension.swift")!
                    ),
                    data: contents.data(using: .utf8)!
                )
            ]
        )
    }
    
    func testExportLabel() throws {
        let exporter = XcodeTypographyExporter()
        
        let styles = [
            makeTextStyle(name: "largeTitle", fontName: "PTSans-Bold", fontStyle: .largeTitle, fontSize: 34, lineHeight: nil),
            makeTextStyle(name: "header", fontName: "PTSans-Bold", fontSize: 20, lineHeight: nil),
            makeTextStyle(name: "body", fontName: "PTSans-Regular", fontStyle: .body, fontSize: 16, lineHeight: nil, letterSpacing: 1.2),
            makeTextStyle(name: "caption", fontName: "PTSans-Regular", fontStyle: .footnote, fontSize: 14, lineHeight: 20)
        ]
        let files = try exporter.exportLabels(textStyles: styles, labelsDirectory: "~/")
        
        let contentsLabel = """
        import UIKit

        class Label: UILabel {

            var style: LabelStyle? { nil }

            override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
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

            override var text: String? {
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

        }

        final class LargeTitleLabel: Label {

            override var style: LabelStyle? {
                LabelStyle(
                    font: UIFont.largeTitle(),
                    fontMetrics: UIFontMetrics(forTextStyle: .largeTitle)
                )
            }
        }

        final class HeaderLabel: Label {

            override var style: LabelStyle? {
                LabelStyle(
                    font: UIFont.header()
                )
            }
        }

        final class BodyLabel: Label {

            override var style: LabelStyle? {
                LabelStyle(
                    font: UIFont.body(),
                    fontMetrics: UIFontMetrics(forTextStyle: .body),
                    tracking: 1.2
                )
            }
        }

        final class CaptionLabel: Label {

            override var style: LabelStyle? {
                LabelStyle(
                    font: UIFont.caption(),
                    fontMetrics: UIFontMetrics(forTextStyle: .footnote),
                    lineHeight: 20.0
                )
            }
        }

        """
        
        let contentsLabelStyle = """
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
            
            funcs attributes(for alignment: NSTextAlignment, lineBreakMode: NSLineBreakMode) -> [NSAttributedString.Key: Any] {
                
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
        """
        
        let differ: () -> String = {
            var result = ""
            
            let diff1 = diff(contentsLabel, String(data: files[0].data!, encoding: .utf8)!)
            let diff2 = diff(contentsLabelStyle, String(data: files[1].data!, encoding: .utf8)!)
            
            if let d = diff1 {
                let a = String.Index(utf16Offset: d.0.lowerBound - 10, in: contentsLabel)
                let b = String.Index(utf16Offset: d.0.upperBound + 10, in: contentsLabel)
                print(contentsLabel[a..<b])
                result += "range=\(d.0) symbols=\(d.1)"
            }
            
            if let d = diff2 {
                let a = String.Index(utf16Offset: d.0.lowerBound - 10, in: contentsLabel)
                let b = String.Index(utf16Offset: d.0.upperBound + 10, in: contentsLabel)
                print(contentsLabel[a..<b])
                result += "\nrange=\(d.0) symbols=\(d.1)"
            }
            
            return result
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
            ],
            differ()
        )
    }
    
    private func makeTextStyle(
        name: String = "name",
        fontName: String = "fontName",
        fontStyle: DynamicTypeStyle? = nil,
        fontSize: Double,
        lineHeight: Double? = nil,
        letterSpacing: Double = 0) -> TextStyle {
        
        return TextStyle(
            name: name,
            fontName: fontName,
            fontSize: fontSize,
            fontStyle: fontStyle,
            lineHeight: lineHeight,
            letterSpacing: letterSpacing)
    }
}
