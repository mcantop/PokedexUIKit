//
//  Data+Extension.swift
//  PokedexUIKit
//
//  Created by Maciej on 18/10/2023.
//

import Foundation

extension Data {
    func parseData(removeString string: String) -> Data? {
        let dataAsString = String(data: self, encoding: .utf8)
        let parsedDataString = dataAsString?.replacingOccurrences(of: string, with: "")
        
        guard let data = parsedDataString?.data(using: .utf8) else { return nil }
        
        return data
    }
}
