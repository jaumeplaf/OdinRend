package Engine

import "core:fmt"

//Define player struct

Player :: struct {
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
