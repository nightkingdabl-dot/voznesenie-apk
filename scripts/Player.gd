extends CharacterBody3D

signal hp_changed(value, maximum)
signal energy_changed(value, maximum)
signal message(text)

@export var speed := 5.0
@export var gravity := 18.0
@export var attack_damage := 28.0
@export var attack_range := 2.2

var attack_cooldown := 0.0
var skill_cooldown := 0.0

func _ready():
    add_to_group("player")
    hp_changed.emit(GameState.hp, GameState.max_hp)
    energy_changed.emit(GameState.energy, GameState.max_energy)

func _physics_process(delta):
    attack_cooldown = max(0.0, attack_cooldown - delta)
    skill_cooldown = max(0.0, skill_cooldown - delta)

    var input_vec = Input.get_vector("move_left", "move_right", "move_forward", "move_back")
    var direction = Vector3(input_vec.x, 0, input_vec.y)

    if direction.length() > 0.1:
        direction = direction.normalized()
        velocity.x = direction.x * speed
        velocity.z = direction.z * speed
        rotation.y = lerp_angle(rotation.y, atan2(-direction.x, -direction.z), delta * 8.0)
    else:
        velocity.x = move_toward(velocity.x, 0, speed * 8.0 * delta)
        velocity.z = move_toward(velocity.z, 0, speed * 8.0 * delta)

    if not is_on_floor():
        velocity.y -= gravity * delta
    else:
        velocity.y = 0

    move_and_slide()

    if Input.is_action_just_pressed("attack"):
        attack()
    if Input.is_action_just_pressed("element_skill"):
        element_skill()
    if Input.is_action_just_pressed("interact"):
        interact()

    GameState.energy = min(GameState.max_energy, GameState.energy + 5.0 * delta)
    energy_changed.emit(GameState.energy, GameState.max_energy)

func attack():
    if attack_cooldown > 0:
        return
    attack_cooldown = 0.55
    message.emit("Удар")
    for enemy in get_tree().get_nodes_in_group("enemies"):
        if global_position.distance_to(enemy.global_position) <= attack_range:
            var forward = -global_transform.basis.z
            var to_enemy = (enemy.global_position - global_position).normalized()
            if forward.dot(to_enemy) > 0.25:
                enemy.take_damage(attack_damage)

func element_skill():
    if skill_cooldown > 0 or GameState.energy < 25:
        return
    skill_cooldown = 2.0
    GameState.energy -= 25
    energy_changed.emit(GameState.energy, GameState.max_energy)
    message.emit("Руна: Пепельный импульс")
    for enemy in get_tree().get_nodes_in_group("enemies"):
        if global_position.distance_to(enemy.global_position) <= 5.0:
            enemy.take_damage(55)

func take_damage(amount):
    GameState.hp = max(0.0, GameState.hp - amount)
    hp_changed.emit(GameState.hp, GameState.max_hp)
    if GameState.hp <= 0:
        message.emit("Вы погибли. Нажмите E, чтобы вернуться.")
        set_physics_process(false)

func interact():
    var nearest = null
    var best = 3.0
    for obj in get_tree().get_nodes_in_group("interactable"):
        var d = global_position.distance_to(obj.global_position)
        if d < best:
            best = d
            nearest = obj
    if nearest:
        nearest.interact()
