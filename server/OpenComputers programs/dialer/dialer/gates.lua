local gates = {
    list = {
		{"Moon", "L998-NVC-PN"},
		
		{"Mars", "L998-NVC-F3"},
		{"Phobos", "FFFK-ZPU-O3"},
		{"Deimos", "1FFD-SP7-ZF"},
		
		{"Ceres", "T939-U1G-AU"},
		{"Asteroids", "644C-30C-M8"},
		{"Callisto", "9992-HVO-EO"},
		{"Ganymede", "V99V-AVV-TE"},
		{"Europa", "V99V-AVV-2Y"},
        {"Ross128b", "1FF1-APJ-RA"},
		
		{"Io", "H999-OVA-BP"},
		{"Venus", "9992-HVO-2Y"},
		{"Mercury", "H999-OVA-16"},
		
		{"Oberon", "9992-HVO-0R"},
		{"Miranda", "9992-HVO-AA"},
		{"Titan", "L998-NVC-QF"},
		{"Enceladus", "H999-OVA-I2"},
		{"Ross128ba", "H999-OVA-K9"},
		
		{"Triton", "9992-HVO-HN"},
		{"Proteus", "9992-HVO-Q7"},
		
		{"Kuiper Belt", "9992-HVO-FG"},
		{"Haumea", "L998-NVC-45"},
		{"Pluto", "9992-HVO-74"},
		{"Makemake", "9992-HVO-O0"},
		
		{"A Centauri Bb", "9992-HVO-5X"},
		{"Tau Ceti E", "9992-HVO-WD"},
		{"Vega B", "9992-HVO-MT"},
		{"Barnarda C", "9992-HVO-C9"},
		{"Barnarda E", "9992-HVO-3Q"},
		{"Barnarda F", "H999-OVA-JU"},
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