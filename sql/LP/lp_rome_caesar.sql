/*
--Seige Ignore Obstacles (features and terrain separate)--
INSERT INTO RequirementSets(RequirementSetId, RequirementSetType) VALUES
	('BBG_PROMOTION_CLASS_SIEGE_REQSET', 'REQUIREMENTSET_TEST_ALL');
INSERT INTO RequirementSetRequirements(RequirementSetId, RequirementId) VALUES
	('BBG_PROMOTION_CLASS_SIEGE_REQSET', 'REQUIREMENT_UNIT_IS_SIEGE');

INSERT INTO Modifiers(ModifierId, ModifierType, SubjectRequirementSetId) VALUES
	('BBG_CAESAR_SIEGE_IGNORE_FEATURES', 'MODIFIER_PLAYER_UNITS_ATTACH_MODIFIER', 'BBG_PROMOTION_CLASS_SIEGE_REQSET'),
	('BBG_CAESAR_SIEGE_IGNORE_FEATURES_MODIFIER', 'MODIFIER_PLAYER_UNIT_ADJUST_SEE_THROUGH_FEATURES', NULL),
	('BBG_CAESAR_SIEGE_IGNORE_TERRAIN', 'MODIFIER_PLAYER_UNITS_ATTACH_MODIFIER', 'BBG_PROMOTION_CLASS_SIEGE_REQSET'),
	('BBG_CAESAR_SIEGE_IGNORE_TERRAIN_MODIFIER', 'MODIFIER_PLAYER_UNIT_ADJUST_SEE_THROUGH_TERRAIN', NULL);

INSERT INTO ModifierArguments(ModifierId, Name, Value) VALUES
	('BBG_CAESAR_SIEGE_IGNORE_FEATURES_MODIFIER', 'CanSee', '1'),
	('BBG_CAESAR_SIEGE_IGNORE_FEATURES', 'ModifierId', 'BBG_CAESAR_SIEGE_IGNORE_FEATURES_MODIFIER'),
	('BBG_CAESAR_SIEGE_IGNORE_TERRAIN_MODIFIER', 'CanSee', '1'),
	('BBG_CAESAR_SIEGE_IGNORE_TERRAIN', 'ModifierId', 'BBG_CAESAR_SIEGE_IGNORE_TERRAIN_MODIFIER');

INSERT INTO TraitModifiers(TraitType, ModifierId) VALUES
	('TRAIT_LEADER_CAESAR', 'BBG_CAESAR_SIEGE_IGNORE_FEATURES'),
	('TRAIT_LEADER_CAESAR', 'BBG_CAESAR_SIEGE_IGNORE_TERRAIN');
*/

--Free Melee Unit on Settle--
-- 22/12/22 not giving a warrior on capital
INSERT INTO Modifiers (ModifierId, ModifierType, Permanent, SubjectRequirementSetId) VALUES
    ('BBG_TRAIT_GRANT_FREE_MELEE_UNIT_ON_NEW_CITY', 'MODIFIER_PLAYER_CITIES_GRANT_UNIT_BY_CLASS', 1, 'BBG_CITY_FOUNDER_NOT_CAPITAL_REQUIREMENTS');
INSERT INTO TraitModifiers (TraitType, ModifierId) VALUES
    ('TRAIT_LEADER_CAESAR', 'BBG_TRAIT_GRANT_FREE_MELEE_UNIT_ON_NEW_CITY');
INSERT INTO RequirementSets (RequirementSetId, RequirementSetType) VALUES
    ('BBG_CITY_FOUNDER_NOT_CAPITAL_REQUIREMENTS', 'REQUIREMENTSET_TEST_ALL');
INSERT INTO RequirementSetRequirements (RequirementSetId, RequirementId) VALUES
    ('BBG_CITY_FOUNDER_NOT_CAPITAL_REQUIREMENTS', 'CITY_FOUNDED_BY_SETTLER_REQUIREMENT'),
-- inversing "is_capital" is not working
    ('BBG_CITY_FOUNDER_NOT_CAPITAL_REQUIREMENTS', 'REQUIRES_OBJECT_1_OR_MORE_TILES_FROM_CAPITAL');
INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES
    ('BBG_TRAIT_GRANT_FREE_MELEE_UNIT_ON_NEW_CITY', 'UnitPromotionClassType', 'PROMOTION_CLASS_MELEE');


--Wildcard--
INSERT INTO RequirementSets (RequirementSetId, RequirementSetType) VALUES 
	('BBG_CAESAR_WILDCARD_REQSET', 'REQUIREMENTSET_TEST_ALL'),
	('BBG_CAESAR_CAPTURED_CITY_NOT_CS_REQSET', 'REQUIREMENTSET_TEST_ALL'),
	('BBG_CAESAR_CAPTURED_NOT_CS_OR_RECONQUEST_REQSET', 'REQUIREMENTSET_TEST_ANY');
	--('BBG_CAESAR_CAPTURED_ORIGINAL_CAPITAL_NOT_CS_REQSET', 'REQUIREMENTSET_TEST_ALL'); --Capitals

INSERT INTO RequirementSetRequirements (RequirementSetId, RequirementId) VALUES 
	('BBG_CAESAR_WILDCARD_REQSET', 'BBG_REQUIRES_CAESAR_CAPTURED_MAJOR_PLAYER_CITY'),
	('BBG_CAESAR_CAPTURED_CITY_NOT_CS_REQSET', 'BBG_REQUIRES_CITY_IS_CAPTURED'),
	('BBG_CAESAR_CAPTURED_CITY_NOT_CS_REQSET','BBG_REQUIRES_CAESAR_CAPTURED_NOT_CS_OR_RECONQUEST'),
	('BBG_CAESAR_CAPTURED_NOT_CS_OR_RECONQUEST_REQSET', 'BBG_REQUIRES_NOT_CS'),
	('BBG_CAESAR_CAPTURED_NOT_CS_OR_RECONQUEST_REQSET', 'BBG_REQUIRES_CAESAR_RECONQUEST');
	--('BBG_CAESAR_CAPTURED_ORIGINAL_CAPITAL_NOT_CS_REQSET', 'BBG_REQUIRES_CITY_IS_CAPTURED'), --Capitals
	--('BBG_CAESAR_CAPTURED_ORIGINAL_CAPITAL_NOT_CS_REQSET', 'BBG_REQUIRES_CITY_IS_ORIGINAL_CAPITAL'), --Capitals
	--('BBG_CAESAR_CAPTURED_ORIGINAL_CAPITAL_NOT_CS_REQSET','BBG_REQUIRES_CAPITAL_NOT_CS'); -- Capitals

-- Requirements

INSERT INTO Requirements (RequirementId, RequirementType, Inverse) VALUES 
	('BBG_REQUIRES_CAESAR_CAPTURED_MAJOR_PLAYER_CITY', 'REQUIREMENT_COLLECTION_COUNT_ATLEAST', '0'),
	('BBG_REQUIRES_CITY_IS_CAPTURED', 'REQUIREMENT_CITY_IS_ORIGINAL_OWNER', '1'), 
	('BBG_REQUIRES_NOT_CS', 'REQUIREMENT_PLOT_PROPERTY_MATCHES','1'),
	('BBG_REQUIRES_CAESAR_RECONQUEST', 'REQUIREMENT_PLOT_PROPERTY_MATCHES', '0'),
	('BBG_REQUIRES_CAESAR_CAPTURED_NOT_CS_OR_RECONQUEST', 'REQUIREMENT_REQUIREMENTSET_IS_MET', '0');
	--('BBG_REQUIRES_CITY_IS_ORIGINAL_CAPITAL', 'REQUIREMENT_CITY_IS_ORIGINAL_CAPITAL', '0');-- Capital

--property 'CS_CAPITAL_BBG' is attached to the plot via lua. Safe Game Loop, trivial code.
--Tried with InternalOnly buildings for CS controll, but they vanish after change of ownership
--Visible buildings show up in a lot of previews (city buildings, civilopedia), even if you make their construction conditions unaccessible
INSERT INTO RequirementArguments (RequirementId, Name, Value) VALUES
	('BBG_REQUIRES_CAESAR_CAPTURED_NOT_CS_OR_RECONQUEST', 'RequirementSetId', 'BBG_CAESAR_CAPTURED_NOT_CS_OR_RECONQUEST_REQSET'),
	('BBG_REQUIRES_NOT_CS', 'PropertyName', 'CS_CAPITAL_BBG'),
	('BBG_REQUIRES_NOT_CS', 'PropertyMinimum', '1'),
	('BBG_REQUIRES_CAESAR_RECONQUEST', 'PropertyName', 'CAESAR_MAJOR_RECONQUEST_BBG'),
	('BBG_REQUIRES_CAESAR_RECONQUEST', 'PropertyMinimum', '1'),
	('BBG_REQUIRES_CAESAR_CAPTURED_MAJOR_PLAYER_CITY', 'CollectionType', 'COLLECTION_PLAYER_CITIES'), 
	('BBG_REQUIRES_CAESAR_CAPTURED_MAJOR_PLAYER_CITY', 'Count', '1'), 
	('BBG_REQUIRES_CAESAR_CAPTURED_MAJOR_PLAYER_CITY', 'RequirementSetId', 'BBG_CAESAR_CAPTURED_CITY_NOT_CS_REQSET');
	--('BBG_REQUIRES_CAESAR_CAPTURED_MAJOR_PLAYER_CITY', 'RequirementSetId', 'BBG_CAESAR_CAPTURED_ORIGINAL_CAPITAL_NOT_CS_REQSET');--CAP

--Caesar Wildcard per retained captured city--
INSERT INTO Modifiers (ModifierId, ModifierType, SubjectRequirementSetId) VALUES 
	('BBG_CAESAR_FREE_WILDCARD_SLOT', 'MODIFIER_PLAYER_CULTURE_ADJUST_GOVERNMENT_SLOTS_MODIFIER', 'BBG_CAESAR_WILDCARD_REQSET');

INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES 
	('BBG_CAESAR_FREE_WILDCARD_SLOT', 'GovernmentSlotType', 'SLOT_WILDCARD');

INSERT INTO TraitModifiers(TraitType, ModifierId) VALUES
	('TRAIT_LEADER_CAESAR', 'BBG_CAESAR_FREE_WILDCARD_SLOT');

