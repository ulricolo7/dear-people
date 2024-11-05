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

var end_screen
var time_display
var counter_display

var credits_screen

var in_dialog = false
var elapsed_time = 0.0
var input_counter = 0
var game_over = false

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
	
	if !$"../../AudioStreamPlayer2D".is_playing():
		$"../../AudioStreamPlayer2D".play()
	
	if !d_timer.is_paused() && d_timer.get_time_left() == 0 && !game_over:
		end_game()
	
	if Input.is_action_just_pressed("return") && !in_dialog:
		input_counter += 1
		parse(text_input.text)
		text_input.clear()
	elif Input.is_action_just_pressed("return"):
		input_counter += 1
		dialog_parse(text_input.text)
		text_input.clear()

func initialise():
	text_input =  $LineEdit
	player = get_parent()
	d_timer = $DialogTimer
	d_timer.set_paused(true)
	p_bar_1 = $SpeechDialogBox/ProgressBar
	p_bar_2 = $SpeechDialogBox/ProgressBar2
	
	#ADD NPC
	flash = $RedFlash
	end_screen = $EndScreen
	time_display = $EndScreen/TimeDisplay
	counter_display = $EndScreen/CounterDisplay
	
	credits_screen = $CreditsScreen
	
	npc_alex = $AlexDialogBox
	npc_alex_dialog = $AlexDialogBox/Label
	npc_alex_ans = $AlexDialogBox/Answer
	npc_mary = $MaryDialogBox
	npc_mary_dialog = $MaryDialogBox/Label
	npc_mary_ans = $MaryDialogBox/Answer
	npc_speech = $SpeechDialogBox
	npc_speech_dialog = $SpeechDialogBox/SpeechDisplay
	npc_speech_ans = $SpeechDialogBox/Answer

func parse(str):
	if str == "left" && player.is_player_moving():
		player.move_left()
	elif str == "right" && player.is_player_moving():
		player.move_right()
	elif str == "down" && player.is_player_moving():
		player.move_down()
	elif str == "up" && player.is_player_moving():
		player.move_up()
	elif str == "enable keys":
		player.enable_keys()
	elif str == "hi" && !in_dialog:
		var npc = player.check_person()
		interact(npc, 0)
	elif str == "credits":
		credits()

func dialog_parse(str):
	#ADD NPX
	if curr_npc == "Alex":
		if str == "bye":
			interact(curr_npc, -1)
			in_dialog = false
			return
		elif npc_alex_val == 0 && str != "no":
			if str != "nervous":
				mistake()
				return
		elif npc_alex_val == 1 && str != "cry":
			if str != "i move slow":
				mistake()
				return
		elif npc_alex_val == 2 && str != "huh?":
			if str != "duh?":
				mistake()
				return
		npc_alex_val += 1
		interact(curr_npc, npc_alex_val)

	elif curr_npc == "Mary":
		if str == "bye":
			interact(curr_npc, -1)
			in_dialog = false
			return
		elif npc_mary_val == 0 && str != "sorry":
			mistake()
			return
		elif npc_mary_val == 1 && str != "im okay":
			mistake()
			return
		elif npc_mary_val == 2 && str != "oh?":
			if str != "thanks!":
				mistake()
				return
		npc_mary_val += 1
		interact(curr_npc, npc_mary_val)

	elif curr_npc == "Speech":
		if str == "end" && npc_speech_val > 3:
			interact(curr_npc, -1)
			in_dialog = false
			return
		elif npc_speech_val == 0 && str != "gulp":
			if str != "talk":
				mistake()
				return
		elif npc_speech_val == 1 && str != "communication":
			mistake()
			return
		elif npc_speech_val == 2 && str != "go":
			mistake()
			return
		elif npc_speech_val == 3 && str != "intentional":
			mistake()
			return
		elif npc_speech_val == 3 && str == "":
			return
		npc_speech_val += 1
		interact(curr_npc, npc_speech_val)

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
		npc_alex_ans.text = "> \"cry\"\n" + "> \"i move slow\""
	elif i == 2:
		intensify(npc_alex, 1)
		npc_alex_dialog.text = "Did you know, you can move up and down too!\n" + "Just go \"up\" or \"down\"!"
		npc_alex_ans.text = "> \"huh?\"\n" + "> \"duh?\""
	else:
		intensify(npc_alex, 2)
		npc_alex_dialog.text = "Go\nbreak\na\nleg."
		npc_alex_ans.text = "> \"bye\"\n"

func set_mary(i):
	if i < 0:
		npc_mary.position = STANDBY_POS
		player.toggle_movement()
	elif i == 0:
		npc_mary.position = npc_mary.get("metadata/ACTIVE_POS")
		player.toggle_movement()
		in_dialog = true
	elif i == 1:
		intensify(npc_mary, 3)
		npc_mary_dialog.text = "OMG ARE YOU OKAY???\n\n" + "You have a speech soon.."
		npc_mary_ans.text = "> \"UHHH\"\n" + "> \"im okay\""
	elif i == 2:
		intensify(npc_mary, -1)
		npc_mary_dialog.text = "To help you move easier,\n" + "you can \"enable keys\" you know!"
		npc_mary_ans.text = "> \"oh?\"\n" + "> \"thanks!\""
	else:
		intensify(npc_mary, 3)
		npc_mary_dialog.text = "You can move with arrow keys now!\n\n All the best!"
		npc_mary_ans.text = "> \"bye\"\n"

func set_speech(i):
	if i < 0:
		npc_speech.position = STANDBY_POS
		end_game()
	elif i == 0:
		npc_speech.position = npc_speech.get("metadata/ACTIVE_POS")
		player.toggle_movement()
		in_dialog = true
		d_timer.start(10)
		d_timer.set_paused(false)
	elif i == 1:
		intensify(npc_speech, 1)
		npc_speech_dialog.text = "Dear People,\n\nI come here before you today to *GULP*\n" + "talk about the importance of.."
		npc_speech_ans.text = "> \"communication\"\n" + "> \"communion?\""
		d_timer.start(9)
	elif i == 2:
		intensify(npc_speech, 1)
		npc_speech_dialog.text = "Dear People,\n\nI come here before you today to *GULP*\n" + "talk about the importance of communication!\n" + "It is used everywhere we.."
		npc_speech_ans.text = "> \"go\"\n" + "> \"bo\""
		d_timer.start(8)
	elif i == 3:
		intensify(npc_speech, 1)
		npc_speech_dialog.text = "Dear People,\n\nI come here before you today to *GULP*\n" + "talk about the importance of communication!\n" + "It is used everywhere we GO and so, being.."
		npc_speech_ans.text = "> \"intense?\"\n" + "> \"intentional\""
		d_timer.start(7)
	else:
		intensify(npc_speech, -3)
		npc_speech_dialog.text = "Dear People,\n\nI come here before you today to *GULP*\n" + "talk about the importance of communication!\n" + "It is used everywhere we GO and so, being intentional is.."
		npc_speech_ans.text = "> \"end\"\n"
		d_timer.start(10)
		d_timer.set_paused(true)

func intensify(dialog, i):
	dialog.position += Vector2(-60 * i, -32.5 * i)
	dialog.set("metadata/ACTIVE_POS", dialog.position)
	dialog.position = dialog.get("metadata/ACTIVE_POS")
	var new_scale = dialog.scale + Vector2(i/10.0, i/10.0)
	dialog.set("scale", new_scale)

func mistake():
	flash.set_modulate(Color(255, 0, 0, 255))

func end_game():
	game_over = true
	in_dialog = false
	time_display.text = "%0.2f" % elapsed_time + "s"
	counter_display.text = str(input_counter)
	npc_speech.position = STANDBY_POS
	end_screen.position = Vector2(-25, -10)
	
func credits():
	end_screen.position = STANDBY_POS
	credits_screen.position = Vector2(-25, -10)
	text_input.set_visible(false)
