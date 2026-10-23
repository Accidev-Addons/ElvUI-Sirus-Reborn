local E, L, V = unpack(ElvUI)
local S = E:GetModule("Skins")
local LSM = E.Libs.LSM

local _G = _G
local select, next, ipairs = select, next, ipairs
local format = string.format
local CreateFrame = CreateFrame

local GetInventorySlotInfo = GetInventorySlotInfo
local GetItemInfo = GetItemInfo
local GetNumFactions = GetNumFactions
local hooksecurefunc = hooksecurefunc

local C_PlayerInfo = C_PlayerInfo

local function CenterCharacterHeader()
	local width = CharacterFrame:GetWidth()
	if not width or width <= 0 then return end

	local title = _G.CharacterFrameTitleText
	title:ClearAllPoints()
	title:SetPoint("TOPLEFT", CharacterFrame, "TOPLEFT", 26, -5)
	title:SetPoint("TOPRIGHT", CharacterFrame, "TOPRIGHT", -26, -5)
	title:SetJustifyH("CENTER")
	title:SetWordWrap(false)

	CharacterLevelText:ClearAllPoints()
	CharacterLevelText:SetSize(width, 16)
	CharacterLevelText:SetPoint("TOP", title, "BOTTOM", 0, -3)
	CharacterLevelText:SetJustifyH("CENTER")
	CharacterLevelText:SetWordWrap(false)
end

local Slots = {"HeadSlot", "NeckSlot", "ShoulderSlot", "BackSlot", "ChestSlot", "ShirtSlot", "TabardSlot", "WristSlot",
		"HandsSlot", "WaistSlot", "LegsSlot", "FeetSlot", "Finger0Slot", "Finger1Slot", "Trinket0Slot", "Trinket1Slot",
		"MainHandSlot", "SecondaryHandSlot"
	}

function S:ColorItemCharacterBorder()
	local enabled = E.db.general.characterInfo.highlightBlackDiamonds
	for _, slotName in ipairs(Slots) do
		local link = enabled and GetInventoryItemLink("player", GetInventorySlotInfo(slotName))
		self:UpdateBlackDiamondHighlight(_G["Character"..slotName], link)
	end
end

function S:ColorItemInspectBorder()
	local unit = InspectFrame and InspectFrame:IsShown() and InspectFrame.unit
	local enabled = E.db.general.characterInfo.highlightBlackDiamonds
	for _, slotName in ipairs(Slots) do
		local link = enabled and unit and GetInventoryItemLink(unit, GetInventorySlotInfo(slotName))
		self:UpdateBlackDiamondHighlight(_G["Inspect"..slotName], link)
	end
end

local function ColorizeStatPane(frame)
	if frame.leftGrad then return end

	local r, g, b = 0.8, 0.8, 0.8
	frame.leftGrad = frame:CreateTexture(nil, "BORDER")
	frame.leftGrad:Width(frame:GetWidth() * .5)
	frame.leftGrad:Height(frame:GetHeight())
	frame.leftGrad:Point("LEFT", frame, "CENTER")
	frame.leftGrad:SetTexture(E.media.blankTex)
	frame.leftGrad:SetGradientAlpha("Horizontal", r, g, b, 0.35, r, g, b, 0)

	frame.rightGrad = frame:CreateTexture(nil, "BORDER")
	frame.rightGrad:Width(frame:GetWidth() * .5)
	frame.rightGrad:Height(frame:GetHeight())
	frame.rightGrad:Point("RIGHT", frame, "CENTER")
	frame.rightGrad:SetTexture(E.Media.Textures.White8x8)
	frame.rightGrad:SetGradientAlpha("Horizontal", r, g, b, 0, r, g, b, 0.35)
end

local function LoadSkin()
	if not E.private.skins.blizzard.enable or not E.private.skins.blizzard.character then return end

	S:HandlePortraitFrame(CharacterFrame)
	S:HandleInsetFrame(CharacterFrame.InsetRight)

	CenterCharacterHeader()
	if PaperDollFrame_UpdateSpellButtons and not CharacterFrame.HeaderPositionHooked then
		hooksecurefunc("PaperDollFrame_UpdateSpellButtons", CenterCharacterHeader)
		CharacterFrame.HeaderPositionHooked = true
	end

	local characterTabs = {}
	for i = 1, #CHARACTERFRAME_SUBFRAMES do
		local tab = _G["CharacterFrameTab"..i]
		if tab then
			S:HandleSirusTab(tab)
			characterTabs[i] = tab
		end
	end
	S:HandleSirusTabFlow(characterTabs, "PetPaperDollFrame_UpdateIsAvailable")

	PaperDollFrame:StripTextures(true)

	local strengthenPane = CharacterStatsPaneAlt.StrengthenStatsPane

	for _, frame in next, {
		CharacterStatsPane.ItemLevelCategory,
		CharacterStatsPaneCategory1,
		CharacterStatsPaneCategory2,
		strengthenPane.Header,
	} do
		ColorizeStatPane(frame)
		frame.Background:SetAlpha(0)
	end

	ColorizeStatPane(CharacterStatsPane.ItemLevelFrame)
	CharacterStatsPane.ItemLevelFrame.Background:SetAlpha(0)

	for _, category in next, { CharacterStatsPaneAlt.StatsPane.Category1, CharacterStatsPaneAlt.StatsPane.Category2 } do
		category:StripTextures()
		category:SetTemplate("Transparent")
	end

	S:HandleButton(strengthenPane.ResetButton)

	for i = 1, C_PlayerInfo.GetNumBonusStats() do
		local statPlus = _G["CharacterStatsPaneAltStrengthenStatsPaneStat"..i.."Plus"]
		if statPlus then
			statPlus:StripTextures()
			S:HandleButton(statPlus)
			statPlus:SetNormalTexture(E.Media.Textures.Plus)
			statPlus:GetNormalTexture():SetInside()
			statPlus:SetPushedTexture(E.Media.Textures.Plus)
			statPlus:GetPushedTexture():SetInside()
			statPlus:SetDisabledTexture(E.Media.Textures.Plus)
			statPlus:GetDisabledTexture():SetInside()
			statPlus:GetDisabledTexture():SetDesaturated(true)
		end
	end

	PaperDollSidebarTabs:StripTextures()

	C_Timer.After(0,function()
		if PaperDollFrameItemSetSwapButton then
			PaperDollFrameItemSetSwapButton:StripTextures()
			S:HandleButton(PaperDollFrameItemSetSwapButton)
			PaperDollFrameItemSetSwapButton.Icon:SetTexCoords()
		end
	end)
	CharacterModelFrame:CreateBackdrop()
	CharacterModelFrame.backdrop:SetOutside(CharacterModelFrameBackgroundOverlay)
	CharacterModelFrame:DisableDrawLayer("OVERLAY")

	S:HandleControlFrame(CharacterModelFrame.controlFrame)

	for i = 1, #PAPERDOLL_SIDEBARS do
		local tab = _G["PaperDollSidebarTab"..i]
		if tab then
			tab:CreateBackdrop()
			tab.Icon:SetAllPoints()
			tab.Highlight:SetTexture(1, 1, 1, .3)
			tab.Highlight:SetAllPoints()
			tab.Hider:SetTexture(.4, .4, .4, .4)
			tab.Hider:SetAllPoints()
			tab.TabBg:Kill()
		end
	end

	local function SkinSidebarPaneButtons(pane)
		for _, button in next, pane.buttons do
			if not button.isSkinned then
				button.BgTop:SetTexture()
				button.BgBottom:SetTexture()
				button.BgMiddle:SetTexture()
				button.text:FontTemplate()

				if button.icon then
					S:HandleIcon(button.icon, true)
				end

				button.isSkinned = true
			end
		end
	end

	S:HandleSirusScrollBar(PaperDollTitlesPane.scrollBar)
	PaperDollTitlesPane:HookScript("OnShow", SkinSidebarPaneButtons)

	local equipmentManagerPane = PaperDollEquipmentManagerPane
	S:HandleSirusScrollBar(equipmentManagerPane.scrollBar)
	S:HandleButton(equipmentManagerPane.EquipSet)
	S:HandleButton(equipmentManagerPane.SaveSet)
	equipmentManagerPane.EquipSet.ButtonBackground:SetAlpha(0)
	equipmentManagerPane:HookScript("OnShow", SkinSidebarPaneButtons)

	S:HandleIconSelectionFrame(GearManagerPopupFrame)

	if CharacterCustomizationButton then
		CharacterCustomizationButton:ClearAllPoints()
		CharacterCustomizationButton:SetPoint("TOPLEFT", CharacterFrame, "TOPLEFT", 18, -18)

		CharacterCustomizationButton:Size(28, 28)
		CharacterCustomizationButton:CreateBackdrop()

		if CharacterCustomizationButton.NormalTexture then
			CharacterCustomizationButton.NormalTexture:SetInside()
			CharacterCustomizationButton.NormalTexture:SetTexCoords()
		end

		if CharacterCustomizationButton.HighlightTexture then
			CharacterCustomizationButton.HighlightTexture:SetTexture(1, 1, 1, 0.3)
			CharacterCustomizationButton.HighlightTexture:SetInside()
		end

		if CharacterCustomizationButton.DisabledTexture then
			CharacterCustomizationButton.DisabledTexture:SetInside()
			CharacterCustomizationButton.DisabledTexture:SetTexCoords()
		end
	end

	local popoutButtonOnEnter = function(btn) btn.icon:SetVertexColor(unpack(E.media.rgbvaluecolor)) end
	local popoutButtonOnLeave = function(btn) btn.icon:SetVertexColor(1, 1, 1) end

	local slots = {
		[1] = "HeadSlot", [2] = "NeckSlot", [3] = "ShoulderSlot", [4] = "ShirtSlot", [5] = "ChestSlot",
		[6] = "WaistSlot", [7] = "LegsSlot", [8] = "FeetSlot", [9] = "WristSlot", [10] = "HandsSlot",
		[11] = "Finger0Slot", [12] = "Finger1Slot", [13] = "Trinket0Slot", [14] = "Trinket1Slot",
		[15] = "BackSlot", [16] = "MainHandSlot", [17] = "SecondaryHandSlot", [18] = "TabardSlot"
	}

	for _, slotName in ipairs(slots) do
		slots[slotName] = GetInventorySlotInfo(slotName)
	end

	local durabilitySlots = {
		HeadSlot = true, ShoulderSlot = true, ChestSlot = true, WristSlot = true, HandsSlot = true,
		WaistSlot = true, LegsSlot = true, FeetSlot = true, MainHandSlot = true, SecondaryHandSlot = true
	}

	local itemLevelExcluded = { ShirtSlot = true, TabardSlot = true }

	for _, slotName in ipairs(slots) do
		local slotFrame = _G["Character"..slotName]
		local icon = _G["Character"..slotName.."IconTexture"]
		local cooldown = _G["Character"..slotName.."Cooldown"]
		local popout = _G["Character"..slotName.."PopoutButton"]

		slotFrame:StripTextures()
		slotFrame:StyleButton(false)
		slotFrame:SetTemplate("Default", true, true)
		slotFrame.ignoreTexture:SetTexture("Interface\\PaperDollInfoFrame\\UI-GearManager-LeaveItem-Transparent")

		if not itemLevelExcluded[slotName] then
			slotFrame.ItemLevel = slotFrame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
		end

		if durabilitySlots[slotName] then
			slotFrame.DurabilityInfo = slotFrame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
		end

		icon:SetTexCoords()
		icon:SetInside()

		slotFrame:SetFrameLevel(PaperDollFrame:GetFrameLevel() + 2)

		if cooldown then
			E:RegisterCooldown(cooldown)
		end

		if popout then
			popout:StripTextures()
			popout:HookScript("OnEnter", popoutButtonOnEnter)
			popout:HookScript("OnLeave", popoutButtonOnLeave)

			popout.icon = popout:CreateTexture(nil, "ARTWORK")
			popout.icon:Size(24)
			popout.icon:Point("CENTER")
			popout.icon:SetTexture(E.Media.Textures.ArrowUp)

			if slotFrame.verticalFlyout then
				popout.icon:SetRotation(S.ArrowRotation.down)
			else
				popout.icon:SetRotation(S.ArrowRotation.right)
			end
		end
	end

	local function ColorItemBorder()
		for _, slotName in ipairs(slots) do
			local target = _G["Character"..slotName]
			local slotId = slots[slotName]
			local itemId = GetInventoryItemID("player", slotId)

			if itemId then
				local rarity = GetInventoryItemQuality("player", slotId)
				if rarity then
					target:SetBackdropBorderColor(E:GetItemQualityColor(rarity))
				else
					target:SetBackdropBorderColor(unpack(E.media.bordercolor))
				end
			else
				target:SetBackdropBorderColor(unpack(E.media.bordercolor))
			end
		end

		S:ColorItemCharacterBorder()
	end

	local equipmentInfoStyle = {}
	local function UpdateEquipmentInfo()
		local db = E.db.general.characterInfo
		local font = LSM:Fetch("font", db.font)
		local updateStyle = equipmentInfoStyle.font ~= font or
			equipmentInfoStyle.fontSize ~= db.fontSize or
			equipmentInfoStyle.fontOutline ~= db.fontOutline or
			equipmentInfoStyle.itemLevelPosition ~= db.itemLevelPosition or
			equipmentInfoStyle.itemLevelXOffset ~= db.itemLevelXOffset or
			equipmentInfoStyle.itemLevelYOffset ~= db.itemLevelYOffset or
			equipmentInfoStyle.durabilityPosition ~= db.durabilityPosition or
			equipmentInfoStyle.durabilityXOffset ~= db.durabilityXOffset or
			equipmentInfoStyle.durabilityYOffset ~= db.durabilityYOffset
		if updateStyle then
			equipmentInfoStyle.font = font
			equipmentInfoStyle.fontSize = db.fontSize
			equipmentInfoStyle.fontOutline = db.fontOutline
			equipmentInfoStyle.itemLevelPosition = db.itemLevelPosition
			equipmentInfoStyle.itemLevelXOffset = db.itemLevelXOffset
			equipmentInfoStyle.itemLevelYOffset = db.itemLevelYOffset
			equipmentInfoStyle.durabilityPosition = db.durabilityPosition
			equipmentInfoStyle.durabilityXOffset = db.durabilityXOffset
			equipmentInfoStyle.durabilityYOffset = db.durabilityYOffset
		end

		for _, slotName in ipairs(slots) do
			local slotFrame = _G["Character"..slotName]
			local slotId = slots[slotName]

			if slotFrame then
				if slotFrame.ItemLevel then
					local text, r, g, b = ""

					if db.showItemLevel then
						local itemId = GetInventoryItemID("player", slotId)

						if itemId then
							local _, _, rarity, itemLevel = GetItemInfo(itemId)

							if itemLevel then
								text = tostring(itemLevel)

								if db.itemLevelQualityColor then
									r, g, b = E:GetItemQualityColor(rarity)
								end
							end
						end
					end

					if r then
						slotFrame.ItemLevel:SetTextColor(r, g, b)
					else
						slotFrame.ItemLevel:SetTextColor(1, 1, 1)
					end

					if updateStyle then
						slotFrame.ItemLevel:ClearAllPoints()
						slotFrame.ItemLevel:SetPoint(db.itemLevelPosition, slotFrame, db.itemLevelXOffset, db.itemLevelYOffset)
						slotFrame.ItemLevel:FontTemplate(font, db.fontSize, db.fontOutline)
					end
					slotFrame.ItemLevel:SetText(text)
				end

				if slotFrame.DurabilityInfo then
					local text = ""

					if db.showDurability then
						local current, maximum = GetInventoryItemDurability(slotId)

						if current and maximum and maximum > 0 and (not db.durabilityOnlyDamaged or current < maximum) then
							local r, g, b = E:ColorGradient(current / maximum, 1, 0, 0, 1, 1, 0, 0, 1, 0)
							text = format("%s%.0f%%|r", E:RGBToHex(r, g, b), (current / maximum) * 100)
						end
					end

					if updateStyle then
						slotFrame.DurabilityInfo:ClearAllPoints()
						slotFrame.DurabilityInfo:SetPoint(db.durabilityPosition, slotFrame, db.durabilityXOffset, db.durabilityYOffset)
						slotFrame.DurabilityInfo:FontTemplate(font, db.fontSize, db.fontOutline)
					end
					slotFrame.DurabilityInfo:SetText(text)
				end
			end
		end
	end

	local socketDataRetry, socketUpdateTimer
	local function UpdateCharacterEquipmentSockets()
		if socketUpdateTimer then
			E:CancelTimer(socketUpdateTimer)
			socketUpdateTimer = nil
		end
		if not CharacterFrame:IsShown() then
			socketDataRetry = nil
			return
		end

		ColorItemBorder()
		UpdateEquipmentInfo()

		local dataPending
		for _, slotName in ipairs(slots) do
			if S:HandleSirusEquipmentSocketInfo(_G["Character"..slotName], slots[slotName], S.EquipmentSlotAnchors[slotName], slotName) then
				dataPending = true
			end
		end

		socketDataRetry = (socketDataRetry or 0) + 1
		if dataPending and socketDataRetry < 10 then
			socketUpdateTimer = E:ScheduleTimer(UpdateCharacterEquipmentSockets, 0.2)
		else
			socketDataRetry = nil
		end
	end

	S.UpdateCharacterEquipmentSockets = UpdateCharacterEquipmentSockets

	local equipmentWatcher = CreateFrame("Frame")
	equipmentWatcher:RegisterEvent("PLAYER_EQUIPMENT_CHANGED")
	equipmentWatcher:RegisterEvent("UNIT_INVENTORY_CHANGED")
	equipmentWatcher:RegisterEvent("SOCKET_INFO_CLOSE")
	equipmentWatcher:RegisterEvent("GET_ITEM_INFO_RECEIVED")
	equipmentWatcher:RegisterEvent("UPDATE_INVENTORY_DURABILITY")
	equipmentWatcher:SetScript("OnEvent", function(_, event, unit)
		if (event == "UNIT_INVENTORY_CHANGED" and unit ~= "player") or not CharacterFrame:IsShown() then return end
		if event == "UPDATE_INVENTORY_DURABILITY" then
			if not socketUpdateTimer then UpdateEquipmentInfo() end
			return
		end
		if socketUpdateTimer then return end
		socketDataRetry = nil
		socketUpdateTimer = E:ScheduleTimer(UpdateCharacterEquipmentSockets, 0.1)
	end)

	CharacterFrame:HookScript("OnShow", UpdateCharacterEquipmentSockets)
	CharacterFrame:HookScript("OnHide", function()
		if socketUpdateTimer then
			E:CancelTimer(socketUpdateTimer)
			socketUpdateTimer = nil
		end
		socketDataRetry = nil
	end)

	local function HandleResistanceFrame(frameName)
		for i = 1, 5 do
			local frame = _G[frameName..i]
			frame:Size(24)
			frame:SetTemplate("Default")

			if i ~= 1 then
				frame:ClearAllPoints()
				frame:Point("TOP", _G[frameName..i-1], "BOTTOM", 0, -(E.Border + E.Spacing))
			end

			select(1, _G[frameName..i]:GetRegions()):SetInside()
			select(1, _G[frameName..i]:GetRegions()):SetDrawLayer("ARTWORK")
			select(2, _G[frameName..i]:GetRegions()):SetDrawLayer("OVERLAY")
		end
	end

	HandleResistanceFrame("MagicResFrame")

	select(1, MagicResFrame1:GetRegions()):SetTexCoord(0.21875, 0.8125, 0.25, 0.32421875)
	select(1, MagicResFrame2:GetRegions()):SetTexCoord(0.21875, 0.8125, 0.0234375, 0.09765625)
	select(1, MagicResFrame3:GetRegions()):SetTexCoord(0.21875, 0.8125, 0.13671875, 0.2109375)
	select(1, MagicResFrame4:GetRegions()):SetTexCoord(0.21875, 0.8125, 0.36328125, 0.4375)
	select(1, MagicResFrame5:GetRegions()):SetTexCoord(0.21875, 0.8125, 0.4765625, 0.55078125)

	PetPaperDollFrame:StripTextures(true)

	S:HandleRotateButton(PetModelFrameRotateLeftButton)
	S:HandleRotateButton(PetModelFrameRotateRightButton)
	PetModelFrameRotateRightButton:SetPoint("TOPLEFT", PetModelFrameRotateLeftButton, "TOPRIGHT", 3, 0)

	HandleResistanceFrame("PetMagicResFrame")

	select(1, PetMagicResFrame1:GetRegions()):SetTexCoord(0.21875, 0.8125, 0.25, 0.32421875)
	select(1, PetMagicResFrame2:GetRegions()):SetTexCoord(0.21875, 0.8125, 0.0234375, 0.09765625)
	select(1, PetMagicResFrame3:GetRegions()):SetTexCoord(0.21875, 0.8125, 0.13671875, 0.2109375)
	select(1, PetMagicResFrame4:GetRegions()):SetTexCoord(0.21875, 0.8125, 0.36328125, 0.4375)
	select(1, PetMagicResFrame5:GetRegions()):SetTexCoord(0.21875, 0.8125, 0.4765625, 0.55078125)

	PetPaperDollFrameExpBar:StripTextures()
	PetPaperDollFrameExpBar:SetStatusBarTexture(E.media.normTex)
	E:RegisterStatusBar(PetPaperDollFrameExpBar)
	PetPaperDollFrameExpBar:CreateBackdrop("Default")

	PetPaperDollPetInfo:SetPoint("TOPLEFT", PetModelFrameRotateLeftButton, "BOTTOMLEFT", 9, -3)
	PetPaperDollPetInfo.Icon:SetTexCoords()
	PetPaperDollPetInfo:SetFrameLevel(PetModelFrame:GetFrameLevel() + 2)
	PetPaperDollPetInfo:CreateBackdrop("Default")
	PetPaperDollPetInfo:Size(24, 24)

	ReputationFrame:StripTextures(true)

	for i = 1, NUM_FACTIONS_DISPLAYED do
		local factionRow = _G["ReputationBar"..i]
		local factionBar = _G["ReputationBar"..i.."ReputationBar"]
		local factionButton = _G["ReputationBar"..i.."ExpandOrCollapseButton"]
		local headerButton = _G["ReputationBar"..i.."HeaderButton"]

		factionRow:StripTextures(true)
		S:HandleSirusStatusBar(factionBar)

		factionButton:SetNormalTexture(E.Media.Textures.Minus)
		factionButton:GetNormalTexture():Size(15)
		factionButton:SetHighlightTexture(nil)

		if headerButton then
			if headerButton.HighlightLeft then headerButton.HighlightLeft:Kill() end
			if headerButton.HighlightRight then headerButton.HighlightRight:Kill() end
			if headerButton.HighlightMiddle then headerButton.HighlightMiddle:Kill() end
			if headerButton.Name then headerButton.Name:Kill() end

			local arrow = headerButton:CreateTexture(nil, "ARTWORK")
			arrow:Size(15)
			arrow:SetPoint("LEFT", 5, 0)
			headerButton.collapseArrow = arrow
		end
	end

	local function UpdateFaction()
		local factionOffset = FauxScrollFrame_GetOffset(ReputationListScrollFrame)
		local factionIndex, factionRow, factionButton, headerButton
		local numFactions = GetNumFactions()
		for i = 1, NUM_FACTIONS_DISPLAYED, 1 do
			factionRow = _G["ReputationBar"..i]
			factionButton = _G["ReputationBar"..i.."ExpandOrCollapseButton"]
			headerButton = _G["ReputationBar"..i.."HeaderButton"]
			factionIndex = factionOffset + i
			if factionIndex <= numFactions then
				if headerButton and headerButton:IsShown() then
					if headerButton.Left then headerButton.Left:SetTexture() end
					if headerButton.Right then headerButton.Right:SetTexture() end
					if headerButton.Middle then headerButton.Middle:SetTexture() end

					S:SetSirusCollapseIcon(headerButton, factionRow.isCollapsed)
				end

				S:SetSirusCollapseIcon(factionButton, factionRow.isCollapsed)

				local normal, pushed = factionButton:GetNormalTexture(), factionButton:GetPushedTexture()
				if normal then
					normal:SetTexCoord(0, 1, 0, 1)
					normal:Size(15)
				end
				if pushed then
					pushed:SetTexture(factionRow.isCollapsed and E.Media.Textures.Plus or E.Media.Textures.Minus)
					pushed:SetTexCoord(0, 1, 0, 1)
					pushed:Size(15)
				end
			end
		end
	end
	hooksecurefunc("ReputationFrame_Update", UpdateFaction)

	ReputationListScrollFrame:StripTextures()
	S:HandleSirusScrollBar(ReputationListScrollFrameScrollBar)

	ReputationDetailFrame:StripTextures()
	ReputationDetailFrame:SetTemplate("Transparent")

	S:HandleCloseButton(ReputationDetailCloseButton)
	ReputationDetailCloseButton:Point("TOPRIGHT", 3, 4)

	S:HandleCheckBox(ReputationDetailAtWarCheckBox)
	ReputationDetailAtWarCheckBox:SetCheckedTexture("Interface\\Buttons\\UI-CheckBox-SwordCheck")
	S:HandleCheckBox(ReputationDetailInactiveCheckBox)
	S:HandleCheckBox(ReputationDetailMainScreenCheckBox)
	S:HandleCheckBox(ReputationDetailLFGBonusReputationCheckBox)

	local flyoutFrame = _G.EquipmentFlyoutFrame
	if flyoutFrame then
		local flyoutHighlight = _G.EquipmentFlyoutFrameHighlight
		if flyoutHighlight then flyoutHighlight:StripTextures() end

		local function UpdateFlyoutLayers()
			local source = flyoutFrame.button
			if not source then return end

			local level = source:GetFrameLevel() + 10
			flyoutFrame:SetFrameStrata("HIGH")
			flyoutFrame:SetFrameLevel(level)
			local buttons = flyoutFrame.buttonFrame
			if buttons then
				buttons:SetFrameStrata("HIGH")
				buttons:SetFrameLevel(level + 1)
				buttons:EnableMouse(true)
			end
			local nav = flyoutFrame.NavigationFrame
			if nav then
				nav:SetFrameStrata("HIGH")
				nav:SetFrameLevel(level + 1)
				nav:EnableMouse(true)
				for _, button in next, { nav.PrevButton, nav.NextButton } do
					button:SetFrameStrata("HIGH")
					button:SetFrameLevel(level + 2)
				end
			end
			for _, button in next, flyoutFrame.buttons or {} do
				button:SetFrameStrata("HIGH")
				button:SetFrameLevel(level + 2)
				if button.cooldown then button.cooldown:SetFrameLevel(level + 3) end
			end
		end

		local function SkinFlyout()
			local buttons = _G.EquipmentFlyoutFrameButtons
			if buttons then
				for i = 1, buttons.numBGs or 1 do
					local bg = buttons["bg"..i]
					if bg then bg:SetAlpha(0) end
				end
				buttons:DisableDrawLayer("ARTWORK")
				if not buttons.isSkinned then
					buttons:SetTemplate("Transparent")
					buttons.isSkinned = true
				end
			end

			local navFrame = flyoutFrame.NavigationFrame
			if navFrame then
				if not navFrame.isSkinned then
					navFrame:StripTextures()
					navFrame:SetTemplate("Transparent")
					navFrame.isSkinned = true
				end
				if navFrame.PrevButton then
					S:HandleNextPrevButton(navFrame.PrevButton, "left")
				end
				if navFrame.NextButton then
					S:HandleNextPrevButton(navFrame.NextButton, "right")
				end
			end

			if flyoutFrame.buttons then
				for _, button in next, flyoutFrame.buttons do
					if button and not button.isSkinned then
						if button.NormalTexture then button.NormalTexture:SetAlpha(0) end
						if button.HighlightTexture then button.HighlightTexture:SetAlpha(0) end
						button:SetTemplate("Default", true)
						if button.icon then
							button.icon:SetTexCoords()
							button.icon:SetInside()
						end
						button.isSkinned = true
					end
				end
			end
			UpdateFlyoutLayers()
		end

		SkinFlyout()
		hooksecurefunc("EquipmentFlyout_UpdateItems", SkinFlyout)
	end
end

S:AddCallback("Skin_Character", LoadSkin)

S:AddCallbackForAddon("Blizzard_TokenUI", "Skin_Blizzard_TokenUI", function()
	if not E.private.skins.blizzard.enable or not E.private.skins.blizzard.character then return end

	TokenFrame:StripTextures(true)

	local function SkinTokenButtons()
		local scrollFrame = TokenFrameContainer
		local offset = HybridScrollFrame_GetOffset(scrollFrame)
		local buttons = scrollFrame.buttons
		local numButtons = #buttons
		local name, isHeader, isExpanded
		local button, index

		for i = 1, numButtons do
			index = offset+i
			name, isHeader, isExpanded = GetCurrencyListInfo(index)
			button = buttons[i]

			if not button.isSkinned then
				if button.HighlightLeft then button.HighlightLeft:Kill() end
				if button.HighlightRight then button.HighlightRight:Kill() end
				if button.HighlightMiddle then button.HighlightMiddle:Kill() end

				if button.HeaderButton then
					if button.HeaderButton.HighlightLeft then button.HeaderButton.HighlightLeft:Kill() end
					if button.HeaderButton.HighlightRight then button.HeaderButton.HighlightRight:Kill() end
					if button.HeaderButton.HighlightMiddle then button.HeaderButton.HighlightMiddle:Kill() end

					local arrow = button.HeaderButton:CreateTexture(nil, "ARTWORK")
					arrow:Size(15)
					arrow:SetPoint("LEFT", 5, 0)
					button.HeaderButton.collapseArrow = arrow

					if button.HeaderButton.Name then
						button.HeaderButton.Name:SetPoint("LEFT", 24, 0)
					end
				end

				button.isSkinned = true
			end

			if isHeader and button.HeaderButton then
				if button.HeaderButton.Left then button.HeaderButton.Left:SetTexture() end
				if button.HeaderButton.Right then button.HeaderButton.Right:SetTexture() end
				if button.HeaderButton.Middle then button.HeaderButton.Middle:SetTexture() end

				local arrow = button.HeaderButton.collapseArrow
				if arrow then
					S:SetSirusCollapseIcon(button.HeaderButton, not isExpanded)
				end
			end

			if name and not isHeader then
				button.icon:SetTexCoords()
			end
		end
	end
	hooksecurefunc("TokenFrame_Update", SkinTokenButtons)
	hooksecurefunc(TokenFrameContainer, "update", SkinTokenButtons)

	S:HandleSirusScrollBar(TokenFrameContainerScrollBar)

	TokenFramePopup:StripTextures()
	TokenFramePopup:SetTemplate("Transparent")

	if TokenFramePopupCloseButton then
		S:HandleCloseButton(TokenFramePopupCloseButton)
	end
	S:HandleCheckBox(TokenFramePopupInactiveCheckBox)
	S:HandleCheckBox(TokenFramePopupBackpackCheckBox)
end)
