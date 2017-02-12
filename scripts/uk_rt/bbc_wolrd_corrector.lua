local channels={}
local grabber

local bbcWorldChannel = "90"

require("timezones")
require("XGUI_Lib")

local function Pass1Func(proc,program)
	local dst,starthour,stophour
	local i,n
	XGUI.SetStatus(2,"Processing "..XGUI_Lib.XS.Val(program.Title))
	if program.Channel==bbcWorldChannel then
		program.Start.Hour=program.Start.Hour-1
		program.Start=time.Fix(program.Start)
		program.Stop.Hour=program.Stop.Hour-1
		program.Stop=time.Fix(program.Stop)
		end
	return program
	end

	
PostProcs.UK_RT_BBC_World_Fix={
	Name = "UK - BBC World timezone fix",
	Version = "1.00.00",
	Author = "Alan Birtles",
	InfoURL = "http://www.birtles.org.uk/xmltv/wiki/index.php?title=UK_RT_BBC_World_Fix",
	Grabber = "UK_RT",
	Passes={
		Pass1={
			Type=XGUI.PassTypes.Program,
			Func=Pass1Func,
			},
		},
	}
