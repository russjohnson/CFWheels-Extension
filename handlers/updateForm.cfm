<cfheader name="Content-Type" value="text/xml">
<cfoutput>
<response status="success" type="default">
  <ide handlerfile="updateForm.cfm">
     <dialog width="400" height="275" title="Update Available" image="includes/images/cfwheels-logo.png">
        <input name="A new version is available. Update?" Label="A new version is available. Update? " type="list" tooltip="There is an update available for the CFWheels Extension. Select YES below to automatically update your copy of the extension." helpmessage="There is an update available for the CFWheels Extension. Select YES below to automatically update your copy of the extension.">
           <option value="Yes" />
           <option value="No" />
        </input>               
     </dialog>
  </ide>
</response>
</cfoutput>
<cfabort />