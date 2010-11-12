<cfheader name="Content-Type" value="text/xml">  
<cfoutput>  
<response status="success" type="default">  
	<ide handlerfile="scaffoldTable.cfm"> 
		<dialog width="500" height="450" title="Scaffold Table" image="includes/images/cfwheels-logo.png">
		
			<input name="projectRoot" 
				   label="Project Root" 
				   tooltip="Select the root of your CFWheels project" 
				   type="projectdir" 
				   required="true"
				   helpmessage="Select the root of your CFWheels project. We use this to determine where to save the scaffolded files."/>
		
			<input name="scaffoldType"
				   label="Elements to Scaffold"
				   type="list"
				   required="true"
				   default="Everything"
				   tooltip="Select which elements you would like to scaffold"
				   helpmessage="You can choose to scaffold a combination of elements from a table based on conventions">
				   		<option value="Everything"/>
				   		<option value="Model Only"/>
				   		<option value="Controller Only"/>
			</input>
				    
				   
			<input name="Script" 
				   label="Script Based CFC's" 
				   type="boolean" 
				   checked="false" 
				   tooltip="Choose whether to create the CFC's in pure script or not."  
				   helpmessage="You must be running ColdFusion 9 in order to use the pure script files."/>
			
		</dialog>
	</ide>
</response>  
</cfoutput>