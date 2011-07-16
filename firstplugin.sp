/**
 *
 * Version: $Id$
 */
#include <sourcemod>
#include <sdktools>
#include <mapchooser>
 
#pragma semicolon 1

 

new Handle:sm_myslap_damage = INVALID_HANDLE;
new String:g_TestString[64] = "Hello world, 123 hashita";

public OnPluginStart() {
	RegAdminCmd("sm_myslap", testMethod, ADMFLAG_SLAY);
	RegConsoleCmd("say", Command_Say);
	RegConsoleCmd("say_team", Command_Say);

	sm_myslap_damage = CreateConVar("sm_myslap_damage", "55", "Default slap damage");
	AutoExecConfig(true, "plugin_myslapQ");
}

public Action:Command_Say(client, args) {
	if (!client)
	{
		return Plugin_Continue;
	}

	decl String:text[192];
	if (!GetCmdArgString(text, sizeof(text)))
	{
		return Plugin_Continue;
	}
	
	new startidx = 0;
	if(text[strlen(text)-1] == '"')
	{
		text[strlen(text)-1] = '\0';
		startidx = 1;
	}
	
	new ReplySource:old = SetCmdReplySource(SM_REPLY_TO_CHAT);
	
	if (strcmp(text[startidx], "stuff", false) == 0)
	{

		//decl String:map[64], String:name[64];
		//GetMenuItem(menu, 7, map, sizeof(map));		
		PrintToChatAll("[SM] Stuff yo, %s", g_TestString);
		//PrintToChatAll("[SM] %s", map);
	}

	SetCmdReplySource(old);
	
	return Plugin_Continue;	
}

public Action:testMethod(client, args){
	new String:arg1[32], String:arg2[32];
	new damage = GetConVarInt(sm_myslap_damage);

	//Get the first argument
	GetCmdArg(1, arg1, sizeof(arg1));

	//If there are 2 or more arguments, and the second argument fetch is successful convert it to an integer
	if( args >= 2 && GetCmdArg(2, arg2, sizeof(arg2))){
		damage = StringToInt(arg2);
	}

	//Try and find a matching player
	new target = FindTarget(client, arg1);
	if (target == -1){
		//Couldn't find, findTarget has the reason
		return Plugin_Handled;
	}

	//If everything worked let's slap a player
	SlapPlayer(target, damage);

	new String:name[MAX_NAME_LENGTH];

	GetClientName(target, name, sizeof(name));
	ReplyToCommand(client, "[SM] You slapped %s for %d damage!", name, damage);


	return Plugin_Handled;
}

public testMethodForward(String:a[64], alpha){
	PrintToChatAll("Hello world");
	PrintToChatAll("This forward call worked");
	PrintToChatAll("Oh boy %s %d", a, alpha);
	return 42;
}

