require("lxp")

local OpenTags
local Result
local NumOpenTags
local callback,callbacklevel
local cdataSplit
local totalLength

local function StartElement (parser, name, attrs)
	local p,t
	if (NumOpenTags==0) then
		p=Result
		else 
			p=OpenTags[NumOpenTags].Tag
		end
	p.Children=p.Children or {}
	p.Children[name] = p.Children[name] or {}
	table.insert(p.Children[name],{Attrs=attrs})
	t=p.Children[name][table.getn(p.Children[name])]
	t.Children={}
	NumOpenTags=NumOpenTags+1
	OpenTags[NumOpenTags]={Name=name,Parent=p,Tag=t}
end

local function EndElement (parser, name)
	NumOpenTags=NumOpenTags-1
	if (NumOpenTags==callbacklevel)and(callback) then
		if OpenTags[NumOpenTags].Tag.Children then
			local n=table.getn(OpenTags[NumOpenTags].Tag.Children[name])
			local t=OpenTags[NumOpenTags].Tag.Children[name][n]
			local line,col,pos=parser:pos()
			local progress = 0
			if totalLength~=0 then
				progress = pos*100 / totalLength
				end
			local e,msg=pcall(callback,name,t,progress)
			if not e then
				print(string.format("Error calling callback in xml_to_table: %s",msg))
				end
			OpenTags[NumOpenTags].Tag.Children[name][n]=nil
			end
		end
end

local function CharacterData (parser, str)
	OpenTags[NumOpenTags].Tag.Data= (OpenTags[NumOpenTags].Tag.Data or "")..str
end

local function EndCdataSection (parser, str)
	if cdataSplit then
		if OpenTags[NumOpenTags].Tag.Data then
			if not OpenTags[NumOpenTags].Tag.CData then
				OpenTags[NumOpenTags].Tag.CData = {}
				end
			table.insert(OpenTags[NumOpenTags].Tag.CData,OpenTags[NumOpenTags].Tag.Data);
			end
		end
end

local function StartCdataSection (parser, str)
	if cdataSplit then
		OpenTags[NumOpenTags].Tag.Data = nil
		end
end

local callbacks = {
	StartElement = StartElement,
	EndElement = EndElement,
	CharacterData = CharacterData,
	EndCdataSection  = EndCdataSection,
	StartCdataSection   = StartCdataSection   
	}

local function Init(level,Callback,splitCData)
	callback=Callback
	callbacklevel=level
	cdataSplit = splitCData
	OpenTags={}
	NumOpenTags=0
	Result={}
end

XmlToTable={

	ParseFile=function(file,level,Callback,splitCData)
		Init(level,Callback,splitCData)
		totalLength = fileLength(file)
		--print(totalLength)
		local lx = lxp.new(callbacks)
		local l
		for l in file:lines() do
			lx:parse(l)
			lx:parse("\n")
			end
		lx:parse()
		lx:close()
		return Result
	end,

	ParseString=function(str,level,Callback,splitCData)
		Init(level,Callback,splitCData)
		totalLength = string.len(str)
		local lx = lxp.new(callbacks)
		local l
		lx:parse(str)
		lx:parse()
		lx:close()
		return Result
	end,
	
	GetChild=function(tag,...)
		local i
		for i=1,arg.n do
			if (tag.Children[arg[i]])and(tag.Children[arg[i]][1]) then
				tag=tag.Children[arg[i]][1]
				else return nil
				end
			end
	return tag
	end,

	}