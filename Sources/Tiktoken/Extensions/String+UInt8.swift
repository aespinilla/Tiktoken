//
//  String+UInt8.swift
//  
//
//  Created by Alberto Espinilla Garrido on 3/4/23.
//

import Foundation

extension String {
    var uInt8: [UInt8] { utf16.map({ UInt8($0) }) }
}
