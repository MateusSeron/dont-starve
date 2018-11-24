Assets = {
    Asset("ATLAS","images/inventory_bg.xml"),
}

local require = GLOBAL.require
local Vector3 = GLOBAL.Vector3
local TUNING = GLOBAL.TUNING
local MAXITEMSLOTS = GLOBAL.MAXITEMSLOTS
local makereadonly = GLOBAL.makereadonly
local SCALEMODE_PROPORTIONAL = GLOBAL.SCALEMODE_PROPORTIONAL
local TALKINGFONT = GLOBAL.TALKINGFONT
local ANCHOR_BOTTOM = GLOBAL.ANCHOR_BOTTOM
local IsServer = GLOBAL.TheNet:GetIsServer()
local TheInput = GLOBAL.TheInput
local ThePlayer = GLOBAL.ThePlayer
local net_entity = GLOBAL.net_entity

ENABLEBACKPACK = GetModConfigData("ENABLEBACKPACK")
INVENTORYSIZE = GetModConfigData("INVENTORYSIZE")
CHESTERSIZE = GetModConfigData("CHESTERSIZE")
MAXITEMSLOTS = INVENTORYSIZE
EXTRASLOT = GetModConfigData("EXTRASLOT")

if EXTRASLOT == 1 then
    MAXITEMSLOTS = MAXITEMSLOTS + 1
end

if EXTRASLOT > 1 then
    MAXITEMSLOTS = MAXITEMSLOTS - 1
end

_G = GLOBAL
local TheNet = _G.rawget(_G, "TheNet")

local inventory = require("components/inventory")
local inventory_replica = require("components/inventory_replica")
local inv = require("widgets/inventorybar")
local InvSlot = require("widgets/invslot")
local Image = require("widgets/image")
local Widget = require("widgets/widget")
local EquipSlot = require("widgets/equipslot")
local ItemTile = require("widgets/itemtile")
local Text = require("widgets/text")
local ThreeSlice = require("widgets/threeslice")
local TEMPLATES = require "widgets/templates"
inventory.maxslots = MAXITEMSLOTS

if INVENTORYSIZE ~= 15 then

    local inventory_CTorBase = inventory._ctor or function() return true end
    function inventory._ctor(self, inst)
        self.inst = inst
        self.isopen = false
        self.isvisible = false

        self.ignoreoverflow = false
        self.ignorefull = false
        self.ignoresound = false

        self.itemslots = { }
        self.maxslots = MAXITEMSLOTS

        self.equipslots = { }

        self.activeitem = nil
        self.acceptsstacks = true
        self.ignorescangoincontainer = false
        self.opencontainers = { }

        if inst.replica.inventory.classified ~= nil then
            makereadonly(self, "maxslots")
            makereadonly(self, "acceptsstacks")
            makereadonly(self, "ignorescangoincontainer")
        end
    end

    local InventoryGetNumSlotsBase = inventory_replica.GetNumSlots
    function inventory_replica:GetNumSlots()
        local result = InventoryGetNumSlotsBase(self)
        return MAXITEMSLOTS
    end

    local function addItemSlotNetvarsInInventory(inst)
        if (#inst._items < MAXITEMSLOTS) then
            for i = #inst._items + 1, MAXITEMSLOTS do
                table.insert(inst._items, net_entity(inst.GUID, "inventory._items[" .. tostring(i) .. "]", "items[" .. tostring(i) .. "]dirty"))
            end
        end
    end
    AddPrefabPostInit("inventory_classified", addItemSlotNetvarsInInventory)

    local HUD_ATLAS = "images/hud.xml"
    local W = 64
    local SEP = 7
    local YSEP = 8
    local INTERSEP = 15

    local inv_CTorBase = inv._ctor or function() return true end
    function inv._ctor(self, owner)
        inv_CTorBase(self, owner)

        self.root:KillAllChildren()
        self.bg = self.root:AddChild(ThreeSlice(HUD_ATLAS, "inventory_corner.tex", "inventory_filler.tex"))
        self.newbg = self.root:AddChild(Image("images/inventory_bg.xml", "inventory_bg.tex"))
        self.newbg:SetVRegPoint(ANCHOR_BOTTOM)
        if MAXITEMSLOTS == 45 then
            self.newbg:SetScale(1.393, 1.128, 0)
        elseif MAXITEMSLOTS == 46 or MAXITEMSLOTS == 44 then
            self.newbg:SetScale(1.45, 1.128, 0)
        elseif MAXITEMSLOTS == 26 or MAXITEMSLOTS == 24 then
            self.newbg:SetScale(0.89, 1.128, 0)
        else
            self.newbg:SetScale(0.84, 1.128, 0)
        end
        self.newbg:SetPosition(Vector3(0, -93, 0))

        self.repeat_time = .2

        self.actionstring = self.root:AddChild(Widget("actionstring"))
        self.actionstring:SetScaleMode(SCALEMODE_PROPORTIONAL)

        self.actionstringtitle = self.actionstring:AddChild(Text(TALKINGFONT, 35))
        self.actionstringtitle:SetColour(204 / 255, 180 / 255, 154 / 255, 1)

        self.actionstringbody = self.actionstring:AddChild(Text(TALKINGFONT, 25))
        self.actionstringbody:EnableWordWrap(true)
        self.actionstring:Hide()

        self.root:SetPosition(self.in_pos)
        self:StartUpdating()
    end

    local function BackpackGet(inst, data)
        local owner = ThePlayer
        if owner ~= nil and owner.HUD ~= nil and owner.replica.inventory:IsHolding(inst) then
            local inv = owner.HUD.controls.inv
            if inv ~= nil then
                inv:OnItemGet(data.item, inv.backpackinv[data.slot], data.src_pos, data.ignore_stacksize_anim)
            end
        end
    end

    local function BackpackLose(inst, data)
        local owner = ThePlayer
        if owner ~= nil and owner.HUD ~= nil and owner.replica.inventory:IsHolding(inst) then
            local inv = owner.HUD.controls.inv
            if inv then
                inv:OnItemLose(inv.backpackinv[data.slot])
            end
        end
    end

    local function InventorybarRework(self)
        function inv:Rebuild()
            if self.cursor then
                self.cursor:Kill()
                self.cursor = nil
            end

            if self.toprow then
                self.toprow:Kill()
            end

            if self.bottomrow then
                self.bottomrow:Kill()
            end

            self.toprow = self.root:AddChild(Widget("toprow"))
            self.bottomrow = self.root:AddChild(Widget("toprow"))
            self.bottomrow:SetPosition(0, - W - SEP, 0)
            self.inv = { }
            self.equip = { }
            self.backpackinv = { }

            local row_offset =(W + SEP)

            local inventory = self.owner.replica.inventory
            local overflow = inventory:GetOverflowContainer()

            local y = 0
            local eslot_order = { }

            local num_slots = MAXITEMSLOTS

            if EXTRASLOT == 1 then
                num_slots = MAXITEMSLOTS - 1
            end
			
			if EXTRASLOT > 1 then
                num_slots = MAXITEMSLOTS + 1
            end

            local num_equip = #self.equipslotinfo

            local T = num_slots + 5

            local num_intersep =(T / 10) -1
            local total_w =(num_slots -((num_slots - 5) / 2)) *(W) +(num_slots -((num_slots - 5) / 2) -1 - num_intersep) *(SEP) +(INTERSEP * num_intersep)
            local total_e = num_equip * 64 + SEP *(num_equip - 1)

            for k, v in ipairs(self.equipslotinfo) do
                local slot = EquipSlot(v.slot, v.atlas, v.image, self.owner)
                self.equip[v.slot] = self.toprow:AddChild(slot)
                local x = - total_e / 2 + W / 2 +(k - 1) * W +(k - 1) * SEP
                slot:SetPosition(x, y + row_offset + 2, 0)
                table.insert(eslot_order, slot)

                local item = inventory:GetEquippedItem(v.slot)
                if item then
                    slot:SetTile(ItemTile(item, inventory))
                end

            end

            if EXTRASLOT > 0 then
                if MAXITEMSLOTS > 40 then
                    for k = 1, T / 5 do
                        local slot = InvSlot(k, HUD_ATLAS, "inv_slot.tex", self.owner, inventory)
                        self.inv[k] = self.toprow:AddChild(slot)
                        local interseps = math.floor((k - 1 - T / 2) / 5)
                        local x = - total_w / 2 + W / 2 + interseps *(INTERSEP - SEP) +(k - 1) * W +(k - 1) * SEP + 5
                        slot:SetPosition(x, y, 0)

                        local item = inventory:GetItemInSlot(k)
                        if item then
                            slot:SetTile(ItemTile(item, inventory))
                        end
                    end

                    for k = T / 5 + 1, T / 5 + 6 do
                        local slot = InvSlot(k, HUD_ATLAS, "inv_slot.tex", self.owner, inventory)
                        self.inv[k] = self.toprow:AddChild(slot)
                        local interseps = 0
                        -- math.floor((k - 1 - T / 2) / 6)
                        local x = - total_w / 2 + W / 2 + interseps *(INTERSEP - SEP) +(k - 1) * W +(k - 1) * SEP - 19
                        slot:SetPosition(x, y, 0)

                        local item = inventory:GetItemInSlot(k)
                        if item then
                            slot:SetTile(ItemTile(item, inventory))
                        end
                    end

                    for k =((T / 5) + 7),(T / 2 + 1) do
                        local slot = InvSlot(k, HUD_ATLAS, "inv_slot.tex", self.owner, inventory)
                        self.inv[k] = self.toprow:AddChild(slot)
                        local interseps = math.floor((k + 5 - 2 - T / 2) / 5)
                        local x = - total_w / 2 + W / 2 + interseps *(INTERSEP - SEP) +(k - 1) * W +(k - 1) * SEP - 3
                        slot:SetPosition(x, y, 0)

                        local item = inventory:GetItemInSlot(k)
                        if item then
                            slot:SetTile(ItemTile(item, inventory))
                        end
                    end
					
					if EXTRASLOT == 1 then
						for k =((T / 2) + 2),((T / 2) +((T / 2) -5) / 2 + 1) do
							local slot = InvSlot(k, HUD_ATLAS, "inv_slot.tex", self.owner, inventory)
							self.inv[k] = self.toprow:AddChild(slot)
							local interseps = math.floor((k - 2 - T / 2) / 5)
							local x = - total_w / 2 + W / 2 + interseps *(INTERSEP - SEP) +(k - 2 - T / 2) * W +(k - 2 - T / 2) * SEP - 36
							slot:SetPosition(x, y + row_offset, 0)

							local item = inventory:GetItemInSlot(k)
							if item then
								slot:SetTile(ItemTile(item, inventory))
							end
						end

						for k =((T / 2) +((T / 2) -5) / 2 + 1) + 1,(T - 5) + 1 do
							local slot = InvSlot(k, HUD_ATLAS, "inv_slot.tex", self.owner, inventory)
							self.inv[k] = self.toprow:AddChild(slot)
							local interseps = math.floor((k + 5 - 2 - T / 2) / 5)
							local x = - total_w / 2 + W / 2 + interseps *(INTERSEP - SEP) +(k + 5 - 2 - T / 2) * W +(k + 5 - 2 - T / 2) * SEP + 36
							slot:SetPosition(x, y + row_offset, 0)

							local item = inventory:GetItemInSlot(k)
							if item then
								slot:SetTile(ItemTile(item, inventory))
							end
						end
					else
						for k =((T / 2) + 2),((T / 2) +((T / 2) -5) / 2 ) do
							local slot = InvSlot(k, HUD_ATLAS, "inv_slot.tex", self.owner, inventory)
							self.inv[k] = self.toprow:AddChild(slot)
							local interseps = math.floor((k - 2 - T / 2) / 5)
							local x = - total_w / 2 + W / 2 + interseps *(INTERSEP - SEP) +(k - 2 - T / 2) * W +(k - 2 - T / 2) * SEP - 36
							slot:SetPosition(x, y + row_offset, 0)

							local item = inventory:GetItemInSlot(k)
							if item then
								slot:SetTile(ItemTile(item, inventory))
							end
						end

						for k =((T / 2) +((T / 2) -5) / 2 + 1) ,(T - 5) - 1 do
							local slot = InvSlot(k, HUD_ATLAS, "inv_slot.tex", self.owner, inventory)
							self.inv[k] = self.toprow:AddChild(slot)
							local interseps = math.floor((k + 5  - T / 2) / 5)
							local x = - total_w / 2 + W / 2 + interseps *(INTERSEP - SEP) +(k + 5  - T / 2) * W +(k + 5  - T / 2) * SEP + 36
							slot:SetPosition(x, y + row_offset, 0)

							local item = inventory:GetItemInSlot(k)
							if item then
								slot:SetTile(ItemTile(item, inventory))
							end
						end
					end
                else
                    for k = 1, T / 6 do
                        local slot = InvSlot(k, HUD_ATLAS, "inv_slot.tex", self.owner, inventory)
                        self.inv[k] = self.toprow:AddChild(slot)
                        local interseps = math.floor((k - 1 - T / 2) / 5)
                        local x = - total_w / 2 + W / 2 + interseps *(INTERSEP - SEP) +(k - 1) * W +(k - 1) * SEP - 12
                        slot:SetPosition(x, y, 0)

                        local item = inventory:GetItemInSlot(k)
                        if item then
                            slot:SetTile(ItemTile(item, inventory))
                        end
                    end

                    for k = T / 6 + 1, T / 6 + 6 do
                        local slot = InvSlot(k, HUD_ATLAS, "inv_slot.tex", self.owner, inventory)
                        self.inv[k] = self.toprow:AddChild(slot)
                        local interseps = 0
                        -- math.floor((k - 1 - T / 2) / 6)
                        local x = - total_w / 2 + W / 2 + interseps *(INTERSEP - SEP) +(k - 1) * W +(k - 1) * SEP - 28
                        slot:SetPosition(x, y, 0)

                        local item = inventory:GetItemInSlot(k)
                        if item then
                            slot:SetTile(ItemTile(item, inventory))
                        end
                    end

                    for k =((T / 6) + 7),(T / 2 + 1) do
                        local slot = InvSlot(k, HUD_ATLAS, "inv_slot.tex", self.owner, inventory)
                        self.inv[k] = self.toprow:AddChild(slot)
                        local interseps = math.floor((k + 5 - 2 - T / 2) / 5)
                        local x = - total_w / 2 + W / 2 + interseps *(INTERSEP - SEP) +(k - 1) * W +(k - 1) * SEP - 18
                        slot:SetPosition(x, y, 0)

                        local item = inventory:GetItemInSlot(k)
                        if item then
                            slot:SetTile(ItemTile(item, inventory))
                        end
                    end
					if EXTRASLOT == 1 then
						for k =((T / 2) + 2),((T / 2) +((T / 2) -5) / 2 + 1) do
							local slot = InvSlot(k, HUD_ATLAS, "inv_slot.tex", self.owner, inventory)
							self.inv[k] = self.toprow:AddChild(slot)
							local interseps = math.floor((k - 2 - T / 2) / 5)
							local x = - total_w / 2 + W / 2 + interseps *(INTERSEP - SEP) +(k - 2 - T / 2) * W +(k - 2 - T / 2) * SEP - 36
							slot:SetPosition(x, y + row_offset, 0)

							local item = inventory:GetItemInSlot(k)
							if item then
								slot:SetTile(ItemTile(item, inventory))
							end
						end

						for k =((T / 2) +((T / 2) -5) / 2 + 1) + 1,(T - 5) + 1 do
							local slot = InvSlot(k, HUD_ATLAS, "inv_slot.tex", self.owner, inventory)
							self.inv[k] = self.toprow:AddChild(slot)
							local interseps = math.floor((k + 5 - 2 - T / 2) / 5)
							local x = - total_w / 2 + W / 2 + interseps *(INTERSEP - SEP) +(k + 5 - 2 - T / 2) * W +(k + 5 - 2 - T / 2) * SEP + 36
							slot:SetPosition(x, y + row_offset, 0)

							local item = inventory:GetItemInSlot(k)
							if item then
								slot:SetTile(ItemTile(item, inventory))
							end
						end
					else
						for k =((T / 2) + 2),((T / 2) +((T / 2) -5) / 2 ) do
							local slot = InvSlot(k, HUD_ATLAS, "inv_slot.tex", self.owner, inventory)
							self.inv[k] = self.toprow:AddChild(slot)
							local interseps = math.floor((k - 2 - T / 2) / 5)
							local x = - total_w / 2 + W / 2 + interseps *(INTERSEP - SEP) +(k - 2 - T / 2) * W +(k - 2 - T / 2) * SEP - 36
							slot:SetPosition(x, y + row_offset, 0)

							local item = inventory:GetItemInSlot(k)
							if item then
								slot:SetTile(ItemTile(item, inventory))
							end
						end

						for k =((T / 2) +((T / 2) -5) / 2 + 1) ,(T - 5) - 1 do
							local slot = InvSlot(k, HUD_ATLAS, "inv_slot.tex", self.owner, inventory)
							self.inv[k] = self.toprow:AddChild(slot)
							local interseps = math.floor((k + 5 - T / 2) / 5)
							local x = - total_w / 2 + W / 2 + interseps *(INTERSEP - SEP) +(k + 5 - T / 2) * W +(k + 5 - T / 2) * SEP + 36
							slot:SetPosition(x, y + row_offset, 0)

							local item = inventory:GetItemInSlot(k)
							if item then
								slot:SetTile(ItemTile(item, inventory))
							end
						end
					end
                end
            else
                for k = 1, T / 2 do
                    local slot = InvSlot(k, HUD_ATLAS, "inv_slot.tex", self.owner, inventory)
                    self.inv[k] = self.toprow:AddChild(slot)
                    local interseps = math.floor((k - 1) / 5)
                    local x = - total_w / 2 + W / 2 + interseps *(INTERSEP - SEP) +(k - 1) * W +(k - 1) * SEP
                    slot:SetPosition(x, y, 0)

                    local item = inventory:GetItemInSlot(k)
                    if item then
                        slot:SetTile(ItemTile(item, inventory))
                    end
                end

                for k =((T / 2) + 1),((T / 2) +((T / 2) -5) / 2) do
                    local slot = InvSlot(k, HUD_ATLAS, "inv_slot.tex", self.owner, inventory)
                    self.inv[k] = self.toprow:AddChild(slot)
                    local interseps = math.floor((k - 1 - T / 2) / 5)
                    local x = - total_w / 2 + W / 2 + interseps *(INTERSEP - SEP) +(k - 1 - T / 2) * W +(k - 1 - T / 2) * SEP
                    slot:SetPosition(x, y + row_offset, 0)

                    local item = inventory:GetItemInSlot(k)
                    if item then
                        slot:SetTile(ItemTile(item, inventory))
                    end
                end

                for k =((T / 2) +((T / 2) -5) / 2 + 1),(T - 5) do
                    local slot = InvSlot(k, HUD_ATLAS, "inv_slot.tex", self.owner, inventory)
                    self.inv[k] = self.toprow:AddChild(slot)
                    local interseps = math.floor((k + 5 - 1 - T / 2) / 5)
                    local x = - total_w / 2 + W / 2 + interseps *(INTERSEP - SEP) +(k + 5 - 1 - T / 2) * W +(k + 5 - 1 - T / 2) * SEP
                    slot:SetPosition(x, y + row_offset, 0)

                    local item = inventory:GetItemInSlot(k)
                    if item then
                        slot:SetTile(ItemTile(item, inventory))
                    end
                end
            end

            local image_name = "self_inspect_" .. self.owner.prefab .. ".tex"
            local atlas_name = "images/hud.xml"

            if not self.controller_build then
                self.bg:SetScale(1.22, 1, 1)
                self.bgcover:SetScale(1.22, 1, 1)
                self.inspectcontrol = self.root:AddChild(TEMPLATES.IconButton(atlas_name, image_name, "Inspect Self", false, false, function() self.owner.HUD:InspectSelf() end, { size = 40 }, "self_inspect_mod.tex"))
                self.inspectcontrol.icon:SetScale(.7)
                self.inspectcontrol.icon:SetPosition(-4, 6)
                self.inspectcontrol:SetScale(1.25)
                self.inspectcontrol:SetPosition((total_w - W) * .5 + 3, 150 - 6, 0)
            else
                self.bg:SetScale(1.15, 1, 1)
                self.bgcover:SetScale(1.15, 1, 1)

                if self.inspectcontrol ~= nil then
                    self.inspectcontrol:Kill()
                    self.inspectcontrol = nil
                end
            end


            local old_backpack = self.backpack
            if self.backpack then
                self.inst:RemoveEventCallback("itemget", BackpackGet, self.backpack)
                self.inst:ListenForEvent("itemlose", BackpackLose, self.backpack)
                self.backpack = nil
            end

            local new_backpack = inventory.overflow
            local do_integrated_backpack = _G.TheInput:ControllerAttached() and new_backpack

            if do_integrated_backpack then

                local num = new_backpack.components.container.numslots
                local total_wb = 0
                local backpack_controller_size_max = 0

                backpack_controller_size_max = 25
                total_wb =(num_slots + 5) / 2 * W +((num_slots + 5) / 2 - 1 - 4) * SEP + 4 * INTERSEP

                if num > backpack_controller_size_max then

                    for k = backpack_controller_size_max + 1, num do
                        local item = new_backpack.components.container:GetItemInSlot(k)
                        new_backpack.components.container:DropItem(item)
                    end

                    new_backpack.components.container:SetNumSlots(backpack_controller_size_max, num)
                    num = backpack_controller_size_max
                end

                for k = 1, num do
                    local slot = InvSlot(k, HUD_ATLAS, "inv_slot.tex", self.owner, new_backpack.components.container)
                    self.backpackinv[k] = self.bottomrow:AddChild(slot)
                    local interseps_backpack = math.floor((k - 1) / 5)
                    local x = - total_wb / 2 + W / 2 + interseps_backpack *(INTERSEP - SEP) +(k - 1) * W +(k - 1) * SEP
                    slot:SetPosition(x, y, 0)

                    local item = new_backpack.components.container:GetItemInSlot(k)
                    if item then
                        slot:SetTile(ItemTile(item))
                    end
                end

                self.backpack = inventory.overflow
                self.inst:ListenForEvent("itemget", BackpackGet, self.backpack)
                self.inst:ListenForEvent("itemlose", BackpackLose, self.backpack)

            end

            if old_backpack and not self.backpack then
                self:SelectSlot(self.inv[1])
                self.current_list = self.inv
            end

            if do_integrated_backpack then
                self.root:SetPosition(self.in_pos)
            else
                self.root:SetPosition(self.out_pos)
            end

            self.actionstring:MoveToFront()

            self:SelectSlot(self.inv[1])
            self.current_list = self.inv
            self:UpdateCursor()

            if self.cursor then
                self.cursor:MoveToFront()
            end

            self.rebuild_pending = false
        end

        local oldOnUpdate = self.OnUpdate

        function self:OnUpdate(dt)

            oldOnUpdate(self, dt)

            self.openhint:Hide()
        end
    end


    AddClassPostConstruct("widgets/inventorybar", InventorybarRework)

end

local SERVER_SIDE = _G.TheNet:GetIsServer()

if not SERVER_SIDE then
    return
end

AddPrefabPostInit("backpack",
function(inst)
    if ENABLEBACKPACK == true then
        if inst.components.inventoryitem then
            inst.components.inventoryitem.cangoincontainer = true
        end
    else
        if inst.components.inventoryitem then
            inst.components.inventoryitem.cangoincontainer = false
        end
    end
end )