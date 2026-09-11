extends Node
## Центральное состояние игры: сохранение, репутация, решения и найденные сведения.

var hp: float = 100.0
var max_hp: float = 100.0
var energy: float = 100.0
var max_energy: float = 100.0
var element: String = "Пепел"

var reputation := {"Мадин": 0, "Инквизиция": 0, "Пан": 0}
var flags := {}
var lore := []
var relationships := {}

func set_flag(id: String, value = true) -> void:
    flags[id] = value

func has_flag(id: String) -> bool:
    return flags.get(id, false)

func add_lore(id: String) -> void:
    if id not in lore:
        lore.append(id)

func save_game() -> void:
    var data = {
        "hp": hp, "energy": energy, "element": element,
        "reputation": reputation, "flags": flags,
        "lore": lore, "relationships": relationships
    }
    var file = FileAccess.open("user://save.json", FileAccess.WRITE)
    file.store_string(JSON.stringify(data))

func load_game() -> void:
    if not FileAccess.file_exists("user://save.json"):
        return
    var file = FileAccess.open("user://save.json", FileAccess.READ)
    var data = JSON.parse_string(file.get_as_text())
    if typeof(data) == TYPE_DICTIONARY:
        hp = data.get("hp", hp)
        energy = data.get("energy", energy)
        element = data.get("element", element)
        reputation = data.get("reputation", reputation)
        flags = data.get("flags", flags)
        lore = data.get("lore", lore)
        relationships = data.get("relationships", relationships)
