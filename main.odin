package OdinRend

import "core:fmt"

main :: proc() {
	fmt.println("Hellope! Initializing program")

	gameWindow := initGL()
	gameLoop(gameWindow)
}
