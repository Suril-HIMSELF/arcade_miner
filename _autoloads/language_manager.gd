extends Node

signal language_changed

var current_language = GameManager.language

func _ready() -> void:
	TranslationServer.set_locale(current_language)


func set_language(language: String) -> void:
	if language == current_language:
		return

	current_language = language
	TranslationServer.set_locale(language)

	language_changed.emit()


func localize_tree(node: Node):
	for child in node.get_children():
		if child is Label or child is Button or child is RichTextLabel:

			if not child.has_meta("loc_key"):
				child.set_meta("loc_key", child.text)

			var key = child.get_meta("loc_key")
			
			#Debug problème de clé non résolue
			#print("'" + str(key) + "'")
			
			var translated = TranslationServer.translate(key)

			child.text = translated
		
		elif child is TabBar:
			localize_tabbar(child)
		
		localize_tree(child)


func localize_tabbar(tabbar: TabBar):
	for i in tabbar.get_tab_count():
		var key = tabbar.get_tab_title(i)

		# sauvegarde clé originale
		if not tabbar.has_meta("tab_key_%d" % i):
			tabbar.set_meta("tab_key_%d" % i, key)

		var stored_key = tabbar.get_meta("tab_key_%d" % i)
		tabbar.set_tab_title(i, TranslationServer.translate(stored_key))
