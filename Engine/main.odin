package Engine

import "core:fmt"

construct :: proc(scene : ^Scene) {
	fmt.println("Hellope! Initializing context")
	initGL(800, 600)
}

run :: proc(scene: ^Scene) {
	fmt.println("Starting game!")
	gameLoop()
}

initManagers :: proc() -> (EntityManager, ComponentManager) {
	entity_manager := EntityManager{}
	entity_manager.alive = map[entity_id]bool{}
	entity_manager.next_id = 0

	component_manager := ComponentManager{}
	component_manager.transforms = map[entity_id]Transform{}
	//component_manager.visibilities = map[entity_id]Visibility{}
	component_manager.static_meshes = map[entity_id]StaticMesh{}
	component_manager.lights = map[entity_id]Light{}

	return entity_manager, component_manager
}

