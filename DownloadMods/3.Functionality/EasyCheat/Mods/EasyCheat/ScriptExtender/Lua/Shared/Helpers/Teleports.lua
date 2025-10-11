-- minput = Ext.Events.MouseButtonInput:Subscribe(function(e) _D(Ext.UI.GetPickingHelper(1).Inner.Inner) end)

Teleports = {}
Teleports.LevelToAct = {
    ["TUT_Avernus_C"] = "Act0", -- nautiloid
    ["WLD_Main_A"] = "Act1",    -- beach, grove, goblin camp, underdark
    ["CRE_Main_A"] = "Act1b",   -- mountain pass, creche
    ["SCL_Main_A"] = "Act2",    -- shadow cursed lands
    ["INT_Main_A"] = "Act2b",   -- camp before baldur's gate
    ["BGO_Main_A"] = "Act3",    -- rivington, wyrm's crossing
    ["CTY_Main_A"] = "Act3b",   -- lower city, sewers
    ["IRN_Main_A"] = "Act3b",   -- iron throne
    ["END_Main"] = "Act3c",     -- morphic pool
}
Teleports.ActToLevel = {
    ["Act0"] = "TUT_Avernus_C",
    ["Act1"] = "WLD_Main_A",
    ["Act1b"] = "CRE_Main_A",
    ["Act2"] = "SCL_Main_A",
    ["Act2b"] = "INT_Main_A",
    ["Act3"] = "BGO_Main_A",
    ["Act3b"] = "CTY_Main_A",
    ["Act3c"] = "END_Main",
}
--Osi.PROC_DEBUG_TeleportToAct("Act1")
--Osi.PROC_TeleportPartiesTo("b5250296-0ecd-4129-94f1-b1170fcff1d7", GetHostCharacter())
Teleports.Regions = {
    Act1 = {
        Act = "Act1",
        Locations = {
            ["1bf2ce97-e32d-49d9-8497-3dd64413bca3"] = {
                Act = "Act1",
                Uuid = "1bf2ce97-e32d-49d9-8497-3dd64413bca3",
                Name = "Daisy's Dream Island",
                Notes = "Not Walkable"
            },
            ["580ecf35-aa9f-4034-a802-87641ac21cf5"] = {
                Act = "Act1",
                Uuid = "580ecf35-aa9f-4034-a802-87641ac21cf5",
                Name = "Shadowheart's Wolf Dream",
                Notes = "Not Walkable"
            },
            ["fb826663-61e2-4ea7-8256-420e8df80601"] = {
                Act = "Act1",
                Uuid = "fb826663-61e2-4ea7-8256-420e8df80601",
                Name = "Night with Astarion at goblin party",
                Notes = "Mostly not Walkable"
            },
            ["3b44ad3c-c474-4839-b395-a4da39d279c3"] = {
                Act = "Act1",
                Uuid = "3b44ad3c-c474-4839-b395-a4da39d279c3",
                Name = "Night with Shadowheart",
                Notes = "Walkable, but just a cliff in camp; Starts a song with lyrics?"
            },
            ["9aee5a2b-695a-4678-8100-a93d778e4d96"] = {
                Act = "Act1",
                Uuid = "9aee5a2b-695a-4678-8100-a93d778e4d96",
                Name = "Grove",
                Notes = "Walkable, normal area"
            },
            ["07521d5c-5bb5-443a-ae8d-eedde58853e2"] = {
                Act = "Act1",
                Uuid = "07521d5c-5bb5-443a-ae8d-eedde58853e2",
                Name = "Basement Player Camp",
                Notes = "Walkable, normal area"
            },
            ["1da9530c-743f-47f8-9b7f-0b03ef330284"] = {
                Act = "Act1",
                Uuid = "1da9530c-743f-47f8-9b7f-0b03ef330284",
                Name = "House on Fire, Florrick",
                Notes = "Walkable, normal area"
            },
            ["5d3da339-176e-492b-a95e-29af27396d92"] = {
                Act = "Act1",
                Uuid = "5d3da339-176e-492b-a95e-29af27396d92",
                Name = "Camp",
                Notes = "Walkable, normal area"
            },
            ["d8b56994-8bde-4281-8f63-4bdb7e7fbb3b"] = {
                Act = "Act1",
                Uuid = "d8b56994-8bde-4281-8f63-4bdb7e7fbb3b",
                Name = "Grymforge",
                Notes = "Walkable, normal area"
            },
        }
    }
}
Teleports.Waypoints = {
    Act0 = {}, -- no waypoints, tutorial region
    Act1 = {
        OverGrownRuins = "S_CHA_WaypointTrigger_5e857e93-203a-4d4a-bd29-8e97eb34dec6",
        RoadsideCliffs = "S_CHA_WaypointTrigger_Top_4141c0a2-5ba9-42c0-ab18-082426df45e7",
        EmeraldGroveEnvirons = "S_DEN_WaypointPos_cdd91969-67d0-454e-b27b-cf34e542956b",
        BlightedVillage = "S_FOR_WaypointTrigger_e44f372c-b335-4dc8-8864-f2111c83c6a6",
        RiversideTeahouse = "S_HAG_WaypointPos_4c92d6c3-055f-40f1-b76b-a3540ffe32ee",
        GoblinCamp = "S_GOB_WaypointTrigger_3b1b1ab2-1962-47cc-8e25-5cfde2a6c32f",
        WaukeensRest = "S_PLA_Tavern_WaypointTrigger_7044aaf2-7ab9-43f6-96f0-08a173fa08b9",
        ZhentarimHideout = "S_PLA_WaypointTrigger_ZhentDungeon_f3cf2ab0-4b05-45e4-b2c8-2dda305ac47e",
        SeluniteOutpost = "S_UND_Fort_WaypointTrigger_dddb39d6-c5ac-4470-98c5-395ce81af017",
        UnderdarkBeach = "S_UND_Beach_WaypointTrigger_91c3fe06-7d44-4f35-a88a-ea5eb303bb70",
        SussurTree = "S_UND_Sussur_WaypointTrigger_d24b2d8c-a4dc-4367-8da2-c6fa75baa61c",
        MyconidColony = "S_UND_Myconid_WaypointTrigger_b83f13a0-e988-48f1-9068-ea9be2adffb2",
        GrymForge = "S_UND_Duergar_WaypointTrigger_01d43e65-d370-46c6-9998-a9f7523221eb",
        RisenRoad = "S_PLA_WaypointShrine_f68dedbb-a256-40f6-a01e-ab261851df5d",
        WisperingDepth = "S_FOR_Bottomless_WaypointTrigger_ad3614e0-8895-45dd-a05d-a78eba584202",
    },
    Act1b = {
        TrieltaCrags = "S_CRE_Exterior_Waypoint_Pos_00abc10c-921d-46f9-80e0-2b8f92f884c7",
        Monastery = "S_CRE_Monastery_Waypoint_Pos_6b587ee7-5767-4d3e-8ef4-270976e63ad5",
        Creche = "S_CRE_Creche_Waypoint_Pos_4324dbaf-6533-4b0f-8c99-de4e2adbd4ec",
    },
    Act2 = {
        LastLight = "S_HAV_Waypoint_Pos_94b462c2-9290-4d4d-8bf4-fbf559f03c3f",
        ShadowedBattlefield = "S_SCL_OliverHouse_Waypoint_Pos_7c083353-7e5c-4cb7-ac3e-42fc3a19807f",
        ReithwinTown = "S_TWN_Waypoint_Pos_488ce3e4-2239-4623-9aeb-d34cc18bec58",
        MoonriseTowers = "S_MOO_TowerExterior_Waypoint_Pos_8fd66a2b-7b29-44f9-b6dd-cd957c91d19c",
        GrandMausoleum = "S_TWN_Mausoleum_Waypoint_Pos_c6faa212-fb0f-4fc5-a011-662a03a3b09a",
        GauntletOfShar = "S_SHA_Temple_Waypoint_Pos_7d5d94c7-fa75-41f2-9aef-06b9d42757ea",
        NightsongPrison = "S_SHA_NightsongPrison_EntranceWaypoint_Pos_9b2081b4-d7dd-43ac-8ef0-4acda40379ae",
        RoadToBaldursGate = "S_SCL_RoadToBaldursGate_Waypoint_Pos_ef45338c-09c7-4904-998f-32c0ad1165b6",
    },
    Act2b = {}, -- no waypoints, it's just the intermediary camp between SCL and Rivington
    Act3 = {
        Rivington = "S_WYR_Rivington_WaypointTrigger_016ac9ad-ac85-49a0-a6be-e24fdb0de2bb",
        SharessCaress = "S_WYR_SharessCaress_WaypointTrigger_5561c476-c82d-4239-b4a3-baaf2985ef71",
    },
    Act3b = {
        BasiliskGate = "S_LOW_Waypoint_HeapsideBarracksTrigger_f0a45122-eca3-4b8f-ad86-c429ca305b3d",
        Heapside = "S_LOW_Waypoint_CityBeachTrigger_f6611899-85b6-45e3-8c1e-3b61590a621f",
        LowerCity = "S_LOW_Waypoint_CentralWallTrigger_97bdf561-7f2b-4618-89ca-5cad0729bd01",
        BaldursGate = "S_LOW_Waypoint_BaldursGateArea_daabc785-6c47-4b5c-a3d8-d4bea24128b7",
        GreyHarbor = "S_LOW_Waypoint_DocksAreaTrigger_1e27d7c2-0914-4717-9a70-37bdcdb3b80b",
        Undercity = "S_LOW_Waypoint_UndercityRuinsTrigger_3e423e81-8d84-463e-b50e-ab8c5869bdf6",
        CazadorsPalace = "S_LOW_CazadorsPalace_Dungeon_WaypointTrigger_717c1fd4-290a-4fb7-9282-dbcdd17a274b",
        BhaalTemple = "S_LOW_Waypoint_BhaalTempleTrigger_807163bb-8341-49da-a074-c5926bfedf1b",
        MorphicDocks = "S_LOW_Waypoint_MorphicPoolDockTrigger_c1ea6981-cfce-495c-8405-3b503df268fd",
    },
    Act3c = {}, -- no waypoints, endgame
}