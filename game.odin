package OdinRend

import "core:fmt"
import "vendor:glfw"

frameCount : i32 = 0

//Logic loop
tick :: proc(debug: bool) {
    if(debug){
        fmt.println(frameCount)
    }
    frameCount += 1
}

//Combined loop
gameLoop :: proc() {
    for !glfw.WindowShouldClose(GAME_WINDOW) && !exit_application {
        tick(false) //Logic loop
        draw() //Draw loop
    }
    cleanup() //Destroy window & context
}




