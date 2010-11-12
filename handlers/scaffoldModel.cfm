<!-- GENERATES A NEW WHEELS MODEL IN THE MODELS FOLDER -->

<cfscript>
	modelLocation = data.event.ide.projectview.resource.xmlAttributes.path;
	modelName = inputStruct.name;
	modelMethods = inputStruct.methods;
</cfscript>

<!-- currently not planning to support the cf8 script style controllers -->
<cfif inputStruct.script>
	<cffile action="read" file="#ExpandPath('../')#/code/templates/model_script.cfm" variable="modelContent">
	<cffile action="read" file="#ExpandPath('../')#/code/templates/model_method_script.cfm" variable="methodContent">
<cfelse>
	<cffile action="read" file="#ExpandPath('../')#/code/templates/model.cfm" variable="modelContent">
	<cffile action="read" file="#ExpandPath('../')#/code/templates/model_method.cfm" variable="methodContent">
</cfif>

<!-- loop through the methods and add the methods to our template -->
<cfif len(modelMethods)>
	<cfset methods = "">
	
	<cfloop list="#modelMethods#" index="method">
		
		<cfset methods = methods & replaceNoCase(methodContent,"[method]",ltrim(method),"all") & chr(13) & chr(13)/>
		
	</cfloop>
	
	<cfset modelContent = replaceNoCase(modelContent,"[eventMethods]",methods,"all") />	
<cfelse>
	<cfset modelContent = replaceNoCase(modelContent,"[eventMethods]",'',"all") />
</cfif>

<cfif !request.utility.fileExists(modelName, "model", data.event.ide.projectview.xmlattributes.projectlocation)>
	<cffile action="write" file="#modelLocation#/#modelName#.cfc" mode ="777" output="#modelContent#">
	<cfset modelMessage = "Generated model named #modelName#.cfc">
<cfelse>
	<cfset modelMessage = "The model file already exists so it was not overwritten">
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
			    <param key="filename" value="#modelLocation#/#modelName#.cfc" />
			</params>
		</command>
	</commands>
	<dialog width="550" height="350" title="CFWheels Model Scaffold" image="includes/images/cfwheels-logo.png"/>  
	<body><![CDATA[
	<html>
		<head>
			<link href="<cfoutput>#request.extensionLocation#</cfoutput>/includes/css/styles.css" type="text/css" rel="stylesheet">
			<script type="text/javascript" src="includes/js/jquery.latest.min.js"></script>
		</head>
		<body>
			<p><cfoutput>#modelMessage#</cfoutput></p>
		</body>
	</html>	
	]]></body>
</ide>
</response>
</cfoutput>