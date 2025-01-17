package Engine

import "core:fmt"
import m "core:math/linalg/glsl"

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