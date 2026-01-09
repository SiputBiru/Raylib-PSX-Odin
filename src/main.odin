package main

import "core:fmt"
import rl "vendor:raylib"

vec2: rl.Vector2

TITLE: cstring : "Raylib PSX"
WIDTH :: 1280
HEIGHT :: 720

main :: proc() {

	fmt.println("Raylib PSX implementation in Odin")

	rl.InitWindow(WIDTH, HEIGHT, TITLE)
	defer rl.CloseWindow()

	for !rl.WindowShouldClose() {
		rl.BeginDrawing()
		rl.ClearBackground(rl.WHITE)

		rl.EndDrawing()


	}
}
