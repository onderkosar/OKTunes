//
//  NetworkManager.swift
//  OKTunes
//
//  Created by Önder Koşar on 11.09.2020.
//  Copyright © 2020 Önder Koşar. All rights reserved.
//

import UIKit
import RxSwift

class NetworkManager {
    static let shared       = NetworkManager()
    
    private init() {}
    
    func fetch<Model: Decodable>(from URLString: String) -> Observable<Model> {
        return Observable.create { observer -> Disposable in
            let url = URL(string: URLString)
            
            let task = URLSession.shared.dataTask(with: url!) { data, response, error in
                
                if let _            = error { return }
                guard let response  = response as? HTTPURLResponse, response.statusCode == 200 else { return }
                guard let data      = data else { return }
                
                do {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    
                    let obj  = try decoder.decode(Model.self, from: data)
                    
                    observer.onNext(obj)
                    observer.onCompleted()
                    
                } catch let err {
                    observer.onError(err)
                }
            }
            
            task.resume()
            
            return Disposables.create {
                task.cancel()
            }
        }
    }
    
    func downloadImage(from urlString: String, completed: @escaping(UIImage?) -> Void) {
        let cache       = NSCache<NSString, UIImage>()
        let cacheKey    = NSString(string: urlString)
        
        if let image = cache.object(forKey: cacheKey) {
            completed(image)
            return
        }
        
        guard let url = URL(string: urlString) else {
            completed(nil)
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            
            guard let _ = self ,
                error == nil,
                let response = response as? HTTPURLResponse, response.statusCode == 200,
                let data = data,
                let image = UIImage(data: data) else {
                    completed(nil)
                    return
                }
            
            cache.setObject(image, forKey: cacheKey)
            
            completed(image)
        }
        
        task.resume()
    }
}
