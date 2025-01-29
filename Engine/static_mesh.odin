package Engine

import "core:fmt"
import m "core:math/linalg/glsl"
import gl "vendor:OpenGL"

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

//Initialize static mesh component
componentStaticMesh :: proc(manager : ^ComponentManager, id : entity_id, mesh : Shape, material : Material){
    static_mesh := StaticMesh{}
    static_mesh.mesh = mesh
    static_mesh.material = material
    manager.static_meshes[id] = static_mesh
    initMeshBuffers(manager, id)
}
initMeshBuffers :: proc(manager: ^ComponentManager, id: entity_id){
    model := manager.static_meshes[id]

    // Generate buffers
    gl.GenBuffers(1, &model.buffer_vertices)
    gl.GenBuffers(1, &model.buffer_indices)
    // gl.GenBuffers(1, &model.buffer_normals)
    // gl.GenBuffers(1, &model.buffer_colors)
    // gl.GenBuffers(1, &model.buffer_texcoords)

    //Vertices
    gl.BindBuffer(gl.ARRAY_BUFFER, model.buffer_vertices)
    gl.BufferData(gl.ARRAY_BUFFER, len(model.mesh.vertices) * size_of(f32), &model.mesh.vertices, gl.STATIC_DRAW)
    //Indices
    gl.BindBuffer(gl.ELEMENT_ARRAY_BUFFER, model.buffer_indices)
    gl.BufferData(gl.ELEMENT_ARRAY_BUFFER, len(model.mesh.indices) * size_of(f32), &model.mesh.indices, gl.STATIC_DRAW)
    ////Normals
    //gl.BindBuffer(gl.ARRAY_BUFFER, model.buffer_normals)
    //gl.BufferData(gl.ARRAY_BUFFER, len(model.mesh.normals) * size_of(f32), &model.mesh.normals, gl.STATIC_DRAW)
    ////Colors
    //gl.BindBuffer(gl.ARRAY_BUFFER, model.buffer_colors)
    //gl.BufferData(gl.ARRAY_BUFFER, len(model.mesh.colors) * size_of(f32), &model.mesh.colors, gl.STATIC_DRAW)
    ////Texcoords
    //gl.BindBuffer(gl.ARRAY_BUFFER, model.buffer_texcoords)
    //gl.BufferData(gl.ARRAY_BUFFER, len(model.mesh.texcoords) * size_of(f32), &model.mesh.texcoords, gl.STATIC_DRAW)
    
    // Update the static mesh in the manager
    manager.static_meshes[id] = model
}

initStaticMesh :: proc(components: ^ComponentManager, entities: ^EntityManager, 
    mesh: Shape, material: Material) -> StaticMesh{
    id := entityCreate(entities)
    componentTransform(components, id)
    componentStaticMesh(components, id, mesh, material)
    return components.static_meshes[id]
}

//Change material of static mesh component
setStaticMeshMaterial :: proc(manager : ^ComponentManager, id : entity_id, material : Material){
    static_mesh := manager.static_meshes[id]
    static_mesh.material = material
    manager.static_meshes[id] = static_mesh
}

