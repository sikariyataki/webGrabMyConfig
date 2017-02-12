local htmlEntities = {
	--[[["quot"] ="\34",
	["amp"] ="\38",
	["apos"] ="\39",
	["lt"] ="\60",
	["gt"] ="\62",]]
	["nbsp"] ="\194\160",
	["iexcl"] ="\194\161",
	["cent"] ="\194\162",
	["pound"] ="\194\163",
	["curren"] ="\194\164",
	["yen"] ="\194\165",
	["brvbar"] ="\194\166",
	["sect"] ="\194\167",
	["uml"] ="\194\168",
	["copy"] ="\194\169",
	["ordf"] ="\194\170",
	["laquo"] ="\194\171",
	["not"] ="\194\172",
	["shy"] ="\194\173",
	["reg"] ="\194\174",
	["macr"] ="\194\175",
	["deg"] ="\194\176",
	["plusmn"] ="\194\177",
	["sup2"] ="\194\178",
	["sup3"] ="\194\179",
	["acute"] ="\194\180",
	["micro"] ="\194\181",
	["para"] ="\194\182",
	["middot"] ="\194\183",
	["cedil"] ="\194\184",
	["sup1"] ="\194\185",
	["ordm"] ="\194\186",
	["raquo"] ="\194\187",
	["frac14"] ="\194\188",
	["frac12"] ="\194\189",
	["frac34"] ="\194\190",
	["iquest"] ="\194\191",
	["Agrave"] ="\195\128",
	["Aacute"] ="\195\129",
	["Acirc"] ="\195\130",
	["Atilde"] ="\195\131",
	["Auml"] ="\195\132",
	["Aring"] ="\195\133",
	["AElig"] ="\195\134",
	["Ccedil"] ="\195\135",
	["Egrave"] ="\195\136",
	["Eacute"] ="\195\137",
	["Ecirc"] ="\195\138",
	["Euml"] ="\195\139",
	["Igrave"] ="\195\140",
	["Iacute"] ="\195\141",
	["Icirc"] ="\195\142",
	["Iuml"] ="\195\143",
	["ETH"] ="\195\144",
	["Ntilde"] ="\195\145",
	["Ograve"] ="\195\146",
	["Oacute"] ="\195\147",
	["Ocirc"] ="\195\148",
	["Otilde"] ="\195\149",
	["Ouml"] ="\195\150",
	["times"] ="\195\151",
	["Oslash"] ="\195\152",
	["Ugrave"] ="\195\153",
	["Uacute"] ="\195\154",
	["Ucirc"] ="\195\155",
	["Uuml"] ="\195\156",
	["Yacute"] ="\195\157",
	["THORN"] ="\195\158",
	["szlig"] ="\195\159",
	["agrave"] ="\195\160",
	["aacute"] ="\195\161",
	["acirc"] ="\195\162",
	["atilde"] ="\195\163",
	["auml"] ="\195\164",
	["aring"] ="\195\165",
	["aelig"] ="\195\166",
	["ccedil"] ="\195\167",
	["egrave"] ="\195\168",
	["eacute"] ="\195\169",
	["ecirc"] ="\195\170",
	["euml"] ="\195\171",
	["igrave"] ="\195\172",
	["iacute"] ="\195\173",
	["icirc"] ="\195\174",
	["iuml"] ="\195\175",
	["eth"] ="\195\176",
	["ntilde"] ="\195\177",
	["ograve"] ="\195\178",
	["oacute"] ="\195\179",
	["ocirc"] ="\195\180",
	["otilde"] ="\195\181",
	["ouml"] ="\195\182",
	["divide"] ="\195\183",
	["oslash"] ="\195\184",
	["ugrave"] ="\195\185",
	["uacute"] ="\195\186",
	["ucirc"] ="\195\187",
	["uuml"] ="\195\188",
	["yacute"] ="\195\189",
	["thorn"] ="\195\190",
	["yuml"] ="\195\191",
	["OElig"] ="\197\146",
	["oelig"] ="\197\147",
	["Scaron"] ="\197\160",
	["scaron"] ="\197\161",
	["Yuml"] ="\197\184",
	["fnof"] ="\198\146",
	["circ"] ="\203\134",
	["tilde"] ="\203\156",
	["Alpha"] ="\206\145",
	["Beta"] ="\206\146",
	["Gamma"] ="\206\147",
	["Delta"] ="\206\148",
	["Epsilon"] ="\206\149",
	["Zeta"] ="\206\150",
	["Eta"] ="\206\151",
	["Theta"] ="\206\152",
	["Iota"] ="\206\153",
	["Kappa"] ="\206\154",
	["Lambda"] ="\206\155",
	["Mu"] ="\206\156",
	["Nu"] ="\206\157",
	["Xi"] ="\206\158",
	["Omicron"] ="\206\159",
	["Pi"] ="\206\160",
	["Rho"] ="\206\161",
	["Sigma"] ="\206\163",
	["Tau"] ="\206\164",
	["Upsilon"] ="\206\165",
	["Phi"] ="\206\166",
	["Chi"] ="\206\167",
	["Psi"] ="\206\168",
	["Omega"] ="\206\169",
	["alpha"] ="\206\177",
	["beta"] ="\206\178",
	["gamma"] ="\206\179",
	["delta"] ="\206\180",
	["epsilon"] ="\206\181",
	["zeta"] ="\206\182",
	["eta"] ="\206\183",
	["theta"] ="\206\184",
	["iota"] ="\206\185",
	["kappa"] ="\206\186",
	["lambda"] ="\206\187",
	["mu"] ="\206\188",
	["nu"] ="\206\189",
	["xi"] ="\206\190",
	["omicron"] ="\206\191",
	["pi"] ="\207\128",
	["rho"] ="\207\129",
	["sigmaf"] ="\207\130",
	["sigma"] ="\207\131",
	["tau"] ="\207\132",
	["upsilon"] ="\207\133",
	["phi"] ="\207\134",
	["chi"] ="\207\135",
	["psi"] ="\207\136",
	["omega"] ="\207\137",
	["thetasym"] ="\207\145",
	["upsih"] ="\207\146",
	["piv"] ="\207\150",
	["ensp"] ="\226\128\130",
	["emsp"] ="\226\128\131",
	["thinsp"] ="\226\128\137",
	["zwnj"] ="\226\128\140",
	["zwj"] ="\226\128\141",
	["lrm"] ="\226\128\142",
	["rlm"] ="\226\128\143",
	["ndash"] ="\226\128\147",
	["mdash"] ="\226\128\148",
	["lsquo"] ="\226\128\152",
	["rsquo"] ="\226\128\153",
	["sbquo"] ="\226\128\154",
	["ldquo"] ="\226\128\156",
	["rdquo"] ="\226\128\157",
	["bdquo"] ="\226\128\158",
	["dagger"] ="\226\128\160",
	["Dagger"] ="\226\128\161",
	["bull"] ="\226\128\162",
	["hellip"] ="\226\128\166",
	["permil"] ="\226\128\176",
	["prime"] ="\226\128\178",
	["Prime"] ="\226\128\179",
	["lsaquo"] ="\226\128\185",
	["rsaquo"] ="\226\128\186",
	["oline"] ="\226\128\190",
	["frasl"] ="\226\129\132",
	["euro"] ="\226\130\172",
	["image"] ="\226\132\145",
	["weierp"] ="\226\132\152",
	["real"] ="\226\132\156",
	["trade"] ="\226\132\162",
	["alefsym"] ="\226\132\181",
	["larr"] ="\226\134\144",
	["uarr"] ="\226\134\145",
	["rarr"] ="\226\134\146",
	["darr"] ="\226\134\147",
	["harr"] ="\226\134\148",
	["crarr"] ="\226\134\181",
	["lArr"] ="\226\135\144",
	["uArr"] ="\226\135\145",
	["rArr"] ="\226\135\146",
	["dArr"] ="\226\135\147",
	["hArr"] ="\226\135\148",
	["forall"] ="\226\136\128",
	["part"] ="\226\136\130",
	["exist"] ="\226\136\131",
	["empty"] ="\226\136\133",
	["nabla"] ="\226\136\135",
	["isin"] ="\226\136\136",
	["notin"] ="\226\136\137",
	["ni"] ="\226\136\139",
	["prod"] ="\226\136\143",
	["sum"] ="\226\136\145",
	["minus"] ="\226\136\146",
	["lowast"] ="\226\136\151",
	["radic"] ="\226\136\154",
	["prop"] ="\226\136\157",
	["infin"] ="\226\136\158",
	["ang"] ="\226\136\160",
	["and"] ="\226\136\167",
	["or"] ="\226\136\168",
	["cap"] ="\226\136\169",
	["cup"] ="\226\136\170",
	["int"] ="\226\136\171",
	["there4"] ="\226\136\180",
	["sim"] ="\226\136\188",
	["cong"] ="\226\137\133",
	["asymp"] ="\226\137\136",
	["ne"] ="\226\137\160",
	["equiv"] ="\226\137\161",
	["le"] ="\226\137\164",
	["ge"] ="\226\137\165",
	["sub"] ="\226\138\130",
	["sup"] ="\226\138\131",
	["nsub"] ="\226\138\132",
	["sube"] ="\226\138\134",
	["supe"] ="\226\138\135",
	["oplus"] ="\226\138\149",
	["otimes"] ="\226\138\151",
	["perp"] ="\226\138\165",
	["sdot"] ="\226\139\133",
	["lceil"] ="\226\140\136",
	["rceil"] ="\226\140\137",
	["lfloor"] ="\226\140\138",
	["rfloor"] ="\226\140\139",
	["lang"] ="\226\140\169",
	["rang"] ="\226\140\170",
	["loz"] ="\226\151\138",
	["spades"] ="\226\153\160",
	["clubs"] ="\226\153\163",
	["hearts"] ="\226\153\165",
	["diams"] ="\226\153\166"}
	
local function entityReplace(name)
	local value = htmlEntities[name];
	if value then
		return value
		end
	return "&"..name..";"
	end
	
function decodeHtmlEntities(html)
	html = string.gsub(html, "&(%a%a?%a?%a?%a?%a?%a?%a?);", entityReplace)
	return html
end