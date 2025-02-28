extends GPUParticles2D


func _ready() -> void:
	self.emitting = true

func _process(delta: float) -> void:
	if(!self.emitting):
		await get_tree().create_timer(2).timeout
		queue_free()
