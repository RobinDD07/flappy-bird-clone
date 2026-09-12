extends CharacterBody2D

const gravity = 1000
const max_velocity = 600
const flap_speed = -440
var flying: bool = false
var falling: bool = false
const start_pos = Vector2(100,400)

func _ready():
	reset()
func reset():
	flying = false
	falling = false
	var _posn = start_pos
	set_rotation(0)
	
func _physics_process(delta):
	if flying or falling:
		velocity.y += gravity*delta
		if velocity.y > max_velocity:
			velocity.y = max_velocity
		if not falling:
			set_rotation(deg_to_rad(velocity.y*0.05))
			if not $AnimatedSprite2D.is_playing():
				$AnimatedSprite2D.play()
		else:
			set_rotation(PI/2)
			$AnimatedSprite2D.stop()
		move_and_collide(velocity*delta)
	else:
		$AnimatedSprite2D.stop()
func flap(delta):
		velocity.y = flap_speed + gravity*delta
