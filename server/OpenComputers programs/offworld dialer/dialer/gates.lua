local gates = {
    list = {
		{"OW North West", "K4ZP-MSS-DM"},
		{"OW North East", "G4YP-QVU-7C"},
		{"OW South West", "FFVV-KED-05"},
		{"OW South East", "2AAO-VV2-2Y"},
	}
}

function gates.getGateByName(name)
    for i = 1, #gates["list"], 1 do
        if gates["list"][i][1] == name then return gates["list"][i] end
    end
    return nil
end

function gates.getGateByAddress(addr)
	for i = 1, #gates["list"], 1 do
        if gates["list"][i][2] == addr then return gates["list"][i] end
    end
    return nil
end

return gates