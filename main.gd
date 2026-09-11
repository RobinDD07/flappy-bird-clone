extends Node2D

var game_running: bool
var game_over: bool

var scroll
var score
const scroll_speed: int = 4 
var pipes: Array

#const pipe_delay
#const pipe_range

func new_game():
	game_running = false
	game_over = false
	$bird.reset()
	
func start_game():
	game_running = true
	$bird.flying = true
	$bird.falling = false
	$bird.flap(get_process_delta_time())

func _ready():
	new_game()

func _input(event):
	if game_over == false:
		if event is InputEventKey and event.pressed:
			if event.keycode == KEY_SPACE:
				if game_running == false:
					start_game()
				else:
					if $bird.flying:
						$bird.flap(get_process_delta_time())
