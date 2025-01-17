package OdinRend

import "core:fmt"
import "core:c"
import "base:runtime"
import "vendor:glfw"
import gl "vendor:OpenGL"

GL_MAJOR_VERSION :: 4
GL_MINOR_VERSION :: 1

exit_application := false

initGL :: proc() -> glfw.WindowHandle {
	fmt.println("Initializing OpenGL")


	if glfw.Init() != glfw.TRUE {
		fmt.println("Failed to initialize GLFW")
		return nil
	}

	glfw.WindowHint(glfw.RESIZABLE, glfw.TRUE)
	glfw.WindowHint(glfw.OPENGL_FORWARD_COMPAT, glfw.TRUE)
	glfw.WindowHint(glfw.OPENGL_PROFILE, glfw.OPENGL_CORE_PROFILE)
	glfw.WindowHint(glfw.CONTEXT_VERSION_MAJOR, GL_MAJOR_VERSION)
	glfw.WindowHint(glfw.CONTEXT_VERSION_MINOR, GL_MINOR_VERSION)

	window := glfw.CreateWindow(640, 480, "OdinRend", nil, nil)
    fmt.println("Window created")

	if window == nil {
		fmt.println("Unable to create window")
		return nil
	}

	glfw.MakeContextCurrent(window)

	// Enable vsync
	glfw.SwapInterval(1)

	glfw.SetKeyCallback(window, key_callback)
	glfw.SetMouseButtonCallback(window, mouse_callback)
	glfw.SetCursorPosCallback(window, cursor_position_callback)
	glfw.SetFramebufferSizeCallback(window, framebuffer_size_callback)

	gl.load_up_to(GL_MAJOR_VERSION, GL_MINOR_VERSION, glfw.gl_set_proc_address)
	
	// Check for errors after loading OpenGL functions
    if err := gl.GetError(); err != gl.NO_ERROR {
        fmt.println("OpenGL error after loading functions: %d\n", err)
        return nil
    }

	
	draw(window)

	return window
}

//Graphic loop
draw :: proc(window: glfw.WindowHandle) {
	gl.ClearColor(1.0, 0.0, 1.0, 1.0)
	gl.Clear(gl.COLOR_BUFFER_BIT) // clear with the color set above		

	glfw.SwapBuffers(window)
	glfw.PollEvents()
}

cleanup :: proc(window: glfw.WindowHandle) {
	glfw.DestroyWindow(window)
	glfw.Terminate()
}


//Event callbacks

key_callback :: proc "c" (window: glfw.WindowHandle, key, scancode, action, mods: i32) {
	if key == glfw.KEY_ESCAPE && action == glfw.PRESS {
		exit_application = true
	}
}

mouse_callback :: proc "c" (window: glfw.WindowHandle, button, action, mods: i32) {
	context = runtime.default_context()
	fmt.println("Mouse clicked!")
}

cursor_position_callback :: proc "c" (window: glfw.WindowHandle, xpos, ypos: f64) {
	context = runtime.default_context()
	fmt.println("Mouse moved to: ", xpos, ypos)
}

scroll_callback :: proc "c" (window: glfw.WindowHandle, xoffset, yoffset: f64) {
	context = runtime.default_context()
	fmt.println("Scrolling: ", "x-", xoffset, "y-", yoffset)
}

framebuffer_size_callback :: proc "c" (window: glfw.WindowHandle, width, height: i32) {
	context = runtime.default_context()
	fmt.println("Framebuffer resized: ", "w-", width, "h-", height)

}