RegisterNetEvent(
    "nwd-airlinepilot:server:payFlight",
    function(passCount)
        local Player = Generic.Server.Framework.GetPlayer(source)
        if (passCount > 1 and Config.VIPPassengerMode) or not Config.VIPPassengerMode then
            Generic.Server.Framework.AddMoney(Player, "bank", Config.BaseFlightPayment + (Config.PaymentPerPassenger * passCount), "Payment for completed flight")
        else
            Generic.Server.Framework.AddMoney(Player, "bank", Config.BaseFlightPayment + Config.VIPPassengerCost, "Payment for completed VIP flight")
        end
    end
)

RegisterNetEvent(
    "nwd-airlinepilot:server:planeCrash",
    function()
        local Player = Generic.Server.Framework.GetPlayer(source)

        Generic.Server.Framework.RemoveMoney(Player, "bank", Config.FineAmount, "Plane crash fine")
    end
)
