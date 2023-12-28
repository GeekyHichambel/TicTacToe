extends Node

@export var circle_scene : PackedScene
@export var cross_scene : PackedScene

var player: int
var grid_data: Array 
var grid_pos: Vector2i
var board_size: int 
var cell_size: int
var row_sum: int
var col_sum: int
var dia1_sum: int
var dia2_sum: int
var winner: int
var moves: int 

# Called when the node enters the scene tree for the first time.
func _ready():
	board_size = $GameBoard.texture.get_width()
	cell_size = board_size/3 
	new_game()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func new_game():
	player = 1
	moves = 0
	winner = 0
	grid_data = [[0,0,0] , [0,0,0], [0,0,0]]
	row_sum = 0
	col_sum = 0
	dia1_sum = 0
	dia2_sum = 0
	get_tree().call_group("Circles", "queue_free")
	get_tree().call_group("Crosses", "queue_free")
	$GameOverScreen.hide()
	get_tree().paused = false
	
func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			if event.position.x < board_size:
				grid_pos = Vector2i(event.position/cell_size)
				if grid_data[grid_pos.y][grid_pos.x] == 0:
					grid_data[grid_pos.y][grid_pos.x] = player
					moves+=1
					place_marker(player, grid_pos * cell_size + Vector2i(cell_size/2, cell_size/2))
					if check_win() == 1:
						print('Player 1 wins')
						get_tree().paused = true
						$GameOverScreen/gameoverlabel.text = 'Player 1 wins!'
						$GameOverScreen.show()
						
					elif check_win() == -1:
						print('PLayer 2 wins')
						get_tree().paused = true
						$GameOverScreen/gameoverlabel.text = 'Player 2 wins!'
						$GameOverScreen.show()
						
					elif moves == 9:
						print('No one wins')
						get_tree().paused = true
						$GameOverScreen/gameoverlabel.text = 'A Tie 😐!'
						$GameOverScreen.show()
								
					player *= -1
					
				else:
					print('Position alreday filled')	
					
func place_marker(player, position):
	# A cross
	if player == -1:
		var cross = cross_scene.instantiate()
		cross.position = position
		add_child(cross)
	# A circle	
	else:
		var circle = circle_scene.instantiate()
		circle.position = position
		add_child(circle)
		
func check_win():
	for i in len(grid_data):
		row_sum = grid_data[i][0] + grid_data[i][1] + grid_data[i][2]
		col_sum = grid_data[0][i] + grid_data[1][i] + grid_data[2][i]
		dia1_sum = grid_data[0][0] + grid_data[1][1] + grid_data[2][2]
		dia2_sum = grid_data[0][2] + grid_data[1][1] + grid_data[2][0]	
	
		#Player 1 won					
		if row_sum == 3 or col_sum == 3 or dia1_sum == 3 or dia2_sum == 3:
			winner = 1
		#Player 2 won	
		elif row_sum == -3 or col_sum == -3 or dia1_sum == -3 or dia2_sum == -3:
			winner = -1
	
	return winner	
					 

func _on_game_over_screen_restart():
	new_game() # Replace with function body.
