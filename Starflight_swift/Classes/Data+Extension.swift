//
//  NSData+Extension.swift
//
//  Created by Ankush Kushwaha on 8/1/18.
//  Copyright © 2018 starcut. All rights reserved.
//

import Foundation

extension Data {
    func convertToDictionary() -> [String: Any]? {
        do {
            return try JSONSerialization.jsonObject(with: self,
                                                    options: []) as? [String: Any]
        } catch {
            print(error.localizedDescription)
        }
        return nil
    }
}

