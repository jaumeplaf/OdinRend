package OdinRend

import "core:fmt"

main :: proc() {
	fmt.println("Hellope! Initializing program")

	initGL()
	gameLoop()
}
