package Engine

import "core:fmt"
import "core:time"
import "vendor:glfw"
import gl "vendor:OpenGL"

//OpenGL version declaration
GL_MAJOR_VERSION :: 4
GL_MINOR_VERSION :: 1

//Global variables
EXIT_APPLICATION : bool = false
GAME_WINDOW : glfw.WindowHandle //Game window and context
START_TIME : time.Time
NOW_TIME : time.Time
PREV_TIME : time.Time
GAME_TIME : f64
DELTA_TIME : f64