//
//  ImageViewFromURL.swift
//  AKCE
//
//  Created by Hubert Gostomski on 28/12/2018.
//  Copyright © 2018 Hubert Gostomski. All rights reserved.
//

import UIKit

class ImageViewFromURL: UIImageView {
    
    var downloadForURL: String?
    var task: URLSessionDataTask?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.clear
        self.contentMode = .scaleAspectFill
        
        self.clipsToBounds = true
    }
    
    public func setURL(url: String) {
        self.downloadForURL = url
        
        self.downloadImage(url:URL.init(string: downloadForURL!)!)
    }
    
    func getDataFromUrl(url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        
        if self.task != nil {
            task?.cancel()
        }
        
        self.task = URLSession.shared.dataTask(with: url) { data, response, error in
            completion(data, response, error)
        }
        task?.resume()
    }
    
    func downloadImage(url: URL) {
        
        getDataFromUrl(url: url) { data, response, error in
            guard let data = data, error == nil else {
                return
            }
            DispatchQueue.main.async() {
                if self.downloadForURL == url.absoluteString {
                    self.alpha = 0
                    let img:UIImage? = UIImage(data: data)
                    if img != nil {
                        self.image = img
                        UIView.animate(withDuration: 0.3, animations: {
                            self.alpha = 1
                        })
                    }
                }
            }
        }
    }
}
