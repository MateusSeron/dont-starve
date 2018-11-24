table.insert(GLOBAL.STRINGS, "DFV_LANG")
table.insert(GLOBAL.STRINGS, "DFV_HUNGER")
table.insert(GLOBAL.STRINGS, "DFV_HEALTH")
table.insert(GLOBAL.STRINGS, "DFV_SANITY")
table.insert(GLOBAL.STRINGS, "DFV_SPOILSOON")
table.insert(GLOBAL.STRINGS, "DFV_SPOILIN")
table.insert(GLOBAL.STRINGS, "DFV_SPOILDAY")
table.insert(GLOBAL.STRINGS, "DFV_MIN")
table.insert(GLOBAL.STRINGS, "DFV_IFCOOKED")
local require = GLOBAL.require
local foodvalues = require "components/foodvalues"
local ItemTile = require "widgets/itemtile"
local Inv = require "widgets/inventorybar"
local DFV_LANG = GetModConfigData("DFV_Language", true)
if DFV_LANG == nil then
	DFV_LANG = GetModConfigData("DFV_Language")
end
local DFV_MIN = not (GetModConfigData("DFV_MinimalMode", true)=="default")

GLOBAL.STRINGS.DFV_MIN = DFV_MIN
GLOBAL.STRINGS.DFV_LANG = DFV_LANG

if DFV_LANG == "FR" then
	GLOBAL.STRINGS.DFV_HUNGER = "Points de faim"
	GLOBAL.STRINGS.DFV_HEALTH = "Points de vie"
	GLOBAL.STRINGS.DFV_SANITY = "Sante mentale"
	GLOBAL.STRINGS.DFV_SPOILSOON = "Pourrira bientot"
	GLOBAL.STRINGS.DFV_SPOILIN = "Pourrira dans"
	GLOBAL.STRINGS.DFV_SPOILDAY = "jour"
	GLOBAL.STRINGS.DFV_IFCOOKED = "Si cuits"
elseif DFV_LANG == "GR" then
	GLOBAL.STRINGS.DFV_HUNGER = "Hunger"
	GLOBAL.STRINGS.DFV_HEALTH = "Gesundheit"
	GLOBAL.STRINGS.DFV_SANITY = "Verstand"
	GLOBAL.STRINGS.DFV_SPOILSOON = "Verdirbt sehr bald"
	GLOBAL.STRINGS.DFV_SPOILIN = "Verdirbt in"
	GLOBAL.STRINGS.DFV_SPOILDAY = "Tag"
	GLOBAL.STRINGS.DFV_IFCOOKED = "Wenn gekocht"
elseif DFV_LANG == "RU" then
	GLOBAL.STRINGS.DFV_HUNGER = "Голод"
	GLOBAL.STRINGS.DFV_HEALTH = "Здоровье"
	GLOBAL.STRINGS.DFV_SANITY = "Рассудок"
	GLOBAL.STRINGS.DFV_SPOILSOON = "Скоро испортится"
	GLOBAL.STRINGS.DFV_SPOILIN = "Испортится через"
	GLOBAL.STRINGS.DFV_SPOILDAY = "дней"
	GLOBAL.STRINGS.DFV_IFCOOKED = "Если приготовлено"
elseif DFV_LANG == "SP" then
	GLOBAL.STRINGS.DFV_HUNGER = "Hambre"
	GLOBAL.STRINGS.DFV_HEALTH = "Salud"
	GLOBAL.STRINGS.DFV_SANITY = "Cordura"
	GLOBAL.STRINGS.DFV_SPOILSOON = "Echara a perder muy pronto"
	GLOBAL.STRINGS.DFV_SPOILIN = "Echara a perder en"
	GLOBAL.STRINGS.DFV_SPOILDAY = "dia"
	GLOBAL.STRINGS.DFV_IFCOOKED = "Si se cocinan"
elseif DFV_LANG == "IT" then
	GLOBAL.STRINGS.DFV_HUNGER = "Fame"
	GLOBAL.STRINGS.DFV_HEALTH = "Vita"
	GLOBAL.STRINGS.DFV_SANITY = "Sanita'"
	GLOBAL.STRINGS.DFV_SPOILSOON = "Marcira' molto presto"
	GLOBAL.STRINGS.DFV_SPOILIN = "Marcira' tra"
	GLOBAL.STRINGS.DFV_SPOILDAY = "giorn"
	GLOBAL.STRINGS.DFV_IFCOOKED = "Se cotta"
elseif DFV_LANG == "NL" then
	GLOBAL.STRINGS.DFV_HUNGER = "Honger"
	GLOBAL.STRINGS.DFV_HEALTH = "Gezondheid"
	GLOBAL.STRINGS.DFV_SANITY = "Geestelijke Gezondheid"
	GLOBAL.STRINGS.DFV_SPOILSOON = "Verderft binnenkort"
	GLOBAL.STRINGS.DFV_SPOILIN = "Aan het bederven"
	GLOBAL.STRINGS.DFV_SPOILDAY = "dag"
	GLOBAL.STRINGS.DFV_IFCOOKED = "Als gekookt"
elseif DFV_LANG == "TR" then
	GLOBAL.STRINGS.DFV_HUNGER = "Aclik"
	GLOBAL.STRINGS.DFV_HEALTH = "Saglik"
	GLOBAL.STRINGS.DFV_SANITY = "Akil"
	GLOBAL.STRINGS.DFV_SPOILSOON = "Cok yakinda bozulacak"
	GLOBAL.STRINGS.DFV_SPOILIN = "Bozulmasina"
	GLOBAL.STRINGS.DFV_SPOILDAY = "gun"
	GLOBAL.STRINGS.DFV_IFCOOKED = "pismis Eger"
elseif DFV_LANG == "CN" then
	GLOBAL.STRINGS.DFV_HUNGER = "饱食度"
	GLOBAL.STRINGS.DFV_HEALTH = "生命值"
	GLOBAL.STRINGS.DFV_SANITY = "精神值"
	GLOBAL.STRINGS.DFV_SPOILSOON = "它马上就要坏掉了"
	GLOBAL.STRINGS.DFV_SPOILIN = "它快坏掉了"
	GLOBAL.STRINGS.DFV_SPOILDAY = "天"
	GLOBAL.STRINGS.DFV_IFCOOKED = "如果熟"
else
	GLOBAL.STRINGS.DFV_HUNGER = "Hunger"
	GLOBAL.STRINGS.DFV_HEALTH = "Health"
	GLOBAL.STRINGS.DFV_SANITY = "Sanity"
	GLOBAL.STRINGS.DFV_SPOILSOON = "Will spoil very soon"
	GLOBAL.STRINGS.DFV_SPOILIN = "Will spoil in"
	GLOBAL.STRINGS.DFV_SPOILDAY = "day"
	GLOBAL.STRINGS.DFV_IFCOOKED = "If Cooked"
end


 
local ItemTile_GetDescriptionString_base = ItemTile.GetDescriptionString or function() return "" end
local Inv_UpdateCursorText_base = Inv.UpdateCursorText or function() return "" end

function ItemTile:UpdateTooltip()
	local player = GLOBAL.ThePlayer

	local keydown = GLOBAL.TheInput:IsControlPressed(GLOBAL.CONTROL_FORCE_INSPECT) 
	
	local ctrlkeydown = GLOBAL.TheInput:IsControlPressed(GLOBAL.CONTROL_FORCE_STACK)
	
	SendModRPCToServer(MOD_RPC["Food Item"]["FIU"], self.item, keydown, ctrlkeydown)
	player:ListenForEvent("fooditem_changed", function()
		
		local str = self:GetDescriptionString()
		self:SetTooltip(str)
		if self.item:GetIsWet() then
			self:SetTooltipColour(GLOBAL.unpack(GLOBAL.WET_TEXT_COLOUR))
		else
			self:SetTooltipColour(GLOBAL.unpack(GLOBAL.NORMAL_TEXT_COLOUR))
		end
			
    end)
end

function ItemTile:GetDescriptionString()
	
	local player = GLOBAL.ThePlayer
	local strings = GLOBAL.STRINGS

	local str = ItemTile_GetDescriptionString_base(self)
	
	local ModString = player.components.foodvalues.string_dirty:value()
	
	if ModString ~= "" then
		str = str .. ModString
	end

	
    return str
        
end


function Inv:UpdateCursorText()
 
	local tmp = Inv_UpdateCursorText_base(self)
 
    local inv_item = self:GetCursorItem()
    if inv_item ~= nil and inv_item.replica.inventoryitem == nil then
        inv_item = nil
    end
    
 	if self.open then
	    if inv_item ~= nil then
	    
	        local controller_id = GLOBAL.TheInput:GetControllerID()
			local realfood = nil
			local show_spoil = GLOBAL.TheInput:IsControlPressed(GLOBAL.CONTROL_INSPECT)
			
	        local player = GLOBAL.ThePlayer
	        local active_item = player.replica.inventory:GetActiveItem()
	        
	 	    local strings = GLOBAL.STRINGS
			local str = {}
			table.insert(str, self.actionstringbody:GetString())
	
			
			local keydown = GLOBAL.TheInput:IsControlPressed(GLOBAL.CONTROL_FOCUS_RIGHT)
			
			local ctrlkeydown = GLOBAL.TheInput:IsControlPressed(GLOBAL.CONTROL_FOCUS_LEFT)
			
			if GLOBAL.TheInput:IsControlPressed(GLOBAL.CONTROL_FOCUS_UP) then
				keydown = true
				ctrlkeydown = true
			end
			
			SendModRPCToServer(MOD_RPC["Food Item"]["FIU"], inv_item, keydown, ctrlkeydown)

			local ModString = string.sub(player.components.foodvalues.string_dirty:value(), 2)
			if ModString ~= "" then
				table.insert(str, ModString)
			end
			    	    
			local TIP_YFUDGE = 16
			local W = 68
			local CURSOR_STRING_DELAY = 10
	        local was_shown = self.actionstring.shown
	        local old_string = self.actionstringbody:GetString()
	        local new_string = table.concat(str, '\n')
	        
	        if old_string ~= new_string then
	            self.actionstringbody:SetString(new_string)
	            self.actionstringtime = CURSOR_STRING_DELAY
	            self.actionstring:Show()
	        end
	
	        local w0, h0 = self.actionstringtitle:GetRegionSize()
	        local w1, h1 = self.actionstringbody:GetRegionSize()
	
	        local wmax = math.max(w0, w1)
	
	        local dest_pos = self.active_slot:GetWorldPosition()
	
	        local xscale, yscale, zscale = self.root:GetScale():Get()
	
	        if self.active_slot.side_align_tip then
	            -- in-game containers, chests, fridge
	            self.actionstringtitle:SetPosition(wmax/2, h0/2)
	            self.actionstringbody:SetPosition(wmax/2, -h1/2)
	
	            dest_pos.x = dest_pos.x + self.active_slot.side_align_tip * xscale
	        elseif self.active_slot.top_align_tip then
	            -- main inventory
	            self.actionstringtitle:SetPosition(0, h0/2 + h1)
	            self.actionstringbody:SetPosition(0, h1/2)
	
	            dest_pos.y = dest_pos.y + (self.active_slot.top_align_tip + TIP_YFUDGE) * yscale
	        else
	            -- old default as fallback ?
	            self.actionstringtitle:SetPosition(0, h0/2 + h1)
	            self.actionstringbody:SetPosition(0, h1/2)
	
	            dest_pos.y = dest_pos.y + (W/2 + TIP_YFUDGE) * yscale
	        end
	
	       
	        if dest_pos:DistSq(self.actionstring:GetPosition()) > 1 then
	            self.actionstringtime = CURSOR_STRING_DELAY
	            if was_shown then
	                self.actionstring:MoveTo(self.actionstring:GetPosition(), dest_pos, .1)
	            else
	                self.actionstring:SetPosition(dest_pos)
	                self.actionstring:Show()
	            end
	        end
	
	end
	end
end



AddPlayerPostInit(function(inst) 
	inst:AddComponent("foodvalues")
end)


AddModRPCHandler("Food Item", "FIU", function(player, item, keydown, ctrlkeydown)
	player.components.foodvalues:On_FoodValue_Changed(player,item,keydown,ctrlkeydown)
end)