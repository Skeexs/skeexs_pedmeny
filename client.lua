local Keys = {
    ["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
    ["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
    ["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
    ["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
    ["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
    ["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
    ["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
    ["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
  }

ESX = nil
local PlayerData = {}
Citizen.CreateThread(function()
    
    while ESX == nil do
      TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
      Citizen.Wait(0)
    end
  end)

  RegisterNetEvent("skeexs:pedmeny")
  AddEventHandler("skeexs:pedmeny", function()
    OpenMenu()
end)


-- function(data, menu)
--     if data.current.value == 'ped' then
--         OpenPedMenu()
--     end,
-- 	function(data, menu)
-- 		menu.close()
-- 	end)

OpenMenu = function()
    local menuElements = {
        {
            ["label"] = "Välj en ped att bli.",
            ["action"] = "choose_ped"
        },
        {
            ["label"] = "Vanlig <span style = 'color:red'Karaktär</span>",
            ["action"] = "citizen_wear"
        }
    }

    ESX.UI.Menu.Open("default", GetCurrentResourceName(), "ped_menu", {
        ["title"] = "Peds",
        ["align"] = "center",
        ["elements"] = menuElements
    }, function(menuData, menuHandle)
        local action = menuData["current"]["action"]

        if action == "choose_ped" then
            ESX.UI.Menu.Open("dialog", GetCurrentResourceName(), "ped_dialog_menu", {
                ["title"] = "Skriv in peden du vill vara."
            }, function(menuData, menuHandle)
                local pedModelChosen = menuData["value"]

                if not type(pedModelChosen) == "number" then pedModelChosen = `pedModelChosen` end
                    
                if IsModelInCdimage(pedModelChosen) then
                    while not HasModelLoaded(pedModelChosen) do
                        Citizen.Wait(5)

                        RequestModel(pedModelChosen)
                    end

                    SetPlayerModel(PlayerId(), pedModelChosen)
                    
                    menuHandle.close()
                else
                    exports.pNotify:SendNotification({text = 'Ogiltig PED', type = "error", timeout = 200, layout = "bottomCenter", queue = "center"})
                end
            end, function(menuData, menuHandle)
                menuHandle.close()
            end)
        elseif action == "mp_m_freemode_01" then
        
        elseif action == "mp_f_freemode_01" then

            --byt till din ped.
        end
    end, function(menuData, menuHandle)
        menuHandle.close()
    end)
end
 
    -- RegisterCommand("ped", function(source)
    --     exports.pNotify:SendNotification({text = 'Du har öppnat <span style ="color:blue">Menyn</span>', type = "success", timeout = 200, layout = "bottomCenter", queue = "center"})
    --     Citizen.Wait(500)
    --     OpenMenu()
    -- end, false)
