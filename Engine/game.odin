package Engine

import "core:fmt"
import "core:time"
import "vendor:glfw"

//Game lifecycle

//Combined loop
gameLoop :: proc(entities : ^EntityManager, components : ^ComponentManager, events : ^EventManager) {

    for !glfw.WindowShouldClose(GAME_WINDOW) && !EXIT_APPLICATION {
        //Logic loop
        tick(entities, components, events) 
        //Draw loop
        draw(entities, components, events) 
    }
    //Destroy window & context
    cleanup() 
}

//Logic loop
tick :: proc(entities : ^EntityManager, components : ^ComponentManager, events : ^EventManager) {
    player := components.players[0]
    calcTime()
    updatePlayerPosition(&player)
}

//Calculate time variables
calcTime :: proc(){
    debug := false
    PREV_TIME = NOW_TIME
    NOW_TIME = time.now()

    DELTA_TIME = -time.duration_milliseconds(time.diff(NOW_TIME, PREV_TIME))
    GAME_TIME = -time.duration_milliseconds(time.diff(NOW_TIME, START_TIME))

    if(debug){
        fmt.printf("DeltaTime: %f\n", DELTA_TIME)
        fmt.printf("GameTime: %f\n", GAME_TIME)
    }
}



