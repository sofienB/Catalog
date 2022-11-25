//
//  URLSession+Extension.swift
//  Articles
//
//  Created by Sofien Benharchache on 20/11/2022.
//

import Foundation

extension URLSession {
    func fetchData<T: Decodable>(for url: URL, completion: @escaping (Result<T, NetworkingError>) -> Void) {
        self.dataTask(with: url) { (data, response, error) in
            guard error == nil
            else { completion(.failure(.request(error: error!))); return }
            
            guard let data = data
            else { completion(.failure(NetworkingError.dataNotFound)); return }
            
            Networking.decode(data: data, toType: T.self, completion)
        }.resume()
    }
}
