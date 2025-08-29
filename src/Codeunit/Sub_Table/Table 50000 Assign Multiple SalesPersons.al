//T12068-NS
codeunit 50004 "Sub 50000 AssignMultiple"
{
    [EventSubscriber(ObjectType::Table, Database::"Assign Multiple SalesPersons", 'OnAfterInsertEvent', '', false, false)]
    local procedure "Assign Multiple SalesPersons_OnAfterInsertEvent"(var Rec: Record "Assign Multiple SalesPersons")
    var

    begin
        if Rec.IsTemporary then
            exit;
        UpdateSalesPerson(Rec);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Assign Multiple SalesPersons", 'OnAfterModifyEvent', '', false, false)]
    local procedure "Assign Multiple SalesPersons_OnAfterModifyEvent"(var Rec: Record "Assign Multiple SalesPersons")
    var

    begin
        if Rec.IsTemporary then
            exit;
        UpdateSalesPerson(Rec);
    end;

    procedure UpdateSalesPerson(MultipleSalesPersons: Record "Assign Multiple SalesPersons")
    var
        CustRec_lRec: Record Customer;
        LoopMultipleSalesPersons_lRec: Record "Assign Multiple SalesPersons";
    begin
        CustRec_lRec.Get(MultipleSalesPersons."Customer No.");
        CustRec_lRec."Associated SalesPerson" := '';

        LoopMultipleSalesPersons_lRec.Reset();
        LoopMultipleSalesPersons_lRec.SetRange("Customer No.", MultipleSalesPersons."Customer No.");
        IF LoopMultipleSalesPersons_lRec.FindSet() Then begin
            repeat
                if CustRec_lRec."Associated SalesPerson" = '' then
                    CustRec_lRec."Associated SalesPerson" := LoopMultipleSalesPersons_lRec."SalesPerson Code"
                else
                    CustRec_lRec."Associated SalesPerson" += '|' + LoopMultipleSalesPersons_lRec."SalesPerson Code";
            Until LoopMultipleSalesPersons_lRec.Next() = 0;
        end;

        CustRec_lRec.Modify();
    end;

}
//T12068-NE