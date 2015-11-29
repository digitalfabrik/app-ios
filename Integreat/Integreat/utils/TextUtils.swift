import Foundation


enum TextUtils {
    
    static func attributedStringWithHtml(html: String) -> NSAttributedString? {
        return html.dataUsingEncoding(NSUTF8StringEncoding).flatMap {
            return try? NSAttributedString(
                data: $0,
                options: [
                    NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,
                    NSCharacterEncodingDocumentAttribute: NSUTF8StringEncoding
                ],
                documentAttributes: nil
            )
        }
    }


}