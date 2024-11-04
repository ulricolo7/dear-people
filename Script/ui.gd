extends Control

var STANDBY_POS = Vector2(3000, 0)
var ACTIVE_POS = Vector2(-20, 0)

var text_input
var dialog_box
var player

var curr_npc

#ADD NPC
var npc_alex
var npc_alex_dialog
var npc_alex_ans
var npc_alex_val = 0
var npc_mary
var npc_mary_dialog
var npc_mary_ans
var npc_mary_val = 0

var in_dialog = false

func _ready():
	initialise()
	text_input.clear()

func _process(delta):
	if Input.is_action_just_pressed("return") && !in_dialog:
		parse(text_input.text)
		text_input.clear()
	elif Input.is_action_just_pressed("return"):
		dialog_parse(text_input.text)
		text_input.clear()

func initialise():
	text_input =  $LineEdit
	player = get_parent()
	
	#ADD NPC
	npc_alex = $AlexDialogBox
	npc_alex_dialog = $AlexDialogBox/Label
	npc_alex_ans = $AlexDialogBox/Answer
	npc_mary = $MaryDialogBox
	npc_mary_dialog = $MaryDialogBox/Label

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
	elif str == "hi" && !in_dialog:
		var npc = player.check_person()
		interact(npc, 0)
	

func dialog_parse(str):
	if curr_npc == "Alex":
		if str == "bye":
			interact(curr_npc, -1)
			in_dialog = false
		else:
			npc_alex_val += 1
			interact(curr_npc, npc_alex_val)

func interact(npc, i):
	#ADD NPC
	curr_npc = npc
	if npc == "no one":
		return
	elif npc == "Alex":
		set_alex(i)
	elif npc == "Mary":
		set_mary(i)
		
	

#ADD NPC
func set_alex(i):
	if i < 0:
		npc_alex.position = STANDBY_POS
		player.toggle_movement()
	elif i == 0:
		npc_alex.position = ACTIVE_POS
		player.toggle_movement()
		in_dialog = true
	elif i == 1:
		npc_alex_dialog.text = "You'll be fine.\n\n" + "Don't worry\ntoo much"
		npc_alex_ans.text = "> \"ok\"\n" + "> \"nervous\""
	else:
		npc_alex_dialog.text = "You can say\nbye now."
		npc_alex_ans.text = "> \"bye\"\n"

func set_mary(i):
	if i < 0:
		npc_mary.position = STANDBY_POS
	elif i == 0:
		npc_mary.position = ACTIVE_POS
