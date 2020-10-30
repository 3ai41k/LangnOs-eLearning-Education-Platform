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

final class MediaDownloader { }

// MARK: - MediaDownloadableProtocol

extension MediaDownloader: MediaDownloadableProtocol {
    
    // MARK: Refactot it
    
    func downloadMedia(url: URL, onSucces: @escaping (Data) -> Void, onFailure: @escaping (Error) -> Void) {
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                onFailure(error)
            } else if let response = response as? HTTPURLResponse, response.statusCode == 200, let data = data {
                onSucces(data)
            }
        }.resume()
    }
    
}
