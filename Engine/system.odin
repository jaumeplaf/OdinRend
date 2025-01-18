package Engine

import "core:fmt"

//Systems: use concurrency features to run systems in parallel (e.g., physics_system, render_system...)
//Interface: define behaviors that different types can conform to without inheritance

Event :: struct {
    event_id : u32,
    global_var : bool
}

addEvent :: proc(manager : ^EventManager, id : u32, global_var : bool){
    manager.events[id] = Event{id, global_var}
}

initializeEvents :: proc(manager : ^EventManager){
    manager.events = make([]Event, 0)
    manager.events
}