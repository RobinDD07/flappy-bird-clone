extends Node2D

@export var pipe_scene: PackedScene

var game_running: bool
var game_over: bool

var scroll: int
var score
const scroll_speed: int = 4 
var pipes: Array

const pipe_delay: int = 100
const pipe_range: int = 200

var screen_size : Vector2i #vector2i integers lega, whereas vector2 decimals leta hai
var ground_height: int

func new_game():
	game_running = false
	game_over = false
	pipes.clear()
	generate_pipes()
	$bird.reset()
	$PipeTimer.start()
	
func start_game():
	game_running = true
	$bird.flying = true
	$bird.falling = false
	$bird.flap(get_process_delta_time())

func _ready():
	screen_size = get_window().size
	ground_height = $ground.get_node("Sprite2D").texture.get_height()
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
		$ground.position.x = -scroll + 864
		
		for pipe in pipes:
			pipe.position.x -= scroll_speed + delta



func _on_pipe_timer_timeout() -> void:
	generate_pipes()
	
func generate_pipes():
	var pipe = pipe_scene.instantiate()
	pipe.position.x = screen_size.x + pipe_delay
	pipe.position.y = (screen_size.y - ground_height)/2 + randi_range(-pipe_range, pipe_range)
	#pipe.hit.connect(bird_hit)
	add_child(pipe)
	pipes.append(pipe)
