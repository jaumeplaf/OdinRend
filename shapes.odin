package OdinRend

import "core:fmt"
//import "core:c"
//import "vendor:glfw"
//import gl "vendor:OpenGL"

shapes :: struct {
    vertices: []float32
    indices: []uint32
}

initShapes :: proc() {
    fmt.println("Initializing shapes")

     : shapes = shapes{
        vertices = []float32{
            1.0, 1.0, 1.0,
            1.0, 1.0, -1.0,
            1.0, -1.0, 
        },
        indices = []uint32{
            // front
            0, 1, 2,
            2, 3, 0,
            // top
            3, 2, 6,
            6, 7, 3,
            // back
            7, 6, 5,
            5, 4, 7,
            // bottom
            4, 5, 1,
            1, 0, 4,
            // left
            4, 0, 3,
            3, 7, 4,
            // right
            1, 5, 6,
            6, 2, 1,
        },
    }
}