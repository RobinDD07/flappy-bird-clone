extends Node2D

@export var pipe_scene: PackedScene

var game_running: bool
var game_over: bool

var scroll: int
var score: int
var scroll_speed: int = 4 
var pipes: Array

const pipe_delay: int = 100
const pipe_range: int = 200

var screen_size : Vector2i #vector2i integers lega, whereas vector2 decimals leta hai
var ground_height: int

func new_game():
	$"Game Over".hide()
	$Start.show()
	score = 0
	$ScoreLabel.text = "SCORE : 0"
	game_running = false
	game_over = false
	pipes.clear()
	scroll_speed = 4
	$bird.reset()
	get_tree().call_group("pipes", "queue_free")
	
func start_game():
	$Start.hide()
	game_running = true
	$bird.flying = true
	$bird.falling = false
	$bird.flap(get_process_delta_time())
	generate_pipes()
	$PipeTimer.start()
	
func stop_game():
	$"Game Over".show()
	$PipeTimer.stop()
	$bird.flying=false
	#$bird.falling=true
	game_running=false
	game_over=true


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
						check_top()

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
	pipe.hit.connect(bird_hit)  #do NOT use parenthesis here. function call will return null
	pipe.scored.connect(scored)
	add_child(pipe)
	pipes.append(pipe)
	

func check_top():
	if $bird.position.y<0:
		$bird.falling=true
		stop_game()
func bird_hit():
	$bird.falling=true
	stop_game()
func _on_ground_hit() -> void:
	$bird.falling=false
	stop_game()

func scored():
	score+=1
	$ScoreLabel.text = "Score : " + str(score)
	if score%10 == 0:
		scroll_speed += 1


func _on_game_over_restart() -> void:
	new_game()
