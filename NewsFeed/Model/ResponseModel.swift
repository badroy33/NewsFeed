//
//  ResponseModel.swift
//  NewsFeed
//
//  Created by Maksym Levytskyi on 11.07.2021.
//

import Foundation
import  UIKit

struct ResponseModel: Decodable {
    let status: String
    let totalResults: Int
    let articles: [NewsModel]
}

struct NewsModel: Decodable {
    let source: SourceModel
    let author: String?
    let title: String
    let description: String?
    let urlToImage: String?
    let publishedAt: String
    let url: String
}

struct SourceModel: Decodable {
    let id: String?
    let name: String
}

//MARK: - For source filter

struct SourceResponse: Decodable {
    let sources: [NewsSource]
}

struct NewsSource: Decodable {
    let id: String
    let name: String
}




