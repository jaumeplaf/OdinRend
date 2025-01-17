package OdinRend

import "core:fmt"
import "core:c"
import "base:runtime"
import "vendor:glfw"
import "core:time"

//Event callbacks

key_callback :: proc "c" (window: glfw.WindowHandle, key, scancode, action, mods: i32) {
	if key == glfw.KEY_ESCAPE && action == glfw.PRESS {
		EXIT_APPLICATION = true
	}
}

mouse_callback :: proc "c" (window: glfw.WindowHandle, button, action, mods: i32) {
	context = runtime.default_context()
	fmt.println("Mouse clicked!")
}

//MOUSE_POS_DELTA_TIME is initialized in data.odin
cursor_position_callback :: proc "c" (window: glfw.WindowHandle, xpos, ypos: f64) {
    context = runtime.default_context()
	//fmt.println("Mouse moved: ", "x-", xpos, "y-", ypos)
}

scroll_callback :: proc "c" (window: glfw.WindowHandle, xoffset, yoffset: f64) {
	context = runtime.default_context()
	fmt.println("Scrolling: ", "x-", xoffset, "y-", yoffset)
}

framebuffer_size_callback :: proc "c" (window: glfw.WindowHandle, width, height: i32) {
	context = runtime.default_context()
	fmt.println("Framebuffer resized: ", "w-", width, "h-", height)

}