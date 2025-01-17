package Engine

import "core:fmt"
import "core:time"
import "vendor:glfw"
import gl "vendor:OpenGL"
import m "core:math/linalg/glsl"

//OpenGL version declaration
GL_MAJOR_VERSION :: 4
GL_MINOR_VERSION :: 1

//Global variables
EXIT_APPLICATION : bool = false
GAME_WINDOW : glfw.WindowHandle //Game window and context
ASPECT_RATIO : f32
ACTIVE_CAMERA : entity_id
START_TIME : time.Time
NOW_TIME : time.Time
PREV_TIME : time.Time
GAME_TIME : f64
DELTA_TIME : f64
WORLD_UP_VEC := m.vec3{0.0, 1.0, 0.0}