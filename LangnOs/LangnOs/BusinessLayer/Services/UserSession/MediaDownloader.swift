//
//  MediaHelper.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 30.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import Foundation

protocol MediaDownloadableProtocol {
    func downloadMedia(url: URL, onSucces: @escaping (Data) -> Void, onFailure: @escaping (Error) -> Void)
}

final class MediaDownloader {
    
    // MARK: - Private properties
    
    private var session: URLSession
    
    init() {
        let configuration = URLSessionConfiguration.default
        configuration.urlCache = URLCache(memoryCapacity: 50 * DataSize.MB,
                                          diskCapacity: 50 * DataSize.MB,
                                          diskPath: "images")
        configuration.httpMaximumConnectionsPerHost = 5
        
        session = URLSession(configuration: configuration, delegate: nil, delegateQueue: OperationQueue.main)
    }
    
}

// MARK: - MediaDownloadableProtocol

extension MediaDownloader: MediaDownloadableProtocol {
    
    func downloadMedia(url: URL, onSucces: @escaping (Data) -> Void, onFailure: @escaping (Error) -> Void) {
        session.dataTask(with: url) { (data, response, error) in
            if let error = error {
                onFailure(error)
            } else if let response = response as? HTTPURLResponse, response.statusCode == 200, let data = data {
                onSucces(data)
            }
        }.resume()
    }
    
}

// MARK: - DataSize

extension MediaDownloader {
    
    private enum DataSize {
        static let MB = 1024 * 1024
    }
    
}
