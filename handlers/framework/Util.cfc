<cfcomponent displayname="Util" hint="Handles utility methods for the Extension" output="false">


	<cffunction name="fileExists" access="public" returntype="boolean" hint="Checks if the desired object is already created" output="true">
		<cfargument name="name" type="string" required="true" hint="Name of the file to search for">
	    <cfargument name="type" type="string" required="true" hint="Type of file to look for (Model, View, Controller)">
	    <cfargument name="projectRoot" type="string" required="true">
	    
	    <cfif !right(arguments.projectRoot,1) is "/">
	    	<cfset arguments.projectRoot = arguments.projectRoot & "/">
	    </cfif>
	    
	    <cfset var loc = {}>
	 	
	    <!--- Expand the target folder --->
	    <cfswitch expression="#arguments.type#">
	    	<cfcase value="Model">
	    		<cfset loc.targetFolderPath = arguments.projectRoot & "models/">
	        </cfcase>
	        <cfcase value="View">
	    		<cfset loc.targetFolderPath = arguments.projectRoot & "views/" & LCase(pluralize(arguments.name))>
	        </cfcase>
	        <cfcase value="Controller">
	        	<cfset loc.targetFolderPath = arguments.projectRoot & "controllers/">
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
	
	<cffunction name="capitalize" returntype="string" access="public" output="false">
		<cfargument name="text" type="string" required="true" hint="Text to capitalize">
		<cfreturn UCase(Left(arguments.text, 1)) & Mid(arguments.text, 2, Len(arguments.text)-1)>
	</cffunction>
	
	<cffunction name="singularize" returntype="string" access="public" output="false">
		<cfargument name="word" type="string" required="true" hint="String to singularize">
		<cfreturn singularizeOrPluralize(text=arguments.word, which="singularize")>
	</cffunction>

	<cffunction name="pluralize" returntype="string" access="public" output="false">
		<cfargument name="word" type="string" required="true" hint="The word to pluralize">
		<cfargument name="count" type="numeric" required="false" default="-1" hint="Pluralization will occur when this value is not 1">
		<cfargument name="returnCount" type="boolean" required="false" default="true" hint="Will return the count prepended to the pluralization when true and count is not -1">
		<cfreturn singularizeOrPluralize(text=arguments.word, which="pluralize", count=arguments.count, returnCount=arguments.returnCount)>
	</cffunction>
	
	<cffunction name="humanize" returntype="string" access="public" output="false">
		<cfargument name="text" type="string" required="true" hint="Text to humanize">
		<cfscript>
			var loc = {};
			loc.returnValue = REReplace(arguments.text, "([[:upper:]])", " \1", "all"); // adds a space before every capitalized word
			loc.returnValue = REReplace(loc.returnValue, "([[:upper:]]) ([[:upper:]]) ", "\1\2", "all"); // fixes abbreviations so they form a word again (example: aURLVariable)
			loc.returnValue = capitalize(loc.returnValue); // capitalize the first letter
		</cfscript>
		<cfreturn loc.returnValue>
</cffunction>

	<cffunction name="singularizeOrPluralize" returntype="string" access="public" output="false">
		<cfargument name="text" type="string" required="true">
		<cfargument name="which" type="string" required="true">
		<cfargument name="count" type="numeric" required="false" default="-1">
		<cfargument name="returnCount" type="boolean" required="false" default="true">
		<cfscript>
			var loc = {};
			loc.returnValue = arguments.text;
			if (arguments.count != 1)
			{
				loc.uncountables = "advice,air,blood,deer,equipment,fish,food,furniture,garbage,graffiti,grass,homework,housework,information,knowledge,luggage,mathematics,meat,milk,money,music,pollution,research,rice,sand,series,sheep,soap,software,species,sugar,traffic,transportation,travel,trash,water";
				loc.irregulars = "child,children,foot,feet,man,men,move,moves,person,people,sex,sexes,tooth,teeth,woman,women";
				if (ListFindNoCase(loc.uncountables, arguments.text))
				{
					loc.returnValue = arguments.text;
				}
				else if (ListFindNoCase(loc.irregulars, arguments.text))
				{
					loc.pos = ListFindNoCase(loc.irregulars, arguments.text);
					if (arguments.which == "singularize" && loc.pos MOD 2 == 0)
						loc.returnValue = ListGetAt(loc.irregulars, loc.pos-1);
					else if (arguments.which == "pluralize" && loc.pos MOD 2 != 0)
						loc.returnValue = ListGetAt(loc.irregulars, loc.pos+1);
					else
						loc.returnValue = arguments.text;
				}
				else
				{
					if (arguments.which == "pluralize")
						loc.ruleList = "(quiz)$,\1zes,^(ox)$,\1en,([m|l])ouse$,\1ice,(matr|vert|ind)ix|ex$,\1ices,(x|ch|ss|sh)$,\1es,([^aeiouy]|qu)y$,\1ies,(hive)$,\1s,(?:([^f])fe|([lr])f)$,\1\2ves,sis$,ses,([ti])um$,\1a,(buffal|tomat|potat|volcan|her)o$,\1oes,(bu)s$,\1ses,(alias|status),\1es,(octop|vir)us$,\1i,(ax|test)is$,\1es,s$,s,$,s";
					else if (arguments.which == "singularize")
						loc.ruleList = "(quiz)zes$,\1,(matr)ices$,\1ix,(vert|ind)ices$,\1ex,^(ox)en,\1,(alias|status)es$,\1,([octop|vir])i$,\1us,(cris|ax|test)es$,\1is,(shoe)s$,\1,(o)es$,\1,(bus)es$,\1,([m|l])ice$,\1ouse,(x|ch|ss|sh)es$,\1,(m)ovies$,\1ovie,(s)eries$,\1eries,([^aeiouy]|qu)ies$,\1y,([lr])ves$,\1f,(tive)s$,\1,(hive)s$,\1,([^f])ves$,\1fe,(^analy)ses$,\1sis,((a)naly|(b)a|(d)iagno|(p)arenthe|(p)rogno|(s)ynop|(t)he)ses$,\1\2sis,([ti])a$,\1um,(n)ews$,\1ews,s$,#Chr(7)#";
					loc.rules = ArrayNew(2);
					loc.count = 1;
					loc.iEnd = ListLen(loc.ruleList);
					for (loc.i=1; loc.i <= loc.iEnd; loc.i=loc.i+2)
					{
						loc.rules[loc.count][1] = ListGetAt(loc.ruleList, loc.i);
						loc.rules[loc.count][2] = ListGetAt(loc.ruleList, loc.i+1);
						loc.count = loc.count + 1;
					}
					loc.iEnd = ArrayLen(loc.rules);
					for (loc.i=1; loc.i <= loc.iEnd; loc.i++)
					{
						if(REFindNoCase(loc.rules[loc.i][1], arguments.text))
						{
							loc.returnValue = REReplaceNoCase(arguments.text, loc.rules[loc.i][1], loc.rules[loc.i][2]);
							break;
						}
					}
					loc.returnValue = Replace(loc.returnValue, Chr(7), "", "all");
				}
			}
			if (arguments.returnCount && arguments.count != -1)
				loc.returnValue = arguments.count & " " & loc.returnValue;
		</cfscript>
		<cfreturn loc.returnValue>
	</cffunction>
	
	<cffunction name="replaceUppercaseWithDash" access="public" returnType="string" hint="Adds a dash before every upper case letter">
		<cfargument name="text" type="string" required="true">
		
		<cfset var loc = {}>
		<cfset loc.returnValue = REReplace(arguments.text, "([[:upper:]])", "-\1", "all")>
		
		<cfreturn loc.returnValue>
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
	
	
	<cffunction name="getColumnsFromXML" access="public" output="false">
		<cfargument name="xmlNode" type="any" required="true">
		<cfset var loc = {}>
		<cfset loc.columns = []>
		<cfscript>
		
			for (i=1;i LTE ArrayLen(arguments.xmlNode);i=i+1) {
    	    	column = arguments.xmlNode[i].xmlAttributes;
				
    	        arrayAppend(loc.columns,column);
            }
		</cfscript>
		<cfreturn loc.columns>
	</cffunction>
	
	<cffunction name="getPrimaryKeyFromXML" access="public" output="false">
		<cfargument name="xmlNode" type="any" required="true">
		<cfset var loc = {}>

		<cfscript>
		
			for (i=1;i LTE ArrayLen(arguments.xmlNode);i=i+1) {
    	    	loc.column = arguments.xmlNode[i].xmlAttributes;
				
				// not sure if we need to support multiple keys here or not
				// first build will handle single key
    	        if(loc.column.primaryKey){
					return loc.column.name;
				}
            }
		</cfscript>
	</cffunction>
	
	<!--- 
	This function converts XML variables into Coldfusion Structures. It also
	returns the attributes for each XML node.
	--->
	
	<cffunction name="xmlToStruct" access="public" returntype="struct" output="false" hint="Parse raw XML response body into ColdFusion structs and arrays and return it.">
		<cfargument name="xmlNode" type="string" required="true" />
		<cfargument name="str" type="struct" required="true" />
		<!---Setup local variables for recurse: --->
		<cfset var i = 0 />
		<cfset var axml = arguments.xmlNode />
		<cfset var astr = arguments.str />
		<cfset var n = "" />
		<cfset var tmpContainer = "" />
		
		<cfset axml = XmlSearch(XmlParse(arguments.xmlNode),"/node()")>
		<cfset axml = axml[1] />
		<!--- For each children of context node: --->
		<cfloop from="1" to="#arrayLen(axml.XmlChildren)#" index="i">
			<!--- Read XML node name without namespace: --->
			<cfset n = replace(axml.XmlChildren[i].XmlName, axml.XmlChildren[i].XmlNsPrefix&":", "") />
			<!--- If key with that name exists within output struct ... --->
			<cfif structKeyExists(astr, n)>
				<!--- ... and is not an array... --->
				<cfif not isArray(astr[n])>
					<!--- ... get this item into temp variable, ... --->
					<cfset tmpContainer = astr[n] />
					<!--- ... setup array for this item beacuse we have multiple items with same name, ... --->
					<cfset astr[n] = arrayNew(1) />
					<!--- ... and reassing temp item as a first element of new array: --->
					<cfset astr[n][1] = tmpContainer />
				<cfelse>
					<!--- Item is already an array: --->
					
				</cfif>
				<cfif arrayLen(axml.XmlChildren[i].XmlChildren) gt 0>
						<!--- recurse call: get complex item: --->
						<cfset astr[n][arrayLen(astr[n])+1] = xmlToStruct(axml.XmlChildren[i], structNew()) />
					<cfelse>
						<!--- else: assign node value as last element of array: --->
						<cfset astr[n][arrayLen(astr[n])+1] = axml.XmlChildren[i].XmlText />
				</cfif>
			<cfelse>
				<!---
					This is not a struct. This may be first tag with some name.
					This may also be one and only tag with this name.
				--->
				<!---
						If context child node has child nodes (which means it will be complex type): --->
				<cfif arrayLen(axml.XmlChildren[i].XmlChildren) gt 0>
					<!--- recurse call: get complex item: --->
					<cfset astr[n] = xmlToStruct(axml.XmlChildren[i], structNew()) />
				<cfelse>
					<!--- else: assign node value as last element of array: --->
					<!--- if there are any attributes on this element--->
					<cfif IsStruct(aXml.XmlChildren[i].XmlAttributes) AND StructCount(aXml.XmlChildren[i].XmlAttributes) GT 0>
						<!--- assign the text --->
						<cfset astr[n] = axml.XmlChildren[i].XmlText />
							<!--- check if there are no attributes with xmlns: , we dont want namespaces to be in the response--->
						 <cfset attrib_list = StructKeylist(axml.XmlChildren[i].XmlAttributes) />
						 <cfloop from="1" to="#listLen(attrib_list)#" index="attrib">
							 <cfif ListgetAt(attrib_list,attrib) CONTAINS "xmlns:">
								 <!--- remove any namespace attributes--->
								<cfset Structdelete(axml.XmlChildren[i].XmlAttributes, listgetAt(attrib_list,attrib))>
							 </cfif>
						 </cfloop>
						 <!--- if there are any atributes left, append them to the response--->
						 <cfif StructCount(axml.XmlChildren[i].XmlAttributes) GT 0>
							 <cfset astr[n&'_attributes'] = axml.XmlChildren[i].XmlAttributes />
						</cfif>
					<cfelse>
						 <cfset astr[n] = axml.XmlChildren[i].XmlText />
					</cfif>
				</cfif>
			</cfif>
		</cfloop>
		<!--- return struct: --->
		<cfreturn astr />
	</cffunction>
	
	
	

</cfcomponent>