//
//  String+Encoding.swift
//  AKCE
//
//  Created by Hubert Gostomski on 30/12/2018.
//  Copyright © 2018 Hubert Gostomski. All rights reserved.
//

extension String {
    public func stringByAddingPercentEncodingForFormData(plusForSpace: Bool=false) -> String? {
        let unreserved = "*-._"
        let allowed = NSMutableCharacterSet.alphanumeric()
        allowed.addCharacters(in: unreserved)
        
        if plusForSpace {
            allowed.addCharacters(in: " ")
        }
        
        var encoded = self.addingPercentEncoding(withAllowedCharacters: allowed as CharacterSet)
        
        while (encoded?.contains("  "))! {
            encoded = encoded?.replacingOccurrences(of: "  ", with: " ")
        }
        
        if plusForSpace {
            encoded = encoded?.replacingOccurrences(of: " ", with: "+")
        }
        return encoded
    }
}

