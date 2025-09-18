//
//  BaseNetworkManager.swift
//  WeatherAppUIKit
//
//  Created by Rovshan Rasulov on 18.09.25.
//

import Foundation
import Combine

protocol NetworkService{
    func fetchData<T: Decodable>(from url: URL) -> AnyPublisher<T, Error>
}


struct BaseNetworkService: NetworkService{
    func fetchData<T>(from url: URL) -> AnyPublisher<T, any Error> where T : Decodable {
        URLSession.shared.dataTaskPublisher(for: url)
            .tryMap { output in
                guard let httpResponse = output.response as? HTTPURLResponse else{
                    throw NetworkErrors.invalidResponse
                }
                
                guard (200...299).contains(httpResponse.statusCode) else{
                    if httpResponse.statusCode == 404{
                        throw NetworkErrors.notFound
                    }
                    throw NetworkErrors.invalidResponse
                }
                return output.data
            }
            .decode(type: T.self, decoder: {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                return decoder
            }())
            .mapError { error -> Error in
                if let decodingError = error as? DecodingError{
                    print("Decoding error: \(decodingError)")
                    return decodingError
                }
                print("Decoding faild: \(error)")
                return NetworkErrors.decodingError(error)
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
