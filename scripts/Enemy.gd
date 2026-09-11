extends CharacterBody3D

var hp := 100.0
var speed := 2.2
var attack_timer := 0.0
var target: Node3D

func _ready():
    add_to_group("enemies")

func _physics_process(delta):
    attack_timer = max(0.0, attack_timer - delta)
    if not target:
        target = get_tree().get_first_node_in_group("player")
    if not target:
        return

    var distance = global_position.distance_to(target.global_position)
    if distance > 2.0:
        var dir = (target.global_position - global_position)
        dir.y = 0
        if dir.length() > 0.1:
            dir = dir.normalized()
            velocity.x = dir.x * speed
            velocity.z = dir.z * speed
            rotation.y = atan2(-dir.x, -dir.z)
    else:
        velocity.x = 0
        velocity.z = 0
        if attack_timer <= 0:
            attack_timer = 1.5
            target.take_damage(12)

    if not is_on_floor():
        velocity.y -= 18.0 * delta
    move_and_slide()

func take_damage(amount):
    hp -= amount
    if hp <= 0:
        GameState.reputation["Инквизиция"] += 1
        queue_free()
