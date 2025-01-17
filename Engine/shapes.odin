package Engine

import "core:fmt"

Shape :: struct {
    vertices: []f32,
    indices: []u32
}

s_triangle := Shape{
    vertices = []f32{
        0.0,  0.5, 0.0,
        0.5, -0.5, 0.0,
       -0.5, -0.5, 0.0
    },
    indices = []u32{
        0, 1, 2
    },
}

s_plane := Shape{
    vertices = []f32{
        -0.5, 0.0, 0.5,
         0.5, 0.0, 0.5,
         0.5, 0.0,-0.5,
        -0.5, 0.0,-0.5
    },
    indices = []u32{
        0, 1, 2, 
        0, 2, 3
    },
}

s_cube := Shape{
    vertices = []f32{
        -0.5, -0.5,  0.5,
         0.5, -0.5,  0.5,
         0.5,  0.5,  0.5,
        -0.5,  0.5,  0.5,
         0.5, -0.5,  0.5,
         0.5, -0.5, -0.5,
         0.5,  0.5, -0.5,
         0.5,  0.5,  0.5,
         0.5, -0.5, -0.5,
        -0.5, -0.5, -0.5,
        -0.5,  0.5, -0.5,
         0.5,  0.5, -0.5,
        -0.5, -0.5, -0.5,
        -0.5, -0.5,  0.5,
        -0.5,  0.5,  0.5,
        -0.5,  0.5, -0.5,
        -0.5,  0.5,  0.5,
         0.5,  0.5,  0.5,
         0.5,  0.5, -0.5,
        -0.5,  0.5, -0.5,
        -0.5, -0.5, -0.5,
         0.5, -0.5, -0.5,
         0.5, -0.5,  0.5,
        -0.5, -0.5,  0.5
    },
    indices = []u32{
        0,  1,  2, 
        0,  2,  3,
        4,  5,  6,
        4,  6,  7,
        8,  9, 10,
        8, 10, 11,
       12, 13, 14,
       12, 14, 15,
       16, 17, 18,
       16, 18, 19,
       20, 21, 22,
       20, 22, 23
    }
}
