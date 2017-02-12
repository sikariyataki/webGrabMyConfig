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
	XMLFile=XGUI.GetSetting(grabber,"File","xmltv.xml")
	if string.sub(XMLFile,string.len(XMLFile))~=";" then 
		XMLFile=XMLFile..";"
		end
	Grabber=grabber
	local xfile
	for xfile in string.gfind(XMLFile,"(.-);") do
		print(string.format("Importing XMLTV file \"%s\"",xfile))
		local file,err=io.open(xfile,"r")
		if file==nil then
			print(string.format("Failed to open XMLTV file \"%s\"",err))
			return XGUI.Fail
			end
		XmltvParse.ParseFile(file,PCallback,CCallback)
		end
	return XGUI.OK
	end
	
local function Init(grabber)
	XGUI.AddSetting(grabber,"File",XGUI.SettingType.File,"xmltv.xml","XMLTV File(s) (seperate files with \";\")")
	return XGUI.OK
	end
	
Grabbers.XMLTV_Import={
	Name = "XMLTV File Importer",
	Version = "1.00.00",
	Author = "Alan Birtles",
	InfoURL = "http://www.birtles.org.uk/xmltv/wiki/index.php/XMLTV_Import",
	SourceURL = "",
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
