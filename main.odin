package OdinRend

import "core:fmt"
import "core:c"
import "vendor:glfw"
import gl "vendor:OpenGL"

main :: proc() {
	fmt.println("Hellope! Initializing program")

	gameWindow := initGL()
	gameLoop(gameWindow)
}
