------------------------------------------------------------------------------
--	FILE:	 Mapuche.sql
--	AUTHOR:  iElden, D. / Jack The Narrator, BBG
--	PURPOSE: Database Civilization related modifications by new BBG
------------------------------------------------------------------------------
--==============================================================================================
--******									MAPUCHE									   ******
--==============================================================================================
-- Delete Base Initial Requirement

 -- 02/05/2021: BugFix, delete double bonus
DELETE FROM TraitModifiers WHERE TraitType='TRAIT_LEADER_LAUTARO_ABILITY' AND ModifierId='TRAIT_TOQUI_COMBAT_BONUS_VS_GOLDEN_AGE_CIV';
DELETE FROM TraitModifiers WHERE TraitType='TRAIT_CIVILIZATION_MAPUCHE_TOQUI' AND ModifierId='TRAIT_TOQUI_COMBAT_BONUS_VS_GOLDEN_AGE_CIV';

-- 16/05/2021: Ability reduce to -15/30 Loyalty
UPDATE ModifierArguments SET Value='-15' WHERE ModifierId='TRAIT_DIMINISH_LOYALTY_IN_ENEMY_CITY' AND Name='Amount';
UPDATE ModifierArguments SET Value='-15' WHERE ModifierId='TRAIT_DIMINISH_LOYALTY_IN_ENEMY_CITY' AND Name='AdditionalGoldenAge';

INSERT OR IGNORE INTO Requirements(RequirementId, RequirementType) VALUES
	('OPPONENT_IS_IN_HEROIC_AGE_REQUIREMENT', 'REQUIREMENT_OPPONENT_ERA_AGE_MATCHES'),
	('REQUIRES_OPPONENT_IS_GOLDEN_AGE_REQUIREMENTS', 'REQUIREMENT_REQUIREMENTSET_IS_MET');	
INSERT OR IGNORE INTO RequirementArguments(RequirementId, Name, Value) VALUES
	('OPPONENT_IS_IN_HEROIC_AGE_REQUIREMENT', 'Type', 'HEROIC'),	
	('REQUIRES_OPPONENT_IS_GOLDEN_AGE_REQUIREMENTS', 'RequirementSetId', 'OPPONENT_IS_IN_GOLDEN_AGE_REQUIREMENTS');	
INSERT OR IGNORE INTO RequirementSets(RequirementSetId, RequirementSetType) VALUES
	('OPPONENT_IS_IN_GOLDEN_OR_HEROIC_AGE_REQUIREMENTS', 'REQUIREMENTSET_TEST_ANY'	), 
	('MAPUCHE_TRAIT_REQUIREMENTS', 'REQUIREMENTSET_TEST_ALL');	
INSERT OR IGNORE INTO RequirementSetRequirements(RequirementSetId, RequirementId) VALUES
	('MAPUCHE_TRAIT_REQUIREMENTS', 'REQUIRES_OPPONENT_IS_GOLDEN_AGE_REQUIREMENTS'),
	('MAPUCHE_TRAIT_REQUIREMENTS', 'OPPONENT_IS_FREE_CITY_REQUIREMENT'); -- 02/05/2021: Added Free cities
	
INSERT OR IGNORE INTO Modifiers(ModifierId, ModifierType, Permanent) VALUES
	('TRAIT_TOQUI_COMBAT_BONUS_ABILITY_VS_GOLDEN_AGE_CIV', 'MODIFIER_PLAYER_UNITS_GRANT_ABILITY', 1);	
INSERT OR IGNORE INTO Modifiers(ModifierId, ModifierType, SubjectRequirementSetId) VALUES
	('MOD_ABILITY_MAPUCHE', 'MODIFIER_UNIT_ADJUST_COMBAT_STRENGTH', 'OPPONENT_IS_IN_GOLDEN_AGE_REQUIREMENTS');	
INSERT OR IGNORE INTO ModifierArguments(ModifierId, Name, Value, Extra, SecondExtra) VALUES
	('TRAIT_TOQUI_COMBAT_BONUS_ABILITY_VS_GOLDEN_AGE_CIV', 'AbilityType',	'ABILITY_TRAIT_MAPUCHE', NULL, NULL),
	('MOD_ABILITY_MAPUCHE', 'Amount', 5, NULL, NULL);

-- Combat bonus against Golden Age Civs set to 5 instead of 10
UPDATE ModifierArguments SET Value='5' WHERE ModifierId='TRAIT_TOQUI_COMBAT_BONUS_VS_GOLDEN_AGE_CIV';

INSERT OR IGNORE INTO ModifierStrings(ModifierId, Context, Text) VALUES
	('MOD_ABILITY_MAPUCHE', 'Preview', 'LOC_PREVIEW_MAPUCHE_COMBAT_BONUS_TOQUI_VS_GOLDEN_AGE_CIV');

INSERT OR IGNORE INTO Types(Type, Kind) VALUES
	('ABILITY_TRAIT_MAPUCHE', 'KIND_ABILITY');

-- 17/08/22 : fix bug where bonus is not working on gdr or planes
INSERT OR IGNORE INTO TypeTags(Type, Tag) VALUES
	('ABILITY_TRAIT_MAPUCHE', 'CLASS_ALL_COMBAT_UNITS');	

INSERT OR IGNORE INTO UnitAbilities(UnitAbilityType, Name, Description, Inactive) VALUES
	('ABILITY_TRAIT_MAPUCHE', 'LOC_ABILITY_TRAIT_MAPUCHE_NAME', 'LOC_ABILITY_TRAIT_MAPUCHE_DESCRIPTION', 1);		

INSERT OR IGNORE INTO UnitAbilityModifiers(UnitAbilityType, ModifierId) VALUES
	('ABILITY_TRAIT_MAPUCHE', 'MOD_ABILITY_MAPUCHE');	

INSERT OR IGNORE INTO TraitModifiers (TraitType, ModifierId) VALUES
	('TRAIT_CIVILIZATION_MAPUCHE_TOQUI', 'TRAIT_TOQUI_COMBAT_BONUS_ABILITY_VS_GOLDEN_AGE_CIV');
	
--Mapuche Malon loses 1 MP pillage and gains a free promotion instead 
DELETE FROM UnitAbilityModifiers WHERE ModifierId='MALON_RAIDER_TERRITORY_COMBAT_BONUS';
INSERT INTO Modifiers(ModifierId, ModifierType) VALUES
	('BBG_MALON_RAIDER_FREE_PROMOTION', 'MODIFIER_PLAYER_UNIT_ADJUST_GRANT_EXPERIENCE');
INSERT INTO ModifierArguments(ModifierId, Name, Value) VALUES
	('BBG_MALON_RAIDER_FREE_PROMOTION', 'Amount', -1);
UPDATE UnitAbilityModifiers SET ModifierId = 'BBG_MALON_RAIDER_FREE_PROMOTION' WHERE UnitAbilityType = 'ABILITY_MAPUCHE_MALON_RAIDER';
-- Malon Raiders become Horseman replacement and territory bonus replaced with +1 movement
UPDATE Units SET Combat=36, Cost=90, Maintenance=2, BaseMoves=5, PrereqTech='TECH_HORSEBACK_RIDING', MandatoryObsoleteTech='TECH_SYNTHETIC_MATERIALS' WHERE UnitType='UNIT_MAPUCHE_MALON_RAIDER';
INSERT OR IGNORE INTO UnitReplaces (CivUniqueUnitType, ReplacesUnitType)
	VALUES ('UNIT_MAPUCHE_MALON_RAIDER', 'UNIT_HORSEMAN');
UPDATE UnitUpgrades SET UpgradeUnit='UNIT_CAVALRY' WHERE Unit='UNIT_MAPUCHE_MALON_RAIDER';


-- Chemamull Unique Improvement gets +1 Production (another at Civil Service Civic)
--INSERT OR IGNORE INTO Improvement_YieldChanges (ImprovementType, YieldType, YieldChange)
--	VALUES ('IMPROVEMENT_CHEMAMULL', 'YIELD_PRODUCTION', 1);
-- 07/12 revert after NFP change
INSERT INTO Improvement_BonusYieldChanges (Id, ImprovementType, YieldType, BonusYieldChange, PrereqCivic)
	VALUES ('203', 'IMPROVEMENT_CHEMAMULL', 'YIELD_PRODUCTION', '1', 'CIVIC_CIVIL_SERVICE');

-- 20/12/14 Chemamull's now allowed on volcanic soil
INSERT OR IGNORE INTO Improvement_ValidFeatures (ImprovementType, FeatureType)
	VALUES ('IMPROVEMENT_CHEMAMULL', 'FEATURE_VOLCANIC_SOIL');
