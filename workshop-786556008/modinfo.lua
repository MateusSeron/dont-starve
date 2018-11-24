name = "45 Inventory Slots"

description = "Increases the number of inventory slots to 45"

author = "fmo080308"

version = "1.4.1"

api_version = 10

icon_atlas = "Icon.xml"
icon = "Icon.tex"

dont_starve_compatible = true
reign_of_giants_compatible = true
dst_compatible = true

all_clients_require_mod = true
clients_only_mod = false

forumthread = ""
server_filter_tags = {"utility","inventory","tweak"} 

priority = 0.01

configuration_options =
{
  {
      name = "ENABLEBACKPACK",
      label = "    Allow backpack to be stored in inventory",
	  hover = "Allow backpack to be stored in inventory.",
      options = {
        {description = "Yes", data = true},
        {description = "No", data = false},
      },
      default = false,
  },
  {
      name = "INVENTORYSIZE",
      label = "    Change the size of inventory",
	  hover = "Change the size of inventory.",
      options = {
        {description = "15", data = 15},
        {description = "25", data = 25},
		{description = "45", data = 45},
      },
      default = 45,
  },
  {
      name = "EXTRASLOT",
      label = "    Enable more extra slots.",
	  hover = "Enable more extra slots.",
      options = {
        {description = "0", data = 0},
        {description = "1", data = 1},
		{description = "2 or 3", data = 3},
      },
      default = 0,
  },
}