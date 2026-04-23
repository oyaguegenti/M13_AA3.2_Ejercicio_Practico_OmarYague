extends Node

@export_file_path() var data_base_file: String

var db: SQLite
var id_user: int = -1


func _ready() -> void:
	db = SQLite.new()
	db.path = data_base_file
	db.open_db()

	create_users_table()
	create_scores_table()


func create_users_table() -> void:
	var query := "
	CREATE TABLE IF NOT EXISTS users (
		id_user INTEGER PRIMARY KEY AUTOINCREMENT,
		username TEXT NOT NULL,
		creation_date DATETIME DEFAULT CURRENT_TIMESTAMP
	);
	"
	db.query(query)


func create_scores_table() -> void:
	var query := "
	CREATE TABLE IF NOT EXISTS scores (
		id_score INTEGER PRIMARY KEY AUTOINCREMENT,
		coins INTEGER NOT NULL,
		game_date DATETIME DEFAULT CURRENT_TIMESTAMP,
		id_user INTEGER NOT NULL,
		FOREIGN KEY (id_user) REFERENCES users(id_user)
	);
	"
	db.query(query)


func insert_user(username: String) -> int:
	var clean_username := username.strip_edges()

	if clean_username == "":
		return -1

	var query := "INSERT INTO users (username) VALUES ('%s');" % clean_username
	var ok := db.query(query)

	if not ok:
		push_error("ERROR: No se pudo insertar el usuario")
		return -1

	id_user = db.last_insert_rowid
	return id_user


func insert_score(user_id: int, coins: int) -> bool:
	var query := "INSERT INTO scores (id_user, coins) VALUES (%d, %d);" % [user_id, coins]
	var ok := db.query(query)

	if not ok:
		push_error("ERROR: No se pudo insertar la puntuación")
		return false

	return true


func save_score() -> bool:
	if id_user <= 0:
		push_error("ERROR: No hay usuario activo")
		return false

	return insert_score(id_user, Globals.coins)


func get_top_scores(limit: int = 10) -> Array:
	var query := "
	SELECT
		u.username,
		s.coins,
		s.game_date
	FROM scores s
	JOIN users u
		ON s.id_user = u.id_user
	ORDER BY s.coins DESC, s.game_date DESC
	LIMIT %d;
	" % limit

	var ok := db.query(query)

	if not ok:
		push_error("ERROR: No se pudo obtener el top de puntuaciones")
		return []

	return db.query_result


func get_all_scores() -> Array:
	var query := "
	SELECT
		u.username,
		s.coins,
		s.game_date
	FROM scores s
	JOIN users u
		ON s.id_user = u.id_user
	ORDER BY s.game_date DESC;
	"

	var ok := db.query(query)

	if not ok:
		push_error("ERROR: No se pudo obtener el historial de puntuaciones")
		return []

	return db.query_result
