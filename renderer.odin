package OdinRend

import "core:fmt"
import "core:c"
import "vendor:glfw"
import gl "vendor:OpenGL"

GL_MAJOR_VERSION :: 4
GL_MINOR_VERSION :: 1


should_exit := false

initGL :: proc() {
	fmt.println("Initializing OpenGL")


	if glfw.Init() != glfw.TRUE {
		fmt.println("Failed to initialize GLFW")
		return
	}
	defer glfw.Terminate()

	glfw.WindowHint(glfw.RESIZABLE, glfw.TRUE)
	glfw.WindowHint(glfw.OPENGL_FORWARD_COMPAT, glfw.TRUE)
	glfw.WindowHint(glfw.OPENGL_PROFILE, glfw.OPENGL_CORE_PROFILE)
	glfw.WindowHint(glfw.CONTEXT_VERSION_MAJOR, GL_MAJOR_VERSION)
	glfw.WindowHint(glfw.CONTEXT_VERSION_MINOR, GL_MINOR_VERSION)

	window := glfw.CreateWindow(640, 480, "OdinRend", nil, nil)
    fmt.println("Window created")
	defer glfw.DestroyWindow(window)

	if window == nil {
		fmt.println("Unable to create window")
		return
	}

	glfw.MakeContextCurrent(window)

	// Enable vsync
	glfw.SwapInterval(1)

	glfw.SetKeyCallback(window, key_callback)
	glfw.SetMouseButtonCallback(window, mouse_callback)
	glfw.SetCursorPosCallback(window, cursor_position_callback)
	glfw.SetFramebufferSizeCallback(window, framebuffer_size_callback)

	gl.load_up_to(GL_MAJOR_VERSION, GL_MINOR_VERSION, glfw.gl_set_proc_address)

	for !glfw.WindowShouldClose(window) && !should_exit {
		gl.ClearColor(1.0, 0.0, 1.0, 1.0)
		gl.Clear(gl.COLOR_BUFFER_BIT) // clear with the color set above

		glfw.SwapBuffers(window)
		glfw.PollEvents()
	}
}

key_callback :: proc "c" (window: glfw.WindowHandle, key, scancode, action, mods: i32) {
	if key == glfw.KEY_ESCAPE && action == glfw.PRESS {
		should_exit = true
	}
}

mouse_callback :: proc "c" (window: glfw.WindowHandle, button, action, mods: i32) {}

cursor_position_callback :: proc "c" (window: glfw.WindowHandle, xpos, ypos: f64) {}

scroll_callback :: proc "c" (window: glfw.WindowHandle, xoffset, yoffset: f64) {}

framebuffer_size_callback :: proc "c" (window: glfw.WindowHandle, width, height: i32) {}