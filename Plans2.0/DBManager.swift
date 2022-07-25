//
//  DBManager.swift
//  Plans2.0
//
//  Created by Abud Salem on 4/13/22.
//

import Foundation


class DBManager {
    
    public struct PostStruct: Decodable {
        enum Category: String, Decodable{
            case swift, combine, debugging, xcode
        }
        let error: Bool
        let message: String
    }
    
    //sends the request to the url with the parameters and returns the string response. uses postStruct to decode the JSON response.
    public func postRequest(_ url : URL, _ parameters: [String: Any]) -> String {
        var request = URLRequest(url: url)
        var message: String = "No Response Found"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        request.httpBody = parameters.percentEncoded()
            
        let sem = DispatchSemaphore.init(value: 0)
            
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            defer { sem.signal() }
            guard let data = data,
                let response = response as? HTTPURLResponse,
                error == nil else {                                              // check for fundamental networking error
                print("error", error ?? "Unknown error")
                return
            }
            guard (200 ... 299) ~= response.statusCode else {                    // check for http errors
                print("statusCode should be 2xx, but is \(response.statusCode)")
                //print("response = \(response)")
                return
            }
            
            let responseString = String(data: data, encoding: .utf8)
                
            //print("responseString = \(responseString!)")
            if let dataK = responseString {
                let jsonData = dataK.data(using: .utf8)!
                let resp: PostStruct = try! JSONDecoder().decode(PostStruct.self, from: jsonData)
                message = resp.message
            }
        }
        task.resume()
        sem.wait()
        //print(message)
        return message
    }
    
    public func getRequest(_ url : URL) -> [String] {
        var request = URLRequest(url: url)
        var message: String = "No Response Found"
        var stringArray : [String] = []
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "GET"
        
        let sem = DispatchSemaphore.init(value: 0)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            defer { sem.signal() }
            guard let data = data,
                let response = response as? HTTPURLResponse,
                error == nil else {                                              // check for fundamental networking error
                print("error", error ?? "Unknown error")
                return
            }

            guard (200 ... 299) ~= response.statusCode else {                    // check for http errors
                print("statusCode should be 2xx, but is \(response.statusCode)")
                print("response = \(response)")
                return
            }
            
            let responseString = String(data: data, encoding: .utf8)
            stringArray = self.separateEntities(responseString!)
            
            
            message = responseString!
            //print("responseString = \(responseString!)")
        }
        task.resume()
        sem.wait()
        //print(message)
        return stringArray
}

    private func separateEntities(_ string: String) -> [String] {
        var open = 0
        var currentString = ""
        var stringArr : [String] = []
        for char in string {
            if char == "{" {
                open = 1
            }
            if open == 1 {
                currentString.append(char)
            }
            if open == 0 {
                if currentString != "" {
                    stringArr.append(currentString);
                    currentString = ""
                }
            }
            if char == "}" {
                open = 0
            }
        }
        return stringArr
    }
    
}
extension Dictionary {
    func percentEncoded() -> Data? {
        return map { key, value in
            let escapedKey = "\(key)".addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowed) ?? ""
            let escapedValue = "\(value)".addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowed) ?? ""
            return escapedKey + "=" + escapedValue
        }
        .joined(separator: "&")
        .data(using: .utf8)
    }
}

extension CharacterSet {
    static let urlQueryValueAllowed: CharacterSet = {
        let generalDelimitersToEncode = ":#[]@"
        let subDelimitersToEncode = "!$&'()*+,;="

        var allowed = CharacterSet.urlQueryAllowed
        allowed.remove(charactersIn: "\(generalDelimitersToEncode)\(subDelimitersToEncode)")
        return allowed
    }()
}
