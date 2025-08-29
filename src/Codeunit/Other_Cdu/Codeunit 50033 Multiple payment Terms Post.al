codeunit 50033 "Multiple payment Terms Post"
{


    //T12539-NS
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", OnBeforeDeleteAfterPosting, '', false, false)]
    local procedure "Sales-Post_OnBeforeDeleteAfterPosting"(var SalesHeader: Record "Sales Header"; var SalesInvoiceHeader: Record "Sales Invoice Header"; var SalesCrMemoHeader: Record "Sales Cr.Memo Header"; var SkipDelete: Boolean; CommitIsSuppressed: Boolean; EverythingInvoiced: Boolean; var TempSalesLineGlobal: Record "Sales Line" temporary)
    var
        MultiplePmtTerms_lRec: Record "Multiple Payment Terms";
        PstdMultiplePmtTerms_lRec: Record "Posted Multiple Payment Terms";
        CustLedgEntry_lRec: Record "Cust. Ledger Entry";
        DtldCustLedgEntry_lREc: Record "Detailed Cust. Ledg. Entry";
        CalculateRemaingAmount_lCdu: Codeunit "Subscribe Table 379";
    begin
        If SalesHeader."Document Type" = SalesHeader."Document Type"::Quote then
            exit;

        MultiplePmtTerms_lRec.Reset();
        MultiplePmtTerms_lRec.SetRange("Document No.", SalesHeader."No.");
        MultiplePmtTerms_lRec.SetRange("Document Type", SalesHeader."Document Type");
        MultiplePmtTerms_lRec.SetRange(Type, MultiplePmtTerms_lRec.Type::Sales);
        If MultiplePmtTerms_lRec.FindSet() then
            repeat
                PstdMultiplePmtTerms_lRec.Init();
                If SalesInvoiceHeader."No." <> '' then begin
                    PstdMultiplePmtTerms_lRec."Table ID" := 112;
                    PstdMultiplePmtTerms_lRec."Document No." := SalesInvoiceHeader."No.";
                    PstdMultiplePmtTerms_lRec."Document Type" := PstdMultiplePmtTerms_lRec."Document Type"::"Posted Sales Invoice";
                    PstdMultiplePmtTerms_lRec."Remaining Amount" := MultiplePmtTerms_lRec."Amount of Document";
                    PstdMultiplePmtTerms_lRec."Amount of Document" := MultiplePmtTerms_lRec."Amount of Document";
                end;
                If SalesCrMemoHeader."No." <> '' then begin
                    PstdMultiplePmtTerms_lRec."Table ID" := 114;
                    PstdMultiplePmtTerms_lRec."Document No." := SalesCrMemoHeader."No.";
                    PstdMultiplePmtTerms_lRec."Document Type" := PstdMultiplePmtTerms_lRec."Document Type"::"Posted Sales Cr. Memo";
                    PstdMultiplePmtTerms_lRec."Remaining Amount" := -1 * MultiplePmtTerms_lRec."Amount of Document";
                    PstdMultiplePmtTerms_lRec."Amount of Document" := -1 * MultiplePmtTerms_lRec."Amount of Document";
                end;
                PstdMultiplePmtTerms_lRec."Line No." := MultiplePmtTerms_lRec."Line No.";
                PstdMultiplePmtTerms_lRec.Type := MultiplePmtTerms_lRec.Type;
                PstdMultiplePmtTerms_lRec.Sequence := MultiplePmtTerms_lRec.Sequence;


                PstdMultiplePmtTerms_lRec."Due Date" := MultiplePmtTerms_lRec."Due Date";
                PstdMultiplePmtTerms_lRec."Due Date Calculation" := MultiplePmtTerms_lRec."Due Date Calculation";
                PstdMultiplePmtTerms_lRec."Event Date" := MultiplePmtTerms_lRec."Event Date";
                PstdMultiplePmtTerms_lRec."Payment Description" := MultiplePmtTerms_lRec."Payment Description";
                PstdMultiplePmtTerms_lRec."Payment Forecast Date" := MultiplePmtTerms_lRec."Payment Forecast Date";
                PstdMultiplePmtTerms_lRec."Percentage of Total" := MultiplePmtTerms_lRec."Percentage of Total";
                PstdMultiplePmtTerms_lRec.Posted := true;
                PstdMultiplePmtTerms_lRec.Released := MultiplePmtTerms_lRec.Released;
                PstdMultiplePmtTerms_lRec.Insert();
            until MultiplePmtTerms_lRec.Next() = 0;

        CustLedgEntry_lRec.Reset();
        If SalesCrMemoHeader."No." <> '' then begin
            CustLedgEntry_lRec.SetRange("Document No.", SalesCrMemoHeader."No.");
            CustLedgEntry_lRec.SetRange("Document Type", CustLedgEntry_lRec."Document Type"::"Credit Memo");
        end else begin
            CustLedgEntry_lRec.SetRange("Document No.", SalesInvoiceHeader."No.");
            CustLedgEntry_lRec.SetRange("Document Type", CustLedgEntry_lRec."Document Type"::Invoice);
        end;
        If CustLedgEntry_lRec.FindFirst() then begin
            DtldCustLedgEntry_lREc.Reset();
            DtldCustLedgEntry_lREc.SetRange("Cust. Ledger Entry No.", CustLedgEntry_lRec."Entry No.");
            DtldCustLedgEntry_lREc.SetRange("Entry Type", DtldCustLedgEntry_lREc."Entry Type"::Application);
            If DtldCustLedgEntry_lREc.FindSet() then
                repeat
                    CalculateRemaingAmount_lCdu.CalCulateRemainingAmount(DtldCustLedgEntry_lREc);
                until DtldCustLedgEntry_lREc.Next() = 0;
        end;


    end;
    //T12539-NE

    //T12539-NS

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", OnBeforeDeleteAfterPosting, '', false, false)]
    local procedure "Purch.-Post_OnBeforeDeleteAfterPosting"(var PurchaseHeader: Record "Purchase Header"; var PurchInvHeader: Record "Purch. Inv. Header"; var PurchCrMemoHdr: Record "Purch. Cr. Memo Hdr."; var SkipDelete: Boolean; CommitIsSupressed: Boolean; var TempPurchLine: Record "Purchase Line" temporary; var TempPurchLineGlobal: Record "Purchase Line" temporary; var GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line")
    var
        MultiplePmtTerms_lRec: Record "Multiple Payment Terms";
        PstdMultiplePmtTerms_lRec: Record "Posted Multiple Payment Terms";
        VendorLedgerEntry_lRec: Record "Vendor Ledger Entry";
        DetailedVendorLedgerEntry_lRec: Record "Detailed Vendor Ledg. Entry";
        CalculateRemaingAmount_lCdu: Codeunit "Subscribe Table 380";
    begin
        If PurchaseHeader."Document Type" = PurchaseHeader."Document Type"::Quote then
            exit;


        MultiplePmtTerms_lRec.Reset();
        MultiplePmtTerms_lRec.SetRange("Document No.", PurchaseHeader."No.");
        MultiplePmtTerms_lRec.SetRange(Type, MultiplePmtTerms_lRec.Type::Purchase);
        MultiplePmtTerms_lRec.SetRange("Document Type", PurchaseHeader."Document Type");
        If MultiplePmtTerms_lRec.FindSet() then
            repeat
                PstdMultiplePmtTerms_lRec.Init();
                If PurchInvHeader."No." <> '' then begin
                    PstdMultiplePmtTerms_lRec."Table ID" := 122;
                    PstdMultiplePmtTerms_lRec."Document No." := PurchInvHeader."No.";
                    PstdMultiplePmtTerms_lRec."Document Type" := PstdMultiplePmtTerms_lRec."Document Type"::"Posted Purchase Invoice";
                    PstdMultiplePmtTerms_lRec."Remaining Amount" := -1 * MultiplePmtTerms_lRec."Amount of Document";
                    PstdMultiplePmtTerms_lRec."Amount of Document" := -1 * MultiplePmtTerms_lRec."Amount of Document";
                end;
                If PurchCrMemoHdr."No." <> '' then begin
                    PstdMultiplePmtTerms_lRec."Table ID" := 124;
                    PstdMultiplePmtTerms_lRec."Document No." := PurchCrMemoHdr."No.";
                    PstdMultiplePmtTerms_lRec."Document Type" := PstdMultiplePmtTerms_lRec."Document Type"::"Posted Purchase Cr. Memo";
                    PstdMultiplePmtTerms_lRec."Remaining Amount" := MultiplePmtTerms_lRec."Amount of Document";
                    PstdMultiplePmtTerms_lRec."Amount of Document" := MultiplePmtTerms_lRec."Amount of Document";
                end;
                PstdMultiplePmtTerms_lRec."Line No." := MultiplePmtTerms_lRec."Line No.";
                PstdMultiplePmtTerms_lRec.Type := MultiplePmtTerms_lRec.Type;
                PstdMultiplePmtTerms_lRec.Sequence := MultiplePmtTerms_lRec.Sequence;

                PstdMultiplePmtTerms_lRec."Due Date" := MultiplePmtTerms_lRec."Due Date";
                PstdMultiplePmtTerms_lRec."Due Date Calculation" := MultiplePmtTerms_lRec."Due Date Calculation";
                PstdMultiplePmtTerms_lRec."Event Date" := MultiplePmtTerms_lRec."Event Date";
                PstdMultiplePmtTerms_lRec."Payment Description" := MultiplePmtTerms_lRec."Payment Description";
                PstdMultiplePmtTerms_lRec."Payment Forecast Date" := MultiplePmtTerms_lRec."Payment Forecast Date";
                PstdMultiplePmtTerms_lRec."Percentage of Total" := MultiplePmtTerms_lRec."Percentage of Total";
                PstdMultiplePmtTerms_lRec.Posted := true;
                PstdMultiplePmtTerms_lRec.Released := MultiplePmtTerms_lRec.Released;
                PstdMultiplePmtTerms_lRec.Insert();
            until MultiplePmtTerms_lRec.Next() = 0;


        VendorLedgerEntry_lRec.Reset();
        If PurchCrMemoHdr."No." <> '' then begin
            VendorLedgerEntry_lRec.SetRange("Document No.", PurchCrMemoHdr."No.");
            VendorLedgerEntry_lRec.SetRange("Document Type", VendorLedgerEntry_lRec."Document Type"::"Credit Memo");
        end else begin
            VendorLedgerEntry_lRec.SetRange("Document No.", PurchInvHeader."No.");
            VendorLedgerEntry_lRec.SetRange("Document Type", VendorLedgerEntry_lRec."Document Type"::Invoice);
        end;
        If VendorLedgerEntry_lRec.FindFirst() then begin
            DetailedVendorLedgerEntry_lRec.Reset();
            DetailedVendorLedgerEntry_lRec.SetRange("Vendor Ledger Entry No.", VendorLedgerEntry_lRec."Entry No.");
            DetailedVendorLedgerEntry_lRec.SetRange("Entry Type", DetailedVendorLedgerEntry_lRec."Entry Type"::Application);
            If DetailedVendorLedgerEntry_lRec.FindSet() then
                repeat
                    CalculateRemaingAmount_lCdu.CalCulateRemainingAmount(DetailedVendorLedgerEntry_lRec);
                until DetailedVendorLedgerEntry_lRec.Next() = 0;
        end;
    end;

    procedure CheckPaymentDiscount_lFnc(Var PaymentTerm_iCde: Code[20])
    var
        PaymentTerm_lRec: Record "Payment Terms";
    begin
        if PaymentTerm_iCde = '' then
            exit;
        PaymentTerm_lRec.get(PaymentTerm_iCde);
        if (PaymentTerm_lRec."Discount %" <> 0) or (Format(PaymentTerm_lRec."Discount Date Calculation") <> '') then
            Error('There should not be payment discount selected on Payment Term Master %1', PaymentTerm_iCde);


    end;

    [EventSubscriber(ObjectType::Table, Database::"Multiple Payment Terms", 'OnAfterInsertEvent', '', true, true)]
    local procedure "MultiplePaymentTermsOnAfterInsertEvent"
    (
        var Rec: Record "Multiple Payment Terms";
        RunTrigger: Boolean
    )
    var
        SalesHeader: Record "Sales Header";
        PurchaseHeader_gRec: Record "Purchase Header";
    begin

        if (Rec."Document Type" = Rec."Document Type"::Order) and (rec.type = Rec.type::Purchase) then begin
            if PurchaseHeader_gRec.get(Rec."Document Type", rec."Document No.") then
                CheckPaymentDiscount_lFnc(PurchaseHeader_gRec."Payment Terms Code");
        end ELSE if (Rec."Document Type" = Rec."Document Type"::Order) and (rec.type = Rec.type::Sales) then begin
            if SalesHeader.get(Rec."Document Type", rec."Document No.") then
                CheckPaymentDiscount_lFnc(SalesHeader."Payment Terms Code");
        END;
    end;
    //T12539-Nheader
}
