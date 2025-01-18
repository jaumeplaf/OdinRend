package Engine

import "core:fmt"
import m "core:math/linalg/glsl"
import gl "vendor:OpenGL"

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



rotateView :: proc(camera: ^Camera, deltaYaw: f32, deltaPitch: f32) {
    camera.yaw += deltaYaw
    camera.pitch += deltaPitch
    camera.pitch = m.max(-camera.max_pitch, m.min(camera.max_pitch, camera.pitch))
    camera.forward_vec = m.normalize(m.vec3{
        m.cos(camera.pitch) * m.sin(camera.yaw), 
        m.sin(camera.pitch), 
        m.cos(camera.pitch) * m.cos(camera.yaw)
    })
    camera.target = camera.position + camera.forward_vec
    setViewMatrix(camera)
    setProjectionMatrix(camera, 70.0, 800.0 / 600.0)
}

setViewMatrix :: proc(camera: ^Camera){
    camera.view_matrix = m.mat4LookAt(camera.position, camera.target, camera.up_vec)
}

setProjectionMatrix :: proc(camera: ^Camera, fov: f32, aspect_ratio: f32){
    camera.projection_matrix = m.mat4Perspective(m.radians_f32(fov), aspect_ratio, 0.1, 100.0) 
}

updateModelMatrixUniform :: proc(manager: ^ComponentManager, id: entity_id){
    transform := manager.transforms[id]
    model_matrix := transform.model_matrix
    prog := manager.static_meshes[id].material.shader.program
    gl.UniformMatrix4fv(prog.model_matrix, 1, false, &model_matrix[0][0])
}

updateViewMatrixUniform :: proc(manager : ^ComponentManager, id : entity_id){
    transform := manager.transforms[id]
    view_matrix := manager.cameras[id].view_matrix
    prog := manager.static_meshes[id].material.shader.program
    gl.UniformMatrix4fv(prog.view_matrix, 1, false, &view_matrix[0][0])
}

updateProjectionMatrixUniform :: proc(manager : ^ComponentManager, id : entity_id){
    transform := manager.transforms[id]
    projection_matrix := manager.cameras[id].projection_matrix
    prog := manager.static_meshes[id].material.shader.program
    gl.UniformMatrix4fv(prog.projection_matrix, 1, false, &projection_matrix[0][0])
}