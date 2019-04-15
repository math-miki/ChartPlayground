import UIKit
import Foundation
import CoreGraphics

struct CoffeeProfile {
    var acidity: Int
    var sweetness: Int
    var richness: Int
    var flavored: Int
    var complexity: Int
    
    var asArray: [Int] {
        return [acidity, sweetness, richness, flavored, complexity]
    }
}


let chartColor = UIColor(red: 0.2, green: 0.4, blue: 0.7, alpha: 1.0).cgColor
let chartPOintSize:CGFloat = 10.0

func createChart(profile: CoffeeProfile, size: CGFloat) -> UIImage? {
    let R = size*0.9 / 2.0
    UIGraphicsBeginImageContext(CGSize(width: size, height: size))
    guard let context = UIGraphicsGetCurrentContext() else { return nil }
    for i in 1...5 {
        context.setLineWidth( (i == 5) ? 2.0 : 1.0)
        context.setStrokeColor( i==5 ? UIColor(red: 0.4, green: 0.4, blue: 0.4, alpha: 1.0).cgColor :
            UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1.0).cgColor)
        
        let r = R*CGFloat(i)/5.0
        var linesPoints:[CGPoint] = []
        for j in 0...5 {
            let theta = 2.0*CGFloat.pi*CGFloat(j)/5.0 - CGFloat.pi/2
            let x = size/2 + r*cos(theta)
            let y = size/2 + r*sin(theta)
            linesPoints.append(CGPoint(x: x, y: y))
        }
        context.addLines(between: linesPoints)
        context.drawPath(using: .stroke)
    }
    
    let params = profile.asArray.compactMap { return CGFloat($0) }
    var linesPoints:[CGPoint] = []
    context.setFillColor(chartColor)
    context.setLineWidth(0.0)
    for i in [0,1,2,3,4,5] {
        let r = R*params[i%5]/5.0
        let theta = 2.0*CGFloat.pi*CGFloat(i)/5.0 - CGFloat.pi/2
        linesPoints.append(CGPoint(x: size/2 + r*cos(theta), y: size/2 + r*sin(theta)))
        context.fillEllipse(in: CGRect(origin: CGPoint(x: size/2 + r*cos(theta) - chartPOintSize/2, y: size/2 + r*sin(theta) - chartPOintSize/2), size: CGSize(width: chartPOintSize, height: chartPOintSize) ))
    }
    context.setLineWidth(7.0)
    context.setStrokeColor(chartColor)
    context.addLines(between: linesPoints)
    context.drawPath(using: .stroke)
    
    
    let image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return image
}
let chart: UIImage = createChart(profile: CoffeeProfile(acidity: 4, sweetness: 3, richness: 2, flavored: 2, complexity: 4), size: 400)!
