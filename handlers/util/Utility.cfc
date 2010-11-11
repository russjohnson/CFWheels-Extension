<!--- Utility Methods that will end up being re-used --->
<cffunction name="$checkIfFileExists" access="public" returntype="boolean" hint="Checks if the desired object is already created" output="false">
	<cfargument name="name" type="string" required="true" hint="Name of the file to search for">
    <cfargument name="type" type="string" required="true" hint="Type of file to look for (Model, View, Controller)">
    
    <cfset var loc = {}>
 	
    <!--- Expand the target folder --->
    <cfswitch expression="#arguments.type#">
    	<cfcase value="Model">
    		<cfset loc.targetFolderPath = expandPath("models/")>
        </cfcase>
        <cfcase value="View">
    		<cfset loc.targetFolderPath = expandPath("views/" & LCase(pluralize(arguments.name)))>
        </cfcase>
        <cfcase value="Controller">
        	<cfset loc.targetFolderPath = expandPath("controllers/")>
        </cfcase>
    </cfswitch>
    
    <!--- Find the names of all the files in the targeted folder --->
    <cfdirectory name="loc.files" action="list" directory="#loc.targetFolderPath#" type="file">
    
    <!--- Check if the desired file is already in the targeted folder --->
	<cfif FindNoCase(arguments.name, ValueList(loc.files.name)) GT 0 OR DirectoryExists(loc.targetFolderPath) AND arguments.type IS "View">
    	<cfset loc.wasFound = true>
    <cfelse>
    	<cfset loc.wasFound = false>
	</cfif>
    
    <cfreturn loc.wasFound>
</cffunction>

<cffunction name="replacePlaceHolders" access="public" returntype="string" hint="Replaces the placeholders in the templates" output="false">
	<cfargument name="content" type="string" required="true" hint="The content where the placeholders are located for replacing">
    <cfargument name="value" type="string" required="true" hint="The value to replace the placeholders with">
    
    <cfset var loc = {}>
    
    <!--- Find all occurences of [NamePluralLowercaseDeHumanized] and replace it --->
    <cfset loc.replacedContent = ReplaceNoCase(arguments.content, "[NamePluralLowercaseDeHumanized]", LCase($replaceUppercaseWithDash(pluralize(arguments.value))), "All")>
    <!--- Find all occurences of [NamePluralLowercase] and replace it --->
    <cfset loc.replacedContent = ReplaceNoCase(loc.replacedContent, "[NamePluralLowercase]", LCase(pluralize(arguments.value)), "All")>
    <!--- Find all occurences of [NameSingularUppercase] and replace it --->
    <cfset loc.replacedContent = ReplaceNoCase(loc.replacedContent, "[NameSingularUppercase]", capitalize(arguments.value), "All")>
    <!--- Find all occurences of [NameSingularLowercase] and replace it--->
    <cfset loc.replacedContent = ReplaceNoCase(loc.replacedContent, "[NameSingularLowercase]", LCase(arguments.value), "All")>
    <!--- Find all occurences of [PrimaryKey] and replace it with the actual primary key(s) --->
    <cfset loc.replacedContent = ReplaceNoCase(loc.replacedContent, "[PrimaryKey]", model(LCase(arguments.value)).primaryKey(), "All")>
    
    <cfreturn loc.replacedContent>
    
</cffunction>


<!--- parseInput --->
<cffunction name="parseInput" output="false" access="public" returntype="any" hint="Parse Input">
	<cfargument name="eventData" type="any" required="true" />
	<cfscript>
    	var extXMLInput = xmlSearch(arguments.eventData, "/event/user/input");
		var inputStruct = StructNew();
		var i = 1;
		
		for(i=1; i lte arrayLen(extXMLInput); i++){
			StructInsert(inputStruct,"#extXMLInput[i].xmlAttributes.name#","#extXMLInput[i].xmlAttributes.value#");	
		}
		
		return inputStruct;
	</cfscript>
</cffunction>