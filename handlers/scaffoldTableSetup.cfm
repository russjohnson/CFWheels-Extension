<cfheader name="Content-Type" value="text/xml">  
<cfoutput>  
<response status="success" type="default">  
	<ide handlerfile="scaffoldTable.cfm"> 
		<dialog width="500" height="450" title="Scaffold Table" image="includes/images/cfwheels-logo.png">  
				   
			<input name="Script" 
				   label="Script Based CFC" 
				   type="boolean" 
				   checked="false" 
				   tooltip="Choose whether to create the cfc in pure script or not."  
				   helpmessage="You must be running ColdFusion 9 in order to use the pure script files."/>
			
		</dialog>
	</ide>
</response>  
</cfoutput>