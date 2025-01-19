package Engine

import "core:fmt"

//Systems: use concurrency features to run systems in parallel (e.g., physics_system, render_system...)
//Interface: define behaviors that different types can conform to without inheritance

RESIZE_WINDOW : bool = false
SCROLL_UP : bool = false
SCROLL_DOWN : bool = false
MOVE_FORWARD : bool = false
MOVE_BACKWARD : bool = false
MOVE_LEFT : bool = false
MOVE_RIGHT : bool = false
JUMP : bool = false
SPRINT : bool = false
CROUCH : bool = false


addEvent :: proc(manager : ^EventManager, global_var : ^bool, entities : ^EntityManager, components : ^ComponentManager){
    manager.events[global_var] = global_var^
}

initializeEvents :: proc(events : ^EventManager, entities : ^EntityManager, components : ^ComponentManager){
    addEvent(events, &RESIZE_WINDOW, entities, components) //Resize window event
}

checkEvents :: proc(events : ^EventManager, entities : ^EntityManager, components : ^ComponentManager){
    for global_var, event in events.events {
        if global_var^ {
            switch global_var {
                case &RESIZE_WINDOW:
                    eventResizeWindow(components)
            }
        }
    }
}

eventResizeWindow :: proc(components : ^ComponentManager){
    //idk if this should iterate for all cameras, for now it's not designed to use multiple cameras
    //the idea is to have a camera list and an active camera and switch between them, and this function should only update the active camera?
    for id in components.cameras {
        camera := components.cameras[id]
        setProjectionMatrix(&camera, camera.fov, ASPECT_RATIO)
    }

    //fmt.println("Framebuffer resized!")

    RESIZE_WINDOW = false //reset event
}
