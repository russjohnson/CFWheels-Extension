<!--- sample handler --->
<cfparam name="ideeventinfo" default="">
 
<cfset xmldoc = xmlParse(ideeventinfo)>
<cfset projectview = xmlSearch(xmldoc,"//projectview")>
<cfset response = xmlSearch(xmldoc,"//user")>

<cfset system = createObject("java", "java.lang.System")>
<cfset fileSeparator = system.getProperty("file.separator")>

<!--- project details --->
<cfset project = structNew()>
<cfset project.name = projectview[1].xmlAttributes["projectname"]>
<cfset project.location = projectview[1].xmlAttributes["projectlocation"]>

<!--- user input --->
<cfset user = structNew()>
<cfset user.firstname = response[1].xmlChildren[1].xmlattributes.value>
<cfset user.lastname = response[1].xmlChildren[2].xmlattributes.value>

<cfheader name="Content-Type" value="text/xml">  
<response status="success" showresponse="true">  
<ide>  
<dialog width="550" height="350" />  
<body>
<![CDATA[<p style="font-size:12px;">
You are done!
</p>]]>
</body>
</ide>
</response>
