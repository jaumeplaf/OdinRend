package Engine

import "core:fmt"
import m "core:math/linalg/glsl"

// Define PlayerState enum
PlayerState :: enum {
	Idle,
	MovingForward,
	MovingBackward,
	MovingLeft,
	MovingRight,
	Sprinting,
	Jumping,
	Crouching,
}

// Define player struct
Player :: struct {
	camera:     ^Camera,
	move_speed: f32,
	state:      PlayerState,
}

initPlayer :: proc(manager: ^ComponentManager, id: entity_id, camera: ^Camera) -> Player {
	player := Player{}
	player.camera = camera
	player.move_speed = 0.05
	player.state = PlayerState.Idle

	manager.players[id] = player

	return player
}

updatePlayerPosition :: proc(player: ^Player) {
	// Update player position based on state
	switch player.state {
	    case PlayerState.MovingForward:
	    	player.camera.position[0] += player.camera.forward_vec[0] * player.move_speed
	    	player.camera.position[2] += player.camera.forward_vec[2] * player.move_speed
	    	player.camera.target[0] += player.camera.forward_vec[0] * player.move_speed
	    	player.camera.target[2] += player.camera.forward_vec[2] * player.move_speed
	    case PlayerState.MovingBackward:
	    	player.camera.position[0] -= player.camera.forward_vec[0] * player.move_speed
	    	player.camera.position[2] -= player.camera.forward_vec[2] * player.move_speed
	    	player.camera.target[0] -= player.camera.forward_vec[0] * player.move_speed
	    	player.camera.target[2] -= player.camera.forward_vec[2] * player.move_speed
	    case PlayerState.MovingLeft:
	    	player.camera.position[0] -= player.camera.right_vec[0] * player.move_speed
	    	player.camera.position[2] -= player.camera.right_vec[2] * player.move_speed
	    	player.camera.target[0] -= player.camera.right_vec[0] * player.move_speed
	    	player.camera.target[2] -= player.camera.right_vec[2] * player.move_speed
	    case PlayerState.MovingRight:
	    	player.camera.position[0] += player.camera.right_vec[0] * player.move_speed
	    	player.camera.position[2] += player.camera.right_vec[2] * player.move_speed
	    	player.camera.target[0] += player.camera.right_vec[0] * player.move_speed
	    	player.camera.target[2] += player.camera.right_vec[2] * player.move_speed
	}

	// Update view matrix
	setViewMatrix(&player.camera)
} 

sprint :: proc(player: ^Player, mult: f32) {
	player.state = PlayerState.Sprinting
	original_speed := player.move_speed
	player.move_speed *= mult
	defer {
		player.move_speed = original_speed
		player.state = PlayerState.Idle
	}
}

jump :: proc(player: ^Player, jump_height: f32) {
	fmt.println("Jumping!")
	player.state = PlayerState.Jumping
	// TODO: Implement jump
}

crouch :: proc(player: ^Player, crouch_height: f32) {
	fmt.println("Crouching!")
	player.state = PlayerState.Crouching
	// TODO: Implement crouch
}