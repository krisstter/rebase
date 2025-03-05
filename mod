Import-IISConfiguration -SourcePath "C:\handler_mappings.xml" -DestinationPath "MACHINE/WEBROOT/APPHOST"

Export-IISConfiguration -SourcePath "MACHINE/WEBROOT/APPHOST" -DestinationPath "C:\handler_mappings.xml"



Get-WebConfigurationProperty -Filter "/system.webServer/handlers/*" -Name . | ConvertTo-Json | Out-File C:\handler_mappings.json
$handlers = Get-Content C:\handler_mappings.json | ConvertFrom-Json

foreach ($handler in $handlers) {
    # Check if the handler already exists
    $existingHandler = Get-WebConfigurationProperty -Filter "/system.webServer/handlers/add[@name='$($handler.name)']" -Name name
    
    if ($existingHandler) {
        Write-Host "Handler '$($handler.name)' already exists. Skipping..."
    } else {
        Write-Host "Adding handler: $($handler.name)"
        New-WebHandler -Name $handler.name -Path $handler.path -Verb $handler.verb -Modules $handler.modules -ResourceType $handler.resourceType
    }
}
