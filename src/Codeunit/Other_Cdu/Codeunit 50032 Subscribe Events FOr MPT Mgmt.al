codeunit 50032 "Subscribe Events FOr MPT Mgmt"
{
    //T12539-N
    var
        SalesLn: Record "Sales Line";

    // [EventSubscriber(ObjectType::Table, Database::"Sales Line", 'OnAfterUpdateVATAmounts', '', false, false)]
    // local procedure OnAfterUpdateVATAmountsSalesLine(var SalesLine: Record "Sales Line");
    // var
    //     MultiplePmtTermMgt_lCdu: Codeunit "Multiple Payment Term Mgt";
    //     SalesHeader: Record "Sales Header";
    // begin
    //     SalesHeader.Reset();
    //     SalesHeader.SetRange("Document Type", SalesLine."Document Type");
    //     SalesHeader.SetRange("No.", SalesLine."Document No.");
    //     if not SalesHeader.FindFirst() then
    //         exit;

    //     Clear(MultiplePmtTermMgt_lCdu);
    //     MultiplePmtTermMgt_lCdu.SalesDocAmtUpd_gFnc(SalesHeader);
    // end;

    // [EventSubscriber(ObjectType::Table, Database::"Purchase Line", 'OnAfterUpdateVATAmounts', '', false, false)]
    // local procedure OnAfterUpdateVATAmountsPurchaseLine(var PurchaseLine: Record "Purchase Line"; TotalLineAmount: Decimal; TotalInvDiscAmount: Decimal; TotalAmount: Decimal; TotalAmountInclVAT: Decimal; TotalVATDifference: Decimal; TotalQuantityBase: Decimal);
    // var
    //     MultiplePmtTermMgt_lCdu: Codeunit "Multiple Payment Term Mgt";
    //     PurchaseHeader: Record "Purchase Header";
    // begin
    //     PurchaseHeader.Reset();
    //     PurchaseHeader.SetRange("Document Type", PurchaseLine."Document Type");
    //     PurchaseHeader.SetRange("No.", PurchaseLine."Document No.");
    //     if not PurchaseHeader.FindFirst() then
    //         exit;

    //     Clear(MultiplePmtTermMgt_lCdu);
    //     MultiplePmtTermMgt_lCdu.PurchasesDocAmtUpd_gFnc(PurchaseHeader);
    // end;



    // [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnAfterSalesInvHeaderInsert', '', false, false)]
    // local procedure OnAfterSalesInvHeaderInsert(var SalesInvHeader: Record "Sales Invoice Header"; SalesHeader: Record "Sales Header"; CommitIsSuppressed: Boolean; WhseShip: Boolean; WhseReceive: Boolean; var TempWhseShptHeader: Record "Warehouse Shipment Header"; var TempWhseRcptHeader: Record "Warehouse Receipt Header"; PreviewMode: Boolean);
    // var
    //     MultiplePaymentTermMgt_lCdu: Codeunit "Multiple Payment Term Mgt";
    // begin
    //     //T12539-NS
    //     MultiplePaymentTermMgt_lCdu.SalesHeadertoPostInvoice_gFnc(SalesHeader, SalesInvHeader."No.");
    //     //T12539-NE
    // end;

    // [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnAfterSalesCrMemoHeaderInsert', '', false, false)]
    // local procedure OnAfterSalesCrMemoHeaderInsert(var SalesCrMemoHeader: Record "Sales Cr.Memo Header"; SalesHeader: Record "Sales Header"; CommitIsSuppressed: Boolean; WhseShip: Boolean; WhseReceive: Boolean; var TempWhseShptHeader: Record "Warehouse Shipment Header"; var TempWhseRcptHeader: Record "Warehouse Receipt Header");
    // var
    //     MultiplePaymentTermMgt_lCdu: Codeunit "Multiple Payment Term Mgt";
    // begin
    //     //T12539-NS
    //     MultiplePaymentTermMgt_lCdu.SalesHeadertoPostCreditMemo_gFnc(SalesHeader, SalesCrMemoHeader."No.");
    //     //T12539-NE
    // end;


    //PurchPost
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", 'OnBeforePostPurchaseDoc', '', false, false)]
    local procedure OnBeforePostPurchaseDoc(var Sender: Codeunit "Purch.-Post"; var PurchaseHeader: Record "Purchase Header"; PreviewMode: Boolean; CommitIsSupressed: Boolean; var HideProgressWindow: Boolean; var ItemJnlPostLine: Codeunit "Item Jnl.-Post Line"; var IsHandled: Boolean);
    var
        MultiplePaymentTermMgt_lCdu: Codeunit "Multiple Payment Term Mgt";
        MultiplePmtTerms_lRec: Record "Multiple Payment Terms";
    begin
        //T12539-NS
        MultiplePaymentTermMgt_lCdu.PurchaseDocAmtUpd_gFnc(PurchaseHeader);
        MultiplePaymentTermMgt_lCdu.CheckPurchMultiplePaymentTermValidation_gFnc(PurchaseHeader);
        //T12539-NE
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", OnBeforeShowSalesApprovalStatus, '', false, false)]
    local procedure "Approvals Mgmt._OnBeforeShowSalesApprovalStatus"(var SalesHeader: Record "Sales Header"; var IsHandled: Boolean)
    var
        MultiplePaymentTermMgt_lCdu: Codeunit "Multiple Payment Term Mgt";
        MultiplePmtTerms_lRec: Record "Multiple Payment Terms";

    begin
        //T12539-NS
        MultiplePaymentTermMgt_lCdu.SalesDocAmtUpd_gFnc(SalesHeader);
        MultiplePaymentTermMgt_lCdu.CheckMultiplePaymentTermValidation_gFnc(SalesHeader);

        MultiplePmtTerms_lRec.Reset();
        MultiplePmtTerms_lRec.SetRange("Document No.", SalesHeader."No.");
        MultiplePmtTerms_lRec.SetRange("Document Type", SalesHeader."Document Type");
        MultiplePmtTerms_lRec.SetRange(Type, MultiplePmtTerms_lRec.Type::Sales);
        MultiplePmtTerms_lRec.SetRange(Type, MultiplePmtTerms_lRec.Type::Sales);
        If MultiplePmtTerms_lRec.FindSet() then
            repeat
                If MultiplePmtTerms_lRec."Percentage of Total" = 0 then
                    Error('Multiple Payment Terms line no %1 Percentage 0 is not allowed', MultiplePmtTerms_lRec."Line No.");
            until MultiplePmtTerms_lRec.Next() = 0;
        //T12539-NE
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", OnBeforeShowPurchApprovalStatus, '', false, false)]
    local procedure "Approvals Mgmt._OnBeforeShowPurchApprovalStatus"(var PurchaseHeader: Record "Purchase Header"; var IsHandled: Boolean)
    var
        MultiplePaymentTermMgt_lCdu: Codeunit "Multiple Payment Term Mgt";
        MultiplePmtTerms_lRec: Record "Multiple Payment Terms";

    begin
        //T12539-NS
        MultiplePaymentTermMgt_lCdu.PurchaseDocAmtUpd_gFnc(PurchaseHeader);
        MultiplePaymentTermMgt_lCdu.CheckpurchMultiplePaymentTermValidation_gFnc(PurchaseHeader);

        MultiplePmtTerms_lRec.Reset();
        MultiplePmtTerms_lRec.SetRange("Document No.", PurchaseHeader."No.");
        MultiplePmtTerms_lRec.SetRange("Document Type", PurchaseHeader."Document Type");
        MultiplePmtTerms_lRec.SetRange(Type, MultiplePmtTerms_lRec.Type::Purchase);
        If MultiplePmtTerms_lRec.FindSet() then
            repeat
                If MultiplePmtTerms_lRec."Percentage of Total" = 0 then
                    Error('Multiple Payment Terms line no %1 Percentage 0 is not allowed', MultiplePmtTerms_lRec."Line No.");

            until MultiplePmtTerms_lRec.Next() = 0;
        //T12539-NE
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", OnBeforePostSalesDoc, '', false, false)]
    local procedure "Sales-Post_OnBeforePostSalesDoc"(var Sender: Codeunit "Sales-Post"; var SalesHeader: Record "Sales Header"; CommitIsSuppressed: Boolean; PreviewMode: Boolean; var HideProgressWindow: Boolean; var IsHandled: Boolean; var CalledBy: Integer)
    var
        MultiplePaymentTermMgt_lCdu: Codeunit "Multiple Payment Term Mgt";
        MultiplePmtTerms_lRec: Record "Multiple Payment Terms";

    begin
        //T12539-NS
        MultiplePaymentTermMgt_lCdu.SalesDocAmtUpd_gFnc(SalesHeader);
        MultiplePaymentTermMgt_lCdu.CheckMultiplePaymentTermValidation_gFnc(SalesHeader);

        MultiplePmtTerms_lRec.Reset();
        MultiplePmtTerms_lRec.SetRange("Document No.", SalesHeader."No.");
        MultiplePmtTerms_lRec.SetRange("Document Type", SalesHeader."Document Type");
        MultiplePmtTerms_lRec.SetRange(Type, MultiplePmtTerms_lRec.Type::Sales);
        If MultiplePmtTerms_lRec.FindSet() then
            repeat
                MultiplePmtTerms_lRec.CheckAmount_lFnc('Sales', MultiplePmtTerms_lRec."Amount of Document");
            until MultiplePmtTerms_lRec.Next() = 0;
        //T12539-NE
    end;
    //Release Sales
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Release Sales Document", 'OnBeforeReleaseSalesDoc', '', false, false)]
    local procedure OnBeforeReleaseSalesDoc(var SalesHeader: Record "Sales Header"; PreviewMode: Boolean; var IsHandled: Boolean; SkipCheckReleaseRestrictions: Boolean);
    var
        MultiplePaymentTermMgt_lCdu: Codeunit "Multiple Payment Term Mgt";
        MultiplePmtTerms_lRec: Record "Multiple Payment Terms";
    begin
        //T12539-NS
        MultiplePaymentTermMgt_lCdu.SalesDocAmtUpd_gFnc(SalesHeader);
        MultiplePaymentTermMgt_lCdu.CheckMultiplePaymentTermValidation_gFnc(SalesHeader);

        MultiplePmtTerms_lRec.Reset();
        MultiplePmtTerms_lRec.SetRange("Document No.", SalesHeader."No.");
        MultiplePmtTerms_lRec.SetRange("Document Type", SalesHeader."Document Type");
        MultiplePmtTerms_lRec.SetRange(Type, MultiplePmtTerms_lRec.Type::Sales);
        If MultiplePmtTerms_lRec.FindSet() then
            repeat
                If MultiplePmtTerms_lRec."Percentage of Total" = 0 then
                    Error('Multiple Payment Terms line no %1 Percentage 0 is not allowed', MultiplePmtTerms_lRec."Line No.");

            until MultiplePmtTerms_lRec.Next() = 0;
        //T12539-NE
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Release Purchase Document", 'OnBeforeReleasepurchaseDoc', '', false, false)]
    local procedure OnBeforeReleasePurchDoc(var PurchaseHeader: Record "Purchase Header"; PreviewMode: Boolean; var IsHandled: Boolean; SkipCheckReleaseRestrictions: Boolean);
    var
        MultiplePaymentTermMgt_lCdu: Codeunit "Multiple Payment Term Mgt";
        MultiplePmtTerms_lRec: Record "Multiple Payment Terms";
    begin
        //T12539-NS
        MultiplePaymentTermMgt_lCdu.PurchaseDocAmtUpd_gFnc(PurchaseHeader);
        MultiplePaymentTermMgt_lCdu.CheckpurchMultiplePaymentTermValidation_gFnc(PurchaseHeader);

        MultiplePmtTerms_lRec.Reset();
        MultiplePmtTerms_lRec.SetRange("Document No.", PurchaseHeader."No.");
        MultiplePmtTerms_lRec.SetRange("Document Type", PurchaseHeader."Document Type");
        MultiplePmtTerms_lRec.SetRange(Type, MultiplePmtTerms_lRec.Type::Purchase);
        If MultiplePmtTerms_lRec.FindSet() then
            repeat
                If MultiplePmtTerms_lRec."Percentage of Total" = 0 then
                    Error('Multiple Payment Terms line no %1 Percentage 0 is not allowed', MultiplePmtTerms_lRec."Line No.");

            until MultiplePmtTerms_lRec.Next() = 0;
        //T12539-NE
    end;



    // [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", 'OnAfterPurchInvHeaderInsert', '', false, false)]
    // local procedure OnAfterPurchInvHeaderInsert(var PurchInvHeader: Record "Purch. Inv. Header"; var PurchHeader: Record "Purchase Header"; PreviewMode: Boolean);
    // var
    //     MultiplePaymentTermMgt_lCdu: Codeunit "Multiple Payment Term Mgt";
    // begin
    //     //T12539-NS
    //     IF NOT PreviewMode THEN
    //         MultiplePaymentTermMgt_lCdu.PurchHeadertoPostInvoice_gFnc(PurchHeader, PurchInvHeader."No.");
    //     //T12539-NE
    // end;

    // [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", 'OnAfterPurchCrMemoHeaderInsert', '', false, false)]
    // local procedure OnAfterPurchCrMemoHeaderInsert(var PurchCrMemoHdr: Record "Purch. Cr. Memo Hdr."; var PurchHeader: Record "Purchase Header"; CommitIsSupressed: Boolean; PreviewMode: Boolean);
    // var
    //     MultiplePaymentTermMgt_lCdu: Codeunit "Multiple Payment Term Mgt";
    // begin
    //     //T12539-NS
    //     IF NOT PreviewMode THEN
    //         MultiplePaymentTermMgt_lCdu.PurchHeadertoPostCreditMemo_gFnc(PurchHeader, PurchCrMemoHdr."No.");
    //     //T12539-NE
    // end;



    // //Release Purchase
    // [EventSubscriber(ObjectType::Codeunit, Codeunit::"Release Purchase Document", 'OnBeforeReleasePurchaseDoc', '', false, false)]
    // local procedure OnBeforeReleasePurchaseDoc(var PurchaseHeader: Record "Purchase Header"; PreviewMode: Boolean; var SkipCheckReleaseRestrictions: Boolean; var IsHandled: Boolean);
    // var
    //     MultiplePaymentTermMgt_lCdu: Codeunit "Multiple Payment Term Mgt";
    // begin
    //     //T12539-NS
    //     MultiplePaymentTermMgt_lCdu.PurchaseDocAmtUpd_gFnc(PurchaseHeader);
    //     MultiplePaymentTermMgt_lCdu.CheckPurchMultiplePaymentTermValidation_gFnc(PurchaseHeader);
    //     //T12539-NE
    // end;



    // //Copy Document
    // [EventSubscriber(ObjectType::Codeunit, Codeunit::"Copy Document Mgt.", 'OnAfterCheckFromSalesHeader', '', false, false)]
    // local procedure OnAfterCheckFromSalesHeader(SalesHeaderFrom: Record "Sales Header"; SalesHeaderTo: Record "Sales Header");
    // var
    //     MultiplePaymentTermMgt_lCdu: Codeunit "Multiple Payment Term Mgt";
    // begin
    //     //T12539-NS
    //     CLEAR(MultiplePaymentTermMgt_lCdu);
    //     MultiplePaymentTermMgt_lCdu.CopySalesHedtoHed(SalesHeaderFrom, SalesHeaderTo);
    //     //T12539-NE
    // end;

    // [EventSubscriber(ObjectType::Codeunit, Codeunit::"Copy Document Mgt.", 'OnCopySalesDocOnBeforeCopySalesDocInvLine', '', false, false)]
    // local procedure OnCopySalesDocOnBeforeCopySalesDocInvLine(var FromSalesInvoiceHeader: Record "Sales Invoice Header"; var ToSalesHeader: Record "Sales Header");
    // var
    //     MultiplePaymentTermMgt_lCdu: Codeunit "Multiple Payment Term Mgt";
    // begin
    //     //T12539-NS
    //     CLEAR(MultiplePaymentTermMgt_lCdu);
    //     MultiplePaymentTermMgt_lCdu.CopySalesInvHedtoHed(FromSalesInvoiceHeader, ToSalesHeader);
    //     //T12539-NE
    // end;

    // [EventSubscriber(ObjectType::Codeunit, Codeunit::"Copy Document Mgt.", 'OnAfterCheckFromPurchaseHeader', '', false, false)]
    // local procedure OnAfterCheckFromPurchaseHeader(PurchaseHeaderFrom: Record "Purchase Header"; PurchaseHeaderTo: Record "Purchase Header");
    // var
    //     MultiplePaymentTermMgt_lCdu: Codeunit "Multiple Payment Term Mgt";
    // begin
    //     //T12539-NS
    //     CLEAR(MultiplePaymentTermMgt_lCdu);
    //     MultiplePaymentTermMgt_lCdu.CopyPurchaseHedtoHed(PurchaseHeaderFrom, PurchaseHeaderTo);
    //     //T12539-NE
    // end;

    // [EventSubscriber(ObjectType::Codeunit, Codeunit::"Copy Document Mgt.", 'OnAfterCheckFromPurchaseInvHeader', '', false, false)]
    // local procedure OnAfterCheckFromPurchaseInvHeader(PurchInvHeaderFrom: Record "Purch. Inv. Header"; PurchaseHeaderTo: Record "Purchase Header");
    // var
    //     MultiplePaymentTermMgt_lCdu: Codeunit "Multiple Payment Term Mgt";
    // begin
    //     //T12539-NS
    //     CLEAR(MultiplePaymentTermMgt_lCdu);
    //     MultiplePaymentTermMgt_lCdu.CopyPurchaseInvHedtoHed(PurchInvHeaderFrom, PurchaseHeaderTo);
    //     //T12539-NE
    // end;
}