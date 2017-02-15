local ChannelsURL="http://xmltv.radiotimes.com/xmltv/channels.dat"
local ListingsURL="http://xmltv.radiotimes.com/xmltv/%d.dat"
local IgnoreTBA
local UseCache
local EmptyChannels
local GoodChannels

local function stripNotice(page, fieldSeparator)
	if page==nil then
		return page
		end
	local firstSeparator = string.find(page,fieldSeparator,nil,true);
	if firstSeparator == nil then
		page=nil;
		else
			local dataStart = 0;
			while true do
				local line = string.find(page,"\n",dataStart,true);
				if line==nil or line > firstSeparator then
					break;
					end
				dataStart = line+1;
				end
			page = string.sub(page,dataStart)
			end
	return page
	end

local function Pass1Func(grabber,channel,maxdays)
	XGUI.SetStatus(2,"Downloading "..channel.Name.Value);
	local cacheid=nil
	local cachemaxdays=nil
	if UseCache then
	   cacheid=channel.ID
	   cachemaxdays=1
	   end
	local page,err = XGUI.Get(string.format(ListingsURL,channel.ID),grabber,_,_,cacheid,cachemaxdays)
	if (err<400)and(err~=-1) then
		page = stripNotice(page,"~")
		if (page=="")or(page==nil)or(page==" ") then 
			print(string.format("   Radio Times returned a zero sized reply for channel %s",channel.Name.Value))
			if UseCache then
				HTTP.DeleteCache(grabber, cacheid)
				end
			EmptyChannels = EmptyChannels + 1
			else 
				UK_RT.ProcessPrograms(grabber,channel.ID,page,IgnoreTBA)
				GoodChannels = GoodChannels + 1
			end
		return XGUI.OK
		else
			if err==404 then
				print("   Channel \""..channel.Name.Value.."\" not found")
				return XGUI.OK
				else
					return XGUI.Fail
				end
		end
	end

local function Pass1Start(grabber)
	print ("   Please note that all data downloaded with this grabber is copyright of the Radio Times website (http://www.radiotimes.com) and the use of the data is restricted to personal use only. Also be aware that this service may not remain free and in future may become a paid-for service")
	IgnoreTBA=toboolean(XGUI.GetSetting(grabber,"IgnoreTBA",true))
	UseCache=toboolean(XGUI.GetSetting(grabber,"UseCache",true))
	EmptyChannels = 0
	GoodChannels = 0
	return XGUI.OK
	end

local function Pass1End(grabber)
	print("   Clearing cache")
	XGUI.CleanCache(grabber,1);
	print("   "..(GoodChannels).." / "..(EmptyChannels + GoodChannels).." channels downloaded")
	if (EmptyChannels > GoodChannels) then
		print("   Aborting");
		return XGUI.Fail
		end
	return XGUI.OK
	end
	
local function RefChans(grabber)
	local page,err = XGUI.Get(ChannelsURL,grabber)
	if (err<400)and(err~=-1) then
		page = stripNotice(page,"|")
		print ("Channels Downloaded")
		XGUI.ClearChannels(grabber)
		print ("Channels Cleared")
		UK_RT.ProcessChannels(grabber,page)
		print ("Channels Processed")
		return XGUI.OK
		else 
			print("Couldn't download channels")
			return XGUI.Fail
		end
	end
	
local function Init(grabber)
	XGUI.AddSetting(grabber,"IgnoreTBA",XGUI.SettingType.Boolean,"true","Ignore TBA Programs")
	XGUI.AddSetting(grabber,"UseCache",XGUI.SettingType.Boolean,"true","Use Cache")
	return XGUI.OK
	end
	
Grabbers.UK_RT={
	Name = "UK - Radio Times",
	Version = "2.22.00",
	Author = "Alan Birtles",
	InfoURL = "http://www.birtles.org.uk/xmltv/wiki/index.php/Radio_Times",
	SourceURL = "http://www.radiotimes.com",
	Encoding = XGUI.Encoding.UTF8,
	Passes={
		Pass1={
			Type=XGUI.PassTypes.Channel,
			Func=Pass1Func,
			Start=Pass1Start,
			End=Pass1End,
			},
		},
	RefreshChannels=RefChans,
	Init=Init,
	}
