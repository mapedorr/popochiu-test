extends Node
# (C) To make characters do things.
# ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓

# character is a PopochiuCharacter node
signal character_moved(character)
signal character_move_ended(character)
signal character_spoke(character, message)
signal character_say(chr_name, dialog)
signal character_grab_done(character)

var player: PopochiuCharacter = null
var characters := []


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos públicos ░░░░
func character_say(
	chr_name: String, dialog: String, is_in_queue := true
	) -> void:
	if is_in_queue: yield()

	var talking_character: PopochiuCharacter = get_character(chr_name)
	
	if talking_character:
		yield(talking_character.say(dialog, false), 'completed')
		
		if not is_in_queue:
			G.done()
	else:
		printerr(
			'[Popochiu] ICharacter.character_say:',
			'character %s not found' % chr_name
		)


func player_say(dialog: String, is_in_queue := true) -> void:
	if is_in_queue:
		yield()
		yield(player.say(dialog, false), 'completed')
	else:
		yield(player.say(dialog, false), 'completed')
		G.done()


func character_walk_to(
	chr_name: String, position: Vector2, is_in_queue := true
	) -> void:
	if is_in_queue: yield()
	
	var walking_character: PopochiuCharacter = get_character(chr_name)
	if walking_character:
		yield(walking_character.walk(position, false), 'completed')
	else:
		printerr(
			'[Popochiu] ICharacter.character_walk_to:',
			'character %s not found' % chr_name
		)


func player_walk_to(position: Vector2, is_in_queue := true) -> void:
	if is_in_queue: yield()
	yield(player.walk(position, false), 'completed')


func walk_to_clicked(is_in_queue := true) -> void:
	if is_in_queue: yield()
	yield(
		player_walk_to(E.clicked.walk_to_point + E.clicked.position, false),
		'completed'
	)


func face_clicked(is_in_queue := true) -> void:
	if is_in_queue: yield()
	
	if E.clicked.global_position < C.player.global_position:
		yield(C.player.face_left(false), 'completed')
	else:
		yield(C.player.face_right(false), 'completed')


func is_valid_character(chr_name: String) -> bool:
	for c in characters:
		if (c as PopochiuCharacter).script_name.to_lower() == chr_name.to_lower():
			return true
	return false


func get_character(script_name: String) -> PopochiuCharacter:
	for c in characters:
		if (c as PopochiuCharacter).script_name.to_lower() == script_name.to_lower():
			return c

	# Si el personaje no está en la lista de personajes, entonces hay que intentar
	# instanciarlo en base a la lista de personajes de Popochiu
	var new_character: PopochiuCharacter = E.get_character_instance(script_name)
	if new_character:
		characters.append(new_character)
		return new_character

	return null

# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos privados ░░░░
# ???
