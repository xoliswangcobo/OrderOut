//
//  UIImageView+Download.swift
//  OrderOut
//
//  Created by Xoliswa on 2020/08/31.
//  Copyright © 2020 Xoliswa. All rights reserved.
//

import UIKit

extension UIImageView {
    
    func download(url: URL) {
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else { return }

            DispatchQueue.main.async() {
                self.image = UIImage(data: data)
            }
        }

        task.resume()
    }
}
