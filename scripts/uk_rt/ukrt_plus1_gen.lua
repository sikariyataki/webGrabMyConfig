local channels={}
local grabber

local availablechannels={
		{name="More4+1",offset=1,id="1959"},
		{name="FX+2",offset=2,id="1461"},
		{name="Paramount Comedy+1",offset=1,id="1061"},
		{name="ITV2 +1",offset=1,id="185"},
		{name="ITV3 +1",offset=1,id="1859"},
		{name="Sci-Fi +1",offset=1,id="244"},
		{name="UKTV Drama +1",offset=1,id="292"},
		{name="Zone Reality +1",offset=1,id="746"},
		{name="Channel 4 +1",offset=1,id="132"},
		{name="Virgin 1+1",offset=1,id="2049"},
		{name="Dave ja vu",offset=1,id="2050"},
 		}

require("timezones")
require("XGUI_Lib")

local function Pass1Func(proc,program)
	local dst,starthour,stophour
	local i,n
	XGUI.SetStatus(2,"Processing "..XGUI_Lib.XS.Val(program.Title))
	n=table.getn(channels)
	for i=1,n do
		if program.Channel==channels[i].id then
			local p2
			p2=table.copy(program)
			p2.Channel=p2.Channel.."+"..channels[i].offset
			p2.Start.Hour=p2.Start.Hour+channels[i].offset
			p2.Start=time.Fix(p2.Start)
			p2.Stop.Hour=p2.Stop.Hour+channels[i].offset
			p2.Stop=time.Fix(p2.Stop)
			XGUI.AddProgram(grabber,p2)
			end
		end
	return program
	end

local function Start(proc)
	grabber=XGUI.GetGrabber("UK_RT")
	channels={}
	local i,n
	n=table.getn(availablechannels)
	for i=1,n do
		if toboolean(XGUI.GetSetting(proc,availablechannels[i].name,"false")) then
			table.insert(channels,{id=availablechannels[i].id,offset=availablechannels[i].offset})
			end
		end
	--[[if toboolean(XGUI.GetSetting(proc,"More4+1","false")) then
		table.insert(channels,{id="1959",offset=1})
		end]]
	n=table.getn(channels)
	for i=1,n do
		local ch
		ch=XGUI.GetChannel(grabber,channels[i].id)
		if ch then
			ch.ID=channels[i].id.."+"..channels[i].offset
			ch.Name=XGUI_Lib.XS.Cat(ch.Name,"+"..channels[i].offset)
			XGUI.AddUserChannel(grabber,ch)
			end
		end
	end

local function Init(proc)
	local i,n
	n=table.getn(availablechannels)
	for i=1,n do
		XGUI.AddSetting(proc,availablechannels[i].name,XGUI.SettingType.Boolean,"false",availablechannels[i].name)
		end
	return XGUI.OK
	end

	
PostProcs.UK_RT_Plus_One={
	Name = "UK - Radio Times Plus one generator",
	Version = "1.01.01",
	Author = "Alan Birtles",
	InfoURL = "http://www.birtles.org.uk/xmltv/wiki/index.php?title=UK_RT_Plus_One",
	Grabber = "UK_RT",
	Passes={
		Pass1={
			Type=XGUI.PassTypes.Program,
			Func=Pass1Func,
			Start=Start,
			},
		},
	Init=Init,
	}
