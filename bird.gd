extends CharacterBody2D

const gravity = 1000
const max_velocity = 600
const flap_speed = -500
var flying: bool = false
var falling: bool = true
const start_pos = Vector2(100,400)

func _ready():
	reset()
func reset():
	flying = true
	falling = true
	var _posn = start_pos
	set_rotation(0)
	
func _physics_process(delta):
	if flying or falling:
		velocity.y += gravity*delta
		if velocity.y > max_velocity:
			velocity.y = max_velocity
		if falling:
			set_rotation(deg_to_rad(velocity.y*0.05))
			$AnimatedSprite2D.play()
		else:
			set_rotation(PI/2)
			$AnimatedSprite2D.stop()
		move_and_collide(velocity*delta)
		if Input.is_action_just_pressed("flap"):
			flap(delta)
	else:
		$AnimatedSprite2D.stop()
func flap(delta):
		velocity.y = flap_speed + gravity*delta
		
