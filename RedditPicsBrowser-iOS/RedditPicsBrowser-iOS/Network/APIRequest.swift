//
//  APIRequest.swift
//  RedditPicsBrowser-iOS
//
//  Created by Anoop Gunaga on 01/10/21.
//
import Foundation
import Reachability

enum RequestType {
    case redditPics
}

enum RequestContentType: String {
    case json = "application/json"
    case urlEncoded = "application/x-www-form-urlencoded"
}

enum RequestMethod: String {
    case get = "GET"
    case post = "POST"
    case delete = "DELETE"
}

enum ErrorType {
    case noNetworkError
    case responseError
    case apiRequestError    
}

class APIRequest {
    static func request(
        type: RequestType,
        contentType: RequestContentType,
        requestMethod: RequestMethod,
        parameters: [String: Any] = [:],
        completion: @escaping ((Any?) -> Void),
        errorHandler: @escaping ((ErrorType, Error?) -> Void)) {
            if !Utilities.isInternetConnectivityAvailable {
                errorHandler(.noNetworkError, nil)
                return
            }
            
            guard let url = url(forType: type) else { return }
            var request = URLRequest(url: url)
            request.httpBody = httpBody(parameters: parameters)
            request.setValue(
                contentType.rawValue,
                forHTTPHeaderField: "Content-Type")
            request.httpMethod = requestMethod.rawValue
            
            
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data,
                      let _ = response as? HTTPURLResponse,
                      error == nil else {
                          errorHandler(.apiRequestError, error)
                          return
                      }
                
                let responseObj = parseJSONData(
                    requestType: type,
                    data: data)
                completion(responseObj)
            }
            task.resume()
        }
    
    static private func parseJSONData(
        requestType: RequestType,
        data: Data) -> Any? {
            switch requestType {
            case .redditPics: return redditImageData(data: data)
            }
    }
    
    static private func redditImageData(data: Data) -> RedditPicsModel? {
        do {
            let redditPicsInfo = try JSONDecoder().decode(RedditPicsModel.self, from: data)
            return redditPicsInfo
        } catch let error {
            debugPrint("JSON decode error: \(error.localizedDescription)")
        }
        return nil
    }
}


private extension APIRequest {
    static func url(forType type: RequestType) -> URL? {
        switch type {
        case .redditPics: return URL.redditPicsURL
        }
    }
    
    static func httpBody(parameters: [String: Any]) -> Data? {
        let urlParams = parameters.compactMap({ (key, value) -> String in
            return "\(key)=\(value)"
        }).joined(separator: "&")
        return Data(base64Encoded: urlParams.urlEncode() ?? "")
    }
}

