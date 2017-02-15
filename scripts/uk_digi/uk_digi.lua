local XMLFile
local Grabber
require("xmltv_parse")
require("htmlentities")
local defaultURL = "http://localhost:2402/"
--local programCount
local lastProgress = -1
local channelCount
local channelsToDownload = 5

local function PCallback(prog,progress)
	prog.Start = time.GMT_BSTToUTC(prog.Start)
	prog.Stop = time.GMT_BSTToUTC(prog.Stop)
	XGUI.AddProgram(Grabber,prog)
	if lastProgress~=progress then
		XGUI.SetProgress(1,progress,XGUI.PBarMode.Pos)
		lastProgress=progress
		end
	end
	
local function CCallback(chan)
	XGUI.AddUserChannel(Grabber,chan)
	channelCount = channelCount + 1
	end
	
local function printHelp()
	print("Check the wiki for help:")
	print(Grabbers.UK_Digi.InfoURL)
	end
		
local function download(URL,sessionID,from,startDate)
	channelCount = 0
	URL = URL.."skin-DG2XML/"..sessionID.."/viewmultichannelgrid?htd=3000&dt="..startDate.."&chi="..from.."&noc="..channelsToDownload
	print("Downloading "..URL)
	XGUI.SetStatus(1,"Downloading xml ("..URL..")")
	local page,err = HTTP.Get(URL,grabber)
	if err~=200 and err~=0 then
		print("Error downloading listings ("..err..")")
		printHelp()
		return XGUI.Fail
		end	
	--print(page)
	XGUI.SetStatus(1,"Processing XML")
	page = decodeHtmlEntities(page)
	XGUI.SetProgress(1,100,XGUI.PBarMode.Max)
	XmltvParse.ParseString(page,PCallback,CCallback,true)
	return channelCount~=0
	end

local function Pass1Start(grabber)
	local URL=XGUI.GetSetting(grabber,"source",defaultURL)
	local password=XGUI.GetSetting(grabber,"password","")
	if URL=="" then
		print("URL not set for Digiguide grabber")
		printHelp()
		return XGUI.Fail
		end
	if not string.ends(URL,"/") then
		URL = URL .. "/"
		end
	print("Logging In")
	XGUI.SetStatus(1,"Logging In")
	local loginUrl, loginError = HTTP.Get(URL.."dologin?password="..password);
	if loginError~=302 then
		print("Login failed")
		--print(loginUrl)
		printHelp()
		return XGUI.Fail
		end
	local sessionIDStart = string.find(loginUrl,"/",2,true)+1
	local sessionIDEnd = string.find(loginUrl,"/",sessionIDStart,true)-1
	local sessionID = string.sub(loginUrl,sessionIDStart,sessionIDEnd)
	print("Getting start date")
	XGUI.SetStatus(1,"Getting start date")
	local startDate,err = HTTP.Get(URL.."skin-DG2XML/"..sessionID.."/index")
	if err~=200 then
		print("Failed to get index")
		printHelp()
		return XGUI.Fail
		end
	Grabber=grabber
	local channelIndex=0
	while true do 
		if download(URL,sessionID,channelIndex,startDate) then
			channelIndex = channelIndex+channelsToDownload
			else
				break
			end
		end
	return XGUI.OK
	end
		
local function Init(grabber)
	XGUI.AddSetting(grabber,"source",XGUI.SettingType.String,defaultURL,"Your Digiguide Webservice URL")
	XGUI.AddSetting(grabber,"password",XGUI.SettingType.Password,"true","Password")
	return XGUI.OK
	end
	
Grabbers.UK_Digi={
	Name = "UK - Digiguide",
	Version = "1.00.05",
	Author = "Alan Birtles",
	InfoURL = "http://www.birtles.org.uk/xmltv/wiki/index.php/UK_Digi",
	SourceURL = "http://www.digiguide.com",
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
