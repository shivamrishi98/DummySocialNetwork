//
//  Extensions.swift
//  DummySocialNetwork
//
//  Created by Shivam Rishi on 27/03/21.
//

import UIKit


extension UIView {
    
    var width:CGFloat {
        return frame.size.width
    }
    
    var height:CGFloat {
        return frame.size.height
    }
    
    var left:CGFloat {
        return frame.origin.x
    }
    
    var right:CGFloat {
        return left + width
    }
    
    var top:CGFloat {
        return frame.origin.y
    }
    
    var bottom:CGFloat {
        return top + height
    }
    
}

extension DateFormatter {
    
    static let dateFormatter:DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        return dateFormatter
    }()
    
    static func makeDisplayDateFormatter(dateStyle:Style,dateFormat:String?) -> DateFormatter {
        let displayDateFormatter:DateFormatter = DateFormatter()
        displayDateFormatter.dateStyle = dateStyle
        displayDateFormatter.dateFormat = dateFormat
        return displayDateFormatter
    }

}

extension String {
    static func formattedDate(string: String,dateStyle:DateFormatter.Style = .long,dateFormat:String? = nil) -> String {
        guard let date = DateFormatter.dateFormatter.date(from: string) else {
            return string
        }
        return DateFormatter.makeDisplayDateFormatter(dateStyle: dateStyle,
                                                      dateFormat: dateFormat ?? nil).string(from: date)
    }
}
