-- great wall gets +1 prod, no initial gold, lowered gold and lowered culture per adj after castles
INSERT OR IGNORE INTO Improvement_YieldChanges VALUES ('IMPROVEMENT_GREAT_WALL', 'YIELD_PRODUCTION', 1);
UPDATE Improvement_YieldChanges SET YieldChange=0 WHERE ImprovementType='IMPROVEMENT_GREAT_WALL' AND YieldType='YIELD_GOLD';
UPDATE Adjacency_YieldChanges SET YieldChange=1 WHERE ID='GreatWall_Culture';
UPDATE Adjacency_YieldChanges SET YieldChange=1 WHERE ID='GreatWall_Gold';
-- Crouching Tiger now a crossbowman replacement that gets +7 when adjacent to an enemy unit
INSERT OR IGNORE INTO UnitReplaces (CivUniqueUnitType , ReplacesUnitType)
    VALUES ('UNIT_CHINESE_CROUCHING_TIGER' , 'UNIT_CROSSBOWMAN');
UPDATE Units SET Cost=190 , RangedCombat=40 , Range=2 WHERE UnitType='UNIT_CHINESE_CROUCHING_TIGER';

INSERT OR IGNORE INTO Tags (Tag , Vocabulary)
    VALUES ('CLASS_CROUCHING_TIGER' , 'ABILITY_CLASS');
INSERT OR IGNORE INTO TypeTags (Type , Tag)
    VALUES ('UNIT_CHINESE_CROUCHING_TIGER' , 'CLASS_CROUCHING_TIGER');
INSERT OR IGNORE INTO Types (Type , Kind)
    VALUES ('ABILITY_TIGER_ADJACENCY_DAMAGE_CPLMOD' , 'KIND_ABILITY');
INSERT OR IGNORE INTO TypeTags (Type , Tag)
    VALUES ('ABILITY_TIGER_ADJACENCY_DAMAGE_CPLMOD' , 'CLASS_CROUCHING_TIGER');
INSERT OR IGNORE INTO UnitAbilities (UnitAbilityType , Name , Description)
    VALUES ('ABILITY_TIGER_ADJACENCY_DAMAGE_CPLMOD' , 'LOC_ABILITY_TIGER_ADJACENCY_NAME' , 'LOC_ABILITY_TIGER_ADJACENCY_DESCRIPTION');
INSERT OR IGNORE INTO UnitAbilityModifiers (UnitAbilityType , ModifierId)
    VALUES ('ABILITY_TIGER_ADJACENCY_DAMAGE_CPLMOD' , 'TIGER_ADJACENCY_DAMAGE');
INSERT OR IGNORE INTO Modifiers (ModifierId , ModifierType , SubjectRequirementSetId)
    VALUES ('TIGER_ADJACENCY_DAMAGE' , 'MODIFIER_UNIT_ADJUST_COMBAT_STRENGTH' , 'TIGER_ADJACENCY_REQUIREMENTS');
INSERT OR IGNORE INTO ModifierArguments (ModifierId , Name , Value)
    VALUES ('TIGER_ADJACENCY_DAMAGE', 'Amount' , '7'); 
INSERT OR IGNORE INTO RequirementSets (RequirementSetId , RequirementSetType)
    VALUES ('TIGER_ADJACENCY_REQUIREMENTS' , 'REQUIREMENTSET_TEST_ALL');
INSERT OR IGNORE INTO RequirementSetRequirements (RequirementSetId , RequirementId)
    VALUES ('TIGER_ADJACENCY_REQUIREMENTS' , 'PLAYER_IS_ATTACKER_REQUIREMENTS');
INSERT OR IGNORE INTO RequirementSetRequirements (RequirementSetId , RequirementId)
    VALUES ('TIGER_ADJACENCY_REQUIREMENTS' , 'ADJACENT_UNIT_REQUIREMENT');
INSERT OR IGNORE INTO ModifierStrings (ModifierId , Context , Text)
    VALUES ('TIGER_ADJACENCY_DAMAGE' , 'Preview' , 'LOC_ABILITY_TIGER_ADJACENCY_DESCRIPTION');

-- Move builder charge from Qin-Shi to China
--DELETE FROM TraitModifiers WHERE TraitType='FIRST_EMPEROR_TRAIT' AND ModifierId='TRAIT_ADJUST_BUILDER_CHARGES';
--INSERT INTO TraitModifiers(TraitType, ModifierId) VALUES
--    ('TRAIT_CIVILIZATION_DYNASTIC_CYCLE', 'TRAIT_ADJUST_BUILDER_CHARGES');
-- Remove 10% eureka/inspiration (return to QinShi leader only)
--DELETE FROM TraitModifiers WHERE ModifierId in ('TRAIT_CIVIC_BOOST', 'TRAIT_TECHNOLOGY_BOOST');

--INSERT INTO TraitModifiers (TraitType, ModifierId) VALUES
--	('FIRST_EMPEROR_TRAIT', 'TRAIT_CIVIC_BOOST'),
--	('FIRST_EMPEROR_TRAIT', 'TRAIT_TECHNOLOGY_BOOST');

-- UPDATE 10/01/2023 Give back eureka to all China and move back builder to Qin-Shin only

-- 10/03/24 QinShi +1 food per wonder
INSERT INTO Modifiers (ModifierId, ModifierType) VALUES
    ('BBG_TRAIT_WONDER_FOOD', 'MODIFIER_SINGLE_CITY_ADJUST_WONDER_YIELD_CHANGE'),
    ('BBG_TRAIT_ATTACH_WONDER_FOOD', 'MODIFIER_PLAYER_CITIES_ATTACH_MODIFIER');
INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES
    ('BBG_TRAIT_ATTACH_WONDER_FOOD', 'ModifierId', 'BBG_TRAIT_WONDER_FOOD'),
    ('BBG_TRAIT_WONDER_FOOD', 'Amount', '1'),
    ('BBG_TRAIT_WONDER_FOOD', 'YieldType', 'YIELD_FOOD');
INSERT INTO TraitModifiers VALUES
    ('FIRST_EMPEROR_TRAIT', 'BBG_TRAIT_ATTACH_WONDER_FOOD');