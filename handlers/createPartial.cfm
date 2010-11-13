<cfscript>

	fileInfo = data.event.ide.editor.file.xmlAttributes;
	currentFile = fileInfo.location;
	projectLocation = data.event.ide.editor.file.xmlAttributes.projectLocation & "/";
	relativeLocation = replaceNoCase(fileInfo.projectRelativeLocation,fileInfo.name,"","all");

	selectedText = data.event.ide.editor.selection.text.xmlText;
	// a struct to hold the coords of anything selected
	selectedCoordinates = data.event.ide.editor.selection.xmlAttributes;
	
	partialName = "_" & inputStruct.name & ".cfm";
	
	response = "";
</cfscript>

<!--- first lets create the partial and save it --->
<cfif fileExists(projectLocation & relativeLocation & partialName)>
	<cfset response = "The partial file you are attempting to create already exists so it was skipped">
<cfelse>
	<cffile action="write" file="#projectLocation##relativeLocation##partialName#" mode="777" output="#selectedText#">
	<cfset response = "Created the partial #relativeLocation##partialName#">
	
	<!--- now removed the selected code and add the includePartial call --->
	
	<!---<cffile action="read" file="#currentFile#" variable="fileData">
	<cfset currentLine = 1>
	<cfloop file="#fileData#" index="line">
		
		<cfset currentLine = currentLine + 1>
	</cfloop>--->
	
</cfif>



<cfheader name="Content-Type" value="text/xml">  
<cfoutput>
<response status="success" showresponse="true">  
<ide>  
	<commands>
		<command type="RefreshProject">
			<params>
			    <param key="projectname" value="#data.event.ide.editor.file.xmlAttributes.project#" />
			</params>
		</command>
		<command type="openfile">
			<params>
			    <param key="filename" value="#projectLocation##relativeLocation##partialName#" />
			</params>
		</command>
	</commands>
	<dialog width="550" height="450" title="CFWheels Create Partial" image="includes/images/cfwheels-logo.png"/>  
	<body><![CDATA[
	<html>
		<head>
			<base href="" />
			<link href="<cfoutput>#request.extensionLocation#</cfoutput>/includes/css/styles.css" type="text/css" rel="stylesheet">
			<script type="text/javascript" src="includes/js/jquery.latest.min.js"></script>
		</head>
		<body>
			<p><strong><cfoutput>#response#</cfoutput></strong></p>
		</body>
	</html>	
	]]></body>
</ide>
</response>
</cfoutput>