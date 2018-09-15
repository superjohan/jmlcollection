//
//  BlurredLabel.swift
//  demo
//
//  Adapted from https://stackoverflow.com/a/30305200
//

import UIKit

class BlurredLabel: UILabel {
    var blurredText: String? {
        get {
            return self.text
        }
        
        set {
            super.text = text
            
            UIGraphicsBeginImageContextWithOptions(self.bounds.size, false, 0)
            self.layer.render(in: UIGraphicsGetCurrentContext()!)
            guard let image = UIGraphicsGetImageFromCurrentImageContext() else { return }
            UIGraphicsEndImageContext()
            
            guard let blurFilter = CIFilter(name: "CIGaussianBlur") else { return }
            blurFilter.setDefaults()
            
            let imageToBlur = CIImage(cgImage: image.cgImage!)
            blurFilter.setValue(imageToBlur, forKey: kCIInputImageKey)
            blurFilter.setValue(50.0, forKey: "inputRadius")
            
            guard let outputImage = blurFilter.outputImage else { return }
            let croppedImage = outputImage.cropped(to: CGRect(x: 0, y: 0, width: self.bounds.size.width * image.scale, height: self.bounds.size.height * image.scale))
            let context = CIContext(options: nil)
            guard let cgImage = context.createCGImage(croppedImage, from: croppedImage.extent) else { return }
            
            self.layer.contents = cgImage
        }
    }
}
