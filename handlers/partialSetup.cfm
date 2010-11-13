<cfset viewPath = data.event.ide.editor.file.xmlAttributes.projectLocation & "/views/">

<cfheader name="Content-Type" value="text/xml">  
<cfoutput>  
<response status="success" type="default">  
	<ide handlerfile="createPartial.cfm"> 
		<dialog width="500" height="450" title="Create Partial From Selection" image="includes/images/cfwheels-logo.png">  
			
			<input name="Name" required="true" label="Partial Name"  type="string" default="" 
				   tooltip="Enter the name of the partial you wish to create."
				   helpmessage="Enter the name of the partial you want to create from the selected text. Don't worry about the underscore(_) or the file type (.cfm)." />
			
			<!--<input name="savePath" label="Path" type="string" default="" 
				   tooltip="Enter or select the folder you want to save the partial in."
				   helpmessage="Enter or select the folder where you want to save the created partial. This is relative to your Views folder."/>-->
			
		</dialog>
	</ide>
</response>  
</cfoutput>