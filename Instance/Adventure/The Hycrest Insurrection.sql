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
-- Drop ship: GC217 - Hycrest Adventure Intro - Set Ship (creature 70557, Cine_Adv_Hycrest_Intro__set_ship.m3),
-- the intro ship's interior set, spawned as a Platform (Type 11) so players can stand inside it. (27 Sep 2026: the
-- Dominion Dropship 17722 put players on its roof; it's also a Dominion ship, not the Black Hoods'.)
-- Confirmed in game 27 Sep 2026: the interior (dark room, door with the red light strip, crates, stairs) matches the
-- retail videos. The interior floor is 1.38 m above this spawn position (measured Y -872.3211). The door and the
-- walkway are part of the model (no separate entities); the script plays their animation when the briefing ends.
-- Position: hovering 17 m in front of the Abandoned Barn doorway (measured -2520.6, -929.1575, -1223.0962), deck
-- 60 m above the ground; identity rotation so the retail interior offsets around the set origin 49984 stay valid
-- (player spots 50008/50009/50022, Dawson 50021). Keep in sync with HycrestShipLayout.cs.
-- Intro event (418) phase 0; the script sends it away once everyone has jumped.
-- --------------------------------------
SET @GUID = (SELECT IFNULL(MAX(`id`), 0) FROM `entity`);
INSERT INTO `entity` (`Id`, `Type`, `Creature`, `World`, `Area`, `X`, `Y`, `Z`, `RX`, `RY`, `RZ`, `DisplayInfo`, `OutfitInfo`, `Faction1`, `Faction2`) VALUES
    (@GUID + 1, 11, 70557, @WORLD, 0, -2520.6, -873.6975, -1240.0, 0, 0, 0, 37379, 0, 219, 219);

INSERT INTO `entity_event` (`id`, `eventId`, `phase`) VALUES
    (@GUID + 1, @EVENT_INTRO, 0);

-- --------------------------------------
-- The Caretaker Disguise - Adventure Intro (creature 56685, EldanCaretaker.m3, model scale 0.6): the Caretaker's
-- hologram inside the ship, at Dawson's spot. The script removes it when Dawson comes out (phase 1).
-- Position: on the floor (Y -872.32, measured) in front of the door with the red light strip; X/Z are the estimate
-- from retail loc 50021 (Dawson's spot), not measured yet.
-- --------------------------------------
SET @GUID = (SELECT IFNULL(MAX(`id`), 0) FROM `entity`);
INSERT INTO `entity` (`Id`, `Type`, `Creature`, `World`, `Area`, `X`, `Y`, `Z`, `RX`, `RY`, `RZ`, `DisplayInfo`, `OutfitInfo`, `Faction1`, `Faction2`) VALUES
    (@GUID + 1, 10, 56685, @WORLD, 0, -2527.15, -872.32, -1241.51, -0.3093, 0, 0, 24983, 0, 219, 219);

INSERT INTO `entity_event` (`id`, `eventId`, `phase`) VALUES
    (@GUID + 1, @EVENT_INTRO, 0);

-- --------------------------------------
-- Vice-Marshal Dawson - Mission Briefer - Hycrest Adventure (creature 18365)
-- Intro objective 2113 TalkTo (TargetGroup 7183) and 2155 TimedWin 20 s.
-- Position: in front of the door with the red light strip, where the hologram stood: floor height measured
-- (Y -872.32), X/Z estimated from retail loc 50021 (offset from the set origin 49984), yaw -0.3093. Retail: he comes
-- out of that door; phase 1 of the intro event, set by the script after the Caretaker's messages.
-- DisplayInfo: Creature2 display group 28260 has 46 variants (25459 first); 25459 is a guess.
-- OutfitInfo 8039 (outfit group 8734). Faction 219 as in Creature2.
-- --------------------------------------
SET @GUID = (SELECT IFNULL(MAX(`id`), 0) FROM `entity`);
INSERT INTO `entity` (`Id`, `Type`, `Creature`, `World`, `Area`, `X`, `Y`, `Z`, `RX`, `RY`, `RZ`, `DisplayInfo`, `OutfitInfo`, `Faction1`, `Faction2`) VALUES
    (@GUID + 1, 0, 18365, @WORLD, 0, -2527.15, -872.32, -1241.51, -0.3093, 0, 0, 25459, 8039, 219, 219);

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
-- Position: measured in game (27 Sep 2026); rotated 90 degrees from the measured -0.36 (try -1.93 if it faces the
-- wrong way). Leaving through it isn't scripted yet and needs a return
-- location for instances without a match (HYCREST.md gap 11).
-- --------------------------------------
SET @GUID = (SELECT IFNULL(MAX(`id`), 0) FROM `entity`);
INSERT INTO `entity` (`Id`, `Type`, `Creature`, `World`, `Area`, `X`, `Y`, `Z`, `RX`, `RY`, `RZ`, `DisplayInfo`, `OutfitInfo`, `Faction1`, `Faction2`) VALUES
    (@GUID + 1, 14, 36869, @WORLD, 0, -2560.2874, -928.04047, -1196.5481, 1.21, 0, 0, 30429, 0, 219, 219);

INSERT INTO `entity_event` (`id`, `eventId`, `phase`) VALUES
    (@GUID + 1, @EVENT_MAIN, 0);

-- --------------------------------------
-- Not included yet (need positions or confirmation):
--   70556 Flying Ship, 70555 Camera: intro cinematic pieces; position unknown. (70556 is the Set Ship mesh exported
--   ~900 m long for the fly-in cinematic.)
--   53455 The Caretaker: "Hycrest Adventure Hub Flavor - Thayd", so the Thayd hub, not world 1149.
-- --------------------------------------
