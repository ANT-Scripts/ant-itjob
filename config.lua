Config = {}
Config.InventoryImage = "ox_inventory/web/images/"
Config.Target = "qb-target" -- Supports: "qb-target"
Config.Menu = "ox_lib"  -- Supports: "ox_lib"
Config.Phone = "qb-phone" -- Supports: "qb"

Config.TaskPed = 'a_m_y_stbla_02'
Config.TaskPedHash = 'a_m_y_stbla_02'
Config.TaskPedLocation = vector3(-826.89, -690.01, 27.06)
Config.TaskPedHeading = 88.75

Config.BlipName = 'IT Company' -- For calls
Config.BlipLocation = vector3(-827.46, -689.94, 28.06)
Config.Items = {"keyboard", "mouse", "compcase", "powersupply", "cpu", "cpucooler", "motherboard", "memory", "graphiccard", "ssd", "cables"}
Config.CheckPartDuration = 10000 -- in ms (10000 = 10 seconds)
Config.RequiredItem = "it_toolbox"

Config.JobPayout = math.random(175, 350)
Config.ProgressbarTime = 5000

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