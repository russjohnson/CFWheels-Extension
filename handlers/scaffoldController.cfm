<!-- GENERATES A NEW WHEELS CONTROLLER IN THE CONTROLLERS FOLDER -->
<!-- ALSO GENERATES VIEW FILES BASED ON CONTROLLER NAME AND WHEELS CONVENTIONS -->

<cfscript>
	controllerLocation = data.event.ide.projectview.resource.xmlAttributes.path;
	controllerName = inputStruct.name;
	controllerMethods = inputStruct.methods;
	
	viewsLocation = data.event.ide.projectview.xmlattributes.projectlocation & "/views/" & lCase(controllerName);
</cfscript>

<!-- currently not planning to support the cf8 script style controllers -->
<cfif inputStruct.script>
	<cffile action="read" file="#ExpandPath('../')#/code/templates/controller_script.cfm" variable="controllerContent">
	<cffile action="read" file="#ExpandPath('../')#/code/templates/eventMethod_script.cfm" variable="eventMethodContent">
<cfelse>
	<cffile action="read" file="#ExpandPath('../')#/code/templates/controller.cfm" variable="controllerContent">
	<cffile action="read" file="#ExpandPath('../')#/code/templates/eventMethod.cfm" variable="eventMethodContent">
</cfif>

<!-- loop through the methods and add the methods to our template -->
<cfif len(controllerMethods)>
	<cfset methods = "">
	
	<cfloop list="#controllerMethods#" index="method">
		
		<cfset methods = methods & replaceNoCase(eventMethodContent,"[method]",method,"all") & chr(13) & chr(13)/>
		
		<!--- check to see if we are generating views --->
		<cfif inputStruct.GenerateViews>
			<cfif NOT directoryExists(viewsLocation)>
				<cfdirectory action="create" directory="#viewsLocation#" mode="777">
			</cfif>
			<cfif !method is 'init'>
				<cfset fileWrite(viewsLocation & "/" & method & ".cfm","<h1>#controllerName# #method#</h1>")>
			</cfif>
		</cfif>
		
	</cfloop>
	
	<cfset controllerContent = replaceNoCase(controllerContent,"[eventMethods]",methods,"all") />	
<cfelse>
	<cfset controllerContent = replaceNoCase(controllerContent,"[eventMethods]",'',"all") />
</cfif>

<cffile action="write" file="#controllerLocation#/#controllerName#.cfc" mode ="777" output="#controllerContent#">

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
	<dialog width="550" height="350" title="ColdBox Event Handler Wizard" image="includes/images/cfwheels.png"/>  
	<body><![CDATA[
	<html>
		<head>
			<base href="" />
			<link href="includes/css/styles.css" type="text/css" rel="stylesheet">
			<script type="text/javascript" src="includes/js/jquery.latest.min.js"></script>
		</head>
		<body>
			<div class="strong">Generated controller #controllerName#.cfc</div>
			<cfif inputStruct.generateViews>
				<!-- need to loop throught he methods and output the view file names here -->
				<p>
					Also built some views
				</p>
			</cfif>
		</body>
	</html>	
	]]></body>
</ide>
</response>
</cfoutput>