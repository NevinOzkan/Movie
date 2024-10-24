//
//  ResourceLoader.swift
//  Movie
//
//  Created by Nevin Özkan on 24.10.2024.
//

import Foundation
import MovieAPI

class ResourceLoader {
    
    enum MovieResource: String {
        case movie1
        case movie2
        case movie3
    }
    
    static func loadMovie(resource: MovieResource) throws -> Movie {
        let bundle = Bundle.test
        guard let url = bundle.url(forResource: resource.rawValue, withExtension: "json") else {
            throw NSError(domain: "ResourceLoaderError", code: 404, userInfo: [NSLocalizedDescriptionKey: "Kaynak bulunamadı"])
        }
        let data = try Data(contentsOf: url)
        let decoder = Decoders.releaseDateDecoder
        let movie = try decoder.decode(Movie.self, from: data)
        return movie
    }
}

private extension Bundle {
    class Dummy { }
    static let test = Bundle(for: Dummy.self)
}
