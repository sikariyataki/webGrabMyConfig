require("xml_to_table")

local ccallback,pcallback,digiguideMode

local function XMLDateToDate(str)
	if not str then 
		return
		end
	local date={}
	if string.len(str)<14 then 
		return
		end
	local tz
	local a,b
	a,b,date.Year,date.Month,date.Day,date.Hour,date.Minute,date.Second,tz=string.find(str,"%s*(%d%d%d%d)(%d%d)(%d%d)(%d%d)(%d%d)(%d%d)%s*([%+%-]%d%d%d%d)%s*")
	if a==nil then
		--try match without timezone
		a,b,date.Year,date.Month,date.Day,date.Hour,date.Minute,date.Second,tz=string.find(str,"%s*(%d%d%d%d)(%d%d)(%d%d)(%d%d)(%d%d)(%d%d)%s*")
		if a==nil then
			if digiguideMode then
				--try digiguide date
				a,b,date.Month,date.Day,date.Year,date.Hour,date.Minute=string.find(str,"%s*(%d%d)/(%d%d)/(%d%d%d%d)%s*(%d%d):(%d%d)%s*")
				--print("'"..date.Month.."'")
				date.Second = 0
				tz = nil
				end
			end
		end
	if a==nil then print(string.format("Invalid date in xmltv: \"%s\"",str)) end
	date.Year = tonumber(date.Year)
	date.Month = tonumber(date.Month)
	date.Day = tonumber(date.Day)
	date.Hour = tonumber(date.Hour)
	date.Minute = tonumber(date.Minute)
	date.Second = tonumber(date.Second)
	if tz and(tz~="") then
		local tzs,tzh,tzm
		_,_,tzs,tzh,tzm=string.find(tz,"%s*([%+%-])(%d%d)(%d%d)%s*")
		if tzs=="+" then
			date.Hour=date.Hour-tzh
			date.Minute=date.Minute-tzm
			elseif tzs=="-" then
				date.Hour=date.Hour+tzh
				date.Minute=date.Minute+tzm
				end
		date=time.Fix(date)
		end
	return date
	end

local function LangStrToXMLStr(tag)
	if not tag then
		return
		end
	local e
	for _,e in tag do
		local str={}
		if e.Attrs.lang then
			str.Lang=XGUI.ValidXML(e.Attrs.lang)
			end
		str.Value=XGUI.ValidXML(e.Data)
		return str
		end
	end
	
local function LangStrToXMLStrList(tag)
	if not tag then
		return
		end
	local e
	local res={}
	local isEmpty = true
	for _,e in tag do
		local str={}
		if e.Attrs.lang then
			str.Lang=XGUI.ValidXML(e.Attrs.lang)
			isEmpty = false
			end
		str.Value=XGUI.ValidXML(e.Data)
		isEmpty = isEmpty and ((not e.Data) or e.Data=="")
		table.insert(res,str)
		end
	if isEmpty then
		return
		end
	return res
	end

local function GetIcon(tag)
	if not tag then
		return
		end
	local e
	local res={}
	for _,e in tag do
		local ico={}
		ico.Source=XGUI.ValidXML(e.Attrs.src)
		ico.Width=XGUI.ValidXML(e.Attrs.width)
		ico.Height=XGUI.ValidXML(e.Attrs.height)
		table.insert(res,ico)
		end
	return res
	end
	
local function GetStrList(tag,res)
	if not tag then
		return
		end
	local e
	if not res then
		res = {}
		end
	for _,e in tag do
		if istable(e) then
			table.insert(res,XGUI.ValidXML(e.Data))
			else
				table.insert(res,XGUI.ValidXML(e))
			end
		end
	return res
	end
	
local function GetCredits(tag)
	if not tag then
		return
		end
	local creditsTemp={}
	local creditsEmpty = true;
	if digiguideMode then
		if tag[1].Children.credit then
			local e
			for _,e in tag[1].Children.credit do
				local _type = e.Attrs.type
				if _type == "Director:" then
					creditsEmpty = false
					creditsTemp.Director = GetStrList(e.CData,creditsTemp.Director)
				elseif _type == "Starring:" or _type == "Guest Starring:" then
					creditsEmpty = false
					creditsTemp.Actor = GetStrList(e.CData,creditsTemp.Actor)
				elseif _type == "Writer:" then
					creditsEmpty = false
					creditsTemp.Writer = GetStrList(e.CData,creditsTemp.Writer)
				elseif _type == "Producer:" or _type == "Executive Producer:" then
					creditsEmpty = false
					creditsTemp.Producer = GetStrList(e.CData,creditsTemp.Producer)
					end
				end
			end
		else
			creditsTemp.Director=GetStrList(tag[1].Children.director)
			creditsEmpty = creditsEmpty and creditsTemp.Director~=nil
			creditsTemp.Actor=GetStrList(tag[1].Children.actor)
			creditsEmpty = creditsEmpty and creditsTemp.Actor~=nil
			creditsTemp.Writer=GetStrList(tag[1].Children.writer)
			creditsEmpty = creditsEmpty and creditsTemp.Writer~=nil
			creditsTemp.Adapter=GetStrList(tag[1].Children.adapter)
			creditsEmpty = creditsEmpty and creditsTemp.Adapter~=nil
			creditsTemp.Producer=GetStrList(tag[1].Children.producer)
			creditsEmpty = creditsEmpty and creditsTemp.Producer~=nil
			creditsTemp.Presenter=GetStrList(tag[1].Children.presenter)
			creditsEmpty = creditsEmpty and creditsTemp.Presenter~=nil
			creditsTemp.Commentator=GetStrList(tag[1].Children.commentator)
			creditsEmpty = creditsEmpty and creditsTemp.Commentator~=nil
			creditsTemp.Guest=GetStrList(tag[1].Children.guest)
			creditsEmpty = creditsEmpty and creditsTemp.Guest~=nil
		end
	if creditsEmpty then
		return nil
		end
	return creditsTemp
	end

local function GetLength(tag)
	if not tag then
		return
		end
	local res={}
	res.Length=tag[1].Data
	local s=tag[1].Attrs.units
	if s=="seconds" then res.Units=XGUI.LengthUnits.Seconds
		elseif s=="minutes" then res.Units=XGUI.LengthUnits.Minutes
		elseif s=="hours" then res.Units=XGUI.LengthUnits.Hours
		end
	return res
	end
	
local function GetEpisode(tag)
	if not tag then
		return
		end
	local res={}
	res.Number=XGUI.ValidXML(tag[1].Data)
	res.System=XGUI.ValidXML(tag[1].Attrs.system)
	return res
	end
	
local function GetVideo(tag)
	if not tag then
		return
		end
	local res={}
	res.Present=(tag[1].Children.present==nil)or(tag[1].Children.present[1].Data~="no")
	res.Colour=(tag[1].Children.colour==nil)or(tag[1].Children.colour[1].Data~="no")
	if tag[1].Children.aspect then
		res.Aspect=XGUI.ValidXML(tag[1].Children.aspect[1].Data)
		end
	if tag[1].Children.quality then
		res.quality=XGUI.ValidXML(tag[1].Children.quality[1].Data)
		end
	return res
	end
	
local function GetAudio(tag)
	if not tag then
		return
		end
	local res={}
	res.Present=(tag[1].Children.present==nil)or(tag[1].Children.present[1].Data~="no")
	if tag[1].Children.stereo then
		res.Stereo=XGUI.ValidXML(tag[1].Children.stereo[1].Data)
		end
	return res
	end
	
local function GetPrevious(tag)
	if not tag then
		return
		end
	local res={}
	res.Channel=XGUI.ValidXML(tag[1].Attrs.channel)
	res.Start=XGUI.ValidXML(tag[1].Attrs.start)
	return res
	end
	
local function GetSubtitles(tag)
	if not tag then
		return
		end
	local res={}
	for _,e in tag do
		local sub={}
		local s=e.Attrs.type
		if s=="teletext" then
			sub.Type=XGUI.SubtitlesType.Teletext
			else sub.Type=XGUI.SubtitlesType.OnScreen
			end
		sub.Lang=LangStrToXMLStr(e.Children.language)
		table.insert(res,sub)
		end
	return res
	end
	
local function GetRating(tag)
	if not tag then
		return
		end
	local res={}
	for _,e in tag do
		local rat={}
		rat.Value=XGUI.ValidXML(e.Children.value[1].Data)
		rat.Icon=GetIcon(e.Children.icon)
		rat.System=XGUI.ValidXML(e.Attrs.system)
		table.insert(res,rat)
		end
	return res
	end
	
local function GetStarRating(tag)
	if not tag then
		return
		end
	local res={}
	if tag[1].Children.value then
		_,_,res.Number,res.OutOf=string.find(tag[1].Children.value[1].Data,"%s*(%d*)%s*/%s*(%d*)%s*")
		end
	res.Icon=GetIcon(tag[1].Children.icon)
	return res	
	end
	
local function DigiMiscFind(str,pattern)
	--match in string
	local _,_,match=string.find(str,".*, "..pattern..",.*")
	if match then
		return match
		end
	--match start of string
	_,_,match=string.find(str,"^"..pattern..",.*")
	if match then
		return match
		end
	--match end of string
	_,_,match=string.find(str,".* "..pattern.."$")	
	if match then
		return match
		end
	--match whole string
	_,_,match=string.find(str,"^"..pattern.."$")	
	return match
	end
	
local function TagCallback(name,tag, progress)
	if name=="programme" then
		local prog={}
		prog.Channel=XGUI.ValidXML(tag.Attrs.channel)
		if digiguideMode and prog.Channel=="" then
			prog.Channel=XGUI.ValidXML(tag.Attrs.channel2)
			end
		prog.Start=XMLDateToDate(tag.Attrs.start)
		prog.Stop=XMLDateToDate(tag.Attrs.stop)
		if not prog.Stop then
			prog.Stop=XMLDateToDate(tag.Attrs["end"])
			end
		prog.PDCStart=XMLDateToDate(tag.Attrs["pdc-start"])
		prog.VPSStart=XMLDateToDate(tag.Attrs["vps-start"])
		prog.ShowView=XGUI.ValidXML(tag.Attrs.showview)
		prog.VideoPlus=XGUI.ValidXML(tag.Attrs.videoplus)
		prog.Clump=XGUI.ValidXML(tag.Attrs.clumpidx)
		prog.Title=LangStrToXMLStrList(tag.Children.title)
		if digiguideMode then
			prog.Sub_Title=LangStrToXMLStrList(tag.Children["episode-name"])
			else
				prog.Sub_Title=LangStrToXMLStrList(tag.Children["sub-title"])
			end
		prog.Description=LangStrToXMLStrList(tag.Children.desc)
		prog.Credits=GetCredits(tag.Children.credits)
		prog.Date=tag.Children.date
		prog.Category=LangStrToXMLStrList(tag.Children.category)
		prog.Lang=LangStrToXMLStr(tag.Children.language)		
		prog.OriginalLang=LangStrToXMLStr(tag.Children["orig-language"])		
		prog.Length=GetLength(tag.Children.length)
		prog.Icon=GetIcon(tag.Children.Icon)
		prog.URL=GetStrList(tag.Children.url)
		prog.Country=LangStrToXMLStrList(tag.Children.country)
		if digiguideMode then
			if tag.Children["series-number"] and tag.Children["series-number"][1].Data and 
					tag.Children["episode-number"] and tag.Children["episode-number"][1].Data then
				prog.Episode = {}
				prog.Episode.Number = tag.Children["series-number"][1].Data-1 .."."..tag.Children["episode-number"][1].Data-1 .. "."
				prog.Episode.System = "xmltv_ns"
				end
			else
				prog.Episode=GetEpisode(tag.Children["episode-num"])
			end
		prog.Video=GetVideo(tag.Children.video)
		prog.Audio=GetAudio(tag.Children.audio)
		prog.Premiere=LangStrToXMLStr(tag.Children.premiere)
		prog.LastChance=LangStrToXMLStr(tag.Children["last-chance"])
		prog.New= (tag.Children.new~=nil)
		prog.Subtitles=GetSubtitles(tag.Children.subtitles)
		prog.Rating=GetRating(tag.Children.rating)
		prog.StarRating=GetStarRating(tag.Children["star-rating"])
		if digiguideMode then
			if tag.Children["miscellaneous"] then
				local miscTag = tag.Children["miscellaneous"][1].Data 
				if miscTag then
					if DigiMiscFind(miscTag,"(Repeat)") then
						prog.PreviouslyShown = true
						end
					local starRating=DigiMiscFind(miscTag,"(%d) Star")
					if starRating then
						prog.StarRating = {}
						prog.StarRating.Number = tonumber(starRating)
						prog.StarRating.OutOf = 5
						end
					local year=DigiMiscFind(miscTag,"(%d%d%d%d)")
					if year then
						prog.Date = year
						end
					local rating=DigiMiscFind(miscTag,"(..)")
					if rating then
						prog.Rating = {}
						prog.Rating.Value = rating
						prog.Rating.System = "bbfc"
						end
					if DigiMiscFind(miscTag,"(Subtitles)") then
						prog.Subtitles = XGUI.SubtitlesType.Teletext
						end
					if DigiMiscFind(miscTag, "(High Definition)") then
						if not prog.Video then
							prog.Video = {}
							end						
						prog.Video.Quality = "HDTV"
						end
					end
				end
			else
				prog.PreviouslyShown=GetPrevious(tag.Children["previously-shown"])
			end			
		if pcallback then
			local e,msg=pcall(pcallback,prog,progress)
			if not e then
				print("Error calling program callback: "..msg)
				end
			end
		elseif name=="channel" then
			local chan={}
			chan.ID=XGUI.ValidXML(tag.Attrs.id)
			if digiguideMode and chan.ID=="" then
				chan.ID = XGUI.ValidXML(tag.Attrs.id2)
				end
			chan.Name=LangStrToXMLStrList(tag.Children["display-name"])
			chan.Icon=GetIcon(tag.Children.icon)
			chan.URL=GetStrList(tag.Children.url)
			if ccallback then
				local e,msg=pcall(ccallback,chan,progress)
				if not e then
					print("Error calling channel callback: "..msg)
					end
				end
		else
			print("Unexpected tag: "..name)
			end
	end

XmltvParse={
	ParseFile = function(file,ProgramCallback,ChannelCallback,DigiguideMode)
		pcallback=ProgramCallback
		ccallback=ChannelCallback
		digiguideMode=DigiguideMode
		XmlToTable.ParseFile(file,1,TagCallback,DigiguideMode)
		end,
	
	ParseString = function(str,ProgramCallback,ChannelCallback,DigiguideMode)
		pcallback=ProgramCallback
		ccallback=ChannelCallback
		digiguideMode=DigiguideMode
		XmlToTable.ParseString(str,1,TagCallback,DigiguideMode)
		end,
	}
	