<cfheader name="Content-Type" value="text/xml">
<response status="success" showresponse="true">
	<ide>
		<dialog width="550" height="350" title="Update Available" image="includes/images/cfwheels-logo.png"/>
			<body><![CDATA[
		<html>
			<head>
				<link href="includes/css/styles.css" type="text/css" rel="stylesheet">
				<script type="text/javascript" src="includes/js/jquery.latest.min.js"></script>
			</head>
			<body>
				<div>Update downloaded and installed. Close this window and run the plugin again.</div>
			</body>
		</html>	
		]]></body>
	</ide>
</response>
<cfabort>