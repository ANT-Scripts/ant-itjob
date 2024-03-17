local Translations = {
    label = {
        ["shop"] = "Shop",
        ["reqjob"] = "Repair Job",
        ["finishjob"] = "Collect Payment",
        ["entry"] = "Enter House",
        ["exit"] = "Exit House",
        ["checkpc"] = "Check PC",
        ["delivery"] = "Deliver",
        ["startdelivery"] = "Delivery Job"
    },

    notify = {
        ["jobinprogress"] = "Your job is still in progress",
        ["recivedlocation"] = "You received a caller's location. It's marked on your GPS",
        ["alreadychecked"] = "You already checked this part",
        ["imnotbroken"] = "This part is not broken",
        ["donthaveitem"] = "You don't have this item",
        ["alreadyfixed"] = "You already fixed this PC",
        ["needtostartjob"] = "You need to start a job first!",
        ["neworder"] = "The address for a New Order has been marked on your GPS!",
        ["ondelivery"] = "You already have a Delivery.",
        ["finish"] = "Finished Sale",
        ["notselling"] = "You haven't started selling",
        ["notfinish"] = "The job is not finished",
        ["packetsell"] = "Order is being delivered",
        ["needitem"] = "You are missing the Delivery item",
        ["deliverynotify"] = "You received $",
        ["success"] = "Success",
        ["nojob"] = "You are not employed with the IT Company.",
    },

    mail = {
        ["sender"] = "Mr. Smith",
        ["subject"] = "IT C.E.O",
        ["message"] = "Head back to Company HQ to collect your payment."
    },

    qbmenu = {
        ["avboptions"] = "Available Options",
        ["checkmonitor"] = "Check Monitor",
        ["checkkeyboard"] = "Check Keyboard",
        ["checkgraphiccard"] = "Check GPU",
        ["checkcpu"] = "Check CPU",
        ["checkssd"] = "Check SSD",
        ["checkmouse"] = "Check Mouse",
        ["checkcompcase"] = "Check Computer Case",
        ["checkpowersupply"] = "Check Power Supply",
        ["checkcpucooler"] = "Check CPU Cooler",
        ["checkmotherboard"] = "Check Motherboard",
        ["checkmemory"] = "Check Memory",
        ["checkcables"] = "Check Cables",
        ["imbroken"] = "I think there's something wrong here, so I'd better replace it.",
        ["replaceit"] = "Replace this part",
        ["needtodeliver"] = "You need to delivery:",
        ["tolocation"] = "To location on map",
        ["deliver"] = "[E] Deliver %s",
        ["confirm"] = "Confirm",
        ["wdmoney"] = "Withdraw Money",
        ["cash"] = "Cash",
        ["bank"] = "Bank",
        ["closeheader"] = "Close (ESC)"
    },

    progress = {
        ["checkingpart"] = "Checking...",
        ["replacingpart"] = "Replacing part...",
        ["packetselling"] = "Selling Computer Parts..."
    }
}

Lang = Lang or Locale:new({
    phrases = Translations,
    warnOnMissing = true
})