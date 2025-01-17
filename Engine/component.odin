package Engine

import "core:fmt"
import m "core:math/linalg/glsl"
import gl "vendor:OpenGL"

//Manager
ComponentManager :: struct {
    transforms : map[entity_id]Transform,
    static_meshes : map[entity_id]StaticMesh,
    lights : map[entity_id]Light,
    cameras : map[entity_id]Camera
}

//Components
Transform :: struct {
    position, rotation, scale : m.vec3
}


StaticMesh :: struct {
    mesh : Shape,
    //vertices/indices/normals/colors/texcoords
    material : Material,
    buffer_vertices : u32,
    buffer_indices : u32,
    buffer_normals : u32,
    buffer_colors : u32,
    buffer_texcoords : u32
}

Light :: struct {
    la, ld, ls : m.vec3,
    intensity : f32,
    radius : f32
}

Camera :: struct {
    fov: f32,
    position: m.vec3,
    target: m.vec3,
    forward_vec: m.vec3,
    up_vec: m.vec3,
    right_vec: m.vec3,
    yaw: f32,
    pitch: f32,
    max_pitch : f32,
    view_matrix: m.mat4,
    projection_matrix: m.mat4
}

//Add components procedures

//Initialize transform component with default values
componentTransform :: proc(manager : ^ComponentManager, id : entity_id){
    transform := Transform{}
    transform.position = m.vec3{0.0, 0.0, 0.0}
    transform.rotation = m.vec3{0.0, 0.0, 0.0}
    transform.scale = m.vec3{1.0, 1.0, 1.0}
    manager.transforms[id] = transform
}
//Initialize transform component with custom values
componentTransformInit :: proc(manager : ^ComponentManager, id : entity_id, position : m.vec3, rotation : m.vec3, scale : m.vec3){
    transform := Transform{}
    transform.position = position
    transform.rotation = rotation
    transform.scale = scale
    manager.transforms[id] = transform
}

//Initialize static mesh component
componentStaticMesh :: proc(manager : ^ComponentManager, id : entity_id, mesh : Shape, material : Material){
    static_mesh := StaticMesh{}
    static_mesh.mesh = mesh
    static_mesh.material = material
    manager.static_meshes[id] = static_mesh
    initMeshBuffers(manager, id)
}
initMeshBuffers :: proc(manager: ^ComponentManager, id: entity_id){
    entity := manager.static_meshes[id]
    //Vertices
    gl.BindBuffer(gl.ARRAY_BUFFER, entity.buffer_vertices)
    gl.BufferData(gl.ARRAY_BUFFER, len(entity.mesh.vertices), &entity.mesh.vertices, gl.STATIC_DRAW)
    //Indices
    gl.BindBuffer(gl.ELEMENT_ARRAY_BUFFER, entity.buffer_indices)
    gl.BufferData(gl.ELEMENT_ARRAY_BUFFER, len(entity.mesh.indices), &entity.mesh.indices, gl.STATIC_DRAW)
    ////Normals
    //gl.BindBuffer(gl.ARRAY_BUFFER, entity.buffer_normals)
    //gl.BufferData(gl.ARRAY_BUFFER, len(entity.mesh.normals), &entity.mesh.normals, gl.STATIC_DRAW)
    ////Colors
    //gl.BindBuffer(gl.ARRAY_BUFFER, entity.buffer_colors)
    //gl.BufferData(gl.ARRAY_BUFFER, len(entity.mesh.colors), &entity.mesh.colors, gl.STATIC_DRAW)
    ////Texcoords
    //gl.BindBuffer(gl.ARRAY_BUFFER, entity.buffer_texcoords)
    //gl.BufferData(gl.ARRAY_BUFFER, len(entity.mesh.texcoords), &entity.mesh.texcoords, gl.STATIC_DRAW)
}

//Change material of static mesh component
componentMaterial :: proc(manager : ^ComponentManager, id : entity_id, material : Material){
    static_mesh := manager.static_meshes[id]
    static_mesh.material = material
    manager.static_meshes[id] = static_mesh
}

initStaticMesh :: proc(manager: ^ComponentManager, id: entity_id, mesh: Shape, material: Material){
    componentTransform(manager, id)
    componentStaticMesh(manager, id, mesh, material)
}

initCamera :: proc(manager: ^ComponentManager, id: entity_id, fov: f32, position: m.vec3, target: m.vec3) -> Camera {
    camera := Camera{}
    camera.position = position
    camera.target = target
    camera.forward_vec = m.normalize(target - position) 
    camera.up_vec = WORLD_UP_VEC
    camera.right_vec = m.normalize(m.cross(camera.forward_vec, camera.up_vec))
    camera.yaw = -90.0
    camera.pitch = 0.0
    camera.max_pitch = m.PI / 2.0 - 0.01
    setViewMatrix(&camera)
    setProjectionMatrix(&camera, fov, ASPECT_RATIO)

    manager.cameras[id] = camera
    return camera
}

