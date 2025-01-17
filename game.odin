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
gameLoop :: proc(window: glfw.WindowHandle) {
    for !glfw.WindowShouldClose(window) && !exit_application {
        tick(false) //Logic loop
        draw(window) //Draw loop
    }
    cleanup(window) //Destroy window & context
}




