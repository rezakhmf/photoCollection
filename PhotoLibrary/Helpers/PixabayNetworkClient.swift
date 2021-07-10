//
//  PixabayNetworkClient.swift
//  PhotoLibrary
//
//  Created by Yurii Petelko on 3/11/20.
//  Copyright © 2020 Squire. All rights reserved.
//

import UIKit

class PixabayNetworkClient {
    enum Error: Swift.Error {
        case objectWasUnexpectedlyDeallocated
        case failedToCreateURL
        case invalidResponse(response: URLResponse?)
        case networkError(error: Swift.Error, response: URLResponse?)
        case parsingError(error: Swift.Error)
    }

    private let apiKey = "15333185-5ec0a04a2ee6bb7f6120de9f8"
    private let baseURLString = "https://pixabay.com/api/"
    private let urlSession = URLSession.shared

    func fetchImageList(for query: String, completion: @escaping (Result<[PhotoInfo], Error>) -> Void) {
        guard let url = URL(string: "\(baseURLString)?key=\(apiKey)&q=\(query)&image_type=photo&per_page=75") else {
            completion(.failure(.failedToCreateURL))
            return
        }

        urlSession.dataTask(with: url) {  [weak self] (jsonData, response, error) in
            guard let self = self else {
                completion(.failure(.objectWasUnexpectedlyDeallocated))
                return
            }
            let result: Result<PhotosCollection, Error> = self.handleResponse(data: jsonData, error: error, response: response)
            completion(result.map { $0.hits })

        }.resume()
    }

    func fetchImage(on urlString: String, completion: @escaping (Result<UIImage, Error>) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(.failure(.failedToCreateURL))
            return
        }

        urlSession.dataTask(with: url) { (jsonData, response, error) in
            if let error = error {
                completion(.failure(.networkError(error: error, response: response)))
            }

            if let image = jsonData.flatMap(UIImage.init(data:)) {
                completion(.success(image))
            } else {
                let decodingError = NSError(domain: "com.photoLibrary.PixabayNetworkClient", code: -1, userInfo: nil)
                completion(.failure(.parsingError(error: decodingError)))
            }
        }.resume()
    }

    private func handleResponse<Type: Decodable>(
        data: Data?, error: Swift.Error?, response: URLResponse?) -> Result<Type, Error> {
        if let error = error {
            return .failure(.networkError(error: error, response: response))
        }

        if let jsonData = data {
            do {
                return .success(try JSONDecoder().decode(Type.self, from: jsonData))
            } catch {
                return .failure(.parsingError(error: error))
            }
        } else {
            return .failure(.invalidResponse(response: response))
        }
    }
}
