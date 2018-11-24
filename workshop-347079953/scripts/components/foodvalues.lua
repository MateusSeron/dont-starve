local strings = STRINGS


local FoodValues = Class(function(self, inst)
	self.inst = inst
	self.foodvalue = 0
	self.hungervalue = 0
	self.sanityvalue = 0
	self.perishremainingtime = 0
	self.string = ""
	self.item = nil
	self.itemupdate= net_event(self.inst.GUID, "fooditem_changed")
	self.string_dirty = net_string(self.inst.GUID, "string", "string_changed_dirty")

end,
nil,
{
})
	



function FoodValues:On_FoodValue_Changed(player, item, keydown, ctrlkeydown)
	self.item = self:SpawnPrefabAsServerAndRemoveFromWorld(item.prefab)
	if keydown and self.item.components.cookable ~= nil then
	local campfire = self:SpawnPrefabAsServerAndRemoveFromWorld("campfire")
	self.item = self.item.components.cookable:Cook(campfire, player)
	self.string = "\n" .. strings.DFV_IFCOOKED
	else
	self.string = ""
	end
	local actionpicker = player.components.playeractionpicker
	local realfood = nil
	
	local actions = actionpicker:GetInventoryActions(self.item)
        if #actions > 0 then
		    for k,v in pairs(actions) do
				if v.action == ACTIONS.EAT or v.action == ACTIONS.HEAL then
				    realfood = true
				    break
				end
		    end
      end
	
	
		if realfood and self.item.components.edible and (not ctrlkeydown or keydown) then
		    if player.components.eater and player.components.eater.monsterimmune then
				if self.item.components.edible.hungervalue < 0 and player.components.eater:DoFoodEffects(self.item) or self.item.components.edible.hungervalue > 0 then
				    self.hungervalue =  math.floor(self.item.components.edible:GetHunger(player) * 10 + 0.5) / 10
				end
				if self.item.components.edible.healthvalue < 0 and player.components.eater:DoFoodEffects(self.item) or self.item.components.edible.healthvalue > 0 then
				    self.healthvalue =  math.floor(self.item.components.edible:GetHealth(player) * 10 + 0.5) / 10
				end
				if self.item.components.edible.sanityvalue < 0 and player.components.eater:DoFoodEffects(self.item) or self.item.components.edible.sanityvalue > 0 then
				    self.sanityvalue =  math.floor(self.item.components.edible:GetSanity(player)  * 10 + 0.5) / 10
				end
			else
				self.hungervalue =  math.floor(self.item.components.edible:GetHunger(player) * 10 + 0.5) / 10
				self.healthvalue =  math.floor(self.item.components.edible:GetHealth(player) * 10 + 0.5) / 10
				self.sanityvalue =  math.floor(self.item.components.edible:GetSanity(player) * 10 + 0.5) / 10
			end
		
		elseif self.item.components.healer and realfood then
		    self.healthvalue =  math.floor(self.item.components.healer.health * 10 + 0.5) / 10
		else
			self.hungervalue = 0
			self.healthvalue = 0
			self.sanityvalue = 0
		end
	
	
		if strings.DFV_MIN then			
			if self.hungervalue ~= 0 or self.healthvalue ~= 0 or self.sanityvalue ~= 0 then
				self.string = self.string .. "\n"
			end
						
			if self.hungervalue ~= 0 then
				self.string = self.string .. "\153" .. " " .. self.hungervalue .. " "
			end
			if self.healthvalue ~= 0 then
				self.string = self.string .. "\151" .. " " .. self.healthvalue .. " "
			end
			if self.sanityvalue ~= 0 then
				self.string = self.string .. "\152" .. " " .. self.sanityvalue .. " "
			end
		else
		    if self.hungervalue ~= 0 then
				self.string = self.string.."\n" .. strings.DFV_HUNGER .. " " .. self.hungervalue
		    end
		    if self.healthvalue ~= 0 then
				self.string = self.string.."\n" .. strings.DFV_HEALTH .. " " .. self.healthvalue
		    end
		    if self.sanityvalue ~= 0 then
				self.string = self.string.."\n" .. strings.DFV_SANITY .. " " .. self.sanityvalue
		    end
				
		end		
	

	if self.item.components.perishable and realfood and ctrlkeydown then
		    local owner = item.components.inventoryitem and item.components.inventoryitem.owner
		    local modifier = 1
		    
		    if owner then				    	
				if owner:HasTag("fridge") then
					if item:HasTag("frozen") then
						modifier = TUNING.PERISH_COLD_FROZEN_MULT
					else
						modifier = TUNING.PERISH_FRIDGE_MULT 
					end 
				elseif owner:HasTag("spoiler") then
					modifier = TUNING.PERISH_GROUND_MULT 
				end
			else
				modifier = TUNING.PERISH_GROUND_MULT 
			end						
				
				
			if self.item.components.perishable.frozenfiremult then
				modifier = modifier * TUNING.PERISH_FROZEN_FIRE_MULT
			end
			
		    modifier = modifier * TUNING.PERISH_GLOBAL_MULT
			
			if modifier ~= 0 then
			 
				if item.components.cookable and keydown then
					self.perishremainingtime = math.floor((self.item.components.perishable.perishremainingtime / TUNING.TOTAL_DAY_TIME / modifier)* 10 + 0.5) / 10
				else
					self.perishremainingtime = math.floor((item.components.perishable.perishremainingtime / TUNING.TOTAL_DAY_TIME / modifier)* 10 + 0.5) / 10
				end	 			 
			    

			   if self.perishremainingtime < 1 then
					self.string = self.string.."\n" .. strings.DFV_SPOILSOON
			    elseif strings.DFV_LANG ~= "RU" then
					self.string = self.string.."\n" .. strings.DFV_SPOILIN .. " " .. self.perishremainingtime .. " " .. strings.DFV_SPOILDAY
			    else
					self.string = self.string.."\n" .. strings.DFV_SPOILIN .. " " .. self.perishremainingtime .. " "
			    end
			    if strings.DFV_LANG == "RU" then
					local plural_days = {"день", "дня", "дней"}
					local plural_type = function(n)
						if n%10==1 and n%100~=11 then
							return 1
						elseif n%10>=2 and n%10<=4 and (n%100<10 or n%100>=20) then
							return 2
						else
							return 3
						end
					end
					self.string = self.string .. plural_days[plural_type(math.modf(self.perishremainingtime))]
			    else
					if self.perishremainingtime >=2 then
						if strings.DFV_LANG == "GR" then
							self.string = self.string .. "en"
						elseif strings.DFV_LANG == "IT" then
							self.string = self.string .. "i"						
						else
							self.string = self.string .. "s"
						end
					elseif self.perishremainingtime >= 1 and strings.DFV_LANG == "IT" then
							self.string = self.string .. "o"											
					end
			    end
				local prep_foods = require("preparedfoods")
				if prep_foods[item.prefab] ~= nil and prep_foods[item.prefab].temperatureduration ~= nil then
					self.string = self.string .. " / t "
					if prep_foods[item.prefab].temperature < 0 then
						self.string = self.string .. "-"
					else
						self.string = self.string .. "+"
					end					
					self.string = self.string .. prep_foods[item.prefab].temperatureduration
				elseif item.prefab == "ice" and item.components.edible.temperatureduration ~= nil then
					self.string = self.string .. " / t "
					if item.components.edible.temperaturedelta < 0 then
						self.string = self.string .. "-"
					else
						self.string = self.string .. "+"
					end					
					self.string = self.string .. item.components.edible.temperatureduration
				end		    
			else
				self.string = self.string .. "\n"
				local prep_foods = require("preparedfoods")
				if prep_foods[item.prefab] ~= nil and prep_foods[item.prefab].temperatureduration ~= nil then
					self.string = self.string .. "t "
					if prep_foods[item.prefab].temperature < 0 then
						self.string = self.string .. "-"
					else
						self.string = self.string .. "+"
					end					
					self.string = self.string .. prep_foods[item.prefab].temperatureduration
				elseif item.prefab == "ice" and item.components.edible.temperatureduration ~= nil then
					self.string = self.string .. "t "
					if item.components.edible.temperaturedelta < 0 then
						self.string = self.string .. "-"
					else
						self.string = self.string .. "+"
					end					
					self.string = self.string .. item.components.edible.temperatureduration
				end		    
		    end	
		end	
		
	self.string = self.string .."\n\n" .. " "
	self.string_dirty:set(self.string)
	self.itemupdate:push()

	
end

function FoodValues:SpawnPrefabAsServerAndRemoveFromWorld(name)
 
    local loot = nil
    if TheWorld.ismastersim then 
        loot=SpawnPrefab(name)      
        loot:Remove()
    else
        TheWorld.ismastersim = true
        loot=SpawnPrefab(name)        
        loot:Remove()
        TheWorld.ismastersim = false
    end
    if loot.replica.inventoryitem then
        loot.replica.inventoryitem.DeserializeUsage = function() end
    end
    return loot
    
end





return FoodValues