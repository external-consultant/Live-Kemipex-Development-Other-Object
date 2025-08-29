codeunit 50009 "Item Substitution Restriction"
{
    trigger OnRun()
    begin

    end;
    //T12114-NS
    [EventSubscriber(ObjectType::Page, Page::"Item Substitution Entries", 'OnOpenPageEvent', '', false, false)]
    local procedure "Item Substitution Entries_OnOpenPageEvent"(var Rec: Record "Item Substitution")
    var
        UserSetup_lRec: Record "User Setup";
    begin
        if UserSetup_lRec.Get(UserId) then
            if not UserSetup_lRec."Allow to view Item Sub" then
                Error('User with UserID= %1 is not allowed to access this page. Kindly contact to Administrator', UserId);
    end;

    [EventSubscriber(ObjectType::Page, Page::"Item Substitution Entry", 'OnOpenPageEvent', '', false, false)]
    local procedure "Item Substitution Entry_OnOpenPageEvent"(var Rec: Record "Item Substitution")
    var
        UserSetup_lRec: Record "User Setup";
    begin
        if UserSetup_lRec.Get(UserId) then
            if not UserSetup_lRec."Allow to view Item Sub" then
                Error('User with UserID= %1 is not allowed to access this page. Kindly contact to Administrator', UserId);
    end;

    [EventSubscriber(ObjectType::Page, Page::"Item Substitutions", 'OnOpenPageEvent', '', false, false)]
    local procedure "Item Substitutions_OnOpenPageEvent"(var Rec: Record "Item Substitution")
    var
        UserSetup_lRec: Record "User Setup";
    begin
        if UserSetup_lRec.Get(UserId) then
            if not UserSetup_lRec."Allow to view Item Sub" then
                Error('User with UserID= %1 is not allowed to access this page. Kindly contact to Administrator', UserId);
    end;
    //T12114-NE
}