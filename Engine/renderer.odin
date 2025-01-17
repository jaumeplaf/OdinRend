package OdinRend

import "core:fmt"
import "core:c"
import "core:time"
import "base:runtime"
import "vendor:glfw"
import gl "vendor:OpenGL"

initGL :: proc(width : i32 = 800, height : i32 = 600) {
	fmt.println("Initializing OpenGL")

	if glfw.Init() != glfw.TRUE {
		fmt.println("Failed to initialize GLFW")
		return
	}

	glfw.WindowHint(glfw.RESIZABLE, glfw.TRUE)
	glfw.WindowHint(glfw.OPENGL_FORWARD_COMPAT, glfw.TRUE)
	glfw.WindowHint(glfw.OPENGL_PROFILE, glfw.OPENGL_CORE_PROFILE)
	glfw.WindowHint(glfw.CONTEXT_VERSION_MAJOR, GL_MAJOR_VERSION)
	glfw.WindowHint(glfw.CONTEXT_VERSION_MINOR, GL_MINOR_VERSION) 

	//MacOS specific hints
	glfw.InitHint(glfw.WAYLAND_LIBDECOR, glfw.WAYLAND_PREFER_LIBDECOR)

	GAME_WINDOW = glfw.CreateWindow(width, height, "OdinRend", nil, nil)
	if GAME_WINDOW == nil {
		fmt.println("Unable to create window")
		return
	}

	START_TIME = time.now()

	fmt.println("Window created successfully")

	glfw.MakeContextCurrent(GAME_WINDOW)

	// Enable vsync
	glfw.SwapInterval(1)

	glfw.SetKeyCallback(GAME_WINDOW, key_callback)
	glfw.SetMouseButtonCallback(GAME_WINDOW, mouse_callback)
	glfw.SetCursorPosCallback(GAME_WINDOW, cursor_position_callback)
	glfw.SetFramebufferSizeCallback(GAME_WINDOW, framebuffer_size_callback)

	gl.load_up_to(GL_MAJOR_VERSION, GL_MINOR_VERSION, glfw.gl_set_proc_address)

	// Check for errors after loading OpenGL functions
	if err := gl.GetError(); err != gl.NO_ERROR {
		fmt.println("OpenGL error after loading functions: %d\n", err)
		return
	}

	//Init time
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