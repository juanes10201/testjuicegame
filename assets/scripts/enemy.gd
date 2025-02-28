extends CharacterBody2D

@onready var Player = $"../Player"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if(Player):
		var direction = global_position.direction_to(Player.global_position)
		velocity = direction * Player.enemies_speed * delta
	move_and_slide()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if(body.is_in_group("Player")):
		Player._OnDeath()

func _OnDeath() -> void:
	$"../Player/killsound".play()
	var particles = preload("res://assets/tscn/enemy_death_particles.tscn")
	var inst_part = particles.instantiate()
	add_sibling(inst_part)
	inst_part.position = position
	queue_free()
