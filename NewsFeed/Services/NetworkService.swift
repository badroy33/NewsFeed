//
//  NetworkService.swift
//  NewsFeed
//
//  Created by Maksym Levytskyi on 09.07.2021.
//

import Foundation
import UIKit


class NetworkService {
    
    func makeRequest(urlString: String, completion: @escaping (Result<[NewsModel], Error>) -> Void) {
        
        guard let url = URL(string: urlString) else {
            print("Invalid url")
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else { return }
            
            DispatchQueue.main.async {
                do {
                    let responseModel = try JSONDecoder().decode(ResponseModel.self, from: data)
                    completion(.success(responseModel.articles))
                } catch let error {
                    completion(.failure(error))
                    print(String(describing: error))
                }
            }
        }.resume()
    }
    
    //MARK: - Get sources for FilterViewController.
    
    func getSources(urlString: String, completion: @escaping (Result<[NewsSource], Error>) -> Void) {
        guard let url = URL(string: urlString) else {
            print("Invalid url")
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else { return }
            
            DispatchQueue.main.async {
                do {
                    let responseModel = try JSONDecoder().decode(SourceResponse.self, from: data)
                    completion(.success(responseModel.sources))
                } catch let error {
                    completion(.failure(error))
                    print(String(describing: error))
                }
            }
        }.resume()
    }
}
