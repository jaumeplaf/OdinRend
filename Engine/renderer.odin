package Engine

import "core:fmt"
import "core:c"
import "core:time"
import "base:runtime"
import "vendor:glfw"
import gl "vendor:OpenGL"
import m "core:math/linalg/glsl"

//Initialize OpenGL and create window
initGL :: proc(width : i32 = 800, height : i32 = 600) {

	//Initialize OpenGL
	if glfw.Init() != glfw.TRUE {
		fmt.println("Failed to initialize GLFW")
		return
	}

	//Window hints
	glfw.WindowHint(glfw.RESIZABLE, glfw.TRUE)
	glfw.WindowHint(glfw.OPENGL_FORWARD_COMPAT, glfw.TRUE)
	glfw.WindowHint(glfw.OPENGL_PROFILE, glfw.OPENGL_CORE_PROFILE)
	glfw.WindowHint(glfw.CONTEXT_VERSION_MAJOR, GL_MAJOR_VERSION)
	glfw.WindowHint(glfw.CONTEXT_VERSION_MINOR, GL_MINOR_VERSION) 

	//MacOS specific hints
	glfw.InitHint(glfw.WAYLAND_LIBDECOR, glfw.WAYLAND_PREFER_LIBDECOR)

	//Create window + context
	GAME_WINDOW = glfw.CreateWindow(width, height, "OdinRend", nil, nil)
	if GAME_WINDOW == nil {
		fmt.println("Unable to create window")
		return
	}

	fmt.println("Initialized window")


	ASPECT_RATIO = getAspectRatio_i32(width, height)
	
	// Load OpenGL functions
	
	//Set context
	glfw.MakeContextCurrent(GAME_WINDOW)
	//Enable depth test
	//gl.Enable(gl.DEPTH_TEST)
	////Initialize clear color
	//gl.ClearColor(1.0, 0.0, 1.0, 1.0)
	//gl.Clear(gl.COLOR_BUFFER_BIT)

	//Enable vsync
	glfw.SwapInterval(1)
	
	fmt.println("Initialized OpenGL functions") 

	//Enable callbacks
	glfw.SetKeyCallback(GAME_WINDOW, keyCallback)
	glfw.SetMouseButtonCallback(GAME_WINDOW, mouseCallback)
	glfw.SetCursorPosCallback(GAME_WINDOW, cursorPositionCallback)
	glfw.SetFramebufferSizeCallback(GAME_WINDOW, framebufferSizeCallback)
	//Set OpenGL version
	gl.load_up_to(GL_MAJOR_VERSION, GL_MINOR_VERSION, glfw.gl_set_proc_address)

	fmt.println("Initialized callbacks")


	//Check for errors after loading OpenGL functions
	if err := gl.GetError(); err != gl.NO_ERROR {
		fmt.println("OpenGL error after loading functions: %d\n", err)
		return
	}



	//Initialize time
	START_TIME = time.now()

	return
}

//Graphic loop
draw :: proc(entities: ^EntityManager, components: ^ComponentManager, events: ^EventManager) {
	gl.ClearColor(1.0, 0.0, 1.0, 1.0)
	gl.Clear(gl.COLOR_BUFFER_BIT | gl.DEPTH_BUFFER_BIT)

	glfw.SwapBuffers(GAME_WINDOW)
	glfw.PollEvents()

	//Draw all StaticMesh components
	for entity_id, static_mesh in components.static_meshes {
		camera := components.cameras[0]
		material := static_mesh.material
		program := material.shader.program.prog
		gl.UseProgram(program)

		updateUniforms(components, entity_id)

		drawTriangles(static_mesh)
	}
}

cleanup :: proc() {
	glfw.DestroyWindow(GAME_WINDOW)
	glfw.Terminate()
}

drawTriangles :: proc (model: StaticMesh) {
	vertices := model.mesh.vertices
	length := i32(len(vertices))
	gl.DrawElements(gl.TRIANGLES, length, gl.UNSIGNED_INT, nil)
}

initUniforms :: proc(shader: ^Shader){
	program := shader.program
    //Init vertex attributes
	gl.EnableVertexAttribArray(program.vertex_position)
    gl.EnableVertexAttribArray(program.indices)
    //Init uniforms
    program.model_matrix = gl.GetUniformLocation(program.prog, "model_matrix")
    program.view_matrix = gl.GetUniformLocation(program.prog, "view_matrix")
    program.projection_matrix = gl.GetUniformLocation(program.prog, "projection_matrix")
    program.color = gl.GetUniformLocation(program.prog, "color")
}

updateUniforms :: proc(components: ^ComponentManager, id: entity_id){
    mat := components.static_meshes[id].material
    prog := mat.shader.program 

    updateModelMatrixUniform(components, id)
    updateViewMatrixUniform(components, prog)
    updateProjectionMatrixUniform(components, prog)

	//Custom shader uniforms
    gl.Uniform4fv(mat.shader.program.color, 1, &mat.color[0])
}

updateModelMatrixUniform :: proc(manager: ^ComponentManager, id: entity_id){
    transform := manager.transforms[id]
    model_matrix := transform.model_matrix
    prog := manager.static_meshes[id].material.shader.program
    gl.UniformMatrix4fv(prog.model_matrix, 1, false, &model_matrix[0][0])
}

updateViewMatrixUniform :: proc(manager : ^ComponentManager, program: Program){
    view_matrix := manager.cameras[0].view_matrix
    gl.UniformMatrix4fv(program.view_matrix, 1, false, &view_matrix[0][0])
}

updateProjectionMatrixUniform :: proc(manager : ^ComponentManager, program : Program){
    projection_matrix := manager.cameras[0].projection_matrix
    gl.UniformMatrix4fv(program.projection_matrix, 1, false, &projection_matrix[0][0])
}