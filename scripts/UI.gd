extends CanvasLayer

var title_label: Label
var body_label: Label
var panel: Panel
var hp_bar: ProgressBar
var energy_bar: ProgressBar
var toast: Label

func _ready():
    add_to_group("ui")
    _build()

func _build():
    var root = Control.new()
    root.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
    add_child(root)

    hp_bar = ProgressBar.new()
    hp_bar.position = Vector2(35, 35)
    hp_bar.size = Vector2(260, 24)
    root.add_child(hp_bar)

    energy_bar = ProgressBar.new()
    energy_bar.position = Vector2(35, 65)
    energy_bar.size = Vector2(260, 16)
    root.add_child(energy_bar)

    var hint = Label.new()
    hint.text = "WASD — движение   SPACE — атака   Q — элемент   E — взаимодействие"
    hint.position = Vector2(35, 95)
    root.add_child(hint)

    toast = Label.new()
    toast.position = Vector2(35, 130)
    toast.add_theme_font_size_override("font_size", 22)
    root.add_child(toast)

    panel = Panel.new()
    panel.position = Vector2(330, 150)
    panel.size = Vector2(620, 360)
    panel.visible = false
    root.add_child(panel)

    title_label = Label.new()
    title_label.position = Vector2(30, 25)
    title_label.add_theme_font_size_override("font_size", 30)
    panel.add_child(title_label)

    body_label = Label.new()
    body_label.position = Vector2(30, 85)
    body_label.size = Vector2(560, 240)
    body_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
    body_label.add_theme_font_size_override("font_size", 20)
    panel.add_child(body_label)

func update_hp(value, maximum):
    hp_bar.max_value = maximum
    hp_bar.value = value

func update_energy(value, maximum):
    energy_bar.max_value = maximum
    energy_bar.value = value

func show_message(text):
    toast.text = text
    await get_tree().create_timer(2.0).timeout
    if toast.text == text:
        toast.text = ""

func show_lore(title, body):
    title_label.text = title
    body_label.text = body + "\n\nE — закрыть"
    panel.visible = true

func _unhandled_input(event):
    if panel.visible and event.is_action_pressed("interact"):
        panel.visible = false
