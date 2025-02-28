extends CanvasLayer

@onready var Progressbar = $ProgressBar
@onready var Player = $"../Player"
@onready var SpawnTimer = $"../Player/EnemySpawnTimer"
@onready var TextScore = $RichTextLabel
@onready var TextRound = $RichTextLabel2


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Progressbar.max_value = SpawnTimer.wait_time


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	Progressbar.value = SpawnTimer.time_left
	TextScore.text = "SCORE:" + str(floor(Player.Score))
	TextRound.text = "ROUND: " + str(floor(Player.round))
