local XMLFile
local Grabber
require("xmltv_parse")

local function PCallback(prog)
	XGUI.AddProgram(Grabber,prog)
	end
	
local function CCallback(chan)
	XGUI.AddUserChannel(Grabber,chan)
	end

local function Pass1Start(grabber)
	local URL=XGUI.GetSetting(grabber,"source","")
	local UseCache=toboolean(XGUI.GetSetting(grabber,"UseCache",true))
	if URL=="" then
		print("URL not set for ONTV grabber")
		return XGUI.Fail
		end
	print("Downloading "..URL)
	XGUI.SetStatus(1,"Downloading xml ("..URL..")")
	local cacheid=nil
	local cachemaxdays=nil
	if UseCache then
	   cacheid=hash(URL)
	   cachemaxdays=1
	   end
	local page,err = HTTP.Get(URL,grabber,_,_,cacheid,cachemaxdays)
	if err~=200 and err~=0 then
		print("Error downloading listings ("..err..")")
		return XGUI.Fail
		end	
	Grabber=grabber
	print("Processing XML")
	XGUI.SetStatus(1,"Processing XML")
	XmltvParse.ParseString(page,PCallback,CCallback)
	return XGUI.OK
	end
	
local function Init(grabber)
	XGUI.AddSetting(grabber,"source",XGUI.SettingType.String,"","Your unique ONTV URL")
	XGUI.AddSetting(grabber,"UseCache",XGUI.SettingType.Boolean,"true","Use Cache")
	return XGUI.OK
	end
	
Grabbers.DK_ONTV={
	Name = "DK - ONTV",
	Version = "1.01.00",
	Author = "Alan Birtles",
	InfoURL = "http://www.birtles.org.uk/xmltv/wiki/index.php/Dk_ontv",
	SourceURL = "http://ontv.dk",
	Encoding = XGUI.Encoding.UTF8,
	NoUserChannels = true,
	Passes={
		Pass1={
			Type=XGUI.PassTypes.None,
			Start=Pass1Start,
			},
		},
	Init=Init,
	}
