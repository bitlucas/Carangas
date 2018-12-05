//
//  REST.swift
//  Carangas
//
//  Created by Lucas Bitar on 18/09/18.
//  Copyright © 2018 Eric Brito. All rights reserved.
//

import Foundation

enum CarErrorList {
    case url
    case taskError(error: Error)
    case noResponse
    case noData
    case responseStatusCode(code: Int)
    case invalidJSON
}


enum RESTOperation {
    case save
    case update
    case delete
}


class REST {
    
    private static let basePath = "https://carangas.herokuapp.com/cars"
    private static let configuration: URLSessionConfiguration = {
        let config = URLSessionConfiguration.default
        config.allowsCellularAccess = false
        config.httpAdditionalHeaders = ["Content-Type": "application/json"]
        config.timeoutIntervalForRequest = 30.0
        config.httpMaximumConnectionsPerHost = 5
        return config
    }()
    private static let session = URLSession(configuration: configuration)

    class func loadCars(onComplete: @escaping ([Car]) -> Void, onError: @escaping (CarErrorList) -> Void){
        guard let url = URL(string: basePath) else {
            onError(.url)
            return
        }
        
        let dataTask = session.dataTask(with: url) { (data: Data?, response: URLResponse?, error: Error?) in
            if error == nil {
                guard let response = response as? HTTPURLResponse else {
                    onError(.noResponse)
                    return
                }
                if response.statusCode == 200 {
                    guard let data = data else {
                        onError(.noData)
                        return
                    }
                    do {
                        let cars = try JSONDecoder().decode([Car].self, from: data)
                        onComplete(cars)
                    } catch {
                        onError(.invalidJSON)
                        print(error.localizedDescription)
                        }
                    } else {
                    onError(.responseStatusCode(code: response.statusCode))
                    }
            } else {
                onError(.taskError(error: error!))
            }
        }
    dataTask.resume()
    }
    
    class func save(car: Car, onComplete: @escaping (Car) -> Void, onError: @escaping (CarErrorList) -> Void ){
        applyOperation(car: car, operation: .save, onComplete: onComplete, onError: onError)
    }
    
    
    class func update(car: Car, onComplete: @escaping (Car) -> Void, onError: @escaping (CarErrorList) -> Void ){
        applyOperation(car: car, operation: .update, onComplete: onComplete, onError: onError)
    }
    
    class func delete(car: Car, onComplete: @escaping (Car) -> Void, onError: @escaping (CarErrorList) -> Void ){
        applyOperation(car: car, operation: .delete, onComplete: onComplete, onError: onError)
    }
    
    private class func applyOperation(car : Car, operation : RESTOperation, onComplete: @escaping (Car) -> Void, onError: @escaping (CarErrorList) -> Void){
        
        let basePathWithID = basePath + "/" + (car._id ?? "")
        guard let url = URL(string: basePathWithID) else {
            onError(.url)
            return
        }
        var request = URLRequest(url: url)
        var httpMethod : String = ""
        
        switch operation {
        case .save:
            httpMethod = "POST"
        case .update:
            httpMethod = "PUT"
        case .delete:
            httpMethod = "DELETE"
        }
        request.httpMethod = httpMethod
        
        guard let json = try? JSONEncoder().encode(car) else {
            onError(.invalidJSON)
            return }
        request.httpBody = json
        
        let dataTask = session.dataTask(with: request) { (data, response, error) in
            if error == nil {
                guard let response = response as? HTTPURLResponse else {
                    onError(.noResponse)
                    return }
                if response.statusCode == 200 {
                    guard let data = data else {
                        onError(.noData)
                        return }
                    print(data)
                    onComplete(car)
                } else {
                    onError(.responseStatusCode(code: response.statusCode))
                }
            } else {
                onError(.taskError(error: error!))
            }
        }
        dataTask.resume()
       
    }
}
