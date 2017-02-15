require("XGUI_Lib")

local AddFilm
local AddMovie
local AddStars
local AddEpNums
local RepeatPrems
local AddPDateDesc
local AddPDateTitle
local AddRepeats
local ShortEpisodeForm
local AddSubtitleToDesc

local function splitEpisodeNumString(str)
	if string.find(str,"%/") then
		local _,_,a,b = string.find(str,"%s*(%d*)%s*%/%s*(%d*)%s*")
		a = tonumber(a)
		b = tonumber(b)
		if a and b then
			if ShortEpisodeForm then
				return (a+1).."/"..b
				else
					return (a+1).." of "..b
				end
			end
		end
	local num = tonumber(str)
	if num then
		return num+1
		else
			return ""
		end	
	end

local function Pass1Func(proc,program)
	local cat,str,i
	XGUI.SetStatus(2,"Processing "..XGUI_Lib.XS.Val(program.Title))
	if program.Category then
		cat=XGUI_Lib.XS.Val(program.Category)
		end
	if ((cat=="Film")or(cat=="Movie")) then
		if AddFilm then
			program.Title=XGUI_Lib.XS.Prefix(program.Title,"Film:") end
		if AddMovie then
			program.Title=XGUI_Lib.XS.Prefix(program.Title,"Movie:") end
		end
	if AddStars and (program.StarRating)and(program.StarRating.Number~=0) then
		str=" "
		for i = 1,program.StarRating.Number do
			str=str.."*"
			end
		program.Title=XGUI_Lib.XS.Cat(program.Title,str)
		end
	if AddEpNums and program.Episode then
		str=nil
		local ep=XGUI_Lib.GetXMLTVEpisode(program.Episode)
		if ep and ep.System=="xmltv_ns" then
			local _,_,season, episode, part = string.find(ep.Number,"(.*)%.(.*)%.(.*)");
			season = splitEpisodeNumString(season)
			episode = splitEpisodeNumString( episode)
			part = splitEpisodeNumString(part)
			if season~="" then
				if ShortEpisodeForm then
					str = "S"..season
					else
						str = "Season "..season
					end
				end
			if episode~="" then
				if str then
					if not ShortEpisodeForm then
						str = str..", "
						end
					else
						str = ""
					end
				if ShortEpisodeForm then
						str = str.."E"..episode
					else
						str = str.."Episode "..episode
					end
				end
			if part~="" then
				if str then
					if not ShortEpisodeForm then
						str = str..", "
						end
					else
						str = ""
					end
				if ShortEpisodeForm then
						str = str.."P"..part
					else
						str = str.."Part "..part
					end
				end
			end
		if str then
			if program.Sub_Title then
				str=str.." - "
				end
			program.Sub_Title=XGUI_Lib.XS.Prefix(program.Sub_Title,str)
			end
		end
	if RepeatPrems then
		if (not program.PreviouslyShown)and(not program.Premiere) then
			program.Premiere="Not a repeat"
			end
		end
	if AddPDateDesc then
		if program.Date then
			program.Description=XGUI_Lib.XS.Cat(program.Description,"Date: "..program.Date)
			end
		end
	if AddPDateTitle then
		if program.Date then
			program.Title=XGUI_Lib.XS.Cat(program.Title," ("..program.Date..")")
			end
		end
	if AddRepeats then
		if program.PreviouslyShown then
			program.Title=XGUI_Lib.XS.Cat(program.Title," (R)")
			end
		end
	if AddSubtitleToDesc then
		if program.Sub_Title then
			program.Description = XGUI_Lib.XS.Prefix(program.Description, XGUI_Lib.XS.Val(program.Sub_Title).."\n")
			end
		end
	return program
	end

local function Pass1Start(proc)
	AddFilm=toboolean(XGUI.GetSetting(proc,"AddFilm",true))
	AddMovie=toboolean(XGUI.GetSetting(proc,"AddMovie",false))
	AddStars=toboolean(XGUI.GetSetting(proc,"AddStars",true))
	AddEpNums=toboolean(XGUI.GetSetting(proc,"AddEpNums",true))
	RepeatPrems=toboolean(XGUI.GetSetting(proc,"RepeatPrems",false))
	AddPDateDesc=toboolean(XGUI.GetSetting(proc,"AddPDateDesc",false))
	AddPDateTitle=toboolean(XGUI.GetSetting(proc,"AddPDateTitle",false))
	AddRepeats=toboolean(XGUI.GetSetting(proc,"AddRepeats",false))
	ShortEpisodeForm=toboolean(XGUI.GetSetting(proc,"ShortEpisodeForm",false))
	AddSubtitleToDesc=toboolean(XGUI.GetSetting(proc,"AddSubtitleToDesc",false))
	return XGUI.OK
	end

local function Init(proc)
	XGUI.AddSetting(proc,"AddFilm",XGUI.SettingType.Boolean,"true","Add \"Film:\" to the title of films")
	XGUI.AddSetting(proc,"AddMovie",XGUI.SettingType.Boolean,"false","Add \"Movie:\" to the title of films")
	XGUI.AddSetting(proc,"AddStars",XGUI.SettingType.Boolean,"true","Add stars to program titles")
	XGUI.AddSetting(proc,"AddEpNums",XGUI.SettingType.Boolean,"true","Add episode numbers to program subtitle")
	XGUI.AddSetting(proc,"ShortEpisodeForm",XGUI.SettingType.Boolean,"false","Use short form for episode numbers")
	XGUI.AddSetting(proc,"RepeatPrems",XGUI.SettingType.Boolean,"false","Mark all non-repeats as \"Premieres\"")
	XGUI.AddSetting(proc,"AddPDateDesc",XGUI.SettingType.Boolean,"false","Add production date to description")
	XGUI.AddSetting(proc,"AddPDateTitle",XGUI.SettingType.Boolean,"false","Add production date to title")
	XGUI.AddSetting(proc,"AddRepeats",XGUI.SettingType.Boolean,"false","Add \"(R)\" to repeated program titles")
	XGUI.AddSetting(proc,"AddSubtitleToDesc",XGUI.SettingType.Boolean,"false","Add the program subtitle to the description")
	return XGUI.OK
	end

PostProcs.PrgDets={
	Name = "Program Details Processor",
	Version = "1.02.00",
	Author = "Alan Birtles",
	InfoURL = "http://www.birtles.org.uk/xmltv/wiki/index.php?title=PrgDets",
	Passes={
		Pass1={
			Start=Pass1Start,
			Type=XGUI.PassTypes.Program,
			Func=Pass1Func,
			},
		},
	Init=Init,		
	}
