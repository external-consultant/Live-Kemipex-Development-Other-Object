codeunit 50041 "Rep 6620 Copy Doc. Mgt."
{
    //T12540-NS
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Copy Document Mgt.", OnAfterCopySalesHeader, '', false, false)]
    local procedure "Copy Document Mgt._OnCopySalesDoc"(FromSalesHeader: Record "Sales Header"; var ToSalesHeader: Record "Sales Header")
    var
    begin
        ToSalesHeader."Vehicle No." := FromSalesHeader."Vehicle No.";
        ToSalesHeader."Container Code" := FromSalesHeader."Container Code";
        ToSalesHeader."Container Plat No." := FromSalesHeader."Container Plat No.";
        ToSalesHeader."Container Seal No." := FromSalesHeader."Container Seal No.";
        ToSalesHeader."Transaction Specification" := FromSalesHeader."Transaction Specification";
        ToSalesHeader."Transaction Type" := FromSalesHeader."Transaction Type";
        ToSalesHeader."Transport Method" := FromSalesHeader."Transport Method";
        ToSalesHeader."Exit Point" := FromSalesHeader."Exit Point";
        ToSalesHeader."Area" := FromSalesHeader."Area";
    end;
    //T12540-NE

}