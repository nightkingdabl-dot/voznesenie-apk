extends Node3D

var enemy_scene

func _ready():
    GameState.load_game()
    _build_world()
    _spawn_enemy(Vector3(0, 1, -5))
    _spawn_enemy(Vector3(7, 1, -12))
    _spawn_enemy(Vector3(-8, 1, -16))

func _build_world():
    _make_box(Vector3(60, 0.2, 60), Vector3(0, -0.1, 0))
    # Храм
    for x in [-10, -6, -2, 2, 6, 10]:
        _make_box(Vector3(1.3, 5, 1.3), Vector3(x, 2.5, -18))
        _make_box(Vector3(1.3, 5, 1.3), Vector3(x, 2.5, -30))
    for z in [-18, -22, -26, -30]:
        _make_box(Vector3(1.3, 5, 1.3), Vector3(-10, 2.5, z))
        _make_box(Vector3(1.3, 5, 1.3), Vector3(10, 2.5, z))

    var stone = StaticBody3D.new()
    stone.position = Vector3(0, 1.5, -24)
    stone.set_script(load("res://scripts/LoreStone.gd"))
    add_child(stone)
    var mesh = MeshInstance3D.new()
    var bm = BoxMesh.new()
    bm.size = Vector3(2.0, 3.0, 0.5)
    mesh.mesh = bm
    stone.add_child(mesh)
    var collision = CollisionShape3D.new()
    var shape = BoxShape3D.new()
    shape.size = Vector3(2.0, 3.0, 0.5)
    collision.shape = shape
    stone.add_child(collision)

func _make_box(size: Vector3, pos: Vector3):
    var body = StaticBody3D.new()
    body.position = pos
    add_child(body)
    var mesh = MeshInstance3D.new()
    var bm = BoxMesh.new()
    bm.size = size
    mesh.mesh = bm
    body.add_child(mesh)
    var collision = CollisionShape3D.new()
    var shape = BoxShape3D.new()
    shape.size = size
    collision.shape = shape
    body.add_child(collision)

func _spawn_enemy(pos: Vector3):
    var enemy = CharacterBody3D.new()
    enemy.position = pos
    enemy.set_script(load("res://scripts/Enemy.gd"))
    add_child(enemy)
    var mesh = MeshInstance3D.new()
    var capsule = CapsuleMesh.new()
    capsule.height = 2.2
    capsule.radius = 0.65
    mesh.mesh = capsule
    enemy.add_child(mesh)
    var collision = CollisionShape3D.new()
    var shape = CapsuleShape3D.new()
    shape.height = 2.2
    shape.radius = 0.65
    collision.shape = shape
    enemy.add_child(collision)
