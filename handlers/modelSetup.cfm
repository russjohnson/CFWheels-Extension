<cfheader name="Content-Type" value="text/xml">  
<cfoutput>  
<response status="success" type="default">  
	<ide handlerfile="scaffoldModel.cfm"> 
		<dialog width="500" height="450" title="Scaffold New Model" image="includes/images/cfwheels-logo.png">  
			
			<input name="Name" required="true" label="Model Name"  type="string" default="" 
				   tooltip="Enter the singular name of your Model without .cfc"
				   helpmessage="Enter the singular name of your Model without .cfc. By conventions, this should be a singular version of the table name for the model." />
				   
			<input name="Script" label="Script Based CFC" type="boolean" checked="false" tooltip="Choose whether to create the cfc in pure script or not." />
			
			<input name="Methods" label="Methods (comma delimmitted)" type="string" default="init" 
				   tooltip="Enter a list of methods to generate, should be separated by a comma"
				   helpmessage="Enter a list of methods to generate, should be separated by a comma"/>
			
		</dialog>
	</ide>
</response>  
</cfoutput>