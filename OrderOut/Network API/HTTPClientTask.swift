//
//  HTTPClientTask.swift
//  OrderOut
//
//  Created by Xoliswa on 2020/08/29.
//  Copyright © 2020 Xoliswa. All rights reserved.
//

import Foundation

enum HTTPRequestMethod: String {
    case GET, POST, PUT, PATCH, DELETE
}

enum HTTPContentType: String {
    case application_json = "application/json"
    case application_form_urlencoded = "application/x-www-form-urlencoded"
    case multipart_form_data = "multipart/form-data"
    case none = ""
}

enum HTTPAcceptType: String {
    case application_json = "application/json"
    case application_xml = "application/xml"
    case text_plain = "text/plain"
}

protocol HTTPClientTask {
    var path: String { get }
    var parameters : [String : Any] { get }
    var uploadData : Data? { get }
    var headers : [String : String] { get }
    var method : HTTPRequestMethod { get }
    var encoding : HTTPContentType { get }
    var acceptType : HTTPAcceptType { get }
}

extension HTTPClientTask {
    
    var parameters : [String : Any]  { [:] }
    
    var uploadData : Data? { nil }
    
    var encoding : HTTPContentType { .application_form_urlencoded }
    
    var acceptType : HTTPAcceptType { .application_json }
    
    var headers : [String : String] { [:] }
    
}
