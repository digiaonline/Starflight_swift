//
//  SFHTTPNetwork.swift
//
//  Created by Ankush Kushwaha on 7/31/18.
//  Copyright © 2018 Ankush Kushwaha. All rights reserved.
//

import Foundation
import UIKit

class SFHTTPNetwork {
    
    var urlRequest :URLRequest?
    
    init?(url: String, postString: String) {
        
        let postData = postString.data(using: .utf8)
        
        let url = URL(string: url)
        var urlRequest = URLRequest(url: url!)  // Note: This is a demo, that's why I use implicitly unwrapped optional
        
        urlRequest.httpMethod = "POST"
        urlRequest.httpBody = postData
        urlRequest.setValue(self.userAgent(), forHTTPHeaderField: "User-Agent")
        urlRequest.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        self.urlRequest = urlRequest
    }
    
    func initiateRequest(completionHandler: @escaping (Data?, URLResponse?, Error?) -> Swift.Void) {
        
        guard let urlRequest = urlRequest else {
            DispatchQueue.main.async {
                completionHandler(nil, nil, nil)
            }
            return
        }
        let defaultSessionConfiguration = URLSessionConfiguration.default
        let defaultSession = URLSession(configuration: defaultSessionConfiguration)
        
        let dataTask = defaultSession.dataTask(with: urlRequest) { (data, response, error) in
            DispatchQueue.main.async {
                completionHandler(data, response, error)
            }
        }
        dataTask.resume()
    }
    
    private func userAgent() -> String {
        
        let device = UIDevice.current
        
        let userAgent = "\(device.systemName)/\(device.systemVersion)"
        
        return userAgent
        
    }
    
}
