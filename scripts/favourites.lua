require("XGUI_Lib")
require("timezones")

local channels
local programs
local fav_progs
local outputfiles

local function TrimWhiteSpace(str)
	local s1,s2
	for s1 in string.gfind(str,"%s*(.*)") do
		s2=s1
		break
		end
	for s1 in string.gfind(s2,"(.-)%s*$") do
		return s1
		end
	end
	
local function GetChannelsPass(proc,channel)
	table.insert(channels,channel)
	return channel
	end

local function ProgramsPass(proc,program)
	local i,pat
	local title = XGUI_Lib.XS.Val(program.Title)
	XGUI.SetStatus(2,"Processing "..title)
	title = string.lower(TrimWhiteSpace(title))
	local titlelen = string.len(title)
	for i,pat in ipairs(fav_progs) do		
		local strstart,strend = string.find(title,pat)
		if (strstart==1) and (strend==titlelen) then
			table.insert(programs,program)
			break
			end
		end
	return program
	end

local function ParseFavProgsString(FavProgsString)
	fav_progs={}
	if FavProgsString == "" then
		return
		end
	for FavProg in string.gfind(FavProgsString, "[^;]+") do
		table.insert(fav_progs,TrimWhiteSpace(FavProg))
		end
	end

local function GetChannelsPassStart(proc)
	ParseFavProgsString(XGUI.GetSetting(proc,"FavProgsString",""))
	outputfiles = XGUI.GetSetting(proc,"OutputFile","")..";"
	channels = {}
	programs = {}
	return XGUI.OK
	end
	
local function ComparePrograms(program1,program2)
	return time.comp(program1.Start,program2.Start)==time.less;
	end
	
local function WriteFavourites()
	table.sort(programs,ComparePrograms)
	local ChannelNames ={}
	local i,channel,program
	for i,channel in ipairs(channels) do
		ChannelNames[channel.ID] = XGUI_Lib.XS.Val(channel.Name)
		end
	for file in string.gfind(outputfiles,"(.-);") do
		if file~="" then
			local output, err = io.open(file,"w")
			if output==nil then
				print("Could not open file - "..err)
				return XGUI.Fail
				end
			for i,program in ipairs(programs) do
				output:write(string.format("%s at %s on %s\n",XGUI_Lib.XS.Val(program.Title),time.DateTimeToStr(program.Start),ChannelNames[program.Channel]))
				end
			output:close()
			end
		end
	end

local function Init(proc)
	XGUI.AddSetting(proc,"FavProgsString",XGUI.SettingType.String,"","Favourite Programs Patterns. Seperate Patterns with ';'")
	XGUI.AddSetting(proc,"OutputFile",XGUI.SettingType.File,"","Output File")
	return XGUI.OK
	end

PostProcs.Favourites={
	Name = "Favourites",
	Version = "1.00.01",
	Author = "Alan Birtles",
	InfoURL = "http://www.birtles.org.uk/xmltv/wiki/index.php?title=Favourites",
	Passes={
		Pass1={
			Start=GetChannelsPassStart,
			Type=XGUI.PassTypes.Channel,
			Func=GetChannelsPass,
			},
		Pass2={
			Type=XGUI.PassTypes.Program,
			Func=ProgramsPass,
			End=WriteFavourites,
			},
		},
	Init=Init,		
	}
