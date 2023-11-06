--5.6. Disable:
--building reqs (reqs are dynamically controlled via Lua)
/*
INSERT INTO Requirements(RequirementId, RequirementType) VALUES
	('DISTRICT_IS_INCOMPLETE_WONDER_REQ_BBG','REQUIREMENT_PLOT_PROPERTY_MATCHES');
INSERT INTO RequirementArguments(RequirementId, Name, Value) VALUES
	('DISTRICT_IS_INCOMPLETE_WONDER_REQ_BBG', 'PropertyName', 'DISTRICT_INCOMPLETE_WONDER'),
	('DISTRICT_IS_INCOMPLETE_WONDER_REQ_BBG', 'PropertyMinimum', '1');
INSERT INTO RequirementSets(RequirementSetId, RequirementSetType) VALUES
	('DISTRICT_IS_INCOMPLETE_WONDER_REQSET_BBG', 'REQUIREMENTSET_TEST_ALL');
INSERT INTO RequirementSetRequirements(RequirementSetId, RequirementId) VALUES
	('DISTRICT_IS_INCOMPLETE_WONDER_REQSET_BBG', 'DISTRICT_IS_INCOMPLETE_WONDER_REQ_BBG');
INSERT INTO Modifiers(ModifierId, ModifierType, SubjectRequirementSetId) VALUES
	('MODIFIER_LUDWIG_REMOVE_INCOMPLETE_WONDER_ADJ_BBG','MODIFIER_PLAYER_DISTRICTS_ADJUST_YIELD_MODIFIER', 'DISTRICT_IS_INCOMPLETE_WONDER_REQSET_BBG');
INSERT INTO ModifierArguments(ModifierId, Name, Value) VALUES
	('MODIFIER_LUDWIG_REMOVE_INCOMPLETE_WONDER_ADJ_BBG', 'YieldType', 'YIELD_CULTURE'),
	('MODIFIER_LUDWIG_REMOVE_INCOMPLETE_WONDER_ADJ_BBG', 'Amount', '-100');
INSERT INTO TraitModifiers(TraitType, ModifierId) VALUES
	('TRAIT_LEADER_LUDWIG', 'MODIFIER_LUDWIG_REMOVE_INCOMPLETE_WONDER_ADJ_BBG');
*/
--5.6: 1 cult on incomplete wonders
UPDATE ModifierArguments SET Value = '1' WHERE ModifierId = 'LUDWIG_WONDER_ADJACENCY' AND Name = 'Amount';