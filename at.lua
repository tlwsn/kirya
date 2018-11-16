local Matrix3X3 = require 'matrix3x3'
local Vector3D = require 'vector3d'
funcsStatus = {Inv = false, AirBrk = false, ClickWarp = false}
tick = {ClickWarp = 0}
----------------------------------------
local memory = require 'memory'
local res, key = pcall(require, 'vkeys')
assert(res, 'not found vkeys')
---
local res, sp = pcall(require, 'lib.samp.events')
assert(res, 'not found lib.samp.events')
---
local res, imgui = pcall(require, 'imgui')
assert(res, 'not found imgui')
---
local res, inicfg = pcall(require, 'inicfg')
assert(res, 'not found inicfg')
---
local encoding = require 'encoding'
encoding.default = 'CP1251'
u8 = encoding.UTF8
show = 1
local ffi = require 'ffi'
----------------------------------------
local mainmenu = imgui.ImBool(false)
local tpmenu = imgui.ImBool(false)
local setwin = imgui.ImBool(false)
local mpwinb = imgui.ImBool(false)
----------------------------------------
mpnazv = ''
mpsposr = ''
mppriz = ''
mpwin = ''
mpzak = false
----------------------------------------
PlayersNickname = {}
local BulletSync = {lastId = 0, maxLines = 15}
for i = 1, BulletSync.maxLines do
	BulletSync[i] = {enable = true, o = {x, y, z}, t = {x, y, z}, time = 0, tType = 0}
end
function sampGetPlayerID(PlayerName)
    for i = 0, 999 do
        if PlayerName == PlayersNickname[i] then
            return i
        end
    end
end
function getPlayersNickname()
    for i = 0, 999 do
        if sampIsPlayerConnected(i) then
            PlayersNickname[i] = sampGetPlayerNickname(i)
        end
    end
end
----------------------------------------
function ftext(name)
    sampAddChatMessage(" "..name, 0xAAAAAAAA)
end
local atcfg = {
    main = {
        pass = 'pass',
        apass = 'apass',
        passb = false,
        apassb = false,
        AirBrkSpd = 0.5,
        speedhackspd = 150.0
    }
}
cfg = inicfg.load(nil, 'AdminTools/config.ini')
if cfg == nil then
    ftext("Отсутсвует файл конфига, создаем.", -1)
    if inicfg.save(cfg, 'AdminTools/config.ini') then
        ftext("Файл конфига успешно создан.", -1)
        cfg = inicfg.load(nil, 'AdminTools/config.ini')
    end
end
local libs = {
   ["utf8data.lua"] = 'https://raw.githubusercontent.com/WhackerH/kirya/master/lib/utf8data.lua',
    ['utf8.lua'] = 'https://raw.githubusercontent.com/WhackerH/kirya/master/lib/utf8.lua',
    ['ssl.lua'] = 'https://raw.githubusercontent.com/WhackerH/kirya/master/lib/ssl.lua',
    ['ssl.dll'] = 'https://raw.githubusercontent.com/WhackerH/kirya/master/lib/ssl.dll',
    ['socket.lua'] = 'https://raw.githubusercontent.com/WhackerH/kirya/master/lib/socket.lua',
    ['requests.lua'] = 'https://raw.githubusercontent.com/WhackerH/kirya/master/lib/requests.lua',
    ['mime.lua'] = 'https://raw.githubusercontent.com/WhackerH/kirya/master/lib/mime.lua',
    ['md5.lua'] = 'https://raw.githubusercontent.com/WhackerH/kirya/master/lib/md5.lua',
    ['lua2json.lua'] = 'https://raw.githubusercontent.com/WhackerH/kirya/master/lib/lua2json.lua',
    ['ltn12.lua'] = 'https://raw.githubusercontent.com/WhackerH/kirya/master/lib/ltn12.lua',
    ['lfs.dll'] = 'https://raw.githubusercontent.com/WhackerH/kirya/master/lib/lfs.dll',
    ['lanes.lua'] = 'https://raw.githubusercontent.com/WhackerH/kirya/master/lib/lanes.lua',
    ['json2lua.lua'] = 'https://raw.githubusercontent.com/WhackerH/kirya/master/lib/lanes.lua',
    ['des56.dll'] = 'https://raw.githubusercontent.com/WhackerH/kirya/master/lib/des56.dll',
    ['cjson.dll'] = 'https://raw.githubusercontent.com/WhackerH/kirya/master/lib/cjson.dll',
    ['base64.dll'] = 'https://raw.githubusercontent.com/WhackerH/kirya/master/lib/base64.dll',
    ['xml/Parser.lua'] = 'https://raw.githubusercontent.com/WhackerH/kirya/master/lib/xml/Parser.lua',
    ['xml/core.dll'] = 'https://raw.githubusercontent.com/WhackerH/kirya/master/lib/xml/core.dll',
    ['xml/init.lua'] = 'https://raw.githubusercontent.com/WhackerH/kirya/master/lib/xml/init.lua',
    ['ssl/https.lua'] = 'https://raw.githubusercontent.com/WhackerH/kirya/master/lib/ssl/https.lua',
    ['socket/url.lua'] = 'https://raw.githubusercontent.com/WhackerH/kirya/master/lib/socket/url.lua',
    ['socket/tp.lua'] = 'https://raw.githubusercontent.com/WhackerH/kirya/master/lib/socket/tp.lua',
    ['socket/smtp.lua'] = 'https://raw.githubusercontent.com/WhackerH/kirya/master/lib/socket/smtp.lua',
    ['socket/http.lua'] = 'https://raw.githubusercontent.com/WhackerH/kirya/master/lib/socket/http.lua',
    ['socket/headers.lua'] = 'https://raw.githubusercontent.com/WhackerH/kirya/master/lib/socket/headers.lua',
    ['socket/ftp.lua'] = 'https://raw.githubusercontent.com/WhackerH/kirya/master/lib/socket/ftp.lua',
    ['socket/core.dll'] = 'https://raw.githubusercontent.com/WhackerH/kirya/master/lib/socket/core.dll',
    ['mime/core.dll'] = 'https://raw.githubusercontent.com/WhackerH/kirya/master/lib/mime/core.dll',
    ['md5/core.dll'] = 'https://raw.githubusercontent.com/WhackerH/kirya/master/lib/md5/core.dll',
    ['lub/init.lua'] = 'https://raw.githubusercontent.com/WhackerH/kirya/master/lib/lub/init.lua',
    ['lub/Template.lua'] = 'https://raw.githubusercontent.com/WhackerH/kirya/master/lib/lub/Template.lua',
    ['lub/Param.lua'] = 'https://raw.githubusercontent.com/WhackerH/kirya/master/lib/lub/Param.lua',
    ['lub/Dir.lua'] = 'https://raw.githubusercontent.com/WhackerH/kirya/master/lib/lub/Dir.lua',
    ['lub/Autoload.lua'] = 'https://raw.githubusercontent.com/WhackerH/kirya/master/lib/lub/Autoload.lua',
    ['lanes/core.dll'] = 'https://raw.githubusercontent.com/WhackerH/kirya/master/lib/lanes/core.dll',
    ['cjson/util.lua'] = 'https://raw.githubusercontent.com/WhackerH/kirya/master/lib/cjson/util.lua'
}
local gostp = {
    ['LSPD'] = '1544.1212158203, -1675.3117675781, 13.557789802551',
    ['SFPD'] = '-1606.0246582031, 719.93884277344, 12.054424285889',
    ['LVPD'] = '2333.9365234375, 2455.9772949219, 14.96875',
    ['FBI'] = '-2444.9887695313, 502.21490478516, 30.094774246216',
    ['Мэрия'] = '1478.6057128906, -1738.2475585938, 13.546875',
    ['Автошкола'] = '-2032.9953613281, -84.548896789551, 35.82837677002',
    ['Больница ЛС'] = '1188.3579101563, -1322.6630859375, 13.566570281982',
    ['Больница СФ'] = '-2664.5402832031, 634.74700927734, 14.453125',
    ['Больница ЛВ'] = '1606.6192626953, 1825.5887451172, 10.8203125',
    ['Больница ФК'] = '-318.11968994141, 1057.3933105469, 19.7421875',
    ['Rifa'] = '2184.4729003906, -1807.0772705078, 13.372615814209',
    ['Grove'] = '2492.5004882813, -1675.2270507813, 13.335947036743',
    ['Vagos'] = '2780.037109375, -1616.1085205078, 10.921875',
    ['Ballas'] = '2645.5832519531, -2009.6373291016, 13.5546875',
    ['Aztec'] = '1679.7568359375, -2112.7685546875, 13.546875',
    ['LCN'] = '1448.5999755859, 752.29913330078, 11.0234375',
    ['RM'] = '948.29113769531, 1732.6284179688, 8.8515625',
    ['Yakuza'] = '1462.0941162109, 2773.9204101563, 10.8203125',
    ['LVN'] = '2647.6062011719, 1182.9040527344, 10.8203125',
    ['SFN'] = '-2047.3449707031, 462.86468505859, 35.171875',
    ['LSN'] = '1658.7456054688, -1694.8518066406, 15.609375',
    ['Mongols'] = '682.31365966797, -478.36148071289, 16.3359375',
    ['Warlocks'] = '657.96783447266, 1724.9599609375, 6.9921875',
    ['Pagans'] = '-236.41778564453, 2602.8095703125, 62.703125',
    ['AVLS'] = '1154.2769775391, -1756.1109619141, 13.634266853333',
    ['AVSF'] = '-1985.5826416016, 137.61878967285, 27.6875',
    ['AVLV'] = '2838.7587890625, 1291.5477294922, 11.390625',
    ['FAMI'] = '2356.6359863281, 2377.3544921875, 10.8203125',
    ['4DR'] = '2030.9317626953, 1009.9556274414, 10.8203125',
    ['CAL'] = '2177.9311523438, 1676.1583251953, 10.8203125',
    ['LVA'] = '209.3503112793, 1916.1086425781, 17.640625',
    ['SFA'] = '-1335.8016357422, 471.39276123047, 7.1875',
    ['DALNO'] = '2358.2663574219, 2737.4006347656, 10.8203125',
    ['PEINT'] = '2586.6628417969, 2788.6235351563, 10.8203125',
    ['BJ'] = '1577.3891601563, -1331.9245605469, 16.484375',
    ['TAXI5'] = '2460.7641601563, 1339.7041015625, 10.8203125',
    ['GRUZ'] = '2191.8410644531, -2255.1296386719, 13.533205986023',
    ['HOTDOG'] = '-2462.2663574219, 717.34100341797, 35.009593963623',
    ['MEHSF'] = '-1915.9177246094, 286.88238525391, 41.046875',
    ['MEHLV'] = '2131.244140625, 954.09143066406, 10.8203125',
    ['MEHLS'] = '-87.400039672852, -1183.9016113281, 1.8439817428589',
    ['SKLDPR'] = '-495.78558349609, -486.47967529297, 25.517845153809'
}
local folders = {'cjson', 'lanes', 'lub', 'md5', 'mime', 'socket', 'ssl', 'xml'}
telephone = false
sborid = false
tpids = {}
ffi.cdef[[
struct stKillEntry
{
	char					szKiller[25];
	char					szVictim[25];
	uint32_t				clKillerColor; // D3DCOLOR
	uint32_t				clVictimColor; // D3DCOLOR
	uint8_t					byteType;
} __attribute__ ((packed));

struct stKillInfo
{
	int						iEnabled;
	struct stKillEntry		killEntry[5];
	int 					iLongestNickLength;
  	int 					iOffsetX;
  	int 					iOffsetY;
	void			    	*pD3DFont; // ID3DXFont
	void		    		*pWeaponFont1; // ID3DXFont
	void		   	    	*pWeaponFont2; // ID3DXFont
	void					*pSprite;
	void					*pD3DDevice;
	int 					iAuxFontInited;
    void 		    		*pAuxFont1; // ID3DXFont
    void 			    	*pAuxFont2; // ID3DXFont
} __attribute__ ((packed));
]]
function calcScreenCoors(fX,fY,fZ)
	local dwM = 0xB6FA2C

	local m_11 = memory.getfloat(dwM + 0*4)
	local m_12 = memory.getfloat(dwM + 1*4)
	local m_13 = memory.getfloat(dwM + 2*4)
	local m_21 = memory.getfloat(dwM + 4*4)
	local m_22 = memory.getfloat(dwM + 5*4)
	local m_23 = memory.getfloat(dwM + 6*4)
	local m_31 = memory.getfloat(dwM + 8*4)
	local m_32 = memory.getfloat(dwM + 9*4)
	local m_33 = memory.getfloat(dwM + 10*4)
	local m_41 = memory.getfloat(dwM + 12*4)
	local m_42 = memory.getfloat(dwM + 13*4)
	local m_43 = memory.getfloat(dwM + 14*4)

	local dwLenX = memory.read(0xC17044, 4)
	local dwLenY = memory.read(0xC17048, 4)

	frX = fZ * m_31 + fY * m_21 + fX * m_11 + m_41
	frY = fZ * m_32 + fY * m_22 + fX * m_12 + m_42
	frZ = fZ * m_33 + fY * m_23 + fX * m_13 + m_43

	fRecip = 1.0/frZ
	frX = frX * (fRecip * dwLenX)
	frY = frY * (fRecip * dwLenY)

    if(frX<=dwLenX and frY<=dwLenY and frZ>1)then
        return frX, frY, frZ
	else
		return -1, -1, -1
	end
end
function main()
    while not isSampAvailable() do wait(0) end
    kill = ffi.cast('struct stKillInfo*', sampGetKillInfoPtr())
    for i, fold in pairs(folders) do
        if not doesDirectoryExist('moonloader/lib/'..fold) then createDirectory('moonloader/lib/'..fold) 
            print('Создана папка '..fold)
        end
    end
    for lib, url in pairs(libs) do
        if not doesFileExist('moonloader/lib/'..lib) then
            downloadUrlToFile('https://raw.githubusercontent.com/WhackerH/kirya/master/lib/'..lib, getWorkingDirectory()..'\\lib\\'..lib)
            print('Загружается библиотека '..lib)
        end
    end
    lanes = require('lanes').configure()
    sampRegisterChatCommand('cip', cip)
    sampRegisterChatCommand('at', function() mainmenu.v = not mainmenu.v end)
    sampRegisterChatCommand('starttp', starttp)
    sampRegisterChatCommand('gcp', function() local posX, posY = getCursorPos()
        ftext(string.format("Координата X:%s | Координата Y:%s", posX, posY), -1)
    end)
    while not sampIsLocalPlayerSpawned() do wait(0) end
    --[[if cfg.main.apassb then
        sampSendChat('/alogin')
    end]]
    font = renderCreateFont('Verdana', 10, 9)
    font1 = renderCreateFont('Verdana', 6, 4)
    funcsStatus.Inv = true
    while true do wait(0)
        local isInVeh = isCharInAnyCar(playerPed)
        local veh = nil
        if isInVeh then veh = storeCarCharIsInNoSave(playerPed) end
        local oTime = os.time()
        if not isPauseMenuActive() then
			for i = 1, BulletSync.maxLines do
				if BulletSync[i].enable == true and BulletSync[i].time >= oTime then
					local sx, sy, sz = calcScreenCoors(BulletSync[i].o.x, BulletSync[i].o.y, BulletSync[i].o.z)
					local fx, fy, fz = calcScreenCoors(BulletSync[i].t.x, BulletSync[i].t.y, BulletSync[i].t.z)

					if sz > 1 and fz > 1 then
						renderDrawLine(sx, sy, fx, fy, 1, BulletSync[i].tType == 0 and 0xFFFFFFFF or 0xFFFFC700)
						renderDrawPolygon(fx, fy-1, 3, 3, 4.0, 10, BulletSync[i].tType == 0 and 0xFFFFFFFF or 0xFFFFC700)
					end
				end
			end
		end
        imgui.Process = mainmenu.v
        if sttp then
            for i,v in pairs(tpids) do 
                sampSendChat('/gethere '..v)
                wait(1200)
                table.remove(tpids, i)
            end
            if #tpids == 0 then
                ftext('Телепортация окончена')
                sttp = false
            end
        end
        check_keystrokes()
        main_funcs()
        fix_funcs()
        if not isSampfuncsConsoleActive() and not sampIsChatInputActive() and not sampIsDialogActive() and not isPauseMenuActive() then
            if isKeyJustPressed(key.VK_Z) and jID ~= nil then
                sampSendChat('/re '..jID)
            end
            if isKeyJustPressed(key.VK_X) and wID ~= nil then
                sampSendChat('/re '..wID)
            end
            if isKeyJustPressed(key.VK_B) then -- hop
                if isCharInAnyCar(playerPed) then
                    local cVecX, cVecY, cVecZ = getCarSpeedVector(storeCarCharIsInNoSave(playerPed))
                    if cVecZ < 7.0 then applyForceToCar(storeCarCharIsInNoSave(playerPed), 0.0, 0.0, 0.1, 0.0, 0.0, 0.0) end
                else
                    local pVecX, pVecY, pVecZ = getCharVelocity(playerPed)
                    if pVecZ < 7.0 then setCharVelocity(playerPed, 0.0, 0.0, 10.0) end
                end
            end
    
            if isKeyJustPressed(key.VK_BACK) and isCharInAnyCar(playerPed) then -- turn back
                local cVecX, cVecY, cVecZ = getCarSpeedVector(storeCarCharIsInNoSave(playerPed))
                applyForceToCar(storeCarCharIsInNoSave(playerPed), -cVecX / 25, -cVecY / 25, -cVecZ / 25, 0.0, 0.0, 0.0)
                local x, y, z, w = getVehicleQuaternion(storeCarCharIsInNoSave(playerPed))
                local matrix = {convertQuaternionToMatrix(w, x, y, z)}
                matrix[1] = -matrix[1]
                matrix[2] = -matrix[2]
                matrix[4] = -matrix[4]
                matrix[5] = -matrix[5]
                matrix[7] = -matrix[7]
                matrix[8] = -matrix[8]
                local w, x, y, z = convertMatrixToQuaternion(matrix[1], matrix[2], matrix[3], matrix[4], matrix[5], matrix[6], matrix[7], matrix[8], matrix[9])
                setVehicleQuaternion(storeCarCharIsInNoSave(playerPed), x, y, z, w)
            end
    
            if isKeyJustPressed(key.VK_N) and isCharInAnyCar(playerPed) then -- fast exit
                local posX, posY, posZ = getCarCoordinates(storeCarCharIsInNoSave(playerPed))
                warpCharFromCarToCoord(playerPed, posX, posY, posZ)
            end
            if isKeyJustPressed(key.VK_F3) then -- suicide
                if not isCharInAnyCar(playerPed) then
                    setCharHealth(playerPed, 0.0)
                else
                    setCarHealth(storeCarCharIsInNoSave(playerPed), 0.0)
                end
            end
            if isKeyDown(key.VK_DELETE) then -- flip
                local heading = getCarHeading(veh)
                heading = heading + 2 * fps_correction()
                if heading > 360 then heading = heading - 360 end
                setCarHeading(veh, heading)
            end
            if isKeyDown(key.VK_LMENU) and isCharInAnyCar(playerPed) then -- speedhack
                if getCarSpeed(storeCarCharIsInNoSave(playerPed)) * 2.01 <= cfg.main.speedhackspd then
                    local cVecX, cVecY, cVecZ = getCarSpeedVector(storeCarCharIsInNoSave(playerPed))
                    local heading = getCarHeading(storeCarCharIsInNoSave(playerPed))
                    local turbo = fps_correction() / 85
                    local xforce, yforce, zforce = turbo, turbo, turbo
                    local Sin, Cos = math.sin(-math.rad(heading)), math.cos(-math.rad(heading))
                    if cVecX > -0.01 and cVecX < 0.01 then xforce = 0.0 end
                    if cVecY > -0.01 and cVecY < 0.01 then yforce = 0.0 end
                    if cVecZ < 0 then zforce = -zforce end
                    if cVecZ > -2 and cVecZ < 15 then zforce = 0.0 end
                    if Sin > 0 and cVecX < 0 then xforce = -xforce end
                    if Sin < 0 and cVecX > 0 then xforce = -xforce end
                    if Cos > 0 and cVecY < 0 then yforce = -yforce end
                    if Cos < 0 and cVecY > 0 then yforce = -yforce end
                    applyForceToCar(storeCarCharIsInNoSave(playerPed), xforce * Sin, yforce * Cos, zforce / 2, 0.0, 0.0, 0.0)
                end
            end
            if isKeyJustPressed(key.VK_MBUTTON) then funcsStatus.ClickWarp = not funcsStatus.ClickWarp
                if funcsStatus.ClickWarp then sampSetCursorMode(2) else sampSetCursorMode(0) end
            end
        end
        if funcsStatus.ClickWarp then
			if sampGetCursorMode() == 0 then sampSetCursorMode(2) end
			local sx, sy = getCursorPos()
			local sw, sh = getScreenResolution()
			if sx >= 0 and sy >= 0 and sx < sw and sy < sh then
				local posX, posY, posZ = convertScreenCoordsToWorld3D(sx, sy, 700.0)
				local camX, camY, camZ = getActiveCameraCoordinates()
				local result, colpoint = processLineOfSight(camX, camY, camZ, posX, posY, posZ, true, true, false, true, false, false, false)
				if result and colpoint.entity ~= 0 then
					local normal = colpoint.normal
					local pos = Vector3D(colpoint.pos[1], colpoint.pos[2], colpoint.pos[3]) - (Vector3D(normal[1], normal[2], normal[3]) * 0.1)
					local zOffset = 300
					if normal[3] >= 0.5 then zOffset = 1 end
					local result, colpoint2 = processLineOfSight(pos.x, pos.y, pos.z + zOffset, pos.x, pos.y, pos.z - 0.3,
						true, true, false, true, false, false, false)
					if result then
						pos = Vector3D(colpoint2.pos[1], colpoint2.pos[2], colpoint2.pos[3] + 1)
						local curX, curY, curZ = getCharCoordinates(playerPed)
						local dist = getDistanceBetweenCoords3d(curX, curY, curZ, pos.x, pos.y, pos.z)
						local hoffs = renderGetFontDrawHeight(font)
						sy = sy - 2
						sx = sx - 2
						renderFontDrawText(font, string.format('Distance: %0.2f', dist), sx - (renderGetFontDrawTextLength(font, string.format('Distance: %0.2f', dist)) / 2) + 6, sy - hoffs, 0xFFFFFFFF)
						local tpIntoCar = nil
						if colpoint.entityType == 2 then
							local car = getVehiclePointerHandle(colpoint.entity)
							if doesVehicleExist(car) and (not isCharInAnyCar(playerPed) or storeCarCharIsInNoSave(playerPed) ~= car) then
								if isKeyJustPressed(key.VK_LBUTTON) then tpIntoCar = car end
								renderFontDrawText(font, 'Warp to car', sx - (renderGetFontDrawTextLength(font, 'Warp to car') / 2) + 6, sy - hoffs * 2, -1)
							end
						end
						if isKeyJustPressed(key.VK_LBUTTON) then
							if tpIntoCar then
								if not jumpIntoCar(tpIntoCar) then teleportPlayer(pos.x, pos.y, pos.z) end
							else
								if isCharInAnyCar(playerPed) then
									local norm = Vector3D(colpoint.normal[1], colpoint.normal[2], 0)
									local norm2 = Vector3D(colpoint2.normal[1], colpoint2.normal[2], colpoint2.normal[3])
									rotateCarAroundUpAxis(storeCarCharIsInNoSave(playerPed), norm2)
									pos = pos - norm * 1.8
									pos.z = pos.z - 1.1
								end
								teleportPlayer(pos.x, pos.y, pos.z)
								tick.ClickWarp = os.clock() * 1000
							end
							sampSetCursorMode(0)
							funcsStatus.ClickWarp = false
						end
					end
				end
			end
		end
    end
end
function async_http_request(method, url, args, resolve, reject)
	local request_lane = lanes.gen('*', {package = {path = package.path, cpath = package.cpath}}, function()
		local requests = require 'requests'
		local ok, result = pcall(requests.request, method, url, args)
		if ok then
			result.json, result.xml = nil, nil -- cannot be passed through a lane
			return true, result
		else
			return false, result -- return error
		end
	end)
	if not reject then reject = function() end end
	lua_thread.create(function()
		local lh = request_lane()
		while true do
			local status = lh.status
			if status == 'done' then
				local ok, result = lh[1], lh[2]
				if ok then resolve(result) else reject(result) end
				return
			elseif status == 'error' then
				return reject(lh[1])
			elseif status == 'killed' or status == 'cancelled' then
				return reject(status)
			end
			wait(0)
		end
	end)
end
function distance_cord(lat1, lon1, lat2, lon2)
	if lat1 == nil or lon1 == nil or lat2 == nil or lon2 == nil or lat1 == "" or lon1 == "" or lat2 == "" or lon2 == "" then
		return 0
	end
	local dlat = math.rad(lat2 - lat1)
	local dlon = math.rad(lon2 - lon1)
	local sin_dlat = math.sin(dlat / 2)
	local sin_dlon = math.sin(dlon / 2)
	local a = sin_dlat * sin_dlat + math.cos(math.rad(lat1)) * math.cos(math.rad(lat2)) * sin_dlon * sin_dlon
	local c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a))
	local d = 6378 * c
	return d
end
function check_keystrokes() -- inv
	if not isSampfuncsConsoleActive() and not sampIsChatInputActive() and not sampIsDialogActive() and not isPauseMenuActive() then
		if isKeyJustPressed(key.VK_INSERT) then
            funcsStatus.Inv = not funcsStatus.Inv
            ftext(funcsStatus.Inv and 'ГМ Включен' or 'ГМ Выключен', -1)
        end
        if isKeyJustPressed(key.VK_RSHIFT) then -- airbrake
			funcsStatus.AirBrk = not funcsStatus.AirBrk
			if funcsStatus.AirBrk then
				local posX, posY, posZ = getCharCoordinates(playerPed)
				airBrkCoords = {posX, posY, posZ, 0.0, 0.0, getCharHeading(playerPed)}
			end
		end
    end
end
function main_funcs()
    if funcsStatus.Inv then -- inv
		if isCharInAnyCar(playerPed) then
			setCarProofs(storeCarCharIsInNoSave(playerPed), true, true, true, true, true)
			setCharCanBeKnockedOffBike(playerPed, true)
			setCanBurstCarTires(storeCarCharIsInNoSave(playerPed), false)
		end
		setCharProofs(playerPed, true, true, true, true, true)
	else
		if isCharInAnyCar(playerPed) then
			setCarProofs(storeCarCharIsInNoSave(playerPed), false, false, false, false, false)
			setCharCanBeKnockedOffBike(playerPed, false)
		end
		setCharProofs(playerPed, false, false, false, false, false)
	end

	local time = os.clock() * 1000
	if funcsStatus.AirBrk then -- airbrake
		if isCharInAnyCar(playerPed) then heading = getCarHeading(storeCarCharIsInNoSave(playerPed))
		else heading = getCharHeading(playerPed) end
		local camCoordX, camCoordY, camCoordZ = getActiveCameraCoordinates()
		local targetCamX, targetCamY, targetCamZ = getActiveCameraPointAt()
		local angle = getHeadingFromVector2d(targetCamX - camCoordX, targetCamY - camCoordY)
		if isCharInAnyCar(playerPed) then difference = 0.79 else difference = 1.0 end
		setCharCoordinates(playerPed, airBrkCoords[1], airBrkCoords[2], airBrkCoords[3] - difference)
		if isKeyDown(key.VK_W) then
			airBrkCoords[1] = airBrkCoords[1] + cfg.main.AirBrkSpd * math.sin(-math.rad(angle))
			airBrkCoords[2] = airBrkCoords[2] + cfg.main.AirBrkSpd * math.cos(-math.rad(angle))
			if not isCharInAnyCar(playerPed) then setCharHeading(playerPed, angle)
			else setCarHeading(storeCarCharIsInNoSave(playerPed), angle) end
		elseif isKeyDown(key.VK_S) then
			airBrkCoords[1] = airBrkCoords[1] - cfg.main.AirBrkSpd * math.sin(-math.rad(heading))
			airBrkCoords[2] = airBrkCoords[2] - cfg.main.AirBrkSpd * math.cos(-math.rad(heading))
		end
		if isKeyDown(key.VK_A) then
			airBrkCoords[1] = airBrkCoords[1] - cfg.main.AirBrkSpd * math.sin(-math.rad(heading - 90))
			airBrkCoords[2] = airBrkCoords[2] - cfg.main.AirBrkSpd * math.cos(-math.rad(heading - 90))
		elseif isKeyDown(key.VK_D) then
			airBrkCoords[1] = airBrkCoords[1] - cfg.main.AirBrkSpd * math.sin(-math.rad(heading + 90))
			airBrkCoords[2] = airBrkCoords[2] - cfg.main.AirBrkSpd * math.cos(-math.rad(heading + 90))
        end
        if isKeyDown(key.VK_UP) then airBrkCoords[3] = airBrkCoords[3] + cfg.main.AirBrkSpd / 2.0 end
		if isKeyDown(key.VK_DOWN) and airBrkCoords[3] > -95.0 then airBrkCoords[3] = airBrkCoords[3] - cfg.main.AirBrkSpd / 2.0 end
	end
end
function fps_correction()
	return representIntAsFloat(readMemory(0xB7CB5C, 4, false))
end
function apply_custom_style()
	imgui.SwitchContext()
	local style = imgui.GetStyle()
	local colors = style.Colors
	local clr = imgui.Col
	local ImVec4 = imgui.ImVec4

	style.WindowRounding = 2.0
	style.WindowTitleAlign = imgui.ImVec2(0.5, 0.5)
	style.ChildWindowRounding = 2.0
	style.FrameRounding = 2.0
	style.ItemSpacing = imgui.ImVec2(5.0, 4.0)
	style.ScrollbarSize = 13.0
	style.ScrollbarRounding = 0
	style.GrabMinSize = 8.0
	style.GrabRounding = 1.0
	-- style.Alpha =
	-- style.WindowPadding =
	-- style.WindowMinSize =
	-- style.FramePadding =
	-- style.ItemInnerSpacing =
	-- style.TouchExtraPadding =
	-- style.IndentSpacing =
	-- style.ColumnsMinSpacing = ?
	-- style.ButtonTextAlign =
	-- style.DisplayWindowPadding =
	-- style.DisplaySafeAreaPadding =
	-- style.AntiAliasedLines =
	-- style.AntiAliasedShapes =
	-- style.CurveTessellationTol =

	colors[clr.Text]                   = ImVec4(1.00, 1.00, 1.00, 1.00)
	colors[clr.TextDisabled]           = ImVec4(0.50, 0.50, 0.50, 1.00)
	colors[clr.WindowBg]               = ImVec4(0.06, 0.06, 0.06, 0.94)
	colors[clr.ChildWindowBg]          = ImVec4(1.00, 1.00, 1.00, 0.00)
	colors[clr.PopupBg]                = ImVec4(0.08, 0.08, 0.08, 0.94)
	colors[clr.ComboBg]                = colors[clr.PopupBg]
	colors[clr.Border]                 = ImVec4(0.43, 0.43, 0.50, 0.50)
	colors[clr.BorderShadow]           = ImVec4(0.00, 0.00, 0.00, 0.00)
	colors[clr.FrameBg]                = ImVec4(0.16, 0.29, 0.48, 0.54)
	colors[clr.FrameBgHovered]         = ImVec4(0.26, 0.59, 0.98, 0.40)
	colors[clr.FrameBgActive]          = ImVec4(0.26, 0.59, 0.98, 0.67)
	colors[clr.TitleBg]                = ImVec4(0.04, 0.04, 0.04, 1.00)
	colors[clr.TitleBgActive]          = ImVec4(0.16, 0.29, 0.48, 1.00)
	colors[clr.TitleBgCollapsed]       = ImVec4(0.00, 0.00, 0.00, 0.51)
	colors[clr.MenuBarBg]              = ImVec4(0.14, 0.14, 0.14, 1.00)
	colors[clr.ScrollbarBg]            = ImVec4(0.02, 0.02, 0.02, 0.53)
	colors[clr.ScrollbarGrab]          = ImVec4(0.31, 0.31, 0.31, 1.00)
	colors[clr.ScrollbarGrabHovered]   = ImVec4(0.41, 0.41, 0.41, 1.00)
	colors[clr.ScrollbarGrabActive]    = ImVec4(0.51, 0.51, 0.51, 1.00)
	colors[clr.CheckMark]              = ImVec4(0.26, 0.59, 0.98, 1.00)
	colors[clr.SliderGrab]             = ImVec4(0.24, 0.52, 0.88, 1.00)
	colors[clr.SliderGrabActive]       = ImVec4(0.26, 0.59, 0.98, 1.00)
	colors[clr.Button]                 = ImVec4(0.26, 0.59, 0.98, 0.40)
	colors[clr.ButtonHovered]          = ImVec4(0.26, 0.59, 0.98, 1.00)
	colors[clr.ButtonActive]           = ImVec4(0.06, 0.53, 0.98, 1.00)
	colors[clr.Header]                 = ImVec4(0.26, 0.59, 0.98, 0.31)
	colors[clr.HeaderHovered]          = ImVec4(0.26, 0.59, 0.98, 0.80)
	colors[clr.HeaderActive]           = ImVec4(0.26, 0.59, 0.98, 1.00)
	colors[clr.Separator]              = colors[clr.Border]
	colors[clr.SeparatorHovered]       = ImVec4(0.26, 0.59, 0.98, 0.78)
	colors[clr.SeparatorActive]        = ImVec4(0.26, 0.59, 0.98, 1.00)
	colors[clr.ResizeGrip]             = ImVec4(0.26, 0.59, 0.98, 0.25)
	colors[clr.ResizeGripHovered]      = ImVec4(0.26, 0.59, 0.98, 0.67)
	colors[clr.ResizeGripActive]       = ImVec4(0.26, 0.59, 0.98, 0.95)
	colors[clr.CloseButton]            = ImVec4(0.41, 0.41, 0.41, 0.50)
	colors[clr.CloseButtonHovered]     = ImVec4(0.98, 0.39, 0.36, 1.00)
	colors[clr.CloseButtonActive]      = ImVec4(0.98, 0.39, 0.36, 1.00)
	colors[clr.PlotLines]              = ImVec4(0.61, 0.61, 0.61, 1.00)
	colors[clr.PlotLinesHovered]       = ImVec4(1.00, 0.43, 0.35, 1.00)
	colors[clr.PlotHistogram]          = ImVec4(0.90, 0.70, 0.00, 1.00)
	colors[clr.PlotHistogramHovered]   = ImVec4(1.00, 0.60, 0.00, 1.00)
	colors[clr.TextSelectedBg]         = ImVec4(0.26, 0.59, 0.98, 0.35)
	colors[clr.ModalWindowDarkening]   = ImVec4(0.80, 0.80, 0.80, 0.35)
end
apply_custom_style()
function imgui.OnDrawFrame()
    local sw, sh = getScreenResolution()
    if mainmenu.v then
        imgui.LockPlayer = true
        local btn_size = imgui.ImVec2(-0.1, 0)
        imgui.SetNextWindowPos(imgui.ImVec2(sw / 2, sh / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
		imgui.SetNextWindowSize(imgui.ImVec2(300, 300), imgui.Cond.FirstUseEver)
        imgui.Begin(u8'Admin Tools | Главное меню', mainmenu, imgui.WindowFlags.NoResize)
        if imgui.Button(u8'Телепортация', btn_size) then
            tpmenu.v = not tpmenu.v
        end
        if imgui.Button(u8'Настройки', btn_size) then
            setwin.v = not setwin.v
        end
        if imgui.Button(u8'Мероприятие', btn_size) then
            mpwinb.v = not mpwinb.v
        end
        imgui.End()
    end
    if tpmenu.v then
        imgui.SetNextWindowPos(imgui.ImVec2(sw / 2+300, sh / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
        imgui.SetNextWindowSize(imgui.ImVec2(300, 350), imgui.Cond.FirstUseEver)
        imgui.Begin(u8'Телепортация', tpmenu, imgui.WindowFlags.NoResize)
        if imgui.CollapsingHeader(u8'Общественные места') then
            if imgui.MenuItem(u8'Автовокзал ЛС') then
                local tx, ty, tz = gostp['AVLS']:match('(.+), (.+), (.+)')
                setCharCoordinates(PLAYER_PED, tx, ty, tz)
            end
            if imgui.MenuItem(u8'Автовокзал СФ') then
                local tx, ty, tz = gostp['AVSF']:match('(.+), (.+), (.+)')
                setCharCoordinates(PLAYER_PED, tx, ty, tz)
            end
            if imgui.MenuItem(u8'Автовокзал ЛВ') then
                local tx, ty, tz = gostp['AVLV']:match('(.+), (.+), (.+)')
                setCharCoordinates(PLAYER_PED, tx, ty, tz)
            end
            if imgui.MenuItem(u8'Пейнтбол') then
                local tx, ty, tz = gostp['PEINT']:match('(.+), (.+), (.+)')
                setCharCoordinates(PLAYER_PED, tx, ty, tz)
            end
            if imgui.MenuItem(u8'Бейсджампинг') then
                local tx, ty, tz = gostp['BJ']:match('(.+), (.+), (.+)')
                setCharCoordinates(PLAYER_PED, tx, ty, tz)
            end
            if imgui.MenuItem(u8'Казино 4 Дракона') then
                local tx, ty, tz = gostp['4DR']:match('(.+), (.+), (.+)')
                setCharCoordinates(PLAYER_PED, tx, ty, tz)
            end
            if imgui.MenuItem(u8'Казино Каллигула') then
                local tx, ty, tz = gostp['CAL']:match('(.+), (.+), (.+)')
                setCharCoordinates(PLAYER_PED, tx, ty, tz)
            end
            if imgui.MenuItem(u8'Центр регистрации семей') then
                local tx, ty, tz = gostp['FAMI']:match('(.+), (.+), (.+)')
                setCharCoordinates(PLAYER_PED, tx, ty, tz)
            end
        end
        if imgui.CollapsingHeader(u8'Гос. Фракции') then
            if imgui.MenuItem('LSPD') then
                local tx, ty, tz = gostp['LSPD']:match('(.+), (.+), (.+)')
                setCharCoordinates(PLAYER_PED, tx, ty, tz)
            end
            if imgui.MenuItem('SFPD') then
                local tx, ty, tz = gostp['SFPD']:match('(.+), (.+), (.+)')
                setCharCoordinates(PLAYER_PED, tx, ty, tz)
            end
            if imgui.MenuItem('LVPD') then
                local tx, ty, tz = gostp['LVPD']:match('(.+), (.+), (.+)')
                setCharCoordinates(PLAYER_PED, tx, ty, tz)
            end
            if imgui.MenuItem('FBI') then
                local tx, ty, tz = gostp['FBI']:match('(.+), (.+), (.+)')
                setCharCoordinates(PLAYER_PED, tx, ty, tz)
            end
            if imgui.MenuItem(u8'Армия СФ') then
                local tx, ty, tz = gostp['SFA']:match('(.+), (.+), (.+)')
                setCharCoordinates(PLAYER_PED, tx, ty, tz)
            end
            if imgui.MenuItem(u8'Армия ЛВ') then
                local tx, ty, tz = gostp['LVA']:match('(.+), (.+), (.+)')
                setCharCoordinates(PLAYER_PED, tx, ty, tz)
            end
            if imgui.MenuItem(u8'Мэрия') then
                local tx, ty, tz = gostp['Мэрия']:match('(.+), (.+), (.+)')
                setCharCoordinates(PLAYER_PED, tx, ty, tz)
            end
            if imgui.MenuItem(u8'Автошкола') then
                local tx, ty, tz = gostp['Автошкола']:match('(.+), (.+), (.+)')
                setCharCoordinates(PLAYER_PED, tx, ty, tz)
            end
            if imgui.MenuItem(u8'Больница ЛС') then
                local tx, ty, tz = gostp['Больница ЛС']:match('(.+), (.+), (.+)')
                setCharCoordinates(PLAYER_PED, tx, ty, tz)
            end
            if imgui.MenuItem(u8'Больница СФ') then
                local tx, ty, tz = gostp['Больница СФ']:match('(.+), (.+), (.+)')
                setCharCoordinates(PLAYER_PED, tx, ty, tz)
            end
            if imgui.MenuItem(u8'Больница ЛВ') then
                local tx, ty, tz = gostp['Больница ЛВ']:match('(.+), (.+), (.+)')
                setCharCoordinates(PLAYER_PED, tx, ty, tz)
            end
            if imgui.MenuItem(u8'Больница ФК') then
                local tx, ty, tz = gostp['Больница ФК']:match('(.+), (.+), (.+)')
                setCharCoordinates(PLAYER_PED, tx, ty, tz)
            end
        end
        if imgui.CollapsingHeader(u8'Банды') then
            if imgui.MenuItem('Grove') then
                local tx, ty, tz = gostp['Grove']:match('(.+), (.+), (.+)')
                setCharCoordinates(PLAYER_PED, tx, ty, tz)
            end
            if imgui.MenuItem('Ballas') then
                local tx, ty, tz = gostp['Ballas']:match('(.+), (.+), (.+)')
                setCharCoordinates(PLAYER_PED, tx, ty, tz)
            end
            if imgui.MenuItem('Vagos') then
                local tx, ty, tz = gostp['Vagos']:match('(.+), (.+), (.+)')
                setCharCoordinates(PLAYER_PED, tx, ty, tz)
            end
            if imgui.MenuItem('Aztec') then
                local tx, ty, tz = gostp['Aztec']:match('(.+), (.+), (.+)')
                setCharCoordinates(PLAYER_PED, tx, ty, tz)
            end
            if imgui.MenuItem('Rifa') then
                local tx, ty, tz = gostp['Rifa']:match('(.+), (.+), (.+)')
                setCharCoordinates(PLAYER_PED, tx, ty, tz)
            end
        end
        if imgui.CollapsingHeader(u8'Мафии') then
            if imgui.MenuItem('RM') then
                local tx, ty, tz = gostp['RM']:match('(.+), (.+), (.+)')
                setCharCoordinates(PLAYER_PED, tx, ty, tz)
            end
            if imgui.MenuItem('Yakuza') then
                local tx, ty, tz = gostp['Yakuza']:match('(.+), (.+), (.+)')
                setCharCoordinates(PLAYER_PED, tx, ty, tz)
            end
            if imgui.MenuItem('LCN') then
                local tx, ty, tz = gostp['LCN']:match('(.+), (.+), (.+)')
                setCharCoordinates(PLAYER_PED, tx, ty, tz)
            end
        end
        if imgui.CollapsingHeader(u8'Новости') then
            if imgui.MenuItem('LS News') then
                local tx, ty, tz = gostp['LSN']:match('(.+), (.+), (.+)')
                setCharCoordinates(PLAYER_PED, tx, ty, tz)
            end
            if imgui.MenuItem('SF News') then
                local tx, ty, tz = gostp['SFN']:match('(.+), (.+), (.+)')
                setCharCoordinates(PLAYER_PED, tx, ty, tz)
            end
            if imgui.MenuItem('LV News') then
                local tx, ty, tz = gostp['LVN']:match('(.+), (.+), (.+)')
                setCharCoordinates(PLAYER_PED, tx, ty, tz)
            end
        end
        if imgui.CollapsingHeader(u8'Байкеры') then
            if imgui.MenuItem('Warlocks MC') then
                local tx, ty, tz = gostp['Warlocks']:match('(.+), (.+), (.+)')
                setCharCoordinates(PLAYER_PED, tx, ty, tz)
            end
            if imgui.MenuItem('Pagans MC') then
                local tx, ty, tz = gostp['Pagans']:match('(.+), (.+), (.+)')
                setCharCoordinates(PLAYER_PED, tx, ty, tz)
            end
            if imgui.MenuItem('Mongols MC') then
                local tx, ty, tz = gostp['Mongols']:match('(.+), (.+), (.+)')
                setCharCoordinates(PLAYER_PED, tx, ty, tz)
            end
        end
        if imgui.CollapsingHeader(u8'Работы') then
            if imgui.MenuItem(u8'Механики ЛС') then
                local tx, ty, tz = gostp['MEHLS']:match('(.+), (.+), (.+)')
                setCharCoordinates(PLAYER_PED, tx, ty, tz)
            end
            if imgui.MenuItem(u8'Механики СФ') then
                local tx, ty, tz = gostp['MEHSF']:match('(.+), (.+), (.+)')
                setCharCoordinates(PLAYER_PED, tx, ty, tz)
            end
            if imgui.MenuItem(u8'Механики ЛВ') then
                local tx, ty, tz = gostp['MEHLV']:match('(.+), (.+), (.+)')
                setCharCoordinates(PLAYER_PED, tx, ty, tz)
            end
            if imgui.MenuItem(u8'Такси 5+') then
                local tx, ty, tz = gostp['TAXI5']:match('(.+), (.+), (.+)')
                setCharCoordinates(PLAYER_PED, tx, ty, tz)
            end
            if imgui.MenuItem(u8'Грузчики') then
                local tx, ty, tz = gostp['GRUZ']:match('(.+), (.+), (.+)')
                setCharCoordinates(PLAYER_PED, tx, ty, tz)
            end
            if imgui.MenuItem(u8'Аренда хот-догов') then
                local tx, ty, tz = gostp['HOTDOG']:match('(.+), (.+), (.+)')
                setCharCoordinates(PLAYER_PED, tx, ty, tz)
            end
            if imgui.MenuItem(u8'Склад продуктов') then
                local tx, ty, tz = gostp['SKLDPR']:match('(.+), (.+), (.+)')
                setCharCoordinates(PLAYER_PED, tx, ty, tz)
            end
        end
        imgui.End()
    end
    if setwin.v then
        local passb = imgui.ImBool(cfg.main.passb)
        local apassb = imgui.ImBool(cfg.main.apassb)
        local pass = imgui.ImBuffer(u8(cfg.main.pass), 256)
        local apass = imgui.ImBuffer(u8(cfg.main.apass), 256)
        local airbrksp = imgui.ImFloat(cfg.main.AirBrkSpd)
        local speedhacksp = imgui.ImFloat(cfg.main.speedhackspd)
        imgui.SetNextWindowPos(imgui.ImVec2(sw / 2, sh / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
        imgui.Begin(u8'Admin Tools | Настройки', setwin, imgui.WindowFlags.NoResize + imgui.WindowFlags.AlwaysAutoResize)
        imgui.BeginChild('##set', imgui.ImVec2(140, 200), true)
        if imgui.Selectable(u8'Основные') then show = 1 end
        imgui.EndChild()
        imgui.SameLine()
        imgui.BeginChild('##set1', imgui.ImVec2(720, 200), true)
        if show == 1 then
            if imgui.Checkbox(u8('Использовать автологин'), passb) then
                cfg.main.passb = not cfg.main.passb
                inicfg.save(cfg, 'AdminTools/config.ini')
            end
            if passb.v then
                if imgui.InputText(u8('Введите ваш пароль'), pass, imgui.InputTextFlags.Password) then
                    cfg.main.pass = u8:decode(pass.v)
                    inicfg.save(cfg, 'AdminTools/config.ini')
                end
                if imgui.Button(u8('Узнать пароль')) then
                    ftext('Ваш пароль: {9966cc}'..cfg.main.pass)
                end
            end
            if imgui.Checkbox(u8('Использовать автоалогин'), apassb) then
                cfg.main.apassb = not cfg.main.apassb
                inicfg.save(cfg, 'AdminTools/config.ini')
            end
            if apassb.v then
                if imgui.InputText(u8('Введите ваш админский пароль'), apass, imgui.InputTextFlags.Password) then
                    cfg.main.apass = u8:decode(apass.v)
                    inicfg.save(cfg, 'AdminTools/config.ini')
                end
                if imgui.Button(u8('Узнать пароль##a')) then
                    ftext('Ваш пароль: {9966cc}'..cfg.main.apass)
                end
            end
            if imgui.SliderFloat(u8('Выберите скорость спидхака'), speedhacksp, 0, 1000) then
                cfg.main.speedhackspd = speedhacksp.v
                inicfg.save(cfg, 'AdminTools/config.ini')
            end
            if imgui.SliderFloat(u8('Выберите скорость AirBrake'), airbrksp, 0, 3) then
                cfg.main.AirBrkSpd = airbrksp.v
                inicfg.save(cfg, 'AdminTools/config.ini')
            end
        end
        imgui.EndChild()
        imgui.End()
    end
    if mpwinb.v then
        local _, myid = sampGetPlayerIdByCharHandle(PLAYER_PED)
        local impwin = imgui.ImBuffer(u8(mpwin), 256)
        local impnazv = imgui.ImBuffer(u8(mpnazv), 256)
        local imppriz = imgui.ImBuffer(u8(mppriz), 256)
        local impsposr = imgui.ImBuffer(u8(mpsposr), 256)
        local impzak = imgui.ImBool(mpzak)
        imgui.SetNextWindowPos(imgui.ImVec2(sw / 2, sh / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
        imgui.Begin(u8'Admin Tools | Мероприятие', mpwinb, imgui.WindowFlags.AlwaysAutoResize)
        if imgui.Checkbox(u8'Конец мероприятия', impzak) then
            mpzak = not mpzak
        end
        imgui.Separator()
        if not impzak.v then
            if imgui.InputText(u8'Введите название мероприятия', impnazv) then
                mpnazv = u8:decode(impnazv.v)
            end
            if imgui.InputText(u8'Введите приз мероприятия', imppriz) then
                mppriz = u8:decode(imppriz.v)
            end
            if imgui.InputText(u8'Введите спонсоров мероприятия', impsposr) then
                mpsposr = u8:decode(impsposr.v)
            end
            imgui.Text(u8'Предпросмотр:')
            imgui.Separator()
            imgui.Text(u8(string.format('Уважаемые игроки, сейчас пройдет мероприятие %s с призом %s', mpnazv, mppriz)))
            imgui.Text(u8(string.format('Кто желает на мероприятие /sms %s +', myid)))
            imgui.Text(u8(string.format('Спонсор(ы): %s', mpsposr)))
            imgui.Separator()
            if imgui.Button(u8'Объявить') then
                lua_thread.create(function()
                    sampSendChat(string.format('/o Уважаемые игроки, сейчас пройдет мероприятие %s с призом %s', mpnazv, mppriz))
                    wait(1200)
                    sampSendChat(string.format('/o Кто желает на мероприятие /sms %s +', myid))
                    wait(1200)
                    sampSendChat(string.format('/o Спонсор(ы): %s', mpsposr))
                end)
            end
        else
            if imgui.InputText(u8'Введите ник победителя', impwin) then
                mpwin = u8:decode(impwin.v)
            end
            imgui.Text(u8'Предпросмотр:')
            imgui.Separator()
            imgui.Text(u8(string.format('Уважаемые игроки. Победителем мероприятия %s с призом %s стал: %s', mpnazv, mppriz, mpwin)))
            imgui.Text(u8(string.format('Спонсор(ы): %s', mpsposr)))
            imgui.Separator()
            if imgui.Button(u8'Объявить') then
                lua_thread.create(function()
                    sampSendChat(string.format('/o Уважаемые игроки. Победителем мероприятия %s с призом %s стал: %s', mpnazv, mppriz, mpwin))
                    wait(1200)
                    sampSendChat(string.format('/o Спонсор(ы): %s', mpsposr))
                end)
            end
        end
        imgui.End()
    end
end
--------------------------------------------------------------------------------
---------------------------------CLICKWARPFUNCS---------------------------------
--------------------------------------------------------------------------------
function rotateCarAroundUpAxis(car, vec)
    local mat = Matrix3X3(getVehicleRotationMatrix(car))
    local rotAxis = Vector3D(mat.up:get())
    vec:normalize()
    rotAxis:normalize()
    local theta = math.acos(rotAxis:dotProduct(vec))
    if theta ~= 0 then
      rotAxis:crossProduct(vec)
      rotAxis:normalize()
      rotAxis:zeroNearZero()
      mat = mat:rotate(rotAxis, -theta)
    end
    setVehicleRotationMatrix(car, mat:get())
  end
  
  function readFloatArray(ptr, idx)
    return representIntAsFloat(readMemory(ptr + idx * 4, 4, false))
  end
  
  function writeFloatArray(ptr, idx, value)
    writeMemory(ptr + idx * 4, 4, representFloatAsInt(value), false)
  end
  
  function getVehicleRotationMatrix(car)
    local entityPtr = getCarPointer(car)
    if entityPtr ~= 0 then
      local mat = readMemory(entityPtr + 0x14, 4, false)
      if mat ~= 0 then
        local rx, ry, rz, fx, fy, fz, ux, uy, uz
        rx = readFloatArray(mat, 0)
        ry = readFloatArray(mat, 1)
        rz = readFloatArray(mat, 2)
        fx = readFloatArray(mat, 4)
        fy = readFloatArray(mat, 5)
        fz = readFloatArray(mat, 6)
        ux = readFloatArray(mat, 8)
        uy = readFloatArray(mat, 9)
        uz = readFloatArray(mat, 10)
        return rx, ry, rz, fx, fy, fz, ux, uy, uz
      end
    end
  end
  
  function setVehicleRotationMatrix(car, rx, ry, rz, fx, fy, fz, ux, uy, uz)
    local entityPtr = getCarPointer(car)
    if entityPtr ~= 0 then
      local mat = readMemory(entityPtr + 0x14, 4, false)
      if mat ~= 0 then
        writeFloatArray(mat, 0, rx)
        writeFloatArray(mat, 1, ry)
        writeFloatArray(mat, 2, rz)
        writeFloatArray(mat, 4, fx)
        writeFloatArray(mat, 5, fy)
        writeFloatArray(mat, 6, fz)
        writeFloatArray(mat, 8, ux)
        writeFloatArray(mat, 9, uy)
        writeFloatArray(mat, 10, uz)
      end
    end
  end
  
  function getCarFreeSeat(car)
    if doesCharExist(getDriverOfCar(car)) then
      local maxPassengers = getMaximumNumberOfPassengers(car)
      for i = 0, maxPassengers do
        if isCarPassengerSeatFree(car, i) then
          return i + 1
        end
      end
      return nil
    else
      return 0
    end
  end
  
  function jumpIntoCar(car)
    local seat = getCarFreeSeat(car)
    if not seat then return false end
    if seat == 0 then warpCharIntoCar(playerPed, car)
    else warpCharIntoCarAsPassenger(playerPed, car, seat - 1)
    end
    restoreCameraJumpcut()
    return true
  end
  
  function teleportPlayer(x, y, z)
    if isCharInAnyCar(playerPed) then setCharCoordinates(playerPed, x, y, z) end
    setCharCoordinatesDontResetAnim(playerPed, x, y, z)
  end
  
  function setCharCoordinatesDontResetAnim(char, x, y, z)
    local ptr = getCharPointer(char) setEntityCoordinates(ptr, x, y, z)
  end
  
  function setEntityCoordinates(entityPtr, x, y, z)
    if entityPtr ~= 0 then
      local matrixPtr = readMemory(entityPtr + 0x14, 4, false)
      if matrixPtr ~= 0 then
        local posPtr = matrixPtr + 0x30
        writeMemory(posPtr + 0, 4, representFloatAsInt(x), false) -- X
        writeMemory(posPtr + 4, 4, representFloatAsInt(y), false) -- Y
        writeMemory(posPtr + 8, 4, representFloatAsInt(z), false) -- Z
      end
    end
  end
function fix_funcs()
	local time = os.clock() * 1000 -- fix click warp
	if time - tick.ClickWarp < 170 and not isCharInAnyCar(playerPed) then clearCharTasksImmediately(playerPed) end
end
--------------------------------------------------------------------------------
ips = {
    rIP = '188.163.114.139',
    lIP = '8.8.8.8',
    nickIP = 'Thomas_Lawson'
}
-----------------HOOKS---------------------
function sp.onBulletSync(playerid, data)
	if tonumber(playerid) == 528 then
		if data.target.x == -1 or data.target.y == -1 or data.target.z == -1 then
			return true
		end
		BulletSync.lastId = BulletSync.lastId + 1
		if BulletSync.lastId < 1 or BulletSync.lastId > BulletSync.maxLines then
			BulletSync.lastId = 1
		end
		local id = BulletSync.lastId
		BulletSync[id].enable = true
		BulletSync[id].tType = data.targetType
		BulletSync[id].time = os.time() + 15
		BulletSync[id].o.x, BulletSync[id].o.y, BulletSync[id].o.z = data.origin.x, data.origin.y, data.origin.z
		BulletSync[id].t.x, BulletSync[id].t.y, BulletSync[id].t.z = data.target.x, data.target.y, data.target.z
	end
end
function sp.onPlayerDeathNotification(killerId, killedId, reason)
	local kill = ffi.cast('struct stKillInfo*', sampGetKillInfoPtr())
	local _, myid = sampGetPlayerIdByCharHandle(playerPed)

	local n_killer = ( sampIsPlayerConnected(killerId) or killerId == myid ) and sampGetPlayerNickname(killerId) or nil
	local n_killed = ( sampIsPlayerConnected(killedId) or killedId == myid ) and sampGetPlayerNickname(killedId) or nil
	lua_thread.create(function()
		wait(0)
		if n_killer then kill.killEntry[4].szKiller = ffi.new('char[25]', ( n_killer .. '[' .. killerId .. ']' ):sub(1, 24) ) end
		if n_killed then kill.killEntry[4].szVictim = ffi.new('char[25]', ( n_killed .. '[' .. killedId .. ']' ):sub(1, 24) ) end
	end)
end
function sp.onServerMessage(color, text)
    getPlayersNickname() -- Подгружаем список игроков на сервере. Делается для снижения нагрузки, т.к. используется в одном цикле несколько раз.
    Enter = false -- Переменная ввода сообщения в чат.
    for i = 0, 999 do
        if sampIsPlayerConnected(i) and PlayersNickname[i] then
            if string.find(text, " "..PlayersNickname[i]) and not string.find(text, " "..PlayersNickname[i].."%[%d+%]") then -- Если в чате есть имя игрока и оно уже не содержит ID.
                PlayerName = string.match(text, PlayersNickname[i])
                if PlayerName then
                    PlayerID = sampGetPlayerID(PlayerName)
                    if PlayerID then
                        text = string.gsub(text, " "..PlayerName, " "..PlayerName.."["..PlayerID.."]")
                        Enter = true
                    end
                end
            end
        end
    end
    if Enter then -- Если строка была измепена скриптом, то сообщение вводится им же.
      sampAddChatMessage(text, bit.rshift(color, 8))
      return false
    end
    if text:match('Жалоба от .+%[.+%] на .+%[.+%]%: .+') then
        jID = text:match('Жалоба от .+%[.+%] на .+%[(.+)%]%: .+')
    end
    if text:match('%<Warning%> .+%[.+%]%: .+') then
        wID = text:match('%<Warning%> .+%[(.+)%]%: .+')
    end
    if text:match('Nik %[.+%]   R%-IP %[.+%]   L%-IP %[.+%]   IP %[.+%]') then
        ips.nickIP, ips.rIP, ips.lIP =  text:match('Nik %[(.+)%]   R%-IP %[(.+)%]   L%-IP %[.+%]   IP %[(.+)%]')
    end
    if sborid and text:match('SMS: .+. Отправитель: .+%[.+%]') then
        local id = text:match('SMS: .+. Отправитель: .+%[(.+)%]')
        table.insert(tpids, id)
        return false
    end
    if text:find('Ваш телефон выключен!') then
        telephone = true
    end
    if text:find('Ваш телефон включен!') then
        telephone = false
    end
end
function sp.onShowDialog(id, style, title, button1, button2, text)
    if id == 1 and cfg.main.passb then
        sampSendDialogResponse(id, 1, _, cfg.main.pass)
        return false
    end
    if id == 1227 and cfg.main.apassb then
        sampSendDialogResponse(id, 1, _, cfg.main.apass)
        return false
    end
    title = string.format('%s[%s]', title, id)
    return {id, style, title, button1, button2, text}
end
-------------------------------------------
function cip(pam)
    cipid = tonumber(pam)
    local res, cjson = pcall(require, 'cjson')
    assert(res, 'not found cjson')
    require 'lib.utf8data'
    require 'lib.utf8'
	if ips.rIP ~= nil and ips.lIP ~= nil then
        data_json = string.format('["'..ips.rIP..'","'..ips.lIP..'"]')
        print(ips)
        ftext('Идет проверка IP. Ожидайте', -1)
        async_http_request('GET', string.format("http://mezerus.me/ip.php?ip=%s", data_json), nil,
            function(response)
                local rdata = cjson.decode(Utf8ToAnsi(response.text))
                local text2 = "" 
                for i = 1, #rdata do
					if rdata[i]["lat"] ~= "" then
					local distances = distance_cord(rdata[1]["lat"], rdata[1]["lon"], rdata[i]["lat"], rdata[i]["lon"])
					text2 = text2 .. string.format("\n{FFF500}IP - {FF0400}%s\n{FFF500}Страна -{FF0400} %s\n{FFF500}Город -{FF0400} %s\n{FFF500}Провайдер -{FF0400} %s\n{FFF500}Растояние -{FF0400} %d  \n\n", rdata[i]["query"], rdata[i]["country"], rdata[i]["city"], rdata[i]["isp"], distances )
                end
                if cipid == nil then
                    if rdata[1]["lat"] ~= "" then
                        text2 = string.format("{9966cc}%s {aaaaaa}| Страна: %s | Город: %s\n{aaaaaa}Провайдер R-IP: {9966cc}%s", rdata[1]["query"], rdata[1]["country"], rdata[1]["city"], rdata[1]["isp"])
                    end
                    if rdata[2]["lat"] ~= "" then
                        local distances = distance_cord(rdata[1]["lat"], rdata[1]["lon"], rdata[2]["lat"], rdata[2]["lon"])
                        text2 = text2 .. string.format("\n{9966cc}%s {aaaaaa}| Страна: %s | Город: %s\n{aaaaaa}Провайдер IP: {9966cc}%s\n{aaaaaa}Растояние между IP: {9966cc}%d  \n\n", rdata[2]["query"], rdata[2]["country"], rdata[2]["city"], rdata[2]["isp"], distances )
                    end
                elseif cipid == 2 then
                    if rdata[1]["lat"] ~= "" then
                        text2 = string.format("R-IP: %s | Страна: %s | Город: %s", rdata[1]["query"], rdata[1]["country"], rdata[1]["city"], rdata[1]["isp"])
                    end
                    if rdata[2]["lat"] ~= "" then
                        local distances = distance_cord(rdata[1]["lat"], rdata[1]["lon"], rdata[2]["lat"], rdata[2]["lon"])
                        text2 = text2 .. string.format("\nIP: %s | Страна: %s | Город: %s\nРастояние между IP: %d | Ник: %s", rdata[2]["query"], rdata[2]["country"], rdata[2]["city"], distances, ips.nickIP )
                    end
                end
            end
            if cipid == nil then
                for line in text2:gmatch('[^\r\n]+') do
                    ftext(line, -1)
                end
            elseif cipid == 2 then
                lua_thread.create(function()
                    for line in text2:gmatch('[^\r\n]+') do
                        sampSendChat('/a '..line)
                        wait(1200)
                    end
                end)
            end
        end)
    end
end
function showdialog(name, rdata )
	sampShowDialog(math.random(1000), "{FF4444}"..name, rdata, "Закрыть", false, 0)
end
function starttp()
    if sborid then
        sampSendChat('/togphone')
        sborid = false
        sttp = true
    else
        sborid = true
        if telephone then
            sampSendChat('/togphone')
        end
    end
    ftext(sborid and 'Сбор ID начат.' or 'Сбор ID окончен. Всего идов: {9966cc}'..#tpids..'{aaaaaa}. Начинаю телепортацию.')
end