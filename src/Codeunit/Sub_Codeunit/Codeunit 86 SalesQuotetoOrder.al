//T12068-NS
codeunit 50000 "Subscriber CU 86"
{
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Quote to Order", 'OnBeforeOnRun', '', false, false)]
    local procedure "Sales-Quote to Order_OnBeforeOnRun"(var SalesHeader: Record "Sales Header")
    var
        DocAtt_lRec: Record "Document Attachment";
    begin
        DocAtt_lRec.Reset();
        DocAtt_lRec.SetRange("Table ID", Database::"Sales Header");
        DocAtt_lRec.SetRange("Document Type", SalesHeader."Document Type");
        DocAtt_lRec.SetRange("No.", SalesHeader."No.");
        if not DocAtt_lRec.FindFirst() then
            If Confirm('Document is not attached, Do you still want to proceed?') then
                exit
            else
                Error('Kindly attach the attachment to the Sales Quote %1', SalesHeader."No.");
    end;


}
//T12068-NE