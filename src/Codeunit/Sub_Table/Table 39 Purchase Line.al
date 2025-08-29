codeunit 50014 "Subscriber 37 Purchase Line"
{

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"GST Purchase Subscribers", OnBeforeCheckHeaderLocation, '', false, false)]
    local procedure "GST Purchase Subscribers_OnBeforeCheckHeaderLocation"(PurchaseLine: Record "Purchase Line"; var IsHandled: Boolean)
    begin
        IsHandled := true//T12113-N
    end;

    //T12141-NS
    [EventSubscriber(ObjectType::Table, Database::"Purchase Line", 'OnAfterValidateEvent', 'No.', true, true)]
    local procedure "Purchase Line_OnAfterValidateEvent_No"
   (
       var Rec: Record "Purchase Line";
       var xRec: Record "Purchase Line";
       CurrFieldNo: Integer
   )
    var
    begin
        GetPurchasePrice(REC);
    end;
    //T12141-NE

    //T12141-NS
    [EventSubscriber(ObjectType::Table, Database::"Purchase Line", 'OnAfterValidateEvent', 'Variant Code', true, true)]
    local procedure "Purchase Line_OnAfterValidateEvent_Variant Code"
   (
       var Rec: Record "Purchase Line";
       var xRec: Record "Purchase Line";
       CurrFieldNo: Integer
   )
    var
    begin
        GetPurchasePrice(REC);
    end;
    //T12141-NE

    //T12141-NS
    [EventSubscriber(ObjectType::Table, Database::"Purchase Line", 'OnAfterValidateEvent', 'Unit Of Measure', true, true)]
    local procedure "Purchase Line_OnAfterValidateEvent_Unit of Measure"
  (
      var Rec: Record "Purchase Line";
      var xRec: Record "Purchase Line";
      CurrFieldNo: Integer
  )
    var
    begin
        GetPurchasePrice(REC);
    end;
    //T12141-NE

    //T12141-NS
    [EventSubscriber(ObjectType::Table, Database::"Purchase Line", 'OnAfterValidateEvent', 'Quantity', true, true)]
    local procedure "Purchase Line_OnAfterValidateEvent_Quantity"
  (
      var Rec: Record "Purchase Line";
      var xRec: Record "Purchase Line";
      CurrFieldNo: Integer
  )
    var
    begin
        GetPurchasePrice(REC);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Purchase Line", OnBeforeUpdateDirectUnitCost, '', false, false)]
    local procedure "Purchase Line_OnBeforeUpdateDirectUnitCost"(var PurchLine: Record "Purchase Line"; xPurchLine: Record "Purchase Line"; CalledByFieldNo: Integer; CurrFieldNo: Integer; var Handled: Boolean)
    var
        Vendor_lRec: Record Vendor;
        PH_lRec: Record "Purchase Header";

    begin
        Clear(PH_lRec);
        if PH_lRec.Get(PurchLine."Document Type", PurchLine."Document No.") then begin
            if PH_lRec.Status = PH_lRec.Status::Released then begin
                Handled := true;
                exit;
            end;
            //T52870-NS-as per Yash Hudiya
            Vendor_lRec.Reset();
            If Vendor_lRec.GET(PurchLine."Buy-from Vendor No.") then
                If Vendor_lRec."IC Partner Code" <> '' then//T52870-NE-as per Yash Hudiya
                    Handled := GetPurchasePrice(PurchLine);
            if not Handled then begin
                Vendor_lRec.Reset();
                IF Vendor_lRec.GET(PurchLine."Buy-from Vendor No.") then begin
                    If Vendor_lRec."IC Partner Code" <> '' then
                        Message('Inter-Company Transfer Price is not defined for the given combination.');

                end;
                //Hypercare-skip the change Direct Unit Cost,Unit of Measure Code
                Clear(PH_lRec);
                if PH_lRec.Get(PurchLine."Document Type", PurchLine."Document No.") then begin
                    if (PH_lRec."IC Direction" = PH_lRec."IC Direction"::Incoming) and (PH_lRec."IC Transaction No." <> 0) and
                    (PH_lRec."Document Type" = PH_lRec."Document Type"::Order) then begin
                        if (PurchLine."IC Partner Ref. Type" <> PurchLine."IC Partner Ref. Type"::" ") and
                        (PurchLine."IC Item Reference No." <> '') and (CurrFieldNo in [7, 5407])
                         then
                            Handled := true;
                    end;
                end;
                //Hypercare-skip the change cost
            end;
        end;
    end;
    //T12141-NE

    //T12141-NS
    procedure GetPurchasePrice(Var PurchaseLine_iRec: Record "Purchase Line"): Boolean
    var
        Vendor_lRec: Record Vendor;
        PurchaseHdr_lRec: Record "Purchase Header";
        TransPriceLt_Rec: Record "Transfer Price List";
        Item_lRec: Record Item;
    begin
        If PurchaseLine_iRec.Type <> PurchaseLine_iRec.Type::Item then
            exit;
        if PurchaseLine_iRec."No." = '' then
            Exit;
        // if PurchaseLine_iRec."Variant Code" = '' then
        //     exit;
        If PurchaseLine_iRec."Unit of Measure Code" = '' then
            exit;


        Vendor_lRec.Reset();
        If Vendor_lRec.GET(PurchaseLine_iRec."Buy-from Vendor No.") then
            If Vendor_lRec."IC Partner Code" <> '' then begin
                PurchaseHdr_lRec.Reset();
                PurchaseHdr_lRec.SetRange("Document Type", PurchaseLine_iRec."Document Type");
                PurchaseHdr_lRec.SetRange("No.", PurchaseLine_iRec."Document No.");
                If PurchaseHdr_lRec.FindFirst() then begin
                    TransPriceLt_Rec.Reset();
                    TransPriceLt_Rec.SetRange("Type Of Transaction", TransPriceLt_Rec."Type Of Transaction"::Purchase);
                    TransPriceLt_Rec.SetRange("IC Partner Code", Vendor_lRec."IC Partner Code");
                    TransPriceLt_Rec.SetRange("Item No.", PurchaseLine_iRec."No.");
                    TransPriceLt_Rec.SetRange("Variant Code", PurchaseLine_iRec."Variant Code");
                    TransPriceLt_Rec.SetRange("Unit of Measure", PurchaseLine_iRec."Unit of Measure Code");
                    TransPriceLt_Rec.SetRange("Currency Code", PurchaseLine_iRec."Currency Code");
                    TransPriceLt_Rec.SetFilter("Starting Date", '<=%1', PurchaseHdr_lRec."Order Date");
                    TransPriceLt_Rec.SetFilter("Ending Date", '>=%1', PurchaseHdr_lRec."Order Date");
                    If TransPriceLt_Rec.FindFirst() then begin

                        IF (TransPriceLt_Rec.Price = 0) and (TransPriceLt_Rec."Margin %" = 0) then
                            Error('Either Margin % or Price should have value for Customer No. %1', PurchaseLine_iRec."Buy-from Vendor No.");
                        If TransPriceLt_Rec.Price <> 0 then begin
                            PurchaseLine_iRec.Validate(PurchaseLine_iRec."Direct Unit Cost", TransPriceLt_Rec.Price);
                            exit(true);
                        end;
                        // If TransPriceLt_Rec."Margin %" <> 0 then begin
                        //     Item_lRec.Reset();
                        //     IF Item_lRec.GET(PurchaseLine_iRec."No.") then begin
                        //         PurchaseLine_iRec.Validate(PurchaseLine_iRec."Direct Unit Cost", Item_lRec."Unit Cost" + ((Item_lRec."Unit Cost" * TransPriceLt_Rec."Margin %") / 100));
                        //     end;
                        // End;
                    end
                    // // else begin
                    // //     Item_lRec.Reset();
                    // //     Item_lRec.SetRange("No.", PurchaseLine_iRec."No.");
                    // //     If Item_lRec.FindFirst() then begin
                    // //         If Item_lRec."Variant Filter" = '' then begin
                    // //             TransPriceLt_Rec.Reset();
                    // //             TransPriceLt_Rec.SetRange("Type Of Transaction", TransPriceLt_Rec."Type Of Transaction"::Sales);
                    // //             TransPriceLt_Rec.SetRange("IC Partner Code", Vendor_lRec."IC Partner Code");
                    // //             TransPriceLt_Rec.SetRange("Item No.", PurchaseLine_iRec."No.");
                    // //             TransPriceLt_Rec.SetRange("Unit of Measure", PurchaseLine_iRec."Unit of Measure Code");
                    // //             TransPriceLt_Rec.SetRange("Currency Code", PurchaseHdr_lRec."Currency Code");
                    // //             If TransPriceLt_Rec.FindFirst() then begin
                    // //                 If (TransPriceLt_Rec."Starting Date" <= PurchaseHdr_lRec."Order Date") and (TransPriceLt_Rec."Ending Date" >= PurchaseLine_iRec."Order Date") then begin
                    // //                     IF (TransPriceLt_Rec.Price = 0) and (TransPriceLt_Rec."Margin %" = 0) then
                    // //                         Error('Either Margin % or Price should have value for Customer No. %1', PurchaseLine_iRec."Buy-from Vendor No.");
                    // //                     If TransPriceLt_Rec.Price <> 0 then
                    // //                         PurchaseLine_iRec.Validate("Direct Unit Cost", TransPriceLt_Rec.Price);

                    // //                     // If TransPriceLt_Rec."Margin %" <> 0 then begin
                    // //                     //     Item_lRec.Reset();
                    // //                     //     IF Item_lRec.GET(PurchaseLine_iRec."No.") then begin
                    // //                     //         PurchaseLine_iRec.Validate("Direct Unit Cost", Item_lRec."Unit Cost" + ((Item_lRec."Unit Cost" * TransPriceLt_Rec."Margin %") / 100));
                    // //                     //     end;
                    // //                     // end;
                    // //                 End;
                    // //             end;
                    // //         end;
                    // //     end;
                    // end;
                end;
                //T12141-NE
            end;
    end;
    //260225-OS
    [EventSubscriber(ObjectType::Table, Database::"Purchase Line", 'OnBeforeValidateEvent', "Direct Unit Cost", true, true)]
    local procedure "Purchase Line_OnBeforeValidateEvent_DirecUnitCostHY"
(
    var Rec: Record "Purchase Line";
    var xRec: Record "Purchase Line";
    CurrFieldNo: Integer
)
    var
        PH_lRec: Record "Purchase Header";
    begin
        Clear(PH_lRec);
        if PH_lRec.Get(Rec."Document Type", Rec."Document No.") then begin
            if (PH_lRec."IC Direction" = PH_lRec."IC Direction"::Incoming) and (PH_lRec."IC Transaction No." <> 0) and
            (PH_lRec."Document Type" = PH_lRec."Document Type"::Order) then begin
                if (Rec."IC Partner Ref. Type" <> Rec."IC Partner Ref. Type"::" ") and
                (Rec."IC Item Reference No." <> '') and (Rec."Direct Unit Cost" <> xRec."Direct Unit Cost")
                 then
                    Error('One can not change Direct Unit cost. if it is Related to Inter Company Transaction.');//Hypercare-Mayank 
            end;
        end;
        // Clear(PH_lRec);
        // if PH_lRec.Get(Rec."Document Type", Rec."Document No.") then begin
        //     if (PH_lRec."IC Direction" = PH_lRec."IC Direction"::Incoming) and (PH_lRec."IC Transaction No." <> 0) then begin
        //         if (Rec."Document Type" = Rec."Document Type"::Order) and
        //         (rec."IC Partner Ref. Type" <> rec."IC Partner Ref. Type"::" ") and
        //         (Rec."Direct Unit Cost" <> xRec."Direct Unit Cost") and
        //         (Rec."IC Item Reference No." <> '')
        //          then
        //             Error('One can not change Direct Unit cost. if it is Related to Inter Company Transaction.');//Hypercare-Mayank 
        //     end;
        // end;
    end;
    //260225-OE
}