extends Node2D

var game_running: bool
var game_over: bool

var scroll: int
var score
const scroll_speed: int = 4 
var pipes: Array

#const pipe_delay
#const pipe_range

var screen_size : Vector2i #vector2i integers lega, whereas vector2 decimals leta hai

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
	screen_size = get_window().size
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

func _process(delta):
	if game_running:
		scroll += scroll_speed
		if scroll >= screen_size.x:
			scroll = 0
		$Ground.position.x = -scroll + 864
