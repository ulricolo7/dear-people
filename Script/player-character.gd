extends CharacterBody2D

var STEP = 100

var LEFT_BOUNDARY = 50
var RIGHT_BOUNDARY = 1350
var TOP_BOUNDARY = 50
var BOTTOM_BOUNDARY = 750

var char_just_moved = false
var is_wasd_enabled = true

var DIRECTIONS = ["UP", "RIGHT", "DOWN", "LEFT"]

var can_move_towards = [true, true, true, true]

var curr_direction = DIRECTIONS[3]

var anim_sprite
var up_collider
var down_collider
var right_collider
var left_collider

func _ready():
	initialise()
	idle()

func _process(delta):
	if char_just_moved:
		pass
	elif is_wasd_enabled:
		moving()
	
	if !Input.is_anything_pressed():
		idle()
		
func initialise():
	anim_sprite = $AnimatedSprite2D
	up_collider = $UpCollider
	right_collider = $RightCollider
	down_collider = $DownCollider
	left_collider = $LeftCollider

func move_up():
	curr_direction = DIRECTIONS[0]
	if can_move_towards[0]:
		anim_sprite.play("run_up")
		position.y -= STEP
		char_just_moved = true
	
func move_right():
	curr_direction = DIRECTIONS[1]
	anim_sprite.flip_h = false
	if can_move_towards[1]:
		anim_sprite.play("run")
		position.x += STEP
		char_just_moved = true
	
func move_down():
	curr_direction = DIRECTIONS[2]
	if can_move_towards[2]:
		anim_sprite.play("run_down")
		position.y += STEP
		char_just_moved = true

func move_left():
	curr_direction = DIRECTIONS[3]
	anim_sprite.flip_h = true
	if can_move_towards[3]:
		anim_sprite.play("run")
		position.x -= STEP
		char_just_moved = true

func idle():
	if curr_direction == DIRECTIONS[0]:
		anim_sprite.play("idle_up")
	elif curr_direction == DIRECTIONS[2]:
		anim_sprite.play("idle_down")
	else:
		anim_sprite.play("idle")
		
	char_just_moved = false

func moving():
	if Input.is_action_pressed("move_down"):
		move_down()
	elif Input.is_action_pressed("move_up"):
		move_up()
	elif Input.is_action_pressed("move_left"):
		move_left()
	elif Input.is_action_pressed("move_right"):
		move_right()

func enable_wasd():
	is_wasd_enabled = true




#collider logic
func _on_left_collider_body_entered(body):
	if body.is_in_group("Obstacle"):
		can_move_towards[3] = false

func _on_left_collider_body_exited(body):
	if body.is_in_group("Obstacle"):
		can_move_towards[3] = true

func _on_right_collider_body_entered(body):
	if body.is_in_group("Obstacle"):
		can_move_towards[1] = false

func _on_right_collider_body_exited(body):
	if body.is_in_group("Obstacle"):
		can_move_towards[1] = true

func _on_up_collider_body_entered(body):
	if body.is_in_group("Obstacle"):
		can_move_towards[0] = false

func _on_up_collider_body_exited(body):
	if body.is_in_group("Obstacle"):
		can_move_towards[0] = true

func _on_down_collider_body_entered(body):
	if body.is_in_group("Obstacle"):
		can_move_towards[2] = false

func _on_down_collider_body_exited(body):
	if body.is_in_group("Obstacle"):
		can_move_towards[2] = true
