//
//  PathGenerateManager.swift
//  Outline
//
//  Created by Seungui Moon on 10/19/23.
//

import CoreLocation
import MapKit
import SwiftUI

struct CanvasData {
    var width: Int
    var height: Int
    var scale: Double
    var zeroX: Double
    var zeroY: Double
}

final class PathGenerateManager {
    static func caculateLines(width: Double, height: Double, coordinates: [CLLocationCoordinate2D]) -> some Shape {
        let canvasData = calculateCanvasData(coordinates: coordinates, width: width, height: height)
        var path = Path()
        if coordinates.isEmpty {
            return path
        }
        
        let position = calculateRelativePoint(coordinate: coordinates[0], canvasData: canvasData)
        path.move(to: CGPoint(x: position[0], y: -position[1]))
        
        for coordinate in coordinates {
            let position = calculateRelativePoint(coordinate: coordinate, canvasData: canvasData)
            path.addLine(to: CGPoint(x: position[0], y: -position[1]))
        }
        
        return path
    }
    
    static func caculateLines(width: Double, height: Double, coordinates: [CLLocationCoordinate2D], canvasData: CanvasData) -> some Shape {
        var path = Path()
        
        if coordinates.isEmpty {
            return path
        }
        
        let position = calculateRelativePoint(coordinate: coordinates[0], canvasData: canvasData)
        path.move(to: CGPoint(x: position[0], y: -position[1]))
        
        for coordinate in coordinates {
            let position = calculateRelativePoint(coordinate: coordinate, canvasData: canvasData)
            path.addLine(to: CGPoint(x: position[0], y: -position[1]))
        }
        
        return path
    }
    
    static private func calculateRelativePoint(coordinate: CLLocationCoordinate2D, canvasData: CanvasData) -> [Int] {
        var posX: Int = 0
        var posY: Int = 0
        let tempX = (coordinate.longitude - canvasData.zeroX) * canvasData.scale * 1000000
        let tempY = (coordinate.latitude - canvasData.zeroY) * canvasData.scale * 1000000
        if !(tempX.isNaN || tempX.isInfinite || tempY.isNaN || tempY.isInfinite) {
            posX = Int(tempX)
            posY = Int(tempY)
        } else {
            posX = 0
            posY = 0
        }
            
        return [posX, posY]
    }
    
    static func calculateCanvasData(coordinates: [CLLocationCoordinate2D], width: Double, height: Double) -> CanvasData {
        var minLat: Double = 90
        var maxLat: Double = -90
        var minLon: Double = 180
        var maxLon: Double = -180
        for coordinate in coordinates {
            if coordinate.latitude < minLat {
                minLat = coordinate.latitude
            }
            if coordinate.latitude > maxLat {
                maxLat = coordinate.latitude
            }
            if coordinate.longitude < minLon {
                minLon = coordinate.longitude
            }
            if coordinate.longitude > maxLon {
                maxLon = coordinate.longitude
            }
        }
        let calculatedHeight = (maxLat - minLat) * 1000000
        let calculatedWidth = (maxLon - minLon) * 1000000
        
        var relativeScale: Double = 0
        
        if calculatedWidth > calculatedHeight {
            relativeScale = width / calculatedWidth
        } else {
            relativeScale = height / calculatedHeight
        }
        let fittedWidth = calculatedWidth * relativeScale
        let fittedHeight = calculatedHeight * relativeScale
        
        return CanvasData(
            width: Int(fittedWidth > 0 ? fittedWidth : 200),
            height: Int(fittedHeight > 0 ? fittedHeight : 200),
            scale: relativeScale > 0 ? relativeScale : 2,
            zeroX: minLon,
            zeroY: maxLat
            )
    }
}
