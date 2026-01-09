package main

import "core:fmt"
import rl "vendor:raylib"

vec2 :: rl.Vector2
vec3 :: rl.Vector3

TITLE: cstring : "Raylib PSX"
WIDTH :: 1280
HEIGHT :: 720


main :: proc() {

	fmt.println("Raylib PSX implementation in Odin")

	rl.InitWindow(WIDTH, HEIGHT, TITLE)

	// Shader load
	ps1_shader := rl.LoadShader("shaders/ps1_vert.glsl", "shaders/ps1_frag.glsl")

	// Shader loc
	res_loc := rl.GetShaderLocation(ps1_shader, "resolution")
	internal_res := vec2{320, 240}
	rl.SetShaderValue(ps1_shader, res_loc, &internal_res, .VEC2)

	// Low Res Render Target
	target: rl.RenderTexture2D = rl.LoadRenderTexture(320, 240)
	rl.SetTextureFilter(target.texture, .POINT)

	// Load Model with the shader and the texture
	model: rl.Model = rl.LoadModel("assets/models/psx_retro_computer/scene.gltf")

	// we don't actually need to manually assign the texture
	texture: rl.Texture2D = rl.LoadTexture(
		"assets/models/psx_retro_computer/textures/M_RetroComputer_baseColor.png",
	)
	// model.materials[0].maps[rl.MaterialMapIndex.ALBEDO].texture = texture

	// Apply texture and shader to all of the material
	for i in 0 ..< model.materialCount {
		model.materials[i].shader = ps1_shader
	}

	// Camera things
	camera := rl.Camera3D {
		position   = {0, 2, -10},
		target     = {0, 0, 0},
		up         = {0, 1, 0},
		fovy       = 45,
		projection = .PERSPECTIVE,
	}
	camera_speed := 0.1


	rl.SetTargetFPS(60)

	// Cleanup
	defer {
		rl.UnloadTexture(texture)
		rl.UnloadModel(model)
		rl.UnloadRenderTexture(target)
		rl.UnloadShader(ps1_shader)
		rl.CloseWindow()
	}


	for !rl.WindowShouldClose() {
		rl.UpdateCamera(&camera, .FREE)

		// draw 3d model
		rl.BeginTextureMode(target)

		rl.ClearBackground(rl.BLACK)

		rl.BeginMode3D(camera)

		rl.DrawModel(model, vec3{0.0, 0.0, 0.0}, 2.5, rl.WHITE)
		rl.DrawGrid(10, 1.0)

		rl.EndMode3D()

		rl.EndTextureMode()


		rl.BeginDrawing()
		rl.ClearBackground(rl.BLACK)
		source_rec := rl.Rectangle {
			0.0,
			0.0,
			f32(target.texture.width),
			-f32(target.texture.height),
		}
		dest_rec := rl.Rectangle{0.0, 0.0, f32(rl.GetScreenWidth()), f32(rl.GetScreenHeight())}
		rl.DrawTexturePro(target.texture, source_rec, dest_rec, vec2{0, 0}, 0.0, rl.WHITE)
		rl.DrawFPS(10, 10)


		rl.EndDrawing()
	}
}
