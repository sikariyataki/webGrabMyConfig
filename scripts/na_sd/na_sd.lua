require ("zip");
require("xml_to_table")
require("tables")
require("timezones")

--zap2it data tables
zapdata={}
zapdata.Programs={}
zapdata.Schedule={}
zapdata.Schedule.Stations={}
zapdata.Stations={}
zapdata.Lineups={}
zapdata.Result=nil

local progress

local currentfile

local today
local daylimit=0
local numberOfAvailableDays=21
local minutesInADay=1440

local function ZapToDate(zapdate)
	local date={}
	local a,b
	a,b,date.Year,date.Month,date.Day,date.Hour,date.Minute,date.Second=string.find(zapdate,"(%d%d%d%d)-(%d%d)-(%d%d)T(%d%d):(%d%d):(%d%d)Z")
	if a==nil then 
		print("Invalid Schedules Direct date: "..zapdate)
		end
	return date
	end
	
local function DateToZap(date)
	if date==nil then
		return ""
		else
			return string.format("%.4d-%.2d-%.2dT%.2d:%.2d:%.2dZ",date.Year,date.Month,date.Day,date.Hour,date.Minute,date.Second)
		end
	end
	
local function StrToDate(str)
	local date={}
	local a,b
	a,b,date.Year,date.Month,date.Day=string.find(str,"(%d%d%d%d)-(%d%d)-(%d%d)")
	if a==nil then 
		print("Invalid date: "..str)
		end
	return date
	end
	
local function GetDuration(str)
	local a,b,h,m
	a,b,h,m=string.find(str,"PT(%d%d)H(%d%d)M");
	if a==nil then 
		print("Invalid duration: "..str)
		end
	return h*60+m
	end	
	
local function AddProgram(tag)
	local prog={}
	prog.ID=tag.Attrs.id
	if tag.Children.subtitle then
		prog.Subtitle=XGUI.ValidXML(tag.Children.subtitle[1].Data)
		end
	if tag.Children.description then
		prog.Description=XGUI.ValidXML(tag.Children.description[1].Data)
		end
	if tag.Children.originalAirDate then
		prog.OriginalAirDate=StrToDate(tag.Children.originalAirDate[1].Data)
		end
	if tag.Children.showType then
		prog.ShowType=tag.Children.showType[1].Data
		end
	if tag.Children.series then
		prog.Series=tag.Children.series[1].Data
		end
	if tag.Children.syndicatedEpisodeNumber then
		prog.SyndicatedEpisodeNumber=tag.Children.syndicatedEpisodeNumber[1].Data
		end
	if tag.Children.title then
		prog.Title=XGUI.ValidXML(tag.Children.title[1].Data)
		end
	if tag.Children.mpaaRating then
		prog.MPAARating = XGUI.ValidXML(tag.Children.mpaaRating[1].Data)
		end
	if tag.Children.starRating then
		prog.StarRating = tag.Children.starRating[1].Data
		end
	if tag.Children.runTime then
		prog.RunTime = GetDuration(tag.Children.runTime[1].Data)
		end
	if tag.Children.year then
		prog.Year = tag.Children.year[1].Data
		end
	if tag.Children.colorCode then
		prog.Colour = tag.Children.colorCode[1].Data
		end
	if (tag.Children.advisories) and (tag.Children.advisories[1].Children.advisory)  then
		local n,i
		n=table.getn(tag.Children.advisories[1].Children.advisory)
		prog.Advisories={}
		for i=1,n do
			table.insert(prog.Advisories,XGUI.ValidXML(tag.Children.advisories[1].Children.advisory[i].Data))
			end
		end	
	zapdata.Programs[prog.ID]=prog
	end
	
local function AddCrew(tag)
	local prog=tag.Attrs.program
	local program = zapdata.Programs[prog]
	if not prog then
		print("Crew found for non-existant program "..prog)
		return
		end
	program.Crew={}
	local n=table.getn(tag.Children.member)
	local i
	for i=1,n do
		local member={}
		local m=tag.Children.member[i].Children
		member.Role=m.role[1].Data
		member.FirstName=XGUI.ValidXML(m.givenname[1].Data)
		member.Surname=XGUI.ValidXML(m.surname[1].Data)
		table.insert(program.Crew,member)
		end
	end
	
local function AddGenre(tag)
	local prog=tag.Attrs.program
	local program = zapdata.Programs[prog]
	if not prog then
		print("Genre found for non-existant program "..prog)
		return
		end
	program.Genre={}
	local n=table.getn(tag.Children.genre)
	local i
	for i=1,n do
		local gen,rel
		gen=XGUI.ValidXML(tag.Children.genre[i].Children.class[1].Data)
		rel=tag.Children.genre[i].Children.relevance[1].Data+1
		program.Genre[rel]=gen
		end
	end
	
local function AddStation(tag)
	local stat={}
	stat.ID=tag.Attrs.id
	if tag.Children.callSign then
		stat.CallSign=XGUI.ValidXML(tag.Children.callSign[1].Data)
		end
	if tag.Children.name then
		stat.Name=XGUI.ValidXML(tag.Children.name[1].Data)
		end
	if tag.Children.affiliate then
		stat.Affiliate=XGUI.ValidXML(tag.Children.affiliate[1].Data)
		end
	if tag.Children.fccChannelNumber then
		stat.FCCChanel=XGUI.ValidXML(tag.Children.fccChannelNumber[1].Data)
		end
	zapdata.Stations[stat.ID]=stat
	end

local function AddSchedule(tag)
	local schd={}
	schd.Program=tag.Attrs.program
	schd.Station=tag.Attrs.station
	schd.Time=ZapToDate(tag.Attrs.time)
	schd.Duration=GetDuration(tag.Attrs.duration)
	if tag.Attrs['repeat'] then 
		schd.IsRepeat=toboolean(tag.Attrs['repeat'])
		end
	if tag.Attrs.stereo then
		schd.Stereo=toboolean(tag.Attrs.stereo)
		end
	if tag.Attrs.subtitled then
		schd.Subtitled=toboolean(tag.Attrs.subtitled)
		end
	if tag.Attrs.hdtv then
		schd.HDTV=toboolean(tag.Attrs.hdtv)
		end
	if tag.Attrs.closeCaptioned then
		schd.CC=toboolean(tag.Attrs.closeCaptioned)
		end
	schd.Rating=XGUI.ValidXML(tag.Attrs.tvRating)
	schd.Dolby=XGUI.ValidXML(tag.Attrs.dolby)
	schd.Part=tag.Attrs.number
	schd.Parts=tag.Attrs.total
	if not zapdata.Schedule.Stations[schd.Station] then
		zapdata.Schedule.Stations[schd.Station]={}
		end
	if (daylimit==0)or(daylimit<=schd.Time.Day) then
		table.insert(zapdata.Schedule.Stations[schd.Station],schd)
		end
	end
	
local function AddLineup(tag)
	local lup={}
	lup.Name=tag.Attrs.name
	lup.UserName=tag.Attrs.userLineupName
	lup.Location=tag.Attrs.location
	lup.Device=tag.Attrs.device
	lup.Type=tag.Attrs.type
	lup.PostCode=tag.Attrs.postalcode
	lup.ID=tag.Attrs.id
	lup.Map={}
	local n=table.getn(tag.Children.map)
	local i
	for i=1,n do
		local mp={}
		mp.Station=tag.Children.map[i].Attrs.station
		mp.Channel=tag.Children.map[i].Attrs.channel
		mp.ChannelMinor=tag.Children.map[i].Attrs.channelMinor
		mp.From=tag.Children.map[i].Attrs.from
		mp.To=tag.Children.map[i].Attrs.to
		if tag.Children.map[i].Children.onAir then
			mp.OnAirFrom=tag.Children.map[i].Children.onAir[1].Attrs.From
			mp.OnAirTo=tag.Children.map[i].Children.onAir[1].Attrs.To
			end
		table.insert(lup.Map,mp)
		end
	zapdata.Lineups[lup.ID]=lup
	end
	
local function TagCallback(name,tag)
	local fpos=currentfile:seek("cur")
	if fpos-progress > 100000 then
		XGUI.SetProgress(1,fpos,XGUI.PBarMode.Pos)
		progress=fpos
		end
	--XGUI.SetStatus(1,name)
	if name=="station" then AddStation(tag)
		elseif name=="lineup" then AddLineup(tag)
		elseif name=="schedule" then AddSchedule(tag)
		elseif name=="program" then AddProgram(tag)
		elseif name=="crew" then AddCrew(tag)
		elseif name=="programGenre" then AddGenre(tag)
		else print("Unused tag: "..name)
		end
	end

local ListingsURL="http://webservices.schedulesdirect.tmsdatadirect.com/schedulesdirect/tvlistings/xtvdService"

local function GenSoapReq(from,to)
	return "<?xml version='1.0' encoding='utf-8'?>"..
		"<SOAP-ENV:Envelope xmlns:SOAP-ENV='http://schemas.xmlsoap.org/soap/envelope/' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:SOAP-ENC='http://schemas.xmlsoap.org/soap/encoding/'>"..
		"<SOAP-ENV:Body>"..
		"<tms:download xmlns:tms='urn:TMSWebServices'>"..
		"<startTime xsi:type='tms:dateTime'>"..
		DateToZap(from)..
		"</startTime>"..
		"<endTime xsi:type='tms:dateTime'>"..
		DateToZap(to)..
		"</endTime>"..
		"</tms:download>"..
		"</SOAP-ENV:Body>"..
		"</SOAP-ENV:Envelope>"
	end
	
local function DownloadData(grabber,from,to,cachefile,cacheage)
	--clear stations + lineup to avoid duplicates
	progress=0
	zapdata.Stations={}
	zapdata.Lineups={}
	XGUI.SetStatus(2,string.format("Downloading data - %s",time.DateToStr(from)))
	HTTP.SetAcptEnc("zip,")
	local uname=XGUI.GetSetting(grabber,"Username","")
	local pword=XGUI.GetSetting(grabber,"Password","")
	local page,err
	if uname=="" then
		err=401
		else 
		page,err = HTTP.Post(ListingsURL,GenSoapReq(from,to),grabber,uname,pword,uname.."_"..cachefile,cacheage)
		end
	HTTP.SetAcptEnc("")
	if (err<400)and(err~=-1) then
		XGUI.SetStatus(2,string.format("Processing data - %s",time.DateToStr(from)))
		local tmp=string.format("%s%s.zip",TEMP,'a')
		local file=io.open(tmp,"wb")
		file:write(page);
		file:close();
		local zf=zip.open(tmp)
		local fileinfo
		for fileinfo in zf:files() do
			currentfile=zf:open(fileinfo.filename)
			XGUI.SetProgress(1,currentfile:seek("end")-1,XGUI.PBarMode.Max)
			currentfile:seek("set")
			zapdata.LastResult=XmlToTable.ParseFile(currentfile,6,TagCallback);
			end
		if (err~=0)and(daylimit~=0)and(daylimit==today) then
			msgs=XmlToTable.GetChild(zapdata.LastResult,
				"SOAP-ENV:Envelope",
				"SOAP-ENV:Body",
				"ns1:downloadResponse",
				"xtvdResponse",
				"messages")
			if msgs then
				local n,i
				n=table.getn(msgs.Children.message)
				for i=1,n do
					print(msgs.Children.message[i].Data)
					end
				end
			end
		elseif err==401 then print("Schedules Direct Authentication error, check your password in the grabber settings")
		else print("Error downloading Schedules Direct data, error code: "..err)
		end
	return err
	end

local function GetRating(rating)
	local ratingout=0
	ratingout=string.len(rating)*2-1
	if string.sub(rating,-1)=="+" then
		ratingout=ratingout-1
		end
	return ratingout
	end
	
local function Pass2Func(grabber,channel,maxdays)
	XGUI.SetStatus(2,"Generating XMLTV Data")
	local a,b,station=string.find(channel.ID,".-_(.-)_.-")
	if a==nil then
		print("Failed to get station ID from channel ID "..channel.ID)
		return XGUI.Fail
		end
	station=zapdata.Schedule.Stations[station]
	if not station then
		print("Station schedule not found")
		return XGUI.Fail
		end
	local i,prog
	for i,prog in ipairs(station) do
		programme={}
		programme.Start=prog.Time
		programme.Stop=table.copy(prog.Time)
		programme.Stop.Minute=programme.Stop.Minute+prog.Duration
		time.Fix(programme.Stop)
		programme.Channel=channel.ID
		if (prog.New) then
			programme.PreviouslyShown=false
			else
				programme.PreviouslyShown=true
			end
		if prog.Stereo then
			programme.Audio={Stereo="Stereo"}
			end
		if prog.Subtitled then
			programme.Subtitles=XGUI.SubtitlesType.OnScreen
			end
		if prog.HDTV then
			programme.Video={Quality="HDTV"}
			end
		if prog.Dolby then
			programme.Audio={Stereo=prog.Dolby}
			end
		if (prog.Part)and(prog.Parts) then
			programme.Episode={{Number=string.format("..%d/%d",prog.Part-1,prog.Parts),System="xmltv_ns"}}
			end
		if prog.Rating then
			programme.Rating={{Value=prog.Rating,System="TV"}}
			end
		programme.Episode=programme.Episode or {}
		table.insert(programme.Episode,{Number=prog.Program,System="Zap2itDD_Program"})
		--get program details
		local progdets=zapdata.Programs[prog.Program]
		if not progdets then
			print("Details not found for program "..prog.Program)
			else 
				programme.Title=progdets.Title
				programme.Sub_Title=progdets.Subtitle
				programme.Description=progdets.Description
				if progdets.Series then
					table.insert(programme.Episode,{Number=progdets.Series,System="Zap2itDD_Series"})
					end
				if progdets.MPAARating then
					programme.Rating=programme.Rating or {}
					table.insert(programme.Rating,{Value=progdets.MPAARating,System="MPAA"})
					end
				if progdets.StarRating then
					programme.StarRating = {Number=GetRating(progdets.StarRating),OutOf=7}
					end
				if progdets.RunTime then
					programme.Duration = {Length=progdets.RunTime,Units=XGUI.LengthUnits.Minutes}
					end
				programme.Date=progdets.Year
				if progdets.Colour=="B & W" then
					programme.Video=programme.Video or {}
					programme.Video.Colour=false
					end
				if progdets.Genre then
					local i,gen
					programme.Category={}
					for i,gen in ipairs(progdets.Genre) do
						table.insert(programme.Category,gen)
						end
					end
				if progdets.Crew then
					local i,mem,r
					programme.Credits={}
					for i,mem in ipairs(progdets.Crew) do
						if mem.Role=="Guest Star" then r="Guest"
							elseif mem.Role=="Host" then r="Presenter"
							elseif mem.Role=="Executive Producer" then r="Producer"
							else r=mem.Role
							end
						programme.Credits[r]=programme.Credits[r] or {}
						table.insert(programme.Credits[r],(mem.FirstName or "").." "..(mem.Surname or ""))
						end
					end
			end
		XGUI.AddProgram(grabber,programme)
		end
	end
	
local function Pass1Func(grabber,ctime)
	local to
	to=table.copy(ctime)
	to.Day=to.Day+1
	time.Fix(to)
	local cacheage = 1
	--[[if ctime.Day==today then cacheage=1
		else cacheage=numberOfAvailableDays
		end]]
	local err=DownloadData(grabber,ctime,to,time.DateToStr(ctime,"_"),cacheage)
	if (err>=400)or(err==-1) then
		return XGUI.Fail
		else return XGUI.OK
		end
	end
	
local function Pass1Start(grabber)
	--clear zap2it data tables
	zapdata.Programs={}
	zapdata.Schedule={}
	zapdata.Schedule.Stations={}
	today=time.GetSystemTime().Day
	end
	
local function Pass1End(grabber)
	print("   Clearing cache")
	XGUI.CleanCache(grabber,numberOfAvailableDays);
	return XGUI.OK
	end
	
local function Init(grabber)
	XGUI.AddSetting(grabber,"Username",XGUI.SettingType.String,"","Username")
	XGUI.AddSetting(grabber,"Password",XGUI.SettingType.Password,"","Password")	
	return XGUI.OK
	end

local function GetLineups(grabber)
	if next(zapdata.Lineups)==nil then
		local from,to
		from=time.GetSystemTime()
		to=time.GetSystemTime()
		to.Hour=to.Hour+1
		time.Fix(to)
		daylimit=0
		DownloadData(grabber,from,to,'lineups',1)
		end
	end
	
local function OnShowSettings(grabber)
	GetLineups(grabber)
	local lups="",n,i
	local lup
	for i,lup in pairs(zapdata.Lineups) do
		if lup.UserName
			then lups=lups..lup.UserName..'|'
			else lups=lups..lup.Name..'|'
			end
		lups=lups..lup.ID..';'
		end
	XGUI.AddSetting(grabber,"Lineups",XGUI.SettingType.ListSelect,"","Select Lineups",lups)
	return XGUI.OK
	end

local function RefChans(grabber)
	GetLineups(grabber)
	XGUI.ClearChannels(grabber)
	local lups=XGUI.GetSetting(grabber,"Lineups","")
	if string.sub(lups,-1)~=";" then
		lups=lups..";"
		end
	local lup
	for lup in string.gfind(lups,"(.-);") do
		local lineup=zapdata.Lineups[lup]
		if lineup then
			local map,i
			for i,map in ipairs(lineup.Map) do
				local chan={}
				chan.ID=lup.."_"..map.Station.."_"..map.Channel
				chan.Name={}
				local stationData = zapdata.Stations[map.Station]
				if stationData then
					table.insert(chan.Name,stationData.Name)
					table.insert(chan.Name,stationData.CallSign)
					table.insert(chan.Name,stationData.Affiliate)
					table.insert(chan.Name,stationData.fccChannelNumber)
					else
						print(chan.ID.." not present in station list")
						end
				table.insert(chan.Name,map.Channel)
				table.insert(chan.Name,map.ChannelMinor)
				XGUI.AddChannel(grabber,chan)
				end
			end
		end
	return XGUI.OK
	end
	
Grabbers.NA_SD={
	Name = "NA - Schedules Direct",
	Version = "1.00.00",
	Author = "Alan Birtles",
	InfoURL = "http://www.birtles.org.uk/xmltv/wiki/index.php/SchedulesDirect",
	SourceURL = "http://www.schedulesdirect.org/",
	Encoding = XGUI.Encoding.UTF8,
	Passes={
		Pass2={
			Type=XGUI.PassTypes.Channel,
			Func=Pass2Func,
			--Start=Pass1Start,
			--End=Pass1End,
			},
		Pass1={
			Type=XGUI.PassTypes.Time,
			Func=Pass1Func,
			Start=Pass1Start,
			--End=Pass1End,
			MaxDays=numberOfAvailableDays,
			Interval=minutesInADay,
			},
		},
	Init=Init,
	OnShowSettings=OnShowSettings,
	RefreshChannels=RefChans,
	}