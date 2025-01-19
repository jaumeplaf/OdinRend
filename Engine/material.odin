package Engine

import "core:fmt"
import m "core:math/linalg/glsl"
import gl "vendor:OpenGL"

Material :: struct {
    shader : ^Shader,
    color: m.vec4
}

Shader :: struct {
    program : Program,
    success : bool
}

Program :: struct {
    prog : u32,
    vertex_position : u32,
    indices : u32,
    model_matrix : i32,
    view_matrix : i32,
    projection_matrix : i32,
    color : i32
}

   

initShader :: proc(vs_source: string, fs_source: string) -> Shader {
    shader := Shader{}
    //Compile and link shaders

    //TODO: fix shaders not loading!
    shader.program.prog, shader.success = gl.load_shaders(vs_source, fs_source, false)
    if !shader.success {
        fmt.println("Failed to load shaders")
    }
    
    initUniforms(&shader)

    return shader
}

initMaterial :: proc(shader: ^Shader, color: m.vec3) -> Material {
    mat := Material{}
    mat.shader = shader
    mat.color = m.vec4{color.x, color.y, color.z, 1.0}
    initUniforms(mat.shader)

    return mat
}
