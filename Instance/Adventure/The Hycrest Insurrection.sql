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
-- Position measured in game (28 Sep 2026, standing in the slot; facing = the player's, may need turning). Retail: the
-- door just appears when the barn closes and disappears when it opens, no animation. Main event phase 20, set by the
-- script when everyone is inside for the briefing; removed once the voted mission has everything on the map.
-- --------------------------------------
SET @GUID = (SELECT IFNULL(MAX(`id`), 0) FROM `entity`);
INSERT INTO `entity` (`Id`, `Type`, `Creature`, `World`, `Area`, `X`, `Y`, `Z`, `RX`, `RY`, `RZ`, `DisplayInfo`, `OutfitInfo`, `Faction1`, `Faction2`) VALUES
    (@GUID + 1, 11, 51064, @WORLD, 0, -2521.343, -925.2442, -1208.2617, 3.1038597, 0, 0, 29764, 0, 219, 219);

INSERT INTO `entity_event` (`id`, `eventId`, `phase`) VALUES
    (@GUID + 1, @EVENT_MAIN, 20);

-- --------------------------------------
-- Sinnatus's Barn (hideout, regroup 1775 after The Farmer's Daughter). Measured in game (28 Sep 2026).
-- Barn Door (51064): 419 phase 21, spawned (closed) when the regroup there completes, removed once the next mission
-- has everything on the map.
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
    (@GUID + 1, @EVENT_MAIN, 21),
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
    (@GUID + 6, 0, 18509, @WORLD, 0, -2366.8215, -929.4628, -1631.9248, 2.957307, 0, 0, 23091, 0, 1452, 1452), -- Shatterforce Responsebot, guards Prema
    (@GUID + 9, 0, 17856, @WORLD, 0, -2441.1294, -922.4717, -1393.5099, 2.0313685, 0, 0, 30970, 8192, 1452, 1452), -- Dominion Scout, stationary
    (@GUID + 10, 0, 17856, @WORLD, 0, -2444.2786, -927.7158, -1515.9824, 1.7310688, 0, 0, 30972, 8192, 1452, 1452), -- Dominion Scout, stationary
    (@GUID + 11, 0, 17856, @WORLD, 0, -2452.7524, -928.83093, -1555.9928, 1.8536189, 0, 0, 30967, 8192, 1452, 1452), -- Dominion Scout, patrol (script)
    (@GUID + 12, 0, 17856, @WORLD, 0, -2456.0398, -928.94116, -1630.2463, 0.9024365, 0, 0, 30968, 8192, 1452, 1452), -- Dominion Scout, stationary
    (@GUID + 13, 0, 17856, @WORLD, 0, -2381.129, -923.09406, -1698.4329, -3.117571, 0, 0, 30970, 8192, 1452, 1452), -- Dominion Scout, patrol (script)
    (@GUID + 15, 0, 17763, @WORLD, 0, -2484.1101, -927.7783, -1283.1149, 0.0, 0, 0, 23754, 0, 1452, 1452), -- Automated Machine Gun - Spotlight Target (lane moved by the script)
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

-- --------------------------------------
-- TEST (28 Sep 2026): one Dominion Scout on every ground-level spline of world 1149 (Spline2, type 1:
-- 153 splines; closed loops walked Cyclic, open paths BackAndForth, 2 m/s), to see which retail patrol routes
-- to keep and which to replace (spotlights and such). The server walks them itself (entity_spline + SplineAI). On the
-- Farmer's Daughter (event 420 phase 0), so they stay until the hideout's barn closes. Remove this block (or rows) when
-- done. Generated from the tables; 18 airborne splines and the 7 linear scripted walks left out.
-- --------------------------------------
SET @GUID = (SELECT IFNULL(MAX(`id`), 0) FROM `entity`);
INSERT INTO `entity` (`Id`, `Type`, `Creature`, `World`, `Area`, `X`, `Y`, `Z`, `RX`, `RY`, `RZ`, `DisplayInfo`, `OutfitInfo`, `Faction1`, `Faction2`) VALUES
    (@GUID + 1, 0, 17856, @WORLD, 0, -2546.5393, -896.5539, -1777.5662, -3.141593, 0, 0, 30968, 8192, 1452, 1452),
    (@GUID + 2, 0, 17856, @WORLD, 0, -2430.4180, -879.9113, -1932.4572, -3.141593, 0, 0, 30970, 8192, 1452, 1452),
    (@GUID + 3, 0, 17856, @WORLD, 0, -2415.5344, -877.0535, -1955.6509, -3.141593, 0, 0, 30972, 8192, 1452, 1452),
    (@GUID + 4, 0, 17856, @WORLD, 0, -2341.1714, -873.0891, -1855.5790, -3.141593, 0, 0, 30967, 8192, 1452, 1452),
    (@GUID + 5, 0, 17856, @WORLD, 0, -2319.9087, -869.2168, -1965.0850, -3.141593, 0, 0, 30968, 8192, 1452, 1452),
    (@GUID + 6, 0, 17856, @WORLD, 0, -2488.7500, -882.0675, -1819.7371, -3.141593, 0, 0, 30970, 8192, 1452, 1452),
    (@GUID + 7, 0, 17856, @WORLD, 0, -2444.5244, -880.4712, -1890.4136, -3.141593, 0, 0, 30972, 8192, 1452, 1452),
    (@GUID + 8, 0, 17856, @WORLD, 0, -2376.0737, -873.3408, -1922.0822, -3.141593, 0, 0, 30967, 8192, 1452, 1452),
    (@GUID + 9, 0, 17856, @WORLD, 0, -2318.6279, -871.5619, -1935.5638, -3.141593, 0, 0, 30968, 8192, 1452, 1452),
    (@GUID + 10, 0, 17856, @WORLD, 0, -2207.0840, -929.0875, -1247.8918, 0.833237, 0, 0, 30970, 8192, 1452, 1452),
    (@GUID + 11, 0, 17856, @WORLD, 0, -2237.4941, -929.6115, -1278.3489, -0.735359, 0, 0, 30972, 8192, 1452, 1452),
    (@GUID + 12, 0, 17856, @WORLD, 0, -2222.0601, -929.3502, -1305.3048, -0.282276, 0, 0, 30967, 8192, 1452, 1452),
    (@GUID + 13, 0, 17856, @WORLD, 0, -2190.3650, -927.5854, -1306.1884, 1.954583, 0, 0, 30968, 8192, 1452, 1452),
    (@GUID + 14, 0, 17856, @WORLD, 0, -2248.6379, -928.7823, -1453.7770, -2.621533, 0, 0, 30970, 8192, 1452, 1452),
    (@GUID + 15, 0, 17856, @WORLD, 0, -2304.8542, -924.8077, -1425.5417, -1.669520, 0, 0, 30972, 8192, 1452, 1452),
    (@GUID + 16, 0, 17856, @WORLD, 0, -2247.3259, -927.9666, -1411.9745, -2.120057, 0, 0, 30967, 8192, 1452, 1452),
    (@GUID + 17, 0, 17856, @WORLD, 0, -2213.4800, -926.3884, -1400.7168, 0.185485, 0, 0, 30968, 8192, 1452, 1452),
    (@GUID + 18, 0, 17856, @WORLD, 0, -2211.7227, -926.1721, -1459.0662, -2.386970, 0, 0, 30970, 8192, 1452, 1452),
    (@GUID + 19, 0, 17856, @WORLD, 0, -2228.9526, -926.1727, -1502.5939, 0.065676, 0, 0, 30972, 8192, 1452, 1452),
    (@GUID + 20, 0, 17856, @WORLD, 0, -2362.9236, -922.8668, -1438.7014, -2.448422, 0, 0, 30967, 8192, 1452, 1452),
    (@GUID + 21, 0, 17856, @WORLD, 0, -2349.3638, -925.0932, -1257.0768, 3.137776, 0, 0, 30968, 8192, 1452, 1452),
    (@GUID + 22, 0, 17856, @WORLD, 0, -2370.3982, -924.1212, -1231.8225, 1.554596, 0, 0, 30970, 8192, 1452, 1452),
    (@GUID + 23, 0, 17856, @WORLD, 0, -2317.5564, -920.9146, -1198.8372, -0.762864, 0, 0, 30972, 8192, 1452, 1452),
    (@GUID + 24, 0, 17856, @WORLD, 0, -2362.4792, -929.3548, -1513.0005, 1.491501, 0, 0, 30967, 8192, 1452, 1452),
    (@GUID + 25, 0, 17856, @WORLD, 0, -2375.0063, -930.2412, -1554.6823, -0.379744, 0, 0, 30968, 8192, 1452, 1452),
    (@GUID + 26, 0, 17856, @WORLD, 0, -2389.3823, -926.2544, -1602.6337, 0.755579, 0, 0, 30970, 8192, 1452, 1452),
    (@GUID + 27, 0, 17856, @WORLD, 0, -2342.2275, -925.9800, -1664.8235, -2.703460, 0, 0, 30972, 8192, 1452, 1452),
    (@GUID + 28, 0, 17856, @WORLD, 0, -2343.5979, -925.9783, -1671.2517, 2.586773, 0, 0, 30967, 8192, 1452, 1452),
    (@GUID + 29, 0, 17856, @WORLD, 0, -2424.6421, -923.9310, -1678.0225, -2.844436, 0, 0, 30968, 8192, 1452, 1452),
    (@GUID + 30, 0, 17856, @WORLD, 0, -2408.5889, -930.5028, -1599.0679, -0.065050, 0, 0, 30970, 8192, 1452, 1452),
    (@GUID + 31, 0, 17856, @WORLD, 0, -2465.5366, -922.3412, -1679.4854, -1.127098, 0, 0, 30972, 8192, 1452, 1452),
    (@GUID + 32, 0, 17856, @WORLD, 0, -2245.1428, -923.4831, -1686.0023, 1.424139, 0, 0, 30967, 8192, 1452, 1452),
    (@GUID + 33, 0, 17856, @WORLD, 0, -2298.8872, -926.5031, -1643.8555, -0.110741, 0, 0, 30968, 8192, 1452, 1452),
    (@GUID + 34, 0, 17856, @WORLD, 0, -2484.4331, -918.3319, -1694.7727, -0.088127, 0, 0, 30970, 8192, 1452, 1452),
    (@GUID + 35, 0, 17856, @WORLD, 0, -2334.7390, -900.7168, -1794.2461, -2.443586, 0, 0, 30972, 8192, 1452, 1452),
    (@GUID + 36, 0, 17856, @WORLD, 0, -2639.3108, -917.2076, -1592.4073, 2.820823, 0, 0, 30967, 8192, 1452, 1452),
    (@GUID + 37, 0, 17856, @WORLD, 0, -2638.1333, -929.2353, -1439.6206, -0.906151, 0, 0, 30968, 8192, 1452, 1452),
    (@GUID + 38, 0, 17856, @WORLD, 0, -2605.7717, -928.0572, -1385.5016, 0.173525, 0, 0, 30970, 8192, 1452, 1452),
    (@GUID + 39, 0, 17856, @WORLD, 0, -2568.8479, -928.4366, -1500.6844, -3.018491, 0, 0, 30972, 8192, 1452, 1452),
    (@GUID + 40, 0, 17856, @WORLD, 0, -2628.7520, -926.6855, -1416.2031, -0.538774, 0, 0, 30967, 8192, 1452, 1452),
    (@GUID + 41, 0, 17856, @WORLD, 0, -2558.9175, -929.5172, -1462.0400, -2.308193, 0, 0, 30968, 8192, 1452, 1452),
    (@GUID + 42, 0, 17856, @WORLD, 0, -2607.3535, -928.1109, -1333.2006, -0.626409, 0, 0, 30970, 8192, 1452, 1452),
    (@GUID + 43, 0, 17856, @WORLD, 0, -2460.0657, -928.0908, -1210.6251, -3.141593, 0, 0, 30972, 8192, 1452, 1452),
    (@GUID + 45, 0, 17856, @WORLD, 0, -2571.2788, -927.8309, -1280.9978, 2.884346, 0, 0, 30968, 8192, 1452, 1452),
    (@GUID + 46, 0, 17856, @WORLD, 0, -2441.4407, -926.6258, -1246.5859, -2.487520, 0, 0, 30970, 8192, 1452, 1452),
    (@GUID + 47, 0, 17856, @WORLD, 0, -2584.8467, -916.3095, -1633.9220, -3.141593, 0, 0, 30972, 8192, 1452, 1452),
    (@GUID + 48, 0, 17856, @WORLD, 0, -2390.5596, -928.1638, -1491.8195, 2.958689, 0, 0, 30967, 8192, 1452, 1452),
    (@GUID + 50, 0, 17856, @WORLD, 0, -2369.2605, -929.8516, -1637.4325, 2.569563, 0, 0, 30970, 8192, 1452, 1452),
    (@GUID + 51, 0, 17856, @WORLD, 0, -2388.7275, -926.5038, -1597.6868, 2.835352, 0, 0, 30972, 8192, 1452, 1452),
    (@GUID + 52, 0, 17856, @WORLD, 0, -2270.5310, -925.9852, -1677.5615, -2.578750, 0, 0, 30967, 8192, 1452, 1452),
    (@GUID + 53, 0, 17856, @WORLD, 0, -2416.8772, -923.1720, -1693.5861, -2.674083, 0, 0, 30968, 8192, 1452, 1452),
    (@GUID + 54, 0, 17856, @WORLD, 0, -2340.0100, -927.4662, -1639.3276, -2.119758, 0, 0, 30970, 8192, 1452, 1452),
    (@GUID + 55, 0, 17856, @WORLD, 0, -2259.2122, -920.8197, -1698.1327, -2.214874, 0, 0, 30972, 8192, 1452, 1452),
    (@GUID + 56, 0, 17856, @WORLD, 0, -2264.7549, -928.4187, -1645.6061, 2.142671, 0, 0, 30967, 8192, 1452, 1452),
    (@GUID + 57, 0, 17856, @WORLD, 0, -2385.9255, -927.8702, -1667.9510, -2.347432, 0, 0, 30968, 8192, 1452, 1452),
    (@GUID + 58, 0, 17856, @WORLD, 0, -2320.6182, -923.3251, -1696.9077, 2.933191, 0, 0, 30970, 8192, 1452, 1452),
    (@GUID + 59, 0, 17856, @WORLD, 0, -2362.2126, -930.1998, -1587.4353, -2.280581, 0, 0, 30972, 8192, 1452, 1452),
    (@GUID + 60, 0, 17856, @WORLD, 0, -2338.5955, -929.3781, -1597.6248, 2.966493, 0, 0, 30967, 8192, 1452, 1452),
    (@GUID + 61, 0, 17856, @WORLD, 0, -2296.1021, -926.1059, -1642.6744, -2.865060, 0, 0, 30968, 8192, 1452, 1452),
    (@GUID + 62, 0, 17856, @WORLD, 0, -2569.9177, -910.0272, -1690.9678, -1.373170, 0, 0, 30970, 8192, 1452, 1452),
    (@GUID + 64, 0, 17856, @WORLD, 0, -2290.7002, -921.8855, -1194.0387, 0.145026, 0, 0, 30967, 8192, 1452, 1452),
    (@GUID + 65, 0, 17856, @WORLD, 0, -2477.6799, -925.2037, -1438.9785, -0.008747, 0, 0, 30968, 8192, 1452, 1452),
    (@GUID + 66, 0, 17856, @WORLD, 0, -2339.5935, -927.2448, -1496.1356, 0.847074, 0, 0, 30970, 8192, 1452, 1452),
    (@GUID + 67, 0, 17856, @WORLD, 0, -2296.8596, -924.6996, -1261.7419, 1.691965, 0, 0, 30972, 8192, 1452, 1452),
    (@GUID + 68, 0, 17856, @WORLD, 0, -2519.2334, -927.9923, -1426.4374, 2.683233, 0, 0, 30967, 8192, 1452, 1452),
    (@GUID + 69, 0, 17856, @WORLD, 0, -2649.7917, -918.9633, -1572.0356, -1.054766, 0, 0, 30968, 8192, 1452, 1452),
    (@GUID + 70, 0, 17856, @WORLD, 0, -2268.7791, -921.7995, -1725.7603, -2.871122, 0, 0, 30970, 8192, 1452, 1452),
    (@GUID + 71, 0, 17856, @WORLD, 0, -2202.5479, -929.0908, -1243.1488, -0.524060, 0, 0, 30972, 8192, 1452, 1452),
    (@GUID + 72, 0, 17856, @WORLD, 0, -2320.0916, -930.4386, -1585.7894, 0.089041, 0, 0, 30967, 8192, 1452, 1452),
    (@GUID + 73, 0, 17856, @WORLD, 0, -2455.1035, -910.2434, -1729.9281, -0.311592, 0, 0, 30968, 8192, 1452, 1452),
    (@GUID + 75, 0, 17856, @WORLD, 0, -2366.7043, -923.9154, -1288.3143, -1.080193, 0, 0, 30972, 8192, 1452, 1452),
    (@GUID + 76, 0, 17856, @WORLD, 0, -2390.7920, -926.2801, -1514.5188, -3.141593, 0, 0, 30967, 8192, 1452, 1452),
    (@GUID + 77, 0, 17856, @WORLD, 0, -2358.3030, -924.1985, -1462.0127, -3.141593, 0, 0, 30968, 8192, 1452, 1452),
    (@GUID + 78, 0, 17856, @WORLD, 0, -2517.1089, -925.8153, -1185.4427, -0.802073, 0, 0, 30970, 8192, 1452, 1452),
    (@GUID + 79, 0, 17856, @WORLD, 0, -2350.0911, -872.0595, -1918.9324, -3.141593, 0, 0, 30972, 8192, 1452, 1452),
    (@GUID + 80, 0, 17856, @WORLD, 0, -2322.5813, -923.4135, -1515.1854, -2.927696, 0, 0, 30967, 8192, 1452, 1452),
    (@GUID + 81, 0, 17856, @WORLD, 0, -2311.4377, -923.2948, -1508.1396, -3.021916, 0, 0, 30968, 8192, 1452, 1452),
    (@GUID + 82, 0, 17856, @WORLD, 0, -2330.5464, -925.4948, -1524.9125, 2.657127, 0, 0, 30970, 8192, 1452, 1452),
    (@GUID + 84, 0, 17856, @WORLD, 0, -2408.1182, -926.1611, -1517.7570, 3.049733, 0, 0, 30967, 8192, 1452, 1452),
    (@GUID + 86, 0, 17856, @WORLD, 0, -2422.1382, -927.8348, -1491.9163, 2.421306, 0, 0, 30970, 8192, 1452, 1452),
    (@GUID + 87, 0, 17856, @WORLD, 0, -2763.6306, -918.3665, -1475.9076, -0.591146, 0, 0, 30972, 8192, 1452, 1452),
    (@GUID + 88, 0, 17856, @WORLD, 0, -2754.4629, -859.8756, -1614.8442, 2.348780, 0, 0, 30967, 8192, 1452, 1452),
    (@GUID + 89, 0, 17856, @WORLD, 0, -2659.0022, -924.2000, -1478.6244, -2.591103, 0, 0, 30968, 8192, 1452, 1452),
    (@GUID + 90, 0, 17856, @WORLD, 0, -2613.7874, -918.2585, -1600.7618, -2.748268, 0, 0, 30970, 8192, 1452, 1452),
    (@GUID + 91, 0, 17856, @WORLD, 0, -2662.3501, -920.1079, -1545.8508, -1.387601, 0, 0, 30972, 8192, 1452, 1452),
    (@GUID + 92, 0, 17856, @WORLD, 0, -2713.0288, -917.2029, -1533.1592, -1.853158, 0, 0, 30967, 8192, 1452, 1452),
    (@GUID + 93, 0, 17856, @WORLD, 0, -2609.3140, -925.9476, -1504.3844, -1.103763, 0, 0, 30968, 8192, 1452, 1452),
    (@GUID + 94, 0, 17856, @WORLD, 0, -2556.6304, -928.6423, -1546.0491, 2.114244, 0, 0, 30970, 8192, 1452, 1452),
    (@GUID + 95, 0, 17856, @WORLD, 0, -2555.8213, -929.7270, -1309.2010, -3.141593, 0, 0, 30972, 8192, 1452, 1452),
    (@GUID + 96, 0, 17856, @WORLD, 0, -2568.2146, -927.5577, -1309.6948, -1.663037, 0, 0, 30967, 8192, 1452, 1452),
    (@GUID + 97, 0, 17856, @WORLD, 0, -2567.9734, -929.3442, -1332.0280, -2.450444, 0, 0, 30968, 8192, 1452, 1452),
    (@GUID + 98, 0, 17856, @WORLD, 0, -2541.2742, -929.7158, -1348.7952, 1.528343, 0, 0, 30970, 8192, 1452, 1452),
    (@GUID + 99, 0, 17856, @WORLD, 0, -2520.1929, -927.8271, -1335.3672, 0.514903, 0, 0, 30972, 8192, 1452, 1452),
    (@GUID + 100, 0, 17856, @WORLD, 0, -2323.6006, -925.1069, -1302.6483, -0.288310, 0, 0, 30967, 8192, 1452, 1452),
    (@GUID + 101, 0, 17856, @WORLD, 0, -2338.2908, -921.9292, -1329.7443, 3.019637, 0, 0, 30968, 8192, 1452, 1452),
    (@GUID + 102, 0, 17856, @WORLD, 0, -2328.8589, -921.8908, -1350.3374, 1.610235, 0, 0, 30970, 8192, 1452, 1452),
    (@GUID + 103, 0, 17856, @WORLD, 0, -2312.8135, -922.8083, -1349.0508, 1.249199, 0, 0, 30972, 8192, 1452, 1452),
    (@GUID + 104, 0, 17856, @WORLD, 0, -2297.8491, -924.1686, -1331.1360, 3.100792, 0, 0, 30967, 8192, 1452, 1452),
    (@GUID + 105, 0, 17856, @WORLD, 0, -2619.0386, -915.5453, -1618.3215, -0.001893, 0, 0, 30968, 8192, 1452, 1452),
    (@GUID + 106, 0, 17856, @WORLD, 0, -2607.5669, -915.9853, -1621.3712, 0.481418, 0, 0, 30970, 8192, 1452, 1452),
    (@GUID + 107, 0, 17856, @WORLD, 0, -2584.8857, -912.4669, -1643.7367, -2.420172, 0, 0, 30972, 8192, 1452, 1452),
    (@GUID + 108, 0, 17856, @WORLD, 0, -2587.7822, -909.8647, -1659.6001, -1.976113, 0, 0, 30967, 8192, 1452, 1452),
    (@GUID + 109, 0, 17856, @WORLD, 0, -2603.1443, -908.5812, -1670.3340, -1.791622, 0, 0, 30968, 8192, 1452, 1452),
    (@GUID + 110, 0, 17856, @WORLD, 0, -2281.9224, -926.8220, -1564.5543, -1.364491, 0, 0, 30970, 8192, 1452, 1452),
    (@GUID + 111, 0, 17856, @WORLD, 0, -2294.1289, -926.6111, -1562.7520, -1.616916, 0, 0, 30972, 8192, 1452, 1452),
    (@GUID + 112, 0, 17856, @WORLD, 0, -2306.3313, -929.8511, -1593.2247, 3.034396, 0, 0, 30967, 8192, 1452, 1452),
    (@GUID + 113, 0, 17856, @WORLD, 0, -2291.5520, -928.0159, -1611.5833, 2.699071, 0, 0, 30968, 8192, 1452, 1452),
    (@GUID + 114, 0, 17856, @WORLD, 0, -2265.8428, -929.0908, -1601.1726, 3.042562, 0, 0, 30970, 8192, 1452, 1452),
    (@GUID + 115, 0, 17856, @WORLD, 0, -2446.7356, -928.9658, -1627.0905, 1.404914, 0, 0, 30972, 8192, 1452, 1452),
    (@GUID + 116, 0, 17856, @WORLD, 0, -2473.8643, -927.8594, -1631.8379, -1.934675, 0, 0, 30967, 8192, 1452, 1452),
    (@GUID + 117, 0, 17856, @WORLD, 0, -2467.0847, -926.3747, -1651.0111, -2.853701, 0, 0, 30968, 8192, 1452, 1452),
    (@GUID + 118, 0, 17856, @WORLD, 0, -2459.2249, -924.0008, -1670.4136, -1.543787, 0, 0, 30970, 8192, 1452, 1452),
    (@GUID + 119, 0, 17856, @WORLD, 0, -2425.9185, -927.3434, -1658.9060, 0.016706, 0, 0, 30972, 8192, 1452, 1452),
    (@GUID + 120, 0, 17856, @WORLD, 0, -2291.1716, -872.2141, -1918.2372, -3.141593, 0, 0, 30967, 8192, 1452, 1452),
    (@GUID + 121, 0, 17856, @WORLD, 0, -2303.1631, -923.5451, -1343.1506, -3.141593, 0, 0, 30968, 8192, 1452, 1452),
    (@GUID + 122, 0, 17856, @WORLD, 0, -2321.3057, -925.9499, -1290.5149, -3.141593, 0, 0, 30970, 8192, 1452, 1452),
    (@GUID + 123, 0, 17856, @WORLD, 0, -2397.8594, -924.7783, -1223.0437, -3.141593, 0, 0, 30972, 8192, 1452, 1452),
    (@GUID + 124, 0, 17856, @WORLD, 0, -2355.2041, -921.1218, -1200.0283, -3.141593, 0, 0, 30967, 8192, 1452, 1452),
    (@GUID + 125, 0, 17856, @WORLD, 0, -2263.6555, -924.7783, -1335.0123, 0.248213, 0, 0, 30968, 8192, 1452, 1452),
    (@GUID + 126, 0, 17856, @WORLD, 0, -2226.1965, -929.3102, -1263.6118, -3.141593, 0, 0, 30970, 8192, 1452, 1452),
    (@GUID + 127, 0, 17856, @WORLD, 0, -2348.1311, -927.8448, -1486.1561, -3.141593, 0, 0, 30972, 8192, 1452, 1452),
    (@GUID + 128, 0, 17856, @WORLD, 0, -2240.9167, -929.3137, -1480.4342, -3.141593, 0, 0, 30967, 8192, 1452, 1452),
    (@GUID + 129, 0, 17856, @WORLD, 0, -2674.6252, -881.0894, -1782.1669, -3.141593, 0, 0, 30968, 8192, 1452, 1452),
    (@GUID + 130, 0, 17856, @WORLD, 0, -2337.7581, -908.7152, -1767.5038, -3.141593, 0, 0, 30970, 8192, 1452, 1452),
    (@GUID + 131, 0, 17856, @WORLD, 0, -2350.2651, -922.2487, -1202.3861, -3.141593, 0, 0, 30972, 8192, 1452, 1452),
    (@GUID + 132, 0, 17856, @WORLD, 0, -2350.6108, -922.8124, -1207.4022, -3.141593, 0, 0, 30967, 8192, 1452, 1452),
    (@GUID + 133, 0, 17856, @WORLD, 0, -2292.1938, -869.9551, -1971.8549, -3.141593, 0, 0, 30968, 8192, 1452, 1452),
    (@GUID + 134, 0, 17856, @WORLD, 0, -2383.3298, -874.4614, -1921.5958, -3.141593, 0, 0, 30970, 8192, 1452, 1452),
    (@GUID + 135, 0, 17856, @WORLD, 0, -2488.8518, -920.5266, -1675.8235, -0.747785, 0, 0, 30972, 8192, 1452, 1452),
    (@GUID + 136, 0, 17856, @WORLD, 0, -2559.6433, -908.5110, -1731.4412, -3.141593, 0, 0, 30967, 8192, 1452, 1452),
    (@GUID + 137, 0, 17856, @WORLD, 0, -2570.7659, -910.2632, -1680.2649, -3.141593, 0, 0, 30968, 8192, 1452, 1452),
    (@GUID + 138, 0, 17856, @WORLD, 0, -2521.6938, -879.7786, -1828.5488, -3.141593, 0, 0, 30970, 8192, 1452, 1452),
    (@GUID + 139, 0, 17856, @WORLD, 0, -2483.1506, -882.1530, -1817.8329, -3.141593, 0, 0, 30972, 8192, 1452, 1452),
    (@GUID + 140, 0, 17856, @WORLD, 0, -2363.2449, -864.2561, -1975.3887, -3.141593, 0, 0, 30967, 8192, 1452, 1452),
    (@GUID + 141, 0, 17856, @WORLD, 0, -2328.2107, -923.8275, -1203.8024, -3.141593, 0, 0, 30968, 8192, 1452, 1452),
    (@GUID + 142, 0, 17856, @WORLD, 0, -2317.1416, -868.3557, -1878.6327, -3.141593, 0, 0, 30970, 8192, 1452, 1452),
    (@GUID + 143, 0, 17856, @WORLD, 0, -2411.3540, -922.6606, -1437.7656, -3.141593, 0, 0, 30972, 8192, 1452, 1452),
    (@GUID + 144, 0, 17856, @WORLD, 0, -2347.2664, -924.1139, -1461.1854, -3.141593, 0, 0, 30967, 8192, 1452, 1452),
    (@GUID + 145, 0, 17856, @WORLD, 0, -2300.8096, -926.0388, -1460.0459, -3.141593, 0, 0, 30968, 8192, 1452, 1452),
    (@GUID + 147, 0, 17856, @WORLD, 0, -2383.7368, -919.6680, -1407.2397, -3.141593, 0, 0, 30972, 8192, 1452, 1452),
    (@GUID + 148, 0, 17856, @WORLD, 0, -2366.8652, -918.8406, -1387.7743, -3.141593, 0, 0, 30967, 8192, 1452, 1452),
    (@GUID + 149, 0, 17856, @WORLD, 0, -2345.0400, -919.1053, -1374.0790, -3.141593, 0, 0, 30968, 8192, 1452, 1452),
    (@GUID + 150, 0, 17856, @WORLD, 0, -2304.6929, -922.8972, -1376.9624, -3.141593, 0, 0, 30970, 8192, 1452, 1452),
    (@GUID + 151, 0, 17856, @WORLD, 0, -2273.0698, -926.1221, -1409.3198, -3.141593, 0, 0, 30972, 8192, 1452, 1452),
    (@GUID + 152, 0, 17856, @WORLD, 0, -2298.7070, -925.7532, -1437.3081, -3.141593, 0, 0, 30967, 8192, 1452, 1452),
    (@GUID + 153, 0, 17856, @WORLD, 0, -2494.0847, -919.9992, -1671.8879, -3.141593, 0, 0, 30968, 8192, 1452, 1452);

INSERT INTO `entity_event` (`id`, `eventId`, `phase`) VALUES
    (@GUID + 1, @EVENT_FARMERS_DAUGHTER, 0),
    (@GUID + 2, @EVENT_FARMERS_DAUGHTER, 0),
    (@GUID + 3, @EVENT_FARMERS_DAUGHTER, 0),
    (@GUID + 4, @EVENT_FARMERS_DAUGHTER, 0),
    (@GUID + 5, @EVENT_FARMERS_DAUGHTER, 0),
    (@GUID + 6, @EVENT_FARMERS_DAUGHTER, 0),
    (@GUID + 7, @EVENT_FARMERS_DAUGHTER, 0),
    (@GUID + 8, @EVENT_FARMERS_DAUGHTER, 0),
    (@GUID + 9, @EVENT_FARMERS_DAUGHTER, 0),
    (@GUID + 10, @EVENT_FARMERS_DAUGHTER, 0),
    (@GUID + 11, @EVENT_FARMERS_DAUGHTER, 0),
    (@GUID + 12, @EVENT_FARMERS_DAUGHTER, 0),
    (@GUID + 13, @EVENT_FARMERS_DAUGHTER, 0),
    (@GUID + 14, @EVENT_FARMERS_DAUGHTER, 0),
    (@GUID + 15, @EVENT_FARMERS_DAUGHTER, 0),
    (@GUID + 16, @EVENT_FARMERS_DAUGHTER, 0),
    (@GUID + 17, @EVENT_FARMERS_DAUGHTER, 0),
    (@GUID + 18, @EVENT_FARMERS_DAUGHTER, 0),
    (@GUID + 19, @EVENT_FARMERS_DAUGHTER, 0),
    (@GUID + 20, @EVENT_FARMERS_DAUGHTER, 0),
    (@GUID + 21, @EVENT_FARMERS_DAUGHTER, 0),
    (@GUID + 22, @EVENT_FARMERS_DAUGHTER, 0),
    (@GUID + 23, @EVENT_FARMERS_DAUGHTER, 0),
    (@GUID + 24, @EVENT_FARMERS_DAUGHTER, 0),
    (@GUID + 25, @EVENT_FARMERS_DAUGHTER, 0),
    (@GUID + 26, @EVENT_FARMERS_DAUGHTER, 0),
    (@GUID + 27, @EVENT_FARMERS_DAUGHTER, 0),
    (@GUID + 28, @EVENT_FARMERS_DAUGHTER, 0),
    (@GUID + 29, @EVENT_FARMERS_DAUGHTER, 0),
    (@GUID + 30, @EVENT_FARMERS_DAUGHTER, 0),
    (@GUID + 31, @EVENT_FARMERS_DAUGHTER, 0),
    (@GUID + 32, @EVENT_FARMERS_DAUGHTER, 0),
    (@GUID + 33, @EVENT_FARMERS_DAUGHTER, 0),
    (@GUID + 34, @EVENT_FARMERS_DAUGHTER, 0),
    (@GUID + 35, @EVENT_FARMERS_DAUGHTER, 0),
    (@GUID + 36, @EVENT_FARMERS_DAUGHTER, 0),
    (@GUID + 37, @EVENT_FARMERS_DAUGHTER, 0),
    (@GUID + 38, @EVENT_FARMERS_DAUGHTER, 0),
    (@GUID + 39, @EVENT_FARMERS_DAUGHTER, 0),
    (@GUID + 40, @EVENT_FARMERS_DAUGHTER, 0),
    (@GUID + 41, @EVENT_FARMERS_DAUGHTER, 0),
    (@GUID + 42, @EVENT_FARMERS_DAUGHTER, 0),
    (@GUID + 43, @EVENT_FARMERS_DAUGHTER, 0),
    (@GUID + 45, @EVENT_FARMERS_DAUGHTER, 0),
    (@GUID + 46, @EVENT_FARMERS_DAUGHTER, 0),
    (@GUID + 47, @EVENT_FARMERS_DAUGHTER, 0),
    (@GUID + 48, @EVENT_FARMERS_DAUGHTER, 0),
    (@GUID + 50, @EVENT_FARMERS_DAUGHTER, 0),
    (@GUID + 51, @EVENT_FARMERS_DAUGHTER, 0),
    (@GUID + 52, @EVENT_FARMERS_DAUGHTER, 0),
    (@GUID + 53, @EVENT_FARMERS_DAUGHTER, 0),
    (@GUID + 54, @EVENT_FARMERS_DAUGHTER, 0),
    (@GUID + 55, @EVENT_FARMERS_DAUGHTER, 0),
    (@GUID + 56, @EVENT_FARMERS_DAUGHTER, 0),
    (@GUID + 57, @EVENT_FARMERS_DAUGHTER, 0),
    (@GUID + 58, @EVENT_FARMERS_DAUGHTER, 0),
    (@GUID + 59, @EVENT_FARMERS_DAUGHTER, 0),
    (@GUID + 60, @EVENT_FARMERS_DAUGHTER, 0),
    (@GUID + 61, @EVENT_FARMERS_DAUGHTER, 0),
    (@GUID + 62, @EVENT_FARMERS_DAUGHTER, 0),
    (@GUID + 64, @EVENT_FARMERS_DAUGHTER, 0),
    (@GUID + 65, @EVENT_FARMERS_DAUGHTER, 0),
    (@GUID + 66, @EVENT_FARMERS_DAUGHTER, 0),
    (@GUID + 67, @EVENT_FARMERS_DAUGHTER, 0),
    (@GUID + 68, @EVENT_FARMERS_DAUGHTER, 0),
    (@GUID + 69, @EVENT_FARMERS_DAUGHTER, 0),
    (@GUID + 70, @EVENT_FARMERS_DAUGHTER, 0),
    (@GUID + 71, @EVENT_FARMERS_DAUGHTER, 0),
    (@GUID + 72, @EVENT_FARMERS_DAUGHTER, 0),
    (@GUID + 73, @EVENT_FARMERS_DAUGHTER, 0),
    (@GUID + 75, @EVENT_FARMERS_DAUGHTER, 0),
    (@GUID + 76, @EVENT_FARMERS_DAUGHTER, 0),
    (@GUID + 77, @EVENT_FARMERS_DAUGHTER, 0),
    (@GUID + 78, @EVENT_FARMERS_DAUGHTER, 0),
    (@GUID + 79, @EVENT_FARMERS_DAUGHTER, 0),
    (@GUID + 80, @EVENT_FARMERS_DAUGHTER, 0),
    (@GUID + 81, @EVENT_FARMERS_DAUGHTER, 0),
    (@GUID + 82, @EVENT_FARMERS_DAUGHTER, 0),
    (@GUID + 84, @EVENT_FARMERS_DAUGHTER, 0),
    (@GUID + 86, @EVENT_FARMERS_DAUGHTER, 0),
    (@GUID + 87, @EVENT_FARMERS_DAUGHTER, 0),
    (@GUID + 88, @EVENT_FARMERS_DAUGHTER, 0),
    (@GUID + 89, @EVENT_FARMERS_DAUGHTER, 0),
    (@GUID + 90, @EVENT_FARMERS_DAUGHTER, 0),
    (@GUID + 91, @EVENT_FARMERS_DAUGHTER, 0),
    (@GUID + 92, @EVENT_FARMERS_DAUGHTER, 0),
    (@GUID + 93, @EVENT_FARMERS_DAUGHTER, 0),
    (@GUID + 94, @EVENT_FARMERS_DAUGHTER, 0),
    (@GUID + 95, @EVENT_FARMERS_DAUGHTER, 0),
    (@GUID + 96, @EVENT_FARMERS_DAUGHTER, 0),
    (@GUID + 97, @EVENT_FARMERS_DAUGHTER, 0),
    (@GUID + 98, @EVENT_FARMERS_DAUGHTER, 0),
    (@GUID + 99, @EVENT_FARMERS_DAUGHTER, 0),
    (@GUID + 100, @EVENT_FARMERS_DAUGHTER, 0),
    (@GUID + 101, @EVENT_FARMERS_DAUGHTER, 0),
    (@GUID + 102, @EVENT_FARMERS_DAUGHTER, 0),
    (@GUID + 103, @EVENT_FARMERS_DAUGHTER, 0),
    (@GUID + 104, @EVENT_FARMERS_DAUGHTER, 0),
    (@GUID + 105, @EVENT_FARMERS_DAUGHTER, 0),
    (@GUID + 106, @EVENT_FARMERS_DAUGHTER, 0),
    (@GUID + 107, @EVENT_FARMERS_DAUGHTER, 0),
    (@GUID + 108, @EVENT_FARMERS_DAUGHTER, 0),
    (@GUID + 109, @EVENT_FARMERS_DAUGHTER, 0),
    (@GUID + 110, @EVENT_FARMERS_DAUGHTER, 0),
    (@GUID + 111, @EVENT_FARMERS_DAUGHTER, 0),
    (@GUID + 112, @EVENT_FARMERS_DAUGHTER, 0),
    (@GUID + 113, @EVENT_FARMERS_DAUGHTER, 0),
    (@GUID + 114, @EVENT_FARMERS_DAUGHTER, 0),
    (@GUID + 115, @EVENT_FARMERS_DAUGHTER, 0),
    (@GUID + 116, @EVENT_FARMERS_DAUGHTER, 0),
    (@GUID + 117, @EVENT_FARMERS_DAUGHTER, 0),
    (@GUID + 118, @EVENT_FARMERS_DAUGHTER, 0),
    (@GUID + 119, @EVENT_FARMERS_DAUGHTER, 0),
    (@GUID + 120, @EVENT_FARMERS_DAUGHTER, 0),
    (@GUID + 121, @EVENT_FARMERS_DAUGHTER, 0),
    (@GUID + 122, @EVENT_FARMERS_DAUGHTER, 0),
    (@GUID + 123, @EVENT_FARMERS_DAUGHTER, 0),
    (@GUID + 124, @EVENT_FARMERS_DAUGHTER, 0),
    (@GUID + 125, @EVENT_FARMERS_DAUGHTER, 0),
    (@GUID + 126, @EVENT_FARMERS_DAUGHTER, 0),
    (@GUID + 127, @EVENT_FARMERS_DAUGHTER, 0),
    (@GUID + 128, @EVENT_FARMERS_DAUGHTER, 0),
    (@GUID + 129, @EVENT_FARMERS_DAUGHTER, 0),
    (@GUID + 130, @EVENT_FARMERS_DAUGHTER, 0),
    (@GUID + 131, @EVENT_FARMERS_DAUGHTER, 0),
    (@GUID + 132, @EVENT_FARMERS_DAUGHTER, 0),
    (@GUID + 133, @EVENT_FARMERS_DAUGHTER, 0),
    (@GUID + 134, @EVENT_FARMERS_DAUGHTER, 0),
    (@GUID + 135, @EVENT_FARMERS_DAUGHTER, 0),
    (@GUID + 136, @EVENT_FARMERS_DAUGHTER, 0),
    (@GUID + 137, @EVENT_FARMERS_DAUGHTER, 0),
    (@GUID + 138, @EVENT_FARMERS_DAUGHTER, 0),
    (@GUID + 139, @EVENT_FARMERS_DAUGHTER, 0),
    (@GUID + 140, @EVENT_FARMERS_DAUGHTER, 0),
    (@GUID + 141, @EVENT_FARMERS_DAUGHTER, 0),
    (@GUID + 142, @EVENT_FARMERS_DAUGHTER, 0),
    (@GUID + 143, @EVENT_FARMERS_DAUGHTER, 0),
    (@GUID + 144, @EVENT_FARMERS_DAUGHTER, 0),
    (@GUID + 145, @EVENT_FARMERS_DAUGHTER, 0),
    (@GUID + 147, @EVENT_FARMERS_DAUGHTER, 0),
    (@GUID + 148, @EVENT_FARMERS_DAUGHTER, 0),
    (@GUID + 149, @EVENT_FARMERS_DAUGHTER, 0),
    (@GUID + 150, @EVENT_FARMERS_DAUGHTER, 0),
    (@GUID + 151, @EVENT_FARMERS_DAUGHTER, 0),
    (@GUID + 152, @EVENT_FARMERS_DAUGHTER, 0),
    (@GUID + 153, @EVENT_FARMERS_DAUGHTER, 0);

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
    (@GUID + 14, 10, 15),
    (@GUID + 15, 10, 15),
    (@GUID + 16, 10, 15),
    (@GUID + 17, 10, 15),
    (@GUID + 18, 10, 15),
    (@GUID + 19, 10, 15),
    (@GUID + 20, 10, 15),
    (@GUID + 21, 10, 15),
    (@GUID + 22, 10, 15),
    (@GUID + 23, 10, 15),
    (@GUID + 24, 10, 15),
    (@GUID + 25, 10, 15),
    (@GUID + 26, 10, 15),
    (@GUID + 27, 10, 15),
    (@GUID + 28, 10, 15),
    (@GUID + 29, 10, 15),
    (@GUID + 30, 10, 15),
    (@GUID + 31, 10, 15),
    (@GUID + 32, 10, 15),
    (@GUID + 33, 10, 15),
    (@GUID + 34, 10, 15),
    (@GUID + 35, 10, 15),
    (@GUID + 36, 10, 15),
    (@GUID + 37, 10, 15),
    (@GUID + 38, 10, 15),
    (@GUID + 39, 10, 15),
    (@GUID + 40, 10, 15),
    (@GUID + 41, 10, 15),
    (@GUID + 42, 10, 15),
    (@GUID + 43, 10, 15),
    (@GUID + 45, 10, 15),
    (@GUID + 46, 10, 15),
    (@GUID + 47, 10, 15),
    (@GUID + 48, 10, 15),
    (@GUID + 50, 10, 15),
    (@GUID + 51, 10, 15),
    (@GUID + 52, 10, 15),
    (@GUID + 53, 10, 15),
    (@GUID + 54, 10, 15),
    (@GUID + 55, 10, 15),
    (@GUID + 56, 10, 15),
    (@GUID + 57, 10, 15),
    (@GUID + 58, 10, 15),
    (@GUID + 59, 10, 15),
    (@GUID + 60, 10, 15),
    (@GUID + 61, 10, 15),
    (@GUID + 62, 10, 15),
    (@GUID + 64, 10, 15),
    (@GUID + 65, 10, 15),
    (@GUID + 66, 10, 15),
    (@GUID + 67, 10, 15),
    (@GUID + 68, 10, 15),
    (@GUID + 69, 10, 15),
    (@GUID + 70, 10, 15),
    (@GUID + 71, 10, 15),
    (@GUID + 72, 10, 15),
    (@GUID + 73, 10, 15),
    (@GUID + 75, 10, 15),
    (@GUID + 76, 10, 15),
    (@GUID + 77, 10, 15),
    (@GUID + 78, 10, 15),
    (@GUID + 79, 10, 15),
    (@GUID + 80, 10, 15),
    (@GUID + 81, 10, 15),
    (@GUID + 82, 10, 15),
    (@GUID + 84, 10, 15),
    (@GUID + 86, 10, 15),
    (@GUID + 87, 10, 15),
    (@GUID + 88, 10, 15),
    (@GUID + 89, 10, 15),
    (@GUID + 90, 10, 15),
    (@GUID + 91, 10, 15),
    (@GUID + 92, 10, 15),
    (@GUID + 93, 10, 15),
    (@GUID + 94, 10, 15),
    (@GUID + 95, 10, 15),
    (@GUID + 96, 10, 15),
    (@GUID + 97, 10, 15),
    (@GUID + 98, 10, 15),
    (@GUID + 99, 10, 15),
    (@GUID + 100, 10, 15),
    (@GUID + 101, 10, 15),
    (@GUID + 102, 10, 15),
    (@GUID + 103, 10, 15),
    (@GUID + 104, 10, 15),
    (@GUID + 105, 10, 15),
    (@GUID + 106, 10, 15),
    (@GUID + 107, 10, 15),
    (@GUID + 108, 10, 15),
    (@GUID + 109, 10, 15),
    (@GUID + 110, 10, 15),
    (@GUID + 111, 10, 15),
    (@GUID + 112, 10, 15),
    (@GUID + 113, 10, 15),
    (@GUID + 114, 10, 15),
    (@GUID + 115, 10, 15),
    (@GUID + 116, 10, 15),
    (@GUID + 117, 10, 15),
    (@GUID + 118, 10, 15),
    (@GUID + 119, 10, 15),
    (@GUID + 120, 10, 15),
    (@GUID + 121, 10, 15),
    (@GUID + 122, 10, 15),
    (@GUID + 123, 10, 15),
    (@GUID + 124, 10, 15),
    (@GUID + 125, 10, 15),
    (@GUID + 126, 10, 15),
    (@GUID + 127, 10, 15),
    (@GUID + 128, 10, 15),
    (@GUID + 129, 10, 15),
    (@GUID + 130, 10, 15),
    (@GUID + 131, 10, 15),
    (@GUID + 132, 10, 15),
    (@GUID + 133, 10, 15),
    (@GUID + 134, 10, 15),
    (@GUID + 135, 10, 15),
    (@GUID + 136, 10, 15),
    (@GUID + 137, 10, 15),
    (@GUID + 138, 10, 15),
    (@GUID + 139, 10, 15),
    (@GUID + 140, 10, 15),
    (@GUID + 141, 10, 15),
    (@GUID + 142, 10, 15),
    (@GUID + 143, 10, 15),
    (@GUID + 144, 10, 15),
    (@GUID + 145, 10, 15),
    (@GUID + 147, 10, 15),
    (@GUID + 148, 10, 15),
    (@GUID + 149, 10, 15),
    (@GUID + 150, 10, 15),
    (@GUID + 151, 10, 15),
    (@GUID + 152, 10, 15),
    (@GUID + 153, 10, 15);

INSERT INTO `entity_spline` (`id`, `splineId`, `mode`, `speed`, `fx`, `fy`, `fz`) VALUES
    (@GUID + 1, 4385, 1, 2, 0, 0, 0),  -- spline 4385, 141 m, open, BackAndForth
    (@GUID + 2, 4424, 1, 2, 0, 0, 0),  -- spline 4424, 61 m, open, BackAndForth
    (@GUID + 3, 4425, 1, 2, 0, 0, 0),  -- spline 4425, 57 m, open, BackAndForth
    (@GUID + 4, 4426, 1, 2, 0, 0, 0),  -- spline 4426, 52 m, open, BackAndForth
    (@GUID + 5, 4427, 1, 2, 0, 0, 0),  -- spline 4427, 51 m, open, BackAndForth
    (@GUID + 6, 4429, 1, 2, 0, 0, 0),  -- spline 4429, 89 m, open, BackAndForth
    (@GUID + 7, 4430, 1, 2, 0, 0, 0),  -- spline 4430, 54 m, open, BackAndForth
    (@GUID + 8, 4431, 1, 2, 0, 0, 0),  -- spline 4431, 55 m, open, BackAndForth
    (@GUID + 9, 4432, 1, 2, 0, 0, 0),  -- spline 4432, 64 m, open, BackAndForth
    (@GUID + 10, 4470, 1, 2, 0, 0, 0),  -- spline 4470, 150 m, open, BackAndForth
    (@GUID + 11, 4471, 1, 2, 0, 0, 0),  -- spline 4471, 114 m, open, BackAndForth
    (@GUID + 12, 4472, 1, 2, 0, 0, 0),  -- spline 4472, 59 m, open, BackAndForth
    (@GUID + 13, 4473, 1, 2, 0, 0, 0),  -- spline 4473, 116 m, open, BackAndForth
    (@GUID + 14, 4474, 1, 2, 0, 0, 0),  -- spline 4474, 197 m, open, BackAndForth
    (@GUID + 15, 4475, 1, 2, 0, 0, 0),  -- spline 4475, 117 m, open, BackAndForth
    (@GUID + 16, 4476, 2, 2, 0, 0, 0),  -- spline 4476, 102 m, closed loop, Cyclic
    (@GUID + 17, 4477, 1, 2, 0, 0, 0),  -- spline 4477, 118 m, open, BackAndForth
    (@GUID + 18, 4478, 2, 2, 0, 0, 0),  -- spline 4478, 71 m, closed loop, Cyclic
    (@GUID + 19, 4479, 1, 2, 0, 0, 0),  -- spline 4479, 64 m, open, BackAndForth
    (@GUID + 20, 4480, 1, 2, 0, 0, 0),  -- spline 4480, 97 m, open, BackAndForth
    (@GUID + 21, 4481, 1, 2, 0, 0, 0),  -- spline 4481, 66 m, open, BackAndForth
    (@GUID + 22, 4482, 1, 2, 0, 0, 0),  -- spline 4482, 40 m, open, BackAndForth
    (@GUID + 23, 4483, 1, 2, 0, 0, 0),  -- spline 4483, 87 m, open, BackAndForth
    (@GUID + 24, 4484, 2, 2, 0, 0, 0),  -- spline 4484, 220 m, closed loop, Cyclic
    (@GUID + 25, 4485, 1, 2, 0, 0, 0),  -- spline 4485, 164 m, open, BackAndForth
    (@GUID + 26, 4486, 2, 2, 0, 0, 0),  -- spline 4486, 88 m, closed loop, Cyclic
    (@GUID + 27, 4487, 2, 2, 0, 0, 0),  -- spline 4487, 85 m, closed loop, Cyclic
    (@GUID + 28, 4488, 2, 2, 0, 0, 0),  -- spline 4488, 91 m, closed loop, Cyclic
    (@GUID + 29, 4489, 2, 2, 0, 0, 0),  -- spline 4489, 127 m, closed loop, Cyclic
    (@GUID + 30, 4490, 1, 2, 0, 0, 0),  -- spline 4490, 85 m, open, BackAndForth
    (@GUID + 31, 4491, 1, 2, 0, 0, 0),  -- spline 4491, 140 m, open, BackAndForth
    (@GUID + 32, 4492, 1, 2, 0, 0, 0),  -- spline 4492, 86 m, open, BackAndForth
    (@GUID + 33, 4493, 2, 2, 0, 0, 0),  -- spline 4493, 80 m, closed loop, Cyclic
    (@GUID + 34, 4494, 1, 2, 0, 0, 0),  -- spline 4494, 210 m, open, BackAndForth
    (@GUID + 35, 4495, 1, 2, 0, 0, 0),  -- spline 4495, 119 m, open, BackAndForth
    (@GUID + 36, 4496, 1, 2, 0, 0, 0),  -- spline 4496, 155 m, open, BackAndForth
    (@GUID + 37, 4497, 1, 2, 0, 0, 0),  -- spline 4497, 153 m, open, BackAndForth
    (@GUID + 38, 4498, 1, 2, 0, 0, 0),  -- spline 4498, 75 m, open, BackAndForth
    (@GUID + 39, 4499, 1, 2, 0, 0, 0),  -- spline 4499, 69 m, open, BackAndForth
    (@GUID + 40, 4500, 1, 2, 0, 0, 0),  -- spline 4500, 59 m, open, BackAndForth
    (@GUID + 41, 4501, 1, 2, 0, 0, 0),  -- spline 4501, 86 m, open, BackAndForth
    (@GUID + 42, 4502, 1, 2, 0, 0, 0),  -- spline 4502, 108 m, open, BackAndForth
    (@GUID + 43, 4503, 1, 2, 0, 0, 0),  -- KEEP (29 Sep 2026: patrol by Tarquim) spline 4503, 72 m, open, BackAndForth
    (@GUID + 45, 4505, 1, 2, 0, 0, 0),  -- spline 4505, 97 m, open, BackAndForth
    (@GUID + 46, 4506, 1, 2, 0, 0, 0),  -- spline 4506, 58 m, open, BackAndForth
    (@GUID + 47, 4508, 1, 2, 0, 0, 0),  -- spline 4508, 359 m, open, BackAndForth
    (@GUID + 48, 4513, 1, 2, 0, 0, 0),  -- spline 4513, 290 m, open, BackAndForth
    (@GUID + 50, 4587, 1, 2, 0, 0, 0),  -- spline 4587, 90 m, open, BackAndForth
    (@GUID + 51, 4588, 1, 2, 0, 0, 0),  -- spline 4588, 60 m, open, BackAndForth
    (@GUID + 52, 4589, 1, 2, 0, 0, 0),  -- spline 4589, 64 m, open, BackAndForth
    (@GUID + 53, 4590, 1, 2, 0, 0, 0),  -- spline 4590, 85 m, open, BackAndForth
    (@GUID + 54, 4591, 1, 2, 0, 0, 0),  -- spline 4591, 91 m, open, BackAndForth
    (@GUID + 55, 4592, 1, 2, 0, 0, 0),  -- spline 4592, 75 m, open, BackAndForth
    (@GUID + 56, 4593, 1, 2, 0, 0, 0),  -- spline 4593, 67 m, open, BackAndForth
    (@GUID + 57, 4594, 1, 2, 0, 0, 0),  -- spline 4594, 57 m, open, BackAndForth
    (@GUID + 58, 4595, 1, 2, 0, 0, 0),  -- spline 4595, 108 m, open, BackAndForth
    (@GUID + 59, 4596, 1, 2, 0, 0, 0),  -- spline 4596, 66 m, open, BackAndForth
    (@GUID + 60, 4597, 1, 2, 0, 0, 0),  -- spline 4597, 72 m, open, BackAndForth
    (@GUID + 61, 4598, 1, 2, 0, 0, 0),  -- spline 4598, 74 m, open, BackAndForth
    (@GUID + 62, 4651, 1, 2, 0, 0, 0),  -- spline 4651, 78 m, open, BackAndForth
    (@GUID + 64, 4668, 1, 2, 0, 0, 0),  -- spline 4668, 430 m, open, BackAndForth
    (@GUID + 65, 4669, 1, 2, 0, 0, 0),  -- spline 4669, 385 m, open, BackAndForth
    (@GUID + 66, 4670, 1, 2, 0, 0, 0),  -- spline 4670, 641 m, open, BackAndForth
    (@GUID + 67, 4671, 1, 2, 0, 0, 0),  -- spline 4671, 71 m, open, BackAndForth
    (@GUID + 68, 4672, 1, 2, 0, 0, 0),  -- spline 4672, 695 m, open, BackAndForth
    (@GUID + 69, 4673, 1, 2, 0, 0, 0),  -- spline 4673, 293 m, open, BackAndForth
    (@GUID + 70, 4674, 1, 2, 0, 0, 0),  -- spline 4674, 187 m, open, BackAndForth
    (@GUID + 71, 4675, 1, 2, 0, 0, 0),  -- spline 4675, 196 m, open, BackAndForth
    (@GUID + 72, 4676, 1, 2, 0, 0, 0),  -- spline 4676, 94 m, open, BackAndForth
    (@GUID + 73, 4677, 1, 2, 0, 0, 0),  -- spline 4677, 295 m, open, BackAndForth
    (@GUID + 75, 4679, 1, 2, 0, 0, 0),  -- spline 4679, 505 m, open, BackAndForth
    (@GUID + 76, 4692, 1, 2, 0, 0, 0),  -- spline 4692, 27 m, open, BackAndForth
    (@GUID + 77, 4702, 1, 2, 0, 0, 0),  -- spline 4702, 60 m, open, BackAndForth
    (@GUID + 78, 4792, 1, 2, 0, 0, 0),  -- spline 4792, 17 m, open, BackAndForth
    (@GUID + 79, 4847, 1, 2, 0, 0, 0),  -- spline 4847, 22 m, open, BackAndForth
    (@GUID + 80, 6106, 1, 2, 0, 0, 0),  -- spline 6106, 330 m, open, BackAndForth
    (@GUID + 81, 6107, 1, 2, 0, 0, 0),  -- spline 6107, 315 m, open, BackAndForth
    (@GUID + 82, 6108, 1, 2, 0, 0, 0),  -- spline 6108, 321 m, open, BackAndForth
    (@GUID + 84, 6110, 1, 2, 0, 0, 0),  -- spline 6110, 346 m, open, BackAndForth
    (@GUID + 86, 6113, 1, 2, 0, 0, 0),  -- spline 6113, 339 m, open, BackAndForth
    (@GUID + 87, 7389, 1, 2, 0, 0, 0),  -- spline 7389, 123 m, open, BackAndForth
    (@GUID + 88, 7390, 1, 2, 0, 0, 0),  -- spline 7390, 111 m, open, BackAndForth
    (@GUID + 89, 7391, 1, 2, 0, 0, 0),  -- spline 7391, 141 m, open, BackAndForth
    (@GUID + 90, 7392, 1, 2, 0, 0, 0),  -- spline 7392, 92 m, open, BackAndForth
    (@GUID + 91, 7393, 1, 2, 0, 0, 0),  -- spline 7393, 47 m, open, BackAndForth
    (@GUID + 92, 7394, 1, 2, 0, 0, 0),  -- spline 7394, 124 m, open, BackAndForth
    (@GUID + 93, 7395, 1, 2, 0, 0, 0),  -- spline 7395, 50 m, open, BackAndForth
    (@GUID + 94, 7396, 1, 2, 0, 0, 0),  -- spline 7396, 25 m, open, BackAndForth
    (@GUID + 95, 7932, 1, 2, 0, 0, 0),  -- spline 7932, 96 m, open, BackAndForth
    (@GUID + 96, 7933, 2, 2, 0, 0, 0),  -- spline 7933, 91 m, closed loop, Cyclic
    (@GUID + 97, 7934, 1, 2, 0, 0, 0),  -- spline 7934, 111 m, open, BackAndForth
    (@GUID + 98, 7935, 1, 2, 0, 0, 0),  -- spline 7935, 110 m, open, BackAndForth
    (@GUID + 99, 7936, 1, 2, 0, 0, 0),  -- spline 7936, 109 m, open, BackAndForth
    (@GUID + 100, 7939, 1, 2, 0, 0, 0),  -- spline 7939, 140 m, open, BackAndForth
    (@GUID + 101, 7940, 1, 2, 0, 0, 0),  -- spline 7940, 128 m, open, BackAndForth
    (@GUID + 102, 7941, 1, 2, 0, 0, 0),  -- spline 7941, 99 m, open, BackAndForth
    (@GUID + 103, 7942, 1, 2, 0, 0, 0),  -- spline 7942, 111 m, open, BackAndForth
    (@GUID + 104, 7943, 1, 2, 0, 0, 0),  -- spline 7943, 138 m, open, BackAndForth
    (@GUID + 105, 7944, 1, 2, 0, 0, 0),  -- spline 7944, 116 m, open, BackAndForth
    (@GUID + 106, 7945, 1, 2, 0, 0, 0),  -- spline 7945, 136 m, open, BackAndForth
    (@GUID + 107, 7946, 1, 2, 0, 0, 0),  -- spline 7946, 97 m, open, BackAndForth
    (@GUID + 108, 7947, 1, 2, 0, 0, 0),  -- spline 7947, 93 m, open, BackAndForth
    (@GUID + 109, 7948, 1, 2, 0, 0, 0),  -- spline 7948, 112 m, open, BackAndForth
    (@GUID + 110, 7950, 1, 2, 0, 0, 0),  -- spline 7950, 135 m, open, BackAndForth
    (@GUID + 111, 7952, 1, 2, 0, 0, 0),  -- spline 7952, 126 m, open, BackAndForth
    (@GUID + 112, 7954, 1, 2, 0, 0, 0),  -- spline 7954, 125 m, open, BackAndForth
    (@GUID + 113, 7956, 1, 2, 0, 0, 0),  -- spline 7956, 120 m, open, BackAndForth
    (@GUID + 114, 7959, 1, 2, 0, 0, 0),  -- spline 7959, 80 m, open, BackAndForth
    (@GUID + 115, 7960, 1, 2, 0, 0, 0),  -- spline 7960, 93 m, open, BackAndForth
    (@GUID + 116, 7961, 1, 2, 0, 0, 0),  -- spline 7961, 95 m, open, BackAndForth
    (@GUID + 117, 7962, 1, 2, 0, 0, 0),  -- spline 7962, 118 m, open, BackAndForth
    (@GUID + 118, 7963, 1, 2, 0, 0, 0),  -- spline 7963, 149 m, open, BackAndForth
    (@GUID + 119, 7964, 1, 2, 0, 0, 0),  -- spline 7964, 176 m, open, BackAndForth
    (@GUID + 120, 9515, 1, 2, 0, 0, 0),  -- spline 9515, 37 m, open, BackAndForth
    (@GUID + 121, 14698, 1, 2, 0, 0, 0),  -- spline 14698, 79 m, open, BackAndForth
    (@GUID + 122, 14699, 1, 2, 0, 0, 0),  -- spline 14699, 57 m, open, BackAndForth
    (@GUID + 123, 14702, 1, 2, 0, 0, 0),  -- spline 14702, 86 m, open, BackAndForth
    (@GUID + 124, 14703, 1, 2, 0, 0, 0),  -- spline 14703, 89 m, open, BackAndForth
    (@GUID + 125, 14704, 1, 2, 0, 0, 0),  -- spline 14704, 163 m, open, BackAndForth
    (@GUID + 126, 14705, 1, 2, 0, 0, 0),  -- spline 14705, 144 m, open, BackAndForth
    (@GUID + 127, 14706, 1, 2, 0, 0, 0),  -- spline 14706, 119 m, open, BackAndForth
    (@GUID + 128, 14707, 1, 2, 0, 0, 0),  -- spline 14707, 158 m, open, BackAndForth
    (@GUID + 129, 14748, 1, 2, 0, 0, 0),  -- spline 14748, 244 m, open, BackAndForth
    (@GUID + 130, 14790, 1, 2, 0, 0, 0),  -- spline 14790, 136 m, open, BackAndForth
    (@GUID + 131, 14818, 1, 2, 0, 0, 0),  -- spline 14818, 69 m, open, BackAndForth
    (@GUID + 132, 14819, 1, 2, 0, 0, 0),  -- spline 14819, 194 m, open, BackAndForth
    (@GUID + 133, 14863, 1, 2, 0, 0, 0),  -- spline 14863, 36 m, open, BackAndForth
    (@GUID + 134, 14864, 1, 2, 0, 0, 0),  -- spline 14864, 74 m, open, BackAndForth
    (@GUID + 135, 14883, 1, 2, 0, 0, 0),  -- spline 14883, 266 m, open, BackAndForth
    (@GUID + 136, 14981, 1, 2, 0, 0, 0),  -- spline 14981, 461 m, open, BackAndForth
    (@GUID + 137, 15012, 1, 2, 0, 0, 0),  -- spline 15012, 408 m, open, BackAndForth
    (@GUID + 138, 15154, 1, 2, 0, 0, 0),  -- spline 15154, 37 m, open, BackAndForth
    (@GUID + 139, 15155, 1, 2, 0, 0, 0),  -- spline 15155, 36 m, open, BackAndForth
    (@GUID + 140, 15157, 1, 2, 0, 0, 0),  -- spline 15157, 65 m, open, BackAndForth
    (@GUID + 141, 15939, 1, 2, 0, 0, 0),  -- spline 15939, 210 m, open, BackAndForth
    (@GUID + 142, 16021, 1, 2, 0, 0, 0),  -- spline 16021, 9 m, open, BackAndForth
    (@GUID + 143, 16026, 1, 2, 0, 0, 0),  -- spline 16026, 80 m, open, BackAndForth
    (@GUID + 144, 16027, 1, 2, 0, 0, 0),  -- spline 16027, 36 m, open, BackAndForth
    (@GUID + 145, 16028, 1, 2, 0, 0, 0),  -- spline 16028, 45 m, open, BackAndForth
    (@GUID + 147, 16032, 1, 2, 0, 0, 0),  -- spline 16032, 52 m, open, BackAndForth
    (@GUID + 148, 16033, 1, 2, 0, 0, 0),  -- spline 16033, 45 m, open, BackAndForth
    (@GUID + 149, 16034, 1, 2, 0, 0, 0),  -- spline 16034, 41 m, open, BackAndForth
    (@GUID + 150, 16035, 1, 2, 0, 0, 0),  -- spline 16035, 41 m, open, BackAndForth
    (@GUID + 151, 16036, 1, 2, 0, 0, 0),  -- spline 16036, 46 m, open, BackAndForth
    (@GUID + 152, 16047, 1, 2, 0, 0, 0),  -- spline 16047, 157 m, open, BackAndForth
    (@GUID + 153, 20094, 1, 2, 0, 0, 0);  -- spline 20094, 9 m, open, BackAndForth

-- --------------------------------------
-- TEMP (29 Sep 2026): all Dominion Scouts friendly (faction 219) to watch the patrol routes and see where units
-- are missing. Remove this statement (and re-import) to make them hostile again.
-- --------------------------------------
UPDATE `entity` SET `Faction1` = 219, `Faction2` = 219 WHERE `World` = @WORLD AND `Creature` = 17856;
