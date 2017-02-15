XGUI_Lib={}
XGUI_Lib.XS={}

XGUI_Lib.XS.Type_String=1
XGUI_Lib.XS.Type_XString=2
XGUI_Lib.XS.Type_List=3

--type of xmltv string
XGUI_Lib.XS.Type = function (xstr)
if istable(xstr) then
	if xstr.Value then return XGUI_Lib.XS.Type_XString
		else return XGUI_Lib.XS.Type_List
		end
	else return XGUI_Lib.XS.Type_String
	end
end

--add value of xstr2 to value of xstr1
XGUI_Lib.XS.Cat = function (xstr1,xstr2)
if not xstr1 then return xstr2
	elseif not xstr2 then return xstr1
	end
local x1type=XGUI_Lib.XS.Type(xstr1)
local x2val=XGUI_Lib.XS.Val(xstr2)
if x1type==XGUI_Lib.XS.Type_String then return xstr1..x2val
	elseif x1type==XGUI_Lib.XS.Type_XString then
		xstr1.Value=xstr1.Value..x2val
		return xstr1
	else 
		xstr1[1]=XGUI_Lib.XS.Cat(xstr1[1],x2val)
		return xstr1
		end
end

--add str to start of xstr
XGUI_Lib.XS.Prefix = function (xstr,str)
if not xstr then return str
	elseif not str then return xstr
	end
local xtype=XGUI_Lib.XS.Type(xstr)
if xtype==XGUI_Lib.XS.Type_String then return str..xstr
	elseif xtype==XGUI_Lib.XS.Type_XString then
		xstr.Value=str..xstr.Value
		return xstr
	else 
		xstr[1]=XGUI_Lib.XS.Prefix(xstr[1],str)
		return xstr
		end
end

--replace first string of xstr with str
XGUI_Lib.XS.Replace = function (xstr,str)
if not xstr then return str
	elseif not str then return xstr
	end
local xtype=XGUI_Lib.XS.Type(xstr)
if xtype==XGUI_Lib.XS.Type_String then return str
	elseif xtype==XGUI_Lib.XS.Type_XString then
		xstr.Value=str
		return xstr
	else 
		xstr[1]=XGUI_Lib.XS.Replace(xstr[1],str)
		return xstr
		end
end

--add xstr2's values to xstr1
XGUI_Lib.XS.Add = function (xstr1,xstr2)
if not xstr1 then return xstr2
	elseif not xstr2 then return xstr1
	end
local x1type=XGUI_Lib.XS.Type(xstr1)
local x2type=XGUI_Lib.XS.Type(xstr2)
if x1type~=XGUI_Lib.XS.Type_List then
	xstr1={xstr1}
	end
if x2type~=XGUI_Lib.XS.Type_List then
	xstr2={xstr2}
	end
local n=table.getn(xstr2)
for i=1,n do
	table.insert(xstr1,xstr2[i])
	end
return xstr1
end

--get value of first string in xstr
XGUI_Lib.XS.Val = function (xstr)
if not xstr then	
	return ""
	end
local xtype=XGUI_Lib.XS.Type(xstr)
if xtype==XGUI_Lib.XS.Type_String then return xstr
	elseif xtype==XGUI_Lib.XS.Type_XString then return xstr.Value
		else return XGUI_Lib.XS.Val(xstr[1])
	end
end

XGUI_Lib.GetXMLTVEpisode = function (episode)
if not episode then return
	end
if episode.System then
	if episode.System=="xmltv_ns" then
		return episode
		else return 
		end
	end
local i,ep
for i,ep in ipairs(episode) do
	if ep.System=="xmltv_ns" then
		return episode
		end
	end
end
