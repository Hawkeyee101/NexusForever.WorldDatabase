-- --------------------------------------
-- The Hycrest Insurrection (world 1149)
-- Intro slice: map entrance, intro NPCs, exit portal. Barn positions measured in game with !entity info
-- (27 Sep 2026); Dawson's is still a WorldLocation2 placeholder. Not sniffed;
-- see ~/nexusforever/docs/hycrest/HYCREST.md ("Intro event 418") for sources and open questions.
-- Spawns belong to public events (entity_event) and only appear when the Hycrest scripts set phase 0.
-- --------------------------------------
SET @WORLD = 1149;
-- world 1149 has no entities in the world DB today (open-world Hycrest is world 22)
DELETE FROM `entity` WHERE `world` = @WORLD;

SET @EVENT_MAIN  = 419; -- The Hycrest Insurrection
SET @EVENT_INTRO = 418; -- Intro
DELETE FROM `entity_event` WHERE `eventId` IN (@EVENT_MAIN, @EVENT_INTRO);

-- Group finder entrance: loc 13039 (Abandoned Orchards, on the ground). The entrance has to be a WorldLocation2
-- point and none exists at the ship's position, so the intro script teleports arriving players onto the ship's
-- deck while the ship is there.
DELETE FROM map_entrance WHERE mapId = @WORLD;
INSERT INTO map_entrance (mapId, team, worldLocationId) VALUE
    (@WORLD, 0, 13039);

-- --------------------------------------
-- Drop ship: Dominion Drop Ship - Hycrest Adventure (creature 17722, PRP_Ship_Imperium_Transport_001.m3, display
-- 23787), confirmed against the retail videos (27 Sep 2026): its interior is the room from the videos (dark room,
-- door with the red light strip, crates) and walkable. The model always spawns with both doorways open and its ramps
-- out; retail closed the doorways with the door entities below. States (the script drives them like DoorEntity):
-- State1 hovering (engines shake), State2 "jump away" (departure).
-- Position: spawns at the start point (above -2543.603, -921.8223, -1151.4386, measured; north of the barn) and flies in
-- with the players on board (script) to its hover point (-2537.821, -865.644, -1245.569): turned -90 degrees
-- (RX -1.5708) so the right ramp points north, its lower end above the spot in front of the Abandoned Barn
-- (-2520.6306, -929.33386, -1229.9689, measured), the floor 60 m above that ground (retail was ~90 m) so players jump
-- from the ramp and glide down. Offsets measured on summoned
-- copies; keep in sync with HycrestShipLayout.cs. (70557, the GC217 Set Ship, is the cinematic's interior stage and
-- is no longer used.)
-- Intro event (418) phase 0; the script sends it away once everyone has left it.
-- Type: Platform (11, as Creature2). Tried SimpleCollidable (32) on 28 Sep 2026 (Rāwaho's tip): inconclusive, the player
-- fell at load (also the first direct entry on the deck) and when it started moving. At the start point it faces its
-- flight direction (RX 0, nose south); the
-- script flies it forward to the hover point and turns it right to RX -1.5708 with the players, doors and hologram as
-- its platform passengers.
-- --------------------------------------
SET @GUID = (SELECT IFNULL(MAX(`id`), 0) FROM `entity`);
INSERT INTO `entity` (`Id`, `Type`, `Creature`, `World`, `Area`, `X`, `Y`, `Z`, `RX`, `RY`, `RZ`, `DisplayInfo`, `OutfitInfo`, `Faction1`, `Faction2`) VALUES
    (@GUID + 1, 11, 17722, @WORLD, 0, -2543.603, -865.644, -1151.4386, 0, 0, 0, 23787, 0, 219, 219);

INSERT INTO `entity_event` (`id`, `eventId`, `phase`) VALUES
    (@GUID + 1, @EVENT_INTRO, 0);

-- (The retail green glow on the ship was tried with glowing unit copies of the ship and doors, 28 Sep 2026: a copy
-- exactly on a model doesn't show over it. Left out for now; only the players glow.)

-- --------------------------------------
-- Dominion Transport Door - Right / Left - Platform - Hycrest Adventure (creatures 18338, 28509;
-- PRP_Ship_Imperium_Transport_Door_000/001.m3, displays 23788 / 26374), Platforms like in Creature2. Retail used them
-- to close the ship's always-open doorways: State0 closed, State1 open. Both stand at one point on the ship's centre
-- line (13.28 m forward, 3.28 m below the ship's position, measured), turned like the ship, and fly in with it.
-- 28509 covers the exit doorway (right ramp): the script closes both on arrival and opens 28509 after the briefing.
-- --------------------------------------
SET @GUID = (SELECT IFNULL(MAX(`id`), 0) FROM `entity`);
INSERT INTO `entity` (`Id`, `Type`, `Creature`, `World`, `Area`, `X`, `Y`, `Z`, `RX`, `RY`, `RZ`, `DisplayInfo`, `OutfitInfo`, `Faction1`, `Faction2`) VALUES
    (@GUID + 1, 11, 18338, @WORLD, 0, -2543.473, -868.924, -1164.7186, 0, 0, 0, 23788, 0, 219, 219),
    (@GUID + 2, 11, 28509, @WORLD, 0, -2543.473, -868.924, -1164.7186, 0, 0, 0, 26374, 0, 219, 219);

INSERT INTO `entity_event` (`id`, `eventId`, `phase`) VALUES
    (@GUID + 1, @EVENT_INTRO, 0),
    (@GUID + 2, @EVENT_INTRO, 0);

-- --------------------------------------
-- The Caretaker Disguise - Adventure Intro (creature 56685, EldanCaretaker.m3, model scale 0.6): the Caretaker's
-- hologram inside the ship, at Dawson's spot. The script removes it when Dawson comes out (phase 1).
-- Position: measured in game (27 Sep 2026) in the ship, in front of the door with the red light strip, facing into
-- the room (offsets turned with the ship); spawns with the ship at its start point and flies in with it.
-- Spawned as NonPlayer (type 0), not Simple (Creature2 says 10): a Simple entity doesn't animate. Retail put the
-- Caretaker's look on an NPC with spell 63212 (Disguise 56685 + display name "The Caretaker").
-- --------------------------------------
SET @GUID = (SELECT IFNULL(MAX(`id`), 0) FROM `entity`);
INSERT INTO `entity` (`Id`, `Type`, `Creature`, `World`, `Area`, `X`, `Y`, `Z`, `RX`, `RY`, `RZ`, `DisplayInfo`, `OutfitInfo`, `Faction1`, `Faction2`) VALUES
    (@GUID + 1, 0, 56685, @WORLD, 0, -2543.8731, -869.334, -1169.0786, -3.1016, 0, 0, 24983, 0, 219, 219);

INSERT INTO `entity_event` (`id`, `eventId`, `phase`) VALUES
    (@GUID + 1, @EVENT_INTRO, 0);

INSERT INTO `entity_stats` (`Id`, `Stat`, `Value`) VALUES
    (@GUID + 1, 10, 15);

-- --------------------------------------
-- Vice-Marshal Dawson - Mission Briefer - Hycrest Adventure (creature 18365)
-- Intro objective 2113 TalkTo (TargetGroup 7183) and 2155 TimedWin 20 s.
-- Position: measured in game (27 Sep 2026), next to the hologram's spot in front of the door with the red light
-- strip. Retail: he comes out of that door; phase 1 of the intro event, set by the script after the Caretaker's
-- messages.
-- DisplayInfo: Creature2 display group 28260 has 46 variants (25459 first); 25459 is a guess.
-- OutfitInfo 8039 (outfit group 8734). Faction 219 as in Creature2.
-- --------------------------------------
SET @GUID = (SELECT IFNULL(MAX(`id`), 0) FROM `entity`);
INSERT INTO `entity` (`Id`, `Type`, `Creature`, `World`, `Area`, `X`, `Y`, `Z`, `RX`, `RY`, `RZ`, `DisplayInfo`, `OutfitInfo`, `Faction1`, `Faction2`) VALUES
    (@GUID + 1, 0, 18365, @WORLD, 0, -2519.001, -869.264, -1246.529, 1.5913, 0, 0, 25459, 8039, 219, 219);

INSERT INTO `entity_event` (`id`, `eventId`, `phase`) VALUES
    (@GUID + 1, @EVENT_INTRO, 1);

INSERT INTO `entity_stats` (`Id`, `Stat`, `Value`) VALUES
    (@GUID + 1, 10, 15);

-- --------------------------------------
-- Vesna Taranoft - Exile Spy - Hycrest Adventure (creature 17778)
-- Intro objective 189 "Meet with Vesna Taranoft" is a trigger volume at loc 13091 (Abandoned Barn).
-- She is needed for the whole run (Raid Warning, Priority Target), so she belongs to the main event.
-- Position: measured in game (27 Sep 2026), standing on the right of the barn by the crates and pipes.
-- DisplayInfo 23710 (only variant), OutfitInfo 8195. Faction 219.
-- --------------------------------------
SET @GUID = (SELECT IFNULL(MAX(`id`), 0) FROM `entity`);
INSERT INTO `entity` (`Id`, `Type`, `Creature`, `World`, `Area`, `X`, `Y`, `Z`, `RX`, `RY`, `RZ`, `DisplayInfo`, `OutfitInfo`, `Faction1`, `Faction2`) VALUES
    (@GUID + 1, 0, 17778, @WORLD, 0, -2528.1743, -925.81494, -1189.919, -0.6829455, 0, 0, 23710, 8195, 219, 219);

INSERT INTO `entity_event` (`id`, `eventId`, `phase`) VALUES
    (@GUID + 1, @EVENT_MAIN, 0);

INSERT INTO `entity_stats` (`Id`, `Stat`, `Value`) VALUES
    (@GUID + 1, 10, 15);

-- --------------------------------------
-- Ayita Sinnatus - Hycrest Adventure (creature 48032), Lysion's daughter
-- Seen in the video sitting on the hay bales in the Abandoned Barn during the intro. The intro dialogue
-- (en-US 160644-160650, "This is Lysion Sinnatus and his daughter, Ayita...") and the vote 45 debate
-- (464075-464089) need her there. No objective of 418 targets her; she is scene dressing + dialogue.
-- Variant: 48032 is the base adventure version (TargetGroup 6996, All Aboard "Meet Ayita in the safe house");
-- 56411 is "T3 Merciful" (Breach of Protocol), 56989/73313 are holograms (hub, housing).
-- Position: measured in game (27 Sep 2026), on top of the hay bales next to the ladder.
-- Sitting pose: not in Creature2; the script has to send emote 16 ("sit", StandState.Sit). Until then she
-- stands on the bales.
-- DisplayInfo 29552 (only variant), OutfitInfo 9521. Faction 219. Main event (419), like Vesna.
-- --------------------------------------
SET @GUID = (SELECT IFNULL(MAX(`id`), 0) FROM `entity`);
INSERT INTO `entity` (`Id`, `Type`, `Creature`, `World`, `Area`, `X`, `Y`, `Z`, `RX`, `RY`, `RZ`, `DisplayInfo`, `OutfitInfo`, `Faction1`, `Faction2`) VALUES
    (@GUID + 1, 0, 48032, @WORLD, 0, -2522.927, -923.20087, -1190.8815, 1.5358136, 0, 0, 29552, 9521, 219, 219);

INSERT INTO `entity_event` (`id`, `eventId`, `phase`) VALUES
    (@GUID + 1, @EVENT_MAIN, 0);

INSERT INTO `entity_stats` (`Id`, `Stat`, `Value`) VALUES
    (@GUID + 1, 10, 15);

-- --------------------------------------
-- Lysion Sinnatus <Cassian Rebel Leader> - Hycrest Adventure - Main Mission #01 (creature 17777)
-- In the barn dialogue (en-US 160649, 464076, 464083, 466928). Main event (419), like Vesna and Ayita.
-- Position: measured in game (27 Sep 2026), standing on the floor in front of the hay bales, below Ayita.
-- DisplayInfo 23711, OutfitInfo 8196. Faction 219.
-- --------------------------------------
SET @GUID = (SELECT IFNULL(MAX(`id`), 0) FROM `entity`);
INSERT INTO `entity` (`Id`, `Type`, `Creature`, `World`, `Area`, `X`, `Y`, `Z`, `RX`, `RY`, `RZ`, `DisplayInfo`, `OutfitInfo`, `Faction1`, `Faction2`) VALUES
    (@GUID + 1, 0, 17777, @WORLD, 0, -2524.9238, -925.81537, -1189.5778, 1.4186237, 0, 0, 23711, 8196, 219, 219);

INSERT INTO `entity_event` (`id`, `eventId`, `phase`) VALUES
    (@GUID + 1, @EVENT_MAIN, 0);

INSERT INTO `entity_stats` (`Id`, `Stat`, `Value`) VALUES
    (@GUID + 1, 10, 15);

-- --------------------------------------
-- Exit Simulation - Adventure - Exits Instance (creature 36869), the green portal in the orchard
-- Creation type 14 (InstancePortal), InstancePortal 33 "Exit Simulation" (type 3), model
-- PRP_Quest_Adventure_Door_01.m3 (display 30429). Main event (419).
-- Position: measured in game (27 Sep 2026). Rotation: measured -0.36; 1.21 and -1.93 faced the wrong way;
-- -1.93 needs another ~80 degrees counter-clockwise, then ~10 degrees clockwise: -0.70. Leaving through it isn't scripted yet and needs a return
-- location for instances without a match (HYCREST.md gap 11).
-- --------------------------------------
SET @GUID = (SELECT IFNULL(MAX(`id`), 0) FROM `entity`);
INSERT INTO `entity` (`Id`, `Type`, `Creature`, `World`, `Area`, `X`, `Y`, `Z`, `RX`, `RY`, `RZ`, `DisplayInfo`, `OutfitInfo`, `Faction1`, `Faction2`) VALUES
    (@GUID + 1, 14, 36869, @WORLD, 0, -2560.2874, -928.04047, -1196.5481, -0.70, 0, 0, 30429, 0, 219, 219);

INSERT INTO `entity_event` (`id`, `eventId`, `phase`) VALUES
    (@GUID + 1, @EVENT_MAIN, 0);

-- --------------------------------------
-- Not included yet (need positions or confirmation):
--   70556 Flying Ship, 70555 Camera: intro cinematic pieces; position unknown. (70556 is the Set Ship mesh exported
--   ~900 m long for the fly-in cinematic.)
--   53455 The Caretaker: "Hycrest Adventure Hub Flavor - Thayd", so the Thayd hub, not world 1149.
-- --------------------------------------

-- --------------------------------------
-- Barn Door - Platform (51064, PRP_Door_Generic_Garage_000.m3, display 29764) in the Abandoned Barn's door slot.
-- Position measured in game (28 Sep 2026, standing in the slot; facing = the player's, may need turning). The main
-- script keeps it open (State1) while players arrive, closes it (State0) for the briefing and the vote, and opens it
-- when the mission starts.
-- --------------------------------------
SET @GUID = (SELECT IFNULL(MAX(`id`), 0) FROM `entity`);
INSERT INTO `entity` (`Id`, `Type`, `Creature`, `World`, `Area`, `X`, `Y`, `Z`, `RX`, `RY`, `RZ`, `DisplayInfo`, `OutfitInfo`, `Faction1`, `Faction2`) VALUES
    (@GUID + 1, 11, 51064, @WORLD, 0, -2521.343, -925.2442, -1208.2617, 3.1038597, 0, 0, 29764, 0, 219, 219);

INSERT INTO `entity_event` (`id`, `eventId`, `phase`) VALUES
    (@GUID + 1, @EVENT_MAIN, 0);

-- --------------------------------------
-- Sinnatus's Barn (hideout, regroup 1775 after The Farmer's Daughter). Measured in game (28 Sep 2026).
-- Barn Door (51064): always there (419 phase 0), open; closed when the regroup there completes, open for the mission.
-- Hideout NPCs: main event 419 phase 11, set by the script when the regroup at Sinnatus's Barn starts. Ayita sits (the
-- script sits every Ayita).
-- --------------------------------------
SET @GUID = (SELECT IFNULL(MAX(`id`), 0) FROM `entity`);
INSERT INTO `entity` (`Id`, `Type`, `Creature`, `World`, `Area`, `X`, `Y`, `Z`, `RX`, `RY`, `RZ`, `DisplayInfo`, `OutfitInfo`, `Faction1`, `Faction2`) VALUES
    (@GUID + 1, 11, 51064, @WORLD, 0, -2389.7212, -925.71704, -1511.0367, -0.052370787, 0, 0, 29764, 0, 219, 219), -- Barn Door
    (@GUID + 2, 0, 48032, @WORLD, 0, -2389.76, -923.57166, -1527.8925, 1.5483615, 0, 0, 29552, 9521, 219, 219),   -- Ayita Sinnatus (seated)
    (@GUID + 3, 0, 17778, @WORLD, 0, -2393.0771, -926.28, -1529.4785, -2.8363886, 0, 0, 23710, 8195, 219, 219),   -- Vesna Taranoft (standing)
    (@GUID + 4, 0, 17777, @WORLD, 0, -2392.0635, -926.2801, -1525.2726, -0.05123353, 0, 0, 23711, 8196, 219, 219);  -- Lysion Sinnatus

INSERT INTO `entity_event` (`id`, `eventId`, `phase`) VALUES
    (@GUID + 1, @EVENT_MAIN, 0),
    (@GUID + 2, @EVENT_MAIN, 11),
    (@GUID + 3, @EVENT_MAIN, 11),
    (@GUID + 4, @EVENT_MAIN, 11);

INSERT INTO `entity_stats` (`Id`, `Stat`, `Value`) VALUES
    (@GUID + 2, 10, 15),
    (@GUID + 3, 10, 15),
    (@GUID + 4, 10, 15);

-- --------------------------------------
-- The Farmer's Daughter (public event 420), layout A
-- Positions measured in game against retail videos. The script sits Tarquim, Millithea and Prema down, moves the
-- patrolling scouts and the spotlight targets, and frees the captives once their guards are dead. One captive at a
-- time: Prema and the Responsebot are phase 1, set once Millithea is freed. The spotlight targets use the hostile
-- adventure faction so their machine gun fire hits players. The Recon Specialist isn't spawned here: the script calls
-- one when players cross the field north of Millithea (alarm). Retail has a second layout (Millithea elsewhere), not
-- added yet.
-- --------------------------------------
SET @EVENT_FARMERS_DAUGHTER = 420;
DELETE FROM `entity_event` WHERE `eventId` = @EVENT_FARMERS_DAUGHTER;
SET @GUID = (SELECT IFNULL(MAX(`id`), 0) FROM `entity`);
INSERT INTO `entity` (`Id`, `Type`, `Creature`, `World`, `Area`, `X`, `Y`, `Z`, `RX`, `RY`, `RZ`, `DisplayInfo`, `OutfitInfo`, `Faction1`, `Faction2`) VALUES
    (@GUID + 1, 0, 17773, @WORLD, 0, -2479.2297, -928.3108, -1208.6279, 1.143748, 0, 0, 29998, 8062, 219, 219), -- Tarquim Arcwulff (seated)
    (@GUID + 2, 0, 49490, @WORLD, 0, -2472.5518, -929.2157, -1577.3994, -3.0135684, 0, 0, 30004, 8066, 219, 219), -- Millithea (seated), layout A
    (@GUID + 3, 0, 51026, @WORLD, 0, -2472.1323, -929.5942, -1569.7185, 0.0020537376, 0, 0, 29558, 0, 1452, 1452), -- Predator Drone, guards Millithea
    (@GUID + 4, 0, 51026, @WORLD, 0, -2473.3782, -929.24347, -1582.0039, -3.1268535, 0, 0, 29558, 0, 1452, 1452), -- Predator Drone, guards Millithea
    (@GUID + 5, 0, 17772, @WORLD, 0, -2377.9238, -929.3451, -1641.9752, -2.9476466, 0, 0, 29997, 8066, 219, 219), -- Prema Arcwulff (seated)
    (@GUID + 6, 0, 18509, @WORLD, 0, -2381.2803, -929.2172, -1631.513, -1.4886488, 0, 0, 23091, 0, 1452, 1452), -- Shatterforce Responsebot, guards Prema
    (@GUID + 7, 0, 17856, @WORLD, 0, -2451.276, -927.9198, -1214.2766, -0.97930264, 0, 0, 30967, 8192, 1452, 1452), -- Dominion Scout, patrol by Tarquim (script)
    (@GUID + 8, 0, 17856, @WORLD, 0, -2403.6204, -924.5514, -1201.0248, 1.1545627, 0, 0, 30968, 8192, 1452, 1452), -- Dominion Scout, stationary
    (@GUID + 9, 0, 17856, @WORLD, 0, -2441.1294, -922.4717, -1393.5099, 2.0313685, 0, 0, 30970, 8192, 1452, 1452), -- Dominion Scout, stationary
    (@GUID + 10, 0, 17856, @WORLD, 0, -2444.2786, -927.7158, -1515.9824, 1.7310688, 0, 0, 30972, 8192, 1452, 1452), -- Dominion Scout, stationary
    (@GUID + 11, 0, 17856, @WORLD, 0, -2452.7524, -928.83093, -1555.9928, 1.8536189, 0, 0, 30967, 8192, 1452, 1452), -- Dominion Scout, patrol (script)
    (@GUID + 12, 0, 17856, @WORLD, 0, -2456.0398, -928.94116, -1630.2463, 0.9024365, 0, 0, 30968, 8192, 1452, 1452), -- Dominion Scout, stationary
    (@GUID + 13, 0, 17856, @WORLD, 0, -2381.129, -923.09406, -1698.4329, -3.117571, 0, 0, 30970, 8192, 1452, 1452), -- Dominion Scout, patrol (script)
    (@GUID + 15, 0, 17763, @WORLD, 0, -2521.6794, -927.764, -1365.4867, 0.0, 0, 0, 23754, 0, 1452, 1452), -- Automated Machine Gun - Spotlight Target (lane moved by the script)
    (@GUID + 16, 0, 17763, @WORLD, 0, -2468.567, -929.0733, -1593.2743, 0.0, 0, 0, 23754, 0, 1452, 1452), -- Automated Machine Gun - Spotlight Target (lane moved by the script)
    (@GUID + 17, 0, 17763, @WORLD, 0, -2490.1282, -920.8113, -1672.5258, 0.0, 0, 0, 23754, 0, 1452, 1452), -- Automated Machine Gun - Spotlight Target (lane moved by the script)
    (@GUID + 18, 0, 17763, @WORLD, 0, -2402.416, -928.3815, -1673.6968, 0.0, 0, 0, 23754, 0, 1452, 1452), -- Automated Machine Gun - Spotlight Target (lane moved by the script)
    (@GUID + 19, 0, 17856, @WORLD, 0, -2513.0195, -927.45575, -1393.5985, -2.598026, 0, 0, 30972, 8192, 1452, 1452); -- Dominion Scout, stationary (by the first spotlight, test 28 Sep)

INSERT INTO `entity_event` (`id`, `eventId`, `phase`) VALUES
    (@GUID + 1, @EVENT_FARMERS_DAUGHTER, 0),
    (@GUID + 2, @EVENT_FARMERS_DAUGHTER, 0),
    (@GUID + 3, @EVENT_FARMERS_DAUGHTER, 0),
    (@GUID + 4, @EVENT_FARMERS_DAUGHTER, 0),
    (@GUID + 5, @EVENT_FARMERS_DAUGHTER, 1), -- Prema and her guard appear once Millithea is freed
    (@GUID + 6, @EVENT_FARMERS_DAUGHTER, 1),
    (@GUID + 7, @EVENT_FARMERS_DAUGHTER, 0),
    (@GUID + 8, @EVENT_FARMERS_DAUGHTER, 0),
    (@GUID + 9, @EVENT_FARMERS_DAUGHTER, 0),
    (@GUID + 10, @EVENT_FARMERS_DAUGHTER, 0),
    (@GUID + 11, @EVENT_FARMERS_DAUGHTER, 0),
    (@GUID + 12, @EVENT_FARMERS_DAUGHTER, 0),
    (@GUID + 13, @EVENT_FARMERS_DAUGHTER, 0),
    (@GUID + 15, @EVENT_FARMERS_DAUGHTER, 0),
    (@GUID + 16, @EVENT_FARMERS_DAUGHTER, 0),
    (@GUID + 17, @EVENT_FARMERS_DAUGHTER, 0),
    (@GUID + 18, @EVENT_FARMERS_DAUGHTER, 0),
    (@GUID + 19, @EVENT_FARMERS_DAUGHTER, 0);

INSERT INTO `entity_stats` (`Id`, `Stat`, `Value`) VALUES
    (@GUID + 1, 10, 15),
    (@GUID + 2, 10, 15),
    (@GUID + 3, 10, 15),
    (@GUID + 4, 10, 15),
    (@GUID + 5, 10, 15),
    (@GUID + 6, 10, 15),
    (@GUID + 7, 10, 15),
    (@GUID + 8, 10, 15),
    (@GUID + 9, 10, 15),
    (@GUID + 10, 10, 15),
    (@GUID + 11, 10, 15),
    (@GUID + 12, 10, 15),
    (@GUID + 13, 10, 15),
    (@GUID + 15, 10, 15),
    (@GUID + 16, 10, 15),
    (@GUID + 17, 10, 15),
    (@GUID + 18, 10, 15),
    (@GUID + 19, 10, 15);
