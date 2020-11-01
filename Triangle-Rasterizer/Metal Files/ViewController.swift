//
//  ViewController.swift
//  Triangle-Rasterizer
//
//  Created by Appnap WS01 on 1/11/20.
//

import UIKit
import MetalKit
class ViewController: UIViewController {

    
    struct Vertex {
        var position: simd_float3
        var color: simd_float4
    }
    
    
    var device: MTLDevice!
    var commandQueue: MTLCommandQueue!
    var renderPipeLineState: MTLRenderPipelineState!
    var vertexBuffer: MTLBuffer!
    var vertices: [Vertex]!
    var metalView: MTKView {
        return view as! MTKView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        metalView.device = MTLCreateSystemDefaultDevice()
        device = metalView.device
        metalView.clearColor = MTLClearColor(red: 0.5, green: 0.0, blue: 0.0, alpha: 1)
        commandQueue = device.makeCommandQueue()
        metalView.delegate = self
        createVertices()
        createBuffer()
        createRenderPipeLineState()
    }
    func createBuffer() {
        vertexBuffer = device.makeBuffer(bytes: vertices, length: MemoryLayout<Vertex>.stride * vertices.count, options: [])
    }
    
    func createVertices() {
            vertices = [
                Vertex(position: simd_float3(0,0.5,0), color: simd_float4(0,1,0,1)),
                Vertex(position: simd_float3(-0.5,0,0), color: simd_float4(1,0,0,1)),
                Vertex(position: simd_float3(0.5,0,0), color: simd_float4(0,0,1,1))
            ]
    }
    func createRenderPipeLineState() {
        let library = device.makeDefaultLibrary()
        let vertexFunction = library?.makeFunction(name: "vertex_Shader")
        let fragmentfunction = library?.makeFunction(name: "fragment_shader")
        
        let vertexDescriptor = MTLVertexDescriptor()
        vertexDescriptor.attributes[0].format = .float3
        vertexDescriptor.attributes[0].bufferIndex = 0
        vertexDescriptor.attributes[0].offset = 0
        
        vertexDescriptor.attributes[1].format = .float4
        vertexDescriptor.attributes[1].bufferIndex = 0
        vertexDescriptor.attributes[1].offset = MemoryLayout<simd_float3>.stride
        
        vertexDescriptor.layouts[0].stride = MemoryLayout<Vertex>.stride
        
        
        let descriptor = MTLRenderPipelineDescriptor()
        descriptor.colorAttachments[0].pixelFormat = .bgra8Unorm
        descriptor.vertexFunction = vertexFunction
        descriptor.fragmentFunction = fragmentfunction
        descriptor.vertexDescriptor = vertexDescriptor
        do {
            renderPipeLineState = try device.makeRenderPipelineState(descriptor: descriptor)
        }catch {
            print(error)
        }
    }
}

extension ViewController: MTKViewDelegate {
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        
    }
    
    func draw(in view: MTKView) {
        guard let drawable = view.currentDrawable, let renderPassDescriptor = view.currentRenderPassDescriptor else {return}
        let commandBuffer = commandQueue.makeCommandBuffer()
        let commandEncoder = commandBuffer?.makeRenderCommandEncoder(descriptor: renderPassDescriptor)
        commandEncoder?.setRenderPipelineState(renderPipeLineState)
        commandEncoder?.setVertexBuffer(vertexBuffer, offset: 0, index: 0)
        commandEncoder?.drawPrimitives(type: .triangle, vertexStart: 0, vertexCount: vertices.count)
        
        commandEncoder?.endEncoding()
        commandBuffer?.present(drawable)
        commandBuffer?.commit()
        
    }
    
    
}
