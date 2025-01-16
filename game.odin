package OdinRend

import "core:fmt"
import "core:c"
import "vendor:glfw"
import gl "vendor:OpenGL"

frameCount : i32 = 0

gameLoop :: proc(window: glfw.WindowHandle) {
    
    glfw.MakeContextCurrent(window)

    for !glfw.WindowShouldClose(window) && !exit_application {
        tick(false)
        draw(window)
    }
}

//Logic loop
tick :: proc(debug: bool) {
    if(debug){
        fmt.println(frameCount)
    }
    frameCount += 1
}



