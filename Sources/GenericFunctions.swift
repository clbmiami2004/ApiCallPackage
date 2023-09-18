//
//  File.swift
//  
//
//  Created by Christian Lorenzo on 9/18/23.
//

import Foundation
import UIKit

public class GenericFunctions: UIViewController {
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
}

public class webServices {
    
    enum CustomError: Error {
        case invalidUrl
        case invalidData
    }
    
    public init() { }
    
    public func request<T: Codable>(url: URL?, expecting: T.Type, completion: @escaping (Result<T, Error>) -> Void) {
        
        guard let url = url else {
            completion(.failure(CustomError.invalidUrl))
            return
        }
        
        let task = self.dataTask(with: url) { data, response, error in
            guard let data = data,
                  (response as? HTTPURLResponse)?.statusCode == 200 else {
                if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.failure(CustomError.invalidData))
                }
                return
            }
            
            do {
                let result = try JSONDecoder().decode(expecting, from: data)
                completion(.success(result))
            } catch {
                completion(.failure(error))
            }
            
        }
        
        task.resume()
    }
}
