extends Control

var STANDBY_POS = Vector2(3000, 0)
var ACTIVE_POS = Vector2(0, 0)

@onready
var text_input =  $LineEdit

@onready
var dialog_box = $DialogBox

@onready
var player = get_parent()

# Called when the node enters the scene tree for the first time.
func _ready():
	text_input.clear()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("return"):
		parse(text_input.text)
		text_input.clear()
		
func parse(str):
	if str == "left" && player.is_player_moving():
		player.move_left()
	elif str == "right" && player.is_player_moving():
		player.move_right()
	elif str == "down" && player.is_player_moving():
		player.move_down()
	elif str == "up" && player.is_player_moving():
		player.move_up()
	elif str == "enable wasd":
		player.toggle_movement()
	elif str == "hi":
		var npc = player.check_person()
		interact(npc)
	elif str == "bye" :
		dialog_box.position = STANDBY_POS

func interact(npc):
	if npc == "no one":
		return
	
	player.toggle_movement()
	dialog_box.position = ACTIVE_POS
