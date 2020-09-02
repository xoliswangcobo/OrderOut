//
//  URLRequestClientService.swift
//  OrderOut
//
//  Created by Xoliswa on 2020/08/29.
//  Copyright © 2020 Xoliswa. All rights reserved.
//

import Foundation

class URLRequestClientService : HTTPClientService {
    
    var host: URL
    
    init(host: URL) {
        self.host = host
    }
    
    func execute<Model : Decodable>(client: HTTPClientTask, responseHandler: @escaping (Error?, Model?) -> Void) {
        self.execute(client: client) { (error, response) in
            if let theResponse = response {
                do {
                    responseHandler(error, try Model.decode(theResponse))
                } catch (let e) {
                    responseHandler(e, nil)
                }
            } else {
                responseHandler(error, nil)
            }
        }
    }
    
    func execute(client: HTTPClientTask, responseHandler: @escaping (Error?, Any?) -> Void) {
        self.execute(client: client) { (error:Error?, data:Data?) in
            if let theResponseData = data {
                do {
                    let responseObject = try JSONSerialization.jsonObject(with: theResponseData, options: [])
                    print("APICore Response: \(String(format: "%@%@ -: %@", self.host.absoluteString, client.path, (responseObject as? [String : Any])?.jsonString() ?? ""))")
                    
                    if error != nil {
                        responseHandler(error, responseObject)
                    } else {
                        responseHandler(nil, responseObject)
                    }
                } catch let tryError {
                    responseHandler(tryError, nil)
                }
            } else {
                responseHandler(error, nil)
            }
        }
    }
    
    func execute(client: HTTPClientTask, responseHandler: @escaping (Error?, Data?) -> Void) {
        
        var components = URLComponents(url: self.host, resolvingAgainstBaseURL: true)!
        components.path = components.path + client.path
        
        guard let url = components.url else {
            responseHandler(nil, nil)
            return
        }

        print("APICoreRequest: \(String(format: "%@%@ -: %@", self.host.absoluteString, client.path, client.parameters.jsonString() ?? ""))")
        
        var request:URLRequest = URLRequest(url: url)
        
        // Content Type
        if (client.encoding == .application_form_urlencoded) {
            components.queryItems = client.parameters.map({ parameter in URLQueryItem(name: parameter.key, value: parameter.value as? String) })
            
            // URL for Get Request
            if client.method == .GET {
                request = URLRequest(url: components.url!)
            } else {
                request.httpBody = components.query?.data(using: .utf8)
            }
        } else if (client.encoding == .application_json) {
            if let theData = try? JSONSerialization.data(withJSONObject: client.parameters, options: []) {
                request.httpBody = theData
            }
        } else if (client.encoding == .multipart_form_data), let uploadData = client.uploadData {
            request.httpBody = uploadData
        }
        
        // HTTP Method
        request.httpMethod = client.method.rawValue
        
        // HTTP Headers
        for header in client.headers {
            request.setValue(header.value, forHTTPHeaderField: header.key)
        }
        
        request.setValue(client.acceptType.rawValue, forHTTPHeaderField: "Accept")
        request.setValue(client.encoding.rawValue, forHTTPHeaderField: "Content-Type")
        
        // Set Timeout
        request.timeoutInterval = 15
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                responseHandler(error, data)
            }
        }
        
        task.resume()
    }
}
