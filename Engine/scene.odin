package Engine

import "core:fmt"

Scene :: struct {
    entities : ^EntityManager,
    components : ^ComponentManager,
    events : ^EventManager,
    name : string
}

initScene :: proc(name: string, entity_manager: ^EntityManager, component_manager: ^ComponentManager) -> Scene {
    scene := Scene{}
    scene.entities = entity_manager
    scene.components = component_manager
    scene.name = name
    return scene
}