//
//  ImagesURL.swift
//  Articles
//
//  Created by Sofien Benharchache on 14/11/2022.
//

import Foundation

struct ImagesURL: Hashable {
    let small: String?
    let thumb: String?
    
    var _smallData: Data?
    private var _thumbData: Data?

    var smallData: Data? {
        return _smallData
    }
    
    var thumbData: Data? {
        return _thumbData
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(identifier)
        
        hasher.combine(small)
        hasher.combine(thumb)
    }
    
    private var identifier: UUID { return UUID() }

    init(small: String?, thumb: String?) {
        self.small = small
        self.thumb = thumb
    }
}

extension ImagesURL: Codable, Equatable {
    /*static func == (lhs: ImagesURL, rhs: ImagesURL) -> Bool {
        return lhs.identifier == rhs.identifier
    }*/
}

extension ImagesURL {
    var downloadSmall: Data? {
        mutating get async throws {
            if let _smallData {
                return _smallData
            }
            guard let small, small.isURL,
                  let url = URL(string: small)
            else { return nil }
            
            
            let data = try Data(contentsOf: url)
            self._smallData = data
            return data
        }
    }
    
    var downloadThumb: Data? {
        mutating get async throws {
            if let _thumbData {
                return _thumbData
            }
            guard let thumb, thumb.isURL,
                  let url = URL(string: thumb)
            else { return nil }
            
            
            let data = try Data(contentsOf: url)
            self._thumbData = data
            return data
        }
    }
}
