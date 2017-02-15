local channels

local function Pass1Func(grabber,channel)
	XGUI.SetStatus(2,"Processing "..channel.Name.Value)
	channel.XML_ID=channels[channel.ID]
	return channel
	end

local function Start(grabber)
	local fn=XGUI.GetSetting(grabber,"FileName","altchids.txt")
	local line
	local first=true
	channels={}
	for line in io.lines(fn) do
		local id,alt
		for id,alt in string.gfind(line,"(.-)%s+(.+)") do
			if not first then
				print(string.format("'%s' --- '%s'",id,alt))
				channels[id]=alt
				else first=false
				end
			end
		end
	return XGUI.OK
	end

local function Init(grabber)
	XGUI.AddSetting(grabber,"FileName",XGUI.SettingType.Directory,"altchids.txt","Channel ids file")
	return XGUI.OK
	end
	
PostProcs.UK_RT_ALT_Text={
	Name = "UK - Radio Times - Text Altchids reader",
	Version = "1.00.00",
	Author = "Alan Birtles",
	InfoURL = "http://www.birtles.org.uk/xmltv/wiki/index.php?title=UK_RT_Alt_Text",
	Grabber = "UK_RT",
	Init=Init,
	Passes={
		Pass1={
			Start=Start,
			Type=XGUI.PassTypes.Channel,
			Func=Pass1Func,
			},
		},
	}
