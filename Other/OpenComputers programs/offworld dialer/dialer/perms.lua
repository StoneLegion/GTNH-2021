local perms = {}

function perms.getListPermittedPlanets(tier)
	local list = {}
	if tier <= 0 then
		return list
	end
	
	if tier >= 1 then
		table.insert(list, "OW North West")
		table.insert(list, "OW North East")
		table.insert(list, "OW South West")
		table.insert(list, "OW South East")
	end
	
	return list
end

function perms.matchRocket(stack)
	if stack == nil or stack["label"] == nil or stack["label"] == "" then
		return -1
	end
	
	local label = stack["label"]
	local name = stack["name"]
	if string.len(label) == 13 and string.find(label, " Rocket") ~= nil and string.find(label, "Tier ") ~= nil and ((string.find(name, "Tier") ~= nil and string.find(name, "Rocket") ~= nil) or string.find(name, "GalacticraftCore:item.spaceship") ~= nil or string.find(name, "GalacticraftMars:item.spaceship") ~= nil) then
		local s,e = string.find(label, "Tier ")
		local text = string.sub(label, e + 1, e + 1)
		if tonumber(text) ~= nil then
			return tonumber(text)
		end
	end
	
	return -2
end

function perms.loadRegistration()
	local file = io.open("/dialer/registration.txt", "r")
	if file ~= nil then
		local text = file:read("*a")
		file:close()
		
		if text ~= nil and text ~= '' then
			local tab = serial.unserialize(text)
			if tab ~= nil and type(tab) == "table" then
				return tab
			end
		end
	end
	
	return {}
end

function perms.saveRegistration(tab)
	local t = tab
	if t == nil then
		t = {}
	end
	
	local file = io.open("/dialer/registration.txt", "w")
	file:write(serial.serialize(t))
	file:close()
end

function perms.registerUser(username, registration)
	local tab = registration
	if tab == nil then
		tab = {}
	end
	
	pInterface.setPlayerName(username)
	os.sleep(1.0)
	local side = sides.west
	local size = pInventory.getInventorySize(side)
	if size > 36 then
		size = 36
	end
	
	if size ~= nil and size > 0 then
		for i = 1, size, 1 do
			local stack = pInventory.getStackInSlot(side, i)
			local flag = perms.matchRocket(stack)
			if flag > 0 then
				local curReg = tab[username]
				if curReg == nil then
					tab[username] = flag
				else
					if curReg < flag then -- don't want to go backward
						tab[username] = flag
					end
				end
			end
		end
	end
	
	perms.saveRegistration(tab)
	
	if tab[username] ~= nil then
		return tab[username]
	end
	
	return 0
end

return perms