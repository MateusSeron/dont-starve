--The name of the mod displayed in the 'mods' screen.
name = " More Stack size"

--A description of the mod.
description = "Changes the maximum size of itemstacks of all stackable items to the configured amount. (recommended value: 99)"

author = "Dyl"
 
version = " 2.1"

api_version = 10

-- Compatible with both the base game, reign of giants, and dst
dont_starve_compatible = true
reign_of_giants_compatible = true
dst_compatible = true

forumthread = ""

--These let clients know if they need to get the mod from the Steam Workshop to join the game
all_clients_require_mod = true
clients_only_mod = false

--This lets people search for servers with this mod by these tags
server_filter_tags = {"utility"}

-- ModConfiguration option
configuration_options =
{
	{
		name = "MAXSTACKSIZE",
		label = "Max stacksize",
		options =	{
						{description = "20", data = 20},
						{description = "40", data = 40},
						{description = "60", data = 60},
						{description = "80", data = 80},
						{description = "99", data = 99},
						{description = "120", data = 120},
						{description = "150", data = 150},
						{description = "200", data = 200},
						{description = "250", data = 250},
					},

		default = 99,
	},
	
	{
		name = "DropWholeStack",
		label = "Drop whole stack",
		hover = "Items are slippery it will drop whole stack.",
		options =	
		{
            {description = "Yes", data = true},
            {description = "No", data = false},
		},
		default = true,
	},
}

icon = "modicon.tex"
icon_atlas = "modicon.xml"