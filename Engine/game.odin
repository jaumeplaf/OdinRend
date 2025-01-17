package OdinRend

import "core:fmt"
import "core:time"
import "vendor:glfw"

//Logic loop
tick :: proc(debug: bool) {
    calc_time(debug)
}

//Combined loop
gameLoop :: proc() {

    for !glfw.WindowShouldClose(GAME_WINDOW) && !EXIT_APPLICATION {
        tick(true) //Logic loop
        draw() //Draw loop
    }
    cleanup() //Destroy window & context
}

calc_time :: proc(debug : bool){

    PREV_TIME = NOW_TIME
    NOW_TIME = time.now()

    DELTA_TIME = -time.duration_milliseconds(time.diff(NOW_TIME, PREV_TIME))
    GAME_TIME = -time.duration_milliseconds(time.diff(NOW_TIME, START_TIME))

    if(debug){
        fmt.printf("DeltaTime: %f\n", DELTA_TIME)
        fmt.printf("GameTime: %f\n", GAME_TIME)
    }
}



