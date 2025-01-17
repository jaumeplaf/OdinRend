package OdinRend

import "core:fmt"
import "vendor:glfw"
import gl "vendor:OpenGL"

GL_MAJOR_VERSION :: 4
GL_MINOR_VERSION :: 1

exit_application : bool = false

GAME_WINDOW : glfw.WindowHandle //Game window and context


//Data types
vec2 :: struct {
    x, y : f32
}

vec3 :: struct {
    x, y, z : f32
}

vec4 :: struct {
    x, y, z, w : f32
}

mat2 :: matrix[2, 2]f32
mat3 :: matrix[3, 3]f32
mat4 :: matrix[4, 4]f32