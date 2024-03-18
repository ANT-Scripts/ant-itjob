Config = {}
Config.Debug = false
Config.RequireJob = false
Config.Job = 'sast'
Config.Phone = 'notify' -- qb-phone, gks-phone, qs-phone, notify
Config.tarortxt = 'qb-target' -- qb-target or drawtxt
Config.InventoryImage = "ps-inventory/html/images/"
Config.Payout = math.random(1000, 2000)
Config.RequireRepairItem = true
Config.RepairItem = "it_toolkit"

Config.ShopPed = 'a_m_m_eastsa_02'
Config.ShopLocation = vector4(89.71, -1101.65, 28.28, 90.0)
Config.ShopPedScenario = 'WORLD_HUMAN_GUARD_STAND'

Config.TaskPed = 'a_m_y_stbla_02'
Config.TaskPedHash = 'a_m_y_stbla_02'
Config.TaskPedLocation = vector4(-826.89, -690.01, 27.06, 0.0)
Config.TaskPedHeading = 88.75

Config.BlipName = 'IT Comp. Call' -- For calls
Config.BlipName2 = 'IT Company'
Config.BlipLocation = vector3(-827.46, -689.94, 28.06)
Config.BlipName3 = 'IT Shop'
Config.BlipLocation3 = vector3(88.99, -1101.38, 29.28)

Config.GiveVehicle = false
Config.CarSpawnCoord = vector4(-834.41, -685.18, 27.28, 0.29)
Config.DeliveryVeh = "burrito3"
Config.Fuel = "cdn-fuel"
Config.VehPlate = "Delivery"

Config.Items = {
    "monitor",
    "keyboard",
    "mouse",
    "compcase",
    "powersupply",
    "cpu",
    "cpucooler",
    "motherboard",
    "memory",
    "graphiccard",
    "ssd",
    "cables"
}

Config.ProgressbarTime = 5000 -- How long is the progressbar for delivering an item (5000 = 5 seconds)
Config.DeliveryPrice = { -- The CASH reward that players receive when delivering one item
    min = 350,
    max = 500,
}

Config.DeliveryCoords = {
    [1] = {['x'] = 224.15, ['y'] = 513.55, ['z'] = 140.92,['h'] = 245.45, ['info'] = 'Vinewood 1'},
    [2] = {['x'] = 43.02, ['y'] = 468.85, ['z'] = 148.1,['h'] = 230.45, ['info'] = 'Vinewood 2'}, 
    [3] = {['x'] = 119.33, ['y'] = 564.1, ['z'] = 183.96,['h'] = 230.45, ['info'] = 'Vinewood 3'},
    [4] = {['x'] = -60.82, ['y'] = 360.56, ['z'] = 113.06,['h'] = 230.45, ['info'] = 'Vinewood 4'},
    [5] = {['x'] = -622.87, ['y'] = 488.81, ['z'] = 108.88,['h'] = 230.45, ['info'] = 'Vinewood 5'}, 
    [6] = {['x'] = -1040.67, ['y'] = 508.11, ['z'] = 84.38,['h'] = 123.45, ['info'] = 'Vinewood 6'}, 
    [7] = {['x'] = -1308.13, ['y'] = 448.9, ['z'] = 100.97,['h'] = 194.45, ['info'] = 'Vinewood 7'}, 
    [8] = {['x'] = -1733.21, ['y'] = 378.99, ['z'] = 89.73,['h'] = 194.45, ['info'] = 'Vinewood 8'},
    [9] = {['x'] = -2009.15, ['y'] = 367.42, ['z'] = 94.81,['h'] = 232.45, ['info'] = 'Vinewood 9'},
    [10] = {['x'] = -1996.29, ['y'] = 591.25, ['z'] = 118.1,['h'] = 232.45, ['info'] = 'Vinewood 10'},
}

Config.Locations = {
    {
        location = vector3(232.22, 672.12, 189.98),
        inside = vector3(-174.27, 497.83, 137.65),
        outside = vector3(231.55, 673.05, 189.94),
        comp = {
            vector3(-169.25, 492.70, 130.04),
        }
    },
}

Config.PcParts = {
    label = 'PC Parts',
    slots = 13,
    items = {
        [1] = {
            name = 'monitor',
            price = 350,
            amount = 500,
            info = {},
            type = 'item',
            slot = 1,
        },
        [2] = {
            name = 'keyboard',
            price = 200,
            amount = 500,
            info = {},
            type = 'item',
            slot = 2,
        },
        [3] = {
            name = 'mouse',
            price = 80,
            amount = 500,
            info = {},
            type = 'item',
            slot = 3,
        },
        [4] = {
            name = 'compcase',
            price = 250,
            amount = 500,
            info = {},
            type = 'item',
            slot = 4,
        },
        [5] = {
            name = 'powersupply',
            price = 400,
            amount = 500,
            info = {},
            type = 'item',
            slot = 5,
        },
        [6] = {
            name = 'cables',
            price = 120,
            amount = 500,
            info = {},
            type = 'item',
            slot = 6,
        },
        [7] = {
            name = 'it_toolkit',
            price = 150,
            amount = 500,
            info = {},
            type = 'item',
            slot = 7,
        },
        [8] = {
            name = 'cpu',
            price = 750,
            amount = 500,
            info = {},
            type = 'item',
            slot = 8,
        },
        [9] = {
            name = 'cpucooler',
            price = 550,
            amount = 500,
            info = {},
            type = 'item',
            slot = 9,
        },
        [10] = {
            name = 'motherboard',
            price = 650,
            amount = 500,
            info = {},
            type = 'item',
            slot = 10,
        },
        [11] = {
            name = 'memory',
            price = 100,
            amount = 500,
            info = {},
            type = 'item',
            slot = 11,
        },
        [12] = {
            name = 'graphiccard',
            price = 1000,
            amount = 500,
            info = {},
            type = 'item',
            slot = 12,
        },
        [13] = {
            name = 'ssd',
            price = 150,
            amount = 500,
            info = {},
            type = 'item',
            slot = 13,
        },

    }
}

--██╗    ██╗███████╗██████╗ ██╗  ██╗ ██████╗  ██████╗ ██╗  ██╗
--██║    ██║██╔════╝██╔══██╗██║  ██║██╔═══██╗██╔═══██╗██║ ██╔╝
--██║ █╗ ██║█████╗  ██████╔╝███████║██║   ██║██║   ██║█████╔╝
--██║███╗██║██╔══╝  ██╔══██╗██╔══██║██║   ██║██║   ██║██╔═██╗
--╚███╔███╔╝███████╗██████╔╝██║  ██║╚██████╔╝╚██████╔╝██║  ██╗
-- ╚══╝╚══╝ ╚══════╝╚═════╝ ╚═╝  ╚═╝ ╚═════╝  ╚═════╝ ╚═╝  ╚═╝
Config.WebhookURL = 'https://discord.com/api/webhooks/1218951129724092588/FleRHH1eLK0Vte37vRDXvr5TItHzpm43PQ6qc7O-YaXuxJQwNjjrzklwCVkc0OIURkfD'
Config.WebhookName = 'Nations Roleplay'         -- The name of the Webhook (e.g. Infinity RP)