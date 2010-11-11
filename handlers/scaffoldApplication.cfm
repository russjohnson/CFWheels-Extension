<cfif structKeyExists(data.event.ide,"projectview")>
	<cfset expandLocation	= data.event.ide.projectview.resource.xmlAttributes.path >
	<cfset projectname		= data.event.ide.projectview.xmlAttributes.projectname>
<cfelse>
	<cfset expandLocation	= data.event.ide.eventinfo.xmlAttributes.projectLocation >
	<cfset projectname		= data.event.ide.eventinfo.xmlAttributes.projectname >
</cfif>

<!--- get the zip file under the skeleton location directory. I ignore any but the first one --->
<cfdirectory action="list" directory="#expandPath('../code/skeleton')#" filter="*.zip" name="appSkeletonZip" />

<!--- Unzip it --->
<cfif appSkeletonZip.recordCount>
	<cfzip action="unzip" destination="#expandLocation#" file="#appSkeletonZip.directory#/#appSkeletonZip.name#" storePath="true" recurse="yes" />
	<cfset message = listFirst(appSkeletonsZip.name,".") & " application skeleton succesfully generated!" />
<cfelse>
	<cfset message = "No zip file was found in that directory." />
</cfif>

<cfheader name="Content-Type" value="text/xml">  
<cfoutput>
<response status="success" showresponse="true">  
<ide> 
	<commands>
		<command type="refreshfolder" />
		<command type="refreshproject">
			<params>
			    <param key="projectname" value="#projectname#" />
			</params>
		</command>
		<!--<command type="openfile">
			<params>
				<cfif fileExists(expandLocation & "/config/Coldbox.cfc")>
					<param key="filename" value="#expandLocation#/config/Coldbox.cfc" />
				<cfelseif fileExists(expandLocation & "/config/coldbox.xml.cfm")>
					<param key="filename" value="#expandLocation#/config/coldbox.xml.cfm" />
				</cfif>
			</params>
		</command>-->
	</commands>
	<dialog width="600" height="250" title="CFWheels Application Scaffold" image="includes/images/coldbox-logo.png"/>  
	<body><![CDATA[
	<html>
		<head>
			<base href="#request.baseURL#" />
			<link href="includes/css/styles.css" type="text/css" rel="stylesheet">
			<script type="text/javascript" src="includes/js/jquery.latest.min.js"></script>
		</head>
		<body>
			<div class="messagebox-green">#message#</div>
		</body>
	</html>	
	]]></body>
</ide>
</response>
</cfoutput>

