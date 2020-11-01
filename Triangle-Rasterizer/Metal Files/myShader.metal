//
//  myShader.metal
//  Triangle-Rasterizer
//
//  Created by Appnap WS01 on 1/11/20.
//

#include <metal_stdlib>
using namespace metal;

struct VertexIn {
    float3 position;
    float4 color;
};

struct RasterizerData {
    float4 position [[position]];
    float4 color;
};

vertex RasterizerData vertex_Shader(const device VertexIn *vertices [[buffer(0)]], uint vertexId [[vertex_id]]) {
    
    RasterizerData data;
    data.position = float4(vertices[vertexId].position, 1);
    data.color = vertices[vertexId].color;
    
    
    return data;
}

fragment half4 fragment_shader(RasterizerData Rd [[stage_in]]) {
    
    float4 color = Rd.color;
    
    return half4(color.r, color.g, color.b, color.a);
}
