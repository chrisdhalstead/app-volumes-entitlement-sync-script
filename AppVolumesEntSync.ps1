Version 1.0
#***********************************************

$Credentials = @{
    username = 'domain\username'
    password = 'password'
}

$SourceServer = "SourceServerFQDN"
$TargetServer = "DestinationServerFQDN"

Invoke-RestMethod -SessionVariable SourceServerSession -Method Post -Uri "https://$SourceServer/cv_api/sessions" -Body $Credentials 
Invoke-RestMethod -SessionVariable TargetServerSession -Method Post -Uri "https://$TargetServer/cv_api/sessions" -Body $Credentials 


$SourceAssignments = (Invoke-RestMethod -WebSession $SourceServerSession -Method Get -Uri "https://$SourceServer/cv_api/assignments").assignments

$SourceAppstacks = Invoke-RestMethod -WebSession $SourceServerSession -Method Get -Uri "https://$SourceServer/cv_api/appstacks"
$TargetAppStacks = Invoke-RestMethod -WebSession $TargetServerSession -Method Get -Uri "https://$TargetServer/cv_api/appstacks"

foreach ($Assignment in $SourceAssignments)
{
    $SourceAppStack = $SourceAppStacks.Where({$_.id -eq $assignment.snapvol_id})[0]    
    $TargetAppStack = $TargetAppStacks.Where({$_.name -eq $SourceAppstack.name})[0]   
    Invoke-RestMethod  -WebSession $TargetServerSession -Method Post -Uri "https://$TargetServer/cv_api/assignments?action_type=assign&id=$($TargetAppStack.id)&assignments%5B0%5D%5Bentity_type%5D=$($assignment.entityt)&assignments%5B0%5D%5Bpath%5D=$($assignment.entity_dn)"
    
}