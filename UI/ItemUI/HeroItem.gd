extends Control

var key = ""
var role_data

func _ready():
	add_to_group("all_hero_list")

func setData(_key):
	self.role_data = StorageData.get_all_team()[_key]
	self.key = _key
	$AnimatedSprite.material = load("res://Shaders/BoderLight.tres")
	match role_data.job:
		"黑袍法师":
			$AnimatedSprite.frames = load("res://Texture/Pre-made characters/BlackHero.tres")
			$AnimatedSprite.position = Vector2(70,0)
			$AnimatedSprite.scale = Vector2(3,3)
		"无畏勇者":
			$AnimatedSprite.frames = load("res://Texture/Pre-made characters/Brave.tres")
			$AnimatedSprite.position = Vector2(50,45)
			$AnimatedSprite.scale = Vector2(3,3)
		"不屈骑士":
			$AnimatedSprite.frames = load("res://Texture/Pre-made characters/Knight.tres")
			$AnimatedSprite.position = Vector2(50,16)
			$AnimatedSprite.scale = Vector2(5,5)
		"绝地武士":
			$AnimatedSprite.frames = load("res://Texture/Pre-made characters/Warrior.tres")
			$AnimatedSprite.position = Vector2(50,16)
			$AnimatedSprite.scale = Vector2(5,5)
		"致命拳手":
			$AnimatedSprite.frames = load("res://Texture/Pre-made characters/Boxer.tres")
			$AnimatedSprite.position = Vector2(50,25)
			$AnimatedSprite.scale = Vector2(3,3)
		"战地牧师":$AnimatedSprite.frames = load("res://Texture/Pre-made characters/Minister.tres")

func reload(_key):
	$ColorRect.visible = self.key == _key
