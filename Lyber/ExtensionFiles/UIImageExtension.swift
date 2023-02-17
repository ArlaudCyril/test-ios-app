//
//  UIImageExtension.swift
//  Lyber
//
//  Created by sonam's Mac on 31/08/22.
//

import Foundation
import UIKit
import SVGKit

extension UIImageView{
    func setSvgImage(from url: URL?) {
        URLSession.shared.dataTask(with: url ?? URL(fileURLWithPath: "")) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let receivedicon: SVGKImage = SVGKImage(data: data),
                let image = receivedicon.uiImage
            else { return }
            DispatchQueue.main.async() {
                self.image = image
            }
        }.resume()
    }
    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage? {
        let size = image.size
        
        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio, height: size.height * widthRatio)
        }
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(origin: .zero, size: newSize)
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
   
    
}

extension UIImage{
    func roundedImageWithBorder(width: CGFloat, color: UIColor) -> UIImage? {
            let square = CGSize(width: min(size.width, size.height) + width * 2, height: min(size.width, size.height) + width * 2)
            let imageView = UIImageView(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: square))
            imageView.contentMode = .center
            imageView.image = self
            imageView.layer.cornerRadius = square.width/2
            imageView.layer.masksToBounds = true
            imageView.layer.borderWidth = width
            imageView.layer.borderColor = color.cgColor
            UIGraphicsBeginImageContextWithOptions(imageView.bounds.size, false, scale)
            guard let context = UIGraphicsGetCurrentContext() else { return nil }
            imageView.layer.render(in: context)
            var result = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            result = result?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
            return result
        }
    public class func gif(name: String) -> UIImage? {
           // Check for existance of gif
           guard let bundleURL = Bundle.main
               .url(forResource: name, withExtension: "gif") else {
                   //print("SwiftGif: This image named \"\(name)\" does not exist")
                   return nil
           }
           
           // Validate data
           guard let imageData = try? Data(contentsOf: bundleURL) else {
               //print("SwiftGif: Cannot turn image named \"\(name)\" into NSData")
               return nil
           }
           
           return gif(data: imageData)
       }
    
    public class func gif(data: Data) -> UIImage? {
           // Create source from data
           guard let source = CGImageSourceCreateWithData(data as CFData, nil) else {
               //print("SwiftGif: Source for the image does not exist")
               return nil
           }
           
           return UIImage.animatedImageWithSource(source)
       }
}
