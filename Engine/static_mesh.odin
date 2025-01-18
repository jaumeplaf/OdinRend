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

initStaticMesh :: proc(manager: ^ComponentManager, id: entity_id, mesh: Shape, material: Material){
    componentTransform(manager, id)
    componentStaticMesh(manager, id, mesh, material)
}

//Change material of static mesh component
setStaticMeshMaterial :: proc(manager : ^ComponentManager, id : entity_id, material : Material){
    static_mesh := manager.static_meshes[id]
    static_mesh.material = material
    manager.static_meshes[id] = static_mesh
}

