<cfcomponent output="false" extends="handlers.BaseApplication">
	
	<cfscript>
		this.name = "CFWheelsCFBuilderExtension_#hash(getCurrentTemplatePath())#";
		this.sessionManagement = true;
		
		this.mappings["/CFWheelsExtension"] = getDirectoryFromPath(getCurrentTemplatePath()) ;
	</cfscript>
	
	<cffunction name="onApplicationStart">
    	<cfset super.onApplicationStart() />
 
    	<cfreturn true />
	</cffunction>
	
	<cffunction name="onRequestStart">
    	<cfsetting showdebugoutput="false">
	</cffunction>

	<cffunction name="onRequest">
		<cfargument name="targetPage" type="string" required="true">
		
		<cfset super.onRequest(arguments.targetPage) />
		
		<!--- Param the incoming ide event info --->
		<cfparam name="ideeventinfo" default="">
		
		<!--- Utility Class --->
		<cfset request.utility = createObject("component","CFWheelsExtension.handlers.framework.Util")>
		<!--- Extension Location --->
		<cfset request.extensionLocation = expandPath("../")>
		
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