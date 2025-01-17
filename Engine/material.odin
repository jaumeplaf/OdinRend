package Engine

import "core:fmt"
import m "core:math/linalg/glsl"
import gl "vendor:OpenGL"

Material :: struct {
    shader : ^Shader,
    //texture : ^Texture
}

Shader :: struct {
    program : u32,
    success : bool
}

//Texture :: struct {
//    name : string,
//    //width, height : i32,
//    data : ^u8
//}

initShader :: proc(vs_source: string, fs_source: string) -> Shader {
    shader := Shader{}
    //Compile and link shaders
    shader.program, shader.success = gl.load_shaders(vs_source, fs_source, false)
    if !shader.success {
        fmt.println("Failed to load shaders")
    }

    return shader
    //TODO: add gl.UseProgram() to draw loop, for each entity
}

initMaterial :: proc(shader: ^Shader, color: m.vec3) -> Material {
    mat := Material{}
    mat.shader = shader
    return mat
}
