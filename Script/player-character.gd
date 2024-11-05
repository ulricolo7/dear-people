extends CharacterBody2D

var STEP = 100

var LEFT_BOUNDARY = 50
var RIGHT_BOUNDARY = 1350
var TOP_BOUNDARY = 50
var BOTTOM_BOUNDARY = 750

var char_just_moved = false
var is_keys_enabled = false
var is_moving = true
var is_elevated = false

var DIRECTIONS = ["UP", "RIGHT", "DOWN", "LEFT"]

var can_move_towards = [true, true, true, true]

var curr_direction = DIRECTIONS[3]
var npc_name
var npc_loc

var anim_sprite
var up_collider
var down_collider
var right_collider
var left_collider
var ui

func _ready():
	initialise()
	idle()

func _process(delta):
	if char_just_moved:
		pass
	elif is_keys_enabled && is_moving:
		keys()
	
	if !Input.is_anything_pressed():
		idle()
		
func initialise():
	anim_sprite = $Scaler/AnimatedSprite2D
	up_collider = $Scaler/UpCollider
	right_collider = $Scaler/RightCollider
	down_collider = $Scaler/DownCollider
	left_collider = $Scaler/LeftCollider
	ui = $Ui

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

func keys():
	if Input.is_action_pressed("move_down"):
		move_down()
	elif Input.is_action_pressed("move_up"):
		move_up()
	elif Input.is_action_pressed("move_left"):
		move_left()
	elif Input.is_action_pressed("move_right"):
		move_right()

func is_player_moving():
	return is_moving

func toggle_movement():
	is_moving = !is_moving
	
func enable_keys():
	is_keys_enabled = true

func check_person():
	if curr_direction == npc_loc:
		return npc_name
	else:
		return "no one"

#collider logic
func _on_left_collider_body_entered(body):
	if body.is_in_group("Obstacle"):
		can_move_towards[3] = false
		if body.is_in_group("NPC"):
			npc_name = body.get_npc_name()
			npc_loc = DIRECTIONS[3]
	elif body.is_in_group("DownStepper") && is_elevated:
		position.y += 50
		ui.position.y -= 12.5
		is_elevated = false

func _on_left_collider_body_exited(body):
	if body.is_in_group("Obstacle"):
		can_move_towards[3] = true
		if body.is_in_group("NPC"):
			npc_name = "no one"

func _on_right_collider_body_entered(body):
	if body.is_in_group("Obstacle"):
		can_move_towards[1] = false
		if body.is_in_group("NPC"):
			npc_name = body.get_npc_name()
			npc_loc = DIRECTIONS[1]
	elif body.is_in_group("Stairs") && !is_elevated:
		position.y -= 50
		ui.position.y += 12.5
		is_elevated = true

func _on_right_collider_body_exited(body):
	if body.is_in_group("Obstacle"):
		can_move_towards[1] = true
		if body.is_in_group("NPC"):
			npc_name = "no one"

func _on_up_collider_body_entered(body):
	if body.is_in_group("Obstacle"):
		can_move_towards[0] = false
		if body.is_in_group("NPC"):
			npc_name = body.get_npc_name()
			npc_loc = DIRECTIONS[0]

func _on_up_collider_body_exited(body):
	if body.is_in_group("Obstacle"):
		can_move_towards[0] = true
		if body.is_in_group("NPC"):
			npc_name = "no one"

func _on_down_collider_body_entered(body):
	if body.is_in_group("Obstacle"):
		can_move_towards[2] = false
		if body.is_in_group("NPC"):
			npc_name = body.get_npc_name()
			npc_loc = DIRECTIONS[2]
	elif body.is_in_group("Mic"):
			npc_name = body.get_npc_name()
			npc_loc = DIRECTIONS[2]

func _on_down_collider_body_exited(body):
	if body.is_in_group("Obstacle"):
		can_move_towards[2] = true
		if body.is_in_group("NPC"):
			npc_name = "no one"
