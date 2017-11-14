--GunRotate script infectado servidor
--Maniacos server
--by luffynando
--test 55

Fields={}
ChangeInterval = 30;
GlobalCurrentGun = ""
PassedTime = 0
GameEnded = false;
Prematch= true;
Active=false;
NextPrimary = ""
PrimaryFullName = ""
Secondary = "iw5_p99_mp_akimbo_xmags"
i=1
j=1

ControlledKillstreaks = {
			"killstreak_predator_missile_mp",
			"killstreak_remote_tank_remote_mp",
			"killstreak_remote_turret_remote_mp",
			"heli_remote_mp",
			"ac130_105mm_mp",
			"ac130_40mm_mp",
			"ac130_25mm_mp",
			"mortar_remote_mp",
			"mortar_remote_zoom_mp"
}

GunNames= {}
function guns()
			GunNames["acr"]= "ACR 6.8"
			GunNames["type95"]="Type 95"
			GunNames["m4"]="M4A1"
			GunNames["ak47"]="AK-47"
			GunNames["m16"]="M16A4"
			GunNames["mk14"]="MK14"
			GunNames["g36c"]="G36C"
			GunNames["scar"]="SCAR-L"
			GunNames["fad"]="FAD"
			GunNames["cm901"]="CM 901"
			GunNames["mp5"]="MP5"
			GunNames["p90"]="P90"
			GunNames["pp90m1"]="PP90M1"
			GunNames["ump45"]="UMP45"
			GunNames["mp7"]="MP7"
			GunNames["m9"]="PM9"
			GunNames["spas12"]="SPAS-12"
			GunNames["aa12"]="AA-12"
			GunNames["striker"]="Striker"
			GunNames["1887"]="Model 1887"
			GunNames["usas12"]="USAS-12"
			GunNames["ksg"]="KSG-12"
			GunNames["m60"]="M60E4"
			GunNames["mk46"]="MK46"
			GunNames["pecheneg"]="PKP Pecheneg"
			GunNames["sa80"]="L86 LSW"
			GunNames["mg36"]="MG36"
			GunNames["barrett"]="Barrett M82"
			GunNames["msr"]="MSR"
			GunNames["rsass"]="RSASS"
			GunNames["dragunov"]="SVD Dragunov"
			GunNames["as50"]= "AS50"
			GunNames["l96a1"]="L118A"
			GunNames["usp45"]="USP .45"
			GunNames["mp412"]="MP412"
			GunNames["44magnum"]=".44 Magnum"
			GunNames["deserteagle"]="Desert Eagle"
			GunNames["p99"]= "P99"
			GunNames["fnfiveseven"]= "Five SeveN"
			GunNames["fmg9"]="FMG 9"
			GunNames["g18"]="G18"
			GunNames["mp9"]="MP9"
			GunNames["skorpion"]="Skorpion"
			GunNames["rpg"]="RPG-7"
			GunNames["javelin"]="Javelin"
			GunNames["smaw"]="SMAW"
			GunNames["m320"]="M320 GLM"
			GunNames["xm25"]="XM25"
end

guns()

Weapons = {}
Attachments = {}
DefaultSniperScopes = {}
AttachmentExclusions = {}
Camouflages = {}
SniperSights = {}
SniperRifles = {}
ReticuleSights = {}
Reticles = {}

local function has_value (tab, val)
    for index, value in ipairs(tab) do
        if value == val then
            return true
        end
    end

    return false
end

function setField(player,valor)
	Fields[player:getentitynumber()] = valor;
end

function getField(player)
	return Fields[player:getentitynumber()];
end

function hasField(player)
	return Fields[player:getentitynumber()] ~= nil
end

function onPlayerConnected(player)
	if (Active) then
		setField(player,0);
		player:setperk("specialty_fastreload", true, false);
		player:setperk("specialty_quickswap", true, false);
	end
end

function onNotify(args)
	if Active  then
		if args == "game_over" then
			callbacks.afterDelay.add(2000,function()GameEnded = true;
				Prematch=true;
				Active=false; end)
		end
		if args == "prematch_done" then 
			if (GameEnded) then 
				return;
			end
			RandomizeGuns();
			PassedTime=0;
			Prematch=false;
		end
	end
end

function GunRotation()
	local gametype = gsc.getdvar("g_gametype")
	if gametype ~= "infect" then
		GameEnded = true;
		Prematch = true;
		Active= false;
		callbacks.afterDelay.add(3000,function() print("Gametype no es infectado, quitando"); gsc.iprintln("Gametype no es infectado, ^3GunRotation ^7desabilitado") end)
		return true;
	end
	local grsecondary= gsc.getdvar("gr_secondary")
	if grsecondary ~= "" then
		Secondary = grsecondary;
	end
	local grinterval = gsc.getdvar("gr_interval")
	if grinterval ~= "" then
		if not tonumber(grinterval) then
			callbacks.afterDelay.add(3000,function() print("Custom intervalo invalido, usando default(30s)") end)
		elseif (tonumber(grinterval) < 15) then
			callbacks.afterDelay.add(3000,function() print("Intervalo de cambio no puede ser menor a 15.Usando default(30s)") end)
		else
			ChangeInterval = tonumber(grinterval);
		end
	end
	Fields= nil
	Fields={}
	GlobalCurrentGun = ""
	PassedTime = 0
	NextPrimary = ""
	PrimaryFullName = ""
	GameEnded=false;
	Prematch=true;
	Active=true;
	callbacks.afterDelay.add(3000,function() gsc.iprintln("^3GunRotate 0.2 ^7by ^;Luffynando") print("GunRotation cargado") end)
end

function GetGunName(FullName)
    FullName = FullName:gsub("iw5_","");
    local key = FullName:split('_')[1];
    return GunNames[key];
end

function messTable(tabs)
local aux= tabs[1]
for k in pairs(tabs) do
if k ~= 1 then
    tabs[k-1]= tabs[k]
end
end
tabs[#tabs]=aux
end

function RandomizeGuns()
    i=i+1000
    math.randomseed(os.time()+i)
    local num = math.random(2)
    if (num == 1) then
        NextPrimary = Weapons["Primaries"][math.random(#Weapons["Primaries"])]
    else
        NextPrimary = Weapons["Secondaries"][math.random(#Weapons["Secondaries"])]
    end
    PrimaryFullName = NextPrimary
    PrimaryFullName = PrimaryFullName.."_mp"
    local num2 = math.random(1,3)
    if ((num2 > 1) and (#Attachments[NextPrimary] ~= 0))then 
        if ((num2 == 3) and (#Attachments[NextPrimary] == 2))then
            num2 = 2
        end
        local text = Attachments[NextPrimary][math.random(#Attachments[NextPrimary])]
        local text2 = "";
        PrimaryFullName = PrimaryFullName.."_"..text;
        if (num2 == 3) then
            repeat
                messTable(Attachments[NextPrimary])
                text2 = Attachments[NextPrimary][1]
            until (has_value(AttachmentExclusions[text],text2) == false)
            PrimaryFullName = PrimaryFullName.."_"..text2
        end
        if (has_value(SniperRifles,NextPrimary) and has_value(SniperSights,text) == false and has_value(SniperSights,text2) == false) then 
            PrimaryFullName = PrimaryFullName.."_"..DefaultSniperScopes[NextPrimary]
        end
        if (num == 1) then
            local text3 = Camouflages[math.random(#Camouflages)]
            if (text3 ~= "none")then 
                PrimaryFullName = PrimaryFullName.."_"..text3
            end
        end
        if (has_value(ReticuleSights,text) or  has_value(ReticuleSights,text2)) then
            local text4 = Reticles[math.random(#Reticles)];
            if (text4 ~= "none")then
                PrimaryFullName = PrimaryFullName.."_"..text4;
                return;
            end
        end
    elseif (has_value(SniperRifles,NextPrimary)) then 
        PrimaryFullName = PrimaryFullName.."_"..DefaultSniperScopes[NextPrimary];
    end
end

function HadGunsRotated(player)
    return hasField(player) and (getField(player) ~= 0)
end

function HasGun(player,gun)
    return player:hasweapon(gun) ~= 0
end

function AddStuff()
    Weapons["Primaries"] = {}
    table.insert(Weapons["Primaries"],"iw5_acr");
    table.insert(Weapons["Primaries"],"iw5_type95");
    table.insert(Weapons["Primaries"],"iw5_m4");
    table.insert(Weapons["Primaries"],"iw5_ak47");
    table.insert(Weapons["Primaries"],"iw5_m16");
    table.insert(Weapons["Primaries"],"iw5_mk14");
    table.insert(Weapons["Primaries"],"iw5_g36c");
    table.insert(Weapons["Primaries"],"iw5_scar");
    table.insert(Weapons["Primaries"],"iw5_fad");
    table.insert(Weapons["Primaries"],"iw5_cm901");
    table.insert(Weapons["Primaries"],"iw5_mp5");
    table.insert(Weapons["Primaries"],"iw5_p90");
    table.insert(Weapons["Primaries"],"iw5_m9");
    table.insert(Weapons["Primaries"],"iw5_pp90m1");
    table.insert(Weapons["Primaries"],"iw5_ump45");
    table.insert(Weapons["Primaries"],"iw5_mp7");
    table.insert(Weapons["Primaries"],"iw5_spas12");
    table.insert(Weapons["Primaries"],"iw5_aa12");
    table.insert(Weapons["Primaries"],"iw5_striker");
    table.insert(Weapons["Primaries"],"iw5_1887");
    table.insert(Weapons["Primaries"],"iw5_usas12");
    table.insert(Weapons["Primaries"],"iw5_ksg");
    table.insert(Weapons["Primaries"],"iw5_m60");
    table.insert(Weapons["Primaries"],"iw5_mk46");
    table.insert(Weapons["Primaries"],"iw5_pecheneg");
    table.insert(Weapons["Primaries"],"iw5_sa80");
    table.insert(Weapons["Primaries"],"iw5_mg36");
    table.insert(Weapons["Primaries"],"iw5_barrett");
    table.insert(Weapons["Primaries"],"iw5_msr");
    table.insert(Weapons["Primaries"],"iw5_rsass");
    table.insert(Weapons["Primaries"],"iw5_dragunov");
    table.insert(Weapons["Primaries"],"iw5_as50");
    table.insert(Weapons["Primaries"],"iw5_l96a1");
    Weapons["Secondaries"]= {}
    table.insert(Weapons["Secondaries"],"iw5_usp45");
    table.insert(Weapons["Secondaries"],"iw5_mp412");
    table.insert(Weapons["Secondaries"],"iw5_44magnum");
    table.insert(Weapons["Secondaries"],"iw5_deserteagle");
    table.insert(Weapons["Secondaries"],"iw5_p99");
    table.insert(Weapons["Secondaries"],"iw5_fnfiveseven");
    table.insert(Weapons["Secondaries"],"iw5_fmg9");
    table.insert(Weapons["Secondaries"],"iw5_g18");
    table.insert(Weapons["Secondaries"],"iw5_mp9");
    table.insert(Weapons["Secondaries"],"iw5_skorpion");
    table.insert(Weapons["Secondaries"],"rpg");
    table.insert(Weapons["Secondaries"],"javelin");
    table.insert(Weapons["Secondaries"],"iw5_smaw");
    table.insert(Weapons["Secondaries"],"m320");
    table.insert(Weapons["Secondaries"],"xm25");
    Attachments["iw5_acr"]= {}
    table.insert(Attachments["iw5_acr"],"reflex");
    table.insert(Attachments["iw5_acr"],"silencer");
    table.insert(Attachments["iw5_acr"],"m320");
    table.insert(Attachments["iw5_acr"],"acog");
    table.insert(Attachments["iw5_acr"],"heartbeat");
    table.insert(Attachments["iw5_acr"],"eotech");
    table.insert(Attachments["iw5_acr"],"shotgun");
    table.insert(Attachments["iw5_acr"],"hybrid");
    table.insert(Attachments["iw5_acr"],"xmags");
    table.insert(Attachments["iw5_acr"],"thermal");
    Attachments["iw5_type95"]= {}
    table.insert(Attachments["iw5_type95"],"reflex");
    table.insert(Attachments["iw5_type95"],"silencer");
    table.insert(Attachments["iw5_type95"],"m320");
    table.insert(Attachments["iw5_type95"],"acog");
    table.insert(Attachments["iw5_type95"],"rof");
    table.insert(Attachments["iw5_type95"],"heartbeat");
    table.insert(Attachments["iw5_type95"],"eotech");
    table.insert(Attachments["iw5_type95"],"shotgun");
    table.insert(Attachments["iw5_type95"],"hybrid");
    table.insert(Attachments["iw5_type95"],"xmags");
    table.insert(Attachments["iw5_type95"],"thermal");
    Attachments["iw5_m4"] ={}
    table.insert(Attachments["iw5_m4"],"reflex");
    table.insert(Attachments["iw5_m4"],"silencer");
    table.insert(Attachments["iw5_m4"],"gl");
    table.insert(Attachments["iw5_m4"],"acog");
    table.insert(Attachments["iw5_m4"],"heartbeat");
    table.insert(Attachments["iw5_m4"],"eotech");
    table.insert(Attachments["iw5_m4"],"shotgun");
    table.insert(Attachments["iw5_m4"],"hybrid");
    table.insert(Attachments["iw5_m4"],"xmags");
    table.insert(Attachments["iw5_m4"],"thermal");
    Attachments["iw5_ak47"]={}
    table.insert(Attachments["iw5_ak47"],"reflex");
    table.insert(Attachments["iw5_ak47"],"silencer");
    table.insert(Attachments["iw5_ak47"],"gp25");
    table.insert(Attachments["iw5_ak47"],"acog");
    table.insert(Attachments["iw5_ak47"],"heartbeat");
    table.insert(Attachments["iw5_ak47"],"eotech");
    table.insert(Attachments["iw5_ak47"],"shotgun");
    table.insert(Attachments["iw5_ak47"],"hybrid");
    table.insert(Attachments["iw5_ak47"],"xmags");
    table.insert(Attachments["iw5_ak47"],"thermal");
    Attachments["iw5_m16"]={}
    table.insert(Attachments["iw5_m16"],"reflex");
    table.insert(Attachments["iw5_m16"],"silencer");
    table.insert(Attachments["iw5_m16"],"gl");
    table.insert(Attachments["iw5_m16"],"acog");
    table.insert(Attachments["iw5_m16"],"rof");
    table.insert(Attachments["iw5_m16"],"heartbeat");
    table.insert(Attachments["iw5_m16"],"eotech");
    table.insert(Attachments["iw5_m16"],"shotgun");
    table.insert(Attachments["iw5_m16"],"hybrid");
    table.insert(Attachments["iw5_m16"],"xmags");
    table.insert(Attachments["iw5_m16"],"thermal");
    Attachments["iw5_mk14"]={}
    table.insert(Attachments["iw5_mk14"],"reflex");
    table.insert(Attachments["iw5_mk14"],"silencer");
    table.insert(Attachments["iw5_mk14"],"gl");
    table.insert(Attachments["iw5_mk14"],"acog");
    table.insert(Attachments["iw5_mk14"],"rof");
    table.insert(Attachments["iw5_mk14"],"heartbeat");
    table.insert(Attachments["iw5_mk14"],"eotech");
    table.insert(Attachments["iw5_mk14"],"shotgun");
    table.insert(Attachments["iw5_mk14"],"hybrid");
    table.insert(Attachments["iw5_mk14"],"xmags");
    table.insert(Attachments["iw5_mk14"],"thermal");
    table.insert(Attachments["iw5_mk14"],"rof");
    Attachments["iw5_g36c"]={}
    table.insert(Attachments["iw5_g36c"],"reflex");
    table.insert(Attachments["iw5_g36c"],"silencer");
    table.insert(Attachments["iw5_g36c"],"m320");
    table.insert(Attachments["iw5_g36c"],"acog");
    table.insert(Attachments["iw5_g36c"],"heartbeat");
    table.insert(Attachments["iw5_g36c"],"eotech");
    table.insert(Attachments["iw5_g36c"],"shotgun");
    table.insert(Attachments["iw5_g36c"],"hybrid");
    table.insert(Attachments["iw5_g36c"],"xmags");
    table.insert(Attachments["iw5_g36c"],"thermal");
    Attachments["iw5_scar"]={}
    table.insert(Attachments["iw5_scar"],"reflex");
    table.insert(Attachments["iw5_scar"],"silencer");
    table.insert(Attachments["iw5_scar"],"m320");
    table.insert(Attachments["iw5_scar"],"acog");
    table.insert(Attachments["iw5_scar"],"heartbeat");
    table.insert(Attachments["iw5_scar"],"eotech");
    table.insert(Attachments["iw5_scar"],"shotgun");
    table.insert(Attachments["iw5_scar"],"hybrid");
    table.insert(Attachments["iw5_scar"],"xmags");
    table.insert(Attachments["iw5_scar"],"thermal");
    Attachments["iw5_fad"]={}
    table.insert(Attachments["iw5_fad"],"reflex");
    table.insert(Attachments["iw5_fad"],"silencer");
    table.insert(Attachments["iw5_fad"],"m320");
    table.insert(Attachments["iw5_fad"],"acog");
    table.insert(Attachments["iw5_fad"],"heartbeat");
    table.insert(Attachments["iw5_fad"],"eotech");
    table.insert(Attachments["iw5_fad"],"shotgun");
    table.insert(Attachments["iw5_fad"],"hybrid");
    table.insert(Attachments["iw5_fad"],"xmags");
    table.insert(Attachments["iw5_fad"],"thermal");
    Attachments["iw5_cm901"]={}
    table.insert(Attachments["iw5_cm901"],"reflex");
    table.insert(Attachments["iw5_cm901"],"silencer");
    table.insert(Attachments["iw5_cm901"],"m320");
    table.insert(Attachments["iw5_cm901"],"acog");
    table.insert(Attachments["iw5_cm901"],"heartbeat");
    table.insert(Attachments["iw5_cm901"],"eotech");
    table.insert(Attachments["iw5_cm901"],"shotgun");
    table.insert(Attachments["iw5_cm901"],"hybrid");
    table.insert(Attachments["iw5_cm901"],"xmags");
    table.insert(Attachments["iw5_cm901"],"thermal");
    Attachments["iw5_mp5"]={}
    table.insert(Attachments["iw5_mp5"],"reflexsmg");
    table.insert(Attachments["iw5_mp5"],"silencer");
    table.insert(Attachments["iw5_mp5"],"rof");
    table.insert(Attachments["iw5_mp5"],"acogsmg");
    table.insert(Attachments["iw5_mp5"],"eotechsmg");
    table.insert(Attachments["iw5_mp5"],"hamrhybrid");
    table.insert(Attachments["iw5_mp5"],"xmags");
    table.insert(Attachments["iw5_mp5"],"thermalsmg");
    Attachments["iw5_p90"]={}
    table.insert(Attachments["iw5_p90"],"reflexsmg");
    table.insert(Attachments["iw5_p90"],"silencer");
    table.insert(Attachments["iw5_p90"],"rof");
    table.insert(Attachments["iw5_p90"],"acogsmg");
    table.insert(Attachments["iw5_p90"],"eotechsmg");
    table.insert(Attachments["iw5_p90"],"hamrhybrid");
    table.insert(Attachments["iw5_p90"],"xmags");
    table.insert(Attachments["iw5_p90"],"thermalsmg");
    Attachments["iw5_m9"]={}
    table.insert(Attachments["iw5_m9"],"reflexsmg");
    table.insert(Attachments["iw5_m9"],"silencer");
    table.insert(Attachments["iw5_m9"],"rof");
    table.insert(Attachments["iw5_m9"],"acogsmg");
    table.insert(Attachments["iw5_m9"],"eotechsmg");
    table.insert(Attachments["iw5_m9"],"hamrhybrid");
    table.insert(Attachments["iw5_m9"],"xmags");
    table.insert(Attachments["iw5_m9"],"thermalsmg");
    Attachments["iw5_pp90m1"]={}
    table.insert(Attachments["iw5_pp90m1"],"reflexsmg");
    table.insert(Attachments["iw5_pp90m1"],"silencer");
    table.insert(Attachments["iw5_pp90m1"],"rof");
    table.insert(Attachments["iw5_pp90m1"],"acogsmg");
    table.insert(Attachments["iw5_pp90m1"],"eotechsmg");
    table.insert(Attachments["iw5_pp90m1"],"hamrhybrid");
    table.insert(Attachments["iw5_pp90m1"],"xmags");
    table.insert(Attachments["iw5_pp90m1"],"thermalsmg");
    Attachments["iw5_ump45"]={}
    table.insert(Attachments["iw5_ump45"],"reflexsmg");
    table.insert(Attachments["iw5_ump45"],"silencer");
    table.insert(Attachments["iw5_ump45"],"rof");
    table.insert(Attachments["iw5_ump45"],"acogsmg");
    table.insert(Attachments["iw5_ump45"],"eotechsmg");
    table.insert(Attachments["iw5_ump45"],"hamrhybrid");
    table.insert(Attachments["iw5_ump45"],"xmags");
    table.insert(Attachments["iw5_ump45"],"thermalsmg");
    Attachments["iw5_mp7"]={}
    table.insert(Attachments["iw5_mp7"],"reflexsmg");
    table.insert(Attachments["iw5_mp7"],"silencer");
    table.insert(Attachments["iw5_mp7"],"rof");
    table.insert(Attachments["iw5_mp7"],"acogsmg");
    table.insert(Attachments["iw5_mp7"],"eotechsmg");
    table.insert(Attachments["iw5_mp7"],"hamrhybrid");
    table.insert(Attachments["iw5_mp7"],"xmags");
    table.insert(Attachments["iw5_mp7"],"thermalsmg");
    Attachments["iw5_spas12"]={}
    table.insert(Attachments["iw5_spas12"],"grip");
    table.insert(Attachments["iw5_spas12"],"reflex");
    table.insert(Attachments["iw5_spas12"],"eotech");
    table.insert(Attachments["iw5_spas12"],"xmags");
    table.insert(Attachments["iw5_spas12"],"silencer03");
    Attachments["iw5_aa12"]={}
    table.insert(Attachments["iw5_aa12"],"grip");
    table.insert(Attachments["iw5_aa12"],"reflex");
    table.insert(Attachments["iw5_aa12"],"eotech");
    table.insert(Attachments["iw5_aa12"],"xmags");
    table.insert(Attachments["iw5_aa12"],"silencer03");
    Attachments["iw5_striker"]={}
    table.insert(Attachments["iw5_striker"],"grip");
    table.insert(Attachments["iw5_striker"],"reflex");
    table.insert(Attachments["iw5_striker"],"eotech");
    table.insert(Attachments["iw5_striker"],"xmags");
    table.insert(Attachments["iw5_striker"],"silencer03");
    Attachments["iw5_1887"]={}
    Attachments["iw5_usas12"]={}
    table.insert(Attachments["iw5_usas12"],"grip");
    table.insert(Attachments["iw5_usas12"],"reflex");
    table.insert(Attachments["iw5_usas12"],"eotech");
    table.insert(Attachments["iw5_usas12"],"xmags");
    table.insert(Attachments["iw5_usas12"],"silencer03");
    Attachments["iw5_ksg"]={}
    table.insert(Attachments["iw5_ksg"],"grip");
    table.insert(Attachments["iw5_ksg"],"reflex");
    table.insert(Attachments["iw5_ksg"],"eotech");
    table.insert(Attachments["iw5_ksg"],"xmags");
    table.insert(Attachments["iw5_ksg"],"silencer03");
    Attachments["iw5_m60"]={}
    table.insert(Attachments["iw5_m60"],"reflexlmg");
    table.insert(Attachments["iw5_m60"],"silencer");
    table.insert(Attachments["iw5_m60"],"grip");
    table.insert(Attachments["iw5_m60"],"acog");
    table.insert(Attachments["iw5_m60"],"rof");
    table.insert(Attachments["iw5_m60"],"eotechlmg");
    table.insert(Attachments["iw5_m60"],"xmags");
    table.insert(Attachments["iw5_m60"],"thermal");
    Attachments["iw5_mk46"]={}
    table.insert(Attachments["iw5_mk46"],"reflexlmg");
    table.insert(Attachments["iw5_mk46"],"silencer");
    table.insert(Attachments["iw5_mk46"],"grip");
    table.insert(Attachments["iw5_mk46"],"acog");
    table.insert(Attachments["iw5_mk46"],"rof");
    table.insert(Attachments["iw5_mk46"],"heartbeat");
    table.insert(Attachments["iw5_mk46"],"eotechlmg");
    table.insert(Attachments["iw5_mk46"],"xmags");
    table.insert(Attachments["iw5_mk46"],"thermal");
    Attachments["iw5_pecheneg"]={}
    table.insert(Attachments["iw5_pecheneg"],"reflexlmg");
    table.insert(Attachments["iw5_pecheneg"],"silencer");
    table.insert(Attachments["iw5_pecheneg"],"grip");
    table.insert(Attachments["iw5_pecheneg"],"acog");
    table.insert(Attachments["iw5_pecheneg"],"rof");
    table.insert(Attachments["iw5_pecheneg"],"eotechlmg");
    table.insert(Attachments["iw5_pecheneg"],"xmags");
    table.insert(Attachments["iw5_pecheneg"],"thermal");
    Attachments["iw5_sa80"]={}
    table.insert(Attachments["iw5_sa80"],"reflexlmg");
    table.insert(Attachments["iw5_sa80"],"silencer");
    table.insert(Attachments["iw5_sa80"],"grip");
    table.insert(Attachments["iw5_sa80"],"acog");
    table.insert(Attachments["iw5_sa80"],"rof");
    table.insert(Attachments["iw5_sa80"],"heartbeat");
    table.insert(Attachments["iw5_sa80"],"eotechlmg");
    table.insert(Attachments["iw5_sa80"],"xmags");
    table.insert(Attachments["iw5_sa80"],"thermal");
    Attachments["iw5_mg36"]={}
    table.insert(Attachments["iw5_mg36"],"reflexlmg");
    table.insert(Attachments["iw5_mg36"],"silencer");
    table.insert(Attachments["iw5_mg36"],"grip");
    table.insert(Attachments["iw5_mg36"],"acog");
    table.insert(Attachments["iw5_mg36"],"rof");
    table.insert(Attachments["iw5_mg36"],"heartbeat");
    table.insert(Attachments["iw5_mg36"],"eotechlmg");
    table.insert(Attachments["iw5_mg36"],"xmags");
    table.insert(Attachments["iw5_mg36"],"thermal");
    Attachments["iw5_barrett"]={}
    table.insert(Attachments["iw5_barrett"],"acog");
    table.insert(Attachments["iw5_barrett"],"heartbeat");
    table.insert(Attachments["iw5_barrett"],"xmags");
    table.insert(Attachments["iw5_barrett"],"thermal");
    table.insert(Attachments["iw5_barrett"],"barrettscopevz");
    table.insert(Attachments["iw5_barrett"],"silencer03");
    Attachments["iw5_msr"]={}
    table.insert(Attachments["iw5_msr"],"acog");
    table.insert(Attachments["iw5_msr"],"heartbeat");
    table.insert(Attachments["iw5_msr"],"xmags");
    table.insert(Attachments["iw5_msr"],"thermal");
    table.insert(Attachments["iw5_msr"],"msrscopevz");
    table.insert(Attachments["iw5_msr"],"silencer03");
    Attachments["iw5_rsass"]={}
    table.insert(Attachments["iw5_rsass"],"acog");
    table.insert(Attachments["iw5_rsass"],"heartbeat");
    table.insert(Attachments["iw5_rsass"],"xmags");
    table.insert(Attachments["iw5_rsass"],"thermal");
    table.insert(Attachments["iw5_rsass"],"rsassscopevz");
    table.insert(Attachments["iw5_rsass"],"silencer03");
    Attachments["iw5_dragunov"]={}
    table.insert(Attachments["iw5_dragunov"],"acog");
    table.insert(Attachments["iw5_dragunov"],"heartbeat");
    table.insert(Attachments["iw5_dragunov"],"xmags");
    table.insert(Attachments["iw5_dragunov"],"thermal");
    table.insert(Attachments["iw5_dragunov"],"dragunovscopevz");
    table.insert(Attachments["iw5_dragunov"],"silencer03");
    Attachments["iw5_as50"]={}
    table.insert(Attachments["iw5_as50"],"acog");
    table.insert(Attachments["iw5_as50"],"heartbeat");
    table.insert(Attachments["iw5_as50"],"xmags");
    table.insert(Attachments["iw5_as50"],"thermal");
    table.insert(Attachments["iw5_as50"],"as50scopevz");
    table.insert(Attachments["iw5_as50"],"silencer03");
    Attachments["iw5_l96a1"]={}
    table.insert(Attachments["iw5_l96a1"],"acog");
    table.insert(Attachments["iw5_l96a1"],"heartbeat");
    table.insert(Attachments["iw5_l96a1"],"xmags");
    table.insert(Attachments["iw5_l96a1"],"thermal");
    table.insert(Attachments["iw5_l96a1"],"l96a1scopevz");
    table.insert(Attachments["iw5_l96a1"],"silencer03");
    Attachments["iw5_usp45"]={}
    table.insert(Attachments["iw5_usp45"],"silencer02");
    table.insert(Attachments["iw5_usp45"],"akimbo");
    table.insert(Attachments["iw5_usp45"],"tactical");
    table.insert(Attachments["iw5_usp45"],"xmags");
    Attachments["iw5_mp412"]={}
    table.insert(Attachments["iw5_mp412"],"akimbo");
    table.insert(Attachments["iw5_mp412"],"tactical");
    Attachments["iw5_44magnum"]={}
    table.insert(Attachments["iw5_44magnum"],"akimbo");
    table.insert(Attachments["iw5_44magnum"],"tactical");
    Attachments["iw5_deserteagle"]={}
    table.insert(Attachments["iw5_deserteagle"],"akimbo");
    table.insert(Attachments["iw5_deserteagle"],"tactical");
    Attachments["iw5_p99"]={}
    table.insert(Attachments["iw5_p99"],"silencer02");
    table.insert(Attachments["iw5_p99"],"akimbo");
    table.insert(Attachments["iw5_p99"],"tactical");
    table.insert(Attachments["iw5_p99"],"xmags");
    Attachments["iw5_fnfiveseven"]={}
    table.insert(Attachments["iw5_fnfiveseven"],"silencer02");
    table.insert(Attachments["iw5_fnfiveseven"],"akimbo");
    table.insert(Attachments["iw5_fnfiveseven"],"tactical");
    table.insert(Attachments["iw5_fnfiveseven"],"xmags");
    Attachments["iw5_fmg9"]={}
    table.insert(Attachments["iw5_fmg9"],"silencer02");
    table.insert(Attachments["iw5_fmg9"],"akimbo");
    table.insert(Attachments["iw5_fmg9"],"reflexsmg");
    table.insert(Attachments["iw5_fmg9"],"xmags");
    Attachments["iw5_g18"]={}
    table.insert(Attachments["iw5_g18"],"silencer02");
    table.insert(Attachments["iw5_g18"],"akimbo");
    table.insert(Attachments["iw5_g18"],"reflexsmg");
    table.insert(Attachments["iw5_g18"],"xmags");
    Attachments["iw5_mp9"]={}
    table.insert(Attachments["iw5_mp9"],"silencer02");
    table.insert(Attachments["iw5_mp9"],"akimbo");
    table.insert(Attachments["iw5_mp9"],"reflexsmg");
    table.insert(Attachments["iw5_mp9"],"xmags");
    Attachments["iw5_skorpion"]={}
    table.insert(Attachments["iw5_skorpion"],"silencer02");
    table.insert(Attachments["iw5_skorpion"],"akimbo");
    table.insert(Attachments["iw5_skorpion"],"reflexsmg");
    table.insert(Attachments["iw5_skorpion"],"xmags");
    Attachments["rpg"]={}
    Attachments["javelin"]={}
    Attachments["iw5_smaw"]={}
    Attachments["m320"]={}
    Attachments["xm25"]={}
    AttachmentExclusions["reflex"]={}
    table.insert(AttachmentExclusions["reflex"],"reflex");
    table.insert(AttachmentExclusions["reflex"],"acog");
    table.insert(AttachmentExclusions["reflex"],"thermal");
    table.insert(AttachmentExclusions["reflex"],"eotech");
    table.insert(AttachmentExclusions["reflex"],"vzscope");
    table.insert(AttachmentExclusions["reflex"],"hamrhybrid");
    table.insert(AttachmentExclusions["reflex"],"hybrid");
    AttachmentExclusions["reflexsmg"]={}
    table.insert(AttachmentExclusions["reflexsmg"],"reflexsmg");
    table.insert(AttachmentExclusions["reflexsmg"],"acogsmg");
    table.insert(AttachmentExclusions["reflexsmg"],"thermalsmg");
    table.insert(AttachmentExclusions["reflexsmg"],"eotechsmg");
    table.insert(AttachmentExclusions["reflexsmg"],"vzscope");
    table.insert(AttachmentExclusions["reflexsmg"],"hamrhybrid");
    table.insert(AttachmentExclusions["reflexsmg"],"hybrid");
    table.insert(AttachmentExclusions["reflexsmg"],"akimbo");
    AttachmentExclusions["reflexlmg"]={}
    table.insert(AttachmentExclusions["reflexlmg"],"reflexlmg");
    table.insert(AttachmentExclusions["reflexlmg"],"acog");
    table.insert(AttachmentExclusions["reflexlmg"],"thermal");
    table.insert(AttachmentExclusions["reflexlmg"],"eotechlmg");
    table.insert(AttachmentExclusions["reflexlmg"],"vzscope");
    table.insert(AttachmentExclusions["reflexlmg"],"hamrhybrid");
    table.insert(AttachmentExclusions["reflexlmg"],"hybrid");
    AttachmentExclusions["silencer"]={}
    table.insert(AttachmentExclusions["silencer"],"silencer");
    table.insert(AttachmentExclusions["silencer"],"silencer02");
    table.insert(AttachmentExclusions["silencer"],"silencer03");
    table.insert(AttachmentExclusions["silencer"],"akimbo");
    AttachmentExclusions["silencer02"]={}
    table.insert(AttachmentExclusions["silencer02"],"silencer");
    table.insert(AttachmentExclusions["silencer02"],"silencer02");
    table.insert(AttachmentExclusions["silencer02"],"silencer03");
    table.insert(AttachmentExclusions["silencer02"],"akimbo");
    AttachmentExclusions["silencer03"]={}
    table.insert(AttachmentExclusions["silencer03"],"silencer");
    table.insert(AttachmentExclusions["silencer03"],"silencer02");
    table.insert(AttachmentExclusions["silencer03"],"silencer03akimbo");
    AttachmentExclusions["acog"]={}
    table.insert(AttachmentExclusions["acog"],"acog");
    table.insert(AttachmentExclusions["acog"],"reflex");
    table.insert(AttachmentExclusions["acog"],"thermal");
    table.insert(AttachmentExclusions["acog"],"eotech");
    table.insert(AttachmentExclusions["acog"],"vzscope");
    table.insert(AttachmentExclusions["acog"],"hamrhybrid");
    table.insert(AttachmentExclusions["acog"],"hybrid");
    table.insert(AttachmentExclusions["acog"],"akimbo");
    AttachmentExclusions["acogsmg"]={}
    table.insert(AttachmentExclusions["acogsmg"],"acogsmg");
    table.insert(AttachmentExclusions["acogsmg"],"reflexsmg");
    table.insert(AttachmentExclusions["acogsmg"],"thermalsmg");
    table.insert(AttachmentExclusions["acogsmg"],"eotechsmg");
    table.insert(AttachmentExclusions["acogsmg"],"vzscope");
    table.insert(AttachmentExclusions["acogsmg"],"hamrhybrid");
    table.insert(AttachmentExclusions["acogsmg"],"hybrid");
    table.insert(AttachmentExclusions["acogsmg"],"akimbo");
    AttachmentExclusions["grip"]={}
    table.insert(AttachmentExclusions["grip"],"grip");
    AttachmentExclusions["akimbo"]={}
    table.insert(AttachmentExclusions["akimbo"],"akimbo");
    table.insert(AttachmentExclusions["akimbo"],"acog");
    table.insert(AttachmentExclusions["akimbo"],"acogsmg");
    table.insert(AttachmentExclusions["akimbo"],"reflex");
    table.insert(AttachmentExclusions["akimbo"],"reflexsmg");
    table.insert(AttachmentExclusions["akimbo"],"thermal");
    table.insert(AttachmentExclusions["akimbo"],"thermalsmg");
    table.insert(AttachmentExclusions["akimbo"],"eotech");
    table.insert(AttachmentExclusions["akimbo"],"vzscope");
    table.insert(AttachmentExclusions["akimbo"],"hamrhybrid");
    table.insert(AttachmentExclusions["akimbo"],"hybrid");
    table.insert(AttachmentExclusions["akimbo"],"tactical");
    table.insert(AttachmentExclusions["akimbo"],"silencer");
    table.insert(AttachmentExclusions["akimbo"],"silencer02");
    table.insert(AttachmentExclusions["akimbo"],"silencer03");
    AttachmentExclusions["thermal"]={}
    table.insert(AttachmentExclusions["thermal"],"akimbo");
    table.insert(AttachmentExclusions["thermal"],"acog");
    table.insert(AttachmentExclusions["thermal"],"reflex");
    table.insert(AttachmentExclusions["thermal"],"thermal");
    table.insert(AttachmentExclusions["thermal"],"eotech");
    table.insert(AttachmentExclusions["thermal"],"vzscope");
    table.insert(AttachmentExclusions["thermal"],"hamrhybrid");
    table.insert(AttachmentExclusions["thermal"],"hybrid");
    AttachmentExclusions["thermalsmg"]={}
    table.insert(AttachmentExclusions["thermalsmg"],"akimbo");
    table.insert(AttachmentExclusions["thermalsmg"],"acogsmg");
    table.insert(AttachmentExclusions["thermalsmg"],"reflexsmg");
    table.insert(AttachmentExclusions["thermalsmg"],"thermalsmg");
    table.insert(AttachmentExclusions["thermalsmg"],"eotechsmg");
    table.insert(AttachmentExclusions["thermalsmg"],"vzscope");
    table.insert(AttachmentExclusions["thermalsmg"],"hamrhybrid");
    table.insert(AttachmentExclusions["thermalsmg"],"hybrid");
    AttachmentExclusions["shotgun"]={}
    table.insert(AttachmentExclusions["shotgun"],"gl");
    table.insert(AttachmentExclusions["shotgun"],"gp25");
    table.insert(AttachmentExclusions["shotgun"],"m320");
    table.insert(AttachmentExclusions["shotgun"],"shotgun");
    AttachmentExclusions["heartbeat"]={}
    table.insert(AttachmentExclusions["heartbeat"],"heartbeat");
    AttachmentExclusions["xmags"]={}
    table.insert(AttachmentExclusions["xmags"],"xmags");
    AttachmentExclusions["rof"]={}
    table.insert(AttachmentExclusions["rof"],"rof");
    AttachmentExclusions["eotech"]={}
    table.insert(AttachmentExclusions["eotech"],"acog");
    table.insert(AttachmentExclusions["eotech"],"reflex");
    table.insert(AttachmentExclusions["eotech"],"thermal");
    table.insert(AttachmentExclusions["eotech"],"eotech");
    table.insert(AttachmentExclusions["eotech"],"vzscope");
    table.insert(AttachmentExclusions["eotech"],"hamrhybrid");
    table.insert(AttachmentExclusions["eotech"],"hybrid");
    AttachmentExclusions["eotechsmg"]={}
    table.insert(AttachmentExclusions["eotechsmg"],"acogsmg");
    table.insert(AttachmentExclusions["eotechsmg"],"reflexsmg");
    table.insert(AttachmentExclusions["eotechsmg"],"thermalsmg");
    table.insert(AttachmentExclusions["eotechsmg"],"eotechsmg");
    table.insert(AttachmentExclusions["eotechsmg"],"vzscope");
    table.insert(AttachmentExclusions["eotechsmg"],"hamrhybrid");
    table.insert(AttachmentExclusions["eotechsmg"],"hybrid");
    AttachmentExclusions["eotechlmg"]={}
    table.insert(AttachmentExclusions["eotechlmg"],"acog");
    table.insert(AttachmentExclusions["eotechlmg"],"reflexlmg");
    table.insert(AttachmentExclusions["eotechlmg"],"thermal");
    table.insert(AttachmentExclusions["eotechlmg"],"eotechlmg");
    table.insert(AttachmentExclusions["eotechlmg"],"vzscope");
    table.insert(AttachmentExclusions["eotechlmg"],"hamrhybrid");
    table.insert(AttachmentExclusions["eotechlmg"],"hybrid");
    AttachmentExclusions["tactical"]={}
    table.insert(AttachmentExclusions["tactical"],"tactical");
    table.insert(AttachmentExclusions["tactical"],"akimbo");
    AttachmentExclusions["barrettscopevz"]={}
    table.insert(AttachmentExclusions["barrettscopevz"],"acog");
    table.insert(AttachmentExclusions["barrettscopevz"],"reflex");
    table.insert(AttachmentExclusions["barrettscopevz"],"thermal");
    table.insert(AttachmentExclusions["barrettscopevz"],"eotech");
    table.insert(AttachmentExclusions["barrettscopevz"],"barrettscopevz");
    table.insert(AttachmentExclusions["barrettscopevz"],"hamrhybrid");
    table.insert(AttachmentExclusions["barrettscopevz"],"hybrid");
    AttachmentExclusions["as50scopevz"]={}
    table.insert(AttachmentExclusions["as50scopevz"],"acog");
    table.insert(AttachmentExclusions["as50scopevz"],"reflex");
    table.insert(AttachmentExclusions["as50scopevz"],"thermal");
    table.insert(AttachmentExclusions["as50scopevz"],"eotech");
    table.insert(AttachmentExclusions["as50scopevz"],"as50scopevz");
    table.insert(AttachmentExclusions["as50scopevz"],"hamrhybrid");
    table.insert(AttachmentExclusions["as50scopevz"],"hybrid");
    AttachmentExclusions["l96a1scopevz"]={}
    table.insert(AttachmentExclusions["l96a1scopevz"],"acog");
    table.insert(AttachmentExclusions["l96a1scopevz"],"reflex");
    table.insert(AttachmentExclusions["l96a1scopevz"],"thermal");
    table.insert(AttachmentExclusions["l96a1scopevz"],"eotech");
    table.insert(AttachmentExclusions["l96a1scopevz"],"l96a1scopevz");
    table.insert(AttachmentExclusions["l96a1scopevz"],"hamrhybrid");
    table.insert(AttachmentExclusions["l96a1scopevz"],"hybrid");
    AttachmentExclusions["msrscopevz"] ={}
    table.insert(AttachmentExclusions["msrscopevz"],"acog");
    table.insert(AttachmentExclusions["msrscopevz"],"reflex");
    table.insert(AttachmentExclusions["msrscopevz"],"thermal");
    table.insert(AttachmentExclusions["msrscopevz"],"eotech");
    table.insert(AttachmentExclusions["msrscopevz"],"msrscopevz");
    table.insert(AttachmentExclusions["msrscopevz"],"hamrhybrid");
    table.insert(AttachmentExclusions["msrscopevz"],"hybrid");
    AttachmentExclusions["dragunovscopevz"]={}
    table.insert(AttachmentExclusions["dragunovscopevz"],"acog");
    table.insert(AttachmentExclusions["dragunovscopevz"],"reflex");
    table.insert(AttachmentExclusions["dragunovscopevz"],"thermal");
    table.insert(AttachmentExclusions["dragunovscopevz"],"eotech");
    table.insert(AttachmentExclusions["dragunovscopevz"],"dragunovscopevz");
    table.insert(AttachmentExclusions["dragunovscopevz"],"hamrhybrid");
    table.insert(AttachmentExclusions["dragunovscopevz"],"hybrid");
    AttachmentExclusions["rsassscopevz"]={}
    table.insert(AttachmentExclusions["rsassscopevz"],"acog");
    table.insert(AttachmentExclusions["rsassscopevz"],"reflex");
    table.insert(AttachmentExclusions["rsassscopevz"],"thermal");
    table.insert(AttachmentExclusions["rsassscopevz"],"eotech");
    table.insert(AttachmentExclusions["rsassscopevz"],"rsassscopevz");
    table.insert(AttachmentExclusions["rsassscopevz"],"hamrhybrid");
    table.insert(AttachmentExclusions["rsassscopevz"],"hybrid");
    AttachmentExclusions["hamrhybrid"]={}
    table.insert(AttachmentExclusions["hamrhybrid"],"acog");
    table.insert(AttachmentExclusions["hamrhybrid"],"reflex");
    table.insert(AttachmentExclusions["hamrhybrid"],"thermal");
    table.insert(AttachmentExclusions["hamrhybrid"],"thermalsmg");
    table.insert(AttachmentExclusions["hamrhybrid"],"eotech");
    table.insert(AttachmentExclusions["hamrhybrid"],"vzscope");
    table.insert(AttachmentExclusions["hamrhybrid"],"hamrhybrid");
    table.insert(AttachmentExclusions["hamrhybrid"],"hybrid");
    table.insert(AttachmentExclusions["hamrhybrid"],"reflexsmg");
    table.insert(AttachmentExclusions["hamrhybrid"],"eotechsmg");
    AttachmentExclusions["hybrid"]={}
    table.insert(AttachmentExclusions["hybrid"],"acog");
    table.insert(AttachmentExclusions["hybrid"],"reflex");
    table.insert(AttachmentExclusions["hybrid"],"thermal");
    table.insert(AttachmentExclusions["hybrid"],"eotech");
    table.insert(AttachmentExclusions["hybrid"],"vzscope");
    table.insert(AttachmentExclusions["hybrid"],"hamrhybrid");
    table.insert(AttachmentExclusions["hybrid"],"hybrid");
    AttachmentExclusions["gl"]={}
    table.insert(AttachmentExclusions["gl"],"gl");
    table.insert(AttachmentExclusions["gl"],"gp25");
    table.insert(AttachmentExclusions["gl"],"m320");
    table.insert(AttachmentExclusions["gl"],"shotgun");
    AttachmentExclusions["gp25"]={}
    table.insert(AttachmentExclusions["gp25"],"gl");
    table.insert(AttachmentExclusions["gp25"],"gp25");
    table.insert(AttachmentExclusions["gp25"],"m320");
    table.insert(AttachmentExclusions["gp25"],"shotgun");
    AttachmentExclusions["m320"]={}
    table.insert(AttachmentExclusions["m320"],"gl");
    table.insert(AttachmentExclusions["m320"],"gp25");
    table.insert(AttachmentExclusions["m320"],"m320");
    table.insert(AttachmentExclusions["m320"],"shotgun");
    table.insert(ReticuleSights,"relfex");
    table.insert(ReticuleSights,"reflexsmgs");
    table.insert(ReticuleSights,"acog");
    table.insert(ReticuleSights,"eotech");
    table.insert(ReticuleSights,"reflexlmg");
    table.insert(ReticuleSights,"reflexsmg");
    table.insert(ReticuleSights,"eotechsmg");
    table.insert(ReticuleSights,"eotechlmg");
    table.insert(ReticuleSights,"acogsmg");
    table.insert(ReticuleSights,"thermalsmg");
    table.insert(SniperSights,"barrettscopevz");
    table.insert(SniperSights,"as50scopevz");
    table.insert(SniperSights,"l96a1scopevz");
    table.insert(SniperSights,"msrscopevz");
    table.insert(SniperSights,"dragunovscopevz");
    table.insert(SniperSights,"rsassscopevz");
    table.insert(SniperSights,"acog");
    table.insert(SniperSights,"thermal");
    table.insert(SniperRifles,"iw5_barrett");
    table.insert(SniperRifles,"iw5_as50");
    table.insert(SniperRifles,"iw5_l96a1");
    table.insert(SniperRifles,"iw5_msr");
    table.insert(SniperRifles,"iw5_rsass");
    table.insert(SniperRifles,"iw5_dragunov");
    table.insert(Camouflages,"none");
    table.insert(Camouflages,"camo01");
    table.insert(Camouflages,"camo02");
    table.insert(Camouflages,"camo03");
    table.insert(Camouflages,"camo04");
    table.insert(Camouflages,"camo05");
    table.insert(Camouflages,"camo06");
    table.insert(Camouflages,"camo07");
    table.insert(Camouflages,"camo08");
    table.insert(Camouflages,"camo09");
    table.insert(Camouflages,"camo10");
    table.insert(Camouflages,"camo11");
    table.insert(Camouflages,"camo12");
    table.insert(Camouflages,"camo13");
    table.insert(Reticles,"none");
    table.insert(Reticles,"scope1");
    table.insert(Reticles,"scope2");
    table.insert(Reticles,"scope3");
    table.insert(Reticles,"scope4");
    table.insert(Reticles,"scope5");
    table.insert(Reticles,"scope6");
    DefaultSniperScopes["iw5_barrett"]="barrettscope";
    DefaultSniperScopes["iw5_as50"]="as50scope";
    DefaultSniperScopes["iw5_l96a1"]="l96a1scope";
    DefaultSniperScopes["iw5_msr"]="msrscope";
    DefaultSniperScopes["iw5_dragunov"]="dragunovscope";
    DefaultSniperScopes["iw5_rsass"]="rsassscope";
end

AddStuff();

callbacks.afterDelay.add(100, GunRotation)
callbacks.preGameInit.add(GunRotation)
callbacks.onInterval.add(1000,function()
	if (GameEnded or Prematch) then 
		return;
	end
	PassedTime = PassedTime + 1
	if ((PassedTime % ChangeInterval) == 0) then 
		PassedTime = 0
		for p in util.iterPlayers() do
			if (p.sessionteam == "allies" and has_value(ControlledKillstreaks,p:getcurrentweapon())==false) then
				if (HadGunsRotated(p) == false )then
					p:setperk("specialty_fastreload", true, false);
					p:setperk("specialty_quickswap", true, false);
					p:takeAllWeapons()
				else
					p:takeWeapon(GlobalCurrentGun)
					p:takeWeapon(Secondary)
					if (HasGun(p, "iw5_usp45jugg_mp") and HasGun(p, "iw5_riotshieldjugg_mp")) then 
						p:takeWeapon("iw5_usp45jugg_mp");
						p:takeWeapon("iw5_riotshieldjugg_mp");
						p:setperk("specialty_fastreload", true, false);
						p:setperk("specialty_quickswap", true, false);
					end
					if (HasGun(p, "iw5_m60jugg_mp") and HasGun(p, "iw5_mp412jugg_mp")) then
						p:takeWeapon("iw5_m60jugg_mp");
						p:takeWeapon("iw5_mp412jugg_mp");
						p:setperk("specialty_fastreload", true, false);
						p:setperk("specialty_quickswap", true, false);
					end
					if (HasGun(p, "iw5_g36c_mp_m320_reflex") and HasGun(p, "iw5_pp90m1_mp")) then
						p:takeWeapon("iw5_g36c_mp_m320_reflex");
						p:takeWeapon("iw5_pp90m1_mp");
						p:setperk("specialty_fastreload", true, false);
						p:setperk("specialty_quickswap", true, false);
					end
				end
				p:giveWeapon(PrimaryFullName);
				p:giveWeapon(Secondary);
				p:giveMaxAmmo(PrimaryFullName)
				p:giveMaxAmmo(Secondary)
				p:switchToWeaponImmediate(PrimaryFullName)
				setField(p,1);
			end
		end
		GlobalCurrentGun = PrimaryFullName
		local flag =true
		local fla = true
		repeat
			RandomizeGuns();
			flag= PrimaryFullName == Secondary;
			fla = string.find(GetGunName(GlobalCurrentGun),GetGunName(PrimaryFullName));
		until(flag == false or fla == nil )
		i=1
		j=1
	end
end)
callbacks.playerConnected.add(onPlayerConnected)
callbacks.levelNotify.add(onNotify)