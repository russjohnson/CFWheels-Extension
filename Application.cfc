<cfcomponent output="false">
	
	<cfscript>
		this.name				= "CFWheelsCFBuilderExtension_#hash(getCurrentTemplatePath())#";
		this.sessionManagement	= true;
		
		this.mappings["/CFWheelsExtension"] = getDirectoryFromPath(getCurrentTemplatePath()) ;
	</cfscript>

	<cffunction name="onRequest">
		<cfargument name="targetPage">
		
   		<cfsetting showdebugoutput="false">
		
		<!--- Param the incoming ide event info --->
		<cfparam name="ideeventinfo" default="">
		
		<!--- Utility Class --->
		<cfset request.utility = createObject("component","CFWheelsExtension.handlers.util.Utility")>
		<!--- Extension Location --->
		<!---<cfset request.extensionLocation = expandPath("../")>--->
		<!--- Base URL --->
		<!---<cfset request.baseURL = replacenoCase( request.utility.getURLBasePath(),"handlers","")>--->
		
		<!--- Log Request 
		<cflog file="ColdBoxCFBuilder" text="Executing #cgi.script_name# #timeFormat(now())#">
		<cflog file="ColdBoxCFBuilder" text="ideeventinfo: #ideeventinfo.toString()#">
		--->
		
		<!--- Parse incoming event info if available? --->
		<cfif isXML(ideeventinfo)>
			<cfset data = xmlParse(ideeventinfo)>
			<!--- Parse the incoming input values --->
			<cfset inputStruct = request.utility.parseInput(data)>
		</cfif>
		
		<!--- Include page requested --->
		<cfinclude template="#arguments.targetPage#">
	</cffunction>
</cfcomponent>