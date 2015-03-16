_unit = _this select 0;
_faction = _this select 1;

if !(_unit isKindOf "CAManBase") exitWith {};

_initialized = _unit getVariable ["unit_initialized", false];

if (!_initialized) then {

    _unit setVariable ["unit_side", (side _unit), true];

    switch (true) do {
        case (_faction == "side_a"): { _faction = side_a_faction };
        case (_faction == "side_b"): { _faction = side_b_faction };
        case (_faction == "side_c"): { _faction = side_c_faction };
    };

    if (toUpper(_faction) == "AUTO") then {
        _faction = [(side _unit), "FACTION"] call BRM_fnc_getSideInfo;
    };

    if ( !(_faction == "CIVILIAN") && !(_faction == "VANILLA") && !units_AI_useVanillaGear) then {
        [_unit, _faction] call BRM_fnc_assignLoadout;
    };

    _unit addEventHandler ["Hit", BRM_fnc_setHitFace];
    _unit addEventHandler ["Killed", BRM_fnc_onAIKilled];

    if (("civilian_casualty_cap" in usedPlugins)) then {
        if ((mission_dead_civilian_limit > -1)&&(side _unit == civilian)) then {
            waitUntil{(!isNil"fnc_civFiredWeapon")&&(!isNil"fnc_countCivDeaths")};

          _unit addEventHandler ["fired", fnc_civFiredWeapon];
          _unit addMPEventHandler ["mpkilled", fnc_countCivDeaths];
        };
    };
    
    _unit setVariable ["unit_initialized", true, true];
};