
local addon,ns = ...;
local L = ns.L;
local _G,string,tonumber,rawset,type = _G,string,tonumber,rawset,type

--== colorized print ==--
do
	local colors = {"20b0ff","00ff00","ff6060","44ffff","ffff00","ff8800","ff44ff","ffffff"};

	local function colorize(...)
		local t,c,a1 = {tostringall(...)},1,...;
		if type(a1)=="boolean" then tremove(t,1); end
		if a1~=false then
			tinsert(t,1,"|cff"..colors[1]..((a1==true and ns.addon_short) or (a1=="||" and "||") or addon).."|r"..(a1~="||" and HEADER_COLON or ""));
			c=2;
		end
		for i=c, #t do
			if not t[i]:find("\124c") then
				t[i],c = "|cff"..colors[c]..t[i].."|r", c<#colors and c+1 or 1;
			end
		end
		return unpack(t);
	end

	function ns.print(...)
		print(colorize(...));
	end

	function ns.debug(name,...)
		ConsolePrint(date("|cff999999%X|r"),colorize("<debug>",...));
	end
end

--== pairs function ==--
do
	local function invert(a,b)
		return a>b;
	end

	function ns.pairsByKeys(t, f)
		local a = {}
		for n in pairs(t) do
			tinsert(a, n)
		end
		if f==true then
			f = invert;
		end
		tsort(a, f)
		local i = 0      -- iterator variable
		local function iter()   -- iterator function
			i = i + 1
			if a[i] == nil then
				return nil
			else
				return a[i], t[a[i]]
			end
			return a[i], t[a[i]]
		end
		return iter
	end
end

--== shared credits page ==--
do
	local supporter = {
		-- localizations
		{name="Nelfym",Locale="frFR",AFK_fullscreen=true},
		{name="pczombie09",Locale="koKR",AFK_fullscreen=true},
		{name="KARMA_Zz",Locale="ruRU",AFK_fullscreen=true},
		{name="BNS333",Locale="zhTW",AFK_fullscreen=true},
		{name="ZamestoTV",Locale="ruRU",AuctionSellers=true,CommunityInfo=true,GatherMate2_ImportExport=true,LFR_of_the_past=true,StayClassy=true},
		{name="Bullseiify",Locale="deDE",Broker_Everything=true,FarmHud=true,GuildApplicantTracker=true,FollowerLocationInfo=true,TooltipRealmInfo=true},
		{name="Nierhain",Locale="deDE",Broker_Everything=true},
		{name="Braincell1980",Locale="frFR",Broker_Everything=true,LFR_of_the_past=true},
		{name="netaras",Locale="koKR",Broker_Everything=true,FarmHud=true},
		{name="적셔줄게",Locale="koKR",Broker_Everything=true},
		{name="cikichen",Locale="zhCN,zhTW",Broker_Everything=true},
		{name="sanxy00",Locale="zhCN",Broker_Everything=true},
		{name="雪夜霜刀",Locale="zhCN",Broker_Everything=true},
		{name="半熟魷魚 ",Locale="zhTW",Broker_Everything=true},
		{name="Lightuky",Locale="frFR",CommunityInfo=true},
		{name="TomasRipley",Locale="ruRU",CommunityInfo=true},
		{name="Dathwada",Locale="deDE",FarmHud=true},
		{name="supahmexman",Locale="esES",FarmHud=true},
		{name="justregular16 ",Locale="esMX",FarmHud=true},
		{name="Zickwik",Locale="frFR",FarmHud=true},
		{name="oxscott",Locale="itIT",FarmHud=true},
		{name="g0ldenev1l",Locale="zhCN",FarmHud=true},
		{name="mccma",Locale="zhTW",FarmHud=true},
		{name="Tumbleweed_DSA",Locale="deDE",FollowerLocationInfo=true},
		{name="Dabeuliou",Locale="frFR",FollowerLocationInfo=true},
		{name="unrealcrom96",Locale="koKR",FollowerLocationInfo=true},
		{name="Canettieri",Locale="ptBR",FollowerLocationInfo=true},
		{name="dropdb",Locale="ruRU",FollowerLocationInfo=true},
		{name="Igara86",Locale="ruRU",FollowerLocationInfo=true},
		{name="Ananhaid",Locale="zhCN",FollowerLocationInfo=true},

	};

	local function AddSupporter(info)
		local section = strsplit("_",info[#info]);
		local names = {};
		for _, entry in ipairs(supporter)do
			if entry[addon] and entry[section] then
				local name = entry.name;
				if type(entry[section])=="string" then
					name = name .. "("..entry[section]..")"; -- add color?
				end
				table.insert(names,name);
			end
		end
		return table.concat(names,", ");
	end

	local function IsSectionVisible(info)
		local section = strsplit("_",info[#info]);
		for _, entry in ipairs(supporter)do
			if entry[addon] and entry[section] then
				return false;
			end
		end
		return true;
	end

	local credits = {
		type = "group",
		name = "Credits",
		args = {
			support_Header = { type = "header",      order = 200, hidden = IsSectionVisible, name = "" },
			support        = { type = "description", order = 201, fontSize="large", name = "Thanks @ all supporter." },
			Github_Header  = { type = "header",      order = 202, hidden = IsSectionVisible, name = "Github" },
			Github         = { type = "description", order = 203, hidden = IsSectionVisible, name = AddSupporter, fontSize="medium" },
			Patreon_Header = { type = "header",      order = 204, hidden = IsSectionVisible, name = "Patreon" },
			Patreon        = { type = "description", order = 205, hidden = IsSectionVisible, name = AddSupporter, fontSize="medium" },
			Paypal_Header  = { type = "header",      order = 206, hidden = IsSectionVisible, name = "Paypal" },
			Paypal         = { type = "description", order = 207, hidden = IsSectionVisible, name = AddSupporter, fontSize="medium" },
			Locale_Header  = { type = "header",      order = 208, hidden = IsSectionVisible, name = "Localizations" },
			Locale         = { type = "description", order = 209, hidden = IsSectionVisible, name = AddSupporter, fontSize="medium" },
		}
	};

	function ns.AddCredits(creditSection)
		if type(creditSection)=="table" then
			Mixin(creditSection,credits.args);
		else
			-- add own sub option table
			LibStub("AceConfigRegistry-3.0"):RegisterOptionsTable(addon.."/Credits", credits);
			LibStub("AceConfigDialog-3.0"):AddToBlizOptions(addon.."/Credits", "Credits", addon);
		end
	end
end

--
