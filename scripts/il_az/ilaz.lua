require("XGUI_Lib")
require ("lxp")
require("timezones")
require("tables")
		
local ListingsURL="http://www.aztv.co.il/site/XmlFiles/createTvProgr.hx.asp"
local ProgsURL="http://www.aztv.co.il/site/XmlFiles/singalProgram.hx.asp?id=%d"

local DownDetails

--pass 1 variables
local curchannelid
local channelid
local curtime

--pass 2 variables
local data
local progdets
local tmpdate

--common variables
local cgrabber

--pass 1 xml callback
local function StartElement (parser, name, attrs)
local pid,width
local program
if name=="channel" then
	channelid=attrs["id"]
	elseif (name=="program")and(channelid==curchannelid)and(attrs["id"]~="") then
		program=XGUI.GetProgram(cgrabber,attrs["id"]) or {}
		program.Title=attrs["title"]
		program.Channel=channelid
		program.ID=attrs["id"]
		if attrs["st"]=="1" then
			program.Start=table.copy(curtime)
			program.Start.Hour=program.Start.Hour-2
			program.Start=time.Fix(program.Start)
			end
		curtime.Minute=curtime.Minute+math.floor(attrs["width"]*2/5)
		curtime=time.Fix(curtime)
		--if attrs["en"]=="1" then
			program.Stop=table.copy(curtime)
			program.Stop.Hour=program.Stop.Hour-2
			program.Stop=time.Fix(program.Stop)
			--end
		if not program.Start then program.Start=program.Stop end
		if attrs["act"]~="" then
			program.Credits=program.Credits or {}
			if not program.Credits.Actor then
				program.Credits.Actor={}
				local act
				attrs["act"]=attrs["act"]..","
				for act in string.gfind(attrs["act"],"(.-),") do
					if (act~="")and(act~=" ") then
						table.insert(program.Credits.Actor,act)
						end
					end
				end
			end
		if attrs["dir"]~="" then
			program.Credits=program.Credits or {}
			if not program.Credits.Director then
				program.Credits.Director={}
				local dir
				attrs["dir"]=attrs["dir"]..","
				for dir in string.gfind(attrs["dir"],"(.-),") do
					if (dir~="")and(dir~=" ") then
						table.insert(program.Credits.Director,dir)
						end
					end
				end
			end
		XGUI.AddProgram(cgrabber,program)
		end
end

local function Pass1Func(grabber,channel,ctime)
	XGUI.SetStatus(2,"Downloading "..string.format("%s - %.2d/%.2d %.2d:%.2d",XGUI_Lib.XS.Val(channel.Name),ctime.Day,ctime.Month,ctime.Hour,ctime.Minute));
	local datestr=string.format("%.2d_%.2d_%.2d_%.2d",ctime.Day,ctime.Month,ctime.Hour,ctime.Minute)
	local page,err
	page,err=XGUI.Post(ListingsURL,
		'<?xml version=\"1.0\" encoding=\"Windows-1255\"?><data><date>'..datestr..'</date><otv/></data>',
		grabber,
		_,_,
		datestr..".xml",1)
	if (err<400)and(err~=-1) then
		page=string.gsub(page,"encoding=\"Windows%-1255\"","encoding=\"UTF-8\"")
		page=Win1255ToUTF8(page)
		local callbacks = {
			StartElement = StartElement,
			}
		curchannelid=channel.ID
		curtime=ctime
		cgrabber=grabber
		local lx = lxp.new(callbacks)
		local res,msg, line, col, pos
		res,msg, line, col, pos=lx:parse(page)
		if not res then
			print(string.format("   Parse error on line %d, column %s: \"%s\"",line,col,msg))
			end
		res,msg, line, col, pos=lx:parse()
		if not res then
			print(string.format("   Parse error on line %d, column %s: \"%s\"",line,col,msg))
			end
		lx:close()
		return XGUI.OK
		end
	return XGUI.Fail
	end

--pass 2 xml callbacks
local function EndElementP (parser, name)
	if name=="day" then
		tmpdate=time.StrToDate(data)
		elseif name=="at" then
			tmpdate=time.Add(tmpdate,time.StrToDate(data))
			progdets.Start=tmpdate
		elseif name=="abstract" then
			progdets.Description=data
		elseif name=="length" then
			progdets.Stop=time.Add(tmpdate,time.StrToDate(data))
		elseif name=="pu" then
			--????????
		elseif name=="title" then
			progdets.Title=data
		elseif name=="labels" then
			--????????
		--[[elseif name=="zapping" then
			--channel number? ignore]]
		--[[elseif name=="description" then
			--channel name? not needed]]
		elseif name=="REPEAT" then
			--repeated at?
		elseif name=="sub_labels" then
			--sub title?
		end
	end

local function StartElementP (parser, name, attrs)
	data=""
	end
	
local function CharacterDataP (parser, str)
	data=data..str
	end

	
local function Pass2Func(grabber,program)
	XGUI.SetStatus(2,"Downloading program details for "..program.ID);
	local page,err
	page,err=XGUI.Get(string.format(ProgsURL,program.ID),
		grabber,
		_,_,
		"prog_"..program.ID..".xml",8)
	if (err<400)and(err~=-1) then
		page=string.gsub(page,"encoding='windows%-1255'","encoding=\"UTF-8\"")
		page=Win1255ToUTF8(page)
		local callbacks = {
			StartElement = StartElementP,
			EndElement = EndElementP,
			CharacterData = CharacterDataP
			}
		progdets=program
		tmpdate={}
		cgrabber=grabber
		local lx = lxp.new(callbacks)
		local res,msg, line, col, pos
		res,msg, line, col, pos=lx:parse(page)
		if not res then
			print(string.format("   Parse error on line %d, column %s: \"%s\"",line,col,msg))
			return XGUI.Fail
			end
		res,msg, line, col, pos=lx:parse()
		if not res then
			print(string.format("   Parse error on line %d, column %s: \"%s\"",line,col,msg))
			return XGUI.Fail
			end
		lx:close()
		return progdets
		end
	return XGUI.Fail
	end

local function Pass2End(grabber)
	print("   Clearing cache")
	XGUI.CleanCache(grabber,1);
	return XGUI.OK
	end
		
local function Init(grabber)
	XGUI.AddSetting(grabber,"DownDetails",XGUI.SettingType.Boolean,"false","Download program details (slow)")
	return XGUI.OK
	end

local Pass2={
			Type=XGUI.PassTypes.Program,
			Func=Pass2Func,
			End=Pass2End,
			}

local function Pass1Start(grabber)
	DownDetails=toboolean(XGUI.GetSetting(grabber,"DownDetails",false))
	if DownDetails then Grabbers.IL_AZ.Passes.Pass2=Pass2
		else Grabbers.IL_AZ.Passes.Pass2=nil
		end
	end
	
Grabbers.IL_AZ={
	Name = "Israel - AZTV.co.il",
	Version = "1.01.00",
	Author = "Alan Birtles",
	InfoURL = "http://www.birtles.org.uk/xmltv/wiki/index.php/Israel",
	SourceURL = "http://www.aztv.co.il/site/programs/programs.asp?start=now",
	Encoding = XGUI.Encoding.UTF8,
	Passes={
		Pass1={
			Type=XGUI.PassTypes.ChannelTime,
			Func=Pass1Func,
			Start=Pass1Start,
			--End=Pass1End,
			MaxDays=7,
			Interval=180,
			},
		},
	RefreshChannels=RefChans,
	Init=Init,
	}
