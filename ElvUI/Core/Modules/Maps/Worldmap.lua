local E, L, V, P, G = unpack(ElvUI)
local M = E:GetModule('WorldMap')

local _G = _G
local find = string.find
local next = next

local C_Map = C_Map
local CreateFrame = CreateFrame

local MOUSE_LABEL = MOUSE_LABEL
local PLAYER = PLAYER

local INVERTED_POINTS = {
	['TOPLEFT'] = 'BOTTOMLEFT',
	['TOPRIGHT'] = 'BOTTOMRIGHT',
	['BOTTOMLEFT'] = 'TOPLEFT',
	['BOTTOMRIGHT'] = 'TOPRIGHT',
	['TOP'] = 'BOTTOM',
	['BOTTOM'] = 'TOP'
}

function M:UpdateCoords(elapsed)
	M.coordTimer = (M.coordTimer or 0) + elapsed
	if M.coordTimer < 0.03333 then return end
	M.coordTimer = 0

	local map = _G.WorldMapFrame
	local playerCoords = M.coordsHolder.playerCoords
	local mouseCoords = M.coordsHolder.mouseCoords

	local x, y
	local position = C_Map.GetPlayerMapPosition(map:GetMapID(), 'player')
	if position then
		x, y = position:GetXY()
	end

	if playerCoords.x ~= x or playerCoords.y ~= y then
		playerCoords.x, playerCoords.y = x, y

		if x then
			playerCoords:SetFormattedText('%s:   %.2f, %.2f', PLAYER, x * 100, y * 100)
		else
			playerCoords:SetFormattedText('%s:   %s', PLAYER, 'N/A')
		end
	end

	if map:IsCanvasMouseFocusOrPinFocus() then
		local curX, curY = map:GetNormalizedCursorPosition()

		if mouseCoords.x ~= curX or mouseCoords.y ~= curY then
			mouseCoords.x, mouseCoords.y = curX, curY
			mouseCoords:SetFormattedText('%s:  %.2f, %.2f', MOUSE_LABEL, curX * 100, curY * 100)
		end
	elseif mouseCoords.x then
		mouseCoords.x, mouseCoords.y = nil, nil
		mouseCoords:SetText('')
	end
end

function M:PositionCoords()
	if not M.coordsHolder then return end

	local db = E.global.general.WorldMapCoordinates
	local position = db.position

	local x = find(position, 'RIGHT') and -5 or 5
	local y = find(position, 'TOP') and -5 or 5

	M.coordsHolder.playerCoords:ClearAllPoints()
	M.coordsHolder.playerCoords:Point(position, M.coordsHolder, position, x + db.xOffset, y + db.yOffset)

	M.coordsHolder.mouseCoords:ClearAllPoints()
	M.coordsHolder.mouseCoords:Point(position, M.coordsHolder.playerCoords, INVERTED_POINTS[position], 0, y)
end

local function MapShouldFade()
	return not _G.WorldMapFrame:IsMouseOver()
end

function M:UpdateMapFade(onShow)
	local map = _G.WorldMapFrame
	if not map:IsShown() then return end

	local fader = _G.PlayerMovementFrameFader
	if E.global.general.fadeMapWhenMoving then
		local addFrame = onShow and fader.AddDeferredFrame or fader.AddFrame
		addFrame(map, E.global.general.mapAlphaWhenMoving, 1, nil, MapShouldFade)
	else
		fader.RemoveFrame(map)
	end
end

local function MapOnShow()
	M:UpdateMapFade(true)
end

function M:Initialize()
	M.Initialized = true

	if not E.private.worldmap.enable then return end

	local map = _G.WorldMapFrame

	map:HookScript('OnShow', MapOnShow)

	if E.global.general.WorldMapCoordinates.enable then
		local coordsHolder = CreateFrame('Frame', 'ElvUI_CoordsHolder', map)
		coordsHolder:SetAllPoints(map.ScrollContainer)
		coordsHolder:SetFrameStrata('HIGH')
		coordsHolder:SetFrameLevel(map.BorderFrame:GetFrameLevel() + 10)

		coordsHolder.playerCoords = coordsHolder:CreateFontString(nil, 'OVERLAY')
		coordsHolder.playerCoords:SetTextColor(1, 1, 0)
		coordsHolder.playerCoords:SetFontObject(NumberFontNormal)
		coordsHolder.playerCoords:SetFormattedText('%s:   %s', PLAYER, 'N/A')

		coordsHolder.mouseCoords = coordsHolder:CreateFontString(nil, 'OVERLAY')
		coordsHolder.mouseCoords:SetTextColor(1, 1, 0)
		coordsHolder.mouseCoords:SetFontObject(NumberFontNormal)

		coordsHolder:SetScript('OnUpdate', M.UpdateCoords)

		M.coordsHolder = coordsHolder
		M:PositionCoords()

		for _, frame in next, map.overlayFrames do
			if frame.CursorCoords and frame.PlayerCoords then
				frame:Hide()
				break
			end
		end
	end
end

E:RegisterModule(M:GetName())
