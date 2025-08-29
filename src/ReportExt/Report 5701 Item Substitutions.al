//T12114-NS
reportextension 50000 "Report 5701 Item Sub" extends "Item Substitutions"
{
    dataset
    {
        // Add changes to dataitems and columns here

    }

    requestpage
    {
        // Add changes to the requestpage here
    }

    trigger OnPreReport()
    var
        UserSetup_lRec: Record "User Setup";
    begin
        if UserSetup_lRec.Get(UserId) then
            if not UserSetup_lRec."Allow to view Item Sub" then
                Error('User with UserID= %1  are not allowed to access this Report. Kindly contact to Administrator', UserId);
    end;
}
//T12114-NE