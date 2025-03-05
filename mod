Import-IISConfiguration -SourcePath "C:\handler_mappings.xml" -DestinationPath "MACHINE/WEBROOT/APPHOST"

Export-IISConfiguration -SourcePath "MACHINE/WEBROOT/APPHOST" -DestinationPath "C:\handler_mappings.xml"
