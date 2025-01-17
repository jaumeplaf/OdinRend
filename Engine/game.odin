package Engine

import "core:fmt"
import "core:time"
import "vendor:glfw"

//Combined loop
gameLoop :: proc() {

    for !glfw.WindowShouldClose(GAME_WINDOW) && !EXIT_APPLICATION {
        //Logic loop
        tick(false) 
        //Draw loop
        draw() 
    }
    //Destroy window & context
    cleanup() 
}

//Logic loop
tick :: proc(debug: bool) {
    calcTime(debug)
}

//Calculate time variables
calcTime :: proc(debug : bool){

    PREV_TIME = NOW_TIME
    NOW_TIME = time.now()

    DELTA_TIME = -time.duration_milliseconds(time.diff(NOW_TIME, PREV_TIME))
    GAME_TIME = -time.duration_milliseconds(time.diff(NOW_TIME, START_TIME))

    if(debug){
        fmt.printf("DeltaTime: %f\n", DELTA_TIME)
        fmt.printf("GameTime: %f\n", GAME_TIME)
    }
}



