extends Control

var STANDBY_POS = Vector2(3000, 0)
var ACTIVE_POS = Vector2(-25, 0)

var text_input
var dialog_box
var player
var d_timer
var p_bar_1
var p_bar_2
var flash

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

var npc_speech
var npc_speech_dialog
var npc_speech_ans
var npc_speech_val = 0

var in_dialog = false
var elapsed_time = 0.0

func _ready():
	initialise()
	text_input.clear()

func _process(delta):
	p_bar_1.value = d_timer.get_time_left() * 10.0
	p_bar_2.set_value(d_timer.get_time_left() * 10.0)
	
	elapsed_time += delta
	var minutes = int(elapsed_time / 60)
	var seconds = int(elapsed_time) % 60
	
	#this solution needs to be put up in a museum
	var x = flash.get_modulate().a - 40
	flash.set_modulate(Color(255, 0, 0, x))
	
	if Input.is_action_just_pressed("return") && !in_dialog:
		parse(text_input.text)
		text_input.clear()
	elif Input.is_action_just_pressed("return"):
		dialog_parse(text_input.text)
		text_input.clear()

func initialise():
	text_input =  $LineEdit
	player = get_parent()
	d_timer = $DialogTimer
	p_bar_1 = $SpeechDialogBox/ProgressBar
	p_bar_2 = $SpeechDialogBox/ProgressBar2
	
	#ADD NPC
	flash = $RedFlash
	npc_alex = $AlexDialogBox
	npc_alex_dialog = $AlexDialogBox/Label
	npc_alex_ans = $AlexDialogBox/Answer
	npc_mary = $MaryDialogBox
	npc_mary_dialog = $MaryDialogBox/Label
	npc_mary_ans = $MaryDialogBox/Answer
	npc_speech = $SpeechDialogBox
	npc_speech_dialog = $SpeechDialogBox/SpeechDisplay

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
	#ADD NPX
	if curr_npc == "Alex":
		if str == "bye":
			interact(curr_npc, -1)
			in_dialog = false
		elif str == "o":
			mistake()
		else:
			npc_alex_val += 1
			interact(curr_npc, npc_alex_val)
	elif curr_npc == "Mary":
		if str == "bye":
			interact(curr_npc, -1)
			in_dialog = false
	elif curr_npc == "Speech":
		if str == "bye":
			interact(curr_npc, -1)
			in_dialog = false

func interact(npc, i):
	#ADD NPC
	curr_npc = npc
	if npc == "no one":
		return
	elif npc == "Alex":
		set_alex(i)
	elif npc == "Mary":
		set_mary(i)
	elif npc == "Speech":
		set_speech(i)		

#ADD NPC
func set_alex(i):
	if i < 0:
		npc_alex.position = STANDBY_POS
		player.toggle_movement()
	elif i == 0:
		npc_alex.position = npc_alex.get("metadata/ACTIVE_POS")
		player.toggle_movement()
		in_dialog = true
	elif i == 1:
		intensify(npc_alex, 1)
		npc_alex_dialog.text = "You'll be fine.\n\n" + "Don't worry too much"
		npc_alex_ans.text = "> \"ok\"\n" + "> \"cry\""
	else:
		intensify(npc_alex, 2)
		npc_alex_dialog.text = "You can say bye now."
		npc_alex_ans.text = "> \"bye\"\n"

func set_mary(i):
	if i < 0:
		npc_mary.position = STANDBY_POS
	elif i == 0:
		npc_mary.position = ACTIVE_POS
		in_dialog = true

func set_speech(i):
	if i < 0:
		npc_speech.position = STANDBY_POS
	elif i == 0:
		npc_speech.position = ACTIVE_POS
		in_dialog = true
		d_timer.start(10)
		

func intensify(dialog, i):
	dialog.position += Vector2(-60 * i, -32.5 * i)
	dialog.set("metadata/ACTIVE_POS", dialog.position)
	dialog.position = npc_alex.get("metadata/ACTIVE_POS")
	var new_scale = dialog.scale + Vector2(i/10.0, i/10.0)
	dialog.set("scale", new_scale)

func mistake():
	flash.set_modulate(Color(255, 0, 0, 255))
