package Engine

import "core:fmt"
import m "core:math/linalg/glsl"


main :: proc() {
    //Initialize pre-game
    fmt.println("Main started")
    construct(800, 600)
    fmt.println("Construct done")
    //Get scene entities
    scene01 := initScene01()
    fmt.println("Scene initialized")
    //Run game loop
    run(&scene01)
}

initScene01 :: proc() -> Scene {
    //Initialize managers and scene
    entity_manager01 : EntityManager
    component_manager01 : ComponentManager
    event_manager01 : EventManager
    
    scene01 := initScene("Scene 01", &entity_manager01, &component_manager01, &event_manager01)
    
    //Initialize camera
    camera01 := initCamera( //ID: 0
        &component_manager01,   //manager
        &entity_manager01,      //entities
        70.0,                   //fov
        m.vec3{0.0, 0.0, 10.0},  //position
        m.vec3{0.0, 0.0, 0.0}   //target
    )
    fmt.println("Camera initialized")
    //Initialize shaders
    sha_base01 := initShader("Shaders/vs_base01.glsl", "Shaders/fs_base01.glsl")
    fmt.println("Shaders initialized")
    //Initialize materials
    mat_red01 := initMaterial(&sha_base01, m.vec3{1.0, 0.0, 0.0})
    mat_blue01 := initMaterial(&sha_base01, m.vec3{0.0, 0.0, 1.0})
    
    //Initialize entities
    cube01 := initStaticMesh(
        &component_manager01,  //manager
        &entity_manager01,     //entities
        s_cube,                //mesh
        mat_red01              //material
    )
    
    tri01 := initStaticMesh(
        &component_manager01,  //manager
        &entity_manager01,     //entities
        s_triangle,            //mesh
        mat_blue01             //material
    )

    return scene01
}