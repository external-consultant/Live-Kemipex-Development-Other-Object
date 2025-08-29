codeunit 50049 Page_300_Sub
{
    //T13872-NS
    [EventSubscriber(ObjectType::Page, Page::"Ship-to Address", OnBeforeOnNewRecord, '', false, false)]
    local procedure "Ship-to Address_OnBeforeOnNewRecord"(var Customer: Record Customer; var IsHandled: Boolean; var ShipToAddress: Record "Ship-to Address")
    begin
        IsHandled := true;
    end;
    //T13872-NE
}