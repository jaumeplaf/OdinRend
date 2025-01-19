package Engine
import m "core:math/linalg/glsl"


main :: proc() {
    //Initialize pre-game
    construct(800, 600)
    //Get scene entities
    scene01 := initScene01()
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
    camera01 := entityCreate(&entity_manager01)
    initCamera(
        &component_manager01,   //manager
        camera01,               //id
        70.0,                   //fov
        m.vec3{0.0, 0.0, 3.0},  //position
        m.vec3{0.0, 0.0, 0.0}   //target
    )
    player01 = initPlayer()
    
    //Initialize shaders
    sha_base01 := initShader("../Shaders/vs_base01.glsl", "../Shaders/fs_base01.glsl")
    //Initialize materials
    mat_red01 := initMaterial(&sha_base01, m.vec3{1.0, 0.0, 0.0})
    mat_blue01 := initMaterial(&sha_base01, m.vec3{0.0, 0.0, 1.0})
    
    //Initialize entities
    cube01 := entityCreate(&entity_manager01)
    initStaticMesh(
        &component_manager01,  //manager
        cube01,                //id
        s_cube,         //mesh
        mat_red01              //material
    )
    
    tri01 := entityCreate(&entity_manager01)
    initStaticMesh(
        &component_manager01,  //manager
        tri01,                 //id
        s_triangle,     //mesh
        mat_blue01             //material
    )

    return scene01
}