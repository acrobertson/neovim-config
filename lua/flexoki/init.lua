-- Adapted from
-- https://github.com/kepano/flexoki-neovim
-- https://github.com/cpplain/flexoki.nvim
-- MIT License

local M = {}

-- Flexoki palette
local p = {}

-- Base
p.black = "#100F0F"
p.base950 = "#1C1B1A"
p.base900 = "#282726"
p.base850 = "#343331"
p.base800 = "#403E3C"
p.base700 = "#575653"
p.base600 = "#6F6E69"
p.base500 = "#878580"
p.base400 = "#9F9D96"
p.base300 = "#B7B5AC"
p.base200 = "#CECDC3"
p.base150 = "#DAD8CE"
p.base100 = "#E6E4D9"
p.base50 = "#F2F0E5"
p.paper = "#FFFCF0"

-- Red
p.red950 = "#261312"
p.red900 = "#3E1715"
p.red850 = "#551B18"
p.red800 = "#6C201C"
p.red700 = "#942822"
p.red600 = "#AF3029"
p.red500 = "#C03E35"
p.red400 = "#D14D41"
p.red300 = "#E8705F"
p.red200 = "#F89A8A"
p.red150 = "#FDB2A2"
p.red100 = "#FFCABB"
p.red50 = "#FFE1D5"

-- Orange
p.orange950 = "#27180E"
p.orange900 = "#40200D"
p.orange850 = "#59290D"
p.orange800 = "#71320D"
p.orange700 = "#9D4310"
p.orange600 = "#BC5215"
p.orange500 = "#CB6120"
p.orange400 = "#DA702C"
p.orange300 = "#EC8B49"
p.orange200 = "#F9AE77"
p.orange150 = "#FCC192"
p.orange100 = "#FED3AF"
p.orange50 = "#FFE7CE"

-- Yellow
p.yellow950 = "#241E08"
p.yellow900 = "#3A2D04"
p.yellow850 = "#503D02"
p.yellow800 = "#664D01"
p.yellow700 = "#8E6B01"
p.yellow600 = "#AD8301"
p.yellow500 = "#BE9207"
p.yellow400 = "#D0A215"
p.yellow300 = "#DFB431"
p.yellow200 = "#ECCB60"
p.yellow150 = "#F1D67E"
p.yellow100 = "#F6E2A0"
p.yellow50 = "#FAEEC6"

-- Green
p.green950 = "#1A1E0C"
p.green900 = "#252D09"
p.green850 = "#313D07"
p.green800 = "#3D4C07"
p.green700 = "#536907"
p.green600 = "#66800B"
p.green500 = "#768D21"
p.green400 = "#879A39"
p.green300 = "#A0AF54"
p.green200 = "#BEC97E"
p.green150 = "#CDD597"
p.green100 = "#DDE2B2"
p.green50 = "#EDEECF"

-- Cyan
p.cyan950 = "#101F1D"
p.cyan900 = "#122F2C"
p.cyan850 = "#143F3C"
p.cyan800 = "#164F4A"
p.cyan700 = "#1C6C66"
p.cyan600 = "#24837B"
p.cyan500 = "#2F968D"
p.cyan400 = "#3AA99F"
p.cyan300 = "#5ABDAC"
p.cyan200 = "#87D3C3"
p.cyan150 = "#A2DECE"
p.cyan100 = "#BFE8D9"
p.cyan50 = "#DDF1E4"

-- Blue
p.blue950 = "#101A24"
p.blue900 = "#12253B"
p.blue850 = "#133051"
p.blue800 = "#163B66"
p.blue700 = "#1A4F8C"
p.blue600 = "#205EA6"
p.blue500 = "#3171B2"
p.blue400 = "#4385BE"
p.blue300 = "#66A0C8"
p.blue200 = "#92BFDB"
p.blue150 = "#ABCFE2"
p.blue100 = "#C6DDE8"
p.blue50 = "#E1ECEB"

-- Purple
p.purple950 = "#1A1623"
p.purple900 = "#261C39"
p.purple850 = "#31234E"
p.purple800 = "#3C2A62"
p.purple700 = "#4F3685"
p.purple600 = "#5E409D"
p.purple500 = "#735EB5"
p.purple400 = "#8B7EC8"
p.purple300 = "#A699D0"
p.purple200 = "#C4B9E0"
p.purple150 = "#D3CAE6"
p.purple100 = "#E2D9E9"
p.purple50 = "#F0EAEC"

-- Magenta
p.magenta950 = "#24131D"
p.magenta900 = "#39172B"
p.magenta850 = "#4F1B39"
p.magenta800 = "#641F46"
p.magenta700 = "#87285E"
p.magenta600 = "#A02F6F"
p.magenta500 = "#B74583"
p.magenta400 = "#CE5D97"
p.magenta300 = "#E47DA8"
p.magenta200 = "#F4A4C2"
p.magenta150 = "#F9B9CF"
p.magenta100 = "#FCCFDA"
p.magenta50 = "#FEE4E5"

-- Theme colors
local c = {}

if vim.o.background == "dark" then
	-- Dark theme
	c.bg = p.black
	c.bg2 = p.base950
	c.ui = p.base900
	c.ui2 = p.base850
	c.ui3 = p.base800
	c.tx = p.base200
	c.tx2 = p.base400
	c.tx3 = p.base600
	c.red = p.red400
	c.red2 = p.red600
	c.red3 = p.red800
	c.red4 = p.red900
	c.orange = p.orange400
	c.orange2 = p.orange600
	c.orange3 = p.orange800
	c.orange4 = p.orange900
	c.yellow = p.yellow400
	c.yellow2 = p.yellow600
	c.yellow3 = p.yellow800
	c.yellow4 = p.yellow900
	c.green = p.green400
	c.green2 = p.green600
	c.green3 = p.green800
	c.green4 = p.green900
	c.cyan = p.cyan400
	c.cyan2 = p.cyan600
	c.cyan3 = p.cyan800
	c.cyan4 = p.cyan900
	c.blue = p.blue400
	c.blue2 = p.blue600
	c.blue3 = p.blue800
	c.blue4 = p.blue900
	c.purple = p.purple400
	c.purple2 = p.purple600
	c.purple3 = p.purple800
	c.purple4 = p.purple900
	c.magenta = p.magenta400
	c.magenta2 = p.magenta600
	c.magenta3 = p.magenta800
	c.magenta4 = p.magenta900
else
	-- Light theme
	c.bg = p.paper
	c.bg2 = p.base50
	c.ui = p.base100
	c.ui2 = p.base150
	c.ui3 = p.base200
	c.tx = p.base800
	c.tx2 = p.base600
	c.tx3 = p.base400
	c.red = p.red600
	c.red2 = p.red400
	c.red3 = p.red200
	c.red4 = p.red100
	c.orange = p.orange600
	c.orange2 = p.orange400
	c.orange3 = p.orange200
	c.orange4 = p.orange100
	c.yellow = p.yellow600
	c.yellow2 = p.yellow400
	c.yellow3 = p.yellow200
	c.yellow4 = p.yellow100
	c.green = p.green600
	c.green2 = p.green400
	c.green3 = p.green200
	c.green4 = p.green100
	c.cyan = p.cyan600
	c.cyan2 = p.cyan400
	c.cyan3 = p.cyan200
	c.cyan4 = p.cyan100
	c.blue = p.blue600
	c.blue2 = p.blue400
	c.blue3 = p.blue200
	c.blue4 = p.blue100
	c.purple = p.purple600
	c.purple2 = p.purple400
	c.purple3 = p.purple200
	c.purple4 = p.purple100
	c.magenta = p.magenta600
	c.magenta2 = p.magenta400
	c.magenta3 = p.magenta200
	c.magenta4 = p.magenta100
end

M.p = p
M.c = c

return M
