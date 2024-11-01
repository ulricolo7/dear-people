extends Control

@onready
var text_input =  $LineEdit

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
	if str == "left":
		player.move_left()
	elif str == "right":
		player.move_right()
	elif str == "down":
		player.move_down()
	elif str == "up":
		player.move_up()
	elif str == "enable wasd":
		player.enable_wasd()
	elif str == "tlk":
		var npc = player.check_person()
		interact(npc)

func interact(npc):
	print("interacting with ", npc)
