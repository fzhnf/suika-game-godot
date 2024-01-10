extends Marker2D
@onready var score_marker: Marker2D = $"."
@onready var current_score_numbers: Label = $CurrentScoreNumbers
@onready var best_score_numbers: Label = $BestScoreNumbers
const SAVE_PATH: String = "user://highscore.dat"
var current_score: int = 0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalBus.fruit_combined.connect(combine_result)
	SignalBus.fruit_spawned.connect(spawn_resuilt)
	SignalBus.game_result.connect(find_highest_score)
	load_file()


func load_file() -> void:
	if FileAccess.file_exists(SAVE_PATH):
		var file: FileAccess = FileAccess.open(SAVE_PATH, FileAccess.READ)
		best_score_numbers.text = str(file.get_var())
	else:
		best_score_numbers.text = str(0)
		
func combine_result(size:int) -> void:
	current_score += (size+1) - 2 * (size)
	current_score_numbers.text = str(current_score)
	
func spawn_resuilt(size:int) -> void:
	current_score += size
	current_score_numbers.text = str(current_score)
	

func find_highest_score() -> void:
	var highest_score: String = str(max(int(current_score_numbers.text), int(best_score_numbers.text)))
	var file: FileAccess = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	file.store_var(highest_score)
