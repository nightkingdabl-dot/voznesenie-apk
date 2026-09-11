extends StaticBody3D

var used := false

func _ready():
    add_to_group("interactable")

func interact():
    if used:
        return
    used = true
    GameState.add_lore("tablet_01")
    GameState.set_flag("temple_tablet_found")
    GameState.reputation["Мадин"] += 2
    var ui = get_tree().get_first_node_in_group("ui")
    if ui:
        ui.show_lore(
            "КАМЕННАЯ ПЛИТА",
            "«Они не были уничтожены. Так записали после того, как ворота закрылись.»\n\n" +
            "Ниже выцараблено более поздней рукой:\n" +
            "«Ложь. Я видел одного из них спустя семь лет.»\n\n" +
            "Кто оставил вторую запись — неизвестно."
        )
