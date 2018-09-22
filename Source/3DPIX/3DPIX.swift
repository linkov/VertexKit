//
//  3DPIX.swift
//  3DPIX
//
//  Created by Hexagons on 2018-09-13.
//  Copyright © 2018 Hexagons. All rights reserved.
//

import UIKit
import Pixels

public class _3DPIX: PIXGenerator, PixelsCustomGeometryDelegate {

    override open var shader: String { return "contentGeneratorColorPIX" }
    
//    var root: _3DRoot
    
    public var vertecies: [Pixels.Vertex] { return [] }
    public var instanceCount: Int { return 0 }
    public var primativeType: MTLPrimitiveType { return .triangle }
    public var wireframe: Bool { return false }

    public var color: UIColor = .white { didSet { setNeedsRender() } }
    enum CodingKeys: String, CodingKey {
        case color
    }
    public override var uniforms: [CGFloat] {
        return PIX.Color(color).list
    }

    override init(res: PIX.Res) {
//        root = Pixels3D.main.engine.createRoot(at: res.size)
        super.init(res: res)
        customGeometryActive = true
        customGeometryDelegate = self
    }
    
    // MAKR: Custom Geometry
    
    public func customVertecies() -> Pixels.Vertecies? {
        
        let scaledVertecies = vertecies.map { vtx -> Pixels.Vertex in
            return Pixels.Vertex(x: vtx.x * 2, y: vtx.y * 2, z: vtx.z, s: vtx.s, t: vtx.t)
        }
        
        var vertexBuffers: [Float] = []
        for vertex in scaledVertecies {
            vertexBuffers += vertex.buffer
        }
        
        let vertexBuffersSize = vertexBuffers.count * MemoryLayout<Float>.size
        let verteciesBuffer = Pixels.main.metalDevice.makeBuffer(bytes: vertexBuffers, length: vertexBuffersSize, options: [])!
        
        return Pixels.Vertecies(buffer: verteciesBuffer, vertexCount: vertecies.count, instanceCount: instanceCount, type: primativeType, wireframe: wireframe)
    }
    
}
