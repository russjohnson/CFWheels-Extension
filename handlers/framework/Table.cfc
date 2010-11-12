<cfcomponent hint="Represents a table from rds view" output="false">
	<cfproperty name="name" hint="Name of the table" type="any" />
	<cfproperty name="primaryKey" hint="Primary key of the table" type="any" />
	<cfproperty name="columns" hint="Array of columns and data" type="array" default="arrayNew()" />
	
	<cffunction name="init" access="public" output="false" returntype="any">
		<cfreturn this>
	</cffunction>

	<cffunction name="getName" access="public" output="false" returntype="any">
		<cfreturn name>
		
	</cffunction>

	<cffunction name="setName" access="public" output="false" returntype="void">
		<cfargument name="argName" type="any">
		<cfset name=argName/>
		
	</cffunction>

	<cffunction name="getPrimaryKey" access="public" output="false" returntype="any">
		<cfreturn primaryKey>
		
	</cffunction>

	<cffunction name="setPrimaryKey" access="public" output="false" returntype="void">
		<cfargument name="argPrimaryKey" type="any">
		<cfset primaryKey=argPrimaryKey/>
		
	</cffunction>

	<cffunction name="getColumns" access="public" output="false" returntype="array">
		<cfreturn columns>
		
	</cffunction>

	<cffunction name="setColumns" access="public" output="false" returntype="void">
		<cfargument name="argColumns" type="array">
		<cfset columns=argColumns/>
		
	</cffunction>

</cfcomponent>