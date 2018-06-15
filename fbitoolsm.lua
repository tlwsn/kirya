local sf = require 'sampfuncs'
local key = require "vkeys"
local inicfg = require 'inicfg'
require 'lib.sampfuncs'
seshsps = 1

local osnova =
{
  {
    title = "Лаборатория",
    onclick = function()
      local _, myid = sampGetPlayerIdByCharHandle(PLAYER_PED)
      sampSendChat("/r Переоделся в сотрудника лаборатории.")
      wait(1500)
      sampSendChat("/rb "..myid)
    end
  },
  {
    title = 'Гражданский',
    onclick = function()
      sampShowDialog(1385, '{9966cc}FBI Tools {ffffff}| Mask Reason', 'Введите причину', 'Отправить', '', 1)
    end
  },
  {
    title = 'Полиция',
    onclick = function()
      sampShowDialog(1386, '{9966cc}FBI Tools {ffffff}| Mask Reason', 'Введите причину', 'Отправить', '', 1)
    end
  },
  {
    title = 'Армия',
    onclick = function()
      sampShowDialog(1387, '{9966cc}FBI Tools {ffffff}| Mask Reason', 'Введите причину', 'Отправить', '', 1)
    end
  },
  {
    title = 'МЧС',
    onclick = function()
      sampShowDialog(1388, '{9966cc}FBI Tools {ffffff}| Mask Reason', 'Введите причину', 'Отправить', '', 1)
    end
  },
  {
    title = 'Мэрия',
    onclick = function()
      sampShowDialog(1389, '{9966cc}FBI Tools {ffffff}| Mask Reason', 'Введите причину', 'Отправить', '', 1)
    end
  },
  {
    title = 'Автошкола',
    onclick = function()
      sampShowDialog(1390, '{9966cc}FBI Tools {ffffff}| Mask Reason', 'Введите причину', 'Отправить', '', 1)
    end
  },
  {
    title = 'News',
    onclick = function()
      sampShowDialog(1391, '{9966cc}FBI Tools {ffffff}| Mask Reason', 'Введите причину', 'Отправить', '', 1)
    end
  },
  {
    title = 'LCN',
    onclick = function()
      sampShowDialog(1392, '{9966cc}FBI Tools {ffffff}| Mask Reason', 'Введите причину', 'Отправить', '', 1)
    end
  },
  {
    title = 'Yakuza',
    onclick = function()
      sampShowDialog(1393, '{9966cc}FBI Tools {ffffff}| Mask Reason', 'Введите причину', 'Отправить', '', 1)
    end
  },
  {
    title = 'Russian Mafia',
    onclick = function()
      sampShowDialog(1394, '{9966cc}FBI Tools {ffffff}| Mask Reason', 'Введите причину', 'Отправить', '', 1)
    end
  },
  {
    title = 'Rifa',
    onclick = function()
      sampShowDialog(1395, '{9966cc}FBI Tools {ffffff}| Mask Reason', 'Введите причину', 'Отправить', '', 1)
    end
  },
  {
    title = 'Grove Street',
    onclick = function()
      sampShowDialog(1396, '{9966cc}FBI Tools {ffffff}| Mask Reason', 'Введите причину', 'Отправить', '', 1)
    end
  },
  {
    title = 'Ballas',
    onclick = function()
      sampShowDialog(1397, '{9966cc}FBI Tools {ffffff}| Mask Reason', 'Введите причину', 'Отправить', '', 1)
    end
  },
  {
    title = 'Vagos',
    onclick = function()
      sampShowDialog(1398, '{9966cc}FBI Tools {ffffff}| Mask Reason', 'Введите причину', 'Отправить', '', 1)
    end
  },
  {
    title = 'Aztec',
    onclick = function()
      sampShowDialog(1399, '{9966cc}FBI Tools {ffffff}| Mask Reason', 'Введите причину', 'Отправить', '', 1)
    end
  },
  {
    title = "Байкеры",
    onclick = function()
      sampShowDialog(1400, '{9966cc}FBI Tools {ffffff}| Mask Reason', 'Введите причину', 'Отправить', '', 1)
    end
  }
}

local dfmenu =
{
  {
    title = 'Бомба с часовым механизмом',
    onclick = function()
      sampSendChat("/me достал саперный набор")
      wait(3500)
      sampSendChat("/me открыл саперный набор")
      wait(3500)
      sampSendChat("/me осмотрел взрывное устройство")
      wait(3500)
      sampSendChat("/do Определил тип взрывного устройства. Бомба с часовым механизмом.")
      wait(3500)
      sampSendChat("/do Увидел три провода выходящих с механизма.")
      wait(3500)
      sampSendChat("/me достал нож из саперного набора")
      wait(3500)
      sampSendChat("/me аккуратно зачистил первый провод")
      wait(3500)
      sampSendChat("/try достал отвертку с индикатором и прислонил край отвертки к оголённом проводу")
end
},
{
  title = 'Бомба с часовым механизмом если {63c600}[Удачно]',
  onclick = function()
    sampSendChat("/me перерезал проводок")
    wait(3500)
    sampSendChat("/me прислушался к устройству")
    wait(3500)
    sampSendChat("/do Механизм перестал издавать тикающие звуки.")
    wait(3500)
    sampSendChat("/do Бомба обезврежена.")
    wait(3500)
    sampSendChat("/me сложил инструменты обратно в саперный набор")
    wait(3500)
    sampSendChat("/me достал бронированный кейс и аккуратно сложил туда бомбу")
  end
},
{
  title = 'Бомба с часовым механизмом если {bf0000}[Неудачно]',
  onclick = function()
    sampSendChat("/me аккуратно зачистил второй провод")
    wait(3500)
    sampSendChat("/me перерезал проводок")
    wait(3500)
    sampSendChat("/me прислушался к устройству")
    wait(3500)
    sampSendChat("/do Механизм перестал издавать тикающие звуки.")
    wait(3500)
    sampSendChat("/do Бомба обезврежена.")
    wait(3500)
    sampSendChat("/me сложил инструменты обратно в саперный набор")
    wait(3500)
    sampSendChat("/me достал бронированный кейс и аккуратно сложил туда бомбу")
  end
},
{
  title = 'Бомба с дистанционным управлением',
  onclick = function()
    sampSendChat("/me достал саперный набор")
    wait(3500)
    sampSendChat("/me открыл саперный набор")
    wait(3500)
    sampSendChat("/me осмотрел взрывное устройство")
    wait(3500)
    sampSendChat("/do Определил тип взрывного устройства. Бомба с часовым механизмом.")
    wait(3500)
    sampSendChat("/do Увидел два шурупа на блоке с механизмом.")
    wait(3500)
    sampSendChat("/me достал отвертку из саперного набора")
    wait(3500)
    sampSendChat("/me аккуратно выкручивает шуруп")
    wait(3500)
    sampSendChat("/me отодвинул крышку блока и увидел антенну")
    wait(3500)
    sampSendChat("/do Увидел красный мигающий индикатор.")
    wait(3500)
    sampSendChat("/me просмотрел путь микросхемы от антенны к детонатору")
    wait(3500)
    sampSendChat("/me увидел два провода")
    wait(3500)
    sampSendChat("/try перерезал первый провод. Индикатор перестал мигать.")
  end
},
{
  title = 'Бомба с дистанционным управлением если {63c600}[Удачно]',
  onclick = function()
    sampSendChat("/do Бомба обезврежена.")
    wait(3500)
    sampSendChat("/me сложил инструменты обратно в саперный набор")
    wait(3500)
    sampSendChat("/me достал бронированный кейс и аккуратно сложил туда бомбу")
  end
},
{
  title = 'Бомба с дистанционным управлением если {bf0000}[Неудачно]',
  onclick = function()
    sampSendChat("/me перерезал второй провод")
    wait(3500)
    sampSendChat("/do Индикатор перестал мигать.")
    wait(3500)
    sampSendChat("/do Бомба обезврежена.")
    wait(3500)
    sampSendChat("/me сложил инструменты обратно в саперный набор")
    wait(3500)
    sampSendChat("/me достал бронированный кейс и аккуратно сложил туда бомбу")
  end
},
{
  title = 'Бомба с активационным кодом',
  onclick = function()
    sampSendChat("/me достал саперный набор")
    wait(3500)
    sampSendChat("/me открыл саперный набор")
    wait(3500)
    sampSendChat("/me осмотрел взрывное устройство")
    wait(3500)
    sampSendChat("/do Определил тип взрывного устройства. Бомба с активационным кодом.")
    wait(3500)
    sampSendChat("/me достал из саперного набора прибор для подбора кода")
    wait(3500)
    sampSendChat("/me подключил прибор к бомбе")
    wait(3500)
    sampSendChat("/do На приборе высветилось: Ожидание получения пароля.")
    wait(3500)
    sampSendChat("/do На приборе высветилось: Пароль 5326.")
    wait(3500)
    sampSendChat("/try ввёл полученный пароль. Экран бомбы выключился")
  end
},
{
  title = 'Бомба с активационным кодом если {63c600}[Удачно]',
  onclick = function()
    sampSendChat("/do Бомба обезврежена.")
    wait(3500)
    sampSendChat("/me сложил инструменты обратно в саперный набор")
    wait(3500)
    sampSendChat("/me достал бронированный кейс и аккуратно сложил туда бомбу")
  end
},
{
  title = 'Бомба с активационным кодом если {bf0000}[Неудачно]',
  onclick = function()
    sampSendChat("/me перезагрузил(а) прибор")
    wait(3500)
    sampSendChat("/do На приборе высветилось: Ожидание получения пароля.")
    wait(3500)
    sampSendChat("/do На приборе высветилось: Пароль 3789.")
    wait(3500)
    sampSendChat("/me ввёл полученный пароль")
    wait(3500)
    sampSendChat("/Экран бомбы выключился")
    wait(3500)
    sampSendChat("/do Бомба обезврежена.")
    wait(3500)
    sampSendChat("/me сложил инструменты обратно в саперный набор")
    wait(3500)
    sampSendChat("/me достал бронированный кейс и аккуратно сложил туда бомбу")
  end
}
}

function submenus_show(menu, caption, select_button, close_button, back_button)
    select_button, close_button, back_button = select_button or 'Select', close_button or 'Close', back_button or 'Back'
    prev_menus = {}
    function display(menu, id, caption)
        local string_list = {}
        for i, v in ipairs(menu) do
            table.insert(string_list, type(v.submenu) == 'table' and v.title .. '  >>' or v.title)
        end
        sampShowDialog(id, caption, table.concat(string_list, '\n'), select_button, (#prev_menus > 0) and back_button or close_button, sf.DIALOG_STYLE_LIST)
        repeat
            wait(0)
            local result, button, list = sampHasDialogRespond(id)
            if result then
                if button == 1 and list ~= -1 then
                    local item = menu[list + 1]
                    if type(item.submenu) == 'table' then -- submenu
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
                else -- if button == 0
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

function pkmmenu(id)
  return
  {
    {
      title = "{ffffff}» Надеть наручники",
      onclick = function()
        sampSendChat("/me заломал руки "..sampGetPlayerNickname(id).." и достал наручники")
        wait(1500)
        sampSendChat("/cuff "..id)
      end
    },
    {
      title = "{ffffff}» Вести за собой",
      onclick = function()
        sampSendChat("/me пристегнул один из концов наручников к себе, после чего повел за собой "..sampGetPlayerNickname(id))
        wait(1500)
        sampSendChat("/follow "..id)
      end
    },
    {
      title = "{ffffff}» Произвести обыск",
      onclick = function()
        sampSendChat("/me надев перчатки, провел руками по торсу")
        wait(1500)
        sampSendChat("/take "..id)
      end
    },
    {
      title = "{ffffff}» Произвести аррест",
      onclick = function()
        sampSendChat("/me достал ключи от камеры, открыв ее")
        wait(1500)
        sampSendChat("/me затолкнул "..sampGetPlayerNickname(id).." в камеру")
        wait(1500)
        sampSendChat("/arrest "..id)
        wait(1500)
        sampSendChat("/me закрыл камеру, убрав ключи в карман")
      end
    },
    {
      title = "{ffffff}» Выдать розыск за проникновение",
      onclick = function()
        sampSendChat("/su "..id.." 2 Проникновение на охр. территорию")
      end
    },
    {
      title = "{ffffff}» Выдать розыск за хранение наркотиков",
      onclick = function()
        sampSendChat("/su "..id.." 3 Хранение наркотиков")
      end
    },
    {
      title = "{ffffff}» Выдать розыск за хранение материалов",
      onclick = function()
        sampSendChat("/su "..id.." 3 Хранение материалов")
      end
    },
    {
      title = "{ffffff}» Выдать розыск за продажу ключей от камеры",
      onclick = function()
        sampSendChat("/su "..id.." 6 Продажа ключей от камеры")
      end
    },
    {
      title = "{ffffff}» Выдать розыск за вооруженное нападение на ПО",
      onclick = function()
        sampSendChat("/su "..id.. " 6 Вооруженное нападение на ПО")
      end
    }
  }
end

function main()
  while not isSampAvailable() do wait(2000) end
  if seshsps == 1 then
    sampAddChatMessage("{9966cc}FBI Tools {ffffff}| Script successfully loaded. Enter: /fthelp to get more information.", -1)
    sampAddChatMessage("{9966cc}FBI Tools {ffffff}| Author: Sesh Jefferson. Remade by Thomas Lawson", -1)
  end
  sampRegisterChatCommand('oop', oop)
  sampRegisterChatCommand('tazer', tazer)
  sampRegisterChatCommand('keys', keys)
  sampRegisterChatCommand('pr', pr)
  sampRegisterChatCommand('su', su)
  sampRegisterChatCommand('ssu', ssu)
  sampRegisterChatCommand("fthelp", fthelp)
  sampRegisterChatCommand('cput', cput)
  sampRegisterChatCommand('ceject', ceject)
  sampRegisterChatCommand('tl', tl)
  sampRegisterChatCommand('st', st)
  sampRegisterChatCommand('deject', deject)
  sampRegisterChatCommand("rh", rh)
  sampRegisterChatCommand('gr', gr)
  sampRegisterChatCommand('warn', warn)
  sampRegisterChatCommand('df', df)
  sampRegisterChatCommand('ms', ms)
  sampRegisterChatCommand('ar', ar)
  sampRegisterChatCommand('kmdc', kmdc)
  while true do wait(0)
    if wasKeyPressed(key.VK_X) and not sampIsChatInputActive() then
      sampSendChat("/tazer")
      wait(1500)
    end
    local valid, ped = getCharPlayerIsTargeting(PLAYER_HANDLE)
    if valid and doesCharExist(ped) then
      local result, id = sampGetPlayerIdByCharHandle(ped)
      if result and wasKeyPressed(key.VK_Z) then
        submenus_show(pkmmenu(id), "{9966cc}FBI Tools {ffffff}| "..sampGetPlayerNickname(id).."["..id.."] ")
      end
    end
      local result, button, list, input = sampHasDialogRespond(1385)
      local result1, button, list, input = sampHasDialogRespond(1386)
      local result2, button, list, input = sampHasDialogRespond(1387)
      local result3, button, list, input = sampHasDialogRespond(1388)
      local result4, button, list, input = sampHasDialogRespond(1389)
      local result5, button, list, input = sampHasDialogRespond(1390)
      local result6, button, list, input = sampHasDialogRespond(1391)
      local result7, button, list, input = sampHasDialogRespond(1392)
      local result8, button, list, input = sampHasDialogRespond(1393)
      local result9, button, list, input = sampHasDialogRespond(1394)
      local result10, button, list, input = sampHasDialogRespond(1395)
      local result11, button, list, input = sampHasDialogRespond(1396)
      local result12, button, list, input = sampHasDialogRespond(1397)
      local result13, button, list, input = sampHasDialogRespond(1398)
      local result14, button, list, input = sampHasDialogRespond(1399)
      local result15, button, list, input = sampHasDialogRespond(1400)
      local _, myid = sampGetPlayerIdByCharHandle(PLAYER_PED)
      if result then
        if button == 1 then
          sampSendChat("/r Переоделся в одежду гражданского. Причина: "..input)
          wait(1500)
          sampSendChat("/rb "..myid)
        end
      end
      if result1 then
        if button == 1 then
          sampSendChat("/r Переоделся в форму полицейского. Причина: "..input)
          wait(1500)
          sampSendChat("/rb "..myid)
        end
      end
      if result2 then
        if button == 1 then
          sampSendChat("/r Переоделся в форму армейского. Причина: "..input)
          wait(1500)
          sampSendChat("/rb "..myid)
        end
      end
      if result3 then
        if button == 1 then
          sampSendChat("/r Переоделся в форму медика. Причина: "..input)
          wait(1500)
          sampSendChat("/rb "..myid)
        end
      end
      if result4 then
        if button == 1 then
          sampSendChat("/r Переоделся в форму работника мэрии. Причина: "..input)
          wait(1500)
          sampSendChat("/rb "..myid)
        end
      end
      if result5 then
        if button == 1 then
          sampSendChat("/r Переоделся в форму работника автошколы. Причина: "..input)
          wait(1500)
          sampSendChat("/rb "..myid)
        end
      end
      if result6 then
        if button == 1 then
          sampSendChat("/r Переоделся в форму работника новостей. Причина: "..input)
          wait(1500)
          sampSendChat("/rb "..myid)
        end
      end
      if result7 then
        if button == 1 then
          sampSendChat("/r Переоделся в форму ЧОП LCN. Причина: "..input)
          wait(1500)
          sampSendChat("/rb "..myid)
        end
      end
      if result8 then
        if button == 1 then
          sampSendChat("/r Переоделся в форму ЧОП Yakuza. Причина: "..input)
          wait(1500)
          sampSendChat("/rb "..myid)
        end
      end
      if result9 then
        if button == 1 then
          sampSendChat("/r Переоделся в форму ЧОП РМ. Причина: "..input)
          wait(1500)
          sampSendChat("/rb "..myid)
        end
      end
      if result10 then
        if button == 1 then
          sampSendChat("/r Переоделся в форму БК Rifa. Причина: "..input)
          wait(1500)
          sampSendChat("/rb "..myid)
        end
      end
      if result11 then
        if button == 1 then
          sampSendChat("/r Переоделся в форму БК Grove. Причина: "..input)
          wait(1500)
          sampSendChat("/rb "..myid)
        end
      end
      if result12 then
        if button == 1 then
          sampSendChat("/r Переоделся в форму БК Ballas. Причина: "..input)
          wait(1500)
          sampSendChat("/rb "..myid)
        end
      end
      if result13 then
        if button == 1 then
          sampSendChat("/r Переоделся в форму БК Vagos. Причина: "..input)
          wait(1500)
          sampSendChat("/rb "..myid)
        end
      end
      if result14 then
        if button == 1 then
          sampSendChat("/r Переоделся в форму БК Aztec. Причина: "..input)
          wait(1500)
          sampSendChat("/rb "..myid)
        end
      end
      if result15 then
        if button == 1 then
          sampSendChat("/r Переоделся в одежду байкеров. Причина: "..input)
          wait(1500)
          sampSendChat("/rb "..myid)
        end
      end
  end
end

function fthelp()
  local fthelp = [[
  {9966cc}Команды:{ffffff}
  {9966cc}/st [id] {ffffff}- Попросить игрока заглушить свое Т/С через мегафон [/m]
  {9966cc}/oop [id] {ffffff}- Написать в волну департамента об ООП
  {9966CC}/warn [id] [departament] {ffffff}- Предупредить игрока в волну департамента о нарушении подачи в розыск
  {9966cc}/su [id] {ffffff}- Выдать розыск через диалог
  {9966cc}/ssu [id] {ffffff}- Выдать розыск через серверную команду
  {9966cc}/cput [id] [seat] {ffffff}- РП отыгровка посадки преступника в автомобиль/мото
  {9966cc}/ceject [id] {ffffff}- РП отыгровка высадки преступника из автомобиля/мото
  {9966CC}/deject [id] {ffffff}- РП отыгровка вытаскивания преступника из автомобиля/мото
  {9966cc}/tl [id] [type] {ffffff}- РП отыгровка изъятия лицензии
  {9966cc}/ms [type] - {ffffff}- РП отыгровка взятия маскировки
  {9966cc}/keys {ffffff}- РП отыгровка сравнения ключей от КПЗ
  {9966cc}/pr {ffffff}- Зачитать права игроку
  {9966cc}/rh [departament] {ffffff}- Запросить патрульный экипаж в текущий квадрат
  {9966cc}/tazer {ffffff}- РП тайзер
  {9966cc}/gr [departament] [reason] {ffffff}- Написать в волну департамента о пересечении юрисдикции
  {9966cc}/df {ffffff}- Открыть диалог с разминированием бомб
  {9966cc}/ar [army]{ffffff} - Попросить разрешение на въезд на военную территорию в волну департамента
  {9966cc}/kmdc [id]{ffffff} - РП отыгровка фотографии человека в КПК (для казино)

  {9966CC}Клавиши:{ffffff}
  {9966cc}ПКМ+Z на игрока {ffffff}- Таргет меню
  {9966cc}X {ffffff}- Быстрая смена /tazer
  ]]
  sampShowDialog(346253, "{9966cc}FBI Tools {ffffff}| Help", fthelp, "OK", "", 0)
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
      title = '{ffffff}» Чистосердечное признание - {ff0000}1 уровень розыска.',
      onclick = function()
        local result = isCharInAnyCar(PLAYER_PED)
        if result then
          sampSendChat("/clear "..args)
          wait(1500)
          sampSendChat("/su "..args.." 1 Чистосердечное признание")
        else
          sampAddChatMessage("{9966CC}FBI Tools {EAEAEA}| You have to be in the car", -1)
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
      title = '{ffffff}» Уход в AFK от арреста - {ff0000}6 уровень розыска.',
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

function oop(args)
  pID = tonumber(args)
  if pID == nil then
    sampAddChatMessage("{9966CC}FBI Tools {EAEAEA}| Enter: /oop ID", -1)
  end
  gint = getActiveInterior()
  if pID ~= nil and sampIsPlayerConnected(pID) then
    if gint == 6 then
      sampSendChat("/d Mayor, дело на имя "..sampGetPlayerNickname(pID):gsub('_', ' ').." рассмотрению не подлежит, ООП, КПЗ LSPD.", -1)
    elseif gint == 10 then
      sampSendChat("/d Mayor, дело на имя "..sampGetPlayerNickname(pID):gsub('_', ' ').." рассмотрению не подлежит, ООП, КПЗ SFPD.", -1)
    elseif gint == 3 then
      sampSendChat("/d Mayor, дело на имя "..sampGetPlayerNickname(pID):gsub('_', ' ').." рассмотрению не подлежит, ООП, КПЗ LVPD.", -1)
    elseif gint ~= 10 and gint ~= 6 and gint ~= 3 then
      sampSendChat("/d Mayor, дело на имя "..sampGetPlayerNickname(pID):gsub('_', ' ').." рассмотрению не подлежит, ООП.", -1)
    end
  else
    sampAddChatMessage("{9966CC}FBI Tools {EAEAEA}| Player with ID: "..args.." is not connected", -1)
  end
end

function tazer()
  lua_thread.create(
  function()
    sampSendChat("/tazer")
    wait(1500)
    sampSendChat("/me сменил тип патронов")
    wait(1500)
  end)
end

function keys()
  lua_thread.create(
  function()
    sampSendChat("/me взял ключ")
    wait(1500)
    sampSendChat("/me сравнивает ключ с ключом от КПЗ")
    wait(1500)
    sampSendChat("/try обнаружил, что ключи идентичны")
    wait(1500)
  end)
end

function pr()
  lua_thread.create(
  function()
    sampSendChat("Вы арестованы, у вас есть право хранить молчание. Всё, что вы скажете, может и будет использовано против вас в суде.")
    wait(4000)
    sampSendChat("У вас есть право на адвоката и на один телефонный звонок. Вам понятны ваши права?")
    wait(1500)
  end)
end

function su(args)
    pID = tonumber(args)
    if pID ~= nil then
        if sampIsPlayerConnected(pID) then
          lua_thread.create(function()
            submenus_show(sumenu(pID), "{9966cc}FBI Tools {ffffff}| "..sampGetPlayerNickname(pID).."["..args.."] ")
          end)
        else
            sampAddChatMessage("{9966CC}FBI Tools {EAEAEA}| Player with ID: "..args.." is not connected", -1)
        end
    else
        sampAddChatMessage("{9966CC}FBI Tools {EAEAEA}| Enter: /su ID", -1)
    end
  end

function ssu(args)
  sampSendChat("/su "..args)
end

function cput(par)
  local id, seat = string.match(par, '(%d+)%s*(%d*)')
  if id == nil or seat == nil then
    sampAddChatMessage("{9966CC}FBI Tools {EAEAEA}| Enter: /cput ID SEAT", -1)
  end
  if id ~= nil and sampIsPlayerConnected(id) then
    if seat == "" or seat < "1" or seat > "3" then
      sampAddChatMessage("{9966CC}FBI Tools {EAEAEA}| Enter: /cput ID SEAT", -1)
    elseif seat == "1" then
      if isCharOnAnyBike(playerPed) then
        lua_thread.create(function()
          sampSendChat("/me посадил "..sampGetPlayerNickname(id).." на сиденье мотоцикла")
          wait(1500)
          sampSendChat("/cput "..id.." 1", -1)
        end)
      else
        lua_thread.create(function()
          sampSendChat("/me открыл дверь автомобиля и затолкнул туда "..sampGetPlayerNickname(id))
          wait(1500)
          sampSendChat("/cput "..id.." 1", -1)
        end)
      end
    elseif seat =="2" then
      if isCharOnAnyBike(playerPed) then
        lua_thread.create(function()
          sampSendChat("/me посадил "..sampGetPlayerNickname(id).." на сиденье мотоцикла")
          wait(1500)
          sampSendChat("/cput "..id.." 1", -1)
        end)
      else
        lua_thread.create(function()
          sampSendChat("/me открыл дверь автомобиля и затолкнул туда "..sampGetPlayerNickname(id))
          wait(1500)
          sampSendChat("/cput "..id.." 2", -1)
        end)
      end
    elseif seat == "3" then
      if isCharOnAnyBike(playerPed) then
        lua_thread.create(function()
          sampSendChat("/me посадил "..sampGetPlayerNickname(id).." на сиденье мотоцикла")
          wait(1500)
          sampSendChat("/cput "..id.." 1", -1)
        end)
      else
        lua_thread.create(function()
          sampSendChat("/me открыл дверь автомобиля и затолкнул туда "..sampGetPlayerNickname(id))
          wait(1500)
          sampSendChat("/cput "..id.." 3", -1)
        end)
      end
    end
  end
end

function ceject(par)
  id = tonumber(par)
  if id == nil then
    sampAddChatMessage("{9966CC}FBI Tools {EAEAEA}| Enter: /ceject ID", -1)
  end
  if id ~= nil and sampIsPlayerConnected(id) then
    if isCharOnAnyBike(playerPed) then
      lua_thread.create(function()
        sampSendChat("/me высадил "..sampGetPlayerNickname(id).." из мотоцикла")
        wait(1500)
        sampSendChat("/ceject "..par, -1)
      end)
    else
      lua_thread.create(function()
        sampSendChat("/me открыл дверь автомобиля и высадил "..sampGetPlayerNickname(id))
        wait(1500)
        sampSendChat("/ceject "..par)
      end)
    end
  end
 end

function tl(par)
  local id, tl = string.match(par, '(%d+)%s*(%d*)')
  if id ~= nil and sampIsPlayerConnected(id) then
    if tl == "" or tl < "1" or tl > "3" or id == nil or tl == nil then
      sampAddChatMessage("{9966CC}FBI Tools {EAEAEA}| Enter: /tl ID TYPE", -1)
      sampAddChatMessage("{9966CC}FBI Tools {EAEAEA}| 1 - DRIVER LICENSE | 2 - GUN LICENSE | 3 - AIR LICENSE", -1)
    elseif tl == "1" then
      lua_thread.create(function()
        sampSendChat("/do в кармане находится КПК")
        wait(1500)
        sampSendChat("/me достал КПК, после чего зашел в базу данных")
        wait(1500)
        sampSendChat("/me аннулировал водительские права")
        wait(1500)
        sampSendChat("/take "..id)
      end)
    elseif tl == "2" then
      lua_thread.create(function()
        sampSendChat("/do в кармане находится КПК")
        wait(1500)
        sampSendChat("/me достал КПК, после чего зашел в базу данных")
        wait(1500)
        sampSendChat("/me аннулировал лицензию на оружие")
        wait(1500)
        sampSendChat("/take "..id)
      end)
    elseif tl == "3" then
      lua_thread.create(function()
        sampSendChat("/do в кармане находится КПК")
        wait(1500)
        sampSendChat("/me достал КПК, после чего зашел в базу данных")
        wait(1500)
        sampSendChat("/me аннулировал лицензию на лётный транспорт")
        wait(1500)
        sampSendChat("/take "..id)
      end)
    end
  end
end

function getVehicleNameByPlayerInCar(id)
    local id = tonumber(id, 10)
    local _, myid = sampGetPlayerIdByCharHandle(playerPed)
    if sampIsPlayerConnected(id) or id == myid then
        local res, ped = sampGetCharHandleBySampPlayerId(id)
        if res and doesCharExist(ped) and isCharInAnyCar(ped) then
            local car = storeCarCharIsInNoSave(ped)
            return getNameOfVehicleModel(getCarModel(car))
        end
    end
end

function st(pam)
  id = tonumber(pam)
  if id == nil then
    sampAddChatMessage("{9966CC}FBI Tools {EAEAEA}| Enter: /st ID", -1)
  end
  if id ~= nil and sampIsPlayerConnected(id) then
    sampSendChat("/m Водитель Т/C "..getVehicleNameByPlayerInCar(id).." с гос.номером [EVL"..pam.."X], прижмитесь к обочине и остановите своё Т/С")
  end
end

function deject(par)
  id = tonumber(par)
  if id == nil then
    sampAddChatMessage("{9966CC}FBI Tools {EAEAEA}| Enter: /deject ID", -1)
  end
  if id ~= nil and sampIsPlayerConnected(id) then
    local result, ped = sampGetCharHandleBySampPlayerId(id)
    if result then
      if isCharInFlyingVehicle(ped) then
        lua_thread.create(function()
          sampSendChat("/me открыл дверь вертолёта и вытащил "..sampGetPlayerNickname(id))
          wait(1500)
          sampSendChat("/deject "..par)
        end)
      elseif isCharInModel(ped, 481) or isCharInModel(ped, 510) then
        lua_thread.create(function()
          sampSendChat("/me скинул "..sampGetPlayerNickname(id).." с велосипеда")
          wait(1500)
          sampSendChat("/deject "..par)
        end)
      elseif isCharInModel(ped, 462) then
        lua_thread.create(function()
          sampSendChat("/me скинул "..sampGetPlayerNickname(id).." со скутера")
          wait(1500)
          sampSendChat("/deject "..par)
        end)
      elseif isCharOnAnyBike(ped) then
        lua_thread.create(function()
          sampSendChat("/me скинул "..sampGetPlayerNickname(id).." с мотоцикла")
          wait(1500)
          sampSendChat("/deject "..par)
        end)
      elseif isCharInAnyCar(ped) then
        lua_thread.create(function()
          sampSendChat("/me разбил окно и вытолкнул "..sampGetPlayerNickname(id).." из машины")
          wait(1500)
          sampSendChat("/deject "..par)
        end)
      end
    end
  end
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

function rh(id)
  local _, myid = sampGetPlayerIdByCharHandle(PLAYER_PED)
  if id == "" or id < "1" or id > "3" or id == nil then
    sampAddChatMessage("{9966CC}FBI Tools {EAEAEA}| Enter: /rh DEPARTAMENT", -1)
    sampAddChatMessage("{9966CC}FBI Tools {EAEAEA}| 1 - LSPD | 2 - SFPD | 3 - LVPD")
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
    sampAddChatMessage("{9966CC}FBI Tools {EAEAEA}| Enter /gr [1-3] REASON", -1)
    sampAddChatMessage("{9966CC}FBI Tools {EAEAEA}| 1 - LSPD | 2 - SFPD | 3 - LVPD", -1)
  end
  if dep ~= nil then
    if dep == "" or dep < "1" or dep > "3" then
      sampAddChatMessage("{9966CC}FBI Tools {EAEAEA}| Enter /gr [1-3] REASON", -1)
      sampAddChatMessage("{9966CC}FBI Tools {EAEAEA}| 1 - LSPD | 2 - SFPD | 3 - LVPD", -1)
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
  local id, dep = string.match(pam, '(%d+)%s*(%d*)')
  if dep == nil or id == nil then
    sampAddChatMessage("{9966CC}FBI Tools {EAEAEA}| Enter: /warn ID DEPARTAMENT", -1)
    sampAddChatMessage("{9966CC}FBI Tools {EAEAEA}| 1 - LSPD | 2 - SFPD | 3 - LVPD",-1)
  end
  if id ~= nil and sampIsPlayerConnected(id) then
    if dep == "" or dep < "1" or dep > "3" then
      sampAddChatMessage("{9966CC}FBI Tools {EAEAEA}| Enter: /warn ID DEPARTAMENT", -1)
      sampAddChatMessage("{9966CC}FBI Tools {EAEAEA}| 1 - LSPD | 2 - SFPD | 3 - LVPD",-1)
    elseif dep == "1" then
      sampSendChat("/d LSPD, "..sampGetPlayerNickname(id):gsub('_', ' ')..", получает предупреждение за неправильную подачу в розыск.")
    elseif dep == '2' then
      sampSendChat("/d SFPD, "..sampGetPlayerNickname(id):gsub('_', ' ')..", получает предупреждение за неправильную подачу в розыск.")
    elseif dep == '3' then
      sampSendChat("/d LVPD, "..sampGetPlayerNickname(id):gsub('_', ' ')..", получает предупреждение за неправильную подачу в розыск.")
    end
  end
end

function df()
  lua_thread.create(function()
    submenus_show(dfmenu, "{9966cc}FBI Tools {ffffff}| Bomb Menu")
  end)
end

function ms(par)
  local _, myid = sampGetPlayerIdByCharHandle(PLAYER_PED)
  if par == "" or par < "0" or par > "3" or par == nil then
    sampAddChatMessage("{9966CC}FBI Tools {EAEAEA}| Enter: /ms TYPE", -1)
    sampAddChatMessage("{9966CC}FBI Tools {EAEAEA}| 0 - MASK OFF | 1 - OFFICE | 2 - TRUNK | 3 - BAG", -1)
  elseif par == "1" then
    lua_thread.create(function()
      sampSendChat("/me снял с себя костюм агента и повесил на вешалку")
      wait(1500)
      sampSendChat("/me открыл ящик, после чего достал комплект маскировки")
      wait(1500)
      sampSendChat("/me надел на себя маскировку и закрыл ящик")
      wait(1500)
      sampSendChat("/do Агент в маскировке")
      wait(100)
      submenus_show(osnova, "{9966cc}FBI Tools {ffffff}| Mask")
    end)
  elseif par == "2" then
    lua_thread.create(function()
      sampSendChat("/me открыл багажник автомобиля")
      wait(1500)
      sampSendChat("/me снял с себя костюм агента и убрал в багажник")
      wait(1500)
      sampSendChat("/me достал из багажника комплект маскировки и надел на себя")
      wait(1500)
      sampSendChat("/me закрыл багажник")
      wait(1500)
      sampSendChat("/do Агент в маскировке")
      wait(100)
      submenus_show(osnova, "{9966cc}FBI Tools {ffffff}| Mask")
    end)
  elseif par == "3" then
    lua_thread.create(function()
      sampSendChat("/do на плече агента висит сумка")
      wait(1500)
      sampSendChat("/me открыв сумку, снял костюм агента и убрал туда")
      wait(1500)
      sampSendChat("/me достал из сумки комплект маскировки и надел на себя")
      wait(1500)
      sampSendChat("/me закрыл сумку")
      wait(1500)
      sampSendChat("/do Агент в маскировке")
      wait(100)
      submenus_show(osnova, "{9966cc}FBI Tools {ffffff}| Mask")
    end)
  elseif par == "0" then
    lua_thread.create(function()
      sampSendChat("/me снял с себя маскировку")
      wait(1500)
      sampSendChat("/me надел на себя костюм агента")
      wait(1500)
      sampSendChat("/r Переоделся в костюм агента")
      wait(1500)
      sampSendChat("/rb "..myid)
    end)
  end
end

function ar(id)
  if id == "" or id < "1" or id > "2" or id == nil then
    sampAddChatMessage("{9966cc}FBI Tools {ffffff}| Enter /ar [1-2]", -1)
    sampAddChatMessage("{9966cc}FBI Tools {ffffff}| 1 - LVa | 2 - SFa", -1)
  elseif id == "1" then
    sampSendChat("/d LVa, разрешите въезд на вашу территорию, поимка преступника.")
  elseif id == "2" then
    sampSendChat("/d SFa, разрешите въезд на вашу территорию, поимка преступника.")
  end
end

function kmdc(args)
    pID = tonumber(args)
    if pID ~= nil then
        if sampIsPlayerConnected(pID) then
            lua_thread.create(function()
              sampSendChat("/me достал КПК и сделал фотографию человека")
              wait(1500)
              sampSendChat("/do КПК дал информацию: Имя: "..sampGetPlayerNickname(pID):gsub('_', ' '))
              wait(1500)
              sampSendChat("/mdc "..args)
              wait(1500)
              sampSendChat("/time")
              wait(500)
              setVirtualKeyDown(key.VK_F8, true)
              wait(150)
              setVirtualKeyDown(key.VK_F8, false)
            end)
        else
            sampAddChatMessage("{9966CC}FBI Tools {EAEAEA}| Player with ID: "..args.." is not connected", -1)
        end
    else
        sampAddChatMessage("{9966CC}FBI Tools {EAEAEA}| Enter: /kmdc ID", -1)
    end
  end
