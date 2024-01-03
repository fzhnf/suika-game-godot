extends Marker2D

@onready var current_score_label: Label = $CurrentScoreLabel
@onready var highest_score_label: Label = $HighestScoreLabel
const SAVE_PATH: String = "user://highscore.dat"
var current_score: int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
	SignalBus.fruit_combined.connect(combine_score)
	SignalBus.game_over.connect(find_highest_score)
	SignalBus.fruit_spawned.connect(spawn_score)
	load_file()

func load_file() -> void:
	if FileAccess.file_exists(SAVE_PATH):
		var file: FileAccess = FileAccess.open(SAVE_PATH, FileAccess.READ)
		highest_score_label.text = str(file.get_var())
	else:
		highest_score_label.text = str(0)
		
func combine_score(size:int) -> void:
	current_score += (size+1) - (size+size) 
	current_score_label.text = str(current_score)

func spawn_score(size:int) -> void:
	current_score += size
	current_score_label.text = str(current_score)
	
func find_highest_score() -> void:
	var highest_score: String = str(max(int(current_score_label.text), int(highest_score_label.text)))
	var file: FileAccess = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	file.store_var(highest_score)
