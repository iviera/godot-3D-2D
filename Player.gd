extends CharacterBody3D

const SPEED = 600.0
const JUMP_VELOCITY = -400.0

#@onready var anim: AnimationPlayer = $SubViewportContainer/SubViewport/Meshy_AI_Animation_Walking_withSkin.get_node("Mesh/AnimationPlayer")
@onready var anim: AnimationPlayer = %AnimationPlayer


func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
		#anim.play("Anim/Run")
		#anim.play("Armature|walking_man|baselayer")
		#anim.play("AnimPack1/FastRun")
		anim.play("AnimPack1/Idle")

		
		if direction > 0:
			self.rotation.y = PI/2
		else:
			self.rotation.y = -PI/2
			
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
	move_and_slide()
