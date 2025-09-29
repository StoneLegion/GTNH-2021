if string.find(package.path, "dialer") == nil then
    package.path = package.path..";/dialer/?.lua"
end

package.loaded.draw = nil
package.loaded.gates = nil
package.loaded.icons = nil
package.loaded.perms = nil

local BUTTON_W = 16
local BUTTON_H = 1

component = require("component")
gpu = component.gpu
stargate = component.stargate
pInterface = component.playerinterface
pInventory = component.inventory_controller
unicode = require("unicode")
sides = require("sides")
colors = require("colors")
serial = require("serialization")

computer = require("computer")
keyboard = require("keyboard")
term = require("term")
event = require("event")
draw = require("draw")
gates = require("gates")
--icons = require("icons")
perms = require("perms")

-- prevent Hard interrupt (prevent cheating)
process = require("process")
process.info().data.signal = function(...)
end

tempTexts = {}
-- schema: {text, x, y, foreColor, backColor, ticks}
-- 'ticks' represent the number of frames/cycles before removing this text
-- EXAMPLE: table.insert(tempTexts, {text = "Hello World!", x = 24, y = 22, foreColor = 0xFFFFFF, backColor = 0x000000, ticks = 10})

term.clear()
--gpu.setResolution(120, 58)
--gpu.setResolution(68, 33)
gpu.setResolution(68, 34)
local sw, sh = gpu.getResolution()
local titleText = "Stargate Controller"
local running = true

local remoteAddress = ""

stargate.disconnect()

local registration = {}

-- Button Definitions --
local disconnect = {x = 24, y = 10, w = 42, h = 3}
local scan = {x = 24, y = 14, w = 42, h = 3}
local preview = {x = 24, y = 18, w = 42, h = 3}

function centerAlign(text)
    return (sw/2)-(string.len(text)/2)
end

function title()
    local bg = 0x82FFFF
    --border begin
    draw.rect(gpu, 1, 1, sw, 1, " ", 0x000000, bg)
    draw.text(gpu, centerAlign(titleText), 1, titleText, 0x000000, bg)
end

registration = perms.loadRegistration()
perms.saveRegistration(registration)

function itableContains(tab, search)
	for key,val in ipairs(tab) do
		if val == search then
			return true
		end
	end
	
	return false
end

-- BUTTON HANDLING --
function insideButton(mx, my, tab)
	return mx >= tab["x"] and mx < tab["x"] + tab["w"] and my >= tab["y"] and my < tab["y"] + tab["h"]
end

function handleButtons(mx, my, username)
	registration = perms.loadRegistration()
	if registration == nil then
		registration = {}
	end
	
	-- DIAL GATE --
	for i = 1, #gates["list"], 1 do
		local gate = gates["list"][i]
		
		if insideButton(mx, my, gate) then
			local tier = registration[username]
			if tier == nil then
				tier = 0
			end
			local planets = perms.getListPermittedPlanets(tier)
			
			if itableContains(planets, gate[1]) then
				stargate.dial(gate[2])
				break
			else
				table.insert(tempTexts, {text = "You aren't permitted to dial to "..gate[1].."!", x = 24, y = 23, foreColor = 0xFF2323, backColor = 0x000000, ticks = 3})
				break
			end
		end
	end
	
	-- DISCONNECT STARGATE --
	if insideButton(mx, my, disconnect) then
		stargate.disconnect()
	end
	
	-- REGISTER/SCAN USER --
	if insideButton(mx, my, scan) then
		local highestTier = perms.registerUser(username, registration)
		table.insert(tempTexts, {text = "Your highest tier rocket is Tier "..highestTier, x = 24, y = 22, foreColor = 0x16DFDF, backColor = 0x000000, ticks = 5})
	end
	
	-- PREVIEW --
	if insideButton(mx, my, preview) then
		local tier = 0
		if registration ~= nil and registration[username] ~= nil then
			tier = registration[username]
		end
		
		local planets = perms.getListPermittedPlanets(tier)
		for i = 1, #gates["list"], 1 do
			local gate = gates["list"][i]
			
			if itableContains(planets, gate[1]) then
				table.insert(tempTexts, {text = ">", x = gate["x"] - 1, y = gate["y"], foreColor = 0x23FF23, backColor = 0x000000, ticks = 5})
				table.insert(tempTexts, {text = "<", x = gate["x"] + gate["w"], y = gate["y"], foreColor = 0x23FF23, backColor = 0x000000, ticks = 5})
			else
				table.insert(tempTexts, {text = ">", x = gate["x"] - 1, y = gate["y"], foreColor = 0xFF2323, backColor = 0x000000, ticks = 5})
				table.insert(tempTexts, {text = "<", x = gate["x"] + gate["w"], y = gate["y"], foreColor = 0xFF2323, backColor = 0x000000, ticks = 5})
			end
		end
	end
end

while running do
    title()
	
	-- INSTRUCTIONS (SOME TEMPORARY) --
	draw.text(gpu, 5, 3, "Gate Selection", 0xFF00FF, 0x000000)
	
	draw.button(
		gpu,
		"Shutdown Stargate",
		disconnect["x"], disconnect["y"],
		disconnect["w"], disconnect["h"],
		0xFFFFFF,
		0x882222
	)
	draw.button(
		gpu,
		" Scan Inventory for Rockets ",
		scan["x"], scan["y"],
		scan["w"], scan["h"],
		0xFFFFFF,
		0x00DDDD
	)
	draw.button(
		gpu,
		" Preview Available Gates ",
		preview["x"], preview["y"],
		preview["w"], preview["h"],
		0xFFFFFF,
		0x11DD11
	)
	
	-- GATE BUTTON RENDERING --
	for i = 1, #gates["list"], 1 do
		local x = 4
		local y = 3 + (i - 1) + BUTTON_H
		
		gates["list"][i]["x"] = x
		gates["list"][i]["y"] = y
		
		gates["list"][i]["w"] = BUTTON_W
		gates["list"][i]["h"] = BUTTON_H
		
		local color = 0
		if i % 2 == 0 then
			color = 0x888899
		else
			color = 0x787878
		end
		
		draw.button(
			gpu,
			gates["list"][i][1],
			gates["list"][i]["x"], gates["list"][i]["y"],
			gates["list"][i]["w"], gates["list"][i]["h"],
			0xFFFFFF,
			color
		)
	end
	
	-- STATUS SCREEN --
	local state, engaged, direction = stargate.stargateState()
	if state == "Closing" or state == "Idle" then
		remoteAddress = ""
	end
	
	local wStatus = 41
	local xStatus = sw - wStatus - 3
	local yStatus = 3
	draw.border(unicode, gpu, "Stargate Status", xStatus, yStatus, wStatus, 6, 0xDDDD00, 0x000000)
	draw.text(gpu, xStatus + 2, yStatus + 1, "Local Address:    "..stargate.localAddress(), 0xFFFFFF, 0x000000)
	draw.text(gpu, xStatus + 2, yStatus + 2, "Remote Address:   "..remoteAddress.."          ", 0xFFFFFF, 0x000000)
	draw.text(gpu, xStatus + 2, yStatus + 3, "Gate State:       "..state.."          ", 0xFFFFFF, 0x000000)
	draw.text(gpu, xStatus + 2, yStatus + 4, "Direction:        "..direction.."          ", 0xFFFFFF, 0x000000)
	draw.text(gpu, xStatus + 2, yStatus + 5, "Chevrons Encoded: "..engaged.."   ", 0xFFFFFF, 0x000000)
	
	-- UPDATE AND RENDER TEMPORARY TEXT --
	for i = #tempTexts, 1, -1 do
		tempTexts[i].ticks = tempTexts[i].ticks - 1
		textTab = tempTexts[i]
		if textTab.ticks < 0 then
			draw.text(gpu, textTab.x, textTab.y, textTab.text, textTab.backColor, textTab.backColor)
			table.remove(tempTexts, i)
		else
			draw.text(gpu, textTab.x, textTab.y, textTab.text, textTab.foreColor, textTab.backColor)
		end
	end
	
	-- EVENT HANDLING --
    local v1,v2,v3,v4,v5,v6 = event.pull(1.0)
	if v1 == "touch" then
		handleButtons(v3, v4, v6)
	end
	
	if v1 == "sgDialIn" or v1 == "sgDialOut" then
		remoteAddress = v3
	end
	
	os.sleep(0.1)
end

term.clear()