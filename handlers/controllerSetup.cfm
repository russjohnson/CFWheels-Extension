<cfheader name="Content-Type" value="text/xml">  
<cfoutput>  
<response status="success" type="default">  
	<ide handlerfile="scaffoldController.cfm"> 
		<dialog width="500" height="450" title="Scaffold New Controller" image="includes/images/ColdBox_Icon.png">  
			
			<input name="Name" required="true" label="Controller Name"  type="string" default="" 
				   tooltip="Enter the plural name of your Controller without .cfc"
				   helpmessage="Enter the plural name of your Controller without .cfc" />
				   
			<input name="Script" label="Script Based CFC" type="boolean" checked="false" tooltip="Choose whether to create the cfc in pure script or not." />
			
			<input name="Methods" label="Methods (comma delimmitted)" type="string" default="init" 
				   tooltip="Enter a list of methods to generate, should be separated by a comma"
				   helpmessage="Enter a list of methods to generate, should be separated by a comma"/>
			
			<input name="GenerateViews" label="Generate View(s)" type="boolean" 
				   helpmessage="Generate views for your methods"
				   tooltip="Generate views for your methods" />
		</dialog>
	</ide>
</response>  
</cfoutput>