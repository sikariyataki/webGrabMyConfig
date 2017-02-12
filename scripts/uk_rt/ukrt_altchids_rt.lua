require("XGUI_Lib")

local function Pass1Func(grabber,channel)
	XGUI.SetStatus(2,"Processing "..XGUI_Lib.XS.Val(channel.Name))
	channel.XML_ID=channel.ID
	return channel
	end

PostProcs.UK_RT_ALT_RT={
	Name = "UK - Radio Times Standard Channel IDS",
	Version = "1.00.00",
	Author = "Alan Birtles",
	InfoURL = "http://www.birtles.org.uk/xmltv/wiki/index.php?title=UK_RT_Alt_RT",
	Grabber = "UK_RT",
	Passes={
		Pass1={
			Type=XGUI.PassTypes.Channel,
			Func=Pass1Func,
			},
		},
	}
