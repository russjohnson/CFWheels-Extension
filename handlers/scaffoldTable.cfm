<cfscript>
	Util = request.utility;
	table = new framework.Table();
	
	// lets set some data about the db and table
	databaseName = data.event.ide.rdsview.database.xmlAttributes.name;
	table.setName(data.event.ide.rdsview.database.table.xmlAttributes.name);
	table.setColumns(Util.getColumnsFromXML(data.event.ide.rdsview.database.table.fields.xmlChildren));
	table.setPrimaryKey(Util.getPrimaryKeyFromXML(data.event.ide.rdsview.database.table.fields.xmlChildren));
	
	projectRoot = inputStruct.projectRoot & "/";
	modelPath = projectRoot & "models";
	controllerPath = projectRoot & "controllers";
	viewPath = projectRoot & "views/";
	
	templatePath = expandPath('../') & "/code/templates/scaffold/";
	
	if(inputStruct.script){
		template = "cf9script";
	} else {
		template = "default";
	}
	
	// our return message
	message = "";
	
</cfscript>


<cfif inputStruct.scaffoldType is "Controller Only">

	<cfset message = message & generateController(Util.singularize(table.getName()), template)>

<cfelseif inputStruct.scaffoldType is "Model Only">

	<cfset message = message & generateModel(Util.singularize(table.getName()), template)>

<cfelse>

	<cfset message = message & generateModel(Util.singularize(table.getName()), template) & "<br/>">
	<cfset message = message & generateController(Util.singularize(table.getName()), template) & "<br/>">
	<cfset message = message & generateViews(Util.singularize(table.getName()), template) & "<br/>">
</cfif>



<cfheader name="Content-Type" value="text/xml">  
<cfoutput>
<response status="success" showresponse="true">  
<ide>  
	<commands>
		<command type="RefreshFolder">
			<params>
			    <param key="foldername" value="#inputStruct.projectRoot#" />
			</params>
		</command>
	</commands>
	<dialog width="550" height="350" title="CFWheels Table Scaffold" image="includes/images/cfwheels-logo.png"/>  
	<body><![CDATA[
	<html>
		<head>
			<link href="<cfoutput>#request.extensionLocation#</cfoutput>/includes/css/styles.css" type="text/css" rel="stylesheet">
			<script type="text/javascript" src="includes/js/jquery.latest.min.js"></script>
		</head>
		<body>
			<div class="strong">Generated scaffolding for #Util.capitalize(table.getName())#</div>
			<p>#message#</p>
		</body>
	</html>	
	]]></body>
</ide>
</response>
</cfoutput>	
	
	
	<cffunction name="moveFileToFolder" access="public" returntype="void" hint="Checks if the desired Model is already created" output="false">
		<cfargument name="name" type="string" required="true" hint="Name to set the file when moved">
	    <cfargument name="type" type="string" required="true" hint="Type of file to move for (Model, View, Controller)">
	    <cfargument name="template" type="string" required="true" default="default">
	     
	    <cfset var loc = {}>
	    
	    <!--- Expand the destination folder and read the file move over --->
	    <cfswitch expression="#arguments.type#">
	    	<cfcase value="Model">
	            
				<!--- Expand the from and destination folders --->
	    		<cfset loc.fromFolderPath = templatePath & arguments.template>
				<cfset loc.destinationFolderPath = modelPath>
	            
	            <!--- Read the template file --->
                    <cffile action="read" file="#loc.fromFolderPath#/model.cfm" variable="loc.file">
                                
                    <!--- Replace the body of the model constructor --->
                    <cfset loc.initCode = "">
                    <cfif inputStruct.IncludeDSN>
                            <cfif NOT(inputStruct.script)>
                                    <cfset loc.initCode = loc.initCode & "<cfset ">
                            </cfif>
                            
                            <cfset loc.initCode = loc.initCode & "dataSource('" & databaseName & "')">
                            
                            <cfif NOT(inputStruct.script)>
                                    <cfset loc.initCode = loc.initCode & ">">
                            <cfelse>
                                    <cfset loc.initCode = loc.initCode & ";">
                            </cfif>
                    </cfif>
                    
                    <cfset loc.file = ReplaceNoCase(loc.file, "[ModelInitCode]", loc.initCode)>
	            
	            <!--- Write the file in the corresponding folder --->
	            <cffile action="write" file="#loc.destinationFolderPath#/#Util.capitalize(arguments.name)#.cfc" output="#loc.file#" mode="777"> 
	        </cfcase>
	        
	        <cfcase value="View">
	        	
	            <!--- Expand the from and destination folders --->
	    		<cfset loc.fromFolderPath = templatePath & arguments.template & "/views">
	            <cfset loc.destinationFolderPath = viewPath & LCase(Util.pluralize(arguments.name))>
	            
	            <!--- Create the directory to store the views in --->
	            <cfif NOT DirectoryExists(loc.destinationFolderPath)>
	            	<cfdirectory action="create" directory="#loc.destinationFolderPath#" mode="777">
	            </cfif>
	            
	            <!--- Read the template files --->
	            <cffile action="read" file="#loc.fromFolderPath#/index.cfm" variable="loc.fileIndex">
	            <cffile action="read" file="#loc.fromFolderPath#/show.cfm" variable="loc.fileShow">
	            <cffile action="read" file="#loc.fromFolderPath#/new.cfm" variable="loc.fileNew">
	            <cffile action="read" file="#loc.fromFolderPath#/edit.cfm" variable="loc.fileEdit">
	            
	            <!--- Generate the forms and listing for the views --->
	            <cfset loc.entryForm = generateEntryFormFromModel(arguments.name)>
	            <cfset loc.editForm = generateEditFormFromModel(arguments.name)>
	            <cfset loc.indexListing = generateListingViewFromModel(arguments.name)>
	            <cfset loc.showListing = generateShowViewFromModel(arguments.name)>
	            
				<!--- Replace the placeholders names --->
	    		<cfset loc.fileIndex = replacePlaceHolders(loc.fileIndex, arguments.name)>
	            <cfset loc.fileShow = replacePlaceHolders(loc.fileShow, arguments.name)>
	            <cfset loc.fileNew = replacePlaceHolders(loc.fileNew, arguments.name)>
	            <cfset loc.fileEdit = replacePlaceHolders(loc.fileEdit, arguments.name)>
	            
	            <!--- Replace the placeholder forms --->
	            <cfset loc.fileNew = ReplaceNoCase(loc.fileNew, "ENTRYFORM", loc.entryForm)>
	            <cfset loc.fileEdit = ReplaceNoCase(loc.fileEdit, "EDITFORM", loc.editForm)>
	                      
	            <!--- Replace the placeholder listing --->
	            <cfset loc.fileIndex = ReplaceNoCase(loc.fileIndex, "LISTINGCOLUMNS", loc.indexListing)>
	            
	            <!--- Replace the placeholder show --->
	            <cfset loc.fileShow = ReplaceNoCase(loc.fileShow, "LISTINGCOLUMNS", loc.showListing)>
	                        
	            <!--- Write the file in the corresponding folder --->
	            <cffile action="write" file="#loc.destinationFolderPath#/index.cfm" output="#loc.fileIndex#" mode="777"> 
	            <cffile action="write" file="#loc.destinationFolderPath#/show.cfm" output="#loc.fileShow#" mode="777"> 
	            <cffile action="write" file="#loc.destinationFolderPath#/new.cfm" output="#loc.fileNew#" mode="777"> 
	            <cffile action="write" file="#loc.destinationFolderPath#/edit.cfm" output="#loc.fileEdit#" mode="777"> 
	            
	        </cfcase>
	        
	        <cfcase value="Controller">
	        	<!--- Expand the from and destination folders --->
	    		<cfset loc.fromFolderPath = templatePath & arguments.template>
	            <cfset loc.destinationFolderPath = controllerPath>
	            
	            <!--- Read the template file --->
	            <cffile action="read" file="#loc.fromFolderPath#/controller.cfm" variable="loc.file">
	            
				<!--- Replace the placeholders with real data to the user --->
	    		<cfset loc.file = replacePlaceHolders(loc.file, arguments.name)>
	            
	            <!--- Write the file in the corresponding folder --->
	            <cffile action="write" file="#loc.destinationFolderPath#/#Util.capitalize(Util.pluralize(arguments.name))#.cfc" output="#loc.file#" mode="777"> 
	        </cfcase>
	      
	    </cfswitch>
	    
	</cffunction>
	
	<cffunction name="replacePlaceHolders" access="public" returntype="string" hint="Replaces the placeholders in the templates" output="false">
		<cfargument name="content" type="string" required="true" hint="The content where the placeholders are located for replacing">
	    <cfargument name="value" type="string" required="true" hint="The value to replace the placeholders with">
	    
	    <cfset var loc = {}>
	    
	    <!--- Find all occurences of [NamePluralLowercaseDeHumanized] and replace it --->
	    <cfset loc.replacedContent = ReplaceNoCase(arguments.content, "[NamePluralLowercaseDeHumanized]", LCase(Util.replaceUppercaseWithDash(Util.pluralize(arguments.value))), "All")>
	    <!--- Find all occurences of [NamePluralLowercase] and replace it --->
	    <cfset loc.replacedContent = ReplaceNoCase(loc.replacedContent, "[NamePluralLowercase]", LCase(Util.pluralize(arguments.value)), "All")>
	    <!--- Find all occurences of [NameSingularUppercase] and replace it --->
	    <cfset loc.replacedContent = ReplaceNoCase(loc.replacedContent, "[NameSingularUppercase]", Util.capitalize(arguments.value), "All")>
	    <!--- Find all occurences of [NameSingularLowercase] and replace it--->
	    <cfset loc.replacedContent = ReplaceNoCase(loc.replacedContent, "[NameSingularLowercase]", LCase(arguments.value), "All")>
	    
		<!--- Find all occurences of [PrimaryKey] and replace it with the actual primary key(s) --->
	    <cfset loc.replacedContent = ReplaceNoCase(loc.replacedContent, "[PrimaryKey]", lCase(table.getPrimaryKey()), "All")>
	    
	    <cfreturn loc.replacedContent>
	    
	</cffunction>
	
	<cffunction name="generateEntryFormFromModel" access="public" returnType="string" hint="Generates an entry form from a Model by reading the table schema" output="false">
		<cfargument name="name" type="string" required="true" hint="Name of the model to generator the form for">
		
		<cfset var loc = {}>
		
		<!--- Define the name of the object returned from the controller --->
		<cfset loc.nameInSingularLowercase = LCase(arguments.name)>
		<cfset loc.nameInPluralLowercase = LCase(Util.pluralize(arguments.name))>
		<cfset loc.nameInPluralUppercase = Util.capitalize(Util.pluralize(arguments.name))>
		
		<!--- Introspect the table to find the column names and types --->		
		<cfset loc.columns = table.getColumns()>

		<cfprocessingdirective suppressWhiteSpace="true">
		<cfsavecontent variable="loc.form">
			
			<cfoutput>
			[errorMessagesFor("<cfoutput>#loc.nameInSingularLowercase#</cfoutput>")]
	
			[startFormTag(action="create")]
			
				<cfloop from="1" to="#arrayLen(loc.columns)#" index="i">
					<cfif !loc.columns[i].primaryKey AND !loc.columns[i].name is "createdAt" AND !loc.columns[i].name is "updatedAt" AND !loc.columns[i].name is "deletedAt">
						[#generateFormField(loc.nameInSingularLowercase, loc.columns[i])#]
					</cfif>
				</cfloop>

				[submitTag()]
				
			[endFormTag()]
			</cfoutput>
		</cfsavecontent>
		</cfprocessingdirective>
		
		<!--- Replace the HTML comments with ColdFusion comments --->
		<cfset loc.form = Replace(loc.form, "<!--", "<!---", "All")>
		<cfset loc.form = Replace(loc.form, "-->", "--->", "All")>
		
		<!--- Replace the brackets with number signs --->
		<cfset loc.form = Replace(loc.form, "[", "##", "All")>
		<cfset loc.form = Replace(loc.form, "]", "##", "All")>
		
		<cfreturn loc.form>
	</cffunction>
	
	<cffunction name="generateEditFormFromModel" access="public" returnType="string" hint="Generates an edit form from a Model by reading the table schema" output="false">
		<cfargument name="name" type="string" required="true" hint="Name of the model to generator the form for">
		
		<cfset var loc = {}>
		
		<!--- Define the name of the object returned from the controller --->
		<cfset loc.nameInSingularLowercase = LCase(arguments.name)>
		<cfset loc.nameInPluralLowercase = LCase(Util.pluralize(arguments.name))>
		<cfset loc.nameInPluralUppercase = Util.capitalize(Util.pluralize(arguments.name))>
		
		<!--- Introspect the table to find the column names and types --->		
		<cfset loc.columns = table.getColumns()>
		
		<cfprocessingdirective suppressWhiteSpace="true">
		<cfsavecontent variable="loc.form">
			<cfoutput>
			[errorMessagesFor("<cfoutput>#loc.nameInSingularLowercase#</cfoutput>")]
	
			[startFormTag(action="update", key=params.key)]
		
				<cfloop from="1" to="#arrayLen(loc.columns)#" index="i">
					<cfif !loc.columns[i].primaryKey AND !loc.columns[i].name is "createdAt" AND !loc.columns[i].name is "updatedAt" AND !loc.columns[i].name is "deletedAt">
						[#generateFormField(loc.nameInSingularLowercase, loc.columns[i])#]
					</cfif>										
				</cfloop>
				
				[submitTag()]
				
			[endFormTag()]
			</cfoutput>
		</cfsavecontent>
		</cfprocessingdirective>
		
		<!--- Replace the HTML comments with ColdFusion comments --->
		<cfset loc.form = Replace(loc.form, "<!--", "<!---", "All")>
		<cfset loc.form = Replace(loc.form, "-->", "--->", "All")>
		
		<!--- Replace the brackets with number signs --->
		<cfset loc.form = Replace(loc.form, "[", "##", "All")>
		<cfset loc.form = Replace(loc.form, "]", "##", "All")>
		
		<cfreturn loc.form>
	</cffunction>
	
	<cffunction name="generateFormField" access="public" returnType="string" hint="Generates a form field using Wheel's view helpers" output="false">
		<cfargument name="objectName" type="string" required="true" hint="Name of the object which holds the property">
		<cfargument name="columnObject" type="struct" required="true" hint="Struct of the database column">
		
		<cfset var loc = {}>

		<cfswitch expression="#arguments.columnObject.cfsqltype#">
			<cfcase value="cf_sql_bit,cf_sql_tinyint" delimiters=",">
				<!--- Return a checkbox --->
				<cfset loc.fieldTag = "checkBox(objectName='#arguments.objectName#', property='#arguments.columnObject.name#', label='#Util.humanize(arguments.columnObject.name)#')">
			</cfcase>

			<cfcase value="cf_sql_longvarchar">
				<!--- Return a textarea --->
				<cfset loc.fieldTag = "textArea(objectName='#arguments.objectName#', property='#arguments.columnObject.name#', label='#Util.humanize(arguments.columnObject.name)#')">
			</cfcase>

			<cfcase value="cf_sql_date">
				<!--- Return a calendar --->
				<cfset loc.fieldTag = "dateSelect(objectName='#arguments.objectName#', property='#arguments.columnObject.name#', label='#Util.humanize(arguments.columnObject.name)#')">
			</cfcase>

			<cfcase value="cf_sql_time">
				<!--- Return a time picker --->
				<cfset loc.fieldTag = "timeSelect(objectName='#arguments.objectName#', property='#arguments.columnObject.name#', label='#Util.humanize(arguments.columnObject.name)#')">
			</cfcase>

			<cfcase value="cf_sql_timestamp">
				<!--- Return a calendar and time picker --->
				<cfset loc.fieldTag = "dateTimeSelect(objectName='#arguments.objectName#', property='#arguments.columnObject.name#', dateOrder='year,month,day', monthDisplay='abbreviations', label='#Util.humanize(arguments.columnObject.name)#')">
			</cfcase>

			<cfdefaultcase>
				<!--- Return a text if everything fails --->
				<cfset loc.fieldTag = "textField(objectName='#arguments.objectName#', property='#arguments.columnObject.name#', label='#Util.humanize(arguments.columnObject.name)#')">
			</cfdefaultcase>
		</cfswitch>
		
		<cfreturn loc.fieldTag>
	</cffunction>
	
	<cffunction name="generateListingViewFromModel" access="public" returnType="string" hint="Generates a listing View from a Model by reading the table schema" output="false">
		<cfargument name="name" type="string" required="true" hint="Name of the model to generator the listing for">
		
		<cfset var loc = {}>
		
		<!--- Define the name of the object returned from the controller --->
		<cfset loc.nameInSingularLowercase = LCase(arguments.name)>
		<cfset loc.nameInPluralLowercase = LCase(Util.pluralize(arguments.name))>
		<cfset loc.nameInPluralUppercase = Util.capitalize(Util.pluralize(arguments.name))>
		
		<!--- Introspect the table to find the column names --->
		<cfset loc.columns = table.getColumns()>
		
		<cfprocessingdirective suppressWhiteSpace="true">
		<cfsavecontent variable="loc.form">
			<cfoutput>
				<cfloop from="1" to="#arrayLen(loc.columns)#" index="i">
					[cfcol header="#Util.humanize(loc.columns[i].name)#" text="###loc.columns[i].name###" /]
				</cfloop>
			</cfoutput>
		</cfsavecontent>
		</cfprocessingdirective>
		
		<!--- Replace the brackets with ColdFusion tag brackets --->
		<cfset loc.form = Replace(loc.form, "[", "<", "All")>
		<cfset loc.form = Replace(loc.form, "]", ">", "All")>
		
		<cfreturn loc.form>
	</cffunction>
	
	<cffunction name="generateShowViewFromModel" access="public" returnType="string" hint="Generates a show View from a Model by reading the table schema" output="false">
		<cfargument name="name" type="string" required="true" hint="Name of the model to generator the show for">
		
		<cfset var loc = {}>
		
		<!--- Define the name of the object returned from the controller --->
		<cfset loc.nameInSingularLowercase = LCase(arguments.name)>
		<cfset loc.nameInPluralLowercase = LCase(Util.pluralize(arguments.name))>
		<cfset loc.nameInPluralUppercase = Util.capitalize(Util.pluralize(arguments.name))>
		
		<!--- Introspect the table to find the column names --->
		<cfset loc.columns = table.getColumns()>
		
		<cfprocessingdirective suppressWhiteSpace="true">
		<cfsavecontent variable="loc.form">
			<cfoutput>
				<cfloop from="1" to="#arrayLen(loc.columns)#" index="i">
					<p><label>#Util.humanize(loc.columns[i].name)#</label> <br />
						###loc.nameInSingularLowercase & "." & loc.columns[i].name###</p>
				</cfloop>
			</cfoutput>
		</cfsavecontent>
		</cfprocessingdirective>
		
		<!--- Replace the brackets with ColdFusion tag brackets --->
		<cfset loc.form = Replace(loc.form, "[", "<", "All")>
		<cfset loc.form = Replace(loc.form, "]", ">", "All")>
		
		<cfreturn loc.form>
	</cffunction>
	
	<cffunction name="generateModel" access="public" returnType="string" hint="Creates a Model for the name of the argument passed" output="false">
		<cfargument name="name" type="string" required="true" hint="Name of the object">
		<cfargument name="template" type="string" required="true" default="default">
		<cfset var loc = {}>
		
		<!--- Check that the file has not been already created --->
		<cfif Util.fileExists(arguments.name, "Model", projectRoot)>
		    <cfset loc.message = "File 'models/#Util.capitalize(arguments.name)#.cfc' already exists so skipped.">
		<cfelse>
			<cfset moveFileToFolder(arguments.name, "Model", arguments.template)>
		    <cfset loc.message = "File 'models/#Util.capitalize(arguments.name)#.cfc' created.">
		</cfif>
		
		<cfreturn loc.message>
	</cffunction>
	
	<cffunction name="generateViews" access="public" returnType="string" hint="Creates the 'index,show,new and edit' Views for the name of the argument passed" output="false">
		<cfargument name="name" type="string" required="true" hint="Name of the object">
		<cfargument name="template" type="string" required="true" default="default">
		    
		<cfset var loc = {}>
		
		<!--- Check that the folder to store the views has not been already created --->
		<cfif Util.fileExists(arguments.name, "View", projectRoot)>
		    <cfset loc.message = "Folder 'views/#LCase(Util.pluralize(arguments.name))#/' already exists so skipped.">  
		<cfelse>
			<cfset moveFileToFolder(arguments.name, "View", template)>
			<cfset loc.message = "Folder 'views/#LCase(Util.pluralize(arguments.name))#/' created.">		
		</cfif>
		
		<cfreturn loc.message>
	</cffunction>
	
	<cffunction name="generateController" access="public" returnType="string" hint="Creates a Controller for the name of the argument passed" output="false">
		<cfargument name="name" type="string" required="true" hint="Name of the object">
		<cfargument name="template" type="string" required="true" default="default">
		    
		<cfset var loc = {}>
		
		<!--- Check that the file has not been already created --->
		<cfif Util.fileExists(arguments.name, "Controller", projectRoot)>
		    <cfset loc.message = "File 'controllers/#Util.capitalize(Util.pluralize(arguments.name))#.cfc' already exists so skipped.">
		<cfelse>
			<cfset moveFileToFolder(arguments.name, "Controller", arguments.template)>
		    <cfset loc.message = "File 'controllers/#Util.capitalize(Util.pluralize(arguments.name))#.cfc' created.">
		</cfif>
		
		<cfreturn loc.message>
	</cffunction>
	
	
	<cffunction name="getTemplates" access="public" output="false" hint="Gets a list of the available templates from the template folder to make a select list.">
	   
	    <cfset var loc = {}>
	    <cfset loc.templateFolderPath = expandPath("plugins/scaffold/templates")>
	            
	    <cfdirectory action="list" directory="#loc.templateFolderPath#" name="loc.templateList">
	            
	    <cfreturn loc.templateList>
	</cffunction>
