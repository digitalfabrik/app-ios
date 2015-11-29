import Foundation


extension Page {
    
    @objc
    var descriptionText: NSAttributedString {
        let text = NSMutableAttributedString()
        
        if let title = title, attributedTitle = TextUtils.attributedStringWithHtml(title) {
            text.appendAttributedString(attributedTitle)
            let attributes = [
                NSFontAttributeName: UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline),
                NSForegroundColorAttributeName: UIColor(white: 0.2, alpha: 1)
            ]
            let range = NSMakeRange(0, attributedTitle.length)
            text.setAttributes(attributes, range: range)
        }
        
        if title != nil && excerpt != nil {
            text.appendAttributedString(NSAttributedString(string: "\n", attributes: [
                NSFontAttributeName: UIFont.preferredFontForTextStyle(UIFontTextStyleBody),
                NSForegroundColorAttributeName: UIColor(white: 0, alpha: 0)
            ]))
        }
        
        if let excerpt = excerpt, attributedExcerpt = TextUtils.attributedStringWithHtml(excerpt) {
            let range = NSMakeRange(text.length, attributedExcerpt.length)
            text.appendAttributedString(attributedExcerpt)
            let attributes = [
                NSFontAttributeName: UIFont.preferredFontForTextStyle(UIFontTextStyleFootnote),
                NSForegroundColorAttributeName: UIColor(white: 0.4, alpha: 1)
            ]
            text.setAttributes(attributes, range: range)
        }
        
        return text.copy() as! NSAttributedString
    }

}
