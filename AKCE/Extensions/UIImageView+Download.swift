//
//  UIImageView+Download.swift
//  AKCE
//
//  Created by Hubert Gostomski on 28/12/2018.
//  Copyright © 2018 Hubert Gostomski. All rights reserved.
//

import UIKit

extension UIImageView {

    private static var taskKey = 0
    private static var urlKey = 0

    private var currentTask: URLSessionTask? {
        get { return objc_getAssociatedObject(self, &UIImageView.taskKey) as? URLSessionTask }
        set { objc_setAssociatedObject(self, &UIImageView.taskKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }

    private var currentURL: URL? {
        get { return objc_getAssociatedObject(self, &UIImageView.urlKey) as? URL }
        set { objc_setAssociatedObject(self, &UIImageView.urlKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }

    public func loadImageAsync(with urlString: String?) {
        weak var oldTask = currentTask
        currentTask = nil
        oldTask?.cancel()

        self.image = nil
        self.alpha = 0

        guard let urlString = urlString else { return }

        let config = URLSessionConfiguration.default
        config.requestCachePolicy = .reloadIgnoringLocalCacheData
        config.urlCache = nil

        let url = URL(string: urlString)!
        currentURL = url
        let task = URLSession.init(configuration: config).dataTask(with: url) { [weak self] data, response, error in
            self?.currentTask = nil

            if let error = error {
                if (error as NSError).domain == NSURLErrorDomain && (error as NSError).code == NSURLErrorCancelled {
                    return
                }
                print(error)
                return
            }

            guard let data = data, let downloadedImage = UIImage(data: data) else {
                print("Unable to extract image.")
                return
            }

            if url == self?.currentURL {
                DispatchQueue.main.async {
                    self?.image = downloadedImage
                    UIView.animate(withDuration: 0.3, animations: {
                        self?.alpha = 1
                    })
                }
            }
        }

        currentTask = task
        task.resume()
    }
}
