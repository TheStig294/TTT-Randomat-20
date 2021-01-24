local EVENT = {}

CreateConVar("randomat_suspicion_chance", 50, {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "The chance of the player being a Jester", 0, 100)

EVENT.Title = ""
EVENT.Description = "Changes a random player to either a Jester or a Traitor"
EVENT.id = "suspicion"
EVENT.AltTitle = "A player is acting suspicious"
EVENT.SingleUse = false

function EVENT:Begin()
    local traitor = {}
    local suspicionply = 0

    for _, v in pairs(self:GetAlivePlayers(true)) do
        if Randomat:IsTraitorTeam(v) then
            table.insert(traitor, v)
            if suspicionply == 0 then
                suspicionply = v
            end
        elseif Randomat:IsInnocentTeam(v, true) then
            suspicionply = v
        elseif suspicionply == 0 and v:GetRole() ~= ROLE_DETECTIVE then
            suspicionply = v
        end
    end

    if suspicionply ~= 0 then
        Randomat:EventNotifySilent(suspicionply:Nick().." is acting suspicious...")

        if math.random(1,100) <= GetConVar("randomat_suspicion_chance"):GetInt() then
            Randomat:SetRole(suspicionply, ROLE_JESTER)
            suspicionply:SetCredits(0)
            for _, v in pairs(traitor) do
                v:PrintMessage(HUD_PRINTCENTER, suspicionply:Nick().." is a jester")
                v:PrintMessage(HUD_PRINTTALK, suspicionply:Nick().." is a jester")
            end
        else
            Randomat:SetRole(suspicionply, ROLE_TRAITOR)
            for _, v in pairs(traitor) do
                v:PrintMessage(HUD_PRINTCENTER, suspicionply:Nick().." is a traitor")
                v:PrintMessage(HUD_PRINTTALK, suspicionply:Nick().." is a traitor")
            end
        end
        SendFullStateUpdate()
    end
end

function EVENT:Condition()
    local has_innocent = false
    for _, v in pairs(self:GetAlivePlayers()) do
        if Randomat:IsJesterTeam(v) then
            return false
        elseif Randomat:IsInnocentTeam(v, true) then
            has_innocent = true
        end
    end
    return has_innocent
end

function EVENT:GetConVars()
    local sliders = {}
    for _, v in pairs({"chance"}) do
        local name = "randomat_" .. self.id .. "_" .. v
        if ConVarExists(name) then
            local convar = GetConVar(name)
            table.insert(sliders, {
                cmd = v,
                dsc = convar:GetHelpText(),
                min = convar:GetMin(),
                max = convar:GetMax(),
                dcm = 0
            })
        end
    end
    return sliders
end

Randomat:register(EVENT)