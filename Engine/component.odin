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
    position, rotation, scale : m.vec3,
    model_matrix : m.mat4
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
    transform.model_matrix = m.identity(m.mat4)
    manager.transforms[id] = transform
}
//Initialize transform component with custom values
componentTransformInit :: proc(manager : ^ComponentManager, id : entity_id, position : m.vec3, rotation : f32, axis : m.vec3, scale : m.vec3){
    transform := Transform{}
    transform.model_matrix = m.identity(m.mat4)
    transform.position = position
    transform.rotation = rotation
    transform.scale = scale
    //Set model matrix
    transform.model_matrix = m.mat4Translate(transform.position) * m.mat4Scale(transform.scale)
    transform.model_matrix = transform.model_matrix * m.mat4Rotate(axis, m.radians_f32(rotation))

    manager.transforms[id] = transform
}

transformRotate :: proc(manager : ^ComponentManager, id : entity_id, rotation : f32, axis : m.vec3){
    transform := manager.transforms[id]
    transform.rotation = rotation
    //Set model matrix
    transform.model_matrix = transform.model_matrix * m.mat4Rotate(axis, m.radians_f32(rotation))

    manager.transforms[id] = transform
}

transformTranslateScale :: proc(manager : ^ComponentManager, id : entity_id, position : m.vec3, scale : m.vec3){
    transform := manager.transforms[id]
    transform.position = position
    transform.scale = scale
    //Set model matrix
    transform.model_matrix = m.mat4Translate(transform.position) * m.mat4Scale(transform.scale)

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
    mesh := manager.static_meshes[id]
    //Vertices
    gl.BindBuffer(gl.ARRAY_BUFFER, mesh.buffer_vertices)
    gl.BufferData(gl.ARRAY_BUFFER, len(mesh.mesh.vertices), &mesh.mesh.vertices, gl.STATIC_DRAW)
    //Indices
    gl.BindBuffer(gl.ELEMENT_ARRAY_BUFFER, mesh.buffer_indices)
    gl.BufferData(gl.ELEMENT_ARRAY_BUFFER, len(mesh.mesh.indices), &mesh.mesh.indices, gl.STATIC_DRAW)
    ////Normals
    //gl.BindBuffer(gl.ARRAY_BUFFER, mesh.buffer_normals)
    //gl.BufferData(gl.ARRAY_BUFFER, len(mesh.mesh.normals), &mesh.mesh.normals, gl.STATIC_DRAW)
    ////Colors
    //gl.BindBuffer(gl.ARRAY_BUFFER, mesh.buffer_colors)
    //gl.BufferData(gl.ARRAY_BUFFER, len(mesh.mesh.colors), &mesh.mesh.colors, gl.STATIC_DRAW)
    ////Texcoords
    //gl.BindBuffer(gl.ARRAY_BUFFER, mesh.buffer_texcoords)
    //gl.BufferData(gl.ARRAY_BUFFER, len(mesh.mesh.texcoords), &mesh.mesh.texcoords, gl.STATIC_DRAW)
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

updateModelMatrixUniform :: proc(manager: ^ComponentManager, id: entity_id){
    transform := manager.transforms[id]
    model_matrix := transform.model_matrix
    prog := manager.static_meshes[id].material.shader.program
    gl.UniformMatrix4fv(prog.model_matrix, 1, false, &model_matrix[0][0])
}

updateViewMatrixUniform :: proc(){
    //TODO: implement
}

updateProjectionMatrixUniform :: proc(){
    //TODO: implement
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

