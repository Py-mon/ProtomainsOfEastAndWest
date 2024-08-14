local Types = {}

export type Events = "battleSwitch" | "startBattle"

export type EventReturn = "cancel" -- TODO

export type EventInput = {
	protomain: Protomain,
	turnNumber: number,
}

export type InflictStatusEffectEvent = {
	protomain: Protomain,
	inflicted: Protomain,
	statusEffect: StatusEffect,
}

export type EventDamageMove = {
	protomain: Protomain,
	attackPower: number,
	typing: number,
	damageMult: number,
}

export type EventOpponentDamageMove = {
	opponent: Protomain,
	owner: Protomain,
	attackPower: number,
	typing: number,
	damageMult: number,
}

export type BeforeOrAfter = "before" | "after"

export type StatusEffect = {
	name: string,
	inflictCondition: (any) -> any,
	endCondition: ((any) -> boolean)?,
	description: string?,
}

export type Ability = {
	name: string,
	battleStart: (any) -> any,
	description: string,
	maxActivations: number?,
}

export type Species = {
	evolutions: { Stage },
	breedingCategory: string,
	maleChance: number,
	name: string,
}

-- TODO evolveWhen: (() -> ())?,
export type Stage = {
	name: string,
	baseStats: Stats_,
	moves: { Move },
	setAbilities: { Ability },
	chanceAbilities: { [number]: Ability },
	types: { Type },
	model: Part,
}

export type MoveAttackCategory = "ranged" | "melee" | "status"

export type MoveBodyPart = "legs" | "claws" | "teeth" | "nose"

-- TODO CHANGE any type to function type for funcs

export type Move = {
	name: string,
	func: any,
	target: MoveTarget,
	category: MoveAttackCategory,
	physicalContact: boolean,
	type_: Type,
	energyCost: number,
	description: string,

	neverMissPriority: number,
	blockPriority: number,

	critChance: number?,

	accuracy: number,
	basePower: number,
	priority: number,
	bodyPart: MoveBodyPart,
}

export type Battle = {
	allies: { Protomain },
	opponents: { Protomain },
	eventsRunning: { { disconnect: () -> () } },
	allProtomains: { Protomain },
}

export type InBattle = {
	stages: Stats_,

	nextMoveFunc: any,
	moveTurnNumber: number,
	moveHits: { Protomain },

	_damageTaken: number,
	_energyUsed: number,
	move: Move,
	target: Protomain,
	statusEffect: StatusEffect?,
	statusEffectTurnNumber: number,

	evasion: number,
}

export type Protomain = {
	id: number,
	species: Species,
	model: Part,

	nickname: string?,

	_evolution: number,
	evolution: Stage,

	abilities: { Ability },

	effortStats: Stats_,
	effortPoints: number,
	size: number,
	isMale: boolean,
	isGlossy: boolean,
	isWild: boolean,

	moves: { Move },

	level: number,
	_experience: number,

	-- stats mainly used in battle
	stages: Stats_,

	nextMoveFunc: any,
	moveTurnNumber: number,
	moveHits: { Protomain },

	_damageTaken: number,
	_energyUsed: number,
	move: Move,
	target: Protomain,
	statusEffect: StatusEffect?,
	statusEffectTurnNumber: number,

	evasion: number,

	battle: Battle,
}

export type WildProtomain = Protomain & { encountered: boolean }

export type Type = {
	name: Types,
	mults: { [Types]: number },
}

export type Types = (
	"Basic"
	| "Fire"
	| "Water"
	| "Electric"
	| "Nature"
	| "Ice"
	| "Brawler"
	| "Toxic"
	| "Earth"
	| "Air"
	| "Mind"
	| "Bug"
	| "Mineral"
	| "Spirit"
	| "Dragon"
	| "Dark"
	| "Metal"
	| "Mystic"
	| "Light"
	| "Sound"
	| "Cyber"
	| "Cosmic"
)

export type Stat = "health" | "energy" | "speed" | "rangedAttack" | "rangedDefense" | "meleeAttack" | "meleeDefense"
export type NormalStat = "speed" | "rangedAttack" | "rangedDefense" | "meleeAttack" | "meleeDefense"
export type AttackStat = "meleeAttack" | "rangedAttack"

export type Stats_ = {
	health: number,
	energy: number,
	meleeAttack: number,
	rangedAttack: number,
	rangedDefense: number,
	speed: number,
}
-- TODO change these to ENums
export type MoveTarget = "none" | "opponent" | "allOpponents" | "ally" | "allProtomains"

export type EventTarget = "user" | "opponent" | "allProtomain" | "ally"

return Types
