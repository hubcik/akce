//
//  APIClient.swift
//  AKCE
//
//  Created by Hubert Gostomski on 28/12/2018.
//  Copyright © 2018 Hubert Gostomski. All rights reserved.
//

import UIKit

enum APIHTTPMethod {
    case APIHTTPMethodGet
    case APIHTTPMethodPost
    case APIHTTPMethodPatch
    case APIHTTPMethodMultipartPost
    case APIHTTPMethodPut
    case APIHTTPMethodDelete
}

class APIClient: AFHTTPSessionManager {

    var authToken: String = ""
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    public init(baseURL: URL)
    {
        super.init(baseURL: baseURL, sessionConfiguration: nil)
    }

    public func useSerialiserForHTTPMethod(method: APIHTTPMethod)
    {
        if (method == .APIHTTPMethodMultipartPost) {
            let serializer: AFHTTPRequestSerializer = AFHTTPRequestSerializer()
            self.requestSerializer = serializer
        } else {
            let serializer: AFJSONRequestSerializer = AFJSONRequestSerializer.init()
            self.requestSerializer = serializer
        }
    }
    
    func getItems(path: String, parameters: Any?, onFinish: @escaping (NSInteger, Any?, String)-> Void) {
        self.useSerialiserForHTTPMethod(method: .APIHTTPMethodGet)
        self.requestSerializer.setValue("application/json", forHTTPHeaderField:"Content-Type")
        
        self.get(path, parameters: parameters, progress: nil, success: { (task: URLSessionDataTask!, responseObject: Any?) in
            let response: HTTPURLResponse = task.response as! HTTPURLResponse;
            onFinish(response.statusCode, responseObject, "")
            
        }, failure: { (task: URLSessionDataTask?, error: Error) in
            let response: HTTPURLResponse? = task?.response as? HTTPURLResponse;
            if (response != nil) {
                onFinish(response!.statusCode, nil, error.localizedDescription)
            }
            else {
                onFinish(-1, nil, error.localizedDescription)
            }
        })
    }


}
