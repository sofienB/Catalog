//
//  Networking.swift
//  Articles
//
//  Created by Sofien Benharchache on 20/11/2022.
//

import Foundation

typealias CatalogResult = (Result<[ClassifiedAd], NetworkingError>) -> ()
typealias GenericResult<T: Decodable> = (Result<T, NetworkingError>) -> ()

struct Networking {
    static private let baseUrl = "https://raw.githubusercontent.com"
    static var listingEndPoint: String {
        return baseUrl + "/leboncoin/paperclip/master/listing.json"
    }
    
    /// Find and return local file.
    ///
    /// - Parameter name : file name to read data.
    /// - Parameter type : type to read data. By default "json" file extension is used.
    ///
    /// - Returns: json data if file exist else return nil
    static func localFile(name: String, ofType type: String = "json") -> Data? {
        
        guard let path = Bundle.main.path(forResource: name, ofType: type)
        else { return nil }

        let url = URL(fileURLWithPath: path)

        do { return try Data(contentsOf: url) }
        catch { print(error) }

        return nil
    }
    
    /// Decode to data
    ///
    /// Decode from json data.
    /// If an error occured a Networking Error is catched and passing into result completion.
    ///
    /// - Parameter data : Data json to decode.
    /// - Parameter toType : Expected type to decode.
    /// - Parameter completion : Result of decoded data. Can be succeded or failed with NetworkingError.
    static func decode<T: Decodable>(data: Data, toType: T.Type, _ completion: @escaping GenericResult<T>) {
        do {
            let data = try JSONDecoder().decode(T.self, from: data)
            completion(.success(data))
        } catch {
            completion(.failure(NetworkingError.decoded(error: error)))
        }
    }
    
    /// Get Catalog data
    ///
    /// fetch and decode from specific url.
    /// If an error occured a Networking Error is catched and passing into result completion.
    static func fetchCatalogData(completion: @escaping CatalogResult) {
        let url = URL(string: Networking.listingEndPoint)!
        URLSession.shared.fetchData(for: url, completion: completion)
    }
}

enum NetworkingError: Error {
    case request(error: Error),
         timedOut,
         invalidUrl,
         dataNotFound,
         decoded(error: Error),
         unknown(error: Error)

}
