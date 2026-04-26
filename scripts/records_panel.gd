extends Control

@onready var top_scores_text: RichTextLabel = $CenterContainer/VBoxContainer/ColumnsContainer/TopColumn/TopScoresText
@onready var all_scores_text: RichTextLabel = $CenterContainer/VBoxContainer/ColumnsContainer/HistoryColumn/HistoryScroll/AllScoresText

func _ready() -> void:
	visible = false

func open_panel() -> void:
	load_scores()
	visible = true

func close_panel() -> void:
	visible = false

func load_scores() -> void:
	load_top_scores()
	load_all_scores()

func load_top_scores() -> void:
	var top_scores: Array = DataBase.get_top_scores(10)
	var text: String = ""

	if top_scores.is_empty():
		text = "No hay puntuaciones todavía."
	else:
		var rank_position: int = 1
		for row in top_scores:
			var time_text: String = format_score_ms(int(row["score_ms"]))
			text += "%d. %s - ⏱️%sms - %s🪙\n" % [
				rank_position,
				str(row["username"]),
				time_text,
				str(row["coins"])
			]
			rank_position += 1

	top_scores_text.text = text

func load_all_scores() -> void:
	var all_scores: Array = DataBase.get_all_scores()
	var text: String = ""

	if all_scores.is_empty():
		text = "No hay partidas guardadas."
	else:
		for row in all_scores:
			var formatted_date: String = format_date_es(str(row["game_date"]))
			var time_text: String = format_score_ms(int(row["score_ms"]))
			text += "%s - %s - ⏱️%sms - %s🪙\n" % [
				formatted_date,
				str(row["username"]),
				time_text,
				str(row["coins"])
			]

	all_scores_text.text = text

func format_date_es(date_text: String) -> String:
	if date_text == "":
		return ""

	var parts: PackedStringArray = date_text.split(" ")
	if parts.size() == 0:
		return date_text

	var date_part: String = parts[0]
	var date_values: PackedStringArray = date_part.split("-")

	if date_values.size() != 3:
		return date_text

	return "%s/%s/%s" % [date_values[2], date_values[1], date_values[0]]

func format_score_ms(score_ms: int) -> String:
	return str(score_ms)

func _on_back_button_pressed() -> void:
	close_panel()
