<!-- GENERATES A NEW WHEELS CONTROLLER IN THE CONTROLLERS FOLDER -->
<!-- ALSO GENERATES VIEW FILES BASED ON CONTROLLER NAME AND WHEELS CONVENTIONS -->

<cfscript>
	controllerLocation = data.event.ide.projectview.resource.xmlAttributes.path;
	controllerName = inputStruct.name;
	controllerFile = controllerName & ".cfc";
	controllerMethods = inputStruct.methods;
	
	viewsLocation = data.event.ide.projectview.xmlattributes.projectlocation & "/views/" & lCase(controllerName);
	
	controllerMessage = "";
	fileMessage = "";
</cfscript>

<!-- currently not planning to support the cf8 script style controllers -->
<cfif inputStruct.script>
	<cffile action="read" file="#ExpandPath('../')#/code/templates/controller_script.cfm" variable="controllerContent">
	<cffile action="read" file="#ExpandPath('../')#/code/templates/action_script.cfm" variable="eventMethodContent">
<cfelse>
	<cffile action="read" file="#ExpandPath('../')#/code/templates/controller.cfm" variable="controllerContent">
	<cffile action="read" file="#ExpandPath('../')#/code/templates/action.cfm" variable="eventMethodContent">
</cfif>

<!-- loop through the methods and add the methods to our template -->
<cfif len(controllerMethods)>
	<cfset methods = "">
	
	<cfloop list="#controllerMethods#" index="method">
		
		<cfset methods = methods & replaceNoCase(eventMethodContent,"[method]",ltrim(method),"all") & chr(13) & chr(13)/>
		
		<!--- check to see if we are generating views --->
		<cfif inputStruct.GenerateViews>
			<cfif NOT directoryExists(viewsLocation)>
				<cfdirectory action="create" directory="#viewsLocation#" mode="777">
			</cfif>
			<cfif !method is 'init'>
				<cfif !request.utility.fileExists(controllerName, "view", data.event.ide.projectview.xmlattributes.projectlocation)>
					<cfset fileWrite(viewsLocation & "/" & ltrim(method) & ".cfm","<h1>#controllerName# #method#</h1>")>
					<cfset fileMessage = fileMessage & "Created view file #viewsLocation#/#ltrim(method)#.cfm<br/>">
				<cfelse>
					<cfset fileMessage = fileMessage & "View file #viewsLocation#/#ltrim(method)#.cfm exists so skipped<br/>">
				</cfif>
			</cfif>
		</cfif>
		
	</cfloop>
	
	<cfset controllerContent = replaceNoCase(controllerContent,"[eventMethods]",methods,"all") />	
<cfelse>
	<cfset controllerContent = replaceNoCase(controllerContent,"[eventMethods]",'',"all") />
</cfif>

<cfif !request.utility.fileExists(controllerName, "controller", data.event.ide.projectview.xmlattributes.projectlocation)>
	<cffile action="write" file="#controllerLocation#/#controllerFile#" mode ="777" output="#controllerContent#">
	<cfset controllerMessage = "Generated controller named #controllerName#.cfc">
<cfelse>
	<cfset controllerMessage = "The controller file already exists so it was not overwritten">
</cfif>


<cfheader name="Content-Type" value="text/xml">  
<cfoutput>
<response status="success" showresponse="true">  
<ide>  
	<commands>
		<command type="RefreshProject">
			<params>
			    <param key="projectname" value="#data.event.ide.projectview.xmlAttributes.projectname#" />
			</params>
		</command>
		<command type="openfile">
			<params>
			    <param key="filename" value="#controllerLocation#/#controllerName#.cfc" />
			</params>
		</command>
	</commands>
	<dialog width="550" height="400" title="CFWheels Controller Scaffold" image="includes/images/cfwheels-logo.png"/>  
	<body><![CDATA[
	<html>
		<head>
			<base href="" />
			<link href="<cfoutput>#request.extensionLocation#</cfoutput>/includes/css/styles.css" type="text/css" rel="stylesheet">
			<script type="text/javascript" src="includes/js/jquery.latest.min.js"></script>
		</head>
		<body>
			<p><strong><cfoutput>#controllerMessage#</cfoutput></strong></p>
			<cfif inputStruct.generateViews>
				<!-- need to loop throught he methods and output the view file names here -->
				<p>Generated the following view files:<br>
					<cfoutput>
						#fileMessage#
					</cfoutput>
				</p>
			</cfif>
		</body>
	</html>	
	]]></body>
</ide>
</response>
</cfoutput>