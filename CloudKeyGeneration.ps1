<#
Script to generate a cloud key from the lambda function dgex-util-runElementExport_<envname>
Requires an OrganizationID, HardwareID, and environment suffix.
Outputs a nifty cloud_key, which can also be viewed in the dgex.DspRegistration_<environment> DynamoDB table. 
#>
Set-AWSCredentials -ProfileName boa-prod
$region = "us-east-1"
#$function =  "arn:aws:lambda:us-east-1:210560287685:function:dgex-util-registerDsp_boaprodtest"#legacy
#$function =  "arn:aws:lambda:us-east-1:210560287685:function:dgex-util-registerDsp_boaprod"#legacy
#$function =  "arn:aws:lambda:us-east-1:576608032189:function:dgex-util-registerDsp_qaprod"
$function =  "arn:aws:lambda:us-east-1:210560287685:function:igcprod-dgexUtilRegisterDsp"
$payload = @'
            {
                    "stackSuffix": "_igcdataprodtest",
                     "hardwareId": "HlMIYm6FSVZtag8CrO3wGO3y6bg3d",
                     "organizationId": "FirstLookInc"
            }
'@

$FunctionResponse = Invoke-LMFunction -FunctionName $function -Payload $payload -InvocationType RequestResponse -LogType Tail -Region $region

([System.Text.Encoding]::ASCII).GetString($FunctionResponse.Payload.ToArray()) |ConvertFrom-JSon | select -expandproperty Item 

([System.Text.Encoding]::ASCII).GetString($FunctionResponse.Payload.ToArray()) |ConvertFrom-JSon | select -expandproperty Item | select -ExpandProperty cloud_key | clip

Write-Host "cloud-key copied to clipboard." 


#extracting errors from the response (otherwise not needed) 
#Invoke-LMFunction doesn't throw an error per se, just get a different object type back 
<#
$base64encoded = Invoke-LMFunction -FunctionName $function -Payload $payload -InvocationType RequestResponse -LogType Tail -Region $region | select -ExpandProperty LogResult
[System.Text.Encoding]::UTF8.GetString(([System.Convert]::FromBase64String($base64encoded))) 
#>