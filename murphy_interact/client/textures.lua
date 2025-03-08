local settings = require 'shared.settings'
-- local textures = settings.Textures
-- local txd = Citizen.InvokeNative(0x1F3AC778, settings.Style)


-- for _, v in pairs(textures) do
--     local test = Citizen.InvokeNative(0x786D8BC3, txd, tostring(v), 'assets/'..settings.Style..'/'..v..'.png')
--     print (test, txd, tostring(v), 'assets/'..settings.Style..'/'..v..'.png')
-- end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
		if not HasStreamedTextureDictLoaded(settings.Style) then
				RequestStreamedTextureDict(settings.Style, true)
				while not HasStreamedTextureDictLoaded(settings.Style) do
					Wait(1)
				end
			else
		end
    end
end)

