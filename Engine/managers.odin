package Engine

import "core:fmt"
import m "core:math/linalg/glsl"
import gl "vendor:OpenGL"

EntityManager :: struct {
    alive : map[entity_id]bool,
    next_id : entity_id
    //can implement a list of freed IDs to reuse, in case of particles or other short-lived entities
}

ComponentManager :: struct {
    transforms : map[entity_id]Transform,
    static_meshes : map[entity_id]StaticMesh,
    lights : map[entity_id]Light,
    cameras : map[entity_id]Camera
}

EventManager :: struct {
    events : []Event
}
