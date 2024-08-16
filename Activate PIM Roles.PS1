Connect-MgGraph -Scopes "RoleManagement.ReadWrite.Directory"
# Define the parameters
$principalId = "1234666" #your azure accounts objectID
$roleDefinitionIds = @(
    "fe930be7-5e62-47db-91af-98c3a49a38b1",
    "729827e3-9c14-49f7-bb1b-9608f156bbb8",
    "29232cdf-9323-42fd-ade2-1d097af3e4de",
    "f28a1f50-f6e7-4571-818b-6a12f2af6b6c",
    "c4e39bd9-1100-46d3-8c65-fb160da0071f",
    "baf37b3a-610e-45da-9e62-d9d1e5e8914b",
    "5f2222b1-57c3-48ba-8ad5-d4759f1fde6f",
    "f2ef992c-3afb-46b9-b7cf-a126ee74c451",
    "fdd7a751-b60b-444a-984c-02652fe8fa1c"
) #the roles you are eligible for can be extracted from the microsoft link below
$justification = "SNOW"
$directoryScopeId = "/"
$action = "SelfActivate"
$startDateTime = Get-Date
$duration = "PT4H"
# Define TicketInfo
$ticketInfo = @{
    TicketNumber = "SR1111"
    TicketSystem = "ServiceNow"
}
# Iterate over each RoleDefinitionId and create the schedule request
foreach ($roleDefinitionId in $roleDefinitionIds) {
    $params = @{
        "PrincipalId" = $principalId
        "RoleDefinitionId" = $roleDefinitionId
        "Justification" = $justification
        "DirectoryScopeId" = $directoryScopeId
        "Action" = $action
        "ScheduleInfo" = @{
            "StartDateTime" = $startDateTime
            "Expiration" = @{
                "Type" = "AfterDuration"
                "Duration" = $duration
            }
        }
        "TicketInfo" = $ticketInfo  # Add the ticket info to the parameters
    }
    
    try {
        $response = New-MgRoleManagementDirectoryRoleAssignmentScheduleRequest -BodyParameter $params
        
        # Display response details including any available fields
        $response | Format-List Id, Status, Action, AppScopeId, DirectoryScopeId, RoleDefinitionId, IsValidationOnly, Justification, PrincipalId, CompletedDateTime, CreatedDateTime, TargetScheduleId, TicketInfo
        
    } catch {
        Write-Error "Failed to assign role ${roleDefinitionId}: $($_.Exception.Message)"
    }
}

#This below command gives eligible role IDs
#Get-MgRoleManagementDirectoryRoleEligibilityScheduleInstance -Filter "principalId eq '*'"  | Format-List 
#https://learn.microsoft.com/en-us/entra/identity/role-based-access-control/permissions-reference
#Principal username: *
#User Object ID or principal id: *
#Tenant ID: *
