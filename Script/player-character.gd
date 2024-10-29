extends CharacterBody2D

var STEP = 50
var start_pos = position
var LEFT_BOUNDARY = start_pos.x + 50
var RIGHT_BOUNDARY = start_pos.x + 1350

var char_just_moved = false

func _ready():
	$AnimatedSprite2D.play("default")

func _process(delta):
	
	if char_just_moved:
		pass
	elif Input.is_action_pressed("move_down"):
		position.y += STEP
		char_just_moved = true
	elif Input.is_action_pressed("move_up"):
		position.y -= STEP
		char_just_moved = true
	elif Input.is_action_pressed("move_left") && position.x != LEFT_BOUNDARY:
		position.x -= STEP
		char_just_moved = true
	elif Input.is_action_pressed("move_right") && position.x != RIGHT_BOUNDARY:
		position.x += STEP
		char_just_moved = true
	
	if !Input.is_anything_pressed():
		char_just_moved = false

