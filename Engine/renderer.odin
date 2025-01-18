package Engine

import "core:fmt"
import "core:c"
import "core:time"
import "base:runtime"
import "vendor:glfw"
import gl "vendor:OpenGL"
import m "core:math/linalg/glsl"

//Initialize OpenGL and create window
initGL :: proc(width : i32 = 800, height : i32 = 600) {

	//Initialize OpenGL
	if glfw.Init() != glfw.TRUE {
		fmt.println("Failed to initialize GLFW")
		return
	}

	//Window hints
	glfw.WindowHint(glfw.RESIZABLE, glfw.TRUE)
	glfw.WindowHint(glfw.OPENGL_FORWARD_COMPAT, glfw.TRUE)
	glfw.WindowHint(glfw.OPENGL_PROFILE, glfw.OPENGL_CORE_PROFILE)
	glfw.WindowHint(glfw.CONTEXT_VERSION_MAJOR, GL_MAJOR_VERSION)
	glfw.WindowHint(glfw.CONTEXT_VERSION_MINOR, GL_MINOR_VERSION) 

	//MacOS specific hints
	glfw.InitHint(glfw.WAYLAND_LIBDECOR, glfw.WAYLAND_PREFER_LIBDECOR)

	//Create window + context
	GAME_WINDOW = glfw.CreateWindow(width, height, "OdinRend", nil, nil)
	if GAME_WINDOW == nil {
		fmt.println("Unable to create window")
		return
	}

	ASPECT_RATIO = getAspectRatio_i32(width, height)
	
	// Load OpenGL functions

	//Set context
	glfw.MakeContextCurrent(GAME_WINDOW)
	//Enable depth test
	gl.Enable(gl.DEPTH_TEST)
	//Enable vsync
	glfw.SwapInterval(1)
	//Enable callbacks
	glfw.SetKeyCallback(GAME_WINDOW, keyCallback)
	glfw.SetMouseButtonCallback(GAME_WINDOW, mouseCallback)
	glfw.SetCursorPosCallback(GAME_WINDOW, cursorPositionCallback)
	glfw.SetFramebufferSizeCallback(GAME_WINDOW, framebufferSizeCallback)
	//Set OpenGL version
	gl.load_up_to(GL_MAJOR_VERSION, GL_MINOR_VERSION, glfw.gl_set_proc_address)

	//Check for errors after loading OpenGL functions
	if err := gl.GetError(); err != gl.NO_ERROR {
		fmt.println("OpenGL error after loading functions: %d\n", err)
		return
	}

	//Initialize time
	START_TIME = time.now()

	return
}

//Graphic loop
draw :: proc() {
	gl.ClearColor(1.0, 0.0, 1.0, 1.0)
	gl.Clear(gl.COLOR_BUFFER_BIT) // clear with the color set above		

	glfw.SwapBuffers(GAME_WINDOW)
	glfw.PollEvents()
}

cleanup :: proc() {
	glfw.DestroyWindow(GAME_WINDOW)
	glfw.Terminate()
}