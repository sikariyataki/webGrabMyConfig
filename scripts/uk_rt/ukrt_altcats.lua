require("XGUI_Lib")

--map from category name to another one
local CatRemap={
		{From="Film",To="Movie"},
		}

--change category of specific programs on specific channels
local ChanCatRemap={
		{Channels={"92"},Map={
			{Progs={"EastEnders"},Cat="Soap"},
			{Progs={"Planet Earth"},Cat="Documentary, Nature"},
			}
		},
		{Channels={"1959","1972"},Map={
			{Progs={"Curb Your Enthusiasm"},Cat="Sitcom"},
			}
		},
	}

local function Pass1Func(proc,program)
	local chid,cat,name,i,j,k,n,m,o,chanmatch
	XGUI.SetStatus(2,"Processing "..XGUI_Lib.XS.Val(program.Title))
	chid=program.Channel
	if program.Category then
		cat=XGUI_Lib.XS.Val(program.Category)
		else 
			cat="No Category"	
		end
	if program.Title then
		name=XGUI_Lib.XS.Val(program.Title)
		else 
			name="No Name"	
		end
	n=table.getn(CatRemap)
	for i=1,n do
		if cat==CatRemap[i].From then
			program.Category=XGUI_Lib.XS.Add(CatRemap[i].To,program.Category)
			return program
			end
		end
	n=table.getn(ChanCatRemap)
	for i=1,n do
		chanmatch=false
		m=table.getn(ChanCatRemap[i].Channels)
		for j=1,m do
			if ChanCatRemap[i].Channels[j]==chid then
				chanmatch=true
				break
				end
			end
		if chanmatch then
			m=table.getn(ChanCatRemap[i].Map)
			for j=1,m do
				o=table.getn(ChanCatRemap[i].Map[j].Progs)
				for k=1,m do
					if name==ChanCatRemap[i].Map[j].Progs[k] then
						program.Category=XGUI_Lib.XS.Add(ChanCatRemap[i].Map[j].Cat,program.Category)
						return program
						end
					end
				end
			end
		end
	return program
	end

PostProcs.UK_RT_Alt_Cat={
	Name = "UK - Radio Times Category Mapper",
	Version = "1.00.00",
	Author = "Alan Birtles",
	InfoURL = "http://www.birtles.org.uk/xmltv/wiki/index.php?title=UK_RT_Alt_Cat",
	Grabber = "UK_RT",
	Passes={
		Pass1={
			Type=XGUI.PassTypes.Program,
			Func=Pass1Func,
			},
		},
	}
