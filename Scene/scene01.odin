package Scenes

import "../Engine"
import m "core:math/linalg/glsl"

main :: proc(){

    
    //Initialize managers and scene
    entity_manager01 : Engine.EntityManager
    component_manager01 : Engine.ComponentManager
    scene01 := Engine.initScene("Scene 01", &entity_manager01, &component_manager01)
    
    Engine.construct(&scene01)

    sha_base01 := Engine.initShader()
    mat_red01 := Engine.initMaterial(sha_base01, m.vec3{1.0, 0.0, 0.0})

    //Initialize entities
    cube01 := Engine.entityCreate(&entity_manager01)
    Engine.initStaticMesh(
        &component_manager01,  //manager
        cube01,                //id
        Engine.s_cube,         //mesh
        m.vec3{0.0, 0.0, 0.0}, //position
        m.vec3{0.0, 0.0, 0.0}, //rotation
        m.vec3{5.0, 5.0, 5.0}, //scale
        mat_red01
    )

    tri01 := Engine.entityCreate(&entity_manager01)
    Engine.initStaticMesh(
        &component_manager01,  //manager
        tri01,                 //id
        Engine.s_triangle,     //mesh
        m.vec3{0.0, 0.0, 0.0}, //position
        m.vec3{0.0, 0.0, 0.0}, //rotation
        m.vec3{1.0, 1.0, 1.0}, //scale
        mat_red01
    )
}