codeunit 50038 "Subscribe VersionManagement"
{
    [EventSubscriber(ObjectType::Codeunit, Codeunit::VersionManagement, OnBeforeGetBOMVersion, '', false, false)]
    local procedure VersionManagement_OnBeforeGetBOMVersion(BOMHeaderNo: Code[20]; Date: Date; OnlyCertified: Boolean; var VersionCode: Code[20]; var IsHandled: Boolean)
    begin
        VersionCode := '';
        IsHandled := true;
    end;

    var
        myInt: Integer;
}