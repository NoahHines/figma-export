//
//  The code generated using FigmaExport — Command line utility to export
//  colors, typography, icons and images from Figma to Xcode project.
//
//  https://github.com/RedMadRobot/figma-export
//
//  Don’t edit this code manually to avoid runtime crashes
//

import UIKit

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

}

public final class ButtonCLabel: Label {

    override var style: LabelStyle? {
        LabelStyle(
            font: ScribdFont.buttonC(),
            fontMetrics: UIFontMetrics(forTextStyle: .headline)
        )
    }
}

public final class Body3Label: Label {

    override var style: LabelStyle? {
        LabelStyle(
            font: ScribdFont.body3(),
            fontMetrics: UIFontMetrics(forTextStyle: .callout)
        )
    }
}

public final class ShareQuote3Label: Label {

    override var style: LabelStyle? {
        LabelStyle(
            font: ScribdFont.shareQuote3()
        )
    }
}

public final class Header3Label: Label {

    override var style: LabelStyle? {
        LabelStyle(
            font: ScribdFont.header3(),
            fontMetrics: UIFontMetrics(forTextStyle: .title3)
        )
    }
}

public final class ButtonELabel: Label {

    override var style: LabelStyle? {
        LabelStyle(
            font: ScribdFont.buttonE(),
            fontMetrics: UIFontMetrics(forTextStyle: .headline)
        )
    }
}

public final class ButtonFLabel: Label {

    override var style: LabelStyle? {
        LabelStyle(
            font: ScribdFont.buttonF(),
            fontMetrics: UIFontMetrics(forTextStyle: .subheadline)
        )
    }
}

public final class ShareQuote4Label: Label {

    override var style: LabelStyle? {
        LabelStyle(
            font: ScribdFont.shareQuote4()
        )
    }
}

public final class Caption1Label: Label {

    override var style: LabelStyle? {
        LabelStyle(
            font: ScribdFont.caption1(),
            fontMetrics: UIFontMetrics(forTextStyle: .caption1)
        )
    }
}

public final class Body5Label: Label {

    override var style: LabelStyle? {
        LabelStyle(
            font: ScribdFont.body5(),
            fontMetrics: UIFontMetrics(forTextStyle: .footnote)
        )
    }
}

public final class Header2Label: Label {

    override var style: LabelStyle? {
        LabelStyle(
            font: ScribdFont.header2(),
            fontMetrics: UIFontMetrics(forTextStyle: .title2)
        )
    }
}

public final class FootnoteLabel: Label {

    override var style: LabelStyle? {
        LabelStyle(
            font: ScribdFont.footnote(),
            fontMetrics: UIFontMetrics(forTextStyle: .caption2)
        )
    }
}

public final class Body2SerifLabel: Label {

    override var style: LabelStyle? {
        LabelStyle(
            font: ScribdFont.body2Serif(),
            fontMetrics: UIFontMetrics(forTextStyle: .callout)
        )
    }
}

public final class Body4Label: Label {

    override var style: LabelStyle? {
        LabelStyle(
            font: ScribdFont.body4(),
            fontMetrics: UIFontMetrics(forTextStyle: .footnote)
        )
    }
}

public final class Body1Label: Label {

    override var style: LabelStyle? {
        LabelStyle(
            font: ScribdFont.body1(),
            fontMetrics: UIFontMetrics(forTextStyle: .body)
        )
    }
}

public final class Body2Label: Label {

    override var style: LabelStyle? {
        LabelStyle(
            font: ScribdFont.body2(),
            fontMetrics: UIFontMetrics(forTextStyle: .callout)
        )
    }
}

public final class ButtonBLabel: Label {

    override var style: LabelStyle? {
        LabelStyle(
            font: ScribdFont.buttonB(),
            fontMetrics: UIFontMetrics(forTextStyle: .headline)
        )
    }
}

public final class ButtonALabel: Label {

    override var style: LabelStyle? {
        LabelStyle(
            font: ScribdFont.buttonA(),
            fontMetrics: UIFontMetrics(forTextStyle: .headline)
        )
    }
}

public final class LargeTextLabel: Label {

    override var style: LabelStyle? {
        LabelStyle(
            font: ScribdFont.largeText(),
            fontMetrics: UIFontMetrics(forTextStyle: .largeTitle)
        )
    }
}

public final class Header1Label: Label {

    override var style: LabelStyle? {
        LabelStyle(
            font: ScribdFont.header1(),
            fontMetrics: UIFontMetrics(forTextStyle: .title1)
        )
    }
}

public final class ShareQuote1Label: Label {

    override var style: LabelStyle? {
        LabelStyle(
            font: ScribdFont.shareQuote1()
        )
    }
}

public final class ShareQuote2Label: Label {

    override var style: LabelStyle? {
        LabelStyle(
            font: ScribdFont.shareQuote2()
        )
    }
}

public final class ShareQuote5Label: Label {

    override var style: LabelStyle? {
        LabelStyle(
            font: ScribdFont.shareQuote5()
        )
    }
}

public final class Header3ItalicLabel: Label {

    override var style: LabelStyle? {
        LabelStyle(
            font: ScribdFont.header3Italic(),
            fontMetrics: UIFontMetrics(forTextStyle: .headline)
        )
    }
}
