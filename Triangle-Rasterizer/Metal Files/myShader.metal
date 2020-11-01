//
//  myShader.metal
//  Triangle-Rasterizer
//
//  Created by Appnap WS01 on 1/11/20.
//

#include <metal_stdlib>
using namespace metal;

struct VertexIn {
    float3 position [[attribute(0)]];
    float4 color [[attribute(1)]];
};

struct RasterizerData {
    float4 position [[position]];
    float4 color;
};

vertex RasterizerData vertex_Shader(const VertexIn vertices [[stage_in]]) {
    
    RasterizerData data;
    data.position = float4(vertices.position, 1);
    data.color = vertices.color;
    
    
    return data;
}

fragment half4 fragment_shader(RasterizerData Rd [[stage_in]]) {
    
    float4 color = Rd.color;
    
    return half4(color.r, color.g, color.b, color.a);
}
