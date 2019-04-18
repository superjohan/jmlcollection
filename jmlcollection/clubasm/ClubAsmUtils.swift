//
//  ClubAsmUtils.swift
//  demo
//
//  Created by Johan Halin on 15/04/2019.
//  Copyright © 2019 Dekadence. All rights reserved.
//

import UIKit

class ClubAsmUtils {
    static func circle(diameter: CGFloat, color: UIColor) -> UIImage {
        let rect = CGRect(origin: CGPoint.zero, size: CGSize(width: diameter, height: diameter))
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.fillColor = color.cgColor
        shapeLayer.lineWidth = 1
        shapeLayer.path = CGPath(ellipseIn: rect, transform: nil)
        
        let renderer = UIGraphicsImageRenderer(size: rect.size)
        let image = renderer.image { context in
            return shapeLayer.render(in: context.cgContext)
        }
        
        return image
    }
    
    static func circleImageView(diameter: CGFloat, color: UIColor) -> UIImageView {
        let circleImage = circle(diameter: diameter, color: color)

        let imageView = UIImageView(image: circleImage)
        imageView.bounds.size = CGSize(width: diameter, height: diameter)
        
        return imageView
    }
}
