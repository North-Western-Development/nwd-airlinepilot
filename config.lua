Config = {}

Config.Framework = {}

-- Framework Settings
Config.Framework.Type = "QBCore" -- Values: QBCore or ESX  //  Capitalization matters

Config.JobName = "" -- Name of the job set in QBCore
Config.UseJobTypeInstead = true -- Use 'type' setting from QBCore's jobs.lua instead of the name
-- useful if you are setting up multiple player owned airlines with different pay structures and such
Config.JobType = "pilot"
Config.MaxPassengerCount = 8

Config.PressE = true -- Set to false to disable the press E system, you will need to implement your own qb-target entries for usage

Config.FuelScript = "LegacyFuel"

Config.PlaneModels = {
    [1] = {
        ModelName = `luxor`,
        MaxPassengers = 8, -- Luxor has 8 passenger seats, a number between 1 and this will be randomly selected
        allowCoPilotSeat = false, -- This is for planes that have more than 2 seats, if you don't want passengers being put into the co-pilot seat set to false
        passengerDoor = 0 -- The index number for the passenger door of the aircraft
    },
    [2] = {
        ModelName = `miljet`,
        MaxPassengers = 14,
        allowCoPilotSeat = false,
        passengerDoor = 1
    },
    [3] = {
        ModelName = `shamal`,
        MaxPassengers = 8,
        allowCoPilotSeat = false,
        passengerDoor = 0
    }
} -- Recommend low to the ground planes with no need for airstairs
Config.EnablePerico = true -- Set to false if your server does not have Perico loaded in
Config.PaymentPerPassenger = 50 -- Payment to pilot per passenger
Config.BaseFlightPayment = 200 -- Base payment per flight regardless of passenger count
Config.FineForCrash = true -- Should players be fined for crashing their aircraft
Config.FineAmount = 1000 -- Amount to fine if the player crashes
Config.VIPPassengerMode = true -- If only one passenger is on board pay a different amount for that one passenger
Config.VIPPassengerCost = 300 -- The flight total will be BaseFlightPayment + VIPPassengerCost

Config.Locations = {
    PlaneGates = {
        ['lsia'] = {
            [0] = {
                gate = vector4(-1344.531, -2691.126, 13.944936, 324.10568),
                passengerSpawn = vector4(-1340.142, -2659.871, 13.944926, 106.89459)
            }
        },
        ['grapeseed'] = {
            [0] = {
                gate = vector4(2129.5229, 4807.6577, 41.195949, 124.64903),
                passengerSpawn = vector4(2122.4721, 4782.0424, 40.970275, 293.55148)
            }
        },
        ['sandy'] = {
            [0] = {
                gate = vector4(1751.8597, 3264.2702, 41.296112, 94.059532),
                passengerSpawn = vector4(1720.4177, 3285.0239, 41.349895, 187.69657)
            }
        },
        ['perico'] = {
            [0] = {
                gate = vector4(4451.3217, -4492.838, 4.2047214, 193.72109),
                passengerSpawn = vector4(4456.0468, -4476.012, 4.3022885, 191.40312)
            }
        }
    },
    WorkCheckIns = {
        ['lsia'] = {
            [0] = vector3(-1165.451, -2735.429, 19.887369)
        },
        ['grapeseed'] = {
            [0] = vector3(2122.2006, 4784.9223, 40.970275)
        },
        ['sandy'] = {
            [0] = vector3(1759.5052, 3299.0695, 42.170913)
        },
        ['perico'] = {
            [0] = vector3(4435.0166, -4484.525, 4.2969756)
        }
    },
    Runways = {
        ['lsia'] = {
            [0] = vector3(-1272.265, -2985.746, 13.950982),
            [1] = vector3(-1343.352, -3139.474, 13.944432),
            [2] = vector3(-1531.188, -2548.322, 13.944391)
        },
        ['grapeseed'] = {
            [0] = vector3(2032.1164, 4764.6967, 41.066925)
        },
        ['sandy'] = {
            [0] = vector3(1394.8621, 3167.2539, 40.414108),
            [1] = vector3(1310.996, 3076.9038, 40.414939)
        },
        ['perico'] = {
            [0] = vector3(4251.5307, -4583.149, 4.1843061)
        }
    }
}

Config.NpcSkins = {
    [1] = {'a_f_m_skidrow_01', 'a_f_m_soucentmc_01', 'a_f_m_soucent_01', 'a_f_m_soucent_02', 'a_f_m_tourist_01',
           'a_f_m_trampbeac_01', 'a_f_m_tramp_01', 'a_f_o_genstreet_01', 'a_f_o_indian_01', 'a_f_o_ktown_01',
           'a_f_o_salton_01', 'a_f_o_soucent_01', 'a_f_o_soucent_02', 'a_f_y_beach_01', 'a_f_y_bevhills_01',
           'a_f_y_bevhills_02', 'a_f_y_bevhills_03', 'a_f_y_bevhills_04', 'a_f_y_business_01', 'a_f_y_business_02',
           'a_f_y_business_03', 'a_f_y_business_04', 'a_f_y_eastsa_01', 'a_f_y_eastsa_02', 'a_f_y_eastsa_03',
           'a_f_y_epsilon_01', 'a_f_y_fitness_01', 'a_f_y_fitness_02', 'a_f_y_genhot_01', 'a_f_y_golfer_01',
           'a_f_y_hiker_01', 'a_f_y_hipster_01', 'a_f_y_hipster_02', 'a_f_y_hipster_03', 'a_f_y_hipster_04',
           'a_f_y_indian_01', 'a_f_y_juggalo_01', 'a_f_y_runner_01', 'a_f_y_rurmeth_01', 'a_f_y_scdressy_01',
           'a_f_y_skater_01', 'a_f_y_soucent_01', 'a_f_y_soucent_02', 'a_f_y_soucent_03', 'a_f_y_tennis_01',
           'a_f_y_tourist_01', 'a_f_y_tourist_02', 'a_f_y_vinewood_01', 'a_f_y_vinewood_02', 'a_f_y_vinewood_03',
           'a_f_y_vinewood_04', 'a_f_y_yoga_01', 'g_f_y_ballas_01'},
    [2] = {'ig_barry', 'ig_bestmen', 'ig_beverly', 'ig_car3guy1', 'ig_car3guy2', 'ig_casey', 'ig_chef',
           'ig_chengsr', 'ig_chrisformage', 'ig_clay', 'ig_claypain', 'ig_cletus', 'ig_dale', 'ig_dreyfuss',
           'ig_fbisuit_01', 'ig_floyd', 'ig_groom', 'ig_hao', 'ig_hunter', 'csb_prolsec', 'ig_joeminuteman',
           'ig_josef', 'ig_josh', 'ig_lamardavis', 'ig_lazlow', 'ig_lestercrest', 'ig_lifeinvad_01',
           'ig_lifeinvad_02', 'ig_manuel', 'ig_milton', 'ig_mrk', 'ig_nervousron', 'ig_nigel', 'ig_old_man1a',
           'ig_old_man2', 'ig_oneil', 'ig_orleans', 'ig_ortega', 'ig_paper', 'ig_priest', 'ig_prolsec_02',
           'ig_ramp_gang', 'ig_ramp_hic', 'ig_ramp_hipster', 'ig_ramp_mex', 'ig_roccopelosi', 'ig_russiandrunk',
           'ig_siemonyetarian', 'ig_solomon', 'ig_stevehains', 'ig_stretch', 'ig_talina', 'ig_taocheng',
           'ig_taostranslator', 'ig_tenniscoach', 'ig_terry', 'ig_tomepsilon', 'ig_tylerdix', 'ig_wade',
           'ig_zimbor', 's_m_m_paramedic_01', 'a_m_m_afriamer_01', 'a_m_m_beach_01', 'a_m_m_beach_02',
           'a_m_m_bevhills_01', 'a_m_m_bevhills_02', 'a_m_m_business_01', 'a_m_m_eastsa_01', 'a_m_m_eastsa_02',
           'a_m_m_farmer_01', 'a_m_m_fatlatin_01', 'a_m_m_genfat_01', 'a_m_m_genfat_02', 'a_m_m_golfer_01',
           'a_m_m_hasjew_01', 'a_m_m_hillbilly_01', 'a_m_m_hillbilly_02', 'a_m_m_indian_01', 'a_m_m_ktown_01',
           'a_m_m_malibu_01', 'a_m_m_mexcntry_01', 'a_m_m_mexlabor_01', 'a_m_m_og_boss_01', 'a_m_m_paparazzi_01',
           'a_m_m_polynesian_01', 'a_m_m_prolhost_01', 'a_m_m_rurmeth_01'}
}
