codeunit 50002 "Subscriber 36 Sales Header"
{
    //T12068-NS

    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnAfterValidateEvent', 'Salesperson Code', false, false)]
    local procedure SalesPersonCode_OnAfterValidateEvent(var Rec: Record "Sales Header"; var xRec: Record "Sales Header")
    var
        SalesLine_lRec: Record "Sales Line";
    begin
        SalesLine_lRec.Reset();
        SalesLine_lRec.SetRange("Document Type", Rec."Document Type");
        SalesLine_lRec.SetRange("Document No.", Rec."No.");
        if SalesLine_lRec.FindSet() then
            repeat
                SalesLine_lRec."SalesPerson Code" := Rec."Salesperson Code";
                SalesLine_lRec.Modify();
            until SalesLine_lRec.Next() = 0;
    end;
    //T12068-NE

    //T12539-NS
    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnAfterValidateEvent', 'Status', false, false)]
    local procedure Status_OnAfterValidateEvent(var Rec: Record "Sales Header"; var xRec: Record "Sales Header")
    var
        MultiplePmtTerms_lRec: Record "Multiple Payment Terms";
    begin
        If Rec.Status = Rec.Status::Released then begin
            MultiplePmtTerms_lRec.Reset();
            MultiplePmtTerms_lRec.SetRange(Type, MultiplePmtTerms_lRec.Type::Sales);
            MultiplePmtTerms_lRec.SetRange("Document No.", Rec."No.");
            MultiplePmtTerms_lRec.SetRange("Document Type", Rec."Document Type");
            If MultiplePmtTerms_lRec.FindSet() then
                repeat
                    MultiplePmtTerms_lRec.Released := true;
                    MultiplePmtTerms_lRec.Modify();
                until MultiplePmtTerms_lRec.Next() = 0;
        end;
    end;
    //T12539-NE

    //T12539-NS
    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnAfterDeleteEvent', '', false, false)]
    local procedure SalesHeader_OnAfterDeletEvent(var Rec: Record "Sales Header")
    var
        MultiplePmtTerms_lRec: Record "Multiple Payment Terms";
    begin
        If Rec.IsTemporary then
            exit;

        MultiplePmtTerms_lRec.Reset();
        MultiplePmtTerms_lRec.SetRange(Type, MultiplePmtTerms_lRec.Type::Sales);
        MultiplePmtTerms_lRec.SetRange("Document No.", Rec."No.");
        MultiplePmtTerms_lRec.SetRange("Document Type", Rec."Document Type");
        If MultiplePmtTerms_lRec.FindSet() then
            repeat
                MultiplePmtTerms_lRec.DeleteAll(true);
            until MultiplePmtTerms_lRec.Next() = 0;
    end;
    //T12539-NE
    //T12937-NS
    [EventSubscriber(ObjectType::Table, Database::"Sales Header", OnAfterInitRecord, '', false, false)]
    local procedure "Sales Header_OnAfterInitRecord"(var Sender: Record "Sales Header"; var SalesHeader: Record "Sales Header")
    begin
        if (SalesHeader."Document Type" in [SalesHeader."Document Type"::"Blanket Order"]) and
           (SalesHeader."Posting Date" = 0D)
        then
            SalesHeader."Posting Date" := WorkDate();
    end;
    //T12937-NE

}