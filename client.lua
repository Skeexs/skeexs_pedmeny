_G.exports = exports;
--
local ESX = exports.es_extended:getSharedObject();
local PedMenu = {
    currentPage = 1,
};

-- * Register Command
RegisterCommand("changeped", function(source, args)
    local pedModel = args[1] == '' and nil or args[1];

    if pedModel then
        PedMenu:change(pedModel)
    else
        PedMenu:open()
    end
end)

-- * Functions
function PedMenu:open()
    local elements = {
        { label = 'Nästa sida',      value = 'nextPage' },
        { label = 'Föregående sida', value = 'prevPage' },
        { label = 'Din karaktär',    value = nil }
    };


    for i = 1, #Config.Peds do
        if i >= (self.currentPage * Config.PedsPerPage) - Config.PedsPerPage and i <= self.currentPage * Config.PedsPerPage then
            table.insert(elements, {
                label = Config.Peds[i],
                value = Config.Peds[i]
            })
        end
    end

    table.insert(elements, {
        label = 'Näsa sida',
        value = 'nextPage'
    })

    table.insert(elements, {
        label = 'Föregående sida',
        value = 'prevPage'
    })


    ESX.UI.Menu.Open("default", GetCurrentResourceName(), "ped_menu", {
        title = Config.MenuTitle,
        align = Config.AlignMenu,
        elements = elements
    }, function(data, menu)
        if data.current.value == 'nextPage' then
            self.currentPage = self.currentPage + 1;
            self:open()
        elseif data.current.value == 'prevPage' then
            self.currentPage = self.currentPage - 1;
            self:open()
        elseif data.current.value == nil then
            self:change(GetEntityModel(PlayerPedId()))
        else
            self:change(data.current.value)
        end
    end, function(data, menu)
        menu.close()
    end)
end

function PedMenu:search(searchQuery)

end

function PedMenu:change(model)
    local chosenModel = type(model) == "string" and GetHashKey(model) or model;

    if not IsModelValid(chosenModel) then
        ESX.ShowNotification("Den här ped modellen finns inte.")
        return;
    end

    local loaded, _model = LoadPedModel(chosenModel);

    if not loaded then
        print("Det gick inte att ladda ped modellen.", _model)
        return
    end

    SetPlayerModel(PlayerId(), chosenModel);

    local loadedModel = Find(Config.Peds, function(model)
        return GetHashKey(model) == chosenModel
    end)

    if not loadedModel then
        print("Det gick inte att hitta ped modellen.")
        return
    end

    ESX.ShowNotification("Du bytte ped modell till " .. loadedModel .. ".")

    SetModelAsNoLongerNeeded(chosenModel);

    return true;
end

-- * Utilities
function LoadPedModel(model)
    while not HasModelLoaded(model) do
        RequestModel(model)
        Citizen.Wait(10)
    end

    return true, model
end

function Find(tbl, cb)
    for k, v in pairs(tbl) do
        if cb(v, k, tbl) then
            return v, k
        end
    end
end
