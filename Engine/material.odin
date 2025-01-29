package Engine

import "core:fmt"
import "core:os"
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

    shader_dir := os.get_current_directory() // Get executable's directory

    when ODIN_OS == .Darwin || ODIN_OS == .Linux  { //macOS and Linux use forward slashes
        vert_path := fmt.tprintf("%s/shaders/%s", shader_dir, vs_source)
        frag_path := fmt.tprintf("%s/shaders/%s", shader_dir, fs_source)
    }
    else{ //Windows uses backslashes
        vert_path := fmt.tprintf("%s\\shaders\\%s", shader_dir, vs_source)
        frag_path := fmt.tprintf("%s\\shaders\\%s", shader_dir, fs_source)
    }

    if !os.exists(vert_path) {
        fmt.eprintln("Vertex shader not found at:", vert_path)
    }
    
    if !os.exists(frag_path) {
        fmt.eprintln("Fragment shader not found at:", frag_path)
    }
    
    shader.program.prog, shader.success = gl.load_shaders_file(vert_path, frag_path)
    if !shader.success {
        fmt.eprintln("Failed to load shaders at path:", vert_path, frag_path)
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
