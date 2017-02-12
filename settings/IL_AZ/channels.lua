local Grab;

local function DoAdd(i,chan)
	XGUI.AddChannel(Grab,chan);
	return nil;
	end
	
function Grabbers.IL_AZ.GetChans(Grabber)
Grab=Grabber
local channels= {
{ID="1",Name="HOT VOD"}
,{ID="2",Name="HOT ACTIVE"}
,{ID="3",Name="HOT 3"}
,{ID="4",Name="Bip"}
,{ID="5",Name="Xtra HOT"}
,{ID="6",Name="AXN1"}
,{ID="7",Name="HOT 7"}
,{ID="8",Name="8 - Mada"}
,{ID="10",Name="Israel 10"}
,{ID="11",Name="Israel 11"}
,{ID="12",Name="HOT Drama"}
,{ID="13",Name="HOT FUN"}
,{ID="14",Name="HOT Action"}
,{ID="15",Name="HOT Prime"}
,{ID="16",Name="HOT Movies"}
,{ID="19",Name="Hollmark"}
,{ID="21",Name="21 - Kaniot"}
,{ID="22",Name="22"}
,{ID="23",Name="Hinochit 23"}
,{ID="24",Name="Musik 24"}
,{ID="25",Name="Local Channel 25"}
,{ID="26",Name="Viva"}
,{ID="27",Name="Viva Platinum"}
,{ID="28",Name="Good Life 28"}
,{ID="29",Name="HOT Bidor"}
,{ID="30",Name="BBC Prime"}
,{ID="31",Name="E!"}
,{ID="32",Name="Bit+"}
,{ID="33",Name="Israel 33"}
,{ID="34",Name="REALITY TV"}
,{ID="35",Name="EGO"}
,{ID="36",Name="STAR WORLD"}
,{ID="37",Name="FTV"}
,{ID="39",Name="KARMA"}
,{ID="41",Name="Hop horim"}
,{ID="42",Name="HISTORY"}
,{ID="44",Name="NETIONAL G."}
,{ID="47",Name="Techlet"}
,{ID="48",Name="Teva Ha Dvarim"}
,{ID="49",Name="Chess"}
,{ID="50",Name="ADVENTURE 1"}
,{ID="51",Name="Hakademi"}
,{ID="53",Name="Liga Anglit"}
,{ID="54",Name="Shabat shel kdoregel"}
,{ID="55",Name="Sport 5"}
,{ID="56",Name="Sport 5+"}
,{ID="57",Name="Euro Sport"}
,{ID="58",Name="Euro News"}
,{ID="59",Name="ESPN"}
,{ID="60",Name="FOX SPORT"}
,{ID="62",Name="EXTREME"}
,{ID="64",Name="Vegas"}
,{ID="67",Name="CNN"}
,{ID="68",Name="Sky News"}
,{ID="69",Name="BBC WORLD"}
,{ID="70",Name="FOX NEWS"}
,{ID="71",Name="CNBC7"}
,{ID="72",Name="METV"}
,{ID="73",Name="73"}
,{ID="74",Name="74"}
,{ID="75",Name="Jetix"}
,{ID="76",Name="HOT Loli"}
,{ID="77",Name="Hop!"}
,{ID="78",Name="Hopi Lumdim"}
,{ID="79",Name="Gurdi"}
,{ID="80",Name="Yaladim 6"}
,{ID="81",Name="Lugi"}
,{ID="82",Name="FOX KIDS"}
,{ID="83",Name="CARTOON"}
,{ID="84",Name="Nikoldehon"}
,{ID="87",Name="Music Choice"}
,{ID="88",Name="Karyoki"}
,{ID="89",Name="MTV"}
,{ID="90",Name="VH-1"}
,{ID="91",Name="VH1 Classic"}
,{ID="92",Name="MTV Hits"}
,{ID="93",Name="MTV 2"}
,{ID="94",Name="MTV Base"}
,{ID="95",Name="MEZZO"}
,{ID="97",Name="HOT DJ"}
,{ID="99",Name="Keneset"}
,{ID="100",Name="HOT PORT"}
,{ID="101",Name="ORT"}
,{ID="102",Name="RTR"}
,{ID="103",Name="RTV INT."}
,{ID="104",Name="NASHE KINO"}
,{ID="105",Name="NTV MIR"}
,{ID="106",Name="Viva-RUS"}
,{ID="107",Name="HISTORY"}
,{ID="108",Name="Moscow O.W"}
,{ID="109",Name="Romantica russion"}
,{ID="110",Name="Movie Russ"}
,{ID="111",Name="Inter +"}
,{ID="121",Name="Yarden"}
,{ID="123",Name="Mizrahim"}
,{ID="124",Name="MBC"}
,{ID="127",Name="Maroko"}
,{ID="128",Name="Tunis"}
,{ID="145",Name="TV-5"}
,{ID="146",Name="FRANCE 2"}
,{ID="147",Name="ARTE"}
,{ID="148",Name="DUNA"}
,{ID="149",Name="PROTV"}
,{ID="150",Name="TV ROMANIA"}
,{ID="151",Name="SAT1"}
,{ID="152",Name="3SAT"}
,{ID="153",Name="RTL"}
,{ID="155",Name="RAI-1"}
,{ID="156",Name="CANALE-5"}
,{ID="157",Name="TVE"}
,{ID="158",Name="TRT1"}
,{ID="160",Name="INTERSTAR"}
,{ID="161",Name="ZEE TV"}
,{ID="170",Name="MGM"}
,{ID="223",Name="Gogo"}
,{ID="224",Name="Klik"}
,{ID="226",Name="Duble clik"}
,{ID="230",Name="Hot Game 2"}
,{ID="231",Name="Hot Game 1"}
,{ID="233",Name="CHESS"}
,{ID="237",Name="Horoskop"}
,{ID="333",Name="Netaction"}
,{ID="400",Name="Buy Hot Luli"}
,{ID="444",Name="TVMALL"}
,{ID="500",Name="Kempos"}
}
	
	
	table.foreach (channels,DoAdd)

	end
