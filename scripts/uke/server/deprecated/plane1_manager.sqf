waitUntil { !isNil "GRLIB_all_fobs" };
waitUntil { !isNil "save_is_loaded" };
[] call compileFinal preprocessFileLineNumbers "scripts\uke\server\planearmamentmanager.sqf";
_id1 = objNull;
_id2 = objNull;
_id3 = objNull;
_id4 = objNull; 
_id5 = objNull;
_id6 = objNull;
_id7 = objNull;
FNC_ACTIVATE = {
	_vehicle = _this select 0;

	_id1 = _vehicle addAction ["Load Cluster Armament",FNC_RemoteClusters,nil,1.5,false,true,"","",4];
	_id2 = _vehicle addAction ["Load GBU Armament",FNC_RemoteGBU,nil,1.5,false,true,"","",4];
	_id3 = _vehicle addAction ["Load ATGM Armament",FNC_RemoteATGM,nil,1.5,false,true,"","",4];
    _id4 = _vehicle addAction ["Load Interceptor Armament",FNC_RemoteIA,nil,1.5,false,true,"","",4];
	_id5 = _vehicle addAction ["Load Mixed Bombs",FNC_RemoteMixedBombs,nil,1.5,false,true,"","",4];
	_id6 = _vehicle addAction ["Load Default Armament",FNC_RemoteDefault,nil,1.5,false,true,"","",4];
	_id7 = _vehicle addAction ["Load Default Cluster",FNC_RemoteDefaultCluster,nil,1.5,false,true,"","",4];
	_vehicle setVariable ["_id1",["321",_id1],false];
	_vehicle setVariable ["_id2",["321",_id2],false];
	_vehicle setVariable ["_id3",["321",_id3],false];
	_vehicle setVariable ["_id4",["321",_id4],false];
	_vehicle setVariable ["_id5",["321",_id5],false];
	_vehicle setVariable ["_id6",["321",_id6],false];
	_vehicle setVariable ["_id7",["321",_id7],false];
};
publicVariable "FNC_ACTIVATE";
FNC_REMOTE_ACTIVATE = {
	_vehicle = _this select 0;
	[_vehicle] remoteExecCall ["FNC_ACTIVATE",0,"plane2on"];
};	

FNC_REMOTE_DEACTIVATE = {
	_vehicle = _this select 0;
	[_vehicle] remoteExecCall ["FNC_DEACTIVATE",0,"plane2off"];
};

FNC_DEACTIVATE = {
	_vehicle = _this select 0;
	_id1 = _vehicle getVariable ["_id1",["NOT SET",_var]] select 1;
	_id2 = _vehicle getVariable ["_id2",["NOT SET",_var]] select 1;
	_id3 = _vehicle getVariable ["_id3",["NOT SET",_var]] select 1;
	_id4 = _vehicle getVariable ["_id4",["NOT SET",_var]] select 1;
	_id5 = _vehicle getVariable ["_id5",["NOT SET",_var]] select 1;
	_id6 = _vehicle getVariable ["_id6",["NOT SET",_var]] select 1;
	_id7 = _vehicle getVariable ["_id7",["NOT SET",_var]] select 1;
	_vehicle removeAction _id1;
	_vehicle removeAction _id2;
	_vehicle removeAction _id3;
	_vehicle removeAction _id4;
	_vehicle removeAction _id5;
	_vehicle removeAction _id6;
	_vehicle removeAction _id7;
	
};
publicVariable "FNC_DEACTIVATE";
	firstloop5 = true;
	plane = objNull;
	_savedplane = objNull;

	while { true } do {

		{
			if ( typeof _x == plane_typename && _x == plane ) then {
				_savedplane = _x;
			};
		} foreach vehicles;

		if ( firstloop5 && !isNull _savedplane ) then {
			plane = _savedplane;
		} else {
			plane = plane_typename createVehicle (getposATL planespawn_0);
			plane enableSimulationGlobal false;
			plane allowdamage false;
			plane setPosATL (getposATL planespawn_0);
			plane setDir (getDir planespawn_0);

			

_trigger = createTrigger["EmptyDetector",plane,true];
_trig = _trigger attachTo [plane,[0,0,0]];
_trigger setTriggerArea[20,20,0,false,20];
_trigger setTriggerActivation ["ANY","PRESENT",true];
_trigger setTriggerStatements["{_x isKindOf 'B_Slingload_01_Ammo_F'} count thisList > 0","[plane] call FNC_REMOTE_ACTIVATE","[plane] call FNC_REMOTE_DEACTIVATE"];

		};

		firstloop5 = false;

		
		publicVariable "plane";
		clearWeaponCargoGlobal plane;
		clearMagazineCargoGlobal plane; 
		clearItemCargoGlobal plane;
		clearBackpackCargoGlobal plane;
		plane setDamage 0;
		sleep 0.5;
		plane enableSimulationGlobal true;
		plane setDamage 0;
		plane setVariable ["ace_medical_medicClass", 1, true];
		sleep 1.5;

		plane setDamage 0;
		plane allowdamage true;

		//if (KP_liberation_debug) then {private _text = format ["[KP LIBERATION] [DEBUG] plane spawned by: %1", debug_source];_text remoteExec ["diag_log",2];};

		if ( alive plane ) then {

			waitUntil {
				sleep 1;
				!alive plane;
			};
			sleep 15;

		};

		if (plane distance startbase < 500) then {
			deletevehicle plane;
		};
		sleep 0.25;
	
};