require("XGUI_Lib")

--channels with local variations
local BBC1 = "BBC ONE"
local BBC2 = "BBC TWO"
local ITV1 = "ITV1"


local channelNames={
		[100]={Value=BBC1,Lang="en"},
		[101]={Value=BBC1,Lang="en"},
		[102]={Value=BBC1,Lang="en"},
		[103]={Value=BBC1,Lang="en"},
		[104]={Value=BBC1,Lang="en"},
		[105]={Value=BBC2,Lang="en"},
		[106]={Value=BBC2,Lang="en"},
		[1061]={Value="Paramount Comedy 1",Lang="en"},
		[107]={Value=BBC2,Lang="en"},
		[108]={Value=BBC2,Lang="en"},
		[109]={Value=BBC2,Lang="en"},
		[110]={Value=BBC2,Lang="en"},
		[111]={Value=BBC2,Lang="en"},
		[112]={Value=BBC2,Lang="en"},
		[113]={Value=BBC2,Lang="en"},
		[114]={Value=BBC2,Lang="en"},
		[1141]={Value="Flaunt",Lang="en"},
		[1142]={Value="Playboy TV",Lang="en"},
		[1143]={Value="Scuzz",Lang="en"},
		[1144]={Value="Bliss",Lang="en"},
		[115]={Value=BBC2,Lang="en"},
		[116]={Value=BBC2,Lang="en"},
		[1161]={Value="E4+1",Lang="en"},
		[117]={Value=BBC2,Lang="en"},
		[118]={Value="Bangla TV",Lang="en"},
		[119]={Value="Biography Channel",Lang="en"},
		[120]={Value="Bloomberg",Lang="en"},
		[1201]={Value="Paramount Comedy 2",Lang="en"},
		[1202]={Value="Trouble Reload",Lang="en"},
		[122]={Value="Bravo",Lang="en"},
		[1221]={Value="Bravo +1",Lang="en"},
		[123]={Value="British Eurosport",Lang="en"},
		[124]={Value="Eurosport",Lang="en"},
		[1241]={Value="Front Row",Lang="en"},
		[125]={Value="CNBC",Lang="en"},
		[126]={Value="CNN",Lang="en"},
		[1261]={Value="Sky Box Office",Lang="en"},
		[128]={Value="Cartoon Network",Lang="en"},
		[129]={Value="Boomerang +1",Lang="en"},
		[131]={Value="Challenge",Lang="en"},
		[132]={Value="Channel 4",Lang="en"},
		[133]={Value="S4C",Lang="en"},
		[134]={Value="Five",Lang="en"},
		[136]={Value="Christian TV",Lang="en"},
		[137]={Value="God Europe",Lang="en"},
		[1421]={Value="E! Entertainment",Lang="en"},
		[1442]={Value="TV Polonia",Lang="en"},
		[1461]={Value="FX",Lang="en"},
		[1462]={Value="Travel Channel",Lang="en"},
		[147]={Value="Discovery Channel",Lang="en"},
		[148]={Value="Discovery Civilisation",Lang="en"},
		[1482]={Value="VH2",Lang="en"},
		[149]={Value="Discovery Home &amp; Health",Lang="en"},
		[150]={Value="Discovery Real Time",Lang="en"},
		[1501]={Value="TMF",Lang="en"},
		[152]={Value="Discovery Channel +1",Lang="en"},
		[1521]={Value="UKTV History +1",Lang="en"},
		[153]={Value="Discovery Science",Lang="en"},
		[154]={Value="Discovery Travel &amp; Living",Lang="en"},
		[1541]={Value="Price-drop TV",Lang="en"},
		[1542]={Value="Community",Lang="en"},
		[1543]={Value="NASN",Lang="en"},
		[1544]={Value="The HITS",Lang="en"},
		[155]={Value="Discovery Turbo",Lang="en"},
		[156]={Value="Disney Channel",Lang="en"},
		[157]={Value="Disney Channel +1",Lang="en"},
		[158]={Value="E4",Lang="en"},
		[159]={Value="Euronews",Lang="en"},
		[160]={Value="Film4",Lang="en"},
		[1601]={Value="UKTV Documentary",Lang="en"},
		[1602]={Value="UKTV People",Lang="en"},
		[1621]={Value="UKTV Food +1",Lang="en"},
		[165]={Value="Jetix",Lang="en"},
		[166]={Value="Jetix +1",Lang="en"},
		[1661]={Value="Boomerang",Lang="en"},
		[1662]={Value="Sky Travel Extra",Lang="en"},
		[1681]={Value="Zone Horror",Lang="en"},
		[1741]={Value="Chelsea TV",Lang="en"},
		[176]={Value="Men &amp; Motors",Lang="en"},
		[1761]={Value="Animal Planet +1",Lang="en"},
		[1763]={Value="Classic FM TV",Lang="en"},
		[1764]={Value="Discovery Real Time +1",Lang="en"},
		[1766]={Value="S4C2",Lang="en"},
		[1767]={Value="Thomas Cook TV",Lang="en"},
		[1781]={Value="Setanta Sport 2",Lang="en"},
		[1783]={Value="Setanta Sport 1",Lang="en"},
		[180]={Value="Hallmark",Lang="en"},
		[1802]={Value="Ideal World",Lang="en"},
		[1804]={Value="TeleG",Lang="en"},
		[182]={Value="The History Channel",Lang="en"},
		[183]={Value="The History Channel +1",Lang="en"},
		[185]={Value="ITV2",Lang="en"},
		[1853]={Value="Celtic TV",Lang="en"},
		[1854]={Value="Rangers TV",Lang="en"},
		[1855]={Value="Travel Channel +1",Lang="en"},
		[1856]={Value="abc1",Lang="en"},
		[1859]={Value="ITV3",Lang="en"},
		[1860]={Value=BBC2,Lang="en"},
		[1861]={Value=BBC2,Lang="en"},
		[1862]={Value=BBC2,Lang="en"},
		[1869]={Value=BBC1,Lang="en"},
		[1870]={Value="RTE2",Lang="en"},
		[1871]={Value="UKTV G2 +1",Lang="en"},
		[1872]={Value="Challenge +1",Lang="en"},
		[1873]={Value="Living2",Lang="en"},
		[1874]={Value="UKTV People +1",Lang="en"},
		[1876]={Value="British Eurosport 2",Lang="en"},
		[1877]={Value="B TV",Lang="en"},
		[1882]={Value="UKTV Style Gardens",Lang="en"},
		[191]={Value="Kerrang!",Lang="en"},
		[1942]={Value="B4U Music",Lang="en"},
		[1943]={Value="Boro TV",Lang="en"},
		[1944]={Value="Channel M",Lang="en"},
		[1948]={Value="Phoenix CNE",Lang="en"},
		[1949]={Value="Racing UK",Lang="en"},
		[1950]={Value="Stop &amp; Shop",Lang="en"},
		[1951]={Value="TV Warehouse",Lang="en"},
		[1952]={Value="Thane Direct",Lang="en"},
		[1953]={Value="Discovery Home &amp; Health +1",Lang="en"},
		[1955]={Value="Teachers&apos; TV (satellite/cable/DSL)",Lang="en"},
		[1956]={Value="Teachers&apos; TV",Lang="en"},
		[1958]={Value="Motors TV",Lang="en"},
		[1959]={Value="More 4",Lang="en"},
		[1961]={Value="ITV4",Lang="en"},
		[1963]={Value="SKY THREE",Lang="en"},
		[197]={Value="Living",Lang="en"},
		[1971]={Value="FX+",Lang="en"},
		[1972]={Value="More 4 +1",Lang="en"},
		[1973]={Value="Sky Movies HD2",Lang="en"},
		[1978]={Value="Zee Cinema",Lang="en"},
		[1979]={Value="Zee Music",Lang="en"},
		[1981]={Value="CITV",Lang="en"},
		[1984]={Value="Disney Cinemagic",Lang="en"},
		[1985]={Value="Disney Cinemagic +1",Lang="en"},
		[1990]={Value="ITV2 +1",Lang="en"},
		[1992]={Value="Private Blue",Lang="en"},
		[1993]={Value="UKTV Drama +1",Lang="en"},
		[1994]={Value="BBC HD",Lang="en"},
		[2007]={Value="Five Life",Lang="en"},
		[2008]={Value="Five US",Lang="en"},
		[2010]={Value="Bravo 2",Lang="en"},
		[2011]={Value="ESPN Classic",Lang="en"},
		[2012]={Value="Movies 24",Lang="en"},
		[2013]={Value="Paramount Comedy Digital +1",Lang="en"},
		[2015]={Value="Sci Fi +1",Lang="en"},
		[2016]={Value="TCM2",Lang="en"},
		[202]={Value="MTV One",Lang="en"},
		[2021]={Value="Film4 +1",Lang="en"},
		[2024]={Value="Nat Geo Wild",Lang="en"},
		[203]={Value="MTV Base",Lang="en"},
		[204]={Value="MTV Hits",Lang="en"},
		[2040]={Value="BBC Sport Interactive (red button)",Lang="en"},
		[2043]={Value="Discovery Channel +1.5",Lang="en"},
		[205]={Value="MTV Two",Lang="en"},
		[206]={Value="MUTV",Lang="en"},
		[213]={Value="National Geographic",Lang="en"},
		[214]={Value="National Geographic +1",Lang="en"},
		[215]={Value="Nick Jr",Lang="en"},
		[216]={Value="Nick Replay",Lang="en"},
		[217]={Value="Nickelodeon",Lang="en"},
		[219]={Value="Sky Box Office Events",Lang="en"},
		[22]={Value="National Geographic Wild",Lang="en"},
		[223]={Value="ARY Digital",Lang="en"},
		[225]={Value="Performance",Lang="en"},
		[228]={Value="QVC",Lang="en"},
		[231]={Value="RTE1",Lang="en"},
		[24]={Value=ITV1,Lang="en"},
		[244]={Value="Sci-Fi",Lang="en"},
		[246]={Value="Screenshop",Lang="en"},
		[248]={Value="Sky One",Lang="en"},
		[249]={Value="Sky Movies Premiere",Lang="en"},
		[25]={Value=ITV1,Lang="en"},
		[250]={Value="Sky Movies Premiere +1",Lang="en"},
		[251]={Value="Sky Movies Action/Thriller",Lang="en"},
		[252]={Value="Sky Movies Sci-Fi/Horror",Lang="en"},
		[253]={Value="Sky Movies Indie",Lang="en"},
		[254]={Value="Sky Movies HD1",Lang="en"},
		[255]={Value="Sky Movies Drama",Lang="en"},
		[256]={Value="Sky News",Lang="en"},
		[257]={Value="Sky Movies Comedy",Lang="en"},
		[258]={Value="Sky Movies Family",Lang="en"},
		[259]={Value="Sky Movies Classics",Lang="en"},
		[26]={Value=ITV1,Lang="en"},
		[260]={Value="Sky Movies Modern Greats",Lang="en"},
		[262]={Value="Sky Sports 1",Lang="en"},
		[263]={Value="Sky Sports Xtra",Lang="en"},
		[264]={Value="Sky Sports 2",Lang="en"},
		[265]={Value="Sky Sports 3",Lang="en"},
		[266]={Value="Sky Travel",Lang="en"},
		[267]={Value="Sony Entertainment TV Asia",Lang="en"},
		[27]={Value=ITV1,Lang="en"},
		[271]={Value="TCM",Lang="en"},
		[273]={Value="TG4",Lang="en"},
		[274]={Value="TV Travel Shop",Lang="en"},
		[275]={Value="TV Travel Shop 2",Lang="en"},
		[276]={Value="TV5 Europe",Lang="en"},
		[279]={Value="Television X",Lang="en"},
		[28]={Value=ITV1,Lang="en"},
		[280]={Value="The Adult Channel",Lang="en"},
		[281]={Value="The Box",Lang="en"},
		[287]={Value="Trouble",Lang="en"},
		[288]={Value="UKTV Gold",Lang="en"},
		[289]={Value="UKTV G2",Lang="en"},
		[29]={Value=ITV1,Lang="en"},
		[291]={Value="UKTV Style",Lang="en"},
		[292]={Value="UKTV Drama",Lang="en"},
		[293]={Value="VH1",Lang="en"},
		[294]={Value="VH1 Classic",Lang="en"},
		[30]={Value=ITV1,Lang="en"},
		[300]={Value="Sky Spts News",Lang="en"},
		[31]={Value=ITV1,Lang="en"},
		[32]={Value=ITV1,Lang="en"},
		[33]={Value=ITV1,Lang="en"},
		[35]={Value=ITV1,Lang="en"},
		[36]={Value=ITV1,Lang="en"},
		[37]={Value="STV (was Grampian/Scottish)",Lang="en"},
		[38]={Value=ITV1,Lang="en"},
		[39]={Value="Animal Planet",Lang="en"},
		[40]={Value="Sky Arts",Lang="en"},
		[421]={Value="Playhouse Disney",Lang="en"},
		[423]={Value="UKTV Food",Lang="en"},
		[43]={Value="B4U Movies",Lang="en"},
		[44]={Value="BBC America",Lang="en"},
		[45]={Value="BBC THREE",Lang="en"},
		[461]={Value=ITV1,Lang="en"},
		[47]={Value="BBC FOUR",Lang="en"},
		[48]={Value="BBC NEWS 24",Lang="en"},
		[482]={Value="CBBC Channel",Lang="en"},
		[483]={Value="CBeebies",Lang="en"},
		[49]={Value="BBC Parliament",Lang="en"},
		[50]={Value="BBC Prime",Lang="en"},
		[521]={Value=BBC2,Lang="en"},
		[581]={Value="Zee TV",Lang="en"},
		[582]={Value="Extreme Sports",Lang="en"},
		[587]={Value="PremPlus",Lang="en"},
		[588]={Value="Magic",Lang="en"},
		[590]={Value="Star News",Lang="en"},
		[591]={Value="Star Plus",Lang="en"},
		[592]={Value="Smash Hits",Lang="en"},
		[594]={Value="Bid TV",Lang="en"},
		[609]={Value="Kiss",Lang="en"},
		[610]={Value="MTV Dance",Lang="en"},
		[613]={Value="Q",Lang="en"},
		[625]={Value="UKTV Documentary +1",Lang="en"},
		[661]={Value="Attheraces",Lang="en"},
		[664]={Value="Nicktoons TV",Lang="en"},
		[665]={Value="UKTV Gold +1",Lang="en"},
		[666]={Value="UKTV Style +1",Lang="en"},
		[721]={Value="S4C Digital",Lang="en"},
		[742]={Value="Cartoon Network Too",Lang="en"},
		[746]={Value="Reality TV",Lang="en"},
		[801]={Value="UKTV History",Lang="en"},
		[841]={Value="Living+1",Lang="en"},
		[90]={Value="BBC World (CET)",Lang="en"},
		[92]={Value=BBC1,Lang="en"},
		[921]={Value="f tn",Lang="en"},
		[922]={Value="Sky Two",Lang="en"},
		[923]={Value="UKTV Br&apos;tIdeas",Lang="en"},
		[93]={Value=BBC1,Lang="en"},
		[94]={Value=BBC1,Lang="en"},
		[941]={Value="TV3",Lang="en"},
		[95]={Value=BBC1,Lang="en"},
		[96]={Value=BBC1,Lang="en"},
		[97]={Value=BBC1,Lang="en"},
		[98]={Value=BBC1,Lang="en"},
		[981]={Value="The Dating Channel",Lang="en"},
		[99]={Value=BBC1,Lang="en"},
		[2049]={Value="Virgin1",Lang="en"}
}

local function Pass1Func(grabber,channel)
	XGUI.SetStatus(2,"Processing "..channel.Name.Value)
	local newName = channelNames[tonumber(channel.ID)]
	if (newName) then
		channel.Name = XGUI_Lib.XS.Add(newName,channel.Name)
		end
	return channel
	end
	
PostProcs.UK_RT_Freeview_Names={
	Name = "UK - Radio Times - Freeview Channel Names",
	Version = "1.00.00",
	Author = "Alan Birtles",
	InfoURL = "http://www.birtles.org.uk/xmltv/wiki/index.php?title=UK_RT_FreeviewNames",
	Grabber = "UK_RT",
	Passes={
		Pass1={
			Type=XGUI.PassTypes.Channel,
			Func=Pass1Func,
			},
		},
	}
