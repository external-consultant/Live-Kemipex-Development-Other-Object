codeunit 50028 "Update First Approval"
{
    trigger OnRun()
    begin

    end;
    //T12141-NS
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Release Sales Document", OnAfterPerformManualCheckAndRelease, '', false, false)]
    local procedure "Release Sales Document_OnAfterPerformManualCheckAndRelease"(var SalesHeader: Record "Sales Header"; PreviewMode: Boolean)
    begin
        Clear(SalesHeader."Workflow Category Type");

        if not SalesHeader."First Approval Completed" then
            SalesHeader."First Approval Completed" := true;
        SalesHeader.Modify();
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Release Purchase Document", OnAfterPerformManualCheckAndRelease, '', false, false)]
    local procedure "Release Purchase Document_OnAfterPerformManualCheckAndRelease"(var PurchaseHeader: Record "Purchase Header")
    begin
        Clear(PurchaseHeader."Workflow Category Type");

        if not PurchaseHeader."First Approval Completed" then
            PurchaseHeader."First Approval Completed" := true;
        PurchaseHeader.Modify();
    end;

    //T12141-NE

}