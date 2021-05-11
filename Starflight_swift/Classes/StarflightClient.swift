//
//  StarflightClient.swift
//
//  Created by Ankush Kushwaha on 7/31/18.
//  Copyright © 2018 starcut. All rights reserved.
//

import Foundation

public class StarflightClient {
    
    private var appId: String?
    private var clientSecret: String?
    
    public init(appId: String, clientSecret: String) {
        
        self.appId = appId
        self.clientSecret = clientSecret
    }
    
    private func starflightUrl() -> String {
        return "https://starflight.starcloudalias.link/push"
    }
    
   public func registerWithToken(token: String,
                           clientUUID: String?,
                           tags: [String]?,
                           timePreferences: String?,
                           completionHandler:((Dictionary<String, Any>?, HTTPURLResponse?, Error?) -> Swift.Void)?) {
        
        guard let appId = self.appId, let clientSecret = self.clientSecret else {
            print("Starflight appId and clientSecret is not provided.")
            
            if let completionHandler = completionHandler {
                completionHandler(nil, nil, nil)
            }
            return
        }
        
        var postString = "action=register&appId=\(appId)&clientSecret=\(clientSecret)&type=ios&token=\(token)"
        
        if let clientUUID = clientUUID {
            postString = postString + "&clientUuid=\(clientUUID)"
        }
        
        if let tagsToRegister = tags?.joined(separator: ",") {
            postString = postString + "&tags=\(tagsToRegister)"
        }
        
        if let timePreferences = timePreferences {
            postString = postString + "&timePreferences=\(timePreferences)"
        }
        
        startHttpRequest(postString: postString, completionHandler: completionHandler)
        
    }
    
   public func unregister(token: String,
                    tags: [String]?,
                    completionHandler: ((Dictionary<String, Any>?, HTTPURLResponse?, Error?) -> Swift.Void)?) {
        
        guard let appId = self.appId, let clientSecret = self.clientSecret else {
            print("Starflight appId and clientSecret is not provided.")
            
            if let completionHandler = completionHandler {
                completionHandler(nil, nil, nil)
            }
            return
        }
        
        var postString = "action=unregister&appId=\(appId)&clientSecret=\(clientSecret)&type=ios&token=\(token)"
        if let tagsToRemove = tags?.joined(separator: ",") {
            postString = postString + "&tags=\(tagsToRemove)"
        }
        
        startHttpRequest(postString: postString, completionHandler: completionHandler)
    }
    
   public func openedMessage(token: String, messageUuid: String,
                       completionHandler: ((Dictionary<String, Any>?, HTTPURLResponse?, Error?) -> Swift.Void)?) {
        
        guard let appId = self.appId, let clientSecret = self.clientSecret else {
            print("Starflight appId and clientSecret is not provided.")
            
            if let completionHandler = completionHandler {
                completionHandler(nil, nil, nil)
            }
            return
        }
        let postString = "action=message_opened&appId=\(appId)&clientSecret=\(clientSecret)&type=ios&token=\(token)&uuid=\(messageUuid)"
        
        startHttpRequest(postString: postString, completionHandler: completionHandler)
        
    }
    
    private func startHttpRequest(postString: String,
                                  completionHandler: ((Dictionary<String, Any>?, HTTPURLResponse?, Error?) -> Swift.Void)?){
        
        //        print(postString)
        
        let http = SFHTTPNetwork(url: starflightUrl(), postString: postString)
        
        http?.initiateRequest(completionHandler: { (data, response, error) in
            
            if error != nil {
                
                if let completionHandler = completionHandler {
                    
                    completionHandler(nil, nil, error) // internet error
                }
                
                return
            }
            
            let httpResponse = response as? HTTPURLResponse
            
            let responseDict = data?.convertToDictionary()
            
            guard let statusCode = httpResponse?.statusCode else {
                
                let error = NSError(domain:"com.starflight.SomethingWentWrong", code:-1, userInfo:nil)
                
                if let completionHandler = completionHandler {
                    
                    completionHandler(responseDict, httpResponse, error) // no error from backend, even internet is on
                }
                return
            }
            
            if statusCode == 200 || statusCode == 201 {
                
                if let completionHandler = completionHandler {
                    
                    completionHandler(responseDict, httpResponse, nil) // success
                }
                
                return
            }
            
            let error = NSError(domain:"com.starflight.backendError", code:statusCode, userInfo:nil)
            
            if let completionHandler = completionHandler {
                
                completionHandler(responseDict, httpResponse, error) // error response from Backend
            }
            
        })
    }
}
