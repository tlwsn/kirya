script_name("FBI Tools")
script_authors("Thomas Lawson, Sesh Jefferson")
script_version(3.31)

require 'lib.moonloader'
require 'lib.sampfuncs'

local lsg, sf               = pcall(require, 'sampfuncs')
local lkey, key             = pcall(require, 'vkeys')
local lmemory, memory       = pcall(require, 'memory')
local lsampev, sp           = pcall(require, 'lib.samp.events')
local lsphere, Sphere       = pcall(require, 'Sphere')
local lrkeys, rkeys         = pcall(require, 'rkeys')
local limadd, imadd         = pcall(require, 'imgui_addons')
local limgui, imgui         = pcall(require, 'imgui')
local lrequests, requests   = pcall(require, 'requests')
local lsha1, sha1           = pcall(require, 'sha1')
local lbasexx, basexx       = pcall(require, 'basexx')
local dlstatus              = require('moonloader').download_status
local wm                    = require 'lib.windows.message'
local gk                    = require 'game.keys'
local encoding              = require 'encoding'
local band                  = bit.band
encoding.default            = 'CP1251'
u8 = encoding.UTF8

local groupNames = {
    u8'ПД/ФБР', u8'Автошкола', u8'Медики', u8'Мэрия'
}

local cfg =
{
    main = {
        posX = 1566,
        posY = 916,
        widehud = 350,
        male = true,
        clear = false,
        hud = false,
        tar = 'тэг',
        parol = 'пароль',
        parolb = false,
        tarb = false,
        clistb = false,
        spzamen = false,
        clist = 0,
        offptrl = false,
        offwntd = false,
        tchat = false,
        autocar = false,
        strobs = true,
        megaf = true,
        autobp = false,
        googlecode = '',
        googlecodeb = false,
        group = 'unknown',
        nwanted = false,
        nclear = false
    },
    commands = {
        cput = true,
        ceject = true,
        deject = true,
        ftazer = true,
        zaderjka = 1400,
        ticket = true,
        kmdctime = true
    },
    autobp = {
        deagle = true,
        dvadeagle = true,
        shot = true,
        dvashot = true,
        smg = true,
        dvasmg = true,
        m4 = true,
        dvam4 = true,
        rifle = true,
        dvarifle = true,
        armour = true,
        spec = true
    }
}

if limgui then 
    mainw           = imgui.ImBool(false)
    setwindows      = imgui.ImBool(false)
    shpwindow       = imgui.ImBool(false)
    ykwindow        = imgui.ImBool(false)
    fpwindow        = imgui.ImBool(false)
    akwindow        = imgui.ImBool(false)
    pozivn          = imgui.ImBool(false)
    updwindows      = imgui.ImBool(false)
    bMainWindow     = imgui.ImBool(false)
    bindkey         = imgui.ImBool(false)
    cmdwind         = imgui.ImBool(false)
    memw            = imgui.ImBool(false)
    sInputEdit      = imgui.ImBuffer(256)
    bIsEnterEdit    = imgui.ImBool(false)
    piew            = imgui.ImBool(false)
    imegaf          = imgui.ImBool(false)
    bindname        = imgui.ImBuffer(256)
    bindtext        = imgui.ImBuffer(20480)
    groupInt        = imgui.ImInt(0)
    vars = {
        menuselect  = 0,
        mainwindow  = imgui.ImBool(false),
        cmdbuf      = imgui.ImBuffer(256),
        cmdparams   = imgui.ImInt(0),
        cmdtext     = imgui.ImBuffer(20480)
    }
end

function ftext(text)
    sampAddChatMessage((' %s | {ffffff}%s'):format(script.this.name, text),0x9966CC)
end

local config_keys = {
    oopda = { v = {key.VK_F12}},
    oopnet = { v = {key.VK_F11}},
    tazerkey = { v = {key.VK_X}},
    fastmenukey = { v = {key.VK_F2}},
    megafkey = { v = {18,77}},
    dkldkey = { v = {18,80}},
    cuffkey = { v = {}},
    followkey = { v = {}},
    cputkey = { v = {}},
    cejectkey = { v = {}},
    takekey = { v = {}},
    arrestkey = { v = {}},
    uncuffkey = { v = {}},
    dejectkey = { v = {}},
    sirenkey = { v = {}},
    hikey = {v = {key.VK_I}},
	summakey = {v = {key.VK_L}},
	freenalkey = {v = {key.VK_Y}},
    freebankkey = {v = {key.VK_U}},
    vzaimkey = {v = {key.VK_Z}}
}

local mcheckb = false
local stazer = false
local rabden = false
local frak = -1
local rang = -1
local warnst = false
local changetextpos = false
local opyatstat = false
local gmegafid = -1
local targetid = -1
local smsid = -1
local smstoid = -1
local mcid = -1
local vixodid = {}
local ins = {}
local ooplistt = {}
local tLastKeys = {}
local departament = {}
local radio = {}
local sms = {}
local wanted = {}
local incar = {}
local suz = {}
local show = 1
local autoBP = 1
local checkstat = false
local fileb = getWorkingDirectory() .. "\\config\\fbitools.bind"
local tMembers = {}
local Player = {}
local tBindList = {}
local commands = {}
local fthelp = {
    {
        cmd = '/ft',
        desc = 'Открыть меню скрипта',
        use = '/ft'
    },
    {
        cmd = '/st',
        desc = 'Попросить игрока заглушить свое Т/С через мегафон [/m]',
        use = '/st [id]'
    },
    {
        cmd = '/oop',
        desc = 'Написать в волну департамента об ООП',
        use = '/oop [id]'
    },
    {
        cmd = '/warn',
        desc = 'Предупредить игрока в волну департамента о нарушении подачи в розыск',
        use = '/warn [id]'
    },
    {
        cmd = '/su',
        desc = 'Выдать розыск через диалог',
        use = '/su [id]'
    },
    {
        cmd = '/ssu',
        desc = 'Выдать розыск через серверную команду',
        use = '/ssu [id] [кол-во звезд] [причина]'
    },
    {
        cmd = '/cput',
        desc = 'РП отыгровка посадки преступника в автомобиль/мото',
        use = '/cput [id] [сиденье(не обязательно)]'
    },
    {
        cmd = '/ceject',
        desc = 'РП отыгровка высадки преступника из автомобиля/мото',
        use = '/ceject [id]'
    },
    {
        cmd = '/deject',
        desc = 'РП отыгровка вытаскивания преступника из автомобиля/мото',
        use = '/deject [id]'
    },
    {
        cmd = '/ms',
        desc = 'РП отыгровка взятия маскировки',
        use = '/ms [тип]'
    },
    {
        cmd = '/keys',
        desc = "РП отыгровка сравнения ключей от КПЗ",
        use = '/keys'
    },
    {
        cmd = '/rh',
        desc = "Запросить патрульный экипаж в текущий квадрат",
        use = "/rh [департамент(1 - LSPD, 2 - SFPD, 3 - LVPD)]"
    },
    {
        cmd = '/tazer',
        desc = "РП тазер",
        use = '/tazer'
    },
    {
        cmd = "/gr",
        desc = "Написать в волну департамента о пересечении юрисдикции",
        use = "/gr [департамент(1 - LSPD, 2 - SFPD, 3 - LVPD)] [причина]"
    },
    {
        cmd = '/df',
        desc = "Открыть диалог с разминированием бомб",
        use = '/df'
    },
    {
        cmd = '/dmb',
        desc = 'Открыть /members в диалоге',
        use = '/dmb'
    },
    {
        cmd = '/ar',
        desc = 'Попросить разрешение на въезд на военную территорию в волну департамента',
        use = '/ar [армия(1 - LVA, 2 - SFA)]'
    },
    {
        cmd = '/pr',
        desc = 'Правила миранды',
        use = '/pr'
    },
    {
        cmd = '/kmdc',
        desc = 'По РП пробить игрока в КПК',
        use = '/kmdc [id]'
    },
    {
        cmd = '/ftazer',
        desc = 'РП отыгровка /ftazer',
        use = '/ftazer [тип]'
    },
    {
        cmd = '/fvz',
        desc = 'Вызвать игрока в офис ФБР со старшими',
        use = '/fvz [id]'
    },
    {
        cmd = '/fbd',
        desc = 'Запросить причину изменения БД по волне департамента',
        use = '/fbd [id]'
    },
    {
        cmd = '/blg',
        desc = 'Выразить благодарность по волне департамента',
        use = "/blg [id] [фракция] [причина]"
    },
    {
        cmd = '/yk',
        desc = "Открыть шпору УК (Текст шпоры можно изменить в файле moonloader/fbitools/yk.txt)",
        use = "/yk"
    },
    {
        cmd = '/ak',
        desc = "Открыть шпору АК (Текст шпоры можно изменить в файле moonloader/fbitools/ak.txt)",
        use = "/ak"
    },
    {
        cmd = '/fp',
        desc = "Открыть шпору ФП (Текст шпоры можно изменить в файле moonloader/fbitools/fp.txt)",
        use = "/fp"
    },
    {
        cmd = '/shp',
        desc = "Открыть шпору (Текст шпоры можно изменить в файле moonloader/fbitools/shp.txt)",
        use = "/shp"
    },
    {
        cmd = '/fyk',
        desc = 'Поиск по шпоре УК',
        use = '/fyk [текст]'
    },
    {
        cmd = '/fak',
        desc = 'Поиск по шпоре АК',
        use = '/fak [текст]'
    },
    {
        cmd = '/ffp',
        desc = 'Поиск по шпоре ФП',
        use = '/ffp [текст]'
    },
    {
        cmd = '/fshp',
        desc = 'Поиск по шпоре',
        use = '/fshp [текст]'
    },
    {
        cmd = '/fst',
        desc = 'Изменить время',
        use = '/fst [время]'
    },
    {
        cmd = '/fsw',
        desc = 'Изменить погоду',
        use = '/fsw [погода]'
    },
    {
        cmd = '/cc',
        desc = 'Очистить чат',
        use = '/cc'
    },
    {
        cmd = '/dkld',
        desc = 'Сделать доклад',
        use = '/dkld'
    },
    {
        cmd = '/mcheck',
        desc = 'Пробить по /mdc всех на расстоянии 200 метров',
        use = '/mcheck'
    },
    {
        cmd = '/megaf',
        desc = 'Мегафон с автоотпределением авто',
        use = '/megaf'
    },
    {
        cmd = '/rlog',
        desc = 'Открыть лог 25 последних сообщений в рацию',
        use = '/rlog'
    },
    {
        cmd = '/dlog',
        desc = 'Открыть лог 25 последних сообщений в департамент',
        use = '/dlog'
    },
    {
        cmd = '/sulog',
        desc = 'Открыть лог 25 последних выдачи розыска',
        use = '/sulog'
    },
    {
        cmd = '/smslog',
        desc = 'Открыть лог 25 последних SMS',
        use = '/smslog'
    },
    {
        cmd = '/z',
        desc = 'Выдать розыск по заготовленым статьям',
        use = '/z [id] [параметр(не обязательно)]'
    },
    {
        cmd = '/rt',
        desc = 'Сообщение в рацию без тэга',
        use = '/rt [текст]'
    },
    {
        cmd = '/ooplist',
        desc = 'Список ООП',
        use = '/ooplist [id(не обязательно)]'
    },
    {
        cmd = '/fkv',
        desc = 'Поставить метку на квадрат на карте',
        use = '/fkv [квадрат]'
    },
    {
        cmd = '/fnr',
        desc = 'Созвать сотрудников на работу',
        use = '/fnr'
    }
}
local tEditData = {
	id = -1,
	inputActive = false
}
local quitReason = {
    [1] = 'Выход',
    [2] = 'Кик/Бан',
    [0] = 'Краш/Вылет'
}
local sut = [[
Нанесение телесных повреждений - 2 года
Вооруженное нападение на гражданских - 3 года
Вооруженное нападение на гос - 6 лет, запрет на адвоката
Хулиганство - 1 год
Неадекватное поведение - 1 год
Попрошайничество - 1 год
Оскорбление - 2 года
Угон транспортного средства - 2 года
Неподчинение сотрудникам ПО - 1 год
Уход от сотрудников ПО - 2 года
Побег с места заключения - 6 лет
Ношение оружия без лицензии - 1 год и штраф в размере 2000$.
Изготовление нелегального оружия - 3 года и изъятие
Приобретение нелегального оружия - 3 года и изъятие
Продажа нелегального оружия - 3 года и изъятие
Хранение наркотиков - 3 года и изъятие
Хранение материалов - 3 года и изъятие
Употребление наркотиков - 3 года и изъятие
Порча чужого имущества - 1 год и штраф в размере 5000$
Уничтожение чужого имущества - 4 года и штраф в размере 15000$
Проникновение на охр. территорию - 2 года
Проникновение на част. территорию - 1 год
Вымогательство - 2 года
Угрозы - 1 год
Провокации - 2 года
Мошенничество - 2 года
Предложение интимных услуг - 1 год
Изнасилование гражданина - 3 год
Укрывательство преступлений - 2 года
Использование фальшивых документов - 1 год
Клевета на гос. лицо - 1 год
Клевета на гос. организации - 2 года
Ношение военной формы - 2 года, форма подлежит изъятию.
Покупка ключей от камеры - 6 лет
Предложение взятки - 2 года
Совершение теракта - 6 лет, лишение всех лицензий
Неуплата штрафа - 2 года
Игнорирование спец. сирен - 1 год
Превышение полномочий адвоката - 3 года
Похищение гос. сотрудника - 4 года
Чистосердечное признание - 1 год
Наезд на пешехода - 2 года
Уход с места ДТП - 3 года
Ограбление - 3 года
ООП - 6 лет
Уход - 6 лет
]]

local shpt = [[
Пока что вы не настроили шпору.
Что бы вставить сюда свой текст вам нужно выполнить ряд дейтсвий:
1. Открыть папку fbitools которая находится в папке moonloader
2. Открыть файл shp.txt любым блокнотом
3. Изменить текст в нем на какой вам нужен
4. Сохранить файл
]]

function sampGetStreamedPlayers()
	local t = {}
	for i = 0, sampGetMaxPlayerId(false) do
		if sampIsPlayerConnected(i) then
			local result, sped = sampGetCharHandleBySampPlayerId(i)
			if result then
				if doesCharExist(sped) then
					table.insert(t, i)
                end
			end
		end
    end
	return t
end

function sirenk()
    if cfg.main.group == 'ПД/ФБР' then 
        if isCharInAnyCar(PLAYER_PED) then
            local car = storeCarCharIsInNoSave(PLAYER_PED)
            switchCarSiren(car, not isCarSirenOn(car))
        end
    end
end

function getClosestPlayerId()
    local minDist = 9999
    local closestId = -1
    local x, y, z = getCharCoordinates(PLAYER_PED)
    for i = 0, 999 do
        local streamed, pedID = sampGetCharHandleBySampPlayerId(i)
        if streamed then
            local xi, yi, zi = getCharCoordinates(pedID)
            local dist = math.sqrt( (xi - x) ^ 2 + (yi - y) ^ 2 + (zi - z) ^ 2 )
            if dist < minDist and sampGetFraktionBySkin(i) ~= 'Полиция' and sampGetFraktionBySkin(i) ~= 'FBI' then
                minDist = dist
                closestId = i
            end
        end
    end
    return closestId
end
function getClosestPlayerIDinCar()
    local minDist = 9999
    local closestId = -1
    local x, y, z = getCharCoordinates(PLAYER_PED)
    local veh = storeCarCharIsInNoSave(PLAYER_PED)
    for i = 0, 999 do
        local streamed, pedID = sampGetCharHandleBySampPlayerId(i)
        if streamed then
            local xi, yi, zi = getCharCoordinates(pedID)
            local dist = math.sqrt( (xi - x) ^ 2 + (yi - y) ^ 2 + (zi - z) ^ 2 )
            if dist < minDist and sampGetFraktionBySkin(i) ~= 'Полиция' and sampGetFraktionBySkin(i) ~= 'FBI' and isCharInAnyCar(pedID) then
                if storeCarCharIsInNoSave(pedID) == veh then
                    minDist = dist
                    closestId = i
                end
            end
        end
    end
    return closestId
end

function getClosestPlayerIDinCarD()
    local minDist = 9999
    local closestId = -1
    local x, y, z = getCharCoordinates(PLAYER_PED)
    for i = 0, 999 do
        local streamed, pedID = sampGetCharHandleBySampPlayerId(i)
        if streamed then
            local xi, yi, zi = getCharCoordinates(pedID)
            local dist = math.sqrt( (xi - x) ^ 2 + (yi - y) ^ 2 + (zi - z) ^ 2 )
            if dist < minDist and sampGetFraktionBySkin(i) ~= 'Полиция' and sampGetFraktionBySkin(i) ~= 'FBI' and isCharInAnyCar(pedID) then
                minDist = dist
                closestId = i
            end
        end
    end
    return closestId
end

function cuffk()
    if cfg.main.group == 'ПД/ФБР' then 
        local valid, ped = getCharPlayerIsTargeting(PLAYER_HANDLE)
        if valid then
            result, targetid = sampGetPlayerIdByCharHandle(ped)
            if result then
                lua_thread.create(function()
                    sampSendChat(string.format('/me %s руки преступника и %s наручники', cfg.main.male and 'заломал' or 'заломала', cfg.main.male and 'достал' or 'достала'))
                    wait(1400)
                    sampSendChat('/cuff '..targetid)
                    gmegafhandle = ped
                    gmegafid = targetid
                    gmegaflvl = sampGetPlayerScore(targetid)
                    gmegaffrak = sampGetFraktionBySkin(targetid)
                end)
            end
        else
            local closeid = getClosestPlayerId()
            if closeid ~= -1 then 
                local result, closehandle = sampGetCharHandleBySampPlayerId(closeid)
                if doesCharExist(closehandle) then
                    lua_thread.create(function()
                        sampSendChat(string.format('/me %s руки преступника и %s наручники', cfg.main.male and 'заломал' or 'заломала', cfg.main.male and 'достал' or 'достала'))
                        wait(1400)
                        sampSendChat('/cuff '..closeid)
                        gmegafhandle = closehandle
                        gmegafid = closeid
                        gmegaflvl = sampGetPlayerScore(closeid)
                        gmegaffrak = sampGetFraktionBySkin(closeid)
                    end)
                end
            end
        end
    end
end

function uncuffk()
    if cfg.main.group == 'ПД/ФБР' then 
        local valid, ped = getCharPlayerIsTargeting(PLAYER_HANDLE)
        if valid then
            local result, targetid = sampGetPlayerIdByCharHandle(ped)
            if result then
                lua_thread.create(function()
                    sampSendChat(string.format('/me %s наручники с преступника', cfg.main.male and 'снял' or 'сняла'))
                    wait(1400)
                    sampSendChat('/uncuff '..targetid)
                    gmegafhandle = nil
                    gmegafid = -1
                    gmegaflvl = nil
                    gmegaffrak = nil
                end)
            end
        else
            local closeid = getClosestPlayerId()
            if sampIsPlayerConnected(closeid) then
                if closeid ~= -1 then
                    local result, closehandle = sampGetCharHandleBySampPlayerId(closeid)
                    if doesCharExist(closehandle) then
                        lua_thread.create(function()
                            sampSendChat(string.format('/me %s наручники с преступника', cfg.main.male and 'снял' or 'сняла'))
                            wait(1400)
                            sampSendChat('/uncuff '..closeid)
                            gmegafhandle = nil
                            gmegafid = -1
                            gmegaflvl = nil
                            gmegaffrak = nil
                        end)
                    end
                end
            end
        end
    end
end

function followk()
    if cfg.main.group == 'ПД/ФБР' then 
        local valid, ped = getCharPlayerIsTargeting(PLAYER_HANDLE)
        if valid then
            result, targetid = sampGetPlayerIdByCharHandle(ped)
            if result then
                lua_thread.create(function()
                    sampSendChat(string.format('/me %s один из концов наручников к себе, после чего %s за собой преступника', cfg.main.male and 'пристегнул' or 'пристегнула', cfg.main.male and 'повел' or 'повела'))
                    wait(1400)
                    sampSendChat('/follow '..targetid)
                    gmegafhandle = ped
                    gmegafid = targetid
                    gmegaflvl = sampGetPlayerScore(targetid)
                    gmegaffrak = sampGetFraktionBySkin(targetid)
                end)
            end
        else
            local closeid = getClosestPlayerId()
            if closeid ~= -1 then 
                local result, closehandle = sampGetCharHandleBySampPlayerId(closeid)
                if doesCharExist(closehandle) then
                    lua_thread.create(function()
                        sampSendChat(string.format('/me %s один из концов наручников к себе, после чего %s за собой преступника', cfg.main.male and 'пристегнул' or 'пристегнула', cfg.main.male and 'повел' or 'повела'))
                        wait(1400)
                        sampSendChat('/follow '..closeid)
                        gmegafhandle = closehandle
                        gmegafid = closeid
                        gmegaflvl = sampGetPlayerScore(closeid)
                        gmegaffrak = sampGetFraktionBySkin(closeid)
                    end)
                end
            end
        end
    end
end

function cputk()
    if cfg.main.group == 'ПД/ФБР' then 
        local closeid = getClosestPlayerId()
        if closeid ~= -1 then
            local result, closehandle = sampGetCharHandleBySampPlayerId(closeid)
            if doesCharExist(closehandle) then
                lua_thread.create(function()
                    if isCharOnAnyBike(PLAYER_PED) then
                        sampSendChat(string.format("/me %s преступника на сиденье мотоцикла", cfg.main.male and 'посадил' or 'посадила'))
                        wait(1400)
                        sampSendChat("/cput "..closeid.." 1", -1)
                    else
                        sampSendChat(string.format("/me %s дверь автомобиля и %s туда преступника", cfg.main.male and 'открыл' or 'открыла', cfg.main.male and 'затолкнул' or 'затолкнула'))
                        wait(1400)
                        sampSendChat("/cput "..closeid.." "..getFreeSeat(), -1)
                    end
                    gmegafhandle = closehandle
                    gmegafid = closeid
                    gmegaflvl = sampGetPlayerScore(closeid)
                    gmegaffrak = sampGetFraktionBySkin(closeid)
                end)
            end
        end
    end
end

function cejectk()
    if cfg.main.group == 'ПД/ФБР' then 
        if isCharInAnyCar(PLAYER_PED) then
            local closestId = getClosestPlayerIDinCar()
            if closestId ~= -1 then
                local result, closehandle = sampGetCharHandleBySampPlayerId(closestId)
                lua_thread.create(function()
                    if isCharOnAnyBike(PLAYER_PED) then
                        sampSendChat(string.format("/me %s преступника с мотоцикла", cfg.main.male and 'высадил' or 'высадила'))
                        wait(1400)
                        sampSendChat("/ceject "..closestId, -1)
                    else
                        sampSendChat(string.format("/me %s дверь автомобиля и %s преступника", cfg.main.male and 'открыл' or 'открыл', cfg.main.male and 'высадил' or 'высадила'))
                        wait(1400)
                        sampSendChat("/ceject "..closestId)
                    end
                    gmegafhandle = closehandle
                    gmegafid = closestId
                    gmegaflvl = sampGetPlayerScore(closestId)
                    gmegaffrak = sampGetFraktionBySkin(closestId)
                end)
            end
        end
    end
end

function takek()
    if cfg.main.group == 'ПД/ФБР' then 
        local valid, ped = getCharPlayerIsTargeting(PLAYER_HANDLE)
        if valid then
            result, targetid = sampGetPlayerIdByCharHandle(ped)
            if result then
                lua_thread.create(function()
                    sampSendChat(string.format('/me надев перчатки, %s руками по торсу', cfg.main.male and 'провел' or 'провела'))
                    wait(1400)
                    sampSendChat('/take '..targetid)
                    gmegafhandle = ped
                    gmegafid = targetid
                    gmegaflvl = sampGetPlayerScore(targetid)
                    gmegaffrak = sampGetFraktionBySkin(targetid)
                end)
            end
        else
            local closeid = getClosestPlayerId()
            if closeid ~= -1 then 
                local result, closehandle = sampGetCharHandleBySampPlayerId(closeid)
                if doesCharExist(closehandle) then
                    lua_thread.create(function()
                        sampSendChat(string.format('/me надев перчатки, %s руками по торсу', cfg.main.male and 'провел' or 'провела'))
                        wait(cfg.commands.zaderjka)
                        sampSendChat('/take '..closeid)
                        gmegafhandle = closehandle
                        gmegafid = closeid
                        gmegaflvl = sampGetPlayerScore(closeid)
                        gmegaffrak = sampGetFraktionBySkin(closeid)
                    end)
                end
            end
        end
    end
end

function arrestk()
    if cfg.main.group == 'ПД/ФБР' then 
        local valid, ped = getCharPlayerIsTargeting(PLAYER_HANDLE)
        if valid then
            result, targetid = sampGetPlayerIdByCharHandle(ped)
            if result then
                lua_thread.create(function()
                    --[[sampSendChat(string.format('/me %s камеру', cfg.main.male and 'открыл' or 'открыла'))
                    wait(cfg.commands.zaderjka)
                    sampSendChat(string.format('/me %s преступника в камеру', cfg.main.male and 'провел' or 'провела'))
                    wait(cfg.commands.zaderjka)
                    sampSendChat('/arrest '..targetid)
                    wait(cfg.commands.zaderjka)
                    sampSendChat(string.format('/me %s камеру', cfg.main.male and 'закрыл' or 'закрыла'))]]
                    sampSendChat("/do Ключи от камеры висят на поясе.")
                    wait(cfg.commands.zaderjka)
                    sampSendChat(string.format("/me %s ключи с пояса и %s камеру, после %s туда преступника", cfg.main.male and 'снял' or 'сняла', cfg.main.male and 'открыл' or 'открыла', cfg.main.male and 'затолкнул' or 'затолкнула'))
                    wait(cfg.commands.zaderjka)
                    sampSendChat('/arrest '..targetid)
                    wait(cfg.commands.zaderjka)
                    sampSendChat(string.format("/me %s дверь камеры и %s ключи на пояс", cfg.main.male and 'закрыл' or 'закрыла', cfg.main.male and 'повесил' or 'повесила'))
                    gmegafhandle = nil
                    gmegafid = -1
                    gmegaflvl = nil
                    gmegaffrak = nil
                end)
            end
        else
            local closeid = getClosestPlayerId()
            if closeid ~= -1 then 
                local result, closehandle = sampGetCharHandleBySampPlayerId(closeid)
                if doesCharExist(closehandle) then
                    lua_thread.create(function()
                        --[[sampSendChat(string.format('/me %s камеру', cfg.main.male and 'открыл' or 'открыла'))
                        wait(cfg.commands.zaderjka)
                        sampSendChat(string.format('/me %s преступника в камеру', cfg.main.male and 'провел' or 'провела'))
                        wait(cfg.commands.zaderjka)
                        sampSendChat('/arrest '..closeid)
                        wait(cfg.commands.zaderjka)
                        sampSendChat(string.format('/me %s камеру', cfg.main.male and 'закрыл' or 'закрыла'))]]
                        sampSendChat("/do Ключи от камеры висят на поясе.")
                        wait(cfg.commands.zaderjka)
                        sampSendChat(string.format("/me %s ключи с пояса и %s камеру, после %s туда преступника", cfg.main.male and 'снял' or 'сняла', cfg.main.male and 'открыл' or 'открыла', cfg.main.male and 'затолкнул' or 'затолкнула'))
                        wait(cfg.commands.zaderjka)
                        sampSendChat('/arrest '..closeid)
                        wait(cfg.commands.zaderjka)
                        sampSendChat(string.format("/me %s дверь камеры и %s ключи на пояс", cfg.main.male and 'закрыл' or 'закрыла', cfg.main.male and 'повесил' or 'повесила'))
                        gmegafhandle = nil
                        gmegafid = -1
                        gmegaflvl = nil
                        gmegaffrak = nil
                    end)
                end
            end
        end
    end
end

function dejectk()
    if cfg.main.group == 'ПД/ФБР' then 
        local closestId = getClosestPlayerIDinCarD()
        if closestId ~= -1 then
            local result, closehandle = sampGetCharHandleBySampPlayerId(closestId)
            if result then
                lua_thread.create(function()
                    if isCharInFlyingVehicle(closehandle) then
                        sampSendChat(string.format("/me %s дверь вертолёта и %s преступника", cfg.main.male and 'открыл' or 'открыла', cfg.main.male and 'вытащил' or 'вытащила'))
                        wait(1400)
                        sampSendChat("/deject "..closestId)
                    elseif isCharInModel(closehandle, 481) or isCharInModel(closehandle, 510) then
                        sampSendChat(string.format("/me скинул преступника с велосипеда", cfg.main.male and 'скинул' or 'скинула'))
                        wait(1400)
                        sampSendChat("/deject "..closestId)
                    elseif isCharInModel(closehandle, 462) then
                        sampSendChat(string.format("/me %s преступника со скутера", cfg.main.male and 'скинул' or 'скинула'))
                        wait(1400)
                        sampSendChat("/deject "..closestId)
                    elseif isCharOnAnyBike(closehandle) then
                        sampSendChat(string.format("/me %s преступника с мотоцикла", cfg.main.male and 'скинул' or 'скинула'))
                        wait(1400)
                        sampSendChat("/deject "..closestId)
                    elseif isCharInAnyCar(closehandle) then
                        sampSendChat(string.format("/me %s окно и %s преступника из машины", cfg.main.male and 'разбил' or 'разбила', cfg.main.male and 'вытолкнул' or 'вытолкнула'))
                        wait(1400)
                        sampSendChat("/deject "..closestId)
                    end
                end)
            end
        end
    end
end

function hikeyk()
	if cfg.main.group == 'Мэрия' then
		lua_thread.create(function()
			sampSendChat(string.format('Приветствую, я адвокат %s. Кто нуждается в моих услугах?', sampGetPlayerNickname(select(2, sampGetPlayerIdByCharHandle(PLAYER_PED))):gsub('_', ' ')))
			wait(1400)
			sampSendChat(string.format('/b /showpass %s', select(2, sampGetPlayerIdByCharHandle(PLAYER_PED))))
		end)
	end
end

function summakeyk()
	if cfg.main.group == 'Мэрия' then
		lua_thread.create(function()
			local valid, tped = getCharPlayerIsTargeting(PLAYER_HANDLE)
			if valid and doesCharExist(tped) then
				local result, tid = sampGetPlayerIdByCharHandle(tped)
				if result then
					local tlvl = sampGetPlayerScore(tid)
					sampSendChat(string.format('Сумма вашего вызволения составляет %s.', getFreeCost(tlvl)))
					wait(1400)
					sampSendChat('Чем желаете оплатить, банком или наличными?')
				end
			end
		end)
	end
end

function freenalkeyk()
	if cfg.main.group == 'Мэрия' then
		lua_thread.create(function()
			local valid, tped = getCharPlayerIsTargeting(PLAYER_HANDLE)
			if valid and doesCharExist(tped) then
				local result, tid = sampGetPlayerIdByCharHandle(tped)
				if result then
					local tlvl = sampGetPlayerScore(tid)
					sampSendChat('/me достал бланк из кейса и начал его заполнять')
					wait(1400)
					sampSendChat('/me поставил печать в бланке и передал заключенному')
					wait(1400)
					sampSendChat(string.format('/free %s 1 %s', tid, getFreeCost(tlvl)))
				end
			end
		end)
	end
end

function freebankkeyk()
	if cfg.main.group == 'Мэрия' then
		lua_thread.create(function()
			local valid, tped = getCharPlayerIsTargeting(PLAYER_HANDLE)
			if valid and doesCharExist(tped) then
				local result, tid = sampGetPlayerIdByCharHandle(tped)
				if result then
					local tlvl = sampGetPlayerScore(tid)
					sampSendChat('/me достал бланк из кейса и начал его заполнять')
					wait(1400)
					sampSendChat('/me поставил печать в бланке и передал заключенному')
					wait(1400)
					sampSendChat(string.format('/free %s 2 %s', tid, getFreeCost(tlvl)))
				end
			end
		end)
	end
end

function vzaimk()
    local valid, ped = getCharPlayerIsTargeting(PLAYER_HANDLE)
    if valid and doesCharExist(ped) then
        local result, id = sampGetPlayerIdByCharHandle(ped)
        --targetid = id
        if result then
            if cfg.main.group == 'ПД/ФБР' then
                gmegafhandle = ped
                gmegafid = id
                gmegaflvl = sampGetPlayerScore(id)
                gmegaffrak = sampGetFraktionBySkin(id)
                submenus_show(pkmmenuPD(id), "{9966cc}"..script.this.name.." {ffffff}| "..sampGetPlayerNickname(id).." ["..id.."] ")
            elseif cfg.main.group == "Автошкола" then
                submenus_show(pkmmenuAS(id), "{9966cc}"..script.this.name.." {ffffff}| "..sampGetPlayerNickname(id).." ["..id.."] ")
            elseif cfg.main.group == "Медики" then
                submenus_show(pkmmenuMOH(id), "{9966cc}"..script.this.name.." {ffffff}| "..sampGetPlayerNickname(id).." ["..id.."] ")
            end
        end
    end
end

function sampGetFraktionBySkin(id)
    local skin = 0
    local t = 'Гражданский'
    --if sampIsPlayerConnected(id) then
        local result, ped = sampGetCharHandleBySampPlayerId(id)
        if result then
            skin = getCharModel(ped)
        else
            skin = getCharModel(PLAYER_PED)
        end
        if skin == 102 or skin == 103 or skin == 104 or skin == 195 or skin == 21 then t = 'Ballas Gang' end
        if skin == 105 or skin == 106 or skin == 107 or skin == 269 or skin == 270 or skin == 271 or skin == 86 or skin == 149 or skin == 297 then t = 'Grove Gang' end
        if skin == 108 or skin == 109 or skin == 110 or skin == 190 or skin == 47 then t = 'Vagos Gang' end
        if skin == 114 or skin == 115 or skin == 116 or skin == 48 or skin == 44 or skin == 41 or skin == 292 then t = 'Aztec Gang' end
        if skin == 173 or skin == 174 or skin == 175 or skin == 193 or skin == 226 or skin == 30 or skin == 119 then t = 'Rifa Gang' end
        if skin == 191 or skin == 252 or skin == 287 or skin == 61 or skin == 179 or skin == 255 then t = 'Army' end
        if skin == 57 or skin == 98 or skin == 147 or skin == 150 or skin == 187 or skin == 216 then t = 'Мэрия' end
        if skin == 59 or skin == 172 or skin == 189 or skin == 240 then t = 'Автошкола' end
        if skin == 201 or skin == 247 or skin == 248 or skin == 254 or skin == 248 or skin == 298 then t = 'Байкеры' end
        if skin == 272 or skin == 112 or skin == 125 or skin == 214 or skin == 111  or skin == 126 then t = 'Русская мафия' end
        if skin == 113 or skin == 124 or skin == 214 or skin == 223 then t = 'La Cosa Nostra' end
        if skin == 120 or skin == 123 or skin == 169 or skin == 186 then t = 'Yakuza' end
        if skin == 211 or skin == 217 or skin == 250 or skin == 261 then t = 'News' end
        if skin == 70 or skin == 219 or skin == 274 or skin == 275 or skin == 276 or skin == 70 then t = 'Медики' end
        if skin == 286 or skin == 141 or skin == 163 or skin == 164 or skin == 165 or skin == 166 then t = 'FBI' end
        if skin == 280 or skin == 265 or skin == 266 or skin == 267 or skin == 281 or skin == 282 or skin == 288 or skin == 284 or skin == 285 or skin == 304 or skin == 305 or skin == 306 or skin == 307 or skin == 309 or skin == 283 or skin == 303 then t = 'Полиция' end
    --end
    return t
end

function sampGetPlayerIdByNickname(nick)
    local _, myid = sampGetPlayerIdByCharHandle(playerPed)
    if tostring(nick) == sampGetPlayerNickname(myid) then return myid end
    for i = 0, 1000 do if sampIsPlayerConnected(i) and sampGetPlayerNickname(i) == tostring(nick) then return i end end
end

function getMaskList(forma)
	local mask = {
		['гражданского'] = 0,
		['полицейского'] = 1,
		['военного'] = 2,
		['лаборатория'] = 3,
		['медика'] = 3,
		['сотрудника мэрии'] = 4,
		['работника автошколы'] = 5,
		['работника новостей'] = 6,
		['ЧОП LCN'] = 7,
		['ЧОП Yakuza'] = 8,
		['ЧОП Russian Mafia'] = 9,
		['БК Rifa'] = 10,
		['БК Grove'] = 11,
		['БК Ballas'] = 12,
		['БК Vagos'] = 13,
		['БК Aztec'] = 14,
		['байкеров'] = 15
	}
	return mask[forma]
end

local russian_characters = {
    [168] = 'Ё', [184] = 'ё', [192] = 'А', [193] = 'Б', [194] = 'В', [195] = 'Г', [196] = 'Д', [197] = 'Е', [198] = 'Ж', [199] = 'З', [200] = 'И', [201] = 'Й', [202] = 'К', [203] = 'Л', [204] = 'М', [205] = 'Н', [206] = 'О', [207] = 'П', [208] = 'Р', [209] = 'С', [210] = 'Т', [211] = 'У', [212] = 'Ф', [213] = 'Х', [214] = 'Ц', [215] = 'Ч', [216] = 'Ш', [217] = 'Щ', [218] = 'Ъ', [219] = 'Ы', [220] = 'Ь', [221] = 'Э', [222] = 'Ю', [223] = 'Я', [224] = 'а', [225] = 'б', [226] = 'в', [227] = 'г', [228] = 'д', [229] = 'е', [230] = 'ж', [231] = 'з', [232] = 'и', [233] = 'й', [234] = 'к', [235] = 'л', [236] = 'м', [237] = 'н', [238] = 'о', [239] = 'п', [240] = 'р', [241] = 'с', [242] = 'т', [243] = 'у', [244] = 'ф', [245] = 'х', [246] = 'ц', [247] = 'ч', [248] = 'ш', [249] = 'щ', [250] = 'ъ', [251] = 'ы', [252] = 'ь', [253] = 'э', [254] = 'ю', [255] = 'я',
}
function string.rlower(s)
    s = s:lower()
    local strlen = s:len()
    if strlen == 0 then return s end
    s = s:lower()
    local output = ''
    for i = 1, strlen do
        local ch = s:byte(i)
        if ch >= 192 and ch <= 223 then
            output = output .. russian_characters[ch + 32]
        elseif ch == 168 then
            output = output .. russian_characters[184]
        else
            output = output .. string.char(ch)
        end
    end
    return output
end
function string.rupper(s)
    s = s:upper()
    local strlen = s:len()
    if strlen == 0 then return s end
    s = s:upper()
    local output = ''
    for i = 1, strlen do
        local ch = s:byte(i)
        if ch >= 224 and ch <= 255 then
            output = output .. russian_characters[ch - 32]
        elseif ch == 184 then
            output = output .. russian_characters[168]
        else
            output = output .. string.char(ch)
        end
    end
    return output
end
function submenus_show(menu, caption, select_button, close_button, back_button)
    select_button, close_button, back_button = select_button or '»', close_button or 'x', back_button or '«'
    prev_menus = {}
    function display(menu, id, caption)
        local string_list = {}
        for i, v in ipairs(menu) do
            table.insert(string_list, type(v.submenu) == 'table' and v.title .. ' »' or v.title)
        end
        sampShowDialog(id, caption, table.concat(string_list, '\n'), select_button, (#prev_menus > 0) and back_button or close_button, sf.DIALOG_STYLE_LIST)
        repeat
            wait(0)
            local result, button, list = sampHasDialogRespond(id)
            if result then
                if button == 1 and list ~= -1 then
                    local item = menu[list + 1]
                    if type(item.submenu) == 'table' then
                        table.insert(prev_menus, {menu = menu, caption = caption})
                        if type(item.onclick) == 'function' then
                            item.onclick(menu, list + 1, item.submenu)
                        end
                        return display(item.submenu, id + 1, item.submenu.title and item.submenu.title or item.title)
                    elseif type(item.onclick) == 'function' then
                        local result = item.onclick(menu, list + 1)
                        if not result then return result end
                        return display(menu, id, caption)
                    end
                else
                    if #prev_menus > 0 then
                        local prev_menu = prev_menus[#prev_menus]
                        prev_menus[#prev_menus] = nil
                        return display(prev_menu.menu, id - 1, prev_menu.caption)
                    end
                    return false
                end
            end
        until result
    end
    return display(menu, 31337, caption or menu.title)
end

local dfmenu = {
    {
        title = 'Бомба с часовым механизмом',
        onclick = function()
            sampSendChat(("/me %s саперный набор"):format(cfg.main.male and 'достал' or 'достала'))
            wait(3500)
            sampSendChat(("/me %s саперный набор"):format(cfg.main.male and 'открыл' or 'открыла'))
            wait(3500)
            sampSendChat(("/me %s взрывное устройство"):format(cfg.main.male and 'осмотрел' or 'осмотрела'))
            wait(3500)
            sampSendChat(("/do %s тип взрывного устройства. Бомба с часовым механизмом."):format(cfg.main.male and 'Определил' or 'Определила'))
            wait(3500)
            sampSendChat(("/do %s три провода выходящих с механизма."):format(cfg.main.male and 'Увидел' or 'Увидела'))
            wait(3500)
            sampSendChat(("/me %s нож из саперного набора"):format(cfg.main.male and 'достал' or 'достала'))
            wait(3500)
            sampSendChat(("/me аккуратно %s первый провод"):format(cfg.main.male and 'зачистил' or 'зачистила'))
            wait(3500)
            sampSendChat(("/try %s отвертку с индикатором и %s край отвертки к оголённом проводу"):format(cfg.main.male and 'достал' or 'достала', cfg.main.male and 'прислонил' or 'прислонила'))
        end
    },
    {
        title = 'Бомба с часовым механизмом если {63c600}[Удачно]',
        onclick = function()
            sampSendChat(("/me %s проводок"):format(cfg.main.male and 'перерезал' or 'перерезала'))
            wait(3500)
            sampSendChat(("/me %s к устройству"):format(cfg.main.male and 'прислушался' or 'прислушалась'))
            wait(3500)
            sampSendChat("/do Механизм перестал издавать тикающие звуки.")
            wait(3500)
            sampSendChat("/do Бомба обезврежена.")
            wait(3500)
            sampSendChat(("/me %s инструменты обратно в саперный набор"):format(cfg.main.male and 'сложил' or 'сложила'))
            wait(3500)
            sampSendChat(("/me %s бронированный кейс и аккуратно %s туда бомбу"):format(cfg.main.male and 'достал' or 'достала', cfg.main.male and 'сложил' or 'сложила'))
        end
    },
    {
        title = 'Бомба с часовым механизмом если {bf0000}[Неудачно]',
        onclick = function()
            sampSendChat(("/me аккуратно %s второй провод"):format(cfg.main.male and 'зачистил' or 'зачистила'))
            wait(3500)
            sampSendChat(("/me %s проводок"):format(cfg.main.male and 'перерезал' or 'перерезала'))
            wait(3500)
            sampSendChat(("/me %s к устройству"):format(cfg.main.male and 'прислушался' or 'прислушалась'))
            wait(3500)
            sampSendChat("/do Механизм перестал издавать тикающие звуки.")
            wait(3500)
            sampSendChat("/do Бомба обезврежена.")
            wait(3500)
            sampSendChat(("/me %s инструменты обратно в саперный набор"):format(cfg.main.male and 'сложил' or 'сложила'))
            wait(3500)
            sampSendChat(("/me %s бронированный кейс и аккуратно %s туда бомбу"):format(cfg.main.male and 'достал' or 'достала', cfg.main.male and 'сложил' or 'сложила'))
        end
    },
    {
        title = 'Бомба с дистанционным управлением',
        onclick = function()
            sampSendChat(("/me %s саперный набор"):format(cfg.main.male and 'достал' or 'достала'))
            wait(3500)
            sampSendChat(("/me %s саперный набор"):format(cfg.main.male and 'открыл' or 'открыла'))
            wait(3500)
            sampSendChat(("/me %s взрывное устройство"):format(cfg.main.male and 'осмотрел' or 'осмотрела'))
            wait(3500)
            sampSendChat(("/do %s тип взрывного устройства. Бомба с дистанционным управлением."):format(cfg.main.male and 'Определил' or 'Определила'))
            wait(3500)
            sampSendChat(("/do %s два шурупа на блоке с механизмом."):format(cfg.main.male and 'Увидел' or 'Увидела'))
            wait(3500)
            sampSendChat(("/me %s отвертку из саперного набора"):format(cfg.main.male and 'достал' or 'достала'))
            wait(3500)
            sampSendChat("/me аккуратно выкручивает шуруп")
            wait(3500)
            sampSendChat(("/me %s крышку блока и %s антенну"):format(cfg.main.male and 'отодвинул' or 'отодвинула', cfg.main.male and 'увидел' or 'увидела'))
            wait(3500)
            sampSendChat(("/do %s красный мигающий индикатор."):format(cfg.main.male and 'Увидел' or 'Увидела'))
            wait(3500)
            sampSendChat(("/me %s путь микросхемы от антенны к детонатору"):format(cfg.main.male and 'просмотрел' or 'просмотрела'))
            wait(3500)
            sampSendChat(("/me %s два провода"):format(cfg.main.male and 'Увидел' or 'Увидела'))
            wait(3500)
            sampSendChat(("/try %s первый провод. Индикатор перестал мигать."):format(cfg.main.male and 'перерезал' or 'перерезала'))
        end
    },
    {
        title = 'Бомба с дистанционным управлением если {63c600}[Удачно]',
        onclick = function()
            sampSendChat("/do Бомба обезврежена.")
            wait(3500)
            sampSendChat(("/me %s инструменты обратно в саперный набор"):format(cfg.main.male and 'сложил' or 'сложила'))
            wait(3500)
            sampSendChat(("/me %s бронированный кейс и аккуратно %s туда бомбу"):format(cfg.main.male and 'достал' or 'достала', cfg.main.male and 'сложил' or 'сложила'))
        end
    },
    {
        title = 'Бомба с дистанционным управлением если {bf0000}[Неудачно]',
        onclick = function()
            sampSendChat(("/me %s второй провод"):format(cfg.main.male and 'перерезал' or 'перерезала'))
            wait(3500)
            sampSendChat("/do Индикатор перестал мигать.")
            wait(3500)
            sampSendChat("/do Бомба обезврежена.")
            wait(3500)
            sampSendChat(("/me %s инструменты обратно в саперный набор"):format(cfg.main.male and 'сложил' or 'сложила'))
            wait(3500)
            sampSendChat(("/me %s бронированный кейс и аккуратно %s туда бомбу"):format(cfg.main.male and 'достал' or 'достала', cfg.main.male and 'сложил' or 'сложила'))
        end
    },
    {
        title = 'Бомба с активационным кодом',
        onclick = function()
            sampSendChat(("/me %s саперный набор"):format(cfg.main.male and 'достал' or 'достала'))
            wait(3500)
            sampSendChat(("/me %s саперный набор"):format(cfg.main.male and 'открыл' or 'открыла'))
            wait(3500)
            sampSendChat(("/me %s взрывное устройство"):format(cfg.main.male and 'осмотрел' or 'осмотрела'))
            wait(3500)
            sampSendChat(("/do %s тип взрывного устройства. Бомба с активационным кодом."):format(cfg.main.male and 'Определил' or 'Определила'))
            wait(3500)
            sampSendChat(("/me %s из саперного набора прибор для подбора кода"):format(cfg.main.male and 'достал' or 'достала'))
            wait(3500)
            sampSendChat(("/me %s прибор к бомбе"):format(cfg.main.male and 'подключил' or 'подключила'))
            wait(3500)
            sampSendChat("/do На приборе высветилось: Ожидание получения пароля.")
            wait(3500)
            sampSendChat("/do На приборе высветилось: Пароль 5326.")
            wait(3500)
            sampSendChat(("/try %s полученный пароль. Экран бомбы выключился"):format(cfg.main.male and 'ввёл' or 'ввёла'))
        end
    },
    {
        title = 'Бомба с активационным кодом если {63c600}[Удачно]',
        onclick = function()
            sampSendChat("/do Бомба обезврежена.")
            wait(3500)
            sampSendChat(("/me %s инструменты обратно в саперный набор"):format(cfg.main.male and 'сложил' or 'сложила'))
            wait(3500)
            sampSendChat(("/me %s бронированный кейс и аккуратно %s туда бомбу"):format(cfg.main.male and 'достал' or 'достала', cfg.main.male and 'сложил' or 'сложила'))
        end
    },
    {
        title = 'Бомба с активационным кодом если {bf0000}[Неудачно]',
        onclick = function()
            sampSendChat(("/me перезагрузила прибор"):format(cfg.main.male and 'перезагрузил' or 'перезагрузила'))
            wait(3500)
            sampSendChat("/do На приборе высветилось: Ожидание получения пароля.")
            wait(3500)
            sampSendChat("/do На приборе высветилось: Пароль 3789.")
            wait(3500)
            sampSendChat(("/me %s полученный пароль"):format(cfg.main.male and 'ввёл' or 'ввёла'))
            wait(3500)
            sampSendChat("/Экран бомбы выключился")
            wait(3500)
            sampSendChat("/do Бомба обезврежена.")
            wait(3500)
            sampSendChat(("/me %s инструменты обратно в саперный набор"):format(cfg.main.male and 'сложил' or 'сложила'))
            wait(3500)
            sampSendChat(("/me %s бронированный кейс и аккуратно %s туда бомбу"):format(cfg.main.male and 'достал' or 'достала', cfg.main.male and 'сложил' or 'сложила'))
        end
    }
}

local fcmenu =
{
  {
    title = 'Теракты',
    submenu =
    {
      {
        title = '{00BFFF}« Мэрия »'
      },
      {
        title = '{00BFFF}Захват мэрии без заложников — {ff0000}100.000$'
      },
      {
        title = '{00BFFF}Захват мэрии c заложниками — {ff0000}150.000$'
      },
      {
        title = '{9A9593}« Офис ФБР »'
      },
      {
        title = '{9A9593}Захват офиса федерального бюро без заложников — {ff0000}100.000$'
      },
      {
        title = '{9A9593}Захват офиса федерального бюро c заложниками — {ff0000}150.000$'
      },
      {
        title = '{0080FF}« Участок SFPD »'
      },
      {
        title = '{0080FF}Захват участка SAPD без заложников — {ff0000}100.000$'
      },
      {
        title = '{0080FF}Захват участка SAPD c заложниками — {ff0000}150.000$'
      },
      {
        title = '{BF4040}« Больница »'
      },
      {
        title = '{BF4040}Захват больницы без заложников — {ff0000}75.000$'
      },
      {
        title = '{BF4040}Захват больницы с заложниками — {ff0000}100.000$'
      },
      {
        title = '{00BFFF}« Автошкола »'
      },
      {
        title = '{00BFFF}Захват автошколы без заложников — {ff0000}50.000$'
      },
      {
        title = '{00BFFF}Захват автошколы с заложниками — {ff0000}75.000$'
      },
      {
        title = '{40BFBF}« CМИ »'
      },
      {
        title = '{40BFBF}Захват СМИ без заложников — {ff0000}50.000$'
      },
      {
        title = '{40BFBF}Захват СМИ с заложниками — {ff0000}75.000$'
      },
      {
        title = '« Остальное »'
      },
      {
        title = 'Захват развлекательных/рабочих заведений без заложников — {ff0000}50.000$'
      },
      {
        title = 'Захват развлекательных/рабочих заведений с заложниками — {ff0000}75.000$'
      }
    }
  },
  {
    title = 'Похищения',
    submenu =
    {
      {
        title = 'Мэрия',
        submenu =
        {
          {
            title = '{0040BF}Мэр{ffffff} [6] - {ff0000}100.000$'
          },
          {
            title = '{0040BF}Зам.Мэра{ffffff} [5] - {ff0000}80.000$'
          },
          {
            title = '{0040BF}Начальник охраны{ffffff} [4] - {ff0000}60.000$'
          },
          {
            title = '{0040BF}Охранник{ffffff} [3] - {ff0000}40.000$'
          },
          {
            title = '{0040BF}Адвокат{ffffff} [2] - {ff0000}30.000$'
          },
          {
            title = '{0040BF}Секретарь{ffffff} [1] - {ff0000}20.000$'
          }
        }
      },
      {
        title = 'ФБР',
        submenu =
        {
          {
            title = '{9A9593}Директор{ffffff} [10] - {ff0000}100.000$'
          },
          {
            title = '{9A9593}Зам.Директора{FFFFFF} [9] - {ff0000}80.000$'
          },
          {
            title = '{9A9593}Инспектор{ffffff} [8] - {ff0000}70.000$'
          },
          {
            title = '{9A9593}Глава CID{ffffff} [7] - {ff0000}60.000$'
          },
          {
            title = '{9A9593}Глава DEA{ffffff} [6] - {ff0000}50.000$'
          },
          {
            title = '{9A9593}Агент CID{ffffff} [5] - {ff0000}40.000$'
          },
          {
            title = '{9A9593}Агент DEA{ffffff} [4] - {ff0000}30.000$'
          },
          {
            title = '{9A9593}Мл.Агент{ffffff} [3] - {ff0000}25.000$'
          },
          {
            title = '{9A9593}Дежурный{ffffff} [2] - {ff0000}20.000$'
          },
          {
            title = '{9A9593}Стажер{ffffff} [1] - {ff0000}15.000$'
          }
        }
      },
      {
        title = 'Полиция',
        submenu =
        {
          {
            title = '{0000FF}Шериф{ffffff} [14] - {ff0000}80.000$'
          },
          {
            title = '{0000FF}Полковник{ffffff} [13] - {ff0000}70.000$'
          },
          {
            title = '{0000FF}Подполковник{ffffff} [12] - {ff0000}65.000$'
          },
          {
            title = '{0000FF}Майор{ffffff} [11] - {ff0000}60.000$'
          },
          {
            title = '{0000FF}Капитан{ffffff} [10] - {ff0000}55.000$'
          },
          {
            title = '{0000FF}Ст.Лейтенант{ffffff} [9] - {ff0000}50.000$'
          },
          {
            title = '{0000FF}Лейтенант{ffffff} [8] - {ff0000}45.000$'
          },
          {
            title = '{0000FF}Мл.Лейтенант{ffffff} [7] - {ff0000}40.000$'
          },
          {
            title = '{0000FF}Ст.Прапорщик{ffffff} [6] - {ff0000}35.000$'
          },
          {
            title = '{0000FF}Прапорщик{ffffff} [5] - {ff0000}30.000$'
          },
          {
            title = '{0000FF}Сержант{ffffff} [4] - {ff0000}25.000$'
          },
          {
            title = '{0000FF}Мл.Сержант{ffffff} [3] - {ff0000}20.000$'
          },
          {
            title = '{0000FF}Офицер{ffffff} [2] - {ff0000}15.000$'
          },
          {
            title = '{0000FF}Кадет{ffffff} [1] - {ff0000}10.000$'
          }
        }
      },
      {
        title = 'Армия',
        submenu =
        {
          {
            title = '{008040}Генерал{ffffff} [15] - {ff0000}80.000$'
          },
          {
            title = '{008040}Полковник{ffffff} [14] - {ff0000}75.000$'
          },
          {
            title = '{008040}Подполковник{ffffff} [13] - {ff0000}70.000$'
          },
          {
            title = '{008040}Майор{ffffff} [12] - {ff0000}65.000$'
          },
          {
            title = '{008040}Капитан{ffffff} [11] - {ff0000}60.000$'
          },
          {
            title = '{008040}Ст.Лейтенант{ffffff} [10] - {ff0000}55.000$'
          },
          {
            title = '{008040}Лейтенант{ffffff} [9] - {ff0000}50.000$'
          },
          {
            title = '{008040}Мл.Лейтенант{ffffff} [8] - {ff0000}45.000$'
          },
          {
            title = '{008040}Прапорщик{ffffff} [7] - {ff0000}40.000$'
          },
          {
            title = '{008040}Старшина{ffffff} [6] - {ff0000}35.000$'
          },
          {
            title = '{008040}Ст.сержант{ffffff} [5] - {ff0000}30.000$'
          },
          {
            title = '{008040}Сержант{ffffff} [4] - {ff0000}25.000$'
          },
          {
            title = '{008040}Мл.Сержант{ffffff} [3] - {ff0000}20.000$'
          },
          {
            title = '{008040}Ефрейтор{ffffff} [2] - {ff0000}15.000$'
          },
          {
            title = '{008040}Рядовой{ffffff} [1] - {ff0000}10.000$'
          }
        }
      },
      {
        title = 'Медики',
        submenu =
        {
          {
            title = '{BF4040}Глав.Врач{ffffff} [10] - {ff0000}80.000$'
          },
          {
            title = '{BF4040}Зам.Глав.Врача{ffffff} [9] - {ff0000}75.000$'
          },
          {
            title = '{BF4040}Хирург{ffffff} [8] - {ff0000}70.000$'
          },
          {
            title = '{BF4040}Психолог{ffffff} [7] - {ff0000}60.000$'
          },
          {
            title = '{BF4040}Доктор{ffffff} [6] - {ff0000}40.000$'
          },
          {
            title = '{BF4040}Нарколог{ffffff} [5] - {ff0000}35.000$'
          },
          {
            title = '{BF4040}Спасатель{ffffff} [4] - {ff0000}30.000$'
          },
          {
            title = '{BF4040}Мед.Брат{ffffff} [3] - {ff0000}25.000$'
          },
          {
            title = '{BF4040}Санитар{ffffff} [2] - {ff0000}20.000$'
          },
          {
            title = '{BF4040}Интерн{ffffff} [1] - {ff0000}15.000$'
          }
        }
      },
      {
        title = 'Автошкола',
        submenu =
        {
          {
            title = '{40BFFF}Управляющий{ffffff} [10] - {ff0000}80.000$'
          },
          {
            title = '{40BFFF}Директор{ffffff} [9] - {ff0000}75.000$'
          },
          {
            title = '{40BFFF}Ст.Менеджер{ffffff} [8] - {ff0000}70.000$'
          },
          {
            title = '{40BFFF}Мл.Менеджер{ffffff} [7] - {ff0000}60.000$'
          },
          {
            title = '{40BFFF}Координатор{ffffff} [6] - {ff0000}55.000$'
          },
          {
            title = '{40BFFF}Инструктор{FFFFFF} [5] - {ff0000}50.000$'
          },
          {
            title = '{40BFFF}Мл.Инструктор{ffffff} [4] - {ff0000}45.000$'
          },
          {
            title = '{40BFFF}Экзаменатор{ffffff} [3] - {ff0000}30.000$'
          },
          {
            title = '{40BFFF}Консультант{ffffff} [2] - {ff0000}25.000$'
          },
          {
            title = '{40BFFF}Стажер{ffffff} [1] - {ff0000}20.000$'
          }
        }
      },
      {
        title = 'Новости',
        submenu =
        {
          {
            title = '{FFFF80}Генеральный директор{ffffff} [10] - {ff0000}70.000$'
          },
          {
            title = '{FFFF80}Програмный директор{ffffff} [9] - {ff0000}60.000$'
          },
          {
            title = '{FFFF80}Технический директор{ffffff} [8] - {ff0000}55.000$'
          },
          {
            title = '{FFFF80}Главный редактор{ffffff} [7] - {ff0000}50.000$'
          },
          {
            title = '{FFFF80}Редактор{ffffff} [6] - {ff0000}45.000$'
          },
          {
            title = '{FFFF80}Ведущий{ffffff} [5] - {ff0000}40.000$'
          },
          {
            title = '{FFFF80}Репортер{ffffff} [4] - {ff0000}30.000$'
          },
          {
            title = '{FFFF80}Звукорежиссер{ffffff} [3] - {ff0000}25.000$'
          },
          {
            title = '{FFFF80}Звукооператор{ffffff} [2] - {ff0000}20.000$'
          },
          {
            title = '{FFFF80}Стажер{ffffff} [1] - {ff0000}15.000$'
          }
        }
      }
    }
  }
}

local fthmenuPD = {
    {
        title = '{ffffff}» Запросить поддержку в текущий квадрат',
        onclick = function()
            if cfg.main.tarb then
                sampSendChat(string.format('/r [%s]: Нужна поддержка в квадрат %s', cfg.main.tar, kvadrat()))
            else
                sampSendChat(string.format('/r Нужна поддержка в квадрат %s', kvadrat()))
            end
        end
    },
    {
        title = '{ffffff}» Запросить эвакуацию в текущий квадрат',
        onclick = function()
            sampShowDialog(1401, '{9966cc}'..script.this.name..' {ffffff}| Эвакуация', '{ffffff}Введите: кол-во мест\nПример: 3 места', 'Отправить', 'Отмена', 1)
        end
    },
    {
        title = '{ffffff}» Цены выкупа',
        onclick = function()
            submenus_show(fcmenu, '{9966cc}'..script.this.name..' {ffffff}| Цены выкупа')
        end
    }
}

local fthmenuAS = {
    {
        title = "{FFFFFF}» Приветствие",
        onclick = function() 
            sampSendChat(("Добрый день. Я сотрудник Автошколы %s, чем могу помочь?"):format(sampGetPlayerNickname(select(2, sampGetPlayerIdByCharHandle(PLAYER_PED))):gsub("_", " ")))
        end
    },
    {
        title = "{FFFFFF}» Попросить паспорт",
        onclick = function()
            sampSendChat("Ваш паспорт, пожалуйста.")
            wait(1400)
            sampSendChat(("/b /showpass %s"):format(select(2, sampGetPlayerIdByCharHandle(PLAYER_PED))))
        end
    },
    {
        title = "{FFFFFF}» Попрощаться",
        onclick = function() sampSendChat("Хорошего дня!") end
    },
    {
        title = "{FFFFFF}» Ударить шокером (близжайшего игрока)",
        onclick = function()
            sampSendChat(("/me %s шокер с пояса"):format(cfg.main.male and 'снял' or 'сняла'))
            wait(cfg.commands.zaderjka)
            sampSendChat("/itazer")
            wait(cfg.commands.zaderjka)
            sampSendChat(("/me %s шокер на пояс"):format(cfg.main.male and 'повесил' or 'повесила'))
        end
    }
}

local fthmenuMOH = {
    {
        title = "» Приветствие",
        onclick = function()
            sampSendChat("Здравствуйте, что вас беспокоит? ")
        end
    },
    {
        title = "» Попрощаться",
        onclick = function()
            sampSendChat("Удачного дня, не болейте.")
        end
    },
    {
        title = "» Огласить стоимость сеанса от наркозависимости",
        onclick = function()
            sampSendChat("Стоимость сеанса от наркозависимости составляет 10.000$.")
        end
    }
}

function getweaponname(weapon)
    local names = {
    [0] = "Fist",
    [1] = "Brass Knuckles",
    [2] = "Golf Club",
    [3] = "Nightstick",
    [4] = "Knife",
    [5] = "Baseball Bat",
    [6] = "Shovel",
    [7] = "Pool Cue",
    [8] = "Katana",
    [9] = "Chainsaw",
    [10] = "Purple Dildo",
    [11] = "Dildo",
    [12] = "Vibrator",
    [13] = "Silver Vibrator",
    [14] = "Flowers",
    [15] = "Cane",
    [16] = "Grenade",
    [17] = "Tear Gas",
    [18] = "Molotov Cocktail",
    [22] = "9mm",
    [23] = "Silenced 9mm",
    [24] = "Desert Eagle",
    [25] = "Shotgun",
    [26] = "Sawnoff Shotgun",
    [27] = "Combat Shotgun",
    [28] = "Micro SMG/Uzi",
    [29] = "MP5",
    [30] = "AK-47",
    [31] = "M4",
    [32] = "Tec-9",
    [33] = "Country Rifle",
    [34] = "Sniper Rifle",
    [35] = "RPG",
    [36] = "HS Rocket",
    [37] = "Flamethrower",
    [38] = "Minigun",
    [39] = "Satchel Charge",
    [40] = "Detonator",
    [41] = "Spraycan",
    [42] = "Fire Extinguisher",
    [43] = "Camera",
    [44] = "Night Vis Goggles",
    [45] = "Thermal Goggles",
    [46] = "Parachute" }
    return names[weapon]
end

function naparnik()
    local v = {}
    if isCharInAnyCar(PLAYER_PED) then
        local veh = storeCarCharIsInNoSave(PLAYER_PED)
        for i = 0, 999 do
            if sampIsPlayerConnected(i) then
                local ichar = select(2, sampGetCharHandleBySampPlayerId(i))
                if doesCharExist(ichar) then
                    if isCharInAnyCar(ichar) then
                        local iveh = storeCarCharIsInNoSave(ichar)
                        if veh == iveh then
                            if sampGetFraktionBySkin(i) == 'Полиция' or sampGetFraktionBySkin(i) == 'FBI' then
                                local inick, ifam = sampGetPlayerNickname(i):match('(.+)_(.+)')
                                if inick and ifam then
                                    table.insert(v, string.format('%s.%s', inick:sub(1,1), ifam))
                                end
                            end
                        end
                    end
                end
            end
        end
    else
        local myposx, myposy, myposz = getCharCoordinates(PLAYER_PED)
        for i = 0, 999 do
            if sampIsPlayerConnected(i) then
                local ichar = select(2, sampGetCharHandleBySampPlayerId(i))
                if doesCharExist(ichar) then
                    local ix, iy, iz = getCharCoordinates(ichar)
                    if getDistanceBetweenCoords3d(myposx, myposy, myposz, ix, iy, iz) <= 30 then
                        if sampGetFraktionBySkin(i) == 'Полиция' or sampGetFraktionBySkin(i) == 'FBI' then
                            local inick, ifam = sampGetPlayerNickname(i):match('(.+)_(.+)')
                            if inick and ifam then
                                table.insert(v, string.format('%s.%s', inick:sub(1,1), ifam))
                            end
                        end
                    end
                end
            end
        end
    end
    if #v == 0 then
        return 'Напарников нет.'
    elseif #v == 1 then
        return 'Напарник: '..table.concat(v, ', ').. '.'
    elseif #v >=2 then
        return 'Напарники: '..table.concat(v, ', ').. '.'
    end
end

function onHotKey(id, keys)
    lua_thread.create(function()
        local sKeys = tostring(table.concat(keys, " "))
        for k, v in pairs(tBindList) do
            if sKeys == tostring(table.concat(v.v, " ")) then
                local tostr = tostring(v.text)
                if tostr:len() > 0 then
                    for line in tostr:gmatch('[^\r\n]+') do
                        if line:match("^{wait%:%d+}$") then
                            wait(line:match("^%{wait%:(%d+)}$"))
                        elseif line:match("^{screen}$") then
                            screen()
                        else
                            local bIsEnter = string.match(line, "^{noe}(.+)") ~= nil
                            local bIsF6 = string.match(line, "^{f6}(.+)") ~= nil
                            local keys = {
                                ["{f6}"] = "",
                                ["{noe}"] = "",
                                ["{myid}"] = select(2, sampGetPlayerIdByCharHandle(PLAYER_PED)),
                                ["{kv}"] = kvadrat(),
                                ["{targetid}"] = targetid,
                                ["{targetrpnick}"] = sampGetPlayerNicknameForBinder(targetid):gsub('_', ' '),
                                ["{naparnik}"] = naparnik(),
                                ["{myrpnick}"] = sampGetPlayerNickname(select(2, sampGetPlayerIdByCharHandle(PLAYER_PED))):gsub("_", " "),
                                ["{smsid}"] = smsid,
                                ["{smstoid}"] = smstoid,
                                ["{rang}"] = rang,
                                ["{frak}"] = frak,
                                ["{megafid}"] = gmegafid,
                                ["{dl}"] = mcid
                            }
                            for k1, v1 in pairs(keys) do
                                line = line:gsub(k1, v1)
                            end

                            if not bIsEnter then
                                if bIsF6 then
                                    sampProcessChatInput(line)
                                else
                                    sampSendChat(line)
                                end
                            else
                                sampSetChatInputText(line)
                                sampSetChatInputEnabled(true)
                            end
                        end
                    end
                end
            end
        end
    end)
end
function kvadrat()
    local KV = {
        [1] = "А",
        [2] = "Б",
        [3] = "В",
        [4] = "Г",
        [5] = "Д",
        [6] = "Ж",
        [7] = "З",
        [8] = "И",
        [9] = "К",
        [10] = "Л",
        [11] = "М",
        [12] = "Н",
        [13] = "О",
        [14] = "П",
        [15] = "Р",
        [16] = "С",
        [17] = "Т",
        [18] = "У",
        [19] = "Ф",
        [20] = "Х",
        [21] = "Ц",
        [22] = "Ч",
        [23] = "Ш",
        [24] = "Я",
    }
    local X, Y, Z = getCharCoordinates(playerPed)
    X = math.ceil((X + 3000) / 250)
    Y = math.ceil((Y * - 1 + 3000) / 250)
    Y = KV[Y]
    local KVX = (Y.."-"..X)
    return KVX
end

function isHudEnabled()
    local value = memory.read(0xBA6769, 1, true)
    if value == 1 then return true else return false end
end

function genCode(skey)
    skey = basexx.from_base32(skey)
    value = math.floor(os.time() / 30)
    value = string.char(
    0, 0, 0, 0,
    band(value, 0xFF000000) / 0x1000000,
    band(value, 0xFF0000) / 0x10000,
    band(value, 0xFF00) / 0x100,
    band(value, 0xFF))
    local hash = sha1.hmac_binary(skey, value)
    local offset = band(hash:sub(-1):byte(1, 1), 0xF)
    local function bytesToInt(a,b,c,d)
      return a*0x1000000 + b*0x10000 + c*0x100 + d
    end
    hash = bytesToInt(hash:byte(offset + 1, offset + 4))
    hash = band(hash, 0x7FFFFFFF) % 1000000
    return ('%06d'):format(hash)
end

function kvadrat1(param)
    local KV = {
        ["А"] = 1,
        ["Б"] = 2,
        ["В"] = 3,
        ["Г"] = 4,
        ["Д"] = 5,
        ["Ж"] = 6,
        ["З"] = 7,
        ["И"] = 8,
        ["К"] = 9,
        ["Л"] = 10,
        ["М"] = 11,
        ["Н"] = 12,
        ["О"] = 13,
        ["П"] = 14,
        ["Р"] = 15,
        ["С"] = 16,
        ["Т"] = 17,
        ["У"] = 18,
        ["Ф"] = 19,
        ["Х"] = 20,
        ["Ц"] = 21,
        ["Ч"] = 22,
        ["Ш"] = 23,
        ["Я"] = 24,
        ["а"] = 1,
        ["б"] = 2,
        ["в"] = 3,
        ["г"] = 4,
        ["д"] = 5,
        ["ж"] = 6,
        ["з"] = 7,
        ["и"] = 8,
        ["к"] = 9,
        ["л"] = 10,
        ["м"] = 11,
        ["н"] = 12,
        ["о"] = 13,
        ["п"] = 14,
        ["р"] = 15,
        ["с"] = 16,
        ["т"] = 17,
        ["у"] = 18,
        ["ф"] = 19,
        ["х"] = 20,
        ["ц"] = 21,
        ["ч"] = 22,
        ["ш"] = 23,
        ["я"] = 24,
    }
    return KV[param]
end

function saveData(table, path)
	if doesFileExist(path) then os.remove(path) end
    local sfa = io.open(path, "w")
    if sfa then
        sfa:write(encodeJson(table))
        sfa:close()
    end
end

function getFreeSeat()
    seat = 3
    if isCharInAnyCar(PLAYER_PED) then
        local veh = storeCarCharIsInNoSave(PLAYER_PED)
        for i = 1, 3 do
            if isCarPassengerSeatFree(veh, i) then
                seat = i
            end
        end
    end
    return seat
end

function getNameSphere(id)
    local names =
    {
      [1] = 'АВ',
      [2] = 'АШ',
      [3] = 'СФа',
      [4] = 'В',
      [5] = 'А',
      [6] = 'СФн',
      [7] = 'Тоннель',
      [8] = 'Мэрия',
      [9] = 'Хот-Доги',
      [10] = 'Больница ЛС',
      [11] = 'АВ',
      [12] = 'Мост',
      [13] = 'Перекресток',
      [14] = 'Развилка',
      [15] = 'В',
      [16] = 'А',
      [17] = 'В',
      [18] = 'С',
      [19] = 'КПП',
      [20] = 'Порт ЛС',
      [21] = 'Опасный район',
      [32] = 'КПП',
      [33] = 'D',
      [34] = 'Холл Мэрии',
      [35] = 'Авторынок'
    }
    return names[id]
end

function longtoshort(long)
    local short =
    {
      ['Армия ЛВ'] = 'LVa',
      ['Армия СФ'] = 'SFa',
      ['ФБР'] = 'FBI'
    }
    return short[long]
end
local osnova = {
	{
		title = 'Лаборатория',
		onclick = function()
			local _, myid = sampGetPlayerIdByCharHandle(PLAYER_PED)
			sampSendChat(("/r %s в сотрудника лаборатории."):format(cfg.main.male and 'Переоделся' or 'Переоделась'))
	        wait(1400)
	        sampSendChat("/rb "..myid)
		end
	},
	{
		title = 'Гражданский',
		onclick = function()
			mstype = 'гражданского'
			sampShowDialog(1385, '{9966cc}'..script.this.name..' {ffffff}| Маскировка', 'Введите: причину', '»', 'x', 1)
		end
	},
	{
		title = 'Полиция',
		onclick = function()
			mstype = 'полицейского'
			sampShowDialog(1385, '{9966cc}'..script.this.name..' {ffffff}| Маскировка', 'Введите: причину', '»', 'x', 1)
		end
	},
	{
		title = 'Армия',
		onclick = function()
			mstype = 'военного'
			sampShowDialog(1385, '{9966cc}'..script.this.name..' {ffffff}| Маскировка', 'Введите: причину', '»', 'x', 1)
		end
	},
	{
		title = 'МЧС',
		onclick = function()
			mstype = 'медика'
			sampShowDialog(1385, '{9966cc}'..script.this.name..' {ffffff}| Маскировка', 'Введите: причину', '»', 'x', 1)
		end
	},
	{
		title = 'Мэрия',
		onclick = function()
			mstype = 'сотрудника мэрии'
			sampShowDialog(1385, '{9966cc}'..script.this.name..' {ffffff}| Маскировка', 'Введите: причину', '»', 'x', 1)
		end
	},
	{
		title = 'Автошкола',
		onclick = function()
			mstype = 'работника автошколы'
			sampShowDialog(1385, '{9966cc}'..script.this.name..' {ffffff}| Маскировка', 'Введите: причину', '»', 'x', 1)
		end
	},
	{
		title = 'Новости',
		onclick = function()
			mstype = 'работника новостей'
			sampShowDialog(1385, '{9966cc}'..script.this.name..' {ffffff}| Маскировка', 'Введите: причину', '»', 'x', 1)
		end
	},
	{
		title = 'LCN',
		ocnlick = function()
			mstype = 'ЧОП LCN'
			sampShowDialog(1385, '{9966cc}'..script.this.name..' {ffffff}| Маскировка', 'Введите: причину', '»', 'x', 1)
		end
	},
	{
		title = 'Yakuza',
		onclick = function()
			mstype = 'ЧОП Yakuza'
			sampShowDialog(1385, '{9966cc}'..script.this.name..' {ffffff}| Маскировка', 'Введите: причину', '»', 'x', 1)
		end
	},
	{
		title = 'Russian Mafia',
		onclick = function()
			mstype = 'ЧОП Russian Mafia'
			sampShowDialog(1385, '{9966cc}'..script.this.name..' {ffffff}| Маскировка', 'Введите: причину', '»', 'x', 1)
		end
	},
	{
		title = 'Rifa',
		onclick = function()
			mstype = 'БК Rifa'
			sampShowDialog(1385, '{9966cc}'..script.this.name..' {ffffff}| Маскировка', 'Введите: причину', '»', 'x', 1)
		end
	},
	{
		title = 'Grove',
		onclick = function()
			mstype = 'БК Grove'
			sampShowDialog(1385, '{9966cc}'..script.this.name..' {ffffff}| Маскировка', 'Введите: причину', '»', 'x', 1)
		end
	},
	{
		title = 'Ballas',
		onclick = function()
			mstype = 'БК Ballas'
			sampShowDialog(1385, '{9966cc}'..script.this.name..' {ffffff}| Маскировка', 'Введите: причину', '»', 'x', 1)
		end
	},
	{
		title = 'Vagos',
		onclick = function()
			mstype = 'БК Vagos'
			sampShowDialog(1385, '{9966cc}'..script.this.name..' {ffffff}| Маскировка', 'Введите: причину', '»', 'x', 1)
		end
	},
	{
		title = 'Aztec',
		onclick = function()
			mstype = 'БК Aztec'
			sampShowDialog(1385, '{9966cc}'..script.this.name..' {ffffff}| Маскировка', 'Введите: причину', '»', 'x', 1)
		end
	},
	{
		title = 'Байкеры',
		onclick = function()
			mstype = 'байкеров'
			sampShowDialog(1385, '{9966cc}'..script.this.name..' {ffffff}| Маскировка', 'Введите: причину', '»', 'x', 1)
		end
	}
}

local tCarsName = {"Landstalker", "Bravura", "Buffalo", "Linerunner", "Perrenial", "Sentinel", "Dumper", "Firetruck", "Trashmaster", "Stretch", "Manana", "Infernus",
"Voodoo", "Pony", "Mule", "Cheetah", "Ambulance", "Leviathan", "Moonbeam", "Esperanto", "Taxi", "Washington", "Bobcat", "Whoopee", "BFInjection", "Hunter",
"Premier", "Enforcer", "Securicar", "Banshee", "Predator", "Bus", "Rhino", "Barracks", "Hotknife", "Trailer", "Previon", "Coach", "Cabbie", "Stallion", "Rumpo",
"RCBandit", "Romero","Packer", "Monster", "Admiral", "Squalo", "Seasparrow", "Pizzaboy", "Tram", "Trailer", "Turismo", "Speeder", "Reefer", "Tropic", "Flatbed",
"Yankee", "Caddy", "Solair", "Berkley'sRCVan", "Skimmer", "PCJ-600", "Faggio", "Freeway", "RCBaron", "RCRaider", "Glendale", "Oceanic", "Sanchez", "Sparrow",
"Patriot", "Quad", "Coastguard", "Dinghy", "Hermes", "Sabre", "Rustler", "ZR-350", "Walton", "Regina", "Comet", "BMX", "Burrito", "Camper", "Marquis", "Baggage",
"Dozer", "Maverick", "NewsChopper", "Rancher", "FBIRancher", "Virgo", "Greenwood", "Jetmax", "Hotring", "Sandking", "BlistaCompact", "PoliceMaverick",
"Boxvillde", "Benson", "Mesa", "RCGoblin", "HotringRacerA", "HotringRacerB", "BloodringBanger", "Rancher", "SuperGT", "Elegant", "Journey", "Bike",
"MountainBike", "Beagle", "Cropduster", "Stunt", "Tanker", "Roadtrain", "Nebula", "Majestic", "Buccaneer", "Shamal", "hydra", "FCR-900", "NRG-500", "HPV1000",
"CementTruck", "TowTruck", "Fortune", "Cadrona", "FBITruck", "Willard", "Forklift", "Tractor", "Combine", "Feltzer", "Remington", "Slamvan", "Blade", "Freight",
"Streak", "Vortex", "Vincent", "Bullet", "Clover", "Sadler", "Firetruck", "Hustler", "Intruder", "Primo", "Cargobob", "Tampa", "Sunrise", "Merit", "Utility", "Nevada",
"Yosemite", "Windsor", "Monster", "Monster", "Uranus", "Jester", "Sultan", "Stratum", "Elegy", "Raindance", "RCTiger", "Flash", "Tahoma", "Savanna", "Bandito",
"FreightFlat", "StreakCarriage", "Kart", "Mower", "Dune", "Sweeper", "Broadway", "Tornado", "AT-400", "DFT-30", "Huntley", "Stafford", "BF-400", "NewsVan",
"Tug", "Trailer", "Emperor", "Wayfarer", "Euros", "Hotdog", "Club", "FreightBox", "Trailer", "Andromada", "Dodo", "RCCam", "Launch", "PoliceCar", "PoliceCar",
"PoliceCar", "PoliceRanger", "Picador", "S.W.A.T", "Alpha", "Phoenix", "GlendaleShit", "SadlerShit", "Luggage A", "Luggage B", "Stairs", "Boxville", "Tiller",
"UtilityTrailer"}
local tCarsTypeName = {"Автомобиль", "Мотоицикл", "Вертолёт", "Самолёт", "Прицеп", "Лодка", "Другое", "Поезд", "Велосипед"}
local tCarsSpeed = {43, 40, 51, 30, 36, 45, 30, 41, 27, 43, 36, 61, 46, 30, 29, 53, 42, 30, 32, 41, 40, 42, 38, 27, 37,
54, 48, 45, 43, 55, 51, 36, 26, 30, 46, 0, 41, 43, 39, 46, 37, 21, 38, 35, 30, 45, 60, 35, 30, 52, 0, 53, 43, 16, 33, 43,
29, 26, 43, 37, 48, 43, 30, 29, 14, 13, 40, 39, 40, 34, 43, 30, 34, 29, 41, 48, 69, 51, 32, 38, 51, 20, 43, 34, 18, 27,
17, 47, 40, 38, 43, 41, 39, 49, 59, 49, 45, 48, 29, 34, 39, 8, 58, 59, 48, 38, 49, 46, 29, 21, 27, 40, 36, 45, 33, 39, 43,
43, 45, 75, 75, 43, 48, 41, 36, 44, 43, 41, 48, 41, 16, 19, 30, 46, 46, 43, 47, -1, -1, 27, 41, 56, 45, 41, 41, 40, 41,
39, 37, 42, 40, 43, 33, 64, 39, 43, 30, 30, 43, 49, 46, 42, 49, 39, 24, 45, 44, 49, 40, -1, -1, 25, 22, 30, 30, 43, 43, 75,
36, 43, 42, 42, 37, 23, 0, 42, 38, 45, 29, 45, 0, 0, 75, 52, 17, 32, 48, 48, 48, 44, 41, 30, 47, 47, 40, 41, 0, 0, 0, 29, 0, 0
}
local tCarsType = {1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 3, 1, 1, 1, 1, 1, 1, 1,
3, 1, 1, 1, 1, 6, 1, 1, 1, 1, 5, 1, 1, 1, 1, 1, 7, 1, 1, 1, 1, 6, 3, 2, 8, 5, 1, 6, 6, 6, 1,
1, 1, 1, 1, 4, 2, 2, 2, 7, 7, 1, 1, 2, 3, 1, 7, 6, 6, 1, 1, 4, 1, 1, 1, 1, 9, 1, 1, 6, 1,
1, 3, 3, 1, 1, 1, 1, 6, 1, 1, 1, 3, 1, 1, 1, 7, 1, 1, 1, 1, 1, 1, 1, 9, 9, 4, 4, 4, 1, 1, 1,
1, 1, 4, 4, 2, 2, 2, 1, 1, 1, 1, 1, 1, 1, 1, 7, 1, 1, 1, 1, 8, 8, 7, 1, 1, 1, 1, 1, 1, 1,
1, 3, 1, 1, 1, 1, 4, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 7, 1, 1, 1, 1, 8, 8, 7, 1, 1, 1, 1, 1, 4,
1, 1, 1, 2, 1, 1, 5, 1, 2, 1, 1, 1, 7, 5, 4, 4, 7, 6, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 5, 5, 5, 1, 5, 5
}

function update()
    local fpath = os.getenv('TEMP') .. '\\ftulsupd.json'
    downloadUrlToFile('https://raw.githubusercontent.com/WhackerH/kirya/master/ftulsupd.json', fpath, function(id, status, p1, p2)
        if status == dlstatus.STATUS_ENDDOWNLOADDATA then
            local f = io.open(fpath, 'r')
            if f then
                local info = decodeJson(f:read('*a'))
                updatelink = info.updateurl
                updlist1 = info.updlist
                ttt = updlist1
			    if info and info.latest then
                    if tonumber(thisScript().version) < tonumber(info.latest) then
                        ftext('Обнаружено обновление {9966cc}'..script.this.name..'{ffffff}. Для обновления нажмите кнопку в окошке.')
                        ftext('Примечание: Если у вас не появилось окошко введите {9966cc}/ft')
                        updwindows.v = true
                        canupdate = true
                    else
                        print('Обновлений скрипта не обнаружено. Приятной игры.')
                        update = false
				    end
                end
            else
                print("Проверка обновления прошка неуспешно. Запускаю старую версию.")
            end
        elseif status == 64 then
            print("Проверка обновления прошка неуспешно. Запускаю старую версию.")
            update = false
        end
    end)
end


function goupdate()
    ftext('Началось скачивание обновления. Скрипт перезагрузится через пару секунд.', -1)
    wait(300)
    downloadUrlToFile(updatelink, thisScript().path, function(id3, status1, p13, p23)
        if status1 == dlstatus.STATUS_ENDDOWNLOADDATA then
            thisScript():reload()
        elseif status1 == 64 then
            ftext("Скачивание обновления прошло не успешно. Запускаю старую версию")
        end
    end)
end

function libs()
    if not limgui or not lsampev or not lsphere or not lrkeys or not limadd or not lsha1 or not lbasexx then
        ftext('Начата загрузка недостающих библиотек')
        ftext('По окончанию загрузки скрипт будет перезагружен')
        if limgui == false then
            imgui_download_status = 'proccess'
            downloadUrlToFile('https://raw.githubusercontent.com/WhackerH/kirya/master/lib/imgui.lua', 'moonloader/lib/imgui.lua', function(id, status, p1, p2)
                if status == dlstatus.STATUS_DOWNLOADINGDATA then
                    imgui_download_status = 'proccess'
                    print(string.format('Загружено %d килобайт из %d килобайт.', p1, p2))
                elseif status == dlstatus.STATUS_ENDDOWNLOADDATA then
                    imgui_download_status = 'succ'
                elseif status == 64 then
                    imgui_download_status = 'failed'
                end
            end)
            while imgui_download_status == 'proccess' do wait(0) end
            if imgui_download_status == 'failed' then
                print('Не удалось загрузить: imgui.lua')
                thisScript():unload()
            else
                print('Файл: imgui.lua успешно загружен')
                if doesFileExist('moonloader/lib/MoonImGui.dll') then
                    print('Imgui был загружен')
                else
                    imgui_download_status = 'proccess'
                    downloadUrlToFile('https://raw.githubusercontent.com/WhackerH/kirya/master/lib/MoonImGui.dll', 'moonloader/lib/MoonImGui.dll', function(id, status, p1, p2)
                        if status == dlstatus.STATUS_DOWNLOADINGDATA then
                            imgui_download_status = 'proccess'
                            print(string.format('Загружено %d килобайт из %d килобайт.', p1, p2))
                        elseif status == dlstatus.STATUS_ENDDOWNLOADDATA then
                            imgui_download_status = 'succ'
                        elseif status == 64 then
                            imgui_download_status = 'failed'
                        end
                    end)
                    while imgui_download_status == 'proccess' do wait(0) end
                    if imgui_download_status == 'failed' then
                        print('Не удалось загрузить Imgui')
                        thisScript():unload()
                    else
                        print('Imgui был загружен')
                    end
                end
            end
        end
        if not lsampev then
            local folders = {'samp', 'samp/events'}
            local files = {'events.lua', 'raknet.lua', 'synchronization.lua', 'events/bitstream_io.lua', 'events/core.lua', 'events/extra_types.lua', 'events/handlers.lua', 'events/utils.lua'}
            for k, v in pairs(folders) do if not doesDirectoryExist('moonloader/lib/'..v) then createDirectory('moonloader/lib/'..v) end end
            for k, v in pairs(files) do
                sampev_download_status = 'proccess'
                downloadUrlToFile('https://raw.githubusercontent.com/WhackerH/kirya/master/lib/samp/'..v, 'moonloader/lib/samp/'..v, function(id, status, p1, p2)
                    if status == dlstatus.STATUS_DOWNLOADINGDATA then
                        sampev_download_status = 'proccess'
                        print(string.format('Загружено %d килобайт из %d килобайт.', p1, p2))
                    elseif status == dlstatus.STATUS_ENDDOWNLOADDATA then
                        sampev_download_status = 'succ'
                    elseif status == 64 then
                        sampev_download_status = 'failed'
                    end
                end)
                while sampev_download_status == 'proccess' do wait(0) end
                if sampev_download_status == 'failed' then
                    print('Не удалось загрузить sampev')
                    thisScript():unload()
                else
                    print(v..' был загружен')
                end
            end
        end
        if not lsphere then
            sphere_download_status = 'proccess'
            downloadUrlToFile('https://raw.githubusercontent.com/WhackerH/kirya/master/lib/sphere.lua', 'moonloader/lib/sphere.lua', function(id, status, p1, p2)
                if status == dlstatus.STATUS_DOWNLOADINGDATA then
                    sphere_download_status = 'proccess'
                    print(string.format('Загружено %d килобайт из %d килобайт.', p1, p2))
                elseif status == dlstatus.STATUS_ENDDOWNLOADDATA then
                    sphere_download_status = 'succ'
                elseif status == 64 then
                    sphere_download_status = 'failed'
                end
            end)
            while sphere_download_status == 'proccess' do wait(0) end
            if sphere_download_status == 'failed' then
                print('Не удалось загрузить Sphere.lua')
                thisScript():unload()
            else
                print('Sphere.lua был загружен')
            end
        end
        if not lrkeys then
            rkeys_download_status = 'proccess'
            downloadUrlToFile('https://raw.githubusercontent.com/WhackerH/kirya/master/lib/rkeys.lua', 'moonloader/lib/rkeys.lua', function(id, status, p1, p2)
                if status == dlstatus.STATUS_DOWNLOADINGDATA then
                    rkeys_download_status = 'proccess'
                    print(string.format('Загружено %d килобайт из %d килобайт.', p1, p2))
                elseif status == dlstatus.STATUS_ENDDOWNLOADDATA then
                    rkeys_download_status = 'succ'
                elseif status == 64 then
                    rkeys_download_status = 'failed'
                end
            end)
            while rkeys_download_status == 'proccess' do wait(0) end
            if rkeys_download_status == 'failed' then
                print('Не удалось загрузить rkeys.lua')
                thisScript():unload()
            else
                print('rkeys.lua был загружен')
            end
        end
        if not limadd then
            imadd_download_status = 'proccess'
            downloadUrlToFile('https://raw.githubusercontent.com/WhackerH/kirya/master/lib/imgui_addons.lua', 'moonloader/lib/imgui_addons.lua', function(id, status, p1, p2)
                if status == dlstatus.STATUS_DOWNLOADINGDATA then
                    imadd_download_status = 'proccess'
                    print(string.format('Загружено %d килобайт из %d килобайт.', p1, p2))
                elseif status == dlstatus.STATUS_ENDDOWNLOADDATA then
                    imadd_download_status = 'succ'
                elseif status == 64 then
                    imadd_download_status = 'failed'
                end
            end)
            while imadd_download_status == 'proccess' do wait(0) end
            if imadd_download_status == 'failed' then
                print('Не удалось загрузить imgui_addons.lua')
                thisScript():unload()
            else
                print('imgui_addons.lua был загружен')
            end
        end
        if not lsha1 then
            sha1_download_status = 'proccess'
            downloadUrlToFile('https://raw.githubusercontent.com/WhackerH/kirya/master/lib/sha1.lua', 'moonloader/lib/sha1.lua', function(id, status, p1, p2)
                if status == dlstatus.STATUS_DOWNLOADINGDATA then
                    sha1_download_status = 'proccess'
                    print(string.format('Загружено %d килобайт из %d килобайт.', p1, p2))
                elseif status == dlstatus.STATUS_ENDDOWNLOADDATA then
                    sha1_download_status = 'succ'
                elseif status == 64 then
                    sha1_download_status = 'failed'
                end
            end)
            while sha1_download_status == 'proccess' do wait(0) end
            if sha1_download_status == 'failed' then
                print('Не удалось загрузить sha1.lua')
                thisScript():unload()
            else
                print('sha1.lua был загружен')
            end
        end
        if not lbasexx then
            basexx_download_status = 'proccess'
            downloadUrlToFile('https://raw.githubusercontent.com/WhackerH/kirya/master/lib/basexx.lua', 'moonloader/lib/basexx.lua', function(id, status, p1, p2)
                if status == dlstatus.STATUS_DOWNLOADINGDATA then
                    basexx_download_status = 'proccess'
                    print(string.format('Загружено %d килобайт из %d килобайт.', p1, p2))
                elseif status == dlstatus.STATUS_ENDDOWNLOADDATA then
                    basexx_download_status = 'succ'
                elseif status == 64 then
                    basexx_download_status = 'failed'
                end
            end)
            while basexx_download_status == 'proccess' do wait(0) end
            if basexx_download_status == 'failed' then
                print('Не удалось загрузить basexx.lua')
                thisScript():unload()
            else
                print('basexx.lua был загружен')
            end
        end
        ftext('Все необходимые библиотеки были загружены')
        reloadScripts()
    else
        print('Все необходиме библиотеки были найдены и загружены')
    end
end

function checkStats()
    while not sampIsLocalPlayerSpawned() do wait(0) end
    checkstat = true
    sampSendChat('/stats')
	local chtime = os.clock() + 10
    while chtime > os.clock() do wait(0) end
    local chtime = nil
    checkstat = false
    if rang == -1 and frak == -1 then
        frak = 'Нет'
        rang = 'Нет'
        ftext('Не удалось определить статистику персонажа. Повторить попытку?', -1)
        ftext('Подтвердить: {9966cc}'..table.concat(rkeys.getKeysName(config_keys.oopda.v), " + ")..'{ffffff} | Отменить: {9966cc}'..table.concat(rkeys.getKeysName(config_keys.oopnet.v), " + "), -1)
        opyatstat = true
    end
end

function ykf()
    if not doesFileExist('moonloader/fbitools/yk.txt') then
        local fpathyk = os.getenv('TEMP') .. '\\yk.txt'
        downloadUrlToFile('https://raw.githubusercontent.com/WhackerH/kirya/master/yk.txt', fpath, function(id, status, p1, p2)
            if status == dlstatus.STATUS_ENDDOWNLOADDATA then
                local f = io.open(fpathyk, 'r')
                if f then
                    local file = io.open("moonloader/fbitools/yk.txt", "w")
                    file:write(u8:decode(f:read('*a')))
                    file:close()
                else
                    local file = io.open("moonloader/fbitools/yk.txt", "w")
                    file:write("Произошла ошибка закачки УК.\nИзменить текст этой шпоры можно в файле: moonloader/fbitools/yk.txt")
                    file:close()
                end
            elseif status == 64 then
                local file = io.open("moonloader/fbitools/yk.txt", "w")
                file:write("Произошла ошибка закачки УК.\nИзменить текст этой шпоры можно в файле: moonloader/fbitools/yk.txt")
                file:close()
            end
        end)
    end
    if not doesFileExist('moonloader/fbitools/yk.txt') then
        local file = io.open("moonloader/fbitools/yk.txt", "w")
        file:write("Произошла ошибка закачки УК.\nИзменить текст этой шпоры можно в файле: moonloader/fbitools/yk.txt")
        file:close()
    end

end

function shpf()
    if not doesFileExist("moonloader/fbitools/shp.txt") then
        local file = io.open("moonloader/fbitools/shp.txt", 'w')
        file:write(shpt)
        file:close()
    end
end

function fpf()
    if not doesFileExist('moonloader/fbitools/fp.txt') then
        local fpathfp = os.getenv('TEMP') .. '\\fp.txt'
        downloadUrlToFile('https://raw.githubusercontent.com/WhackerH/kirya/master/fp.txt', fpath, function(id, status, p1, p2)
            if status == dlstatus.STATUS_ENDDOWNLOADDATA then
                local f = io.open(fpathfp, 'r')
                if f then
                    local file = io.open("moonloader/fbitools/fp.txt", "w")
                    file:write(u8:decode(f:read('*a')))
                    file:close()
                else
                    local file = io.open("moonloader/fbitools/fp.txt", "w")
                    file:write("Произошла ошибка закачки ФП.\nИзменить текст этой шпоры можно в файле: moonloader/fbitools/yk.txt")
                    file:close()
                end
            elseif status == 64 then
                local file = io.open("moonloader/fbitools/fp.txt", "w")
                file:write("Произошла ошибка закачки ФП.\nИзменить текст этой шпоры можно в файле: moonloader/fbitools/yk.txt")
                file:close()
            end
        end)
    end
    if not doesFileExist('moonloader/fbitools/fp.txt') then 
        local file = io.open("moonloader/fbitools/fp.txt", "w")
        file:write("Произошла ошибка закачки ФП.\nИзменить текст этой шпоры можно в файле: moonloader/fbitools/yk.txt")
        file:close()
    end
end

function akf()
    if not doesFileExist('moonloader/fbitools/ak.txt') then
        local fpathak = os.getenv('TEMP') .. '\\ak.txt'
        downloadUrlToFile('https://raw.githubusercontent.com/WhackerH/kirya/master/ak.txt', fpath, function(id, status, p1, p2)
            if status == dlstatus.STATUS_ENDDOWNLOADDATA then
                local f = io.open(fpathak, 'r')
                if f then
                    local file = io.open("moonloader/fbitools/ak.txt", "w")
                    file:write(u8:decode(f:read('*a')))
                    file:close()
                else
                    local file = io.open("moonloader/fbitools/ak.txt", "w")
                    file:write("Произошла ошибка закачки АК.\nИзменить текст этой шпоры можно в файле: moonloader/fbitools/yk.txt")
                    file:close()
                end
            elseif status == 64 then
                local file = io.open("moonloader/fbitools/ak.txt", "w")
                file:write("Произошла ошибка закачки АК.\nИзменить текст этой шпоры можно в файле: moonloader/fbitools/yk.txt")
                file:close()
            end
        end)
    end
    if not doesFileExist('moonloader/fbitools/ak.txt') then
        local file = io.open("moonloader/fbitools/ak.txt", "w")
        file:write("Произошла ошибка закачки АК.\nИзменить текст этой шпоры можно в файле: moonloader/fbitools/yk.txt")
        file:close()
    end
end

function suf()
    if not doesFileExist('moonloader/fbitools/su.txt') then
        local file = io.open('moonloader/fbitools/su.txt', 'w')
        file:write(sut)
        file:close()
        file = nil
    end
end

function mcheckf() if not doesFileExist('moonloader/fbitools/mcheck.txt') then io.open("moonloader/fbitools/mcheck.txt", "w"):close() end end

function sampGetPlayerNicknameForBinder(nikkid)
    local nick = '-1'
    local nickid = tonumber(nikkid)
    if nickid ~= nil then
        if sampIsPlayerConnected(nickid) then
            nick = sampGetPlayerNickname(nickid)
        end
    end
    return nick
end

function sumenu(args)
    return
    {
      {
        title = '{5b83c2}« Раздел №1 »',
        onclick = function()
        end
      },
      {
        title = '{ffffff}» Избиение - {ff0000}2 уровень розыска.',
        onclick = function()
          sampSendChat("/su "..args.." 2 Избиение")
        end
      },
      {
        title = '{ffffff}» Вооруженное нападение на гражданского - {ff0000}3 уровень розыска.',
        onclick = function()
          sampSendChat("/su "..args.." 3 Вооруженное нападение на гражданского")
        end
      },
      {
        title = '{ffffff}» Вооруженное нападение на гос.служащего - {ff0000}6 уровень розыска.',
        onclick = function()
          sampSendChat("/su "..args.." 6 Вооруженное нападение на ПО")
        end
      },
      {
        title = '{ffffff}» Убийство человека - {ff0000}3 уровень розыска.',
        onclick = function()
          sampSendChat("/su "..args.." 3 Убийство человека")
        end
      },
      {
        title = '{ffffff}» Хулиганство - {ff0000}1 уровень розыска.',
        onclick = function()
          sampSendChat("/su "..args.." 1 Хулиганство")
        end
      },
      {
        title = '{ffffff}» Неадекватное поведение - {ff0000}1 уровень розыска.',
        onclick = function()
          sampSendChat("/su "..args.." 1 Неадекватное поведение")
        end
      },
      {
        title = '{ffffff}» Попрошайничество - {ff0000}1 уровень розыска.',
        onclick = function()
          sampSendChat("/su "..args.." 1 Попрошайничество")
        end
      },
      {
        title = '{ffffff}» Оскорбление - {ff0000}2 уровень розыска.',
        onclick = function()
          sampSendChat("/su "..args.." 2 Оскорбление")
        end
      },
      {
        title = '{ffffff}» Наезд на пешехода - {ff0000}2 уровень розыска.',
        onclick = function()
          sampSendChat("/su "..args.." 2 Наезд на пешехода")
        end
      },
      {
        title = '{ffffff}» Игнорирование спец.сигнала - {ff0000}1 уровень розыска.',
        onclick = function()
          sampSendChat("/su "..args.." 1 Игнорирование спец.сигнала")
        end
      },
      {
        title = '{ffffff}» Угон транспортного средства - {ff0000}2 уровень розыска.',
        onclick = function()
          sampSendChat("/su "..args.." 2 Угон транспортного средства")
        end
      },
      {
        title = '{ffffff}» Порча чужого имущества - {ff0000}1 уровень розыска.',
        onclick = function()
          sampSendChat("/su "..args.. " 1 Порча чужого имущества")
        end
      },
      {
        title = '{ffffff}» Уничтожение чужого имущества - {ff0000}4 уровень розыска.',
        onclick = function()
          sampSendChat("/su "..args.." 4 Уничтожение чужого имущества")
        end
      },
      {
        title = '{ffffff}» Неподчинение сотруднику ПО - {ff0000}1 уровень розыска.',
        onclick = function()
          sampSendChat("/su "..args.." 1 Неподчинение сотруднику ПО")
        end
      },
      {
        title = '{ffffff}» Уход от сотрудника ПО - {ff0000}2 уровень розыска',
        onclick = function()
          sampSendChat("/su "..args.." 2 Уход от сотрудника ПО")
        end
      },
      {
          title = '{ffffff}» Уход с места ДТП - {ff0000}3 уровень розыска',
          onclick = function()
            sampSendChat('/su '..args.. ' 3 Уход с места ДТП')
          end
      },
      {
        title = '{ffffff}» Побег из места заключения - {ff0000}6 уровень розыска.',
        onclick = function()
          sampSendChat("/su "..args.." 6 Побег из места заключения")
        end
      },
      {
        title = '{ffffff}» Проникновение на охраняемую территорию - {ff0000}2 уровень розыска.',
        onclick = function()
          sampSendChat("/su "..args.." 2 Проникновение на охр. территорию")
        end
      },
      {
        title = '{ffffff}» Провокация - {ff0000}2 уровень розыска.',
        onclick = function()
          sampSendChat("/su "..args.." 2 Провокация")
        end
      },
      {
        title = '{ffffff}» Угрозы - {ff0000}1 уровень розыска.',
        onclick = function()
          sampSendChat("/su "..args.." 1 Угрозы")
        end
      },
      {
        title = '{ffffff}» Предложение интим. услуг - {ff0000}1 уровень розыска',
        onclick = function()
          sampSendChat('/su '..args..' 1 Предложение интимных услуг')
        end
      },
      {
        title = '{ffffff}» Изнасилование - {ff0000}3 уровень розыска',
        onclick = function()
          sampSendChat('/su '..args..' 3 Изнасилование')
        end
      },
      {
        title = '{ffffff}» Чистосердечное признание - {ff0000}1 уровень розыска.',
        onclick = function()
          local result = isCharInAnyCar(PLAYER_PED)
          if result then
            sampSendChat("/clear "..args)
            wait(1400)
            sampSendChat("/su "..args.." 1 Чистосердечное признание")
          else
            sampAddChatMessage("{9966CC}"..script.this.name.." {FFFFFF}| You have to be in the car", -1)
          end
        end
      },
      {
        title = '{ffbc54}« Раздел №2 »',
        onclick = function()
        end
      },
      {
        title = '{ffffff}» Хранение материалов - {ff0000}3 уровень розыска.',
        onclick = function()
          sampSendChat("/su "..args.." 3 Хранение материалов")
        end
      },
      {
        title = '{ffffff}» Хранение наркотиков - {ff0000}3 уровень розыска.',
        onclick = function()
          sampSendChat("/su "..args.." 3 Хранение наркотиков")
        end
      },
      {
        title = '{ffffff}» Продажа ключей от камеры - {ff0000}6 уровень розыска',
        onclick = function()
          sampSendChat("/su "..args.." 6 Продажа ключей от камеры")
        end
      },
      {
        title = '{ffffff}» Употребление наркотиков - {ff0000}3 уровень розыска',
        onclick = function()
          sampSendChat("/su "..args.." 3 Употребление наркотиков")
        end
      },
      {
        title = '{ffffff}» Продажа наркотиков - {ff0000}2 уровень розыска',
        onclick = function()
          sampSendChat("/su "..args.." 2 Продажа наркотиков")
        end
      },
      {
        title = '{ffffff}» Покупка военной формы - {ff0000}2 уровень розыска',
        onclick = function()
          sampSendChat("/su "..args.." 2 Покупка военной формы")
        end
      },
      {
        title = '{ffffff}» Предложение взятки гос.служащему - {ff0000}2 уровень розыска.',
        onclick = function()
          sampSendChat("/su "..args.." 2 Предложение взятки гос.служащему")
        end
      },
      {
        title = '{ae0620}« Раздел №3 »',
        onclick = function()
        end
      },
      {
        title = '{ffffff}» Уход в AFK от ареста - {ff0000}6 уровень розыска.',
        onclick = function()
          sampSendChat("/su "..args.." 6 Уход")
        end
      },
      {
        title = '{ffffff}» Совершение терракта - {ff0000}6 уровень розыска.',
        onclick = function()
          sampSendChat("/su "..args.." 6 Совершение теракта")
        end
      },
      {
        title = '{ffffff}» Неуплата штрафа - {ff0000}2 уровень розыска.',
        onclick = function()
          sampSendChat("/su "..args.." 2 Неуплата штрафа")
        end
      },
      {
        title = '{ffffff}» Превышение полномочий адвоката - {ff0000}3 уровень розыска.',
        onclick = function()
          sampSendChat("/su "..args.." 3 Превышение полномочий адвоката")
        end
      },
      {
        title = '{ffffff}» Похищение гражданского/гос.служащего - {ff0000}4 уровень розыска',
        onclick = function()
          sampSendChat("/su "..args.." 4 Похищение")
        end
      },
      {
        title = '{ffffff}» Статус ООП - {ff0000}6 уровень розыска',
        onclick = function()
          sampSendChat("/su "..args.." 6 ООП")
        end
      }
    }
end

function getDriveLicenseCount(id)
    local lvl = sampGetPlayerScore(id)
    if lvl <= 2 then return 500
    elseif lvl >= 3 and lvl <= 5 then return 5000
    elseif lvl >= 6 and lvl <= 15 then return 10000
    elseif lvl >= 16 then return 30000 end
end

function giveLicense(id, list)
    ins.list = list
    ins.isLicense = true
    sampSendChat(("/me %s папку с лицензиями"):format(cfg.main.male and "открыл" or "открыла"))
    wait(cfg.commands.zaderjka)
    sampSendChat("/do Лицензия в руке.")
    wait(cfg.commands.zaderjka)
    sampSendChat(("/me %s печать \"Autoschool San Fierro\" и %s лицензию"):format(cfg.main.male and "поставил" or "поставила", cfg.main.male and "передал" or "передала"))
    wait(1400)
    sampSendChat(("/givelicense %s"):format(id))
end

function healPlayer(id, head)
    sampSendChat(("/me %s аптечку"):format(cfg.main.male and "достал" or "достала"))
    wait(cfg.commands.zaderjka)
    sampSendChat(("/me %s необходимый препарат"):format(cfg.main.male and "нашел" or "нашла"))
    wait(cfg.commands.zaderjka)
    sampSendChat(("/do %s в руках"):format(head and "Аспирин" or "Ношпа"))
    wait(cfg.commands.zaderjka)
    sampSendChat(("/me %s пациенту лекарство и %s запить водой"):format(cfg.main.male and "передал" or "передала", cfg.main.male and "дал" or "дала"))
    wait(1400)
    sampSendChat(("/heal %s"):format(id))
end

function pkmmenuMOH(id)
    return
    {
        {
            title = "Вылечить",
            submenu = {
                {
                    title = "Голова",
                    onclick = function()
                        healPlayer(id, true)
                    end
                },
                {
                    title = "Живота",
                    onclick = function()
                        healPlayer(id, false)
                    end
                },
                {
                    title = "Горло",
                    onclick = function()
                        sampSendChat(("/me %s горло"):format(cfg.main.male and "осмотрел" or "осмотрела"))
                        wait(cfg.commands.zaderjka)
                        sampSendChat(("/me %s аптечку"):format(cfg.main.male and "достал" or "достала"))
                        wait(cfg.commands.zaderjka)
                        sampSendChat(("/me %s необходимый препарат"):format(cfg.main.male and "нашел" or "нашла"))
                        wait(cfg.commands.zaderjka)
                        sampSendChat("/do Стопангин в руках")
                        wait(cfg.commands.zaderjka)
                        sampSendChat(("/me %s пациенту лекарство и %s запить водой"):format(cfg.main.male and "передал" or "передала", cfg.main.male and "дал" or "дала"))
                        wait(1400)
                        sampSendChat(("/heal %s"):format(id))
                    end
                }
            }
        },
        {
            title = "» Провести сеанс",
            onclick = function()
                sampSendChat("/do Шприц в руке.")
                wait(cfg.commands.zaderjka)
                sampSendChat(("/me %s ватку смоченную мед.спиртом и %s место укола"):format(cfg.main.male and "взял" or "взяла", cfg.main.male and "обработал" or "обработала"))
                wait(cfg.commands.zaderjka)
                sampSendChat(("/me %s жгут на руке пациента, после чего %s инъекцию"):format(cfg.main.male and "затянул" or "затянула", cfg.main.male and "ввел" or "ввела"))
                wait(cfg.commands.zaderjka)
                sampSendChat(("/me %s жгут и %s ватку к месту укола"):format(cfg.main.male and "снял" or "сняла", cfg.main.male and "приложил" or "приложила"))
                wait(1400)
                sampSendChat(("/healaddict %s 10000"):format(id))
            end
        },
        {
            title = "» Сделать рентген",
            onclick = function()
                sampSendChat(("/me %s рентгеновский аппарат"):format(cfg.main.male and "включил" or "включила"))
                wait(cfg.commands.zaderjka)
                sampSendChat("/do Рентгеновский аппарат зашумел.")
                wait(cfg.commands.zaderjka)
                sampSendChat(("/me %s рентгеновским аппаратом по поврежденному участку"):format(cfg.main.male and "провел" or "провела"))
                wait(cfg.commands.zaderjka)
                sampSendChat("/me рассматривает снимок")
                wait(cfg.commands.zaderjka)
                sampSendChat(("/try %s перелом"):format(cfg.main.male and "обнаружил" or "обнаружила"))
            end
        },
        {
            title = "» Вылечить перелом конечностей",
            onclick = function()
                sampSendChat(("/me %s со стола перчатки и %s их"):format(cfg.main.male and "взял" or "взяла", cfg.main.male and "надел" or "надела"))
                wait(cfg.commands.zaderjka)
                sampSendChat(("/me %s шприц с обезбаливающим, после чего %s поврежденный участок"):format(cfg.main.male and "взял" or "взяла", cfg.main.male and "обезболил" or "обезболила"))
                wait(cfg.commands.zaderjka)
                sampSendChat(("/me %s репозицию поврежденного участка"):format(cfg.main.male and "провел" or "провела"))
                wait(cfg.commands.zaderjka)
                sampSendChat(("/me %s бинт вдоль стола, после чего %s гипсовый раствор"):format(cfg.main.male and "раскатил" or "раскатила", cfg.main.male and "втер" or "втерла"))
                wait(cfg.commands.zaderjka)
                sampSendChat(("/me %s бинт, после чего зафиксировал перелом"):format(cfg.main.male and "свернул" or "свернула"))
                wait(cfg.commands.zaderjka)
                sampSendChat("Приходите через месяц. Всего доброго!")
                wait(cfg.commands.zaderjka)
                sampSendChat(("/me %s перчатки и %s их в урну возле стола"):format(cfg.main.male and "снял" or "сняла", cfg.main.male and "бросил" or "бросила"))
            end
        },
        {
            title = "» Вылечить перелом позвоночника / ребер",
            onclick = function()
                sampSendChat(("/me осторожно %s пострадавшего на операционный стол"):format(cfg.main.male and "уклал" or "уклала"))
                wait(cfg.commands.zaderjka)
                sampSendChat(("/me %s со стола перчатки и %s их"):format(cfg.main.male and "взял" or "взяла", cfg.main.male and "надел" or "надела"))
                wait(cfg.commands.zaderjka)
                sampSendChat(("/me %s пострадавшего к капельнице"):format(cfg.main.male and "подключил" or "подключила"))
                wait(cfg.commands.zaderjka)
                sampSendChat(("/me %s ватку спиртом и %s кожу на руке пациента"):format(cfg.main.male and "намочил" or "намочила", cfg.main.male and "обработал" or "обработала"))
                wait(cfg.commands.zaderjka)
                sampSendChat(("/me внутривенно %s Фторотан"):format(cfg.main.male and "ввел" or "ввела"))
                wait(cfg.commands.zaderjka)
                sampSendChat("/do Наркоз начинает действовать, пациент потерял сознание.")
                wait(cfg.commands.zaderjka)
                sampSendChat(("/me %s скальпель и пинцет"):format(cfg.main.male and "достал" or "достала"))
                wait(cfg.commands.zaderjka)
                sampSendChat(("/me с помощью различных инструментов %s репозицию поврежденного участка"):format(cfg.main.male and "произвел" or "произвела"))
                wait(cfg.commands.zaderjka)
                sampSendChat(("/me %s из тумбочки специальный корсет"):format(cfg.main.male and "достал" or "достала"))
                wait(cfg.commands.zaderjka)
                sampSendChat(("/me %s поврежденный участок с помощью карсета"):format(cfg.main.male and "зафиксировал" or "зафиксировала"))
                wait(cfg.commands.zaderjka)
                sampSendChat(("/me %s перчатки и %s их в урну возле стола"):format(cfg.main.male and "снял" or "сняла", cfg.main.male and "бросил" or "бросила"))
                wait(cfg.commands.zaderjka)
                sampSendChat(("/me %s в отдельный контейнер грязный инструментарий"):format(cfg.main.male and "убрал" or "убрала"))
                wait(cfg.commands.zaderjka)
                sampSendChat("/do Прошло некоторое время, пациент пришел в сознание.")
            end
        },
        {
            title = "» Глубокий порез",
            onclick = function()
                sampSendChat(("/me %s со стола перчатки и %s их"):format(cfg.main.male and "взял" or "взяла", cfg.main.male and "надел" or "надела"))
                wait(cfg.commands.zaderjka)
                sampSendChat(("/me %s осмотр пациента"):format(cfg.main.male and "провел" or "провела"))
                wait(cfg.commands.zaderjka)
                sampSendChat(("/me %s степень тяжести пореза у пациента"):format(cfg.main.male and "определил" or "определила"))
                wait(cfg.commands.zaderjka)
                sampSendChat(("/me %s поврежденный участок"):format(cfg.main.male and "обезболил" or "обезболила"))
                wait(cfg.commands.zaderjka)
                sampSendChat(("/me %s из мед. сумки жгут и %s его поверх повреждения"):format(cfg.main.male and "достал" or "достала", cfg.main.male and "наложил" or "наложила"))
                wait(cfg.commands.zaderjka)
                sampSendChat(("/me %s хирургические инструменты на столе"):format(cfg.main.male and "разложил" or "разложила"))
                wait(cfg.commands.zaderjka)
                sampSendChat(("/me %s специальные иглу и нити"):format(cfg.main.male and "взял" or "взяла"))
                wait(cfg.commands.zaderjka)
                sampSendChat(("/me %s кровеносный сосуд и %s пульс"):format(cfg.main.male and "зашил" or "зашила", cfg.main.male and "проверил" or "проверила"))
                wait(cfg.commands.zaderjka)
                sampSendChat(("/me %s кровь и %s место пореза"):format(cfg.main.male and "протер" or "протерла", cfg.main.male and "зашил" or "зашила"))
                wait(cfg.commands.zaderjka)
                sampSendChat(("/me %s иглу и нити в сторону"):format(cfg.main.male and "отложил" or "отложила"))
                wait(cfg.commands.zaderjka)
                sampSendChat(("/me %s жгут, %s бинты и %s поврежденный участок кожи"):format(cfg.main.male and "снял" or "сняла", cfg.main.male and "взял" or "взяла", cfg.main.male and "перебинтовал" or "перебинтовала"))
                wait(cfg.commands.zaderjka)
                sampSendChat(("/me %s в отдельный контейнер грязный инструментарий"):format(cfg.main.male and "убрал" or "убрала"))
            end
        },
        {
            title = "Пулевое ранение",
            submenu = {
                {
                    title = "» Основная отыгровка",
                    onclick = function()
                        sampSendChat(("/me %s осмотр пациента"):format(cfg.main.male and "провел" or "провела"))
                        wait(cfg.commands.zaderjka)
                        sampSendChat(("/me %s признаки пулевого ранения у пациента"):format(cfg.main.male and "выявил" or "выявила"))
                        wait(cfg.commands.zaderjka)
                        sampSendChat(("/me %s из мед. сумки и %s стерильные перчатки"):format(cfg.main.male and "достал" or "достала", cfg.main.male and "надел" or "надела"))
                        wait(cfg.commands.zaderjka)
                        sampSendChat(("/me %s и %s аппарат для наркоза"):format(cfg.main.male and "подкатил" or "подкатила", cfg.main.male and "включил" or "включила"))
                        wait(cfg.commands.zaderjka)
                        sampSendChat(("/me %s маску для наркоза пациенту"):format(cfg.main.male and "надел" or "надела"))
                        wait(cfg.commands.zaderjka)
                        sampSendChat("/do Пациент заснул.")
                        wait(cfg.commands.zaderjka)
                        sampSendChat(("/me %s хирургические инструменты на столе и %s ватку"):format(cfg.main.male and "разложил" or "разложила", cfg.main.male and "взял" or "взяла"))
                        wait(cfg.commands.zaderjka)
                        sampSendChat(("/me %s рану пациента и %s щипцы"):format(cfg.main.male and "обработал" or "обработала", cfg.main.male and "взял" or "взяла"))
                        wait(cfg.commands.zaderjka)
                        sampSendChat(("/try %s пулю"):format(cfg.main.male and "вытащил" or "вытащила"))
                        return true
                    end
                },
                {
                    title = "» Продолжение если {63c600}[Удачно]",
                    onclick = function()
                        sampSendChat(("/me %s пулю, %s мед. иглу и мед. нити и %s рану пациенту"):format(cfg.main.male and "отложил" or "отложила", cfg.main.male and "взял" or "взяла", cfg.main.male and "зашил" or "зашила"))
                        wait(cfg.commands.zaderjka)
                        sampSendChat(("/me %s бинты и %s на ранения"):format(cfg.main.male and "достал" or "достала", cfg.main.male and "наложил" or "наложила"))
                        wait(cfg.commands.zaderjka)
                        sampSendChat(("/me %s и %s стерильные перчатки "):format(cfg.main.male and "снял" or "сняла", cfg.main.male and "свернул" or "свернула"))
                        wait(cfg.commands.zaderjka)
                        sampSendChat(("/me %s аппарат для наркоза и %s маску с пациента"):format(cfg.main.male and "отключил" or "отключила", cfg.main.male and "снял" or "сняла"))
                        wait(cfg.commands.zaderjka)
                        sampSendChat("/do Пациент проснулся ")
                        wait(1400)
                        sampSendChat("Вам положен постельный режим. Выздоравливайте")
                    end
                },
                {
                    title = "» Продолжение {bf0000}[Неудачно]",
                    onclick = function()
                        sampSendChat(("/me %s кровь ваткой"):format(cfg.main.male and "вытер" or "вытерла"))
                        wait(cfg.commands.zaderjka)
                        sampSendChat(("/try %s пулю"):format(cfg.main.male and "вытащил" or "вытащила"))
                        return true
                    end
                }
            }
        }
    }
end

function pkmmenuAS(id)
    return
    {
        {
            title = "{FFFFFF}Выдать лицензии",
            submenu = {
                {
                    title = "» Водительские права",
                    onclick = function()
                        if sampIsPlayerConnected(id) then
                            giveLicense(id, 0)
                        end
                    end
                },
                {
                    title = "» Воздушний транспорт",
                    onclick = function()
                        if sampIsPlayerConnected(id) then
                            giveLicense(id, 1)
                        end
                    end
                },
                {
                    title = "» Водный транспорт",
                    onclick = function()
                        if sampIsPlayerConnected(id) then
                            giveLicense(id, 3)
                        end
                    end
                },
                {
                    title = "» Лицензия на оружие",
                    onclick = function()
                        if sampIsPlayerConnected(id) then
                            giveLicense(id, 4)
                        end
                    end
                },
                {
                    title = "» Лицензия на рыболовство",
                    onclick = function()
                        if sampIsPlayerConnected(id) then
                            giveLicense(id, 2)
                        end
                    end
                },
                {
                    title = "» Лицензия на бизнес",
                    onclick = function()
                        if sampIsPlayerConnected(id) then
                            giveLicense(id, 5)
                        end
                    end
                }
            }
        },
        {
            title = "{FFFFFF}Задать вопросы",
            submenu = {
                {
                    title = "{FFFFFF}» Максимальная скорость в городе {6495ED}[Ответ: {FFFFFF}50{6495ED}]",
                    onclick = function() sampSendChat("Какая максимальная скорость разрешена в городе?") end
                },
                {
                    title = "{FFFFFF}» Максимальная скорость в жилых зонах {6495ED}[Ответ: {FFFFFF}30{6495ED}]",
                    onclick = function() sampSendChat("Какая максимальная скорость разрешена в жилых зонах?") end
                },
                {
                    title = "{FFFFFF}» С какой стороны разрешен обгон {6495ED}[Ответ: {FFFFFF}С левой{6495ED}]",
                    onclick = function() sampSendChat("С какой стороны разрешен обгон?") end
                },
                {
                    title = "{FFFFFF}» Можно ли останавливаться на проезжей части {6495ED}[Ответ: {FFFFFF}Нет{6495ED}]",
                    onclick = function() sampSendChat("Можно ли останавливаться на проезжей части?") end
                },
                {
                    title = "{FFFFFF}» Цель ношения оружия",
                    onclick = function() sampSendChat("Зачем вам лицензия на оружие?") end
                },
                {
                    title = "{FFFFFF}» Хранение оружия",
                    onclick = function() sampSendChat("Где вы будете хранить оружие?") end
                }
            }
        },
        {
            title = "{FFFFFF}Огласить цену на лизцензию",
            submenu = {
                {
                    title = "» Водительские права",
                    onclick = function() sampSendChat(("Лицензия будет стоить %s$. Оформляем?"):format(getDriveLicenseCount(id))) end
                },
                {
                    title = "» Воздушний транспорт",
                    onclick = function() sampSendChat("Лицензия будет стоить 10000$. Оформляем?") end
                },
                {
                    title = "» Водный транспорт",
                    onclick = function() sampSendChat("Лицензия будет стоить 5000$. Оформляем?") end
                },
                {
                    title = "» Лицензия на оружие",
                    onclick = function() sampSendChat("Лицензия будет стоить 50000$. Оформляем?") end
                },
                {
                    title = "» Лицензия на рыболовство",
                    onclick = function() sampSendChat("Лицензия будет стоить 2000$. Оформляем?") end
                },
                {
                    title = "» Лицензия на бизнес",
                    onclick = function() sampSendChat("Лицензия будет стоить 100000$. Оформляем?") end
                }
            }
        }
    }
end

function pkmmenuPD(id)
	return
	{
		{
			title = '{ffffff}» Надеть наручники',
			onclick = function()
				if sampIsPlayerConnected(id) then
					sampSendChat(string.format('/me %s руки %s и %s наручники', cfg.main.male and 'заломал' or 'заломала', sampGetPlayerNickname(id):gsub("_", " "), cfg.main.male and 'достал' or 'достала'))
					wait(1400)
					sampSendChat(string.format('/cuff %s', id))
				end
			end
		},
		{
			title = "{ffffff}» Вести за собой",
			onclick = function()
				if sampIsPlayerConnected(id) then
					sampSendChat(string.format('/me %s один из концов наручников к себе, после чего %s за собой %s', cfg.main.male and 'пристегнул' or 'пристегнула', cfg.main.male and 'повел' or 'повела', sampGetPlayerNickname(id):gsub("_", " ")))
					wait(1400)
					sampSendChat(string.format('/follow %s', id))
				end
			end
		},
		{
			title = "{ffffff}» Произвести обыск",
			onclick = function()
				if sampIsPlayerConnected(id) then
					sampSendChat(string.format("/me надев перчатки, %s руками по торсу", cfg.main.male and 'провел' or 'провела'))
					wait(cfg.commands.zaderjka)
					sampSendChat(('/take %s'):format(id))
				end
			end
		},
		{
			title = "{ffffff}» Произвести арест",
			onclick = function()
				if sampIsPlayerConnected(id) then
					--[[sampSendChat(('/me достав ключи от камеры %s ее'):format(cfg.main.male and 'открыл' or 'открыла'))
					wait(cfg.commands.zaderjka)
					sampSendChat(('/me %s %s в камеру'):format(cfg.main.male and 'затолкнул' or 'затолкнула', sampGetPlayerNickname(id):gsub("_", " ")))
					wait(cfg.commands.zaderjka)
					sampSendChat(('/arrest %s'):format(id))
					wait(cfg.commands.zaderjka)
                    sampSendChat(('/me закрыв камеру %s ключи в карман'):format(cfg.main.male and 'убрал' or 'убрала'))]]
                    sampSendChat("/do Ключи от камеры висят на поясе.")
                    wait(cfg.commands.zaderjka)
                    sampSendChat(string.format("/me %s ключи с пояса и %s камеру, после %s туда преступника", cfg.main.male and 'снял' or 'сняла', cfg.main.male and 'открыл' or 'открыла', cfg.main.male and 'затолкнул' or 'затолкнула'))
                    wait(cfg.commands.zaderjka)
                    sampSendChat('/arrest '..id)
                    wait(cfg.commands.zaderjka)
                    sampSendChat(string.format("/me %s дверь камеры и %s ключи на пояс", cfg.main.male and 'закрыл' or 'закрыла', cfg.main.male and 'повесил' or 'повесила'))
				end
			end
		},
		{
			title = '{ffffff}» Снять наручники',
			onclick = function()
				if sampIsPlayerConnected(id) then
					sampSendChat(('/me %s наручники с %s'):format(cfg.main.male and 'снял' or 'сняла', sampGetPlayerNickname(id):gsub("_", " ")))
					wait(1400)
					sampSendChat(('/uncuff %s'):format(id))
				end
			end
        },
        {
            title = "{ffffff}» Снять маску",
            onclick = function()
                if sampIsPlayerConnected(id) then
                    sampSendChat(("/offmask %s"):format(id))
                end
            end
        },
		{
			title = "{ffffff}» Выдать розыск за проникновение",
			onclick = function()
				if sampIsPlayerConnected(id) then
					sampSendChat(("/su %s 2 Проникновение на охр. территорию"):format(id))
				end
			end
		},
		{
			title = "{ffffff}» Выдать розыск за хранение наркотиков",
			onclick = function()
				if sampIsPlayerConnected(id) then
					sampSendChat(("/su %s 3 Хранение наркотиков"):format(id))
				end
			end
		},
		{
			title = "{ffffff}» Выдать розыск за хранение материалов",
			onclick = function()
				if sampIsPlayerConnected(id) then
					sampSendChat(("/su %s 3 Хранение материалов"):format(id))
				end
			end
		},
		{
			title = "{ffffff}» Выдать розыск за продажу наркотиков",
			onclick = function()
				if sampIsPlayerConnected(id) then
					sampSendChat(('/su %s 2 Продажа наркотиков'):format(id))
					wait(1400)
					sampSendChat(("/me %s руки %s и %s наручники"):format(cfg.main.male and 'заломал' or 'заломала', sampGetPlayerNickname(id):gsub("_", " "), cfg.main.male and 'достал' or 'достала'))
				end
			end
		},
		{
			title = "{ffffff}» Выдать розыск за продажу ключей от камеры",
			onclick = function()
				if sampIsPlayerConnected(id) then
					sampSendChat(("/su %s 6 Продажа ключей от камеры"):format(id))
				end
			end
		},
		{
			title = "{ffffff}» Выдать розыск за вооруженное нападение на ПО",
			onclick = function()
				if sampIsPlayerConnected(id) then
					sampSendChat(("/su %s 6 Вооруженное нападение на ПО"):format(id))
				end
			end
		},
		{
			title = "{ffffff}» Выдать розыск",
			onclick = function()
				if sampIsPlayerConnected(id) then
					submenus_show(sumenu(id), ('{9966cc}'..script.this.name..' {ffffff}| %s [%s]'):format(sampGetPlayerNickname(id):gsub("_", " "), id))
				end
			end
		}
	}
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

function onScriptTerminate(scr)
    if scr == script.this then
		showCursor(false)
	end
end

if limgui then
    function imgui.TextQuestion(text)
        imgui.TextDisabled('(?)')
        if imgui.IsItemHovered() then
            imgui.BeginTooltip()
            imgui.PushTextWrapPos(450)
            imgui.TextUnformatted(text)
            imgui.PopTextWrapPos()
            imgui.EndTooltip()
        end
    end
    function imgui.CentrText(text)
        local width = imgui.GetWindowWidth()
        local calc = imgui.CalcTextSize(text)
        imgui.SetCursorPosX( width / 2 - calc.x / 2 )
        imgui.Text(text)
    end
    function imgui.CustomButton(name, color, colorHovered, colorActive, size)
        local clr = imgui.Col
        imgui.PushStyleColor(clr.Button, color)
        imgui.PushStyleColor(clr.ButtonHovered, colorHovered)
        imgui.PushStyleColor(clr.ButtonActive, colorActive)
        if not size then size = imgui.ImVec2(0, 0) end
        local result = imgui.Button(name, size)
        imgui.PopStyleColor(3)
        return result
    end
    function imgui.OnDrawFrame()
        if infbar.v then
            imgui.ShowCursor = false
            _, myid = sampGetPlayerIdByCharHandle(PLAYER_PED)
            local myname = sampGetPlayerNickname(myid)
            local myping = sampGetPlayerPing(myid)
            local myweapon = getCurrentCharWeapon(PLAYER_PED)
            local myweaponammo = getAmmoInCharWeapon(PLAYER_PED, myweapon)
            local valid, ped = getCharPlayerIsTargeting(PLAYER_HANDLE)
            local myweaponname = getweaponname(myweapon)
            imgui.SetNextWindowPos(imgui.ImVec2(cfg.main.posX, cfg.main.posY), imgui.ImVec2(0.5, 0.5))
            imgui.SetNextWindowSize(imgui.ImVec2(cfg.main.widehud, 160), imgui.Cond.FirstUseEver)
            imgui.Begin(script.this.name, infbar, imgui.WindowFlags.NoResize + imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoTitleBar)
            imgui.CentrText(script.this.name)
            imgui.Separator()
            imgui.Text((u8"Информация:"):format(myname, myid, myping))
            imgui.SameLine()
            imgui.TextColored(imgui.ImVec4(getColor(myid)), u8('%s [%s]'):format(myname, myid))
            imgui.SameLine()
            imgui.Text((u8"| Пинг: %s"):format(myping))
            --imgui.Text((u8 'Оружие: %s [%s]'):format(myweaponname, myweaponammo))
            if getAmmoInClip() ~= 0 then
                imgui.Text((u8 "Оружие: %s [%s/%s]"):format(myweaponname, getAmmoInClip(), myweaponammo - getAmmoInClip()))
            else
                imgui.Text((u8 'Оружие: %s'):format(myweaponname))
            end
            if isCharInAnyCar(playerPed) then
                local vHandle = storeCarCharIsInNoSave(playerPed)
                local result, vID = sampGetVehicleIdByCarHandle(vHandle)
                local vHP = getCarHealth(vHandle)
                local carspeed = getCarSpeed(vHandle)
                local speed = math.floor(carspeed)
                local vehName = tCarsName[getCarModel(storeCarCharIsInNoSave(playerPed))-399]
                local ncspeed = math.floor(carspeed*2)
                imgui.Text((u8 'Транспорт: %s [%s] | HP: %s | Скорость: %s'):format(vehName, vID, vHP, ncspeed))
            else
                imgui.Text(u8 'Транспорт: Нет')
            end
            if valid and doesCharExist(ped) then 
                local result, id = sampGetPlayerIdByCharHandle(ped)
                if result then
                    local targetname = sampGetPlayerNickname(id)
                    local targetscore = sampGetPlayerScore(id)
                    imgui.Text((u8 'Цель: %s [%s] | Уровень: %s'):format(targetname, id, targetscore))
                else
                    imgui.Text(u8 'Цель: Нет')
                end
            else
                imgui.Text(u8 'Цель: Нет')
            end
            imgui.Text((u8 'Квадрат: %s'):format(u8(kvadrat())))
            imgui.Text((u8 'Время: %s'):format(os.date('%H:%M:%S')))
            if cfg.main.group == "ПД/ФБР" or cfg.main.group == "Мэрия" then imgui.Text((u8 'Tazer: %s'):format(stazer and 'ON' or 'OFF')) end
            if imgui.IsMouseClicked(0) and changetextpos then
                changetextpos = false
                sampToggleCursor(false)
                mainw.v = true
                saveData(cfg, 'moonloader/config/fbitools/config.json')
            end
            imgui.End()
        end
        if imegaf.v then
            imgui.ShowCursor = true
            local x, y = getScreenResolution()
            local btn_size = imgui.ImVec2(-0.1, 0)
            imgui.SetNextWindowSize(imgui.ImVec2(300, 300), imgui.Cond.FirstUseEver)
            imgui.SetNextWindowPos(imgui.ImVec2(x/2+300, y/2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
            imgui.Begin(u8(script.this.name..' | Мегафон'), imegaf, imgui.WindowFlags.NoResize)
            for k, v in ipairs(incar) do
                local mx, my, mz = getCharCoordinates(PLAYER_PED)
                if sampIsPlayerConnected(v) then
                    local result, ped = sampGetCharHandleBySampPlayerId(v)
                    if result then
                        local px, py, pz = getCharCoordinates(ped)
                        local dist = math.floor(getDistanceBetweenCoords3d(mx, my, mz, px, py, pz))
                        if isCharInAnyCar(ped) then
                            local carh = storeCarCharIsInNoSave(ped)
                            local carhm = getCarModel(carh)
                            if imgui.Button(("%s [EVL%sX] | Distance: %s m.##%s"):format(tCarsName[carhm-399], v, dist, k), btn_size) then
                                lua_thread.create(function()
                                    imegaf.v = false
                                    gmegafid = v
                                    gmegaflvl = sampGetPlayerScore(v)
                                    gmegaffrak = sampGetFraktionBySkin(v)
                                    gmegafcar = tCarsName[carhm-399]
                                    sampSendChat(("/m Водитель а/м %s [EVL%sX]"):format(tCarsName[carhm-399], v))
                                    wait(1400)
                                    sampSendChat("/m Прижмитесь к обочине или мы откроем огонь!")
                                    wait(300)
                                    sampAddChatMessage(' {ffffff}~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~', 0x9966cc)
                                    sampAddChatMessage('', 0x9966cc)
                                    sampAddChatMessage(' {ffffff}Ник: {9966cc}'..sampGetPlayerNickname(v)..' ['..v..']', 0x9966cc)
                                    sampAddChatMessage(' {ffffff}Уровень: {9966cc}'..sampGetPlayerScore(v), 0x9966cc)
                                    sampAddChatMessage(' {ffffff}Фракция: {9966cc}'..sampGetFraktionBySkin(v), 0x9966cc)
                                    sampAddChatMessage('', 0x9966cc)
                                    sampAddChatMessage(' {ffffff}~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~', 0x9966cc)
                                end)
                            end
                        end
                    end
                end
            end
            imgui.End()
        end
        if updwindows.v then
            local updlist = ttt
            imgui.ShowCursor = true
            local iScreenWidth, iScreenHeight = getScreenResolution()
            imgui.SetNextWindowPos(imgui.ImVec2(iScreenWidth / 2, iScreenHeight / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
            imgui.SetNextWindowSize(imgui.ImVec2(700, 290), imgui.Cond.FirstUseEver)
            imgui.Begin(u8(script.this.name..' | Обновление'), updwindows, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize)
            imgui.Text(u8('Вышло обновление скрипта '..script.this.name..'! Что бы обновиться нажмите кнопку внизу. Список изменений:'))
            imgui.Separator()
            imgui.BeginChild("uuupdate", imgui.ImVec2(690, 200))
            for line in ttt:gmatch('[^\r\n]+') do
                imgui.TextWrapped(line)
            end
            imgui.EndChild()
            imgui.Separator()
            imgui.PushItemWidth(305)
            if imgui.Button(u8("Обновить"), imgui.ImVec2(339, 25)) then
                lua_thread.create(goupdate)
                updwindows.v = false
            end
            imgui.SameLine()
            if imgui.Button(u8("Отложить обновление"), imgui.ImVec2(339, 25)) then
                updwindows.v = false
                ftext("Если вы захотите установить обновление введите команду {9966CC}/ft")
            end
            imgui.End()
        end
        if mainw.v then
            imgui.ShowCursor = true
            local x, y = getScreenResolution()
            local btn_size = imgui.ImVec2(-0.1, 0)
            imgui.SetNextWindowSize(imgui.ImVec2(300, 300), imgui.Cond.FirstUseEver)
            imgui.SetNextWindowPos(imgui.ImVec2(x/2, y/2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
            imgui.Begin(u8(script.this.name..' | Главное меню | Версия: '..thisScript().version), mainw, imgui.WindowFlags.NoResize)
            if imgui.Button(u8'Биндер', btn_size) then
                bMainWindow.v = not bMainWindow.v
            end
            if imgui.Button(u8'Командный биндер', btn_size) then
                vars.mainwindow.v = not vars.mainwindow.v
            end
            if imgui.Button(u8 'Команды скрипта', btn_size) then cmdwind.v = not cmdwind.v end
            if imgui.Button(u8'Настройки скрипта', btn_size) then
                setwindows.v = not setwindows.v
            end
            if imgui.Button(u8 'Сообщить о ошибке / баге', btn_size) then os.execute('explorer "https://vk.me/fbitools"') end
            if canupdate then if imgui.Button(u8 '[!] Доступно обновление скрипта [!]', btn_size) then updwindows.v = not updwindows.v end end
            if imgui.CollapsingHeader(u8 'Действия со скриптом', btn_size) then
                if imgui.Button(u8'Перезагрузить скрипт', btn_size) then
                    thisScript():reload()
                end
                if imgui.Button(u8 'Отключить скрипт', btn_size) then
                    thisScript():unload()
                end
            end
            imgui.End()
            if cmdwind.v then
                local x, y = getScreenResolution()
                imgui.SetNextWindowSize(imgui.ImVec2(500, 500), imgui.Cond.FirstUseEver)
                imgui.SetNextWindowPos(imgui.ImVec2(x/2, y/2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
                imgui.Begin(u8(script.this.name..' | Команды'), cmdwind)
                for k, v in ipairs(fthelp) do
                    if imgui.CollapsingHeader(v['cmd']..'##'..k) then
                        imgui.TextWrapped(u8('Описание: %s'):format(u8(v['desc'])))
                        imgui.TextWrapped(u8("Использование: %s"):format(u8(v['use'])))
                    end
                end
                imgui.End()
            end
            if vars.mainwindow.v then
                local sX, sY = getScreenResolution()
                imgui.SetNextWindowPos(imgui.ImVec2(sX/2, sY/2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
                imgui.SetNextWindowSize(imgui.ImVec2(891, 380), imgui.Cond.FirstUseEver)
                imgui.Begin(u8(script.this.name.." | Список команд"), vars.mainwindow, imgui.WindowFlags.NoResize)
                imgui.BeginChild("##commandlist", imgui.ImVec2(170 ,320), true)
                for k, v in pairs(commands) do
                    if imgui.Selectable(u8(("%s. /%s##%s"):format(k, v.cmd, k)), vars.menuselect == k) then 
                        vars.menuselect     = k 
                        vars.cmdbuf.v       = u8(v.cmd) 
                        vars.cmdparams.v    = v.params
                        vars.cmdtext.v      = u8(v.text)
                    end
                end
                imgui.EndChild()
                imgui.SameLine()
                imgui.BeginChild("##commandsetting", imgui.ImVec2(700, 320), true)
                for k, v in pairs(commands) do
                    if vars.menuselect == k then
                        imgui.InputText(u8 "Введите саму команду", vars.cmdbuf)
                        imgui.InputInt(u8 "Введите кол-во параметров команды", vars.cmdparams, 0)
                        imgui.InputTextMultiline(u8 "##cmdtext", vars.cmdtext, imgui.ImVec2(678, 200))
                        imgui.TextWrapped(u8 "Ключи параметров: {param:1}, {param:2} и т.д (Использовать в тексте на месте параметра)\nКлюч задержки: {wait:кол-во миллисекунд} (Использовать на новой строке)")
                        if imgui.Button(u8 "Сохранить команду") then
                            sampUnregisterChatCommand(v.cmd)
                            v.cmd = u8:decode(vars.cmdbuf.v)
                            v.params = vars.cmdparams.v
                            v.text = u8:decode(vars.cmdtext.v)
                            saveData(commands, "moonloader/config/fbitools/cmdbinder.json")
                            registerCommandsBinder()
                            ftext("Команда сохранена")
                        end
                        imgui.SameLine()
                        if imgui.Button(u8 "Удалить команду") then
                            imgui.OpenPopup(u8 "Удаление команды##"..k)
                        end
                        if imgui.BeginPopupModal(u8 "Удаление команды##"..k, _, imgui.WindowFlags.AlwaysAutoResize) then
                            imgui.SetCursorPosX(imgui.GetWindowWidth()/2 - imgui.CalcTextSize(u8 "Вы действительно хотите удалить команду?").x / 2)
                            imgui.Text(u8 "Вы действительно хотите удалить команду?")
                            if imgui.Button(u8 "Удалить##"..k, imgui.ImVec2(170, 20)) then
                                sampUnregisterChatCommand(v.cmd)
                                vars.menuselect     = 0
                                vars.cmdbuf.v       = ""
                                vars.cmdparams.v    = 0
                                vars.cmdtext.v      = ""
                                table.remove(commands, k)
                                saveData(commands, "moonloader/config/fbitools/cmdbinder.json")
                                registerCommandsBinder()
                                ftext("Команда удалена")
                                imgui.CloseCurrentPopup()
                            end
                            imgui.SameLine()
                            if imgui.Button(u8 "Отмена##"..k, imgui.ImVec2(170, 20)) then
                                imgui.CloseCurrentPopup()
                            end
                            imgui.EndPopup()
                        end
                        imgui.SameLine()
                        if imgui.Button(u8 'Ключи', imgui.ImVec2(170, 20)) then imgui.OpenPopup('##bindkey') end
                        if imgui.BeginPopup('##bindkey') then
                            imgui.Text(u8 'Используйте ключи биндера для более удобного использования биндера')
                            imgui.Text(u8 'Пример: /su {targetid} 6 Вооруженное нападение на ПО')
                            imgui.Separator()
                            imgui.Text(u8 '{myid} - ID вашего персонажа | '..select(2, sampGetPlayerIdByCharHandle(PLAYER_PED)))
                            imgui.Text(u8 '{myrpnick} - РП ник вашего персонажа | '..sampGetPlayerNickname(select(2, sampGetPlayerIdByCharHandle(PLAYER_PED))):gsub('_', ' '))
                            imgui.Text(u8 ('{naparnik} - Ваши напарники | '..naparnik()))
                            imgui.Text(u8 ('{kv} - Ваш текущий квадрат | '..kvadrat()))
                            imgui.Text(u8 '{targetid} - ID игрока на которого вы целитесь | '..targetid)
                            imgui.Text(u8 '{targetrpnick} - РП ник игрока на которого вы целитесь | '..sampGetPlayerNicknameForBinder(targetid):gsub('_', ' '))
                            imgui.Text(u8 '{smsid} - Последний ID того, кто вам написал в SMS | '..smsid)
                            imgui.Text(u8 '{smstoid} - Последний ID того, кому вы написали в SMS | '..smstoid)
                            imgui.Text(u8 '{megafid} - ID игрока, за которым была начата погоня | '..gmegafid)
                            imgui.Text(u8 '{rang} - Ваше звание | '..u8(rang))
                            imgui.Text(u8 '{frak} - Ваша фракция | '..u8(frak))
                            imgui.Text(u8 '{dl} - ID авто, в котором вы сидите | '..mcid)
                            imgui.Text(u8 '{noe} - Оставить сообщение в полле ввода а не отправлять его в чат (использовать в самом начале)')
                            imgui.Text(u8 '{wait:sek} - Задержка между строками, где sek - кол-во миллисекунд. Пример: {wait:2000} - задержка 2 секунды. (использовать отдельно на новой строчке)')
                            imgui.Text(u8 '{screen} - Сделать скриншот экрана (использовать отдельно на новой строчке)')
                            imgui.EndPopup()
                        end
                    end
                end
                imgui.EndChild()
                if imgui.Button(u8 "Добавить команду", imgui.ImVec2(170, 20)) then
                    table.insert(commands, {cmd = "", params = 0, text = ""})
                    saveData(commands, "moonloader/config/fbitools/cmdbinder.json")
                end
                imgui.End()
            end
            if bMainWindow.v then
                imgui.ShowCursor = true
                local iScreenWidth, iScreenHeight = getScreenResolution()
                imgui.SetNextWindowPos(imgui.ImVec2(iScreenWidth / 2, iScreenHeight / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
                imgui.SetNextWindowSize(imgui.ImVec2(1000, 510), imgui.Cond.FirstUseEver)
                imgui.Begin(u8(script.this.name.." | Биндер##main"), bMainWindow, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize)
                imgui.BeginChild("##bindlist", imgui.ImVec2(995, 442))
                for k, v in ipairs(tBindList) do
                    if imadd.HotKey("##HK" .. k, v, tLastKeys, 100) then
                        if not rkeys.isHotKeyDefined(v.v) then
                            if rkeys.isHotKeyDefined(tLastKeys.v) then
                                rkeys.unRegisterHotKey(tLastKeys.v)
                            end
                            rkeys.registerHotKey(v.v, true, onHotKey)
                        end
                        saveData(tBindList, fileb)
                    end
                    imgui.SameLine()
                    imgui.CentrText(u8(v.name))
                    imgui.SameLine(850)
                    if imgui.Button(u8 'Редактировать бинд##'..k) then imgui.OpenPopup(u8 "Редактирование биндера##editbind"..k) 
                        bindname.v = u8(v.name) 
                        bindtext.v = u8(v.text)
                    end
                    if imgui.BeginPopupModal(u8 'Редактирование биндера##editbind'..k, _, imgui.WindowFlags.NoResize) then
                        imgui.Text(u8 "Введите название биндера:")
                        imgui.InputText("##Введите название биндера", bindname)
                        imgui.Text(u8 "Введите текст биндера:")
                        imgui.InputTextMultiline("##Введите текст биндера", bindtext, imgui.ImVec2(500, 200))
                        imgui.Separator()
                        if imgui.Button(u8 'Ключи', imgui.ImVec2(90, 20)) then imgui.OpenPopup('##bindkey') end
                        if imgui.BeginPopup('##bindkey') then
                            imgui.Text(u8 'Используйте ключи биндера для более удобного использования биндера')
                            imgui.Text(u8 'Пример: /su {targetid} 6 Вооруженное нападение на ПО')
                            imgui.Separator()
                            imgui.Text(u8 '{myid} - ID вашего персонажа | '..select(2, sampGetPlayerIdByCharHandle(PLAYER_PED)))
                            imgui.Text(u8 '{myrpnick} - РП ник вашего персонажа | '..sampGetPlayerNickname(select(2, sampGetPlayerIdByCharHandle(PLAYER_PED))):gsub('_', ' '))
                            imgui.Text(u8 ('{naparnik} - Ваши напарники | '..naparnik()))
                            imgui.Text(u8 ('{kv} - Ваш текущий квадрат | '..kvadrat()))
                            imgui.Text(u8 '{targetid} - ID игрока на которого вы целитесь | '..targetid)
                            imgui.Text(u8 '{targetrpnick} - РП ник игрока на которого вы целитесь | '..sampGetPlayerNicknameForBinder(targetid):gsub('_', ' '))
                            imgui.Text(u8 '{smsid} - Последний ID того, кто вам написал в SMS | '..smsid)
                            imgui.Text(u8 '{smstoid} - Последний ID того, кому вы написали в SMS | '..smstoid)
                            imgui.Text(u8 '{megafid} - ID игрока, за которым была начата погоня | '..gmegafid)
                            imgui.Text(u8 '{rang} - Ваше звание | '..u8(rang))
                            imgui.Text(u8 '{frak} - Ваша фракция | '..u8(frak))
                            imgui.Text(u8 '{dl} - ID авто, в котором вы сидите | '..mcid)
                            imgui.Text(u8 '{f6} - Отправить сообщение в чат через эмуляцию чата (использовать в самом начале)')
                            imgui.Text(u8 '{noe} - Оставить сообщение в полле ввода а не отправлять его в чат (использовать в самом начале)')
                            imgui.Text(u8 '{wait:sek} - Задержка между строками, где sek - кол-во миллисекунд. Пример: {wait:2000} - задержка 2 секунды. (использовать отдельно на новой строчке)')
                            imgui.Text(u8 '{screen} - Сделать скриншот экрана (использовать отдельно на новой строчке)')
                            imgui.EndPopup()
                        end
                        imgui.SameLine()
                        imgui.SetCursorPosX((imgui.GetWindowWidth() - 90 - imgui.GetStyle().ItemSpacing.x))
                        if imgui.Button(u8 "Удалить бинд##"..k, imgui.ImVec2(90, 20)) then
                            table.remove(tBindList, k)
                            saveData(tBindList, fileb)
                            imgui.CloseCurrentPopup()
                        end
                        imgui.SameLine()
                        imgui.SetCursorPosX((imgui.GetWindowWidth() - 180 + imgui.GetStyle().ItemSpacing.x) / 2)
                        if imgui.Button(u8 "Сохранить##"..k, imgui.ImVec2(90, 20)) then
                            v.name = u8:decode(bindname.v)
                            v.text = u8:decode(bindtext.v)
                            bindname.v = ''
                            bindtext.v = ''
                            saveData(tBindList, fileb)
                            imgui.CloseCurrentPopup()
                        end
                        imgui.SameLine()
                        if imgui.Button(u8 "Закрыть##"..k, imgui.ImVec2(90, 20)) then imgui.CloseCurrentPopup() end
                        imgui.EndPopup()
                    end
                end
                imgui.EndChild()
                imgui.Separator()
                if imgui.Button(u8"Добавить клавишу") then
                    tBindList[#tBindList + 1] = {text = "", v = {}, time = 0, name = "Бинд"..#tBindList + 1}
                    saveData(tBindList, fileb)
                end
                imgui.End()
            end
            if setwindows.v then
                --
                cput            = imgui.ImBool(cfg.commands.cput)
                ceject          = imgui.ImBool(cfg.commands.ceject)
                ftazer          = imgui.ImBool(cfg.commands.ftazer)
                deject          = imgui.ImBool(cfg.commands.deject)
                kmdcb           = imgui.ImBool(cfg.commands.kmdctime)
                carb            = imgui.ImBool(cfg.main.autocar)
                stateb          = imgui.ImBool(cfg.main.male)
                tagf            = imgui.ImBuffer(u8(cfg.main.tar), 256)
                parolf          = imgui.ImBuffer(u8(tostring(cfg.main.parol)), 256)
                tagb            = imgui.ImBool(cfg.main.tarb)
                xcord           = imgui.ImInt(cfg.main.posX)
                ycord           = imgui.ImInt(cfg.main.posY)
                clistbuffer     = imgui.ImInt(cfg.main.clist)
                waitbuffer      = imgui.ImInt(cfg.commands.zaderjka)
                clistb          = imgui.ImBool(cfg.main.clistb)
                parolb          = imgui.ImBool(cfg.main.parolb)
                offptrlb        = imgui.ImBool(cfg.main.offptrl)
                offwntdb        = imgui.ImBool(cfg.main.offwntd)
                ticketb         = imgui.ImBool(cfg.commands.ticket)
                tchatb          = imgui.ImBool(cfg.main.tchat)
                strobbsb        = imgui.ImBool(cfg.main.strobs)
                megafb          = imgui.ImBool(cfg.main.megaf)
                infbarb         = imgui.ImBool(cfg.main.hud)
                autobpb         = imgui.ImBool(cfg.main.autobp)
                deagleb         = imgui.ImBool(cfg.autobp.deagle)
                shotb           = imgui.ImBool(cfg.autobp.shot)
                smgb            = imgui.ImBool(cfg.autobp.smg)
                m4b             = imgui.ImBool(cfg.autobp.m4)
                rifleb          = imgui.ImBool(cfg.autobp.rifle)
                armourb         = imgui.ImBool(cfg.autobp.armour)
                specb           = imgui.ImBool(cfg.autobp.spec)
                dvadeagleb      = imgui.ImBool(cfg.autobp.dvadeagle)
                dvashotb        = imgui.ImBool(cfg.autobp.dvashot)
                dvasmgb         = imgui.ImBool(cfg.autobp.dvasmg)
                dvam4b          = imgui.ImBool(cfg.autobp.dvam4)
                dvarifleb       = imgui.ImBool(cfg.autobp.dvarifle)
                googlecodeb     = imgui.ImBuffer(tostring(cfg.main.googlecode), 256)
                googlecodebb    = imgui.ImBool(cfg.main.googlecodeb)
                nwantedb        = imgui.ImBool(cfg.main.nwanted)
                nclearb         = imgui.ImBool(cfg.main.nclear)
                --
                local iScreenWidth, iScreenHeight = getScreenResolution()
                imgui.SetNextWindowPos(imgui.ImVec2(iScreenWidth / 2, iScreenHeight / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
                imgui.SetNextWindowSize(imgui.ImVec2(1161, 436), imgui.Cond.FirstUseEver)
                imgui.Begin(u8'Настройки##1', setwindows, imgui.WindowFlags.NoResize)
                --ftext(("w: %s / h: %s"):format(imgui.GetWindowWidth(), imgui.GetWindowHeight()))
                if cfg.main.group ~= 'unknown' then
                    imgui.BeginChild('##set', imgui.ImVec2(140, 400), true)
                    if imgui.Selectable(u8'Основные', show == 1) then show = 1 end
                    if cfg.main.group == 'ПД/ФБР' then if imgui.Selectable(u8'Команды', show == 2) then show = 2 end end
                    if imgui.Selectable(u8'Клавиши', show == 3) then show = 3 end
                    if cfg.main.group == 'ПД/ФБР' then if imgui.Selectable(u8'Авто-БП', show == 4) then show = 4 end end
                    imgui.EndChild()
                    imgui.SameLine()
                    imgui.BeginChild('##set1', imgui.ImVec2(1000, 400), true)
                    if show == 1 then
                        if imadd.ToggleButton(u8 'Инфобар', infbarb) then cfg.main.hud = infbarb.v saveData(cfg, 'moonloader/config/fbitools/config.json') end imgui.SameLine() imgui.Text(u8 "Инфо-бар")
                        if infbarb.v then
                            imgui.SameLine()
                            if imgui.Button(u8 'Изменить местоположение') then
                                mainw.v = false
                                changetextpos = true
                                ftext('По завешению нажмите левую кнопку мыши')
                            end
                        end
                        if cfg.main.group == 'ПД/ФБР' then
                            if imadd.ToggleButton(u8'Скрывать сообщения о начале преследования', offptrlb) then cfg.main.offptrl = offptrlb.v saveData(cfg, 'moonloader/config/fbitools/config.json') end imgui.SameLine(); imgui.Text(u8 'Скрывать сообщения о начале преследования')
                            if imadd.ToggleButton(u8'Скрывать сообщения о выдаче розыска', offwntdb) then cfg.main.offwntd = offwntdb.v saveData(cfg, 'moonloader/config/fbitools/config.json') end imgui.SameLine(); imgui.Text(u8 'Скрывать сообщения о выдаче розыска')
                            if imadd.ToggleButton(u8'Новый wanted', nwantedb) then cfg.main.nwanted = nwantedb.v saveData(cfg, 'moonloader/config/fbitools/config.json') end imgui.SameLine(); imgui.Text(u8 'Обновленный Wanted')
                            if imadd.ToggleButton(u8'допclear', nclearb) then cfg.main.nclear = nclearb.v saveData(cfg, 'moonloader/config/fbitools/config.json') end imgui.SameLine(); imgui.Text(u8 'Дополненый Clear')
                        end
                        if imadd.ToggleButton(u8'Мужские отыгровки', stateb) then cfg.main.male = stateb.v saveData(cfg, 'moonloader/config/fbitools/config.json') end imgui.SameLine(); imgui.Text(u8 'Мужские отыгровки')
                        if imadd.ToggleButton(u8'Использовать автотег', tagb) then cfg.main.tarb = tagb.v saveData(cfg, 'moonloader/config/fbitools/config.json') end imgui.SameLine(); imgui.Text(u8 'Использовать автотег')
                        if tagb.v then
                            if imgui.InputText(u8'Введите ваш Тег.', tagf) then cfg.main.tar = u8:decode(tagf.v) saveData(cfg, 'moonloader/config/fbitools/config.json') end
                        end
                        if imadd.ToggleButton(u8'Использовать авто логин', parolb) then cfg.main.parolb = parolb.v saveData(cfg, 'moonloader/config/fbitools/config.json') end; imgui.SameLine(); imgui.Text(u8 'Использовать авто логин')
                        if parolb.v then
                            if imgui.InputText(u8'Введите ваш пароль.', parolf, imgui.InputTextFlags.Password) then cfg.main.parol = u8:decode(parolf.v) saveData(cfg, 'moonloader/config/fbitools/config.json') end
                            if imgui.Button(u8'Узнать пароль') then ftext('Ваш пароль: {9966cc}'..cfg.main.parol) end
                        end
                        if imadd.ToggleButton(u8'Использовать авто g-auth', googlecodebb) then cfg.main.googlecodeb = googlecodebb.v saveData(cfg, 'moonloader/config/fbitools/config.json') end; imgui.SameLine(); imgui.Text(u8 'Использовать авто g-auth')
                        if googlecodebb.v then
                            if imgui.InputText(u8'Введите ваш гугл код(который пришел вам на почту).', googlecodeb, imgui.InputTextFlags.Password) then cfg.main.googlecode = googlecodeb.v saveData(cfg, 'moonloader/config/fbitools/config.json') end
                            if imgui.Button(u8'Узнать гугл код') then ftext('Ваш гугл код: {9966cc}'..cfg.main.googlecode) end
                            if #tostring(cfg.main.googlecode) == 16 then imgui.SameLine() imgui.Text(u8(("Сгенерированый код: %s"):format(genCode(tostring(cfg.main.googlecode))))) end
                        end
                        if imadd.ToggleButton(u8'Использовать автоклист', clistb) then cfg.main.clistb = clistb.v end; imgui.SameLine() saveData(cfg, 'moonloader/config/fbitools/config.json'); imgui.Text(u8 'Использовать автоклист')
                        if clistb.v then
                            if imgui.SliderInt(u8"Выберите значение клиста", clistbuffer, 0, 33) then cfg.main.clist = clistbuffer.v saveData(cfg, 'moonloader/config/fbitools/config.json') end
                        end
                        if imadd.ToggleButton(u8'Открывать чат на T', tchatb) then cfg.main.tchat = tchatb.v saveData(cfg, 'moonloader/config/fbitools/config.json') end imgui.SameLine(); imgui.Text(u8 'Открывать чат на T')
                        if imadd.ToggleButton(u8 'Автоматически заводить авто', carb) then cfg.main.autocar = carb.v saveData(cfg, 'moonloader/config/fbitools/config.json') end imgui.SameLine(); imgui.Text(u8 'Автоматически заводить авто')
                        if cfg.main.group == 'ПД/ФБР' then
                            if imadd.ToggleButton(u8 'Стробоскопы', strobbsb) then cfg.main.strobs = strobbsb.v saveData(cfg, 'moonloader/config/fbitools/config.json') end imgui.SameLine(); imgui.Text(u8 'Стробоскопы')
                            if imadd.ToggleButton(u8 'Расширенный мегафон', megafb) then cfg.main.megaf = megafb.v end saveData(cfg, 'moonloader/config/fbitools/config.json'); imgui.SameLine(); imgui.Text(u8 'Расширенный мегафон')
                        end
                        if imgui.InputInt(u8'Задержка в отыгровках', waitbuffer) then cfg.commands.zaderjka = waitbuffer.v saveData(cfg, 'moonloader/config/fbitools/config.json') end
                        imgui.Separator()
                        if imgui.Button(u8 'Сбросить группу') then imgui.OpenPopup(u8 'Сбросс группы') end
                        imgui.SameLine()
                        imgui.Text(u8 'Текущая группа фракций: '..u8(cfg.main.group))
                        if imgui.BeginPopupModal(u8 'Сбросс группы', _, imgui.WindowFlags.NoResize) then
                            imgui.CentrText(u8 'Вы действительно хотите сбросить группу фракций?')
                            if imgui.Button(u8 'Да##группа', imgui.ImVec2(170, 20)) then cfg.main.group = 'unknown'
                                saveData(cfg, 'moonloader/config/fbitools/config.json')
                                registerCommands()
                                imgui.CloseCurrentPopup()
                            end
                            imgui.SameLine()
                            if imgui.Button(u8 'Нет##группа', imgui.ImVec2(170, 20)) then imgui.CloseCurrentPopup() end
                            imgui.EndPopup()
                        end
                    end
                    if show == 2 then
                        if cfg.main.group == 'ПД/ФБР' then
                            if imadd.ToggleButton(u8('Отыгровка /cput'), cput) then cfg.commands.cput = cput.v end; imgui.SameLine(); imgui.Text(u8 'Отыгровка /cput')
                            if imadd.ToggleButton(u8('Отыгровка /ceject'), ceject) then cfg.commands.ceject = ceject.v saveData(cfg, 'moonloader/config/fbitools/config.json') end; imgui.SameLine(); imgui.Text(u8 'Отыгровка /ceject')
                            if imadd.ToggleButton(u8('Отыгровка /ftazer'), ftazer) then cfg.commands.ftazer = ftazer.v saveData(cfg, 'moonloader/config/fbitools/config.json') end; imgui.SameLine(); imgui.Text(u8 'Отыгровка /ftazer')
                            if imadd.ToggleButton(u8('Отыгровка /deject'), deject) then cfg.commands.deject = deject.v saveData(cfg, 'moonloader/config/fbitools/config.json') end; imgui.SameLine(); imgui.Text(u8 'Отыгровка /deject')
                            if imadd.ToggleButton(u8('Отыгровка /ticket'), ticketb) then cfg.commands.ticket = ticketb.v saveData(cfg, 'moonloader/config/fbitools/config.json') end; imgui.SameLine(); imgui.Text(u8 'Отыгровка /ticket')
                            if imadd.ToggleButton(u8('Использовать /time F8 при /kmdc'), kmdcb) then cfg.commands.kmdctime = kmdcb.v saveData(cfg, 'moonloader/config/fbitools/config.json') end; imgui.SameLine(); imgui.Text(u8 'Использовать /time F8 при /kmdc')
                        end
                    end
                    if show == 3 then
                        if cfg.main.group ~= "Мэрия" then
                            if imadd.HotKey(u8'##Клавиша взаимодействия с игроком', config_keys.vzaimkey, tLastKeys, 100) then
                                rkeys.changeHotKey(vzaimbind, config_keys.vzaimkey.v)
                                ftext('Клавиша успешно изменена. Старое значение: '.. table.concat(rkeys.getKeysName(tLastKeys.v), " + ") .. ' | Новое значение: '.. table.concat(rkeys.getKeysName(config_keys.vzaimkey.v), " + "))
                                saveData(config_keys, 'moonloader/config/fbitools/keys.json')
                            end
                            imgui.SameLine()
                            imgui.Text(u8 'Клавиша взаимодействия с игроком (срабатывает после прицеливания на игрока)')
                            if imadd.HotKey('##fastmenu', config_keys.fastmenukey, tLastKeys, 100) then
                                rkeys.changeHotKey(fastmenubind, config_keys.fastmenukey.v)
                                ftext('Клавиша успешно изменена. Старое значение: '.. table.concat(rkeys.getKeysName(tLastKeys.v), " + ") .. ' | Новое значение: '.. table.concat(rkeys.getKeysName(config_keys.fastmenukey.v), " + "))
                                saveData(config_keys, 'moonloader/config/fbitools/keys.json')
                            end
                            imgui.SameLine()
                            imgui.Text(u8('Клавиша быстрого меню'))
                        end
                        if cfg.main.group == 'ПД/ФБР' or cfg.main.group == 'Мэрия' then
                            if imadd.HotKey(u8'##Клавиша быстрого тазера', config_keys.tazerkey, tLastKeys, 100) then
                                rkeys.changeHotKey(tazerbind, config_keys.tazerkey.v)
                                ftext('Клавиша успешно изменена. Старое значение: '.. table.concat(rkeys.getKeysName(tLastKeys.v), " + ") .. ' | Новое значение: '.. table.concat(rkeys.getKeysName(config_keys.tazerkey.v), " + "))
                                saveData(config_keys, 'moonloader/config/fbitools/keys.json')
                            end
                            imgui.SameLine()
                            imgui.Text(u8'Клавиша быстрого тазера')
                        end
                        if cfg.main.group == 'ПД/ФБР' then
                            if imadd.HotKey('##oopda', config_keys.oopda, tLastKeys, 100) then
                                rkeys.changeHotKey(oopdabind, config_keys.oopda.v)
                                ftext('Клавиша успешно изменена. Старое значение: '.. table.concat(rkeys.getKeysName(tLastKeys.v), " + ") .. ' | Новое значение: '.. table.concat(rkeys.getKeysName(config_keys.oopda.v), " + "))
                                saveData(config_keys, 'moonloader/config/fbitools/keys.json')
                            end
                            imgui.SameLine()
                            imgui.Text(u8('Клавиша подтверждения'))
                            if imadd.HotKey('##oopnet', config_keys.oopnet, tLastKeys, 100) then
                                rkeys.changeHotKey(oopnetbind, config_keys.oopnet.v)
                                ftext('Клавиша успешно изменена. Старое значение: '.. table.concat(rkeys.getKeysName(tLastKeys.v), " + ") .. ' | Новое значение: '.. table.concat(rkeys.getKeysName(config_keys.oopnet.v), " + "))
                                saveData(config_keys, 'moonloader/config/fbitools/keys.json')
                            end
                            imgui.SameLine()
                            imgui.Text(u8('Клавиша отмены'))
                            if imadd.HotKey('##megaf', config_keys.megafkey, tLastKeys, 100) then
                                rkeys.changeHotKey(megafbind, config_keys.megafkey.v)
                                ftext('Клавиша успешно изменена. Старое значение: '.. table.concat(rkeys.getKeysName(tLastKeys.v), " + ") .. ' | Новое значение: '.. table.concat(rkeys.getKeysName(config_keys.megafkey.v), " + "))
                                saveData(config_keys, 'moonloader/config/fbitools/keys.json')
                            end
                            imgui.SameLine()
                            imgui.Text(u8('Клавиша мегафона'))
                            if imadd.HotKey('##dkld', config_keys.dkldkey, tLastKeys, 100) then
                                rkeys.changeHotKey(dkldbind, config_keys.dkldkey.v)
                                ftext('Клавиша успешно изменена. Старое значение: '.. table.concat(rkeys.getKeysName(tLastKeys.v), " + ") .. ' | Новое значение: '.. table.concat(rkeys.getKeysName(config_keys.dkldkey.v), " + "))
                                saveData(config_keys, 'moonloader/config/fbitools/keys.json')
                            end
                            imgui.SameLine()
                            imgui.Text(u8('Клавиша доклада'))
                            if imadd.HotKey('##cuff', config_keys.cuffkey, tLastKeys, 100) then
                                rkeys.changeHotKey(cuffbind, config_keys.cuffkey.v)
                                ftext('Клавиша успешно изменена. Старое значение: '.. table.concat(rkeys.getKeysName(tLastKeys.v), " + ") .. ' | Новое значение: '.. table.concat(rkeys.getKeysName(config_keys.cuffkey.v), " + "))
                                saveData(config_keys, 'moonloader/config/fbitools/keys.json')
                            end
                            imgui.SameLine()
                            imgui.Text(u8('Надеть наручники на преступника'))
                            if imadd.HotKey('##uncuff', config_keys.uncuffkey, tLastKeys, 100) then
                                rkeys.changeHotKey(uncuffbind, config_keys.uncuffkey.v)
                                ftext('Клавиша успешно изменена. Старое значение: '.. table.concat(rkeys.getKeysName(tLastKeys.v), " + ") .. ' | Новое значение: '.. table.concat(rkeys.getKeysName(config_keys.uncuffkey.v), " + "))
                                saveData(config_keys, 'moonloader/config/fbitools/keys.json')
                            end
                            imgui.SameLine()
                            imgui.Text(u8('Снять наручники'))
                            if imadd.HotKey('##follow', config_keys.followkey, tLastKeys, 100) then
                                rkeys.changeHotKey(followbind, config_keys.followkey.v)
                                ftext('Клавиша успешно изменена. Старое значение: '.. table.concat(rkeys.getKeysName(tLastKeys.v), " + ") .. ' | Новое значение: '.. table.concat(rkeys.getKeysName(config_keys.followkey.v), " + "))
                                saveData(config_keys, 'moonloader/config/fbitools/keys.json')
                            end
                            imgui.SameLine()
                            imgui.Text(u8('Вести преступника за собой'))
                            if imadd.HotKey('##cput', config_keys.cputkey, tLastKeys, 100) then
                                rkeys.changeHotKey(cputbind, config_keys.cputkey.v)
                                ftext('Клавиша успешно изменена. Старое значение: '.. table.concat(rkeys.getKeysName(tLastKeys.v), " + ") .. ' | Новое значение: '.. table.concat(rkeys.getKeysName(config_keys.cputkey.v), " + "))
                                saveData(config_keys, 'moonloader/config/fbitools/keys.json')
                            end
                            imgui.SameLine()
                            imgui.Text(u8('Посадить преступника в авто'))
                            if imadd.HotKey('##ceject', config_keys.cejectkey, tLastKeys, 100) then
                                rkeys.changeHotKey(cejectbind, config_keys.cejectkey.v)
                                ftext('Клавиша успешно изменена. Старое значение: '.. table.concat(rkeys.getKeysName(tLastKeys.v), " + ") .. ' | Новое значение: '.. table.concat(rkeys.getKeysName(config_keys.cejectkey.v), " + "))
                                saveData(config_keys, 'moonloader/config/fbitools/keys.json')
                            end
                            imgui.SameLine()
                            imgui.Text(u8('Высадить преступника в участок'))
                            if imadd.HotKey('##take', config_keys.takekey, tLastKeys, 100) then
                                rkeys.changeHotKey(takebind, config_keys.takekey.v)
                                ftext('Клавиша успешно изменена. Старое значение: '.. table.concat(rkeys.getKeysName(tLastKeys.v), " + ") .. ' | Новое значение: '.. table.concat(rkeys.getKeysName(config_keys.takekey.v), " + "))
                                saveData(config_keys, 'moonloader/config/fbitools/keys.json')
                            end
                            imgui.SameLine()
                            imgui.Text(u8('Обыскать преступника'))
                            if imadd.HotKey('##arrest', config_keys.arrestkey, tLastKeys, 100) then
                                rkeys.changeHotKey(arrestbind, config_keys.arrestkey.v)
                                ftext('Клавиша успешно изменена. Старое значение: '.. table.concat(rkeys.getKeysName(tLastKeys.v), " + ") .. ' | Новое значение: '.. table.concat(rkeys.getKeysName(config_keys.arrestkey.v), " + "))
                                saveData(config_keys, 'moonloader/config/fbitools/keys.json')
                            end
                            imgui.SameLine()
                            imgui.Text(u8('Арестовать преступника'))
                            if imadd.HotKey('##deject', config_keys.dejectkey, tLastKeys, 100) then
                                rkeys.changeHotKey(dejectbind, config_keys.dejectkey.v)
                                ftext('Клавиша успешно изменена. Старое значение: '.. table.concat(rkeys.getKeysName(tLastKeys.v), " + ") .. ' | Новое значение: '.. table.concat(rkeys.getKeysName(config_keys.dejectkey.v), " + "))
                                saveData(config_keys, 'moonloader/config/fbitools/keys.json')
                            end
                            imgui.SameLine()
                            imgui.Text(u8('Вытащить преступника из авто'))
                            if imadd.HotKey('##siren', config_keys.sirenkey, tLastKeys, 100) then
                                rkeys.changeHotKey(sirenbind, config_keys.sirenkey.v)
                                ftext('Клавиша успешно изменена. Старое значение: '.. table.concat(rkeys.getKeysName(tLastKeys.v), " + ") .. ' | Новое значение: '.. table.concat(rkeys.getKeysName(config_keys.sirenkey.v), " + "))
                                saveData(config_keys, 'moonloader/config/fbitools/keys.json')
                            end
                            imgui.SameLine()
                            imgui.Text(u8('Включить / выключить сирену на авто'))
                        end
                        if cfg.main.group == 'Мэрия' then
                            if imadd.HotKey('##hik', config_keys.hikey, tLastKeys, 100) then 
                                rkeys.changeHotKey(hibind, config_keys.hikey.v) 
                                ftext('Клавиша успешно изменена. Старое значение: '.. table.concat(rkeys.getKeysName(tLastKeys.v), " + ") .. ' | Новое значение: '.. table.concat(rkeys.getKeysName(config_keys.hikey.v), " + "))
                                saveData(config_keys, 'moonloader/config/fbitools/keys.json')
                            end imgui.SameLine() imgui.Text(u8 'Приветствие')
                            if imadd.HotKey('##sumk', config_keys.summakey, tLastKeys, 100) then 
                                rkeys.changeHotKey(summabind, config_keys.summakey.v) 
                                ftext('Клавиша успешно изменена. Старое значение: '.. table.concat(rkeys.getKeysName(tLastKeys.v), " + ") .. ' | Новое значение: '.. table.concat(rkeys.getKeysName(config_keys.summakey.v), " + "))
                                saveData(config_keys, 'moonloader/config/fbitools/keys.json')
                            end imgui.SameLine() imgui.Text(u8 'Огласить сумму')
                            if imadd.HotKey('##freenk', config_keys.freenalkey, tLastKeys, 100) then 
                                rkeys.changeHotKey(freenalbind, config_keys.freenalkey.v) 
                                ftext('Клавиша успешно изменена. Старое значение: '.. table.concat(rkeys.getKeysName(tLastKeys.v), " + ") .. ' | Новое значение: '.. table.concat(rkeys.getKeysName(config_keys.freenalkey.v), " + "))
                                saveData(config_keys, 'moonloader/config/fbitools/keys.json')
                            end imgui.SameLine() imgui.Text(u8 'Выпустить наличными')
                            if imadd.HotKey('##freebk', config_keys.freebankkey, tLastKeys, 100) then 
                                rkeys.changeHotKey(freebankbind, config_keys.freebankkey.v) 
                                ftext('Клавиша успешно изменена. Старое значение: '.. table.concat(rkeys.getKeysName(tLastKeys.v), " + ") .. ' | Новое значение: '.. table.concat(rkeys.getKeysName(config_keys.freebankkey.v), " + "))
                                saveData(config_keys, 'moonloader/config/fbitools/keys.json')
                            end imgui.SameLine() imgui.Text(u8 'Выпустить через банк')
                        end
                    elseif show == 4 then
                        if imadd.ToggleButton(u8 'Автобп', autobpb) then cfg.main.autobp = autobpb.v end saveData(cfg, 'moonloader/config/fbitools/config.json'); imgui.SameLine(); imgui.Text(u8 'Автоматически брать боеприпасы')
                        if imgui.Checkbox(u8 "Desert Eagle", deagleb) then cfg.autobp.deagle = deagleb.v saveData(cfg, 'moonloader/config/fbitools/config.json') end
                        if deagleb.v then
                            imgui.SameLine(110)
                            if imgui.Checkbox(u8 'Два компекта##1', dvadeagleb) then cfg.autobp.dvadeagle = dvadeagleb.v saveData(cfg, 'moonloader/config/fbitools/config.json') end
                        end
                        if imgui.Checkbox(u8 "Shotgun", shotb) then cfg.autobp.shot = shotb.v saveData(cfg, 'moonloader/config/fbitools/config.json') end
                        if shotb.v then
                            imgui.SameLine(110)
                            if imgui.Checkbox(u8 'Два компекта##2', dvashotb) then cfg.autobp.dvashot = dvashotb.v saveData(cfg, 'moonloader/config/fbitools/config.json') end
                        end
                        if imgui.Checkbox(u8 "SMG", smgb) then cfg.autobp.smg = smgb.v saveData(cfg, 'moonloader/config/fbitools/config.json') end
                        if smgb.v then
                            imgui.SameLine(110)
                            if imgui.Checkbox(u8 'Два компекта##3', dvasmgb) then cfg.autobp.dvasmg = dvasmgb.v saveData(cfg, 'moonloader/config/fbitools/config.json') end
                        end
                        if imgui.Checkbox(u8 "M4A1", m4b) then cfg.autobp.m4 = m4b.v saveData(cfg, 'moonloader/config/fbitools/config.json') end
                        if m4b.v then
                            imgui.SameLine(110)
                            if imgui.Checkbox(u8 'Два компекта##4', dvam4b) then cfg.autobp.dvam4 = dvam4b.v saveData(cfg, 'moonloader/config/fbitools/config.json') end
                        end
                        if imgui.Checkbox(u8 "Rifle", rifleb) then cfg.autobp.rifle = rifleb.v saveData(cfg, 'moonloader/config/fbitools/config.json') end
                        if rifleb.v then
                            imgui.SameLine(110)
                            if imgui.Checkbox(u8 'Два компекта##5', dvarifleb) then cfg.autobp.dvarifle = dvarifleb.v saveData(cfg, 'moonloader/config/fbitools/config.json') end
                        end
                        if imgui.Checkbox(u8 "Броня", armourb) then cfg.autobp.armour = armourb.v saveData(cfg, 'moonloader/config/fbitools/config.json') end 
                        if imgui.Checkbox(u8 "Спец. оружие", specb)then cfg.autobp.spec = specb.v saveData(cfg, 'moonloader/config/fbitools/config.json') end
                    end
                    imgui.EndChild()
                else
                    imgui.SetCursorPosX( imgui.GetWindowWidth()/2 - imgui.CalcTextSize(u8 "Выберите вашу группу фракций").x/2 - 50 )
                    imgui.SetCursorPosY( imgui.GetWindowHeight()/2 )
                    imgui.PushItemWidth(100)
                    imgui.Combo(u8 'Выберите вашу группу фракций', groupInt, groupNames)
                    imgui.SetCursorPosX( imgui.GetWindowWidth()/2 - 50 )
                    if imgui.Button(u8 'Подтвердить') then
                        ftext(("Вы выбрали группу: {9966CC}%s"):format(u8:decode(groupNames[groupInt.v + 1])))
                        cfg.main.group = u8:decode(groupNames[groupInt.v + 1])
                        saveData(cfg, 'moonloader/config/fbitools/config.json')
                        registerCommands()
                    end
                end
                imgui.End()
            end
        end
        if shpwindow.v then
            imgui.ShowCursor = true
            local iScreenWidth, iScreenHeight = getScreenResolution()
            imgui.SetNextWindowPos(imgui.ImVec2(iScreenWidth / 2, iScreenHeight / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
            imgui.SetNextWindowSize(imgui.ImVec2(iScreenWidth/2, iScreenHeight / 2), imgui.Cond.FirstUseEver)
            imgui.Begin(u8(script.this.name..' | Шпора'), shpwindow)
            for line in io.lines('moonloader\\fbitools\\shp.txt') do
                imgui.TextWrapped(u8(line))
            end
            imgui.End()
        end
        if akwindow.v then
            imgui.ShowCursor = true
            local iScreenWidth, iScreenHeight = getScreenResolution()
            imgui.SetNextWindowPos(imgui.ImVec2(iScreenWidth / 2, iScreenHeight / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
            imgui.SetNextWindowSize(imgui.ImVec2(iScreenWidth/2, iScreenHeight / 2), imgui.Cond.FirstUseEver)
            imgui.Begin(u8(script.this.name..' | Административный кодекс'), akwindow)
            for line in io.lines('moonloader\\fbitools\\ak.txt') do
                imgui.TextWrapped(u8(line))
            end
            imgui.End()
        end
        if fpwindow.v then
            imgui.ShowCursor = true
            local iScreenWidth, iScreenHeight = getScreenResolution()
            imgui.SetNextWindowPos(imgui.ImVec2(iScreenWidth / 2, iScreenHeight / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
            imgui.SetNextWindowSize(imgui.ImVec2(iScreenWidth/2, iScreenHeight / 2), imgui.Cond.FirstUseEver)
            imgui.Begin(u8(script.this.name..' | Федеральное постановление'), fpwindow)
            for line in io.lines('moonloader\\fbitools\\fp.txt') do
                imgui.TextWrapped(u8(line))
            end
            imgui.End()
        end
        if ykwindow.v then
            imgui.ShowCursor = true
            local iScreenWidth, iScreenHeight = getScreenResolution()
            imgui.SetNextWindowPos(imgui.ImVec2(iScreenWidth / 2, iScreenHeight / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
            imgui.SetNextWindowSize(imgui.ImVec2(iScreenWidth/2, iScreenHeight / 2), imgui.Cond.FirstUseEver)
            imgui.Begin(u8(script.this.name..' | Уголовный кодекс'), ykwindow)
            for line in io.lines('moonloader\\fbitools\\yk.txt') do
                imgui.TextWrapped(u8(line))
            end
            imgui.End()
        end
        if memw.v then
            imgui.ShowCursor = true
            local sw, sh = getScreenResolution()
            --imgui.SetWindowPos('##' .. thisScript().name, imgui.ImVec2(sw/2 - imgui.GetWindowSize().x/2, sh/2 - imgui.GetWindowSize().y/2))
            --imgui.SetWindowSize('##' .. thisScript().name, imgui.ImVec2(670, 500))
            imgui.SetNextWindowPos(imgui.ImVec2(sw / 2, sh / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
            imgui.SetNextWindowSize(imgui.ImVec2(670, 330), imgui.Cond.FirstUseEver)
            imgui.Begin(u8(script.this.name..' | Список сотрудников [Всего: %s]'):format(#tMembers), memw, imgui.WindowFlags.NoResize)
            imgui.BeginChild('##1', imgui.ImVec2(670, 300))
            imgui.Columns(5, _)
            imgui.SetColumnWidth(-1, 180) imgui.Text(u8 'Ник игрока'); imgui.NextColumn()
            imgui.SetColumnWidth(-1, 190) imgui.Text(u8 'Должность');  imgui.NextColumn()
            imgui.SetColumnWidth(-1, 80) imgui.Text(u8 'Статус') imgui.NextColumn()
            imgui.SetColumnWidth(-1, 120) imgui.Text(u8 'Дата приема') imgui.NextColumn() 
            imgui.SetColumnWidth(-1, 70) imgui.Text(u8 'AFK') imgui.NextColumn() 
            imgui.Separator()
            for _, v in ipairs(tMembers) do
                imgui.TextColored(imgui.ImVec4(getColor(v.id)), u8('%s [%s]'):format(v.nickname, v.id))
                if imgui.IsItemHovered() then
                    imgui.BeginTooltip();
                    imgui.PushTextWrapPos(450.0);
                    imgui.TextColored(imgui.ImVec4(getColor(v.id)), u8("%s\nУровень: %s"):format(v.nickname, sampGetPlayerScore(v.id)))
                    imgui.PopTextWrapPos();
                    imgui.EndTooltip();
                end
                imgui.NextColumn()
                imgui.Text(('%s [%s]'):format(v.sRang, v.iRang))
                imgui.NextColumn()
                if v.status ~= u8("На работе") then
                    imgui.TextColored(imgui.ImVec4(0.80, 0.00, 0.00, 1.00), v.status);
                else
                    imgui.TextColored(imgui.ImVec4(0.00, 0.80, 0.00, 1.00), v.status);
                end
                imgui.NextColumn()
                imgui.Text(v.invite)
                imgui.NextColumn()
                if v.sec ~= 0 then
                    if v.sec < 360 then 
                        imgui.TextColored(getColorForSeconds(v.sec), tostring(v.sec .. u8(' сек.')));
                    else
                        imgui.TextColored(getColorForSeconds(v.sec), tostring("360+" .. u8(' сек.')));
                    end
                else
                    imgui.TextColored(imgui.ImVec4(0.00, 0.80, 0.00, 1.00), u8("Нет"));
                end
                imgui.NextColumn()
            end
            imgui.Columns(1)
            imgui.EndChild()
            imgui.End()
        end
    end
end

if lsampev then
    function sp.onPlayerQuit(id, reason)
        if gmegafhandle ~= -1 and id == gmegafid then
            sampAddChatMessage(' {ffffff}~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~', 0x9966cc)
            sampAddChatMessage('', 0x9966cc)
            sampAddChatMessage(' {ffffff}Игрок: {9966cc}'..sampGetPlayerNickname(gmegafid)..'['..gmegafid..'] {ffffff}вышел из игры', 0x9966cc)
            sampAddChatMessage(' {ffffff}Уровень: {9966cc}'..gmegaflvl, 0x9966cc)
            sampAddChatMessage(' {ffffff}Фракция: {9966cc}'..gmegaffrak, 0x9966cc)
            sampAddChatMessage(' {ffffff}Причина выхода: {9966cc}'..quitReason[reason], 0x9966CC)
            sampAddChatMessage('', 0x9966cc)
            sampAddChatMessage(' {ffffff}~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~', 0x9966cc)
            gmegafid = -1
            gmegaflvl = nil
            gmegaffrak = nil
            gmegafhandle = nil
        end
    end

    function sp.onSendSpawn()
        if cfg.main.clistb and rabden then
            lua_thread.create(function()
                wait(1400)
                ftext('Цвет ника сменен на: {9966cc}' .. cfg.main.clist)
                sampSendChat('/clist '..cfg.main.clist)
            end)
        end
    end

    function sp.onServerMessage(color, text)
        if text:find("У данного игрока уже есть") and ins.isLicense then
            ins.isLicense = false
            ins.list = nil
        end
        if text:match(" ^Вы начали преследование за преступником %S!$") then
            local nick = text:match(" ^Вы начали преследование за преступником (%S)!$")
            local id = sampGetPlayerIdByNickname(nick)
            gmegafid = id
            gmegaflvl = sampGetPlayerScore(id)
            gmegaffrak = sampGetFraktionBySkin(id)
        end
        if nazhaloop then
            if text:match('Посылать сообщение в /d можно раз в 10 секунд!') then
                zaproop = true
                ftext('Не удалось подать в ООП игрока {9966cc}'..nikk..'{ffffff}. Повторить попытку?')
                ftext('Подтвердить: {9966cc}'..table.concat(rkeys.getKeysName(config_keys.oopda.v), " + ")..'{ffffff} | Отменить: {9966cc}'..table.concat(rkeys.getKeysName(config_keys.oopnet.v), " + "))
            end
            if nikk == nil then
                dmoop = false
                nikk = nil
                zaproop = false
                aroop = false
                nazhaloop = false
            end
            if color == -8224086 and text:find(nikk) then
                dmoop = false
                nikk = nil
                zaproop = false
                aroop = false
                nazhaloop = false
            end
        end
        if (text:match('дело на имя .+ рассмотрению не подлежит, ООП') or text:match('дело .+ рассмотрению не подлежит %- ООП.')) and color == -8224086 then
            local ooptext = text:match('Mayor, (.+)')
            table.insert(ooplistt, ooptext)
        end
        if text:find('{00AB06}Чтобы завести двигатель, нажмите клавишу {FFFFFF}"2"{00AB06} или введите команду {FFFFFF}"/en"') then
            if cfg.main.autocar then
                lua_thread.create(function()
                    while not isCharInAnyCar(PLAYER_PED) do wait(0) end
                    if not isCarEngineOn(storeCarCharIsInNoSave(PLAYER_PED)) then
                        while sampIsChatInputActive() or sampIsDialogActive() or isSampfuncsConsoleActive() do wait(0) end
                        setVirtualKeyDown(key.VK_2, true)
                        wait(150)
                        setVirtualKeyDown(key.VK_2, false)
                    end
                end)
            end
        end
        if color == -8224086 then
            local colors = ("{%06X}"):format(bit.rshift(color, 8))
            table.insert(departament, os.date(colors.."[%H:%M:%S] ") .. text)
        end
        if color == -1920073984 and (text:match('.+ .+%: .+') or text:match('%(%( .+ .+%: .+ %)%)')) then
            local colors = ("{%06X}"):format(bit.rshift(color, 8))
            table.insert(radio, os.date(colors.."[%H:%M:%S] ") .. text)
        end
        if color == -3669760 and text:match('%[Wanted %d+: .+%] %[Сообщает%: .+%] %[.+%]') then
            local colors = ("{%06X}"):format(bit.rshift(color, 8))
            table.insert(wanted, os.date(colors.."[%H:%M:%S] ") .. text)
        end
        if color == -65366 and (text:match('SMS%: .+. Отправитель%: .+') or text:match('SMS%: .+. Получатель%: .+')) then
            if text:match('SMS%: .+. Отправитель%: .+%[%d+%]') then smsid = text:match('SMS%: .+. Отправитель%: .+%[(%d+)%]') elseif text:match('SMS%: .+. Получатель%: .+%[%d+%]') then smstoid = text:match('SMS%: .+. Получатель%: .+%[(%d+)%]') end
            local colors = ("{%06X}"):format(bit.rshift(color, 8))
            table.insert(sms, os.date(colors.."[%H:%M:%S] ") .. text)
        end
        if mcheckb then
            if text:find('---======== МОБИЛЬНЫЙ КОМПЬЮТЕР ДАННЫХ ========---') then
                local open = io.open("moonloader/fbitools/mcheck.txt", 'a')
                open:write(string.format('%s\n', text))
                open:close()
            end
            if text:find('Имя:') then
                local open = io.open("moonloader/fbitools/mcheck.txt", 'a')
                open:write(string.format('%s\n', text))
                open:close()
            end
            if text:find('Организация:') then
                local open = io.open("moonloader/fbitools/mcheck.txt", 'a')
                open:write(string.format('%s\n', text))
                open:close()
            end
            if text:find('Преступление:') then
                local open = io.open("moonloader/fbitools/mcheck.txt", 'a')
                open:write(string.format('%s\n', text))
                open:close()
            end
            if text:find('Сообщил:') then
                local open = io.open("moonloader/fbitools/mcheck.txt", 'a')
                open:write(string.format('%s\n', text))
                open:close()
            end
            if text:find('Уровень розыска:') then
                local open = io.open("moonloader/fbitools/mcheck.txt", 'a')
                open:write(string.format('%s\n', text))
                open:close()
            end
            if text:find('---============================================---') then
                local open = io.open("moonloader/fbitools/mcheck.txt", 'a')
                open:write(string.format('%s\n', text))
                open:write(' \n')
                open:close()
            end
        end
        if text:find('Вы посадили в тюрьму') then
            local nik, sek = text:match('Вы посадили в тюрьму (%S+) на (%d+) секунд')
            if sek == '3600' or sek == '3000'  then
                lua_thread.create(function()
                    nikk = nik:gsub('_', ' ')
                    aroop = true
                    wait(3000)
                    ftext(string.format("Запретить рассмотр дела на имя {9966cc}%s", nikk), -1)
                    ftext('Подтвердить: {9966cc}'..table.concat(rkeys.getKeysName(config_keys.oopda.v), " + ")..'{ffffff} | Отменить: {9966cc}'..table.concat(rkeys.getKeysName(config_keys.oopnet.v), " + "), -1)
                end)
            end
        end
        if text:find('Вы посадили преступника на') then
            local sekk = text:match('Вы посадили преступника на (.+) секунд!')
            if sekk == '3000' or sekk == '3600' then
                lua_thread.create(function()
                    nikk = sampGetPlayerNickname(tdmg)
                    dmoop = true
                    wait(50)
                    ftext(string.format("Запретить рассмотр дела на имя {9966cc}%s", nikk:gsub('_', ' ')), -1)
                    ftext('Подтвердить: {9966cc}'..table.concat(rkeys.getKeysName(config_keys.oopda.v), " + ")..'{ffffff} | Отменить: {9966cc}'..table.concat(rkeys.getKeysName(config_keys.oopnet.v), " + "), -1)
                end)
            end
        end
        if status then
            if text:find("ID: %d+ | .+ | %g+: .+%[%d+%] %- %{......%}.+%{......%}") then
                if not text:find("AFK") then
                    local id, invDate, nickname, sRang, iRang, status = text:match("ID: (%d+) | (.+) | (%g+): (.+)%[(%d+)%] %- %{.+%}(.+)%{.+%}")
                    table.insert(tMembers, Player:new(id, sRang, iRang, status, invDate, false, 0, nickname))
                else
                    local id, invDate, nickname, sRang, iRang, status, sec = text:match("ID: (%d+) | (.+) | (%g+): (.+)%[(%d+)%] %- %{.+%}(.+)%{.+%} | %{.+%}%[AFK%]: (%d+).+")
                    table.insert(tMembers, Player:new(id, sRang, iRang, status, invDate, true, sec, nickname))
                end
                return false
            end
            if text:find("ID: %d+ | .+ | %g+: .+%[%d+%]") then
                if not text:find("AFK") then
                    local id, invDate, nickname, sRang, iRang = text:match("ID: (%d+) | (.+) | (%g+): (.+)%[(%d+)%]")
                    table.insert(tMembers, Player:new(id, sRang, iRang, "Недоступно", invDate, false, 0, nickname))
                else
                    local id, invDate, nickname, sRang, iRang, sec = text:match("ID: (%d+) | (.+) | (%g+): (.+)%[(%d+)%] | %{.+%}%[AFK%]: (%d+).+")
                    table.insert(tMembers, Player:new(id, sRang, iRang, "Недоступно", invDate, true, sec, nickname))
                end
                return false
            end
            if text:match('Всего: %d+ человек') then
                gotovo = true
                return false
            end
            if color == -1 then
                return false
            end
            if color == 647175338 then
                return false
            end
        end
        if fnrstatus then
            if text:match("^ ID: %d+") then 
                if text:find("Выходной") then
                    table.insert(vixodid, tonumber(text:match("ID: (%d+)")))
                end
                return false
            end
            if text:match('Всего: %d+ человек') then
                gotovo = true
                return false
            end
            if color == -1 then
                return false
            end
            if color == 647175338 then
                return false
            end
        end
        if warnst then
            if text:find('Организация:') then
                local wcfrac = text:match('Организация: (.+)')
                wfrac = wcfrac
                if wcfrac == 'Армия СФ' or wcfrac == 'Армия ЛВ' or wcfrac == 'ФБР' then
                    wfrac = longtoshort(wcfrac)
                end
            end
        end
        if text:find('Рабочий день начат') and color ~= -1 then
            if cfg.main.clistb then
                lua_thread.create(function()
                    wait(100)
                    ftext('Цвет ника сменен на: {9966cc}'..cfg.main.clist)
                    sampSendChat('/clist '..tonumber(cfg.main.clist))
                    rabden = true
                end)
            end
        end
        if text:find('Рабочий день окончен') and color ~= -1 then
            rabden = false
        end
        if text:find('Вы поменяли пули на резиновые') then
            stazer = true
        end
        if text:find('Вы поменяли пули на обычные') then
            stazer = false
        end
        if cfg.main.nclear then
            if text:find('удалил из розыскиваемых') then
                local chist, jertva = text:match('%[Clear%] (.+) удалил из розыскиваемых (.+)')
                printStringNow(chist..' cleared '..jertva..' from BD', 3000)
            end
        end
        if text:find('Wanted') and text:find('Сообщает') then
            local id, prestp, police, prichin = text:match('%[Wanted (%d+): (.+)%] %[Сообщает: (.+)%] %[(.+)%]')
            if not cfg.main.offwntd then
                if cfg.main.nwanted then
                    return {0x9966CCFF, ' [{ffffff}Wanted '..id..': '..prestp..'{9966cc}] [{ffffff}Сообщает: '..police..'{9966cc}] [{ffffff}'..prichin..'{9966cc}]'}
                end
            else
                local mynick = sampGetPlayerNickname(select(2, sampGetPlayerIdByCharHandle(PLAYER_PED)))
                if police ~= mynick then
                    return false
                else
                    if cfg.main.nwanted then
                        return {0x9966CCFF, ' [{ffffff}Wanted '..id..': '..prestp..'{9966cc}] [{ffffff}Сообщает: '..police..'{9966cc}] [{ffffff}'..prichin..'{9966cc}]'}
                    end
                end
            end
        end
        if text:find('начал преследование за преступником') then
            local polic, prest, yrvn = text:match('Полицейский (.+) начал преследование за преступником (.+) %(Уровень розыска: (.+)%)')
            if not cfg.main.offptrl then
                if cfg.main.nwanted then
                    return {0xFFFFFFFF, ' Полицейский {9966cc}'..polic..' {ffffff}начал преследование за {9966cc}'..prest..' {ffffff}(Уровень розыска: {9966cc}'..yrvn..'{ffffff})'}
                end
            else
                local mynick = sampGetPlayerNickname(select(2, sampGetPlayerIdByCharHandle(PLAYER_PED)))
                if polic ~= mynick then
                    return false
                else
                    if cfg.main.nwanted then
                        return {0xFFFFFFFF, ' Полицейский {9966cc}'..polic..' {ffffff}начал преследование за {9966cc}'..prest..' {ffffff}(Уровень розыска: {9966cc}'..yrvn..'{ffffff})'}
                    end
                end
            end
        end
        if cfg.main.nwanted then
            if text:find('удалил из розыскиваемых') then
                local chist, jertva = text:match('%[Clear%] (.+) удалил из розыскиваемых (.+)')
                return {0x9966CCFF, ' [{ffffff}Clear{9966cc}] '..chist..'{ffffff} удалил из розыскиваемых {9966cc}'..jertva}
            end
            if text:find('<<') and text:find('Офицер') and text:find('арестовал') and text:find('>>') then
                local arr, arre = text:match('<< Офицер (.+) арестовал (.+) >>')
                return {0xFFFFFFFF, ' « Офицер {9966CC}'..arr..' {ffffff}арестовал {9966cc}'..arre..' {ffffff}»'}
            end
            if text:find('<<') and text:find('Агент FBI') and text:find('арестовал') and text:find('>>') then
                local arrr, arrre = text:match('<< Агент FBI (.+) арестовал (.+) >>')
                return {0xFFFFFFFF, ' « Агент FBI {9966CC}'..arrr..' {ffffff}арестовал {9966cc}'..arrre..' {ffffff}»'}
            end
            if text:find('Вы посадили преступника на') then
                local sekund = text:match('Вы посадили преступника на (%d+) секунд!')
                return {0xFFFFFFFF, ' Вы посадили преступника на {9966cc}'..sekund..' {ffffff}секунд!'}
            end
        end
    end

    function sp.onShowDialog(id, style, title, button1, button2, text)
        if id == 7777 and ins.isLicense then
            sampSendDialogResponse(id, 1, ins.list, _)
            ins.isLicense = false
            ins.list = nil
            return false
        end
        if id == 50 and msda then
            sampSendDialogResponse(id, 1, getMaskList(msvidat), _)
            msid = nil
            msda = false
            msvidat = nil
            return false
        end
        if id == 1 and cfg.main.parolb and #tostring(cfg.main.parol) >= 6 then
            sampSendDialogResponse(id, 1, _, tostring(cfg.main.parol))
            return false
        end
        if id == 16 and cfg.main.googlecodeb and #tostring(cfg.main.googlecode) == 16 then
            if lsha1 and lbasexx then
                sampSendDialogResponse(id, 1, _, genCode(tostring(cfg.main.googlecode)))
                return false
            end
        end
        if id == 0 and checkstat then
            frak = text:match('.+Организация%:%s+(.+)%s+Ранг')
            rang = text:match('.+Ранг%:%s+(.+)%s+Работа')
            print(frak)
            print(rang)
            checkstat = false
            sampSendDialogResponse(id, 1, _, _)
            return false
        end
        if cfg.main.autobp == true and id == 5225 then
            --[[lua_thread.create(function()
                wait(250)
                if autoBP == 6 and repeatgun then
                    autoBP = 0
                    sampCloseCurrentDialogWithButton(0)
                    repeatgun = false
                    return
                elseif autoBP == 6 and not repeatgun then
                    autoBP = 0
                    repeatgun = true
                    return
                end
                sampSendDialogResponse(5225, 1, autoBP, "")
                autoBP = autoBP + 1
                if autoBP == 2 then autoBP = 3 end
                return
            end)]]
            local guns = getCompl()
            lua_thread.create(function()
                wait(250)
                if autoBP == #guns + 1 then
                    autoBP = 1
                    sampCloseCurrentDialogWithButton(0)
                    return
                end
                sampSendDialogResponse(5225, 1, guns[autoBP], "")
                autoBP = autoBP + 1
                return
            end)
        end
    end

    function sp.onSendGiveDamage(playerId, damage, weapon, bodypart)
        tdmg = playerId
    end
end
if lrkeys then
    function rkeys.onHotKey(id, keys)
        if sampIsChatInputActive() or sampIsDialogActive() or isSampfuncsConsoleActive() then
            return false
        end
    end
end

if lsphere then
function Sphere.onEnterSphere(id)
        post = id
    end

    function Sphere.onExitSphere(id)
        post = nil
    end
end

function registerCommands()
    if sampIsChatCommandDefined('yk') then sampUnregisterChatCommand('yk') end
    if sampIsChatCommandDefined('fp') then sampUnregisterChatCommand('fp') end
    if sampIsChatCommandDefined('ak') then sampUnregisterChatCommand('ak') end
    if sampIsChatCommandDefined('shp') then sampUnregisterChatCommand('shp') end
    if sampIsChatCommandDefined('ft') then sampUnregisterChatCommand('ft') end
    if sampIsChatCommandDefined('fnr') then sampUnregisterChatCommand('fnr') end
    if sampIsChatCommandDefined('fkv') then sampUnregisterChatCommand('fkv') end
    if sampIsChatCommandDefined('ooplist') then sampUnregisterChatCommand('ooplist') end
    if sampIsChatCommandDefined('ticket') then sampUnregisterChatCommand('ticket') end
    if sampIsChatCommandDefined('dlog') then sampUnregisterChatCommand('dlog') end
    if sampIsChatCommandDefined('rlog') then sampUnregisterChatCommand('rlog') end
    if sampIsChatCommandDefined('sulog') then sampUnregisterChatCommand('sulog') end
    if sampIsChatCommandDefined('smslog') then sampUnregisterChatCommand('smslog') end
    if sampIsChatCommandDefined('ftazer') then sampUnregisterChatCommand('ftazer') end
    if sampIsChatCommandDefined('kmdc') then sampUnregisterChatCommand('kmdc') end
    if sampIsChatCommandDefined('su') then sampUnregisterChatCommand('ssu') end
    if sampIsChatCommandDefined('megaf') then sampUnregisterChatCommand('megaf') end
    if sampIsChatCommandDefined('tazer') then sampUnregisterChatCommand('tazer') end
    if sampIsChatCommandDefined('keys') then sampUnregisterChatCommand('keys') end
    if sampIsChatCommandDefined('oop') then sampUnregisterChatCommand('oop') end
    if sampIsChatCommandDefined('cput') then sampUnregisterChatCommand('cput') end
    if sampIsChatCommandDefined('ceject') then sampUnregisterChatCommand('ceject') end
    if sampIsChatCommandDefined('st') then sampUnregisterChatCommand('st') end
    if sampIsChatCommandDefined('deject') then sampUnregisterChatCommand('deject') end
    if sampIsChatCommandDefined('rh') then sampUnregisterChatCommand('rh') end
    if sampIsChatCommandDefined('ak') then sampUnregisterChatCommand('ak') end
    if sampIsChatCommandDefined('gr') then sampUnregisterChatCommand('gr') end
    if sampIsChatCommandDefined('warn') then sampUnregisterChatCommand('warn') end
    if sampIsChatCommandDefined('ms') then sampUnregisterChatCommand('ms') end
    if sampIsChatCommandDefined('ar') then sampUnregisterChatCommand('ar') end
    if sampIsChatCommandDefined('r') then sampUnregisterChatCommand('r') end
    if sampIsChatCommandDefined('f') then sampUnregisterChatCommand('f') end
    if sampIsChatCommandDefined('rt') then sampUnregisterChatCommand('rt') end
    if sampIsChatCommandDefined('fst') then sampUnregisterChatCommand('fst') end
    if sampIsChatCommandDefined('fsw') then sampUnregisterChatCommand('fsw') end
    if sampIsChatCommandDefined('fshp') then sampUnregisterChatCommand('fshp') end
    if sampIsChatCommandDefined('fyk') then sampUnregisterChatCommand('fyk') end
    if sampIsChatCommandDefined('ffp') then sampUnregisterChatCommand('ffp') end
    if sampIsChatCommandDefined('fak') then sampUnregisterChatCommand('fak') end
    if sampIsChatCommandDefined('dmb') then sampUnregisterChatCommand('dmb') end
    if sampIsChatCommandDefined('dkld') then sampUnregisterChatCommand('dkld') end
    if sampIsChatCommandDefined('fvz') then sampUnregisterChatCommand('fvz') end
    if sampIsChatCommandDefined('fbd') then sampUnregisterChatCommand('fbd') end
    if sampIsChatCommandDefined('blg') then sampUnregisterChatCommand('blg') end
    if sampIsChatCommandDefined('cc') then sampUnregisterChatCommand('cc') end
    if sampIsChatCommandDefined('df') then sampUnregisterChatCommand('df') end
    if sampIsChatCommandDefined('mcheck') then sampUnregisterChatCommand('mcheck') end
    if sampIsChatCommandDefined('z') then sampUnregisterChatCommand('z') end
    if sampIsChatCommandDefined('pr') then sampUnregisterChatCommand('pr') end
    if isSampfuncsConsoleCommandDefined('gppc') then sampfuncsUnregisterConsoleCommand('gppc') end
    if cfg.main.group == 'ПД/ФБР' then
        sampRegisterChatCommand('fkv', fkv)
        sampRegisterChatCommand('ticket', ticket)
        sampRegisterChatCommand('sulog', sulog)
        sampRegisterChatCommand('ftazer', ftazer)
        sampRegisterChatCommand('kmdc', kmdc)
        sampRegisterChatCommand('su', su)
        sampRegisterChatCommand('ssu', ssu)
        sampRegisterChatCommand('megaf', megaf)
        sampRegisterChatCommand('tazer', tazer)
        sampRegisterChatCommand('oop', oop)
        sampRegisterChatCommand('keys', keys)
        sampRegisterChatCommand('cput', cput)
        sampRegisterChatCommand('ceject', ceject)
        sampRegisterChatCommand('st', st)
        sampRegisterChatCommand('deject', deject)
        sampRegisterChatCommand('rh', rh)
        sampRegisterChatCommand('gr', gr)
        sampRegisterChatCommand('warn', warn)
        sampRegisterChatCommand('ms', ms)
        sampRegisterChatCommand('ar', ar)
        sampRegisterChatCommand('fshp', fshp)
        sampRegisterChatCommand('fyk', fyk)
        sampRegisterChatCommand('ffp', ffp)
        sampRegisterChatCommand('fak', fak)
        sampRegisterChatCommand('dkld', dkld)
        sampRegisterChatCommand('fvz', fvz)
        sampRegisterChatCommand('fbd', fbd)
        sampRegisterChatCommand('df', df)
        sampRegisterChatCommand('mcheck', mcheck)
        sampRegisterChatCommand('z', ssuz)
        sampRegisterChatCommand("pr", pr)
    end
    if cfg.main.group == 'ПД/ФБР' or cfg.main.group == 'Мэрия' then sampRegisterChatCommand('ooplist', ooplist) end
    sampRegisterChatCommand('fnr', fnr)
    sampRegisterChatCommand('yk', function() ykwindow.v = not ykwindow.v end)
    sampRegisterChatCommand('fp', function() fpwindow.v = not fpwindow.v end)
    sampRegisterChatCommand('ak', function() akwindow.v = not akwindow.v end)
    sampRegisterChatCommand('shp',function() shpwindow.v = not shpwindow.v end)
    sampRegisterChatCommand('ft', function() mainw.v = not mainw.v end)
    sampRegisterChatCommand('dlog', dlog)
    sampRegisterChatCommand('rlog', rlog)
    sampRegisterChatCommand('smslog', smslog)
    sampRegisterChatCommand('r', r)
    sampRegisterChatCommand('f', f)
    sampRegisterChatCommand('rt', rt)
    sampRegisterChatCommand("fst", fst)
    sampRegisterChatCommand("fsw", fsw)
    sampRegisterChatCommand('dmb', dmb)
    sampRegisterChatCommand('blg', blg)
    sampRegisterChatCommand('cc', cc)
    sampfuncsRegisterConsoleCommand('gppc', function()
        local mxx, myy, mzz = getCharCoordinates(PLAYER_PED)
        print(string.format('%s, %s, %s', mxx, myy, mzz))
    end)
end

function registerSphere()
    Sphere.createSphere(-1984.6375732422, 106.85540008545, 27.42943572998, 50.0)-- -1984.6375732422 106.85540008545 27.42943572998 -- АВСФ [1]
    Sphere.createSphere(-2055.283203125, -84.472702026367, 35.064281463623, 50.0)-- -2055.283203125 -84.472702026367 35.064281463623 -- АШ [2]
    Sphere.createSphere(-1521.4412841797, 503.20678710938, 6.7215604782104, 40.0)-- -1521.4412841797 503.20678710938 6.7215604782104 -- СФа [3]
    Sphere.createSphere(-1702.3824462891, 684.79150390625, 25.01790618896, 30.0)-- -1702.3824462891 684.79150390625 25.017906188965 -- Пост В СФПД [4]
    Sphere.createSphere(-1574.4406738281, 662.24047851563, 7.3254537582397, 20.0)-- -1574.4406738281 662.24047851563 7.3254537582397 Пост А СФПД [5]
    Sphere.createSphere(-2013.1629638672, 464.77380371094, 35.313331604004, 30.0)-- -2013.1629638672 464.77380371094 35.313331604004 -- СФн [6]
    Sphere.createSphere(-1749.7822265625, -591.34033203125, 16.62273979187, 100.0)-- -1749.7822265625 -591.34033203125 16.62273979187 -- Тоннель [7]
    Sphere.createSphere(1481.77734375, -1739.9536132813, 13.546875, 70.0)-- 1481.77734375 -1739.9536132813 13.546875 -- Мэрия [8]
    Sphere.createSphere(-2448.3591308594, 725.09326171875, 34.756977081299, 70.0)-- -2448.3591308594 725.09326171875 34.756977081299 -- Хот-Доги [9]
    Sphere.createSphere(1186.5642089844, -1322.2257080078,13.098788261414, 50.0)-- 1186.5642089844 -1322.2257080078 13.098788261414 -- Больница ЛС [10]
    Sphere.createSphere(1195.8181152344, -1741.1024169922, 13.131011962891, 70.0)-- 1195.8181152344 -1741.1024169922 13.131011962891 -- АВ ЛС [11]
    Sphere.createSphere(1667.1462402344, -768.31890869141, 54.092594146729, 70.0)-- 1667.1462402344 -768.31890869141 54.092594146729 -- Мост ЛС-ЛВ [12]
    Sphere.createSphere(1766.12109375,   874.89379882813,   10.887091636658, 70.0)-- 1820.5036621094 816.41632080078 10.8203125 -- Перекросток LVPD [13]
    Sphere.createSphere(1155.6971435547, 831.9443359375, 10.409364700317, 80.0)-- 1155.6971435547 831.9443359375 10.409364700317 Развилка LVPD [14]
    Sphere.createSphere(2033.3028564453, 1007.163269043, 10.8203125, 50.0)-- 2033.3028564453 1007.163269043 10.8203125 Постовой В LVPD [4 Дракона] [15]
    Sphere.createSphere(2824.7353515625, 1292.9085693359, 10.764576911926, 50.0)-- 2824.7353515625 1292.9085693359 10.764576911926 Постовой А LVPD [АВЛВ] [16]
    Sphere.createSphere(2180.99609375, 1676.2248535156, 11.060985565186, 50.0)-- 2180.99609375 1676.2248535156 11.060985565186 Постовой В LVPD [Каллигула] [17]
    Sphere.createSphere(1727.3302001953, 1618.9171142578, 9.8169927597046, 50.0)-- 1727.3302001953 1618.9171142578 9.8169927597046 -- Пост С LVPD [18]
    Sphere.createSphere(1545.6296386719, -1631.2828369141, 13.3828125, 50.0)-- 1545.6296386719 -1631.2828369141 13.3828125 -- КПП ЛСПД [19]
    Sphere.createSphere(2753.5388183594, -2432.2268066406, 13.64318561554, 80.0)-- 2753.5388183594 -2432.2268066406 13.64318561554 -- Порт ЛС[20]
    Sphere.createSphere(2293.4145507813, -1584.8774414063, 3.5703411102295, 670.0)--  2293.4145507813 -1584.8774414063 3.5703411102295 -- Патруль гетто [21]
    Sphere.createSphere(186.95843505859, 1901.0294189453, 17.640625, 300.0)-- 186.95843505859 1901.0294189453 17.640625 -- Патруль ЛВа [22]
    Sphere.createSphere(-422, -1195, 60, 500.0)-- -422 -1195 60 --Юрисдикция ЛС - СФ [23]
    Sphere.createSphere(1644, -25, 36, 300.0)-- 1644 -25 36 --Юрисдикция ЛС - ЛВ [24]
    Sphere.createSphere(413, 625, 18, 300.0)-- 413 625 18 Юрисдикция ЛС- ЛВ 2 [25]
    Sphere.createSphere(-129, 518, 8, 300.0)-- -129 518 8 Юрисдикция ЛС - ЛВ 3 [26]
    Sphere.createSphere(-1003, 1285, 40, 300.0)-- -1003 1285 40 Юрисдикция СФ - ЛВ [27]
    Sphere.createSphere(-2126, 2654, 53, 300.0)-- -2126 2654 53 Юрисдикция СФ - ЛВ 2 [28]
    Sphere.createSphere(-1006, -442, 36, 300.0)-- -1006 -442 36 Юрисдикция ЛС - СФ 2 [29]
    Sphere.createSphere(-1126, -2574, 72, 300.0)-- -1126 -2574 72 Юрисдикция ЛС - СФ 3 [30]
    Sphere.createSphere(-1248, -2867, 64, 300.0)-- -1248 -2867 64 Юрисдикция ЛС- СФ 4 [31]
    Sphere.createSphere(2238.6533203125,   2449.4895019531,   11.037217140198, 10.0) -- 2238.6533203125   2449.4895019531   11.037217140198 -- КПП ЛВПД [32]
    Sphere.createSphere(2458.4575195313,   1340.5772705078,   10.9765625, 30) -- 2458.4575195313   1340.5772705078   10.9765625 -- LVPD D [33]
    Sphere.createSphere(373.66720581055,   173.75173950195,   1008.3893432617, 30) -- 373.66720581055,   173.75173950195,   1008.3893432617 -- Холл мэрии [34]
    Sphere.createSphere(361.3515, -1785.0653, 5.4350, 30) -- 361.3515,-1785.0653,5.4350 -- Автоярмарка [35]
end

function registerHotKey()
    --all
    vzaimbind = rkeys.registerHotKey(config_keys.vzaimkey.v, true, vzaimk)
    --pd/fbi
    tazerbind = rkeys.registerHotKey(config_keys.tazerkey.v, true, function() 
        if cfg.main.group == 'ПД/ФБР' or cfg.main.group == 'Мэрия' then
            sampSendChat('/tazer')
        end
    end)
    fastmenubind = rkeys.registerHotKey(config_keys.fastmenukey.v, true, function() 
        if cfg.main.group == 'ПД/ФБР' then
            lua_thread.create(function() 
                submenus_show(fthmenuPD, '{9966cc}'..script.this.name.." {FFFFFF}| Быстрое меню") 
            end) 
        elseif cfg.main.group == 'Автошкола' then
            lua_thread.create(function() 
                submenus_show(fthmenuAS, '{9966cc}'..script.this.name.." {FFFFFF}| Быстрое меню") 
            end)
        elseif cfg.main.group == "Медики" then
            lua_thread.create(function() 
                submenus_show(fthmenuMOH, '{9966cc}'..script.this.name.." {FFFFFF}| Быстрое меню") 
            end)
        end
    end)
    oopdabind = rkeys.registerHotKey(config_keys.oopda.v, true, oopdakey)
    oopnetbind = rkeys.registerHotKey(config_keys.oopnet.v, true, oopnetkey)
    megafbind = rkeys.registerHotKey(config_keys.megafkey.v, true, megaf)
    dkldbind = rkeys.registerHotKey(config_keys.dkldkey.v, true, dkld)
    cuffbind = rkeys.registerHotKey(config_keys.cuffkey.v, true, cuffk)
    followbind = rkeys.registerHotKey(config_keys.followkey.v, true, followk)
    cputbind = rkeys.registerHotKey(config_keys.cputkey.v, true, cputk)
    cejectbind = rkeys.registerHotKey(config_keys.cejectkey.v, true, cejectk)
    takebind = rkeys.registerHotKey(config_keys.takekey.v, true, takek)
    arrestbind = rkeys.registerHotKey(config_keys.arrestkey.v, true, arrestk)
    uncuffbind = rkeys.registerHotKey(config_keys.uncuffkey.v, true, uncuffk)
    dejectbind = rkeys.registerHotKey(config_keys.dejectkey.v, true, dejectk)
    sirenbind = rkeys.registerHotKey(config_keys.sirenkey.v, true, sirenk)
    --mayor
    hibind = rkeys.registerHotKey(config_keys.hikey.v, true, hikeyk)
	summabind = rkeys.registerHotKey(config_keys.summakey.v, true, summakeyk)
	freenalbind = rkeys.registerHotKey(config_keys.freenalkey.v, true, freenalkeyk)
	freebankbind = rkeys.registerHotKey(config_keys.freebankkey.v, true, freebankkeyk)
end

function oopchat()
	while true do wait(0)
        stext, sprefix, scolor, spcolor = sampGetChatString(99)
        if cfg.main.group == 'ПД/ФБР' then
            if zaproop then
                if nikk ~= nil then
                    if stext:find(nikk) and scolor == 4294935170 then
                        local _, myid = sampGetPlayerIdByCharHandle(PLAYER_PED)
                        local myname = sampGetPlayerNickname(myid)
                        if not stext:find(myname) then
                            zaproop = false
                            nikk = nil
                            wait(100)
                            ftext('Команду выполнил другой сотрудник.', -1)
                        end
                    end
                end
            end
            --if scolor == 4287467007 or scolor == 9276927 then
                if frak == 'FBI' then
                    if rang == 'Глава DEA' or rang == 'Глава CID' or rang == 'Инспектор FBI' or rang == 'Зам.Директора FBI' or rang == 'Директор FBI' then
                        if stext:match('Переоделся в костюм агента') then
                            local msrang, msnick = stext:match('(.+) (.+): Переоделся в костюм агента')
                            if msnick ~= sampGetPlayerNickname(select(2, sampGetPlayerIdByCharHandle(PLAYER_PED))) then
                                mssnyat = true
                                msoffid = sampGetPlayerIdByNickname(msnick)
                                ftext(('Агент {9966cc}%s {ffffff}хочет cнять маскировку'):format(msnick:gsub('_', ' ')))
                                ftext('Подтвердить: {9966cc}'..table.concat(rkeys.getKeysName(config_keys.oopda.v), " + ")..'{ffffff} | Отменить: {9966cc}'..table.concat(rkeys.getKeysName(config_keys.oopnet.v), " + "), -1)
                            end
                        end
                        if stext:match('Переоделась в костюм агента') then
                            local msrang, msnick = stext:match('(.+) (.+): Переоделась в костюм агента')
                            if msnick ~= sampGetPlayerNickname(select(2, sampGetPlayerIdByCharHandle(PLAYER_PED))) then
                                mssnyat = true
                                msoffid = sampGetPlayerIdByNickname(msnick)
                                ftext(('Агент {9966cc}%s {ffffff}хочет cнять маскировку'):format(msnick:gsub('_', ' ')))
                                ftext('Подтвердить: {9966cc}'..table.concat(rkeys.getKeysName(config_keys.oopda.v), " + ")..'{ffffff} | Отменить: {9966cc}'..table.concat(rkeys.getKeysName(config_keys.oopnet.v), " + "), -1)
                            end
                        end
                        if stext:match('Переоделся в сотрудника лаборатории') then
                            local msrang, msnick = stext:match('(.+) (.+): Переоделся в сотрудника лаборатории')
                            if msnick ~= sampGetPlayerNickname(select(2, sampGetPlayerIdByCharHandle(PLAYER_PED))) then
                                msid = sampGetPlayerIdByNickname(msnick)
                                msvidat = "лаборатория"
                                ftext(('Агент {9966cc}%s {ffffff}хочет взять форму {9966cc}сотрудника лаборатории{ffffff}'):format(msnick:gsub('_', ' ')))
                                ftext('Подтвердить: {9966cc}'..table.concat(rkeys.getKeysName(config_keys.oopda.v), " + ")..'{ffffff} | Отменить: {9966cc}'..table.concat(rkeys.getKeysName(config_keys.oopnet.v), " + "), -1)
                            end
                        end
                        if stext:match('Переоделась в сотрудника лаборатории') then
                            local msrang, msnick = stext:match('(.+) (.+): Переоделась в сотрудника лаборатории')
                            if msnick ~= sampGetPlayerNickname(select(2, sampGetPlayerIdByCharHandle(PLAYER_PED))) then
                                msid = sampGetPlayerIdByNickname(msnick)
                                msvidat = "лаборатория"
                                ftext(('Агент {9966cc}%s {ffffff}хочет взять форму {9966cc}сотрудника лаборатории{ffffff}'):format(msnick:gsub('_', ' ')))
                                ftext('Подтвердить: {9966cc}'..table.concat(rkeys.getKeysName(config_keys.oopda.v), " + ")..'{ffffff} | Отменить: {9966cc}'..table.concat(rkeys.getKeysName(config_keys.oopnet.v), " + "), -1)
                            end
                        end
                        if stext:match('Переоделся в форму .+. Причина: .+') then
                            local msrang, msnick, msforma, msreason = stext:match('(.+) (.+): Переоделся в форму (.+). Причина: (.+)')
                            if msnick ~= sampGetPlayerNickname(select(2, sampGetPlayerIdByCharHandle(PLAYER_PED))) then
                                msid = sampGetPlayerIdByNickname(msnick)
                                msvidat = msforma
                                ftext(('Агент {9966cc}%s {ffffff}хочет взять маскировку {9966cc}%s{ffffff}. Причина: {9966cc}%s'):format(msnick:gsub('_', ' '), msforma, msreason))
                                ftext('Подтвердить: {9966cc}'..table.concat(rkeys.getKeysName(config_keys.oopda.v), " + ")..'{ffffff} | Отменить: {9966cc}'..table.concat(rkeys.getKeysName(config_keys.oopnet.v), " + "), -1)
                            end
                        end
                        if stext:match('Переоделась в форму .+. Причина: .+') then
                            local msrang, msnick, msforma, msreason = stext:match('(.+) (.+): Переоделась в форму (.+). Причина: (.+)')
                            if msnick ~= sampGetPlayerNickname(select(2, sampGetPlayerIdByCharHandle(PLAYER_PED))) then
                                msid = sampGetPlayerIdByNickname(msnick)
                                msvidat = forma
                                ftext(('Агент {9966cc}%s {ffffff}хочет взять маскировку {9966cc}%s{ffffff}. Причина: {9966cc}%s'):format(msnick:gsub('_', ' '), msforma, msreason))
                                ftext('Подтвердить: {9966cc}'..table.concat(rkeys.getKeysName(config_keys.oopda.v), " + ")..'{ffffff} | Отменить: {9966cc}'..table.concat(rkeys.getKeysName(config_keys.oopnet.v), " + "), -1)
                            end
                        end
                    end
                end
                if rang ~= 'Кадет' and rang ~= 'Офицер' and rang ~= 'Мл.Сержант' and  rang ~= 'Сержант' and  rang ~= 'Прапорщик' then
                    if stext:find('Дело на имя .+ %(%d+%) рассмотрению не подлежит, ООП, объявите.') then
                        local name, id = stext:match('Дело на имя (.+) %((%d+)%) рассмотрению не подлежит, ООП, объявите.')
                        zaproop = true
                        nikk = name
                        if nikk ~= nil then
                            ftext(string.format("Поступил запрос на объявление ООП игрока {9966cc}%s", nikk:gsub('_', ' ')), -1)
                            ftext('Подтвердить: {9966cc}'..table.concat(rkeys.getKeysName(config_keys.oopda.v), " + ")..'{ffffff} | Отменить: {9966cc}'..table.concat(rkeys.getKeysName(config_keys.oopnet.v), " + "), -1)
                        else
                            zaproop = false
                        end
                    end
                    if stext:match('Дело .+ рассмотрению не подлежит %- ООП.') then
                        local name = stext:match('Дело (.+) рассмотрению не подлежит %- ООП.')
                        zaproop = true
                        nikk = name
                        if nikk ~= nil then
                            ftext(string.format("Поступил запрос на объявление ООП игрока {9966cc}%s", nikk:gsub('_', ' ')), -1)
                            ftext('Подтвердить: {9966cc}'..table.concat(rkeys.getKeysName(config_keys.oopda.v), " + ")..'{ffffff} | Отменить: {9966cc}'..table.concat(rkeys.getKeysName(config_keys.oopnet.v), " + "), -1)
                        else
                            zaproop = false
                        end
                    end
                    if stext:match('Дело на имя .+ рассмотрению не подлежит, ООП.') then
                        local name = stext:match('Дело на имя (.+) рассмотрению не подлежит, ООП.')
                        zaproop = true
                        nikk = name
                        if nikk ~= nil then
                            ftext(string.format("Поступил запрос на объявление ООП игрока {9966cc}%s", nikk:gsub('_', ' ')), -1)
                            ftext('Подтвердить: {9966cc}'..table.concat(rkeys.getKeysName(config_keys.oopda.v), " + ")..'{ffffff} | Отменить: {9966cc}'..table.concat(rkeys.getKeysName(config_keys.oopnet.v), " + "), -1)
                        else
                            zaproop = false
                        end
                    end
                end
            --end
            if nikk == nil then
                if aroop then aroop = false end
                if zaproop then zaproop = false end
                if dmoop then dmoop = false end
            end
        end
	end
end

function oopdakey()
    if cfg.main.group == 'ПД/ФБР' then
        if msvidat then
            msda = true
            sampSendChat('/spy '..msid)
        end
        if mssnyat then
            sampSendChat('/spyoff '..msoffid)
            msoffid = nil
            mssnyat = false
        end
        if opyatstat then
            lua_thread.create(checkStats)
            opyatstat = false
        end
        if zaproop then
            sampSendChat(string.format('/d Mayor, дело на имя %s рассмотрению не подлежит, ООП', nikk:gsub('_', ' ')))
            zaproop = false
            nazhaloop = true
        end
        if dmoop then
            if frak == 'FBI' or frak == 'LSPD' or frak == 'SFPD' or frak == 'LVPD' then
                if rang == 'Кадет' or rang == 'Офицер' or rang == 'Мл.Сержант' or  rang == 'Сержант' or  rang == 'Прапорщик' then
                    if not cfg.main.tarb then
                        sampSendChat(string.format('/r Дело на имя %s рассмотрению не подлежит, ООП.', nikk:gsub('_', ' ')))
                        dmoop = false
                    else
                        sampSendChat(string.format('/r [%s]: Дело на имя %s рассмотрению не подлежит, ООП.', cfg.main.tar, nikk:gsub('_', ' ')))
                        dmoop = false
                    end
                else
                    sampSendChat(string.format('/d Mayor, дело на имя %s рассмотрению не подлежит, ООП КПЗ LSPD.', nikk:gsub('_', ' ')))
                    dmoop = false
                    nazhaloop = true
                end
            end
        end
        if aroop then
            if frak == 'FBI' or frak == 'LSPD' or frak == 'SFPD' or frak == 'LVPD' then
                if rang == 'Кадет' or rang == 'Офицер' or rang == 'Мл.Сержант' or  rang == 'Сержант' or  rang == 'Прапорщик' then
                    if not cfg.main.tarb then
                        sampSendChat(string.format('/r Дело на имя %s рассмотрению не подлежит, ООП.', nikk:gsub('_', ' ')))
                        aroop = false
                        nikk = nil
                    else
                        sampSendChat(string.format('/r [%s]: Дело на имя %s рассмотрению не подлежит, ООП.', cfg.main.tar, nikk:gsub('_', ' ')))
                        aroop = false
                        nikk = nil
                    end
                else
                    sampSendChat(string.format("/d Mayor, дело на имя %s рассмотрению не подлежит, ООП.", nikk:gsub('_', ' ')))
                    aroop = false
                    --nikk = nil
                    nazhaloop = true
                end
            end
        end
    end
end

function oopnetkey()
    if cfg.main.group == 'ПД/ФБР' then
        msid = nil
        msda = false
        msvidat = nil
        mssnyat = false
        msoffid = nil
        if opyatstat then
            opyatstat = false
        end
        if dmoop == true then
            dmoop = false
            nikk = nil
            ftext("Рассмотр дела отменен.", -1)
        end
        if zaproop == true then
            zaproop = false
            nikk = nil
            ftext("Рассмотр дела отменен.", -1)
        end
        if aroop == true then
            aroop = false
            nikk = nil
            ftext("Рассмотр дела отменен.", -1)
        end
    end
end

function main()
    local directoryes = {'config', 'config/fbitools', 'fbitools'}
    for k, v in pairs(directoryes) do
        if not doesDirectoryExist('moonloader/'..v) then createDirectory("moonloader/"..v) end
    end
    if not doesFileExist('moonloader/config/fbitools/config.json') then
        io.open('moonloader/config/fbitools/config.json', 'w'):close()
    else
        local file = io.open('moonloader/config/fbitools/config.json', 'r')
        if file then
            cfg = decodeJson(file:read('*a'))
            if cfg.main.megaf == nil then cfg.main.megaf = true end
            if cfg.main.autobp == nil then cfg.main.autobp = false end
            if cfg.autobp == nil then cfg.autobp = {
                deagle = true,
                dvadeagle = true,
                shot = true,
                dvashot = true,
                smg = true,
                dvasmg = true,
                m4 = true,
                dvam4 = true,
                rifle = true,
                dvarifle = true,
                armour = true,
                spec = true
            }
            end
            if cfg.main.googlecode == nil then cfg.main.googlecode = '' end
            if cfg.main.googlecodeb == nil then cfg.main.googlecodeb = false end
            if cfg.main.group == nil then cfg.main.group = 'unknown' end
            if cfg.main.nwanted == nil then cfg.main.nwanted = false end
            if cfg.main.nclear == nil then cfg.main.nclear = false end
        end
    end
    saveData(cfg, 'moonloader/config/fbitools/config.json')
    if doesFileExist("moonloader/config/fbitools/cmdbinder.json") then
        local file = io.open('moonloader/config/fbitools/cmdbinder.json', 'r')
        if file then
            commands = decodeJson(file:read('*a'))
        end
    end
    saveData(commands, "moonloader/config/fbitools/cmdbinder.json")
    if not doesFileExist("moonloader/config/fbitools/keys.json") then
        local fa = io.open("moonloader/config/fbitools/keys.json", "w")
		fa:write(encodeJson(config_keys))
        fa:close()
    else
        local fa = io.open("moonloader/config/fbitools/keys.json", 'r')
        if fa then
            config_keys = decodeJson(fa:read('*a'))
            if config_keys.hikey == nil then config_keys.hikey = {v = {key.VK_I}} end
            if config_keys.summakey == nil then config_keys.summakey = {v = {key.VK_L}} end
            if config_keys.freenalkey == nil then config_keys.freenalkey = {v = {key.VK_Y}} end
            if config_keys.freebankkey == nil then config_keys.freebankkey = {v = {key.VK_U}} end
            if config_keys.vzaimkey == nil then config_keys.vzaimkey = {v = {key.VK_Z}} end
        end
    end
    saveData(config_keys, 'moonloader/config/fbitools/keys.json')
    if doesFileExist(fileb) then
        local f = io.open(fileb, "r")
        if f then
            tBindList = decodeJson(f:read())
            f:close()
        end
    else
        tBindList = {
            [1] = {
                text = "",
                v = {},
                name = 'Бинд1'
            },
            [2] = {
                text = "",
                v = {},
                name = 'Бинд2'
            },
            [3] = {
                text = "",
                v = {},
                name = 'Бинд3'
            }
        }
    end
    saveData(tBindList, fileb)
    repeat wait(0) until isSampAvailable()
    ftext(script.this.name..' успешно загружен. Введите: /ft что бы получить дополнительную информацию.')
    ftext('Авторы: '..table.concat(script.this.authors))
    print(("%s v%s: Успешно загружен"):format(script.this.name, script.this.version))
    libs()
    registerCommands()
    registerSphere()
    registerHotKey()
    registerCommandsBinder()
    if cfg.main.group == 'unknown' then ftext("Сейчас у вас не выбрана группа фракций. Большинство функций скрипта недоступны.")
        ftext("Настроить группу можно в настройках скрипта.") 
    else 
        ftext("Загружены настройки для группы: {9966CC}"..cfg.main.group) 
    end
    update()
    mcheckf()
    shpf()
    ykf()
    akf()
    fpf()
    suf()
    apply_custom_style()
    lua_thread.create(oopchat)
	lua_thread.create(strobes)
    for k, v in pairs(tBindList) do
        rkeys.registerHotKey(v.v, true, onHotKey)
        if v.time ~= nil then v.time = nil end
        if v.name == nil then v.name = "Бинд"..k end
        v.text = v.text:gsub("%[enter%]", ""):gsub("{noenter}", "{noe}")
    end
    saveData(tBindList, fileb)
    addEventHandler("onWindowMessage", function (msg, wparam, lparam)
        if msg == wm.WM_KEYDOWN or msg == wm.WM_SYSKEYDOWN then
            if tEditData.id > -1 then
                if wparam == key.VK_ESCAPE then
                    tEditData.id = -1
                    consumeWindowMessage(true, true)
                elseif wparam == key.VK_TAB then
                    bIsEnterEdit.v = not bIsEnterEdit.v
                    consumeWindowMessage(true, true)
                end
            end
            if wparam == key.VK_ESCAPE then
                if not sampIsChatInputActive() and not sampIsDialogActive() and not sampIsScoreboardOpen() then
                    if mainw.v then mainw.v = false consumeWindowMessage(true, true) end
                    if imegaf.v then imegaf.v = false consumeWindowMessage(true, true) end
                    if shpwindow.v then shpwindow.v = false consumeWindowMessage(true, true) end
                    if ykwindow.v then ykwindow.v = false consumeWindowMessage(true, true) end
                    if fpwindow.v then fpwindow.v = false consumeWindowMessage(true, true) end
                    if akwindow.v then akwindow.v = false consumeWindowMessage(true, true) end
                    if updwindows.v then updwindows.v = false consumeWindowMessage(true, true) end
                    if memw.v then memw.v = false consumeWindowMessage(true, true) end
                end
            end
        end
    end)
    if not sampIsDialogActive() then
        lua_thread.create(checkStats)
    else
        while sampIsDialogActive() do wait(0) end
        lua_thread.create(checkStats)
    end
    while true do wait(0)
        if isCharInAnyCar(PLAYER_PED) then mcid = select(2, sampGetVehicleIdByCarHandle(storeCarCharIsInNoSave(PLAYER_PED))) end
        if gmegafid == nil then gmegafid = -1 end
        if #departament > 25 then table.remove(departament, 1) end
        if #radio > 25 then table.remove(radio, 1) end
        if #wanted > 25 then table.remove(wanted, 1) end
        if #sms > 25 then table.remove(sms, 1) end
        infbar = imgui.ImBool(cfg.main.hud)
        local myid = select(2, sampGetPlayerIdByCharHandle(PLAYER_PED))
        imgui.Process = infbar.v or mainw.v or shpwindow.v or ykwindow.v or fpwindow.v or akwindow.v or updwindows.v or imegaf.v or memw.v
        local myskin = getCharModel(PLAYER_PED)
        if myskin == 280 or myskin == 265 or myskin == 266 or myskin == 267 or myskin == 281 or myskin == 282 or myskin == 288 or myskin == 284 or myskin == 285 or myskin == 304 or myskin == 305 or myskin == 306 or myskin == 307 or myskin == 309 or myskin == 283 or myskin == 286 or myskin == 287 or myskin == 252 or myskin == 279 or myskin == 163 or myskin == 164 or myskin == 165 or myskin == 166 then
            rabden = true
        end
        if cfg.main.group == 'ПД/ФБР' then if sampGetFraktionBySkin(myid) == 'Полиция' or sampGetFraktionBySkin(myid) == 'FBI' or sampGetFraktionBySkin(myid) == 'Army' then rabden = true end
        elseif cfg.main.group == 'Автошкола' then if sampGetFraktionBySkin(myid) == 'Автошкола' then rabden = true end
        elseif cfg.main.group == 'МОН' then if sampGetFraktionBySkin(myid) == 'Медики' then rabden = true end
        elseif cfg.main.group == 'Мэрия' then if sampGetFraktionBySkin(myid) == 'Мэрия' then rabden = true end
        end
        if sampIsDialogActive() == false and not isPauseMenuActive() and isPlayerPlaying(playerHandle) and sampIsChatInputActive() == false then
            if coordX ~= nil and coordY ~= nil then
                cX, cY, cZ = getCharCoordinates(playerPed)
                cX = math.ceil(cX)
                cY = math.ceil(cY)
                cZ = math.ceil(cZ)
                ftext('Метка установлена на '..kvadY..'-'..kvadX)
                placeWaypoint(coordX, coordY, 0)
                coordX = nil
                coordY = nil
            end
        end
        if not doesCharExist(gmegafhandle) and gmegafhandle ~= nil then
            ftext(string.format('Игрок {9966cc}%s [%s] {ffffff}потерян из поля зрения', sampGetPlayerNickname(gmegafid), gmegafid))
            gmegafid = -1
			gmegaflvl = nil
			gmegaffrak = nil
            gmegafhandle = nil
        end
        if changetextpos then
            sampToggleCursor(true)
            local CPX, CPY = getCursorPos()
            cfg.main.posX = CPX
            cfg.main.posY = CPY
        end
        if wasKeyPressed(key.VK_T) and cfg.main.tchat and not sampIsChatInputActive() and not sampIsDialogActive() and not isSampfuncsConsoleActive() then
            sampSetChatInputEnabled(true)
        end
        local myhp = getCharHealth(PLAYER_PED)
        local valid, ped = getCharPlayerIsTargeting(PLAYER_HANDLE)
        if valid and doesCharExist(ped) then
            local result, id = sampGetPlayerIdByCharHandle(ped)
            targetid = id
        end
        local result, button, list, input = sampHasDialogRespond(1385)
        local result16, button, list, input = sampHasDialogRespond(1401)
        local result17, button, list, input = sampHasDialogRespond(1765)
        local ooplresult, button, list, input = sampHasDialogRespond(2458)
        local oopdelresult, button, list, input = sampHasDialogRespond(2459)
        local _, myid = sampGetPlayerIdByCharHandle(PLAYER_PED)
        if #ooplistt > 30 then
            table.remove(ooplistt, 1)
        end
        if oopdelresult then
            if button == 1 then
                local oopi = 1
                while oopi <= #ooplistt do
                    if ooplistt[oopi]:find(oopdelnick) then
                        table.remove(ooplistt, oopi)
                    else
                        oopi = oopi + 1
                    end
                end
                ftext('Игрок {9966cc}'..oopdelnick..'{ffffff} был удален из списка ООП')
            elseif button == 0 then
                sampShowDialog(2458, '{9966cc}'..script.this.name.. '| {ffffff}Список ООП', table.concat(ooplistt, '\n'), '»', "x", 2)
            end
        end
        if ooplresult then
            if button == 1 then
                local ltext = sampGetListboxItemText(list)
                if ltext:match("дело на имя .+ рассмотрению не подлежит, ООП") then
                    oopdelnick = ltext:match("дело на имя (.+) рассмотрению не подлежит, ООП")
                    sampShowDialog(2459, '{9966cc}'..script.this.name..' | {ffffff}Удаление из ООП', "{ffffff}Вы действительно желаете удалить {9966cc}"..oopdelnick.."\n{ffffff}Из списка ООП?", "»", "«", 0)
                elseif ltext:match("дело .+ рассмотрению не подлежит %- ООП.") then
                    oopdelnick = ltext:match("дело (.+) рассмотрению не подлежит %- ООП.")
                    sampShowDialog(2459, '{9966cc}'..script.this.name..' | {ffffff}Удаление из ООП', "{ffffff}Вы действительно желаете удалить {9966cc}"..oopdelnick.."\n{ffffff}Из списка ООП?", "»", "«", 0)
                end
            end
        end
        if result17 then
            if button == 1 then
                if #input ~= 0 and tonumber(input) ~= nil then
                    for k, v in pairs(suz) do
                        if tonumber(input) == k then
                            local reas, zzv = v:match('(.+) %- (%d+) .+')
                            sampSendChat(string.format('/su %s %s %s', zid, zzv, reas))
                            zid = nil
                        end
                    end
                else
                    ftext('Вы не выбрали номер статьи.')
                end
            end
        end
        if result16 then
            if input ~= '' and button == 1 then
                if cfg.main.tarb then
                    sampSendChat(string.format('/r [%s]: Запрашиваю эвакуацию в квадрат %s на %s', cfg.main.tar, kvadrat(), input))
                else
                    sampSendChat(string.format('/r Запрашиваю эвакуацию в квадрат %s на %s', kvadrat(), input))
                end
            end
        end
        if result then
            if button == 1 then
				sampSendChat(("/r %s в форму %s. Причина: %s"):format(cfg.main.male and 'Переоделся' or 'Переоделась', mstype, input))
				wait(1400)
				sampSendChat("/rb "..myid)
				mstype = ''
            end
        end
    end
end

function oop(pam)
    pID = tonumber(pam)
    if frak == 'FBI' or frak == 'LSPD' or frak == 'SFPD' or frak == 'LVPD' then
        if pID ~= nil then
            if sampIsPlayerConnected(pID) then
                if rang == 'Кадет' or rang == 'Офицер' or rang == 'Мл.Сержант' or  rang == 'Сержант' or  rang == 'Прапорщик' then
                    if not cfg.main.tarb then
                        sampSendChat("/r Дело на имя "..sampGetPlayerNickname(pID):gsub('_', ' ').." рассмотрению не подлежит, ООП.")
                    else
                        sampSendChat("/r ["..cfg.main.tar.."]: Дело на имя "..sampGetPlayerNickname(pID):gsub('_', ' ').." рассмотрению не подлежит, ООП.")
                    end
                else
                    sampSendChat("/d Mayor, дело на имя "..sampGetPlayerNickname(pID):gsub('_', ' ').." рассмотрению не подлежит, ООП.")
                end
            else
                ftext("Игрок с ID: "..pID.." не подключен к серверу")
            end
        else
            ftext("Введите: /oop [id]")
        end
    else
        ftext("Вы не сотрудник ПД/FBI")
    end
end

function tazer()
    lua_thread.create(function()
        sampSendChat("/tazer")
        wait(1400)
        sampSendChat(('/me %s тип патронов'):format(cfg.main.male and 'сменил' or 'сменила'))
    end)
end

function su(pam)
    pID = tonumber(pam)
    if pID ~= nil then
        if sampIsPlayerConnected(pID) then
            lua_thread.create(function()
                submenus_show(sumenu(pID), "{9966cc}"..script.this.name.." {ffffff}| "..sampGetPlayerNickname(pID).."["..pID.."] ")
            end)
        else
            ftext("Игрок с ID: "..pID.." не подключен к серверу")
        end
    else
        ftext("Введите: /su [id]")
    end
end

function ssu(pam)
    local id, zv, orichina = pam:match('(%d+) (%d+) (.+)')
    if id and zv and orichina then
        sampSendChat(string.format('/su %s %s %s', id, zv, orichina))
    else
        ftext('Введите: /ssu [id] [кол-во звезд] [причина]')
    end
end

function keys()
    lua_thread.create(function()
        sampSendChat(("/me %s ключ"):format(cfg.main.male and 'взял' or 'взяла'))
        wait(cfg.commands.zaderjka)
        sampSendChat("/me сравнивает ключ с ключом от КПЗ")
        wait(cfg.commands.zaderjka)
        sampSendChat(("/try %s, что ключи идентичны"):format(cfg.main.male and 'обнаружил', 'обнаружила'))
    end)
end

function cput(pam)
    lua_thread.create(function()
        if cfg.commands.cput then
            if pam:match("^(%d+)$") then
                local id = tonumber(pam:match("^(%d+)$"))
                if sampIsPlayerConnected(id) then
                    if isCharInAnyCar(PLAYER_PED) then
                        if isCharOnAnyBike(PLAYER_PED) then
                            sampSendChat(("/me %s %s на сиденье мотоцикла"):format(cfg.main.male and 'посадил' or 'посадила', sampGetPlayerNickname(id):gsub("_", ' ')))
                            wait(1400)
                            sampSendChat(("/cput %s %s"):format(id, getFreeSeat()))
                        else
                            sampSendChat(("/me %s дверь автомобиля и %s туда %s"):format(cfg.main.male and 'открыл' or 'открыла', cfg.main.male and 'затолкнул' or 'затолкнула', sampGetPlayerNickname(id):gsub("_", ' ')))
                            wait(1400)
                            sampSendChat(("/cput %s %s"):format(id, getFreeSeat()))
                        end
                    else
                        sampSendChat(("/me %s дверь автомобиля и %s туда %s"):format(cfg.main.male and 'открыл' or 'открыла', cfg.main.male and 'затолкнул' or 'затолкнула', sampGetPlayerNickname(id):gsub("_", ' ')))
                        while not isCharInAnyCar(PLAYER_PED) do wait(0) end
                        sampSendChat(("/cput %s %s"):format(id, getFreeSeat()))
                    end
                else
                    ftext("Игрок оффлайн")
                end
            elseif pam:match("^(%d+) (%d+)$") then
                local id, seat = pam:match("^(%d+) (%d+)$")
                local id, seat = tonumber(id), tonumber(seat)
                if sampIsPlayerConnected(id) then
                    if seat >=1 and seat <=3 then
                        if isCharInAnyCar(PLAYER_PED) then
                            if isCharOnAnyBike(PLAYER_PED) then
                                sampSendChat(("/me %s %s на сиденье мотоцикла"):format(cfg.main.male and 'посадил' or 'посадила', sampGetPlayerNickname(id):gsub("_", ' ')))
                                wait(1400)
                                sampSendChat(("/cput %s %s"):format(id, seat))
                            else
                                sampSendChat(("/me %s дверь автомобиля и %s туда %s"):format(cfg.main.male and 'открыл' or 'открыла', cfg.main.male and 'затолкнул' or 'затолкнула', sampGetPlayerNickname(id):gsub("_", ' ')))
                                wait(1400)
                                sampSendChat(("/cput %s %s"):format(id, seat))
                            end
                        else
                            sampSendChat(("/me %s дверь автомобиля и %s туда %s"):format(cfg.main.male and 'открыл' or 'открыла', cfg.main.male and 'затолкнул' or 'затолкнула', sampGetPlayerNickname(id):gsub("_", ' ')))
                            while not isCharInAnyCar(PLAYER_PED) do wait(0) end
                            sampSendChat(("/cput %s %s"):format(id, seat))
                        end
                    else
                        ftext('Значение не должно быть меньше 1 и больше 3!')
                    end
                else
                    ftext('Игрок оффлайн')
                end
            elseif #pam == 0 or not pam:match("^(%d+)$") or not pam:match("^(%d+) (%d+)$") then
                ftext('Введите: /cput [id] [место(не обязательно)]')
            end
        else
            sampSendChat(('/cput %s'):format(pam))
        end
    end)
end

function ceject(pam)
    lua_thread.create(function()
        local id = tonumber(pam)
        if cfg.commands.ceject then
            if id ~= nil then
                if sampIsPlayerConnected(id) then
                    if isCharOnAnyBike(PLAYER_PED) then
                        sampSendChat(("/me %s %s с мотоцикла"):format(cfg.main.male and 'высадил' or 'высадила', sampGetPlayerNickname(id):gsub('_', ' ')))
                        wait(1400)
                        sampSendChat(("/ceject %s"):format(id))
                    else
                        sampSendChat(("/me %s дверь атвомобиля и %s %s"):format(cfg.main.male and 'открыл' or 'открыла', cfg.main.male and 'высадил' or 'высадила', sampGetPlayerNickname(id):gsub('_', ' ')))
                        wait(1400)
                        sampSendChat(("/ceject %s"):format(id))
                    end
                else
                    ftext('Игрок оффлайн')
                end
            else
                ftext('Введите: /ceject [id]')
            end
        else
            sampSendChat(("/ceject %s"):format(pam))
        end
    end)
end

function st(pam)
    local id = tonumber(pam)
    local result, ped = sampGetCharHandleBySampPlayerId(id)
    if id == nil then
        sampSendChat('/m ['..frak..'] Водитель, снизьте скорость и прижмитесь к обочине или мы откроем огонь!')
    end
    if id ~= nil and not sampIsPlayerConnected(id) then
        ftext(string.format('Игрок с ID: %s не подключен к серверу', id), -1)
    end
    if result and not doesCharExist(ped) then
        local stname = sampGetPlayerNickname(id)
        ftext(string.format('Игрок %s [%s] не доступен', stname, id), -1)
    end
    if result and doesCharExist(ped) and not isCharInAnyCar(ped) then
        local stnaame = sampGetPlayerNickname(id)
        ftext(string.format('Игрок %s [%s] не в транспорте', stnaame, id), -1)
    end
    if result and doesCharExist(ped) and isCharInAnyCar(ped) then
        local vehName = tCarsName[getCarModel(storeCarCharIsInNoSave(ped))-399]
        sampSendChat("/m Водитель Т/C "..vehName.." с гос.номером [EVL"..id.."X], прижмитесь к обочине и остановите своё Т/С")
    end
end

function deject(pam)
    lua_thread.create(function()
        local id = tonumber(pam)
        if cfg.commands.deject then
            if id ~= nil then
                if sampIsPlayerConnected(id) then
                    local result, ped = sampGetCharHandleBySampPlayerId(id)
                    if result then
                        if isCharInFlyingVehicle(ped) then
                            sampSendChat(("/me %s дверь вертолёта и %s %s"):format(cfg.main.male and 'открыл' or 'открыла', cfg.main.male and 'вытащил' or 'вытащила', sampGetPlayerNickname(id):gsub('_', ' ')))
                        elseif isCharInModel(ped, 481) or isCharInModel(ped, 510) then
                            sampSendChat(("/me %s %s с велосипеда"):format(cfg.main.male and 'скинул' or 'скинула', sampGetPlayerNickname(id):gsub('_', ' ')))
                        elseif isCharInModel(ped, 462) then
                            sampSendChat(("/me %s %s со скутера"):format(cfg.main.male and 'скинул' or 'скинула', sampGetPlayerNickname(id):gsub('_', ' ')))
                        elseif isCharOnAnyBike(ped) then
                            sampSendChat(("/me %s %s с мотоцикла"):format(cfg.main.male and 'скинул' or 'скинула', sampGetPlayerNickname(id):gsub('_', ' ')))
                        elseif isCharInAnyCar(ped) then
                            sampSendChat(("/me %s окно и %s %s из машины"):format(cfg.main.male and 'разбил' or 'разбила', cfg.main.male and 'вытащил' or 'вытащила', sampGetPlayerNickname(id):gsub('_', ' ')))
                        end
                        wait(1400)
                        sampSendChat(("/deject %s"):format(id))
                    end
                else
                    ftext('Игрок оффлайн')
                end
            else
                ftext("Введите: /deject [id]")
            end
        else
            sampSendChat(("/deject %s"):format(pam))
        end
    end)
end

function rh(id)
    local _, myid = sampGetPlayerIdByCharHandle(PLAYER_PED)
    if id == "" or id < "1" or id > "3" or id == nil then
        ftext("Введите: /rh Департамент", -1)
        ftext("1 - LSPD | 2 - SFPD | 3 - LVPD", -1)
    elseif id == "1" then
        sampSendChat("/d LSPD, запрашиваю патрульный экипаж в "..kvadrat()..", как приняли? Ответ на пдж."..myid)
    elseif id == "2" then
        sampSendChat("/d SFPD, запрашиваю патрульный экипаж в "..kvadrat()..", как приняли? Ответ на пдж."..myid)
    elseif id == "3" then
        sampSendChat("/d LVPD, запрашиваю патрульный экипаж в "..kvadrat()..", как приняли? Ответ на пдж."..myid)
    end
end
function gr(pam)
    local dep, reason = pam:match('(%d+)%s+(.+)')
    if dep == nil or reason == nil then
        ftext("Введите: /gr [1-3] [Причина]")
        ftext("1 - LSPD | 2 - SFPD | 3 - LVPD")
    end
    if dep ~= nil then
        if dep == "" or dep < "1" or dep > "3" then
            ftext("{9966CC}"..script.this.name.." {FFFFFF}| Введите: /gr [1-3] [Причина]")
            ftext("{9966CC}"..script.this.name.." {FFFFFF}| 1 - LSPD | 2 - SFPD | 3 - LVPD")
        elseif dep == "1" then
            sampSendChat("/d LSPD, пересекаю вашу юрисдикцию, "..reason)
        elseif dep == "2" then
            sampSendChat("/d SFPD, пересекаю вашу юрисдикцию, "..reason)
        elseif dep == "3" then
            sampSendChat("/d LVPD, пересекаю вашу юрисдикцию, "..reason)
        end
    end
end
function warn(pam)
    local id = tonumber(pam)
    if frak == 'FBI' then
        if id == nil then
            ftext('Введите /warn ID')
        end
        if id ~= nil and sampIsPlayerConnected(id) then
            lua_thread.create(function()
                warnst = true
                sampSendChat('/mdc '..id)
                wait(1400)
                if wfrac == 'LSPD' or wfrac == 'SFPD' or wfrac == 'LVPD' then
                    sampSendChat(string.format('/d %s, %s получает предупреждение за неправильную подачу в розыск.', wfrac, sampGetPlayerNickname(id):gsub('_', ' ')))
                else
                    ftext('Человек не является сотрудником PD')
                end
                wfrac = nil
                warnst = false
            end)
        end
    else
        ftext("Вы не сотрудник ФБР")
    end
end
function ms(pam)
	lua_thread.create(function()
		if frak == 'FBI' then
			if pam == "" or pam < "0" or pam > "3" or pam == nil then
				ftext("Введите: /ms [Тип]", -1)
				ftext("0 - Снять маскировку | 1 - Офис | 2 - Багажник | 3 - Сумка", -1)
			elseif pam == '1' then
				sampSendChat(("/me %s с себя костюм агента и %s на вешалку"):format(cfg.main.male and 'снял' or 'сняла', cfg.main.male and 'повесил' or 'повесила'))
				wait(cfg.commands.zaderjka)
				sampSendChat(("/me %s ящик, после чего достал %s маскировки"):format(cfg.main.male and 'открыл' or 'открыла', cfg.main.male and 'достал' or 'достала'))
				wait(cfg.commands.zaderjka)
				sampSendChat(("/me %s на себя маскировку и %s ящик"):format(cfg.main.male and 'надел' or 'надела', cfg.main.male and 'закрыл' or 'закрыла'))
				wait(cfg.commands.zaderjka)
				sampSendChat("/do Агент в маскировке.")
				wait(100)
				submenus_show(osnova, "{9966cc}"..script.this.name.." {ffffff}| Mask")
			elseif pam == '2' then
				sampSendChat(("/me %s багажник автомобиля"):format(cfg.main.male and 'открыл' or 'открыла'))
				wait(cfg.commands.zaderjka)
				sampSendChat(("/me %s с себя костюм агента и %s в багажник"):format(cfg.main.male and 'снял' or 'сняла', cfg.main.male and 'убрал' or 'убрала'))
				wait(cfg.commands.zaderjka)
				sampSendChat(("/me %s из багажника комплект маскировки и %s на себя"):format(cfg.main.male and 'достал' or 'достала', cfg.main.male and 'надел' or 'надела'))
				wait(cfg.commands.zaderjka)
				sampSendChat(("/me %s багажник"):format(cfg.main.male and 'закрыл' or 'закрыла'))
				wait(cfg.commands.zaderjka)
				sampSendChat("/do Агент в маскировке.")
				wait(100)
				submenus_show(osnova, "{9966cc}"..script.this.name.." {ffffff}| Mask")
			elseif pam == '3' then
				sampSendChat("/do На плече агента висит сумка.")
				wait(cfg.commands.zaderjka)
				sampSendChat(("/me открыв сумку, %s костюм агента и %s туда"):format(cfg.main.male and 'снял' or 'сняла', cfg.main.male and 'убрал' or 'убрала'))
				wait(cfg.commands.zaderjka)
				sampSendChat(("/me %s из сумки комплект маскировки и %s на себя"):format(cfg.main.male and 'достал' or 'достала', cfg.main.male and 'надел' or 'надела'))
				wait(cfg.commands.zaderjka)
				sampSendChat(("/me %s сумку"):format(cfg.main.male and 'закрыл' or 'закрыла'))
				wait(cfg.commands.zaderjka)
				sampSendChat("/do Агент в маскировке.")
				wait(100)
				submenus_show(osnova, "{9966cc}"..script.this.name.." {ffffff}| Mask")
			elseif pam == '0' then
				sampSendChat(("/me %s с себя маскировку"):format(cfg.main.male and 'снял' or 'сняла'))
				wait(cfg.commands.zaderjka)
				sampSendChat(("/me %s на себя костюм агента"):format(cfg.main.male and 'надел' or 'надела'))
				wait(cfg.commands.zaderjka)
				sampSendChat(("/r %s в костюм агента"):format(cfg.main.male and 'Переоделся' or 'Переоделась'))
				wait(cfg.commands.zaderjka)
				sampSendChat("/rb "..select(2, sampGetPlayerIdByCharHandle(PLAYER_PED)))
			end
		else
			ftext('Вы не сотрудник FBI')
		end
	end)
end

function ar(id)
    if id == "" or id < "1" or id > "2" or id == nil then
        ftext("Введите: /ar [1-2]", -1)
        ftext("1 - LVa | 2 - SFa", -1)
    elseif id == "1" then
        sampSendChat("/d LVa, разрешите въезд на вашу территорию, поимка преступника.")
    elseif id == "2" then
        sampSendChat("/d SFa, разрешите въезд на вашу территорию, поимка преступника.")
    end
end

function r(pam)
    if #pam ~= 0 then
        if cfg.main.tarb then
            sampSendChat(string.format('/r [%s]: %s', cfg.main.tar, pam))
        else
            sampSendChat(string.format('/r %s', pam))
        end
    else
        ftext('Введите /r [текст]')
    end
end

function f(pam)
    if #pam ~= 0 then
        if cfg.main.tarb then
            sampSendChat(string.format('/f [%s]: %s', cfg.main.tar, pam))
        else
            sampSendChat(string.format('/f %s', pam))
        end
    else
        ftext('Введите /f [текст]')
    end
end

function fst(param)
    local hour = tonumber(param)
    if hour ~= nil and hour >= 0 and hour <= 23 then
        time = hour
        patch_samp_time_set(true)
        if time then
            setTimeOfDay(time, 0)
            ftext('Время изменено на: {9966cc}'..time, -1)
        end
    else
        ftext('Значение времени должно быть в диапазоне от 0 до 23.', -1)
        patch_samp_time_set(false)
        time = nil
    end
end

function fsw(param)
    local weather = tonumber(param)
    if weather ~= nil and weather >= 0 and weather <= 45 then
        forceWeatherNow(weather)
        ftext('Погода изменена на: {9966cc}'..weather, -1)
    else
        ftext('Значение погоды должно быть в диапазоне от 0 до 45.', -1)
    end
end

function patch_samp_time_set(enable)
    if enable and default == nil then
        default = readMemory(sampGetBase() + 0x9C0A0, 4, true)
        writeMemory(sampGetBase() + 0x9C0A0, 4, 0x000008C2, true)
    elseif enable == false and default ~= nil then
        writeMemory(sampGetBase() + 0x9C0A0, 4, default, true)
        default = nil
    end
end

function fshp(pam)
    if #pam ~= 0 then
        local f = io.open('moonloader\\fbitools\\shp.txt')
        for line in f:lines() do
            if string.find(line, pam) or string.rlower(line):find(pam) or string.rupper(line):find(pam) then
                sampAddChatMessage(' '..line, -1)
            end
        end
        f:close()
    else
        ftext('Введите /fshp [текст]')
    end
end
function fyk(pam)
    if #pam ~= 0 then
        local f = io.open('moonloader\\fbitools\\yk.txt')
        for line in f:lines() do
            if string.find(line, pam) or string.rlower(line):find(pam) or string.rupper(line):find(pam) then
                sampAddChatMessage(' '..line, -1)
            end
        end
        f:close()
    else
        ftext('Введите /fyk [текст]')
    end
end

function ffp(pam)
    if #pam ~= 0 then
        local f = io.open('moonloader\\fbitools\\fp.txt')
        for line in f:lines() do
            if string.find(line, pam) or string.rlower(line):find(pam) or string.rupper(line):find(pam) then
                sampAddChatMessage(' '..line, -1)
            end
        end
        f:close()
    else
        ftext('Введите /ffp [текст]')
    end
end

function fak(pam)
    if #pam ~= 0 then
        local f = io.open('moonloader\\fbitools\\ak.txt')
        for line in f:lines() do
            if string.find(line, pam) or string.rlower(line):find(pam) or string.rupper(line):find(pam) then
                sampAddChatMessage(' '..line, -1)
            end
        end
        f:close()
    else
        ftext('Введите /fak [текст]')
    end
end

function dmb()
    lua_thread.create(function()
        if sampIsDialogActive() then
            if sampIsDialogClientside() then
                tMembers = {}
                status = true
                sampSendChat('/members')
                while not gotovo do wait(0) end
                memw.v = true
                gosmb = false
                krimemb = false
                gotovo = false
                status = false
                gcount = nil
            end
        else
            tMembers = {}
            status = true
            sampSendChat('/members')
            while not gotovo do wait(0) end
            memw.v = true
            gosmb = false
            krimemb = false
            gotovo = false
            status = false
            gcount = nil
        end
	end)
end

function megaf()
    if cfg.main.group == 'ПД/ФБР' then
        lua_thread.create(function()
            if isCharInAnyCar(PLAYER_PED) then
                incar = {}
                local stream = sampGetStreamedPlayers()
                local _, myvodil = sampGetPlayerIdByCharHandle(getDriverOfCar(storeCarCharIsInNoSave(PLAYER_PED)))
                for k, v in pairs(stream) do
                    local result, ped = sampGetCharHandleBySampPlayerId(v)
                    if result then
                        if isCharInAnyCar(ped) then
                            local car = storeCarCharIsInNoSave(ped)
                            local myposx, myposy, myposz = getCharCoordinates(PLAYER_PED)
                            local pposx, pposy, pposz = getCharCoordinates(ped)
                            local dist = getDistanceBetweenCoords3d(myposx, myposy, myposz, pposx, pposy, pposz)
                            if dist <=65 then
                                if getDriverOfCar(car) == ped then
                                    if sampGetFraktionBySkin(v) ~= 'Полиция' then
                                        if storeCarCharIsInNoSave(ped) ~= storeCarCharIsInNoSave(PLAYER_PED) then
                                            if v ~= myvodil then
                                                table.insert(incar, v)
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
                if #incar ~= 0 then
                    if #incar == 1 then
                        local result, ped = sampGetCharHandleBySampPlayerId(incar[1])
                        if doesCharExist(ped) then
                            if isCharInAnyCar(ped) then
                                local carh = storeCarCharIsInNoSave(ped)
                                local carhm = getCarModel(carh)
                                sampSendChat(("/m Водитель а/м %s [EVL%sX]"):format(tCarsName[carhm-399], incar[1]))
                                wait(1400)
                                sampSendChat("/m Прижмитесь к обочине или мы откроем огонь!")
                                wait(300)
                                sampAddChatMessage(' {ffffff}~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~', 0x9966cc)
                                sampAddChatMessage('', 0x9966cc)
                                sampAddChatMessage(' {ffffff}Ник: {9966cc}'..sampGetPlayerNickname(incar[1])..' ['..incar[1]..']', 0x9966cc)
                                sampAddChatMessage(' {ffffff}Уровень: {9966cc}'..sampGetPlayerScore(incar[1]), 0x9966cc)
                                sampAddChatMessage(' {ffffff}Фракция: {9966cc}'..sampGetFraktionBySkin(incar[1]), 0x9966cc)
                                sampAddChatMessage('', 0x9966cc)
                                sampAddChatMessage(' {ffffff}~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~', 0x9966cc)
                                gmegafid = incar[1]
                                gmegaflvl = sampGetPlayerScore(incar[1])
                                gmegaffrak = sampGetFraktionBySkin(incar[1])
                                gmegafcar = tCarsName[carhm-399]
                            end
                        end
                    else
                        if cfg.main.megaf then
                            if not imegaf.v then imegaf.v = true end
                        else
                            for k, v in pairs(incar) do
                                local result, ped = sampGetCharHandleBySampPlayerId(v)
                                if doesCharExist(ped) then
                                    local carh = storeCarCharIsInNoSave(ped)
                                    local carhm = getCarModel(carh)
                                    sampSendChat(("/m Водитель а/м %s [EVL%sX]"):format(tCarsName[carhm-399], v))
                                    wait(1400)
                                    sampSendChat("/m Прижмитесь к обочине или мы откроем огонь!")
                                    wait(300)
                                    sampAddChatMessage(' {ffffff}~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~', 0x9966cc)
                                    sampAddChatMessage('', 0x9966cc)
                                    sampAddChatMessage(' {ffffff}Ник: {9966cc}'..sampGetPlayerNickname(v)..' ['..v..']', 0x9966cc)
                                    sampAddChatMessage(' {ffffff}Уровень: {9966cc}'..sampGetPlayerScore(v), 0x9966cc)
                                    sampAddChatMessage(' {ffffff}Фракция: {9966cc}'..sampGetFraktionBySkin(v), 0x9966cc)
                                    sampAddChatMessage('', 0x9966cc)
                                    sampAddChatMessage(' {ffffff}~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~', 0x9966cc)
                                    gmegafid = v
                                    gmegaflvl = sampGetPlayerScore(v)
                                    gmegaffrak = sampGetFraktionBySkin(v)
                                    gmegafcar = tCarsName[carhm-399]
                                    break
                                end
                            end
                        end
                    end
                end
            else
                ftext("Вам необходимо сидеть в транспорте")
            end
        end)
    end
end

function dkld()
    if cfg.main.group == 'ПД/ФБР' then
        if isCharInAnyCar(PLAYER_PED) then
            if post ~= 7 and post ~= 12 and post ~= 13 and post ~= 14 and post ~= 18 and post ~= 21 and post ~= 22 and post ~= 23 and post ~= 24 and post ~= 25 and post ~= 26 and post ~= 27 and post ~= 28 and post ~= 29 and post ~= 30 and post ~= 31 then
                if getCarSpeed(storeCarCharIsInNoSave(PLAYER_PED)) > 0 then
                    if frak == 'LSPD' then
                        if not cfg.main.tarb  then
                            sampSendChat('/r Патруль г. Лос-Сантос. '..naparnik())
                        else
                            sampSendChat('/r ['..cfg.main.tar..']: Патруль г. Лос-Сантос. '..naparnik())
                        end
                    elseif frak == 'SFPD' then
                        if not cfg.main.tarb then
                            sampSendChat('/r Патруль г. Сан-Фиерро. '..naparnik())
                        else
                            sampSendChat('/r ['..cfg.main.tar..']: Патруль г. Сан-Фиерро. '..naparnik())
                        end
                    elseif frak == 'LVPD' then
                        if not cfg.main.tarb then
                            sampSendChat('/r Патруль г. Лас-Вентурас. '..naparnik())
                        else
                            sampSendChat('/r ['..cfg.main.tar..']: Патруль г. Лас-Вентурас. '..naparnik())
                        end
                    end
                else
                    if post ~= nil then
                        if getNameSphere(post) ~= nil then
                            if not cfg.main.tarb then
                                sampSendChat('/r Пост: '..getNameSphere(post)..'. '..naparnik())
                            else
                                sampSendChat('/r ['..cfg.main.tar..']: Пост: '..getNameSphere(post)..'. '..naparnik())
                            end
                        end
                    else
                        if frak == 'LSPD' then
                            if not cfg.main.tarb  then
                                sampSendChat('/r Патруль г. Лос-Сантос. '..naparnik())
                            else
                                sampSendChat('/r ['..cfg.main.tar..']: Патруль г. Лос-Сантос. '..naparnik())
                            end
                        elseif frak == 'SFPD' then
                            if not cfg.main.tarb then
                                sampSendChat('/r Патруль г. Сан-Фиерро. '..naparnik())
                            else
                                sampSendChat('/r ['..cfg.main.tar..']: Патруль г. Сан-Фиерро. '..naparnik())
                            end
                        elseif frak == 'LVPD' then
                            if not cfg.main.tarb then
                                sampSendChat('/r Патруль г. Лас-Вентурас. '..naparnik())
                            else
                                sampSendChat('/r ['..cfg.main.tar..']: Патруль г. Лас-Вентурас. '..naparnik())
                            end
                        end
                    end
                end
            end
            if post == 7 or post == 12 or post == 13 or post == 14 or post == 18 then
                if not cfg.main.tarb then
                    sampSendChat('/r Пост: '..getNameSphere(post)..'. '..naparnik())
                else
                    sampSendChat('/r ['..cfg.main.tar..']: Пост: '..getNameSphere(post)..'. '..naparnik())
                end
            end
            if post == 21 then
                if not cfg.main.tarb then
                    sampSendChat('/r Патруль опасного района. '..naparnik())
                else
                    sampSendChat('/r ['..cfg.main.tar..']: Патруль опасного района. '..naparnik())
                end
            end
            if post == 22 then
                if cfg.main.tar == nil then
                    sampSendChat('/r Патруль ЛВа. '..naparnik())
                else
                    sampSendChat('/r ['..cfg.main.tar..']: Патруль ЛВа. '..naparnik())
                end
            end
            lua_thread.create(function()
                if post == 23 then
                    if frak == 'LSPD' then
                        sampSendChat('/d SFPD, пересекаю вашу юрисдикцию, погоня.')
                    elseif frak == 'SFPD' then
                        sampSendChat('/d LSPD, пересекаю вашу юрисдикцию, погоня.')
                    elseif frak == 'LVPD' then
                        submenus_show(yrisdkld1404, '{9966CC}'..script.this.name..'{ffffff} | Пересечение юрисдикции')
                    end
                end
                if post == 24 then
                    if frak == 'LSPD' then
                        sampSendChat('/d LVPD, пересекаю вашу юрисдикцию, погоня.')
                    elseif frak == 'LVPD' then
                        sampSendChat('/d LSPD, пересекаю вашу юрисдикцию, погоня.')
                    elseif frak == 'SFPD' then
                        submenus_show(yrisdkld1405, '{9966CC}'..script.this.name..'{ffffff} | Пересечение юрисдикции')
                    end
                end
                if post == 25 then
                    if frak == 'LSPD' then
                        sampSendChat('/d LVPD, пересекаю вашу юрисдикцию, погоня.')
                    elseif frak == 'LVPD' then
                        sampSendChat('/d LSPD, пересекаю вашу юрисдикцию, погоня.')
                    elseif frak == 'SFPD' then
                        submenus_show(yrisdkld1405, '{9966CC}'..script.this.name..'{ffffff} | Пересечение юрисдикции')
                    end
                end
                if post == 26 then
                    if frak == 'LSPD' then
                        sampSendChat('/d LVPD, пересекаю вашу юрисдикцию, погоня.')
                    elseif frak == 'LVPD' then
                        sampSendChat('/d LSPD, пересекаю вашу юрисдикцию, погоня.')
                    elseif frak == 'SFPD' then
                        submenus_show(yrisdkld1405, '{9966CC}'..script.this.name..'{ffffff} | Пересечение юрисдикции')
                    end
                end
                if post == 27 then
                    if frak == 'LVPD' then
                        sampSendChat('/d SFPD, пересекаю вашу юрисдикцию, погоня.')
                    elseif frak == 'SFPD' then
                        sampSendChat('/d LVPD, пересекаю вашу юрисдикцию, погоня.')
                    elseif frak == 'LSPD' then
                        submenus_show(yrisdkld1406, '{9966CC}'..script.this.name..'{ffffff} | Пересечение юрисдикции')
                    end
                end
                if post == 28 then
                    if frak == 'LVPD' then
                        sampSendChat('/d SFPD, пересекаю вашу юрисдикцию, погоня.')
                    elseif frak == 'SFPD' then
                        sampSendChat('/d LVPD, пересекаю вашу юрисдикцию, погоня.')
                    elseif frak == 'LSPD' then
                        submenus_show(yrisdkld1406, '{9966CC}'..script.this.name..'{ffffff} | Пересечение юрисдикции')
                    end
                end
                if post == 29 then
                    if frak == 'LSPD' then
                        sampSendChat('/d SFPD, пересекаю вашу юрисдикцию, погоня.')
                    elseif frak == 'SFPD' then
                        sampSendChat('/d LSPD, пересекаю вашу юрисдикцию, погоня.')
                    elseif frak == 'LVPD' then
                        submenus_show(yrisdkld1404, '{9966CC}'..script.this.name..'{ffffff} | Пересечение юрисдикции')
                    end
                end
                if post == 30 then
                    if frak == 'LSPD' then
                        sampSendChat('/d SFPD, пересекаю вашу юрисдикцию, погоня.')
                    elseif frak == 'SFPD' then
                        sampSendChat('/d LSPD, пересекаю вашу юрисдикцию, погоня.')
                    elseif frak == 'LVPD' then
                        submenus_show(yrisdkld1404, '{9966CC}'..script.this.name..'{ffffff} | Пересечение юрисдикции')
                    end
                end
                if post == 31 then
                    if frak == 'LSPD' then
                        sampSendChat('/d SFPD, пересекаю вашу юрисдикцию, погоня.')
                    elseif frak == 'SFPD' then
                        sampSendChat('/d LSPD, пересекаю вашу юрисдикцию, погоня.')
                    elseif frak == 'LVPD' then
                        submenus_show(yrisdkld1404, '{9966CC}'..script.this.name..'{ffffff} | Пересечение юрисдикции')
                    end
                end
            end)
        end
        if not isCharInAnyCar(PLAYER_PED) then
            if post ~= nil then
                if getNameSphere(post) ~= nil then
                    if not cfg.main.tarb then
                        sampSendChat('/r Пост: '..getNameSphere(post)..'. '..naparnik())
                    else
                        sampSendChat('/r ['..cfg.main.tar..']: Пост: '..getNameSphere(post)..'. '..naparnik())
                    end
                end
            end
        end
    end
end

function kmdc(pam)
    lua_thread.create(function()
        local id = tonumber(pam)
        if id ~= nil then
            if sampIsPlayerConnected(id) then
                sampSendChat(("/me %s КПК и %s фотографию человека"):format(cfg.main.male and 'достал' or 'достала', cfg.main.male and 'сделал' or 'сделала'))
                wait(cfg.commands.zaderjka)
                sampSendChat(("/do КПК дал информацию: Имя: %s."):format(sampGetPlayerNickname(id):gsub('_', ' ')))
                wait(cfg.commands.zaderjka)
                sampSendChat(("/mdc %s"):format(id))
                if cfg.commands.kmdctime then
                    wait(1400)
                    sampSendChat("/time")
                    wait(500)
                    setVirtualKeyDown(key.VK_F8, true)
                    wait(150)
                    setVirtualKeyDown(key.VK_F8, false)
                end
            else
                ftext("Игрок оффлайн")
            end
        else
            ftext("Введите: /kmdc [id]")
        end
    end)
end

function fvz(pam)
    local id = tonumber(pam)
    local _, myid = sampGetPlayerIdByCharHandle(playerPed)
    if frak == 'FBI' then
        if id == nil then
            ftext("Введите: /fvz [id]")
        end
        if id ~= nil and sampIsPlayerConnected(id) then
            lua_thread.create(function()
                warnst = true
                sampSendChat('/mdc '..id)
                wait(1400)
                if wfrac == 'LSPD' or wfrac == 'SFPD' or wfrac == 'LVPD' or wfrac == 'LVa' or wfrac == 'SFa' then
                    sampSendChat(string.format('/d %s, %s, явитесь в офис ФБР со старшими. Как приняли? Ответ на пдж.%s', wfrac, sampGetPlayerNickname(id):gsub('_', ' '), myid))
                else
                    ftext('Человек не является сотрудником PD/Army')
                end
                warnst = false
                wfrac = nil
            end)
        end
    else
        ftext("Вы не сотрудник ФБР")
    end
end

function ftazer(pam)
    lua_thread.create(function()
        local id = tonumber(pam)
        if cfg.commands.ftazer then
            if id ~= nil then
                if id >=1 and id <=3 then
                    sampSendChat(("/me %s из внутреннего кармана беруши"):format(cfg.main.male and 'достал' or 'достала'))
                    wait(1400)
                    sampSendChat(("/me %s беруши и %s"):format(cfg.main.male and 'надел' or 'надела', cfg.main.male and 'зажмурился' or 'зажмурилась'))
                    wait(1400)
                    sampSendChat(("/me %s светошумовую гранату"):format(cfg.main.male and 'бросил' or 'бросила'))
                    wait(1400)
                    sampSendChat(("/ftazer %s"):format(id))
                else
                    ftext("Значение не может быть ментше 1 и больше 3!")
                end
            else
                ftext("Введите: /ftazer [тип]")
            end
        else
            sampSendChat(("/ftazer %s"):format(pam))
        end
    end)
end

function df()
    lua_thread.create(function()
        submenus_show(dfmenu, "{9966cc}"..script.this.name.." {ffffff}| Bomb Menu")
    end)
end

function fbd(pam)
    local id = tonumber(pam)
    if frak == 'FBI' then
        if id == nil then
            ftext("Введите: /fbd [id]")
        end
        if id ~= nil and sampIsPlayerConnected(id) then
            lua_thread.create(function()
                local _, myid = sampGetPlayerIdByCharHandle(playerPed)
                warnst = true
                sampSendChat('/mdc '..id)
                wait(1400)
                if wfrac == 'LSPD' or wfrac == 'SFPD' or wfrac == 'LVPD' then
                    sampSendChat(string.format('/d %s, %s, Причина изменения БД на п.%s', wfrac, sampGetPlayerNickname(id):gsub('_', ' '), myid))
                else
                    ftext('Человек не является сотрудником PD')
                end
                warnst = false
                wfrac = nil
            end)
        end
    else
        ftext("Вы не сотрудник ФБР")
    end
end

function cc()
    memory.fill(sampGetChatInfoPtr() + 306, 0x0, 25200)
    memory.write(sampGetChatInfoPtr() + 306, 25562, 4, 0x0)
    memory.write(sampGetChatInfoPtr() + 0x63DA, 1, 1)
end

function blg(pam)
    local id, frack, pric = pam:match('(%d+) (%a+) (.+)')
    if id and frack and pric and sampIsPlayerConnected(id) then
        name = sampGetPlayerNickname(id)
        rpname = name:gsub('_', ' ')
        sampSendChat(string.format("/d %s, благодарю %s за %s. Цените", frack, rpname, pric))
    else
        ftext("Введите: /blg [id] [Фракция] [Причина]", -1)
    end
end

function mcheck()
    peds = getAllChars()
    if peds ~= nil then
        local openw = io.open("moonloader/fbitools/mcheck.txt", 'a')
        openw:write('\n')
        openw:write(os.date()..'\n')
        openw:close()
        lua_thread.create(function()
            for _, hm in pairs(peds) do
                _ , id = sampGetPlayerIdByCharHandle(hm)
                _ , m = sampGetPlayerIdByCharHandle(PLAYER_PED)
                if id ~= -1 and id ~= m and doesCharExist(hm) and sampIsPlayerConnected(id) then
                    local x, y, z = getCharCoordinates(hm)
                    local mx, my, mz = getCharCoordinates(PLAYER_PED)
                    local dist = getDistanceBetweenCoords3d(mx, my, mz, x, y, z)
                    if dist <= 200 then
                        mcheckb = true
                        _ , idofplayercar = sampGetPlayerIdByCharHandle(hm)
                        sampSendChat('/mdc '..idofplayercar)
                        wait(1400)
                        mcheckb = false
                    end
                end
            end
        end)
    end
end

function dlog()
    sampShowDialog(97987, '{9966cc}'..script.this.name..' {ffffff} | Лог сообщений департамента', table.concat(departament, '\n'), '»', 'x', 0)
end

function rlog()
    sampShowDialog(97987, '{9966cc}'..script.this.name..' {ffffff} | Лог сообщений рации', table.concat(radio, '\n'), '»', 'x', 0)
end

function sulog()
    sampShowDialog(97987, '{9966cc}'..script.this.name..' {ffffff} | Лог выдачи розыска', table.concat(wanted, '\n'), '»', 'x', 0)
end

function smslog()
    sampShowDialog(97987, '{9966cc}'..script.this.name..' {ffffff} | Лог SMS', table.concat(sms, '\n'), '»', 'x', 0)
end

function ticket(pam)
    lua_thread.create(function()
        local id, summa, reason = pam:match('(%d+) (%d+) (.+)')
        if id and summa and reason then
            if cfg.commands.ticket then
                sampSendChat(string.format("/me %s бланк и ручку", cfg.main.male and 'достал' or 'достала'))
                wait(cfg.commands.zaderjka)
                sampSendChat("/do Бланк и ручка в руках.")
                wait(cfg.commands.zaderjka)
                sampSendChat("/me начинает заполнять бланк")
                wait(cfg.commands.zaderjka)
                sampSendChat("/do Бланк заполнен.")
                wait(cfg.commands.zaderjka)
                sampSendChat(string.format("/me %s бланк нарушителю", cfg.main.male and 'передал' or 'передала'))
                wait(1400)
            end
            sampSendChat(string.format('/ticket %s %s %s', id, summa, reason))
        else
            ftext('Введите: /ticket [id] [сумма] [причина]')
        end
    end)
end

function ssuz(pam)
    suz = {}
    local dsuz = {}
    for line in io.lines('moonloader\\fbitools\\su.txt') do
        table.insert(suz, line)
    end
    for k, v in pairs(suz) do
        table.insert(dsuz, string.format('{9966cc}%s. {ffffff}%s', k, v))
    end
    if pam:match('(%d+) (%d+)') then
        zid, zsu = pam:match('(%d+) (%d+)')
        if sampIsPlayerConnected(tonumber(zid)) then
            for k, v in pairs(suz) do
                if tonumber(zsu) == k then
                    local reas, zzv = v:match('(.+) %- (%d+) .+')
                    sampSendChat(string.format('/su %s %s %s', zid, zzv, reas))
                    zid = nil
                end
            end
        end
    elseif pam:match('(%d+)') then
        zid = pam:match('(%d+)')
        if sampIsPlayerConnected(tonumber(zid)) then
            sampShowDialog(1765, '{9966cc}'..script.this.name..' {ffffff}| Выдача розыска игроку {9966cc}'..sampGetPlayerNickname(tonumber(zid)).. '[' ..zid.. ']', table.concat(dsuz, '\n').. '\n\n{ffffff}Выберите номер для объявления в розыск. Пример: 15', '»', 'x', 1)
        end
    elseif #pam == 0 then
        ftext('Введите: /z [id] [параметр(не опционально)]')
    end
end

function rt(pam)
    if #pam == 0 then
        ftext("Введите /rt [текст]")
    else
        sampSendChat('/r '..pam)
    end
end

function ooplist(pam)
    lua_thread.create(function()
        local oopid = tonumber(pam)
        if oopid ~= nil and sampIsPlayerConnected(oopid) then
            for k, v in pairs(ooplistt) do
                sampSendChat('/sms '..oopid..' '..v)
                wait(1400)
            end
        else
            sampShowDialog(2458, '{9966cc}'..script.this.name..' | {ffffff}Список ООП', table.concat(ooplistt, '\n'), '»', "x", 2)
            ftext('Для отправки списка ООП адвокату введите /ooplist [id]')
        end
    end)
end

function fkv(pam)
    if #pam ~= 0 then
        kvadY, kvadX = string.match(pam, "(%A)-(%d+)")
        if kvadrat(kvadY) ~= nil and kvadX ~= nil and kvadY ~= nil and tonumber(kvadX) < 25 and tonumber(kvadX) > 0 then
            last = lcs
            coordX = kvadX * 250 - 3125
            coordY = (kvadrat1(kvadY) * 250 - 3125) * - 1
        end
    else
        ftext('Введите: /fkv [квадрат]')
        ftext('Пример: /fkv Л-6')
    end
end

function fnr()
    lua_thread.create(function()
        vixodid = {}
		fnrstatus = true
		sampSendChat('/members')
        while not gotovo do wait(0) end
        wait(1400)
        for k, v in pairs(vixodid) do
            sampSendChat('/sms '..v..' На работу')
            wait(1400)
        end
		gotovo = false
        status = false
	end)
end

function strobes()
	while true do
		if isCharInAnyCar(PLAYER_PED) and not isCharInAnyBoat(PLAYER_PED) and not isCharInFlyingVehicle(PLAYER_PED) and not isCharOnAnyBike(PLAYER_PED) and not isCharInAnyTrain(PLAYER_PED) then
			if cfg.main.strobs then
				local car = storeCarCharIsInNoSave(PLAYER_PED)
				if doesVehicleExist(car) then
					local veh_struct = getCarPointer(car) + 1440
					if isCarSirenOn(car) then
						callMethod(0x6C2100, veh_struct, 2, 1, 0, 1)
						callMethod(0x6C2100, veh_struct, 2, 1, 1, 0)
						wait(300)
						callMethod(0x6C2100, veh_struct, 2, 1, 0, 0)
						callMethod(0x6C2100, veh_struct, 2, 1, 1, 1)
					else
						callMethod(0x6C2100, veh_struct, 2, 1, 0, 0)
						callMethod(0x6C2100, veh_struct, 2, 1, 1, 0)
					end
				end
			end
		end
		wait(300)
	end
end
function screen() local memory = require 'memory' memory.setuint8(sampGetBase() + 0x119CBC, 1) end

function Player:new(id, sRang, iRang, status, invite, afk, sec, nick)
	local obj = {
		id = id,
		nickname = nick,
		iRang = tonumber(iRang),
		sRang = u8(sRang),
		status = u8(status),
		invite = invite,
		afk = afk,
		sec = tonumber(sec)
	}

	setmetatable(obj, self)
	self.__index = self

	return obj
end
function getColorForSeconds(sec)
	if sec > 0 and sec <= 50 then
		return imgui.ImVec4(1, 1, 0, 1)
	elseif sec > 50 and sec <= 100 then
		return imgui.ImVec4(1, 159/255, 32/255, 1)
	elseif sec > 100 and sec <= 200 then
		return imgui.ImVec4(1, 93/255, 24/255, 1)
	elseif sec > 200 and sec <= 300 then
		return imgui.ImVec4(1, 43/255, 43/255, 1)
	elseif sec > 300 then
		return imgui.ImVec4(1, 0, 0, 1)
	end
end
function getColor(ID)
	PlayerColor = sampGetPlayerColor(ID)
	a, r, g, b = explode_argb(PlayerColor)
	return r/255, g/255, b/255, 1
end
function explode_argb(argb)
    local a = bit.band(bit.rshift(argb, 24), 0xFF)
    local r = bit.band(bit.rshift(argb, 16), 0xFF)
    local g = bit.band(bit.rshift(argb, 8), 0xFF)
    local b = bit.band(argb, 0xFF)
    return a, r, g, b
end

function pr()
    lua_thread.create(function()
        sampSendChat("Вы арестованы, у вас есть право хранить молчание. Всё, что вы скажете, может и будет использовано против вас в суде.")
        wait(cfg.commands.zaderjka)
        sampSendChat("У вас есть право на адвоката и на один телефонный звонок. Вам понятны ваши права?")
    end)
end

function getCompl()
    local t = {}
    if cfg.autobp.armour then table.insert(t, 5) end
    if cfg.autobp.spec then table.insert(t, 6) end
    if cfg.autobp.deagle then 
        table.insert(t, 0)
        if cfg.autobp.dvadeagle then table.insert(t, 0) end
    end
    if cfg.autobp.shot then 
        table.insert(t, 1)
        if cfg.autobp.dvashot then table.insert(t, 1) end
    end
    if cfg.autobp.smg then 
        table.insert(t, 2)
        if cfg.autobp.dvasmg then table.insert(t, 2) end
    end
    if cfg.autobp.m4 then 
        table.insert(t, 3)
        if cfg.autobp.dvam4 then table.insert(t, 3) end
    end
    if cfg.autobp.rifle then 
        table.insert(t, 4)
        if cfg.autobp.dvarifle then table.insert(t, 4) end
    end
    return t
end

function getAmmoInClip()
	local struct = getCharPointer(PLAYER_PED)
	local prisv = struct + 0x0718
	local prisv = memory.getint8(prisv, false)
	local prisv = prisv * 0x1C
	local prisv2 = struct + 0x5A0
	local prisv2 = prisv2 + prisv
	local prisv2 = prisv2 + 0x8
	local ammo = memory.getint32(prisv2, false)
	return ammo
end

function getFreeCost(lvl)
	if lvl >= 1 and lvl <= 2 then cost = 1000 end
	if lvl >= 3 and lvl <= 6 then cost = 3000 end
	if lvl >= 7 and lvl <= 13 then cost = 6000 end
	if lvl >= 14 and lvl <= 23 then cost = 9000 end
	if lvl >= 24 and lvl <= 35 then cost = 14000 end
	if lvl >= 36 then cost = 15000 end
	return cost
end

function string.split(inputstr, sep, limit)
    if limit == nil then limit = 0 end
    if sep == nil then sep = "%s" end
    local t={} ; i=1
    for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
        if i >= limit and limit > 0 then
            if t[i] == nil then
                t[i] = ""..str
            else
                t[i] = t[i]..sep..str
            end
        else
            t[i] = str
            i = i + 1
        end
    end
    return t
end

function registerCommandsBinder()
    for k, v in pairs(commands) do
        if sampIsChatCommandDefined(v.cmd) then sampUnregisterChatCommand(v.cmd) end
        sampRegisterChatCommand(v.cmd, function(pam)
            lua_thread.create(function()
                local params = string.split(pam, " ", v.params)
                local cmdtext = v.text
                if #params < v.params then
                    local paramtext = ""
                    for i = 1, v.params do
                        paramtext = paramtext .. "[параметр"..i.."] "
                    end
                    ftext("Введите: /"..v.cmd.." "..paramtext, -1)
                else
                    for line in cmdtext:gmatch('[^\r\n]+') do

                        if line:match("^{wait%:%d+}$") then
                            wait(line:match("^%{wait%:(%d+)}$"))
                        elseif line:match("^{screen}$") then
                            screen()
                        else
                            local bIsEnter = string.match(line, "^{noe}(.+)") ~= nil
                            local bIsF6 = string.match(line, "^{f6}(.+)") ~= nil
                            local keys = {
                                ["{f6}"] = "",
                                ["{noe}"] = "",
                                ["{myid}"] = select(2, sampGetPlayerIdByCharHandle(PLAYER_PED)),
                                ["{kv}"] = kvadrat(),
                                ["{targetid}"] = targetid,
                                ["{targetrpnick}"] = sampGetPlayerNicknameForBinder(targetid):gsub('_', ' '),
                                ["{naparnik}"] = naparnik(),
                                ["{myrpnick}"] = sampGetPlayerNickname(select(2, sampGetPlayerIdByCharHandle(PLAYER_PED))):gsub("_", " "),
                                ["{smsid}"] = smsid,
                                ["{smstoid}"] = smstoid,
                                ["{rang}"] = rang,
                                ["{frak}"] = frak,
                                ["{megafid}"] = gmegafid,
                                ["{dl}"] = mcid
                            }
                            for k1, v1 in pairs(keys) do
                                line = line:gsub(k1, v1)
                            end

                            if not bIsEnter then
                                if bIsF6 then
                                    sampProcessChatInput(line)
                                else
                                    sampSendChat(line)
                                end
                            else
                                sampSetChatInputText(line)
                                sampSetChatInputEnabled(true)
                            end
                        end
                    end
                end
            end)
        end)
    end
end