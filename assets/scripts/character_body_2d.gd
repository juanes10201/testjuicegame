extends CharacterBody2D

@export var MaxSpeed : Vector2 = Vector2(500, 500)
@export var Acc : Vector2 = Vector2(500, 500)
@export var DesAcc : Vector2 = Vector2(500, 500)

@onready var Sprite = $Sprite
@onready var GunSprite = $GunSprite
@onready var TimeShowShoot = $TimeShowShoot
@onready var CooldownShoot = $CooldownShoot
@onready var RaycastShoot = $GunSprite/RayCast2D

@export var enemies_to_spawn = 5

@export var enemies_speed : float = 1500.0
var round : float = 0

var Score : float = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_on_enemy_spawn_timer_timeout()

func TickGun() -> void:
	if(Input.is_action_pressed("move_shoot") && CooldownShoot.is_stopped()):
		TimeShowShoot.start()
		CooldownShoot.start()
		_change_size(OriginalSize.x*1.5, OriginalSize.y*1.5)
		$shootsound.play()
		if(RaycastShoot.is_colliding()):
			var collider = RaycastShoot.get_collider()
			#if(collider.is_in_group("Enemy")):
			collider._OnDeath()
			Score += 200
			_change_size(OriginalSize.x*2, OriginalSize.y*2)
	if(!TimeShowShoot.is_stopped()):
		$GunSprite/Shoot.show()
	else:
		$GunSprite/Shoot.hide()
	GunSprite.look_at(get_global_mouse_position())

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	TickGun()
	#region Aceleration and desaceleration based player movement
	var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	#print(direction)
	if(velocity.x < MaxSpeed.x):
		velocity.x += Acc.x * direction.x * delta
	if(direction.x == 0):
		if(velocity.x > 0):
			velocity.x -= DesAcc.x * delta
		elif(velocity.x < 0):
			velocity.x += DesAcc.x * delta
	
	if(velocity.y < MaxSpeed.y):
		velocity.y += Acc.y * direction.y * delta
	if(direction.y == 0):
		if(velocity.y > 0):
			velocity.y -= DesAcc.y * delta
		elif(velocity.y < 0):
			velocity.y += DesAcc.y * delta
	
	velocity.normalized()
	#endregion
	move_and_slide()
	_tick_size(delta)

func _OnDeath() -> void:
	get_tree().reload_current_scene()

@onready var enemy = preload("res://assets/tscn/enemy.tscn")
func _on_enemy_spawn_timer_timeout() -> void:
	round += 1
	Score *= 1.5
	$roundsound.play()
	if(CooldownShoot.wait_time > 0.2):
		CooldownShoot.wait_time -= 0.1
	for n in enemies_to_spawn:
		var enemyinstance = enemy.instantiate()
		add_sibling(enemyinstance)
		enemyinstance.position = $"../SpawnEnemiesReference".position
		enemyinstance.position.x += randf_range(-100, 100)
		enemyinstance.position.y += randf_range(-10, 10)
	enemies_to_spawn += 2
	$EnemySpawnTimer.wait_time += 2
	enemies_speed += 200
	print("Spawn enemies!")

@onready var OriginalSize = Sprite.scale 
func _change_size(x, y):
	Sprite.scale = Vector2(OriginalSize.x * x, OriginalSize.y * y)
func _tick_size(delta : float):
	Sprite.scale.x = lerpf(Sprite.scale.x, OriginalSize.x, 10*delta)
	Sprite.scale.y = lerpf(Sprite.scale.y, OriginalSize.y, 10*delta)
