local channels={
		{id="1856",start=6,stop=18},
		{id="2049+1",start=18,stop=6}
		}

require("timezones")

local function Pass1Func(proc,program)
	local dst,starthour,stophour
	local i,n
	XGUI.SetStatus(2,"Processing "..XGUI_Lib.XS.Val(program.Title))
	dst=time.IsEUDST(program.Start)
	if dst then
		starthour=program.Start.Hour+1
		stophour=program.Stop.Hour+1
		else 
			starthour=program.Start.Hour
			stophour=program.Stop.Hour
			end
	n=table.getn(channels)
	for i=1,n do
		if program.Channel==channels[i].id then
			local start1=channels[i].start
			local stop1=channels[i].stop
			if start1<stop1 then
				if (((starthour>=start1)and(stophour<stop1))
					or((stophour==stop1)and(program.Stop.Minute==0)))
					and((stop1==0)or(stophour>=starthour)) then 
						return program
						else return XGUI.OK
						end
				else
				if (starthour>=start1)
					or (stophour<stop1)
					or ((stophour==stop1)and(program.Stop.Minute==0))then 
						return program
						else return XGUI.OK
						end				
				end
			end
		end
	return program
	end

PostProcs.UK_RT_Free_Limit={
	Name = "UK - Radio Times freeview channel time limiter",
	Version = "1.00.01",
	Author = "Alan Birtles",
	InfoURL = "http://www.birtles.org.uk/xmltv/wiki/index.php?title=UK_RT_Free_Limit",
	Grabber = "UK_RT",
	Passes={
		Pass1={
			Type=XGUI.PassTypes.Program,
			Func=Pass1Func,
			},
		},
	}
