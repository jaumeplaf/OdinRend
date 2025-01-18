package Engine

import "core:fmt"
import m "core:math/linalg/glsl"

//Define player struct

Player :: struct {
    camera:        Camera,
    move_speed:    f32,
    move_forward:  bool,
    move_backward: bool,
    move_left:     bool,
    move_right:    bool,
    move_sprint:   bool,
    move_jump:     bool,
    move_crouch:   bool,
    is_moving:     bool,
}

updatePlayerPosition :: proc(player: ^Player) {
    //Update player position
    if player.move_forward {
        player.camera.position[0] += player.camera.forward_vec[0] * player.move_speed
        player.camera.position[2] += player.camera.forward_vec[2] * player.move_speed
        player.camera.target[0] += player.camera.forward_vec[0] * player.move_speed
        player.camera.target[2] += player.camera.forward_vec[2] * player.move_speed
    }
    if player.move_backward {
        player.camera.position[0] -= player.camera.forward_vec[0] * player.move_speed
        player.camera.position[2] -= player.camera.forward_vec[2] * player.move_speed
        player.camera.target[0] -= player.camera.forward_vec[0] * player.move_speed
        player.camera.target[2] -= player.camera.forward_vec[2] * player.move_speed
    }
    if player.move_left {
        player.camera.position[0] -= player.camera.right_vec[0] * player.move_speed
        player.camera.position[2] -= player.camera.right_vec[2] * player.move_speed
        player.camera.target[0] -= player.camera.right_vec[0] * player.move_speed
        player.camera.target[2] -= player.camera.right_vec[2] * player.move_speed
    }
    if player.move_right {
        player.camera.position[0] += player.camera.right_vec[0] * player.move_speed
        player.camera.position[2] += player.camera.right_vec[2] * player.move_speed
        player.camera.target[0] += player.camera.right_vec[0] * player.move_speed
        player.camera.target[2] += player.camera.right_vec[2] * player.move_speed
    }

    //Update view matrix
    setViewMatrix(&player.camera)
} 

sprint :: proc(player: ^Player, mult: f32) {
    original_speed := player.move_speed
    player.move_speed *= mult
    defer player.move_speed = original_speed
}

jump :: proc(player: ^Player, jump_height: f32) {
    fmt.println("Jumping!")
    //TODO: Implement jump
}

crouch :: proc(player: ^Player, crouch_height: f32) {
    fmt.println("Crouching!")
    //TODO: Implement crouch
}