require("XGUI_Lib")

local RepChar

local function Pass1Func(proc,channel)
	local cname=XGUI_Lib.XS.Val(channel.Name)
	XGUI.SetStatus(2,"Processing "..cname)
	cname,_=string.gsub(cname,":",RepChar)
	channel.Name=XGUI_Lib.XS.Replace(channel.Name,cname)
	return channel
	end

local function Pass1Start(proc)
	RepChar=XGUI.GetSetting(proc,"RepChar","-")
	return XGUI.OK
	end

local function Init(proc)
	XGUI.AddSetting(proc,"RepChar",XGUI.SettingType.String,"-","Character(s) to replace \":\" with")
	return XGUI.OK
	end

PostProcs.ChanColon={
	Name = "Channel Name Colon Replacer",
	Version = "1.00.00",
	Author = "Alan Birtles",
	InfoURL = "http://www.birtles.org.uk/xmltv/wiki/index.php?title=ChanColon",
	Passes={
		Pass1={
			Start=Pass1Start,
			Type=XGUI.PassTypes.Channel,
			Func=Pass1Func,
			},
		},
	Init=Init,		
	}
