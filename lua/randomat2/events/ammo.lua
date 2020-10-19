local EVENT = {}

EVENT.Title = "Infinite Ammo!"
EVENT.id = "ammo"

CreateConVar("randomat_ammo_affectbuymenu", 0, {FCVAR_NOTIFY, FCVAR_ARCHIVE}, "Whether it gives buy menu weapons infinite ammo too.")

function EVENT:Begin()
    self:AddHook("Think", function()
        for _, v in pairs(self:GetAlivePlayers()) do
            if not v:GetActiveWeapon().CanBuy or GetConVar("randomat_ammo_affectbuymenu"):GetBool() then
                v:GetActiveWeapon():SetClip1(v:GetActiveWeapon().Primary.ClipSize)
            end
        end
    end)
end

Randomat:register(EVENT)