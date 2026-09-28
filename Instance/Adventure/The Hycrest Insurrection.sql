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
    (@GUID + 15, 0, 17763, @WORLD, 0, -2484.1101, -927.7783, -1283.1149, 0.0, 0, 0, 23754, 0, 1452, 1452), -- Automated Machine Gun - Spotlight Target (lane moved by the script)
    (@GUID + 16, 0, 17763, @WORLD, 0, -2468.567, -929.0733, -1593.2743, 0.0, 0, 0, 23754, 0, 1452, 1452), -- Automated Machine Gun - Spotlight Target (lane moved by the script)
    (@GUID + 17, 0, 17763, @WORLD, 0, -2490.1282, -920.8113, -1672.5258, 0.0, 0, 0, 23754, 0, 1452, 1452), -- Automated Machine Gun - Spotlight Target (lane moved by the script)
    (@GUID + 18, 0, 17763, @WORLD, 0, -2402.416, -928.3815, -1673.6968, 0.0, 0, 0, 23754, 0, 1452, 1452); -- Automated Machine Gun - Spotlight Target (lane moved by the script)

INSERT INTO `entity_event` (`id`, `eventId`, `phase`) VALUES
    (@GUID + 1, @EVENT_FARMERS_DAUGHTER, 0),
    (@GUID + 2, @EVENT_FARMERS_DAUGHTER, 0),
    (@GUID + 3, @EVENT_FARMERS_DAUGHTER, 0),
    (@GUID + 4, @EVENT_FARMERS_DAUGHTER, 0),
    (@GUID + 5, @EVENT_FARMERS_DAUGHTER, 1), -- Prema and her guard appear once Millithea is freed
    (@GUID + 6, @EVENT_FARMERS_DAUGHTER, 1),
    (@GUID + 15, @EVENT_FARMERS_DAUGHTER, 0),
    (@GUID + 16, @EVENT_FARMERS_DAUGHTER, 0),
    (@GUID + 17, @EVENT_FARMERS_DAUGHTER, 0),
    (@GUID + 18, @EVENT_FARMERS_DAUGHTER, 0);

INSERT INTO `entity_stats` (`Id`, `Stat`, `Value`) VALUES
    (@GUID + 1, 10, 15),
    (@GUID + 2, 10, 15),
    (@GUID + 3, 10, 15),
    (@GUID + 4, 10, 15),
    (@GUID + 5, 10, 15),
    (@GUID + 6, 10, 15),
    (@GUID + 15, 10, 15),
    (@GUID + 16, 10, 15),
    (@GUID + 17, 10, 15),
    (@GUID + 18, 10, 15);

-- --------------------------------------
-- TEST (28 Sep 2026): one Dominion Scout on every ground-level spline of world 1149 (Spline2, type 1:
-- 153 splines; closed loops walked Cyclic, open paths BackAndForth, 2 m/s), to see which retail patrol routes
-- to keep and which to replace (spotlights and such). The server walks them itself (entity_spline + SplineAI). On the
-- Farmer's Daughter (event 420 phase 0), so they stay until the hideout's barn closes. Remove this block (or rows) when
-- done. Generated from the tables; 18 airborne splines and the 7 linear scripted walks left out.
-- --------------------------------------
SET @GUID = (SELECT IFNULL(MAX(`id`), 0) FROM `entity`);
INSERT INTO `entity` (`Id`, `Type`, `Creature`, `World`, `Area`, `X`, `Y`, `Z`, `RX`, `RY`, `RZ`, `DisplayInfo`, `OutfitInfo`, `Faction1`, `Faction2`) VALUES
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
    (@GUID + 26, 0, 17856, @WORLD, 0, -2389.3823, -926.2544, -1602.6337, 0.755579, 0, 0, 30970, 8192, 1452, 1452),
    (@GUID + 27, 0, 17856, @WORLD, 0, -2342.2275, -925.9800, -1664.8235, -2.703460, 0, 0, 30972, 8192, 1452, 1452),
    (@GUID + 29, 0, 17856, @WORLD, 0, -2424.6421, -923.9310, -1678.0225, -2.844436, 0, 0, 30968, 8192, 1452, 1452),
    (@GUID + 31, 0, 17856, @WORLD, 0, -2465.5366, -922.3412, -1679.4854, -1.127098, 0, 0, 30972, 8192, 1452, 1452),
    (@GUID + 32, 0, 17856, @WORLD, 0, -2245.1428, -923.4831, -1686.0023, 1.424139, 0, 0, 30967, 8192, 1452, 1452),
    (@GUID + 33, 0, 17856, @WORLD, 0, -2298.8872, -926.5031, -1643.8555, -0.110741, 0, 0, 30968, 8192, 1452, 1452),
    (@GUID + 35, 0, 17856, @WORLD, 0, -2334.7390, -900.7168, -1794.2461, -2.443586, 0, 0, 30972, 8192, 1452, 1452),
    (@GUID + 38, 0, 17856, @WORLD, 0, -2605.7717, -928.0572, -1385.5016, 0.173525, 0, 0, 30970, 8192, 1452, 1452),
    (@GUID + 39, 0, 17856, @WORLD, 0, -2568.8479, -928.4366, -1500.6844, -3.018491, 0, 0, 30972, 8192, 1452, 1452),
    (@GUID + 41, 0, 17856, @WORLD, 0, -2558.9175, -929.5172, -1462.0400, -2.308193, 0, 0, 30968, 8192, 1452, 1452),
    (@GUID + 42, 0, 17856, @WORLD, 0, -2607.3535, -928.1109, -1333.2006, -0.626409, 0, 0, 30970, 8192, 1452, 1452),
    (@GUID + 43, 0, 17856, @WORLD, 0, -2460.0657, -928.0908, -1210.6251, -3.141593, 0, 0, 30972, 8192, 1452, 1452),
    (@GUID + 45, 0, 17856, @WORLD, 0, -2571.2788, -927.8309, -1280.9978, 2.884346, 0, 0, 30968, 8192, 1452, 1452),
    (@GUID + 46, 0, 17856, @WORLD, 0, -2441.4407, -926.6258, -1246.5859, -2.487520, 0, 0, 30970, 8192, 1452, 1452),
    (@GUID + 47, 0, 17856, @WORLD, 0, -2584.8467, -916.3095, -1633.9220, -3.141593, 0, 0, 30972, 8192, 1452, 1452),
    (@GUID + 52, 0, 17856, @WORLD, 0, -2270.5310, -925.9852, -1677.5615, -2.578750, 0, 0, 30967, 8192, 1452, 1452),
    (@GUID + 54, 0, 17856, @WORLD, 0, -2340.0100, -927.4662, -1639.3276, -2.119758, 0, 0, 30970, 8192, 1452, 1452),
    (@GUID + 55, 0, 17856, @WORLD, 0, -2259.2122, -920.8197, -1698.1327, -2.214874, 0, 0, 30972, 8192, 1452, 1452),
    (@GUID + 56, 0, 17856, @WORLD, 0, -2264.7549, -928.4187, -1645.6061, 2.142671, 0, 0, 30967, 8192, 1452, 1452),
    (@GUID + 58, 0, 17856, @WORLD, 0, -2320.6182, -923.3251, -1696.9077, 2.933191, 0, 0, 30970, 8192, 1452, 1452),
    (@GUID + 61, 0, 17856, @WORLD, 0, -2296.1021, -926.1059, -1642.6744, -2.865060, 0, 0, 30968, 8192, 1452, 1452),
    (@GUID + 64, 0, 17856, @WORLD, 0, -2290.7002, -921.8855, -1194.0387, 0.145026, 0, 0, 30967, 8192, 1452, 1452),
    (@GUID + 72, 0, 17856, @WORLD, 0, -2320.0916, -930.4386, -1585.7894, 0.089041, 0, 0, 30967, 8192, 1452, 1452),
    (@GUID + 75, 0, 17856, @WORLD, 0, -2366.7043, -923.9154, -1288.3143, -1.080193, 0, 0, 30972, 8192, 1452, 1452),
    (@GUID + 81, 0, 17856, @WORLD, 0, -2311.4377, -923.2948, -1508.1396, -3.021916, 0, 0, 30968, 8192, 1452, 1452),
    (@GUID + 87, 0, 17856, @WORLD, 0, -2763.6306, -918.3665, -1475.9076, -0.591146, 0, 0, 30972, 8192, 1452, 1452),
    (@GUID + 95, 0, 17856, @WORLD, 0, -2555.8213, -929.7270, -1309.2010, -3.141593, 0, 0, 30972, 8192, 1452, 1452),
    (@GUID + 96, 0, 17856, @WORLD, 0, -2568.2146, -927.5577, -1309.6948, -1.663037, 0, 0, 30967, 8192, 1452, 1452),
    (@GUID + 97, 0, 17856, @WORLD, 0, -2567.9734, -929.3442, -1332.0280, -2.450444, 0, 0, 30968, 8192, 1452, 1452),
    (@GUID + 98, 0, 17856, @WORLD, 0, -2541.2742, -929.7158, -1348.7952, 1.528343, 0, 0, 30970, 8192, 1452, 1452),
    (@GUID + 101, 0, 17856, @WORLD, 0, -2338.2908, -921.9292, -1329.7443, 3.019637, 0, 0, 30968, 8192, 1452, 1452),
    (@GUID + 102, 0, 17856, @WORLD, 0, -2328.8589, -921.8908, -1350.3374, 1.610235, 0, 0, 30970, 8192, 1452, 1452),
    (@GUID + 103, 0, 17856, @WORLD, 0, -2312.8135, -922.8083, -1349.0508, 1.249199, 0, 0, 30972, 8192, 1452, 1452),
    (@GUID + 110, 0, 17856, @WORLD, 0, -2281.9224, -926.8220, -1564.5543, -1.364491, 0, 0, 30970, 8192, 1452, 1452),
    (@GUID + 111, 0, 17856, @WORLD, 0, -2294.1289, -926.6111, -1562.7520, -1.616916, 0, 0, 30972, 8192, 1452, 1452),
    (@GUID + 112, 0, 17856, @WORLD, 0, -2306.3313, -929.8511, -1593.2247, 3.034396, 0, 0, 30967, 8192, 1452, 1452),
    (@GUID + 113, 0, 17856, @WORLD, 0, -2291.5520, -928.0159, -1611.5833, 2.699071, 0, 0, 30968, 8192, 1452, 1452),
    (@GUID + 114, 0, 17856, @WORLD, 0, -2265.8428, -929.0908, -1601.1726, 3.042562, 0, 0, 30970, 8192, 1452, 1452),
    (@GUID + 115, 0, 17856, @WORLD, 0, -2446.7356, -928.9658, -1627.0905, 1.404914, 0, 0, 30972, 8192, 1452, 1452),
    (@GUID + 121, 0, 17856, @WORLD, 0, -2303.1631, -923.5451, -1343.1506, -3.141593, 0, 0, 30968, 8192, 1452, 1452),
    (@GUID + 123, 0, 17856, @WORLD, 0, -2397.8594, -924.7783, -1223.0437, -3.141593, 0, 0, 30972, 8192, 1452, 1452),
    (@GUID + 124, 0, 17856, @WORLD, 0, -2355.2041, -921.1218, -1200.0283, -3.141593, 0, 0, 30967, 8192, 1452, 1452),
    (@GUID + 126, 0, 17856, @WORLD, 0, -2226.1965, -929.3102, -1263.6118, -3.141593, 0, 0, 30970, 8192, 1452, 1452),
    (@GUID + 127, 0, 17856, @WORLD, 0, -2348.1311, -927.8448, -1486.1561, -3.141593, 0, 0, 30972, 8192, 1452, 1452),
    (@GUID + 128, 0, 17856, @WORLD, 0, -2240.9167, -929.3137, -1480.4342, -3.141593, 0, 0, 30967, 8192, 1452, 1452),
    (@GUID + 129, 0, 17856, @WORLD, 0, -2674.6252, -881.0894, -1782.1669, -3.141593, 0, 0, 30968, 8192, 1452, 1452),
    (@GUID + 131, 0, 17856, @WORLD, 0, -2350.2651, -922.2487, -1202.3861, -3.141593, 0, 0, 30972, 8192, 1452, 1452),
    (@GUID + 132, 0, 17856, @WORLD, 0, -2350.6108, -922.8124, -1207.4022, -3.141593, 0, 0, 30967, 8192, 1452, 1452),
    (@GUID + 137, 0, 17856, @WORLD, 0, -2570.7659, -910.2632, -1680.2649, -3.141593, 0, 0, 30968, 8192, 1452, 1452),
    (@GUID + 141, 0, 17856, @WORLD, 0, -2328.2107, -923.8275, -1203.8024, -3.141593, 0, 0, 30968, 8192, 1452, 1452),
    (@GUID + 142, 0, 17856, @WORLD, 0, -2317.1416, -868.3557, -1878.6327, -3.141593, 0, 0, 30970, 8192, 1452, 1452),
    (@GUID + 143, 0, 17856, @WORLD, 0, -2411.3540, -922.6606, -1437.7656, -3.141593, 0, 0, 30972, 8192, 1452, 1452),
    (@GUID + 147, 0, 17856, @WORLD, 0, -2383.7368, -919.6680, -1407.2397, -3.141593, 0, 0, 30972, 8192, 1452, 1452),
    (@GUID + 148, 0, 17856, @WORLD, 0, -2366.8652, -918.8406, -1387.7743, -3.141593, 0, 0, 30967, 8192, 1452, 1452),
    (@GUID + 149, 0, 17856, @WORLD, 0, -2345.0400, -919.1053, -1374.0790, -3.141593, 0, 0, 30968, 8192, 1452, 1452),
    (@GUID + 150, 0, 17856, @WORLD, 0, -2304.6929, -922.8972, -1376.9624, -3.141593, 0, 0, 30970, 8192, 1452, 1452),
    (@GUID + 151, 0, 17856, @WORLD, 0, -2273.0698, -926.1221, -1409.3198, -3.141593, 0, 0, 30972, 8192, 1452, 1452),
    (@GUID + 152, 0, 17856, @WORLD, 0, -2298.7070, -925.7532, -1437.3081, -3.141593, 0, 0, 30967, 8192, 1452, 1452);

INSERT INTO `entity_event` (`id`, `eventId`, `phase`) VALUES
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
    (@GUID + 26, @EVENT_FARMERS_DAUGHTER, 0),
    (@GUID + 27, @EVENT_FARMERS_DAUGHTER, 0),
    (@GUID + 29, @EVENT_FARMERS_DAUGHTER, 0),
    (@GUID + 31, @EVENT_FARMERS_DAUGHTER, 0),
    (@GUID + 32, @EVENT_FARMERS_DAUGHTER, 0),
    (@GUID + 33, @EVENT_FARMERS_DAUGHTER, 0),
    (@GUID + 35, @EVENT_FARMERS_DAUGHTER, 0),
    (@GUID + 38, @EVENT_FARMERS_DAUGHTER, 0),
    (@GUID + 39, @EVENT_FARMERS_DAUGHTER, 0),
    (@GUID + 41, @EVENT_FARMERS_DAUGHTER, 0),
    (@GUID + 42, @EVENT_FARMERS_DAUGHTER, 0),
    (@GUID + 43, @EVENT_FARMERS_DAUGHTER, 0),
    (@GUID + 45, @EVENT_FARMERS_DAUGHTER, 0),
    (@GUID + 46, @EVENT_FARMERS_DAUGHTER, 0),
    (@GUID + 47, @EVENT_FARMERS_DAUGHTER, 0),
    (@GUID + 52, @EVENT_FARMERS_DAUGHTER, 0),
    (@GUID + 54, @EVENT_FARMERS_DAUGHTER, 0),
    (@GUID + 55, @EVENT_FARMERS_DAUGHTER, 0),
    (@GUID + 56, @EVENT_FARMERS_DAUGHTER, 0),
    (@GUID + 58, @EVENT_FARMERS_DAUGHTER, 0),
    (@GUID + 61, @EVENT_FARMERS_DAUGHTER, 0),
    (@GUID + 64, @EVENT_FARMERS_DAUGHTER, 0),
    (@GUID + 72, @EVENT_FARMERS_DAUGHTER, 0),
    (@GUID + 75, @EVENT_FARMERS_DAUGHTER, 0),
    (@GUID + 81, @EVENT_FARMERS_DAUGHTER, 0),
    (@GUID + 87, @EVENT_FARMERS_DAUGHTER, 0),
    (@GUID + 95, @EVENT_FARMERS_DAUGHTER, 0),
    (@GUID + 96, @EVENT_FARMERS_DAUGHTER, 0),
    (@GUID + 97, @EVENT_FARMERS_DAUGHTER, 0),
    (@GUID + 98, @EVENT_FARMERS_DAUGHTER, 0),
    (@GUID + 101, @EVENT_FARMERS_DAUGHTER, 0),
    (@GUID + 102, @EVENT_FARMERS_DAUGHTER, 0),
    (@GUID + 103, @EVENT_FARMERS_DAUGHTER, 0),
    (@GUID + 110, @EVENT_FARMERS_DAUGHTER, 0),
    (@GUID + 111, @EVENT_FARMERS_DAUGHTER, 0),
    (@GUID + 112, @EVENT_FARMERS_DAUGHTER, 0),
    (@GUID + 113, @EVENT_FARMERS_DAUGHTER, 0),
    (@GUID + 114, @EVENT_FARMERS_DAUGHTER, 0),
    (@GUID + 115, @EVENT_FARMERS_DAUGHTER, 0),
    (@GUID + 121, @EVENT_FARMERS_DAUGHTER, 0),
    (@GUID + 123, @EVENT_FARMERS_DAUGHTER, 0),
    (@GUID + 124, @EVENT_FARMERS_DAUGHTER, 0),
    (@GUID + 126, @EVENT_FARMERS_DAUGHTER, 0),
    (@GUID + 127, @EVENT_FARMERS_DAUGHTER, 0),
    (@GUID + 128, @EVENT_FARMERS_DAUGHTER, 0),
    (@GUID + 129, @EVENT_FARMERS_DAUGHTER, 0),
    (@GUID + 131, @EVENT_FARMERS_DAUGHTER, 0),
    (@GUID + 132, @EVENT_FARMERS_DAUGHTER, 0),
    (@GUID + 137, @EVENT_FARMERS_DAUGHTER, 0),
    (@GUID + 141, @EVENT_FARMERS_DAUGHTER, 0),
    (@GUID + 142, @EVENT_FARMERS_DAUGHTER, 0),
    (@GUID + 143, @EVENT_FARMERS_DAUGHTER, 0),
    (@GUID + 147, @EVENT_FARMERS_DAUGHTER, 0),
    (@GUID + 148, @EVENT_FARMERS_DAUGHTER, 0),
    (@GUID + 149, @EVENT_FARMERS_DAUGHTER, 0),
    (@GUID + 150, @EVENT_FARMERS_DAUGHTER, 0),
    (@GUID + 151, @EVENT_FARMERS_DAUGHTER, 0),
    (@GUID + 152, @EVENT_FARMERS_DAUGHTER, 0);

INSERT INTO `entity_stats` (`Id`, `Stat`, `Value`) VALUES
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
    (@GUID + 26, 10, 15),
    (@GUID + 27, 10, 15),
    (@GUID + 29, 10, 15),
    (@GUID + 31, 10, 15),
    (@GUID + 32, 10, 15),
    (@GUID + 33, 10, 15),
    (@GUID + 35, 10, 15),
    (@GUID + 38, 10, 15),
    (@GUID + 39, 10, 15),
    (@GUID + 41, 10, 15),
    (@GUID + 42, 10, 15),
    (@GUID + 43, 10, 15),
    (@GUID + 45, 10, 15),
    (@GUID + 46, 10, 15),
    (@GUID + 47, 10, 15),
    (@GUID + 52, 10, 15),
    (@GUID + 54, 10, 15),
    (@GUID + 55, 10, 15),
    (@GUID + 56, 10, 15),
    (@GUID + 58, 10, 15),
    (@GUID + 61, 10, 15),
    (@GUID + 64, 10, 15),
    (@GUID + 72, 10, 15),
    (@GUID + 75, 10, 15),
    (@GUID + 81, 10, 15),
    (@GUID + 87, 10, 15),
    (@GUID + 95, 10, 15),
    (@GUID + 96, 10, 15),
    (@GUID + 97, 10, 15),
    (@GUID + 98, 10, 15),
    (@GUID + 101, 10, 15),
    (@GUID + 102, 10, 15),
    (@GUID + 103, 10, 15),
    (@GUID + 110, 10, 15),
    (@GUID + 111, 10, 15),
    (@GUID + 112, 10, 15),
    (@GUID + 113, 10, 15),
    (@GUID + 114, 10, 15),
    (@GUID + 115, 10, 15),
    (@GUID + 121, 10, 15),
    (@GUID + 123, 10, 15),
    (@GUID + 124, 10, 15),
    (@GUID + 126, 10, 15),
    (@GUID + 127, 10, 15),
    (@GUID + 128, 10, 15),
    (@GUID + 129, 10, 15),
    (@GUID + 131, 10, 15),
    (@GUID + 132, 10, 15),
    (@GUID + 137, 10, 15),
    (@GUID + 141, 10, 15),
    (@GUID + 142, 10, 15),
    (@GUID + 143, 10, 15),
    (@GUID + 147, 10, 15),
    (@GUID + 148, 10, 15),
    (@GUID + 149, 10, 15),
    (@GUID + 150, 10, 15),
    (@GUID + 151, 10, 15),
    (@GUID + 152, 10, 15);

INSERT INTO `entity_spline` (`id`, `splineId`, `mode`, `speed`, `fx`, `fy`, `fz`) VALUES
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
    (@GUID + 26, 4486, 2, 2, 0, 0, 0),  -- spline 4486, 88 m, closed loop, Cyclic
    (@GUID + 27, 4487, 2, 2, 0, 0, 0),  -- spline 4487, 85 m, closed loop, Cyclic
    (@GUID + 29, 4489, 2, 2, 0, 0, 0),  -- spline 4489, 127 m, closed loop, Cyclic
    (@GUID + 31, 4491, 1, 2, 0, 0, 0),  -- spline 4491, 140 m, open, BackAndForth
    (@GUID + 32, 4492, 1, 2, 0, 0, 0),  -- spline 4492, 86 m, open, BackAndForth
    (@GUID + 33, 4493, 2, 2, 0, 0, 0),  -- spline 4493, 80 m, closed loop, Cyclic
    (@GUID + 35, 4495, 1, 2, 0, 0, 0),  -- spline 4495, 119 m, open, BackAndForth
    (@GUID + 38, 4498, 1, 2, 0, 0, 0),  -- spline 4498, 75 m, open, BackAndForth
    (@GUID + 39, 4499, 1, 2, 0, 0, 0),  -- spline 4499, 69 m, open, BackAndForth
    (@GUID + 41, 4501, 1, 2, 0, 0, 0),  -- spline 4501, 86 m, open, BackAndForth
    (@GUID + 42, 4502, 1, 2, 0, 0, 0),  -- spline 4502, 108 m, open, BackAndForth
    (@GUID + 43, 4503, 1, 2, 0, 0, 0),  -- KEEP (29 Sep 2026: patrol by Tarquim) spline 4503, 72 m, open, BackAndForth
    (@GUID + 45, 4505, 1, 2, 0, 0, 0),  -- spline 4505, 97 m, open, BackAndForth
    (@GUID + 46, 4506, 1, 2, 0, 0, 0),  -- spline 4506, 58 m, open, BackAndForth
    (@GUID + 47, 4508, 1, 2, 0, 0, 0),  -- spline 4508, 359 m, open, BackAndForth
    (@GUID + 52, 4589, 1, 2, 0, 0, 0),  -- spline 4589, 64 m, open, BackAndForth
    (@GUID + 54, 4591, 1, 2, 0, 0, 0),  -- spline 4591, 91 m, open, BackAndForth
    (@GUID + 55, 4592, 1, 2, 0, 0, 0),  -- spline 4592, 75 m, open, BackAndForth
    (@GUID + 56, 4593, 1, 2, 0, 0, 0),  -- spline 4593, 67 m, open, BackAndForth
    (@GUID + 58, 4595, 1, 2, 0, 0, 0),  -- spline 4595, 108 m, open, BackAndForth
    (@GUID + 61, 4598, 1, 2, 0, 0, 0),  -- spline 4598, 74 m, open, BackAndForth
    (@GUID + 64, 4668, 1, 2, 0, 0, 0),  -- spline 4668, 430 m, open, BackAndForth
    (@GUID + 72, 4676, 1, 2, 0, 0, 0),  -- spline 4676, 94 m, open, BackAndForth
    (@GUID + 75, 4679, 1, 2, 0, 0, 0),  -- spline 4679, 505 m, open, BackAndForth
    (@GUID + 81, 6107, 1, 2, 0, 0, 0),  -- spline 6107, 315 m, open, BackAndForth
    (@GUID + 87, 7389, 1, 2, 0, 0, 0),  -- spline 7389, 123 m, open, BackAndForth
    (@GUID + 95, 7932, 1, 2, 0, 0, 0),  -- spline 7932, 96 m, open, BackAndForth
    (@GUID + 96, 7933, 2, 2, 0, 0, 0),  -- spline 7933, 91 m, closed loop, Cyclic
    (@GUID + 97, 7934, 1, 2, 0, 0, 0),  -- spline 7934, 111 m, open, BackAndForth
    (@GUID + 98, 7935, 1, 2, 0, 0, 0),  -- spline 7935, 110 m, open, BackAndForth
    (@GUID + 101, 7940, 1, 2, 0, 0, 0),  -- spline 7940, 128 m, open, BackAndForth
    (@GUID + 102, 7941, 1, 2, 0, 0, 0),  -- spline 7941, 99 m, open, BackAndForth
    (@GUID + 103, 7942, 1, 2, 0, 0, 0),  -- spline 7942, 111 m, open, BackAndForth
    (@GUID + 110, 7950, 1, 2, 0, 0, 0),  -- spline 7950, 135 m, open, BackAndForth
    (@GUID + 111, 7952, 1, 2, 0, 0, 0),  -- spline 7952, 126 m, open, BackAndForth
    (@GUID + 112, 7954, 1, 2, 0, 0, 0),  -- spline 7954, 125 m, open, BackAndForth
    (@GUID + 113, 7956, 1, 2, 0, 0, 0),  -- spline 7956, 120 m, open, BackAndForth
    (@GUID + 114, 7959, 1, 2, 0, 0, 0),  -- spline 7959, 80 m, open, BackAndForth
    (@GUID + 115, 7960, 1, 2, 0, 0, 0),  -- spline 7960, 93 m, open, BackAndForth
    (@GUID + 121, 14698, 1, 2, 0, 0, 0),  -- spline 14698, 79 m, open, BackAndForth
    (@GUID + 123, 14702, 1, 2, 0, 0, 0),  -- spline 14702, 86 m, open, BackAndForth
    (@GUID + 124, 14703, 1, 2, 0, 0, 0),  -- spline 14703, 89 m, open, BackAndForth
    (@GUID + 126, 14705, 1, 2, 0, 0, 0),  -- spline 14705, 144 m, open, BackAndForth
    (@GUID + 127, 14706, 1, 2, 0, 0, 0),  -- spline 14706, 119 m, open, BackAndForth
    (@GUID + 128, 14707, 1, 2, 0, 0, 0),  -- spline 14707, 158 m, open, BackAndForth
    (@GUID + 129, 14748, 1, 2, 0, 0, 0),  -- spline 14748, 244 m, open, BackAndForth
    (@GUID + 131, 14818, 1, 2, 0, 0, 0),  -- spline 14818, 69 m, open, BackAndForth
    (@GUID + 132, 14819, 1, 2, 0, 0, 0),  -- spline 14819, 194 m, open, BackAndForth
    (@GUID + 137, 15012, 1, 2, 0, 0, 0),  -- spline 15012, 408 m, open, BackAndForth
    (@GUID + 141, 15939, 1, 2, 0, 0, 0),  -- spline 15939, 210 m, open, BackAndForth
    (@GUID + 142, 16021, 1, 2, 0, 0, 0),  -- spline 16021, 9 m, open, BackAndForth
    (@GUID + 143, 16026, 1, 2, 0, 0, 0),  -- spline 16026, 80 m, open, BackAndForth
    (@GUID + 147, 16032, 1, 2, 0, 0, 0),  -- spline 16032, 52 m, open, BackAndForth
    (@GUID + 148, 16033, 1, 2, 0, 0, 0),  -- spline 16033, 45 m, open, BackAndForth
    (@GUID + 149, 16034, 1, 2, 0, 0, 0),  -- spline 16034, 41 m, open, BackAndForth
    (@GUID + 150, 16035, 1, 2, 0, 0, 0),  -- spline 16035, 41 m, open, BackAndForth
    (@GUID + 151, 16036, 1, 2, 0, 0, 0),  -- spline 16036, 46 m, open, BackAndForth
    (@GUID + 152, 16047, 1, 2, 0, 0, 0);  -- spline 16047, 157 m, open, BackAndForth
