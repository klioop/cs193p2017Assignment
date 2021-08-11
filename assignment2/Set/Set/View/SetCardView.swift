//
//  Diamond.swift
//  Pratice-Drawing
//
//  Created by klioop on 2021/07/31.
//

import UIKit

class SetCardView: UIView {
    
    var number: CGFloat = 3 { didSet { setNeedsDisplay() }}
    var shape: Shape = .diamond { didSet { setNeedsDisplay() }}
    var shade: Shade = .fill { didSet { setNeedsDisplay() }}
    var color: Color = .red { didSet { setNeedsDisplay() }}
    var isSelected: Bool = false
    
    var shapeScaleSmall = SizeRatio.shapeRectSmallRatioToPerRowRect {
        didSet {
            setNeedsDisplay()
        }
    }
    
    var shapeScaleLarge = SizeRatio.shapeRectLargeRatioToPerRowRect {
        didSet {
            setNeedsDisplay()
        }
    }
    
    override func draw(_ rect: CGRect) {
        
        drawShape(shape: shape, shade: shade, color: color)
    }
    
    func makeRoundedCorner() {
        let minLength = min(frame.size.width, frame.size.height)
        layer.cornerRadius = minLength * SizeRatio.roundedCornerRatioToMinLenth
        layer.masksToBounds = true
    }
    
     func drawBorderDependingOnTapped() {
        if isSelected {
            layer.borderWidth = borderWidthWhenTapped
            layer.borderColor = UIColor.systemGreen.cgColor
        } else {
            layer.borderWidth = 0
        }
    }
    
    private func drawShape(shape: Shape, shade: Shade, color: Color) {
        var shapePerRowRect = CGRect(origin: bounds.origin,
                                     size: shapePerRowSize)
        if number == 3 {
            for _ in 0..<Int(number) {
                let shapeRect = shapePerRowRect.zoom(by: shapeScaleSmall,
                                                     by: shapeScaleLarge)
                
                determineAndDrawShape(in: shapeRect, for: shape, with: shade, in: color)
                shapePerRowRect.origin.y += shapePerRow
            }
            
        } else if number == 2 {
            let boundsHalfHeight = bounds.size.height / 2
            shapePerRowRect.origin.y += (boundsHalfHeight - shapePerRow)
            
            for _ in 0..<Int(number) {
                let shapeRect = shapePerRowRect.zoom(by: shapeScaleSmall,
                                                     by: shapeScaleLarge)
                
                determineAndDrawShape(in: shapeRect, for: shape, with: shade, in: color)
                shapePerRowRect.origin.y += shapePerRow
            }
        } else {
            shapePerRowRect.origin.y += shapePerRow
            let shapeRect = shapePerRowRect.zoom(by: shapeScaleSmall,
                                                 by: shapeScaleLarge)
            determineAndDrawShape(in: shapeRect, for: shape, with: shade, in: color)
        }
    }
    
    // MARK: - functions related to drawing shapes
    
    private func determineAndDrawShape (in rect: CGRect,
                                for shape: Shape,
                                with shade: Shade,
                                in color: Color
    ) {
        switch shape {
        case .diamond:
            drawDiamond(drawArea: rect, shade, color)
        case .oval:
            drawOval(drawArea: rect, with: shade, in: color)
        case .squiggle:
            drawSquiggle(drawArea: rect, with: shade, in: color)
        }
    }
    
    private func drawDiamond(drawArea: CGRect, _ shade: Shade, _ color: Color) {
        let color = color.returnColor()
        
        let path = UIBezierPath()
        path.move(to: CGPoint(x: drawArea.midX, y: drawArea.minY))
        path.addLine(to: CGPoint(x: drawArea.minX, y: drawArea.midY))
        path.addLine(to: CGPoint(x: drawArea.midX, y: drawArea.maxY))
        path.addLine(to: CGPoint(x: drawArea.maxX, y: drawArea.midY))
        path.addLine(to: CGPoint(x: drawArea.midX, y: drawArea.minY))
        
        color.setStroke()
        path.lineWidth = lineWidthOfShape
        path.stroke()
        
        switch shade {
        case .open:
            break
        case .stripped:
            stripped(drawArea: drawArea, path: path)
        case .fill:
            color.setFill()
            path.fill()
        }
    }
    
    private func drawOval(drawArea: CGRect, with shade: Shade, in color: Color) {
        let color = color.returnColor()
        
        let ovalCornerRadius = drawArea.size.height * SizeRatio.ovalCornerRadiusRatioToShapeRectHeight
        let oval = UIBezierPath(roundedRect: drawArea,
                                cornerRadius: ovalCornerRadius)
        color.setStroke()
        oval.lineWidth = lineWidthOfShape
        oval.stroke()
        
        switch shade {
        case .open:
            break
        case .stripped:
            stripped(drawArea: drawArea, path: oval)
        case .fill:
            color.setFill()
            oval.fill()
        }
    }
    
    private func drawSquiggle(drawArea: CGRect, with shade: Shade, in color: Color) {
        let uiColor = color.returnColor()
        
        let width10 = drawArea.size.width * 0.1
        let height30 = drawArea.size.height * 0.3
        
        
        let path = UIBezierPath()
        path.move(to: CGPoint(x: drawArea.minX, y: drawArea.maxY))
        path.addCurve(to: CGPoint(x: drawArea.maxX,
                                  y: drawArea.maxY),
                      controlPoint1: CGPoint(x: drawArea.size.width * SizeRatio.controlPointRatioForSquiggle, y: drawArea.maxY - height30),
                      controlPoint2: CGPoint(x: drawArea.midX + width10, y: drawArea.maxY + height30))
        path.addLine(to: CGPoint(x: drawArea.maxX, y: drawArea.minY))
        path.addCurve(to: drawArea.origin,
                      controlPoint1: CGPoint(x: drawArea.midX + width10, y: drawArea.minY + height30),
                      controlPoint2: CGPoint(x: drawArea.size.width * SizeRatio.controlPointRatioForSquiggle, y: drawArea.minY - height30))
        path.addLine(to: CGPoint(x: drawArea.minX, y: drawArea.maxY))
        uiColor.setStroke()
        path.lineWidth = lineWidthOfShape
        path.stroke()
        
        switch shade {
        case .open:
            break
        case .stripped:
            stripped(drawArea: drawArea, path: path)
        case .fill:
            uiColor.setFill()
            path.fill()
        }
        
    }
    
    private func stripped(drawArea: CGRect, path: UIBezierPath) {
        
        guard let context = UIGraphicsGetCurrentContext() else { return }
        context.saveGState()
        path.addClip()
        
        let numberOfStripe: CGFloat = numberOfStripe
        let temp = drawArea.maxX / numberOfStripe
        
        for line in 1..<Int(numberOfStripe) {
            let startPointWidth = temp * CGFloat(line)
            let startPoint = CGPoint(x: startPointWidth, y: bounds.minY)
            let endPoint = CGPoint(x: startPointWidth, y: bounds.maxY)
            
            path.move(to: startPoint)
            path.addLine(to: endPoint)
            path.lineWidth = lineWidthOfStripe
            path.stroke()
        }
        
        context.restoreGState()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        setNeedsLayout()
        setNeedsDisplay()
    }
    
    // MARK: - init
    
    init(number: Number = .three,
         shape: Shape = .squiggle,
         shade: Shade = .open,
         color: Color = .red,
         isSelected: Bool = false) {
        super.init(frame: .zero)
        
        switch number {
        case .one: self.number = CGFloat(1)
        case .two: self.number = CGFloat(2)
        case .three: self.number = CGFloat(3)
        }
        
        self.shape = shape
        self.shade = shade
        self.color = color
        self.isSelected = isSelected
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: - extension

extension SetCardView {
    
    struct SizeRatio {
        static let shapeRectSmallRatioToPerRowRect: CGFloat = 0.8
        static let shapeRectLargeRatioToPerRowRect: CGFloat = 0.6
        static let ovalCornerRadiusRatioToShapeRectHeight: CGFloat = 0.4
        static let roundedCornerRatioToMinLenth: CGFloat = 0.1
        static let controlPointRatioForSquiggle: CGFloat = 0.4
    }
    
    var numberOfStripe: CGFloat {
        20
    }
    
    var shapePerRow: CGFloat {
        bounds.size.height / 3
    }
    
    var shapePerRowSize: CGSize {
        CGSize(width: bounds.size.width, height: shapePerRow)
    }
    
    var lineWidthOfShape: CGFloat {
        3.0
    }
    
    var lineWidthOfStripe: CGFloat {
        1.0
    }
    
    var borderWidthWhenTapped: CGFloat {
        3
    }
    
}

    

