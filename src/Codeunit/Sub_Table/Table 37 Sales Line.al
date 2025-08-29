
codeunit 50001 "Subscriber 37 Sales Line"
{
    //T12068-NS
    [EventSubscriber(ObjectType::Table, Database::"Sales Line", OnValidateNoOnCopyFromTempSalesLine, '', false, false)]
    local procedure "Sales Line_OnValidateNoOnCopyFromTempSalesLine"(var SalesLine: Record "Sales Line"; var TempSalesLine: Record "Sales Line" temporary; xSalesLine: Record "Sales Line"; CurrentFieldNo: Integer)
    begin
        // SalesLine.BDM := TempSalesLine.BDM;     //T13399-O
        SalesLine."SalesPerson Code" := TempSalesLine."SalesPerson Code";
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Line", OnValidateTypeOnCopyFromTempSalesLine, '', false, false)]
    local procedure "Sales Line_OnValidateTypeOnCopyFromTempSalesLine"(var SalesLine: Record "Sales Line"; var TempSalesLine: Record "Sales Line" temporary)
    begin
        // SalesLine.BDM := TempSalesLine.BDM;     //T13399-O
        SalesLine."SalesPerson Code" := TempSalesLine."SalesPerson Code";
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Line", OnAfterAssignFieldsForNo, '', false, false)]
    local procedure "Sales Line_OnAfterAssignFieldsForNo"(var SalesLine: Record "Sales Line"; var xSalesLine: Record "Sales Line"; SalesHeader: Record "Sales Header")
    begin
        // SalesLine.BDM := SalesHeader.BDM;     //T13399-O
        SalesLine."SalesPerson Code" := SalesHeader."Salesperson Code";
    end;
    //T12068-NE



    /* [EventSubscriber(ObjectType::Table, Database::"Sales Line", OnBeforeUpdateUnitPrice, '', false, false)]
    local procedure "Sales Line_OnBeforeUpdateUnitPrice"(var SalesLine: Record "Sales Line"; xSalesLine: Record "Sales Line"; CalledByFieldNo: Integer; CurrFieldNo: Integer; var Handled: Boolean)
    var
        Cust_lRec: Record Customer;
    begin
        Handled := GetSalesPrice(SalesLine);
        if not Handled then begin
            Cust_lRec.Reset();
            IF Cust_lRec.GET(SalesLine."Sell-to Customer No.") then begin
                If Cust_lRec."IC Partner Code" <> '' then
                    Message('Inter-Company Transfer Price is not defined for the given combination.');
            end;
        end;
    end; */ //Hypercare 31-01-2025

    //T12141-NS
    procedure GetSalesPrice(Var SalesLine_iRec: Record "Sales Line"): Boolean
    var
        Cust_lRec: Record Customer;
        SalesHdr_lRec: Record "Sales Header";
        TransPriceLt_Rec: Record "Transfer Price List";
        Item_lRec: Record Item;
        CurrencyFactor_lDec: Decimal;
    begin
        If SalesLine_iRec.Type <> SalesLine_iRec.Type::Item then
            exit;
        if SalesLine_iRec."No." = '' then
            Exit;
        If SalesLine_iRec."Unit of Measure Code" = '' then
            exit;

        CurrencyFactor_lDec := 0;
        Cust_lRec.Reset();
        If Cust_lRec.GET(SalesLine_iRec."Sell-to Customer No.") then
            If Cust_lRec."IC Partner Code" <> '' then begin
                SalesHdr_lRec.Reset();
                SalesHdr_lRec.SetRange("Document Type", SalesLine_iRec."Document Type");
                SalesHdr_lRec.SetRange("No.", SalesLine_iRec."Document No.");
                If SalesHdr_lRec.FindFirst() then begin

                    if SalesHdr_lRec."Currency Code" = '' then
                        CurrencyFactor_lDec := 1
                    else
                        CurrencyFactor_lDec := SalesHdr_lRec."Currency Factor";

                    TransPriceLt_Rec.Reset();
                    TransPriceLt_Rec.SetRange("Type Of Transaction", TransPriceLt_Rec."Type Of Transaction"::Sales);
                    TransPriceLt_Rec.SetRange("IC Partner Code", Cust_lRec."IC Partner Code");
                    TransPriceLt_Rec.SetRange("Item No.", SalesLine_iRec."No.");
                    TransPriceLt_Rec.SetRange("Variant Code", SalesLine_iRec."Variant Code");
                    TransPriceLt_Rec.SetRange("Unit of Measure", SalesLine_iRec."Unit of Measure Code");
                    TransPriceLt_Rec.SetRange("Currency Code", SalesHdr_lRec."Currency Code");
                    TransPriceLt_Rec.SetFilter("Starting Date", '<=%1', SalesHdr_lRec."Order Date");
                    TransPriceLt_Rec.SetFilter("Ending Date", '>=%1', SalesHdr_lRec."Order Date");
                    If TransPriceLt_Rec.FindFirst() then begin

                        IF (TransPriceLt_Rec.Price = 0) and (TransPriceLt_Rec."Margin %" = 0) then
                            Error('Either Margin % or Price should have value for Customer No. %1', SalesLine_iRec."Sell-to Customer No.");
                        If TransPriceLt_Rec.Price <> 0 then begin
                            SalesLine_iRec.Validate("Unit Price", TransPriceLt_Rec.Price);
                            Exit(True);
                        end;


                        If TransPriceLt_Rec."Margin %" <> 0 then begin
                            Item_lRec.Reset();
                            IF Item_lRec.GET(SalesLine_iRec."No.") then begin
                                SalesLine_iRec.Validate("Unit Price", (Item_lRec."Unit Cost" + ((Item_lRec."Unit Cost" * TransPriceLt_Rec."Margin %") / 100)) * CurrencyFactor_lDec);
                                Exit(True);
                            end;
                        End;
                    end;
                    /*  else begin
                         Item_lRec.Reset();
                         Item_lRec.SetRange("No.", SalesLine_iRec."No.");
                         If Item_lRec.FindFirst() then begin
                             If Item_lRec."Variant Filter" = '' then begin
                                 TransPriceLt_Rec.Reset();
                                 TransPriceLt_Rec.SetRange("Type Of Transaction", TransPriceLt_Rec."Type Of Transaction"::Sales);
                                 TransPriceLt_Rec.SetRange("IC Partner Code", Cust_lRec."IC Partner Code");
                                 TransPriceLt_Rec.SetRange("Item No.", SalesLine_iRec."No.");
                                 TransPriceLt_Rec.SetRange("Unit of Measure", SalesLine_iRec."Unit of Measure Code");
                                 TransPriceLt_Rec.SetRange("Currency Code", SalesHdr_lRec."Currency Code");
                                 If TransPriceLt_Rec.FindFirst() then begin
                                     If (TransPriceLt_Rec."Starting Date" <= SalesHdr_lRec."Order Date") and (TransPriceLt_Rec."Ending Date" >= SalesHdr_lRec."Order Date") then begin
                                         IF (TransPriceLt_Rec.Price = 0) and (TransPriceLt_Rec."Margin %" = 0) then
                                             Error('Either Margin % or Price should have value for Customer No. %1', SalesLine_iRec."Sell-to Customer No.");
                                         If TransPriceLt_Rec.Price <> 0 then
                                             SalesLine_iRec.Validate("Unit Price", TransPriceLt_Rec.Price);

                                         If TransPriceLt_Rec."Margin %" <> 0 then begin
                                             begin
                                                 SalesLine_iRec.Validate("Unit Price", (Item_lRec."Unit Cost" + ((Item_lRec."Unit Cost" * TransPriceLt_Rec."Margin %") / 100)) * CurrencyFactor_lDec);
                                                 Exit(True);
                                             end;
                                         end;
                                     end;
                                 End;
                             end;
                         end;
                     end;*/
                end;
            end;
    end;
    //T12141-NE
    //Hypercare-10-03-25-NS
    [EventSubscriber(ObjectType::Table, Database::"Sales Line", 'OnBeforeValidateEvent', "Unit Price", true, true)]
    local procedure "Sales Line_OnBeforeValidateEvent_DirecUnitCostHY"
(
    CurrFieldNo: Integer;
    var Rec: Record "Sales Line";
    var xRec: Record "Sales Line"
)
    var
        SH_lRec: Record "Sales Header";
    begin
        Clear(SH_lRec);
        if SH_lRec.Get(Rec."Document Type", Rec."Document No.") then begin
            if (SH_lRec."IC Direction" = SH_lRec."IC Direction"::Incoming) and (SH_lRec."IC Transaction No." <> 0) and
            (SH_lRec."Document Type" = SH_lRec."Document Type"::Order) then begin
                if (Rec."IC Partner Ref. Type" <> Rec."IC Partner Ref. Type"::" ") and
                (Rec."IC Item Reference No." <> '') and (Rec."Unit Price" <> xRec."Unit Price")
                 then
                    Error('One can not change Unit Price. if it is Related to Inter Company Transaction.');//Hypercare-Mayank 
            end;
        end;
    end;
    [EventSubscriber(ObjectType::Table, Database::"Sales Line", OnBeforeUpdateUnitPrice, '', false, false)]
    local procedure "Sales Line_OnBeforeUpdateUnitPrice"(var SalesLine: Record "Sales Line"; xSalesLine: Record "Sales Line"; CalledByFieldNo: Integer; CurrFieldNo: Integer; var Handled: Boolean)
    var
        SH_lRec: Record "Sales Header";
    begin
        //Hypercare-skip the change Direct Unit Cost,Unit of Measure Code
        Clear(SH_lRec);
        if SH_lRec.Get(SalesLine."Document Type", SalesLine."Document No.") then begin
            if (SH_lRec."IC Direction" = SH_lRec."IC Direction"::Incoming) and (SH_lRec."IC Transaction No." <> 0) and
            (SH_lRec."Document Type" = SH_lRec."Document Type"::Order) then begin
                if (SalesLine."IC Partner Ref. Type" <> SalesLine."IC Partner Ref. Type"::" ") and
                (SalesLine."IC Item Reference No." <> '') and (CurrFieldNo in [7, 5407])
                 then
                    Handled := true;
            end;
        end;
        //Hypercare-skip the change cost
    end;
    //Hypercare-10-03-25-NE
}
