-- This information tells other players more about the mod
name = "Display food values"
description = "Displays what food and healing items have what hunger, health, sanity values"
author = "alks, gregdwilson"
version = "1.61"

forumthread = ""

-- This lets other players know if your mod is out of date, update it to match the current version in the game
api_version = 10

--This let's the game know that this mod doesn't need to be listed in the server's mod listing
client_only_mod = false

--Let the mod system know that this mod is functional with Don't Starve Together
dst_compatible = true

all_clients_require_mod = true 

-- Can specify a custom icon for this mod!
icon_atlas = "DisplayFoodValues.xml"
icon = "DisplayFoodValues.tex"

-- Specify the priority
priority=3

configuration_options =
{
	{
		name = "DFV_Language",
		label = "Language",
		options =	{
						{description = "English", data = "EN"},
						{description = "French", data = "FR"},
						{description = "German", data = "GR"},
						{description = "Russian", data = "RU"},
						{description = "Spanish", data = "SP"},
						{description = "Italian", data = "IT"},
						{description = "Dutch", data = "NL"},
						{description = "Turkish", data = "TR"},
						{description = "Chinese", data = "CN"},
					},

		default = "EN",
	
	},
	
	{
		name = "DFV_MinimalMode",
		label = "Minimal mode",
		options =	{
						{description = "Off", data = "default"},
						{description = "On", data = "on"},
					},

		default = "default",
	
	},

}