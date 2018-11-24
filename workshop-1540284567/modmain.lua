local require = GLOBAL.require
local stackable_replica = require "components/stackable_replica"
local IsServer = GLOBAL.TheNet:GetIsServer()

local size = GetModConfigData("MAXSTACKSIZE")
local TUNING = GLOBAL.TUNING
local net_byte = GLOBAL.net_byte

TUNING.STACK_SIZE_LARGEITEM = size
TUNING.STACK_SIZE_MEDITEM = size
TUNING.STACK_SIZE_SMALLITEM = size 

local stackable_replica_ctorBase = stackable_replica._ctor or function() return true end    
function stackable_replica._ctor(self, inst)
    self.inst = inst

    self._stacksize = net_byte(inst.GUID, "stackable._stacksize", "stacksizedirty")
    self._maxsize = size
end

local stackable_replicaSetMaxSize_Base = stackable_replica.SetMaxSize or function() return true end
function stackable_replica:SetMaxSize(maxsize)
  self._maxsize = size
end

local stackable_replicaMaxSize_Base = stackable_replica.MaxSize or function() return true end
function stackable_replica:MaxSize()
  return self._maxsize
end


if IsServer then
AddPrefabPostInit("rabbit",function(inst)
   if(inst.components.stackable == nil) then
      inst:AddComponent("stackable")
   end
   inst.components.inventoryitem:SetOnDroppedFn(function(inst)
        inst.components.perishable:StopPerishing()
        inst.sg:GoToState("stunned")
        if inst.components.stackable then
    	    while inst.components.stackable:StackSize() > 1 do
    	        local item = inst.components.stackable:Get()
    	        if item then
    	            if item.components.inventoryitem then
    	                item.components.inventoryitem:OnDropped()
    	            end
    	            item.Physics:Teleport(inst.Transform:GetWorldPosition() )
    	        end
    	    end
    	 end
    end)
end)
end

if IsServer then
AddPrefabPostInit("mole",function(inst)
   if(inst.components.stackable == nil) then
      inst:AddComponent("stackable")
   end
   inst.components.inventoryitem:SetOnDroppedFn(function(inst)
        inst.components.perishable:StopPerishing()
        inst.sg:GoToState("stunned")
        if inst.components.stackable then
            while inst.components.stackable:StackSize() > 1 do
                local item = inst.components.stackable:Get()
                if item then
                    if item.components.inventoryitem then
                        item.components.inventoryitem:OnDropped()
                    end
                    item.Physics:Teleport(inst.Transform:GetWorldPosition() )
                end
            end
         end
    end)
end)
end

if IsServer then
AddPrefabPostInit("crow",function(inst)
   if(inst.components.stackable == nil) then
      inst:AddComponent("stackable")
   end
   inst.components.inventoryitem:SetOnDroppedFn(function(inst)
        inst.components.perishable:StopPerishing()
        inst.sg:GoToState("stunned")
        if inst.components.stackable then
            while inst.components.stackable:StackSize() > 1 do
                local item = inst.components.stackable:Get()
                if item then
                    if item.components.inventoryitem then
                        item.components.inventoryitem:OnDropped()
                    end
                    item.Physics:Teleport(inst.Transform:GetWorldPosition() )
                end
            end
         end
    end)
end)
end

if IsServer then
AddPrefabPostInit("robin",function(inst)
   if(inst.components.stackable == nil) then
      inst:AddComponent("stackable")
   end
   inst.components.inventoryitem:SetOnDroppedFn(function(inst)
        inst.components.perishable:StopPerishing()
        inst.sg:GoToState("stunned")
        if inst.components.stackable then
            while inst.components.stackable:StackSize() > 1 do
                local item = inst.components.stackable:Get()
                if item then
                    if item.components.inventoryitem then
                        item.components.inventoryitem:OnDropped()
                    end
                    item.Physics:Teleport(inst.Transform:GetWorldPosition() )
                end
            end
         end
    end)
end)
end

if IsServer then
AddPrefabPostInit("robin_winter",function(inst)
   if(inst.components.stackable == nil) then
      inst:AddComponent("stackable")
   end
   inst.components.inventoryitem:SetOnDroppedFn(function(inst)
        inst.components.perishable:StopPerishing()
        inst.sg:GoToState("stunned")
        if inst.components.stackable then
            while inst.components.stackable:StackSize() > 1 do
                local item = inst.components.stackable:Get()
                if item then
                    if item.components.inventoryitem then
                        item.components.inventoryitem:OnDropped()
                    end
                    item.Physics:Teleport(inst.Transform:GetWorldPosition() )
                end
            end
         end
    end)
end)
end

if IsServer then
AddPrefabPostInit("canary",function(inst)
   if(inst.components.stackable == nil) then
      inst:AddComponent("stackable")
   end
   inst.components.inventoryitem:SetOnDroppedFn(function(inst)
        inst.components.perishable:StopPerishing()
        inst.sg:GoToState("stunned")
        if inst.components.stackable then
            while inst.components.stackable:StackSize() > 1 do
                local item = inst.components.stackable:Get()
                if item then
                    if item.components.inventoryitem then
                        item.components.inventoryitem:OnDropped()
                    end
                    item.Physics:Teleport(inst.Transform:GetWorldPosition() )
                end
            end
         end
    end)
end)
end

if IsServer then
AddPrefabPostInit("eyeturret_item",function(inst)
   if(inst.components.stackable == nil) then
      inst:AddComponent("stackable")
   end
   inst.components.inventoryitem:SetOnDroppedFn(function(inst)
        inst.components.perishable:StopPerishing()
        inst.sg:GoToState("stunned")
        if inst.components.stackable then
    	    while inst.components.stackable:StackSize() > 1 do
    	        local item = inst.components.stackable:Get()
    	        if item then
    	            if item.components.inventoryitem then
    	                item.components.inventoryitem:OnDropped()
    	            end
    	            item.Physics:Teleport(inst.Transform:GetWorldPosition() )
    	        end
    	    end
    	 end
    end)
end)
end

if IsServer then
AddPrefabPostInit("wetpouch",function(inst)
   if(inst.components.stackable == nil) then
      inst:AddComponent("stackable")
   end
   inst.components.inventoryitem:SetOnDroppedFn(function(inst)
        inst.components.perishable:StopPerishing()
        inst.sg:GoToState("stunned")
        if inst.components.stackable then
    	    while inst.components.stackable:StackSize() > 1 do
    	        local item = inst.components.stackable:Get()
    	        if item then
    	            if item.components.inventoryitem then
    	                item.components.inventoryitem:OnDropped()
    	            end
    	            item.Physics:Teleport(inst.Transform:GetWorldPosition() )
    	        end
    	    end
    	 end
    end)
end)
end

----------------------------------------
local MaxStack = GetModConfigData("MAXSTACKSIZE")
local DropWholeStack = GetModConfigData("DropWholeStack")
local DST = GLOBAL.TheSim:GetGameID() == "DST"

local function CanDropAll(act)
	if act.invobject ~= nil and act.invobject:HasTag("trap") then
		if DST then
			if act.invobject:HasTag("dropall") then
				return true
			end
		else
			if GLOBAL.TheInput:IsControlPressed(GLOBAL.CONTROL_FORCE_STACK) then
				return true
			end
		end
	end
	return false
end

GLOBAL.STRINGS.ACTIONS.DROP.DROPALL = "Drop All"

local oldactiondrop = GLOBAL.ACTIONS.DROP.fn
GLOBAL.ACTIONS.DROP.fn = function(act)
	if CanDropAll(act) then
		if act.invobject:HasTag("dropall") then                       
			act.invobject:RemoveTag("dropall")
		end	
		return act.doer.components.inventory ~= nil and act.doer.components.inventory:DropItem(act.invobject,true,false,act.pos) or nil    
	end
	return oldactiondrop(act)
end	

local oldactiondropstr = GLOBAL.ACTIONS.DROP.strfn
GLOBAL.ACTIONS.DROP.strfn = function(act)
	if CanDropAll(act) then
		return "DROPALL"
	end	
	return oldactiondropstr(act)
end

if DST then
	local function dropall(inst, doer, pos, actions, right)
		if inst:HasTag("trap") and not right and inst.replica.inventoryitem:IsHeldBy(doer) then
			if doer.components.playercontroller ~= nil then
				if doer.components.playercontroller:IsControlPressed(GLOBAL.CONTROL_FORCE_STACK) then
					if not inst:HasTag("dropall") then
						inst:AddTag("dropall")
					end	
				else
					if inst:HasTag("dropall") then
						inst:RemoveTag("dropall")
					end
				end
			end
			table.insert(actions, GLOBAL.ACTIONS.DROP)
		end
	end
	AddComponentAction("POINT", "inventoryitem", dropall)
end	

local function DecreaseSizeByOne(inst)
	local size = inst.components.stackable:StackSize() - 1
	inst.components.stackable:SetStackSize(size)	
end

local function CaseOne(inst, components1, components2)
	local percent = components1:GetPercent() + components2:GetPercent()
	if percent > 1 then
		percent = percent - 1
	else
		DecreaseSizeByOne(inst)
	end
	components1:SetPercent(percent)
end

local function CaseTwo(item, components1, components2)
	local sourceper = components1:GetPercent()
	if sourceper < 1 then
		local itemper = components2:GetPercent()
		local percentleft = 1 - sourceper
		if itemper > percentleft then
			local percent = itemper - percentleft
			components2:SetPercent(percent)
			components1:SetPercent(1)
		else
			if item.components.stackable:StackSize() > 1 then
				components1:SetPercent(1)
				local percent = 1 - (percentleft - itemper)
				components2:SetPercent(percent)
				DecreaseSizeByOne(item)
			else
				local percent = sourceper + itemper
				components1:SetPercent(percent)
				item:Remove()
				return true
			end
		end
		if components2:GetPercent() < 0.01 then
			item:Remove()
			return true
		end
	end
	return false
end

local function newstackable(self)
	local _Put = self.Put
	self.Put = function(self, item, source_pos)
		if item.prefab == self.inst.prefab then
			local instper, itemper
			local newtotal = item.components.stackable:StackSize() + self.inst.components.stackable:StackSize()
			if item.components.finiteuses ~= nil then
				instper = self.inst.components.finiteuses
				itemper = item.components.finiteuses
			elseif item.components.fueled ~= nil then
				instper = self.inst.components.fueled
				itemper = item.components.fueled
			elseif item.components.armor ~= nil then
				instper = self.inst.components.armor
				itemper = item.components.armor
			end
			
			if instper ~= nil and itemper ~= nil then
				if newtotal <= self.inst.components.stackable.maxsize then
					CaseOne(self.inst, instper, itemper)
				else						
					if CaseTwo(item, instper, itemper) then
						return nil
					end
				end
			end
			
		end
		return _Put(self, item, source_pos)
	end
end

AddComponentPostInit("stackable", newstackable)

if DropWholeStack then

	local function newdropitem(self)
		local _DropItem = self.DropItem
		self.DropItem = function(self, item, wholestack, randomdir, pos)
			if item == nil or item.components.inventoryitem == nil then
				return
			end
			if item.components.stackable ~= nil and item.components.equippable ~= nil and item.components.equippable.equipstack
					and not item:HasTag("projectile") then
				wholestack = true
			end
			return _DropItem(self, item, wholestack, randomdir, pos)
		end
	end

	AddComponentPostInit("inventory", newdropitem)
end

local function newarmor(self)
	local _SetCondition = self.SetCondition
	self.SetCondition = function(self, amount)
		local armorhp = math.min(amount, self.maxcondition)
		if armorhp <= 0 then
			if self.inst.components.stackable ~= nil and self.inst.components.stackable:StackSize() > 1 then
				DecreaseSizeByOne(self.inst)
				amount = self.maxcondition
			end	
		end
		_SetCondition(self, amount)
	end
end

AddComponentPostInit("armor", newarmor)

local function onfinish(inst)
	DecreaseSizeByOne(inst)
	if inst.components.finiteuses ~= nil then
		inst.components.finiteuses:SetPercent(1)
	elseif inst.components.fueled ~= nil then
		inst.components.fueled:SetPercent(1)
	end			
end

local function newsectionfn(_sectionfn, newsection, oldsection, inst, dlc)
	if newsection == 0 then
		if inst.components.stackable:StackSize() > 1 then
			onfinish(inst)
		else
			if dlc then
				_sectionfn(newsection, oldsection, inst)
			else
				_sectionfn(newsection, oldsection)
			end
		end	
	end	
end

if not DST or (DST and GLOBAL.TheNet:GetIsServer()) then

	local function addstackable(inst)
	
		if inst.components.inventoryitem == nil then
			return
		end	
	
		if inst.components.equippable == nil then
			if not inst:HasTag("trap") and not inst:HasTag("mine") and inst.components.instrument == nil and
						inst.components.sewing == nil and inst.components.fertilizer == nil then
				return
			end	
		end	
	
		if inst.components.container ~= nil then
			return
		end
	
		if inst.components.stackable ~= nil then
			return
		end
		
		if inst.components.fueled ~= nil and inst.components.fueled.accepting and inst.components.fueled.ontakefuelfn ~= nil then
			return
		end
		
		inst:AddComponent("stackable")
		inst.components.stackable.maxsize = MaxStack
		if inst:HasTag("trap") then
			inst.components.stackable.forcedropsingle = true
		end
		if inst.components.projectile == nil or (inst.components.projectile ~= nil and not inst.components.projectile.cancatch) then
			if inst.components.throwable == nil then
				if inst.components.equippable ~= nil then
					inst.components.equippable.equipstack = true
				end	
			end	
		end
			
		if inst.components.finiteuses == nil then
			if inst.components.fueled == nil then
				return
			end		
		end
			
		if inst.components.finiteuses ~= nil then
			local _onfinished = inst.components.finiteuses.onfinished and inst.components.finiteuses.onfinished or nil
			if _onfinished ~= nil then
				inst.components.finiteuses.onfinished = function (inst)			
					if inst.components.stackable:StackSize() > 1 then
						onfinish(inst)
					else
						_onfinished(inst)
					end	
				end
			end
		elseif inst.components.fueled ~= nil then
			local _sectionfn = inst.components.fueled.sectionfn and inst.components.fueled.sectionfn or nil
			if _sectionfn ~= nil then
				if DST or (not DST and (GLOBAL.IsDLCEnabled(GLOBAL.REIGN_OF_GIANTS) or GLOBAL.IsDLCEnabled(GLOBAL.CAPY_DLC))) then
					inst.components.fueled.sectionfn = function (newsection, oldsection, inst)
						newsectionfn(_sectionfn, newsection, oldsection, inst, true)
					end
				else
					inst.components.fueled.sectionfn = function (newsection, oldsection)
						newsectionfn(_sectionfn, newsection, oldsection, inst, false)
					end
				end	
			else
				local _depleted = inst.components.fueled.depleted and inst.components.fueled.depleted or nil
				if _depleted ~= nil then
					inst.components.fueled.depleted = function (inst)	
						if inst.components.stackable:StackSize() > 1 then
							onfinish(inst)
						else
							_depleted(inst)
						end	
					end
				end	
			end	
		end
	end
	
	AddPrefabPostInitAny(addstackable)

end