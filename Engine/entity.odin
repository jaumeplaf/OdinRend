package Engine

import "core:fmt"
import m "core:math/linalg/glsl"

//Entity: game actor that has an ID, can have components and can be manipulated by systems
entity_id :: u32

EntityManager :: struct {
    alive : map[entity_id]bool,
    next_id : entity_id
    //can implement a list of freed IDs to reuse, in case of particles or other short-lived entities
}

//Manage entities
entityCreate :: proc(manager : ^EntityManager) -> entity_id {
    id := manager.next_id
    manager.next_id += 1
    manager.alive[id] = true
    return id
}
entityDestroy :: proc(manager : ^EntityManager, id : entity_id) {
    manager.alive[id] = false
}
//Transform entities
translate :: proc(manager : ^ComponentManager, id : entity_id, translate : m.vec3) {
    transform := manager.transforms[id]
    transform.position += translate
    manager.transforms[id] = transform
}
scale :: proc(manager : ^ComponentManager, id : entity_id, scale : m.vec3) {
    transform := manager.transforms[id]
    transform.scale *= scale
    manager.transforms[id] = transform
}
rotate :: proc(manager : ^ComponentManager, id : entity_id, rotate : m.vec3) {
    transform := manager.transforms[id]
    transform.rotation += rotate
    manager.transforms[id] = transform
}