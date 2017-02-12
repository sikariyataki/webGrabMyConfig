require ("zip");
require ("lxp");
require ("xmltv_parse")

local prog
local chan
local tag
local data
local grab
local lang
local UseCache

local ListingsURL="http://www.bleb.org/tv/data/listings?days=0..%d&format=XMLTV&channels=%s&file=zip"
local ChannelsURL="http://www.bleb.org/tv/data/listings/0/"
local Grabber

local function DownloadData(grabber, channelList, days, programCallback, channelCallback)
	local cacheid=nil
	local cahcemaxdays=nil
	if UseCache then
	   cacheid=hash(channelList).."_"..days
	   cachemaxdays=1
	   end
	local page,err = XGUI.Get(string.format(ListingsURL,days-1,channelList),grabber,_,_,cacheid,cachemaxdays)
	if (err<400)and(err~=-1) then
			local tmp=string.format("%s%s.zip",TEMP,hash(channelList))
			local file=io.open(tmp,"wb")
			file:write(page);
			file:close();
			local zf=zip.open(tmp)
			file=zf:open("data.xml")
			XmltvParse.ParseFile(file, programCallback, channelCallback)
			return XGUI.OK	
		else
			return XGUI.Fail
		end
	end

local channelList
local channelFiles
local channelFilesIndex
local MaxDays
local Grabber
	
local function programCallback(prog)
	XGUI.AddProgram(Grabber,prog)
	end

local function channelCallback(chan)
	local url = channelFiles[channelFilesIndex]
	chan.URL = XGUI_Lib.XS.Add(chan.URL,url)
	channelFilesIndex = channelFilesIndex + 1;
	XGUI.AddChannel(Grabber,chan)
	--print(chan.ID)
	--print(url)
	end
	
local function Pass1End(grabber)
	if not MaxDays then
		--no channels to download
		return XGUI.OK
		end
	if MaxDays==0 then MaxDays=7
		end
	XGUI.SetStatus(2,"Downloading Data")
	Grabber = grabber
	if DownloadData(grabber,channelList,MaxDays,programCallback,nil) ~= XGUI.OK then
		return XGUI.Fail
		end

	print("   Clearing cache")
	XGUI.CleanCache(grabber,1);
	return XGUI.OK
	end
	
local function Pass1Func(grabber,channel,maxdays)
	if not channel.URL then
		print("Please refresh your channel list")
		return XGUI.Fail
		end
	local url
	if istable(channel.URL) then
		url = channel.URL[table.getn(channel.URL)]
		else
			url = channel.URL
		end
	channelList = channelList..url..","
	MaxDays = maxdays
	return XGUI.OK
	end

local function Pass1Start(grabber)
	UseCache=toboolean(XGUI.GetSetting(grabber,"UseCache",true))
	channelList = ""
	return XGUI.OK
	end

local function Init(grabber)
	XGUI.AddSetting(grabber,"UseCache",XGUI.SettingType.Boolean,"true","Use Cache")
	end
	
local function RefChans(grabber)
	Grabber = grabber
	local page,err = XGUI.Get(ChannelsURL,grabber)
	if (err<400)and(err~=-1) then
		print ("File List Downloaded")
		local files = ""
		local file
		XGUI.SetStatus(1,"Getting channel list")	
		local numChannels = 0;
		channelFiles = {}
		channelFilesIndex = 1
		for file in string.gfind(page,"<a href=\"([%w%._%-!£%$%%%^&()=%+%[%]{}@#~]+).xml\">") do
			files = files .. file .. ","
			table.insert(channelFiles, file)
			numChannels = numChannels + 1
			--print("Found :"..file)
			end
		print("Found "..numChannels.." channels")
		XGUI.ClearChannels(grabber)
		if DownloadData(grabber,files,1,nil,channelCallback) ~= XGUI.OK then
			return XGUI.Fail
			end		
		return XGUI.OK
		else 
			print("Couldn't download channels")
			return XGUI.Fail
		end
	end

Grabbers.UK_Bleb={
	Name = "UK - Bleb",
	Version = "2.00.01",
	Encoding = XGUI.Encoding.UTF8,
	Author = "Alan Birtles",
	InfoURL = "http://www.birtles.org.uk/xmltv/wiki/index.php/Bleb",
	SourceURL = "http://www.bleb.org/tv",
	Passes={
		Pass1={
			Type=XGUI.PassTypes.Channel,
			Start=Pass1Start,
			End=Pass1End,
			Func=Pass1Func,
			},
		},
	RefreshChannels=RefChans,
	Init=Init,		
	}
