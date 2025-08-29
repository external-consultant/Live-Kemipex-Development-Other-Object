codeunit 50015 "Subscriber 38 Purchase Head"
{
    trigger OnRun()
    begin

    end;

    //T12141-NS
    // [EventSubscriber(ObjectType::Table, Database::"Purchase Header", OnAfterCopyBuyFromVendorFieldsFromVendor, '', false, false)]
    // local procedure "Purchase Header_OnAfterCopyBuyFromVendorFieldsFromVendor"(var PurchaseHeader: Record "Purchase Header"; Vendor: Record Vendor; xPurchaseHeader: Record "Purchase Header")
    // var
    // begin
    //     PurchaseHeader."Due Date Calculation Type" := Vendor."Due Date Calculation Type";
    // end;

    // [EventSubscriber(ObjectType::Table, Database::"Purchase Header", 'OnAfterValidateEvent', 'Document Date', true, true)]
    // local procedure PurchaseHeader_DocumentDate_OnAfterValidateEvent(var Rec: Record "Purchase Header"; var xRec: Record "Purchase Header")
    // begin
    //     if Rec."Due Date Calculation Type" <> Rec."Due Date Calculation Type"::" " then begin
    //         if Rec."Due Date Calculation Type" = Rec."Due Date Calculation Type"::"BL Date" then
    //             Rec.Validate(Rec."Bill of Lading Date");
    //         if Rec."Due Date Calculation Type" = Rec."Due Date Calculation Type"::"Delivery Date" then
    //             Rec.Validate(Rec."Delivery Date");
    //         if Rec."Due Date Calculation Type" = Rec."Due Date Calculation Type"::"Document Submission Date" then
    //             Rec.Validate(Rec."Document Submission Date");
    //         if Rec."Due Date Calculation Type" = Rec."Due Date Calculation Type"::"QC Date" then
    //             Rec.Validate(Rec."QC Date");
    //     end;
    //     Commit();
    // end;
    //T12141_NE

    /* [EventSubscriber(ObjectType::Table, Database::"Purchase Header", 'OnAfterValidateEvent', 'Posting Date', true, true)]
    local procedure PurchaseHeader_PostingDate_OnAfterValidateEvent(var Rec: Record "Purchase Header"; var xRec: Record "Purchase Header")
    begin
        InsertIncoCharges(Rec, xRec);
    end; *///T12937-as per UAT need to close

    [EventSubscriber(ObjectType::Table, Database::"Purchase Header", 'OnAfterValidateEvent', 'Location Code', true, true)]
    local procedure PurchaseHeader_LocationCode_OnAfterValidateEvent(var Rec: Record "Purchase Header"; var xRec: Record "Purchase Header"; CurrFieldNo: Integer)
    var
        Loc_lRec: Record location;//T12475-N
        CategoryType: Code[10];//T12475-N
    begin
        //T12475-NS
        If Rec.IsTemporary then
            exit;
        if Rec."Location Code" <> xRec."Location Code" then begin
            if Loc_lRec.Get(Rec."Location Code") then begin
                Loc_lRec.TestField("Location Category");
                Rec."Location Category" := Loc_lRec."Location Category";
                Rec."Last Location Category" := xRec."Location Category";
            end;
        end;

        if Rec."First Approval Completed" then begin
            // Rec.TestField("Location Change Remarks");
            if CurrFieldNo <> Rec.FieldNo("Location Code") then
                exit;
            if rec."Location Category" <> rec."Last Location Category" then
                rec."Workflow Category Type" := '1'
            else
                rec."Workflow Category Type" := '2';
            Rec.Modify();
        end;
        //T12475-NE
        // InsertIncoCharges(Rec, xRec);//T12937-as per UAT need to close
    end;

    /*  [EventSubscriber(ObjectType::Table, Database::"Purchase Header", 'OnAfterValidateEvent', 'Shipment Method Code', true, true)]
     local procedure PurchaseHeader_ShipmentMethodCode_OnAfterValidateEvent(var Rec: Record "Purchase Header"; var xRec: Record "Purchase Header")
     begin
         InsertIncoCharges(Rec, xRec);
     end; *///T12937-as per UAT need to close

    /*  [EventSubscriber(ObjectType::Table, Database::"Purchase Header", 'OnAfterValidateEvent', 'Buy-from Vendor No.', true, true)]
     local procedure PurchaseHeader_BuyfromVendorNo_OnAfterValidateEvent(var Rec: Record "Purchase Header"; var xRec: Record "Purchase Header")
     begin
         InsertIncoCharges(Rec, xRec);
     end; *///T12937-as per UAT need to close

    // procedure InsertIncoCharges(PH_iRec: Record "Purchase Header"; xPH_iRec: Record "Purchase Header") //T12937-as per UAT need to close
    // var
    //     IncoCharge_lRec: Record "Incoterms and Charges";//Master
    //     DocIncoChrg_lRec: Record "Document Incoterms and Charges";//Transaction
    // begin
    //     if (PH_iRec."Shipment Method Code" <> xPH_iRec."Shipment Method Code") or (PH_iRec."Buy-from Vendor No." <> xPH_iRec."Buy-from Vendor No.") or (PH_iRec."Location Code" <> xPH_iRec."Location Code") or (PH_iRec."Posting Date" <> xPH_iRec."Posting Date") then begin
    //         DocIncoChrg_lRec.Reset();
    //         DocIncoChrg_lRec.SetRange("Transaction Type", DocIncoChrg_lRec."Transaction Type"::Purchase);
    //         DocIncoChrg_lRec.SetRange("Document Type", PH_iRec."Document Type");
    //         DocIncoChrg_lRec.SetRange("Document No.", PH_iRec."No.");
    //         if DocIncoChrg_lRec.FindFirst() then DocIncoChrg_lRec.DeleteAll();
    //     end;
    //     if (PH_iRec."Shipment Method Code" <> '') and (PH_iRec."Buy-from Vendor No." <> '') and (PH_iRec."Location Code" <> '') and (PH_iRec."Posting Date" <> 0D) then begin
    //         IncoCharge_lRec.Reset();
    //         InCoCharge_lRec.SetRange("Inco Term Code", PH_iRec."Shipment Method Code");
    //         InCoCharge_lRec.SetRange("Location Code", PH_iRec."Location Code");
    //         InCoCharge_lRec.SetRange("Vendor No.", PH_iRec."Buy-from Vendor No.");
    //         IncoCharge_lRec.SetFilter("Starting Date", '<=%1', PH_iRec."Posting Date");
    //         IncoCharge_lRec.SetAscending("Starting Date", false);
    //         if IncoCharge_lRec.FindSet() then begin
    //             Clear(DocIncoChrg_lRec);
    //             repeat
    //                 if not DocIncoChrg_lRec.Get(DocIncoChrg_lRec."Transaction Type"::Purchase, PH_iRec."Document Type", PH_iRec."No.", IncoCharge_lRec."Charge Item") then begin
    //                     DocIncoChrg_lRec.Init();
    //                     DocIncoChrg_lRec."Transaction Type" := DocIncoChrg_lRec."Transaction Type"::Purchase;
    //                     DocIncoChrg_lRec."Document Type" := PH_iRec."Document Type";
    //                     DocIncoChrg_lRec."Document No." := PH_iRec."No.";
    //                     DocIncoChrg_lRec."Inco Term Code" := IncoCharge_lRec."Inco Term Code";
    //                     DocIncoChrg_lRec."Charge Item" := IncoCharge_lRec."Charge Item";
    //                     DocIncoChrg_lRec.Insert();
    //                     DocIncoChrg_lRec."Location Code" := IncoCharge_lRec."Location Code";
    //                     DocIncoChrg_lRec.Validate("Vendor No.", IncoCharge_lRec."Vendor No.");
    //                     DocIncoChrg_lRec."Expected Charge Amount" := IncoCharge_lRec."Expected Charge Amount";
    //                     DocIncoChrg_lRec.Modify();
    //                 end;
    //             until IncoCharge_lRec.Next() = 0;
    //         end;
    //     end
    //     else begin
    //         DocIncoChrg_lRec.Reset();
    //         DocIncoChrg_lRec.SetRange("Transaction Type", DocIncoChrg_lRec."Transaction Type"::Purchase);
    //         DocIncoChrg_lRec.SetRange("Document Type", PH_iRec."Document Type");
    //         DocIncoChrg_lRec.SetRange("Document No.", PH_iRec."No.");
    //         if DocIncoChrg_lRec.FindFirst() then DocIncoChrg_lRec.DeleteAll();
    //     end;

    // end;

    //T12539-NS
    [EventSubscriber(ObjectType::Table, Database::"Purchase Header", 'OnAfterDeleteEvent', '', false, false)]
    local procedure PurchaseHeader_OnAfterDeletEvent(var Rec: Record "Purchase Header")
    var
        MultiplePmtTerms_lRec: Record "Multiple Payment Terms";
    begin
        If Rec.IsTemporary then
            exit;

        MultiplePmtTerms_lRec.Reset();
        MultiplePmtTerms_lRec.SetRange("Document No.", Rec."No.");
        MultiplePmtTerms_lRec.SetRange(Type, MultiplePmtTerms_lRec.Type::Purchase);
        MultiplePmtTerms_lRec.SetRange("Document Type", Rec."Document Type");
        If MultiplePmtTerms_lRec.FindSet() then
            repeat
                MultiplePmtTerms_lRec.DeleteAll(true);
            until MultiplePmtTerms_lRec.Next() = 0;
    end;
    //T12539-NE

    //T12539-NS
    [EventSubscriber(ObjectType::Table, Database::"Purchase Header", 'OnAfterValidateEvent', 'Status', false, false)]
    local procedure Status_OnAfterValidateEvent(var Rec: Record "Purchase Header"; var xRec: Record "Purchase Header")
    var
        MultiplePmtTerms_lRec: Record "Multiple Payment Terms";
    begin
        If Rec.Status = Rec.Status::Released then begin
            MultiplePmtTerms_lRec.Reset();
            MultiplePmtTerms_lRec.SetRange(Type, MultiplePmtTerms_lRec.Type::Purchase);
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

    var
        IncoTerm_gCdu: Codeunit IncoTerm_Mgmt;
}