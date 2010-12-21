<cfscript>

	fileInfo = data.event.ide.editor.file.xmlAttributes;
	currentFile = fileInfo.location;
	projectLocation = data.event.ide.editor.file.xmlAttributes.projectLocation & "/";
	relativeLocation = replaceNoCase(fileInfo.projectRelativeLocation,fileInfo.name,"","all");
	
	selectedText = data.event.ide.editor.selection.text.xmlText;
	
	// todo - need to parse the selected text to see if it contains any path info
	partialName = "_" & selectedText & ".cfm";
	
	response = "";
</cfscript>

<cfdump var="#projectLocation# #relativeLocation# #partialName#" abort="true" >

<cfif fileExists(projectLocation & relativeLocation & partialName)>
	
	<cfheader name="Content-Type" value="text/xml">  
	<cfoutput>
	<response status="success" showresponse="false">  
	<ide>  
		<commands>
			<command type="openfile">
				<params>
				    <param key="filename" value="#projectLocation##relativeLocation##partialName#" />
				</params>
			</command>
		</commands>
	</ide>
	</response>
	</cfoutput>
	
	
<cfelse>

	<cfheader name="Content-Type" value="text/xml">  
	<cfoutput>
	<response status="error" showresponse="true">  
	<ide>  
		<dialog width="550" height="450" title="Open Partial Failed" image="includes/images/cfwheels-logo.png"/>  
		<body><![CDATA[
		<html>
			<head>
				<base href="" />
				<link href="<cfoutput>#request.extensionLocation#</cfoutput>/includes/css/styles.css" type="text/css" rel="stylesheet">
				<script type="text/javascript" src="includes/js/jquery.latest.min.js"></script>
			</head>
			<body>
				<p><strong>The partial you are trying to open doesnt exist. Make sure you selected the path and the partial name.</strong></p>
			</body>
		</html>	
		]]></body>
	</ide>
	</response>
	</cfoutput>
	
</cfif>