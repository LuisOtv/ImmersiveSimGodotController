extends Control

@onready var texture_rect: TextureRect = $TextureRect
@onready var title: Label = $Title
@onready var content: Label = $Content

func openNote(i,n,c):
	texture_rect.texture = i
	title.text = n
	content.text = c
	visible = true
