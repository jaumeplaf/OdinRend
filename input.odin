package OdinRend

import "core:fmt"
import "core:c"
import "base:runtime"
import "vendor:glfw"

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