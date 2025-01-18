package Engine

import "core:fmt"
import m "core:math/linalg/glsl"
import gl "vendor:OpenGL"

Material :: struct {
    shader : ^Shader,
    //texture : ^Texture
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
    projection_matrix : i32
}

initShader :: proc(vs_source: string, fs_source: string) -> Shader {
    shader := Shader{}
    //Compile and link shaders
    shader.program.prog, shader.success = gl.load_shaders(vs_source, fs_source, false)
    if !shader.success {
        fmt.println("Failed to load shaders")
    }

    initUniforms(&shader)

    return shader
    //TODO: add gl.UseProgram() to draw loop, for each entity
}

initUniforms :: proc(shader: ^Shader){
	program := shader.program
    //Init vertex attributes
	gl.EnableVertexAttribArray(program.vertex_position)
    gl.EnableVertexAttribArray(program.indices)
    //Init uniforms
    gl.GetUniformLocation(program.prog, "model_matrix")
    gl.GetUniformLocation(program.prog, "view_matrix")
    gl.GetUniformLocation(program.prog, "projection_matrix")
}

updateUniforms :: proc(shader: ^Shader){
    //gl.UniformMatrix4fv(shader.program.model_matrix, 1, false, false, &model_matrix)
}


initMaterial :: proc(shader: ^Shader, color: m.vec3) -> Material {
    mat := Material{}
    mat.shader = shader
    return mat
}
