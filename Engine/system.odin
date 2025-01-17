package Engine

import "core:fmt"

//Systems: use concurrency features to run systems in parallel (e.g., physics_system, render_system...)
//Interface: define behaviors that different types can conform to without inheritance

loadScene :: proc(scene : proc()) {
    //load scene
}

bindEntityManagers :: proc(manager : ^EntityManager) -> Scene{
    scene := Scene{}
    scene.entities = manager
    scene.components = componentInit()
    scene.name = "Scene 01"
    return scene
}

bindComponentManagers :: proc(manager : ^ComponentManager) -> Scene{
    scene := Scene{}
    scene.entities = entityInit()
    scene.components = manager
    scene.name = "Scene 01"
    return scene
}

bindScene :: proc(entity_manager : ^EntityManager, component_manager : ^ComponentManager) -> Scene{
    scene := Scene{}
    scene.entities = entity_manager
    scene.components = component_manager
    scene.name = "Scene 01"
    return scene
}