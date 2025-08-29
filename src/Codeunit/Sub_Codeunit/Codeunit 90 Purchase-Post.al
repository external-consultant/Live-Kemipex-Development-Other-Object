codeunit 50012 "Subscriber CU 90"
{
    //T12115-NS 21-06-2024
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", OnAfterFinalizePostingOnBeforeCommit, '', false, false)]
    local procedure "Purch.-Post_OnAfterFinalizePostingOnBeforeCommit"(var PurchHeader: Record "Purchase Header"; var PurchRcptHeader: Record "Purch. Rcpt. Header"; var PurchInvHeader: Record "Purch. Inv. Header"; var PurchCrMemoHdr: Record "Purch. Cr. Memo Hdr."; var ReturnShptHeader: Record "Return Shipment Header"; var GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line"; PreviewMode: Boolean; CommitIsSupressed: Boolean; EverythingInvoiced: Boolean)
    var
        SalesReceivables: Record "Sales & Receivables Setup";
        CreatePurchInvoice: Report "Create Purch Invoice Batch";
        PurchRcptLine: Record "Purch. Rcpt. Line";
        PurchInvLn_lRec: Record "Purch. Inv. Line";
        VLE_lRec: Record "Vendor Ledger Entry";
        PurchPayablesSetup_lRec: Record "Purchases & Payables Setup";
        PurchCreditLn_lRec: Record "Purch. Cr. Memo Line";//T12706-N
    begin
        IF (PurchRcptHeader."No." <> '') AND (PurchHeader."Document Type" = PurchHeader."Document Type"::"Return Order") THEN BEGIN
            SalesReceivables.Get();
            if SalesReceivables."Prepostd CrMemo on Sal Ret Ord" then begin
                CLEAR(CreatePurchInvoice);
                PurchRcptLine.RESET;
                PurchRcptLine.SETRANGE("No.", PurchRcptHeader."No.");
                IF PurchRcptLine.FINDSET THEN BEGIN
                    CreatePurchInvoice.SetReturnOrder(PurchHeader);
                    CreatePurchInvoice.SETTABLEVIEW(PurchRcptHeader);
                    CreatePurchInvoice.USEREQUESTPAGE(FALSE);
                    CreatePurchInvoice.RUNMODAL;
                    IF Not PreviewMode Then
                        COMMIT;
                END;
            end;
        end;

        //T12141-NS
        PurchPayablesSetup_lRec.GET();
        If PurchPayablesSetup_lRec."Copy Line Description" then begin
            PurchInvLn_lRec.Reset();
            PurchInvLn_lRec.SetRange("Document No.", PurchInvHeader."No.");
            IF PurchInvLn_lRec.FindSet() then
                repeat
                    VLE_lRec.Reset();
                    VLE_lRec.SetRange("Document No.", PurchInvLn_lRec."Document No.");
                    If VLE_lRec.FindFirst() then begin
                        If VLE_lRec."Copy Line Description" = '' then
                            VLE_lRec."Copy Line Description" := PurchInvLn_lRec.Description
                        else
                            VLE_lRec."Copy Line Description" += ', ' + PurchInvLn_lRec.Description;
                        VLE_lRec.Modify(true);
                    end;
                until PurchInvLn_lRec.Next() = 0;
            //T12706-NS
            PurchCreditLn_lRec.reset;
            PurchCreditLn_lRec.SetRange("Document No.", PurchCrMemoHdr."No.");
            if PurchCreditLn_lRec.FindSet() then begin
                repeat
                    VLE_lRec.Reset();
                    VLE_lRec.SetRange("Document No.", PurchCreditLn_lRec."Document No.");
                    If VLE_lRec.FindFirst() then begin
                        If VLE_lRec."Copy Line Description" = '' then
                            VLE_lRec."Copy Line Description" := PurchCreditLn_lRec.Description
                        else
                            VLE_lRec."Copy Line Description" += ', ' + PurchCreditLn_lRec.Description;
                        VLE_lRec.Modify(true);
                    end;
                until PurchCreditLn_lRec.next = 0;
            end;
            //T12706-NE
        end;
        //T12141-NE



    end;
    //T12115-NE 21-06-2024

    //T12141-NS
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", OnBeforePostPurchaseDoc, '', false, false)]
    local procedure "Purch.-Post_OnBeforePostPurchaseDoc"(var Sender: Codeunit "Purch.-Post"; var PurchaseHeader: Record "Purchase Header"; PreviewMode: Boolean; CommitIsSupressed: Boolean; var HideProgressWindow: Boolean; var ItemJnlPostLine: Codeunit "Item Jnl.-Post Line"; var IsHandled: Boolean)
    var
        ConfTempHead_lRec: Record "Config. Template Header";
        ConfTempLine_lRec: Record "Config. Template Line";
        FieldRef_lFrf: FieldRef;
        RecRef_lRrf: RecordRef;
        ErrorMsghandler: Codeunit "Error Message Handler";
        ErrorMsgMgt: Codeunit "Error Message Management";
        Fieldvalue_txt: Text;
        FieldMandtempSetup_lRec: Record "Field Mand. Templ. Setup";
        ConditionFilter_lText: Text;
        PurchaseHeaderDocNoFilter_lText: Text;
        RecordRef_lSH: RecordRef;
        TemplateFound_lCode: Code[10];
        TemplateFound_lInt: Integer;
        PurchaseHeaderDocTypeFilter_lText: Text;
        ReservationEntry: Record "Reservation Entry";
    begin
        PurchaseHeaderDocNoFilter_lText := ',Field3=1(' + PurchaseHeader."No." + '))';
        PurchaseHeaderDocTypeFilter_lText := 'Field1=1(' + FORMAT(PurchaseHeader."Document Type".AsInteger()) + ')';

        TemplateFound_lCode := '';
        FieldMandtempSetup_lRec.Reset();
        FieldMandtempSetup_lRec.SetRange("Record Type", FieldMandtempSetup_lRec."Record Type"::"Purchase Document");
        FieldMandtempSetup_lRec.SetRange(Enabled, true);
        FieldMandtempSetup_lRec.SetRange("Table Id", Database::"Purchase Header");
        If FieldMandtempSetup_lRec.FindSet() then
            repeat
                Clear(ConditionFilter_lText);
                ConditionFilter_lText := CopyStr(GetConditionAsDisplayText(FieldMandtempSetup_lRec), 1, StrLen(GetConditionAsDisplayText(FieldMandtempSetup_lRec)) - 1);
                ConditionFilter_lText := ConditionFilter_lText + PurchaseHeaderDocNoFilter_lText;
                if (TemplateFound_lCode = '') and (StrPos(ConditionFilter_lText, PurchaseHeaderDocTypeFilter_lText) <> 0) then begin
                    RecordRef_lSH.Open(Database::"Purchase Header");
                    RecordRef_lSH.SetView(ConditionFilter_lText);
                    if RecordRef_lSH.FindFirst() then begin
                        TemplateFound_lCode := FieldMandtempSetup_lRec."Config. Template";
                        TemplateFound_lInt := FieldMandtempSetup_lRec.ID;
                    end;
                    RecordRef_lSH.Close();
                end;
            until FieldMandtempSetup_lRec.Next() = 0;

        ErrorMsgMgt.Activate(ErrorMsghandler);
        ConfTempHead_lRec.Reset();
        ConfTempHead_lRec.SetRange(Code, TemplateFound_lCode);
        ConfTempHead_lRec.SetRange("Table ID", Database::"Purchase Header");
        if ConfTempHead_lRec.FindFirst() then begin
            ConfTempLine_lRec.Reset();
            ConfTempLine_lRec.SetRange("Data Template Code", ConfTempHead_lRec.Code);
            if ConfTempLine_lRec.FindSet() then
                repeat
                    RecRef_lRrf.GetTable(PurchaseHeader);
                    FieldRef_lFrf := RecRef_lRrf.Field(ConfTempLine_lRec."Field ID");
                    Fieldvalue_txt := Format(FieldRef_lFrf.Value);
                    if Fieldvalue_txt = '' then
                        ErrorMsgMgt.LogSimpleErrorMessage('Error In Process! ' + FieldRef_lFrf.Caption + ' must have value');
                until ConfTempLine_lRec.Next() = 0;
            if ErrorMsghandler.HasErrors() then
                if ErrorMsghandler.ShowErrors() then
                    Error('');
        end;
        
        //ISPLRV-NS-13-01-2025
        ReservationEntry.Reset();
        ReservationEntry.SetRange("Source Type", 83);
        ReservationEntry.SetRange("Source Batch Name", '');
        ReservationEntry.SetRange("Source ID", '');
        if ReservationEntry.FindSet() then
            ReservationEntry.DeleteAll();
        //ISPLRV-NE-13-01-2025


    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Release Purchase Document", OnBeforeManualReleasePurchaseDoc, '', false, false)]
    local procedure "Release Purchase Document_OnBeforeManualReleasePurchaseDoc"(var PurchaseHeader: Record "Purchase Header"; PreviewMode: Boolean)
    var
        ConfTempHead_lRec: Record "Config. Template Header";
        ConfTempLine_lRec: Record "Config. Template Line";
        FieldRef_lFrf: FieldRef;
        RecRef_lRrf: RecordRef;
        ErrorMsghandler: Codeunit "Error Message Handler";
        ErrorMsgMgt: Codeunit "Error Message Management";
        Fieldvalue_txt: Text;
        FieldMandtempSetup_lRec: Record "Field Mand. Templ. Setup";
        ConditionFilter_lText: Text;
        PurchaseHeaderDocNoFilter_lText: Text;
        RecordRef_lSH: RecordRef;
        TemplateFound_lCode: Code[10];
        TemplateFound_lInt: Integer;
        PurchaseHeaderDocTypeFilter_lText: Text;
    begin
        PurchaseHeaderDocNoFilter_lText := ',Field3=1(' + PurchaseHeader."No." + '))';
        PurchaseHeaderDocTypeFilter_lText := 'Field1=1(' + FORMAT(PurchaseHeader."Document Type".AsInteger()) + ')';

        TemplateFound_lCode := '';
        FieldMandtempSetup_lRec.Reset();
        FieldMandtempSetup_lRec.SetRange("Record Type", FieldMandtempSetup_lRec."Record Type"::"Purchase Document");
        FieldMandtempSetup_lRec.SetRange(Enabled, true);
        FieldMandtempSetup_lRec.SetRange("Table Id", Database::"Purchase Header");
        If FieldMandtempSetup_lRec.FindSet() then
            repeat
                Clear(ConditionFilter_lText);
                ConditionFilter_lText := CopyStr(GetConditionAsDisplayText(FieldMandtempSetup_lRec), 1, StrLen(GetConditionAsDisplayText(FieldMandtempSetup_lRec)) - 1);
                ConditionFilter_lText := ConditionFilter_lText + PurchaseHeaderDocNoFilter_lText;
                if (TemplateFound_lCode = '') and (StrPos(ConditionFilter_lText, PurchaseHeaderDocTypeFilter_lText) <> 0) then begin
                    RecordRef_lSH.Open(Database::"Purchase Header");
                    RecordRef_lSH.SetView(ConditionFilter_lText);
                    if RecordRef_lSH.FindFirst() then begin
                        TemplateFound_lCode := FieldMandtempSetup_lRec."Config. Template";
                        TemplateFound_lInt := FieldMandtempSetup_lRec.ID;
                    end;
                    RecordRef_lSH.Close();
                end;
            until FieldMandtempSetup_lRec.Next() = 0;

        ErrorMsgMgt.Activate(ErrorMsghandler);
        ConfTempHead_lRec.Reset();
        ConfTempHead_lRec.SetRange(Code, TemplateFound_lCode);
        ConfTempHead_lRec.SetRange("Table ID", Database::"Purchase Header");
        if ConfTempHead_lRec.FindFirst() then begin
            ConfTempLine_lRec.Reset();
            ConfTempLine_lRec.SetRange("Data Template Code", ConfTempHead_lRec.Code);
            if ConfTempLine_lRec.FindSet() then
                repeat
                    RecRef_lRrf.GetTable(PurchaseHeader);
                    FieldRef_lFrf := RecRef_lRrf.Field(ConfTempLine_lRec."Field ID");
                    Fieldvalue_txt := Format(FieldRef_lFrf.Value);
                    if Fieldvalue_txt = '' then
                        ErrorMsgMgt.LogSimpleErrorMessage('Error In Process! ' + FieldRef_lFrf.Caption + ' must have value');
                until ConfTempLine_lRec.Next() = 0;
            if ErrorMsghandler.HasErrors() then
                if ErrorMsghandler.ShowErrors() then
                    Error('');
        end;
    end;


    // [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", OnBeforeReleasePurchDoc, '', false, false)]
    // local procedure "Purch.-Post_OnBeforeReleasePurchDoc"(var PurchHeader: Record "Purchase Header"; PreviewMode: Boolean)
    // var
    // begin
    //     if PurchHeader."Due Date Calculation Type" <> PurchHeader."Due Date Calculation Type"::" " then begin
    //         if PurchHeader."Due Date Calculation Type" = PurchHeader."Due Date Calculation Type"::"BL Date" then
    //             PurchHeader.TestField("Bill of Lading Date");
    //         if PurchHeader."Due Date Calculation Type" = PurchHeader."Due Date Calculation Type"::"Delivery Date" then
    //             PurchHeader.TestField("Delivery Date");
    //         if PurchHeader."Due Date Calculation Type" = PurchHeader."Due Date Calculation Type"::"Document Submission Date" then
    //             PurchHeader.TestField("Document Submission Date");
    //         if PurchHeader."Due Date Calculation Type" = PurchHeader."Due Date Calculation Type"::"QC Date" then
    //             PurchHeader.TestField("QC Date");
    //     end else
    //         exit;
    // end;



    procedure GetConditionAsDisplayText(FieldMandtempSetup_lRec: Record "Field Mand. Templ. Setup"): Text
    var
        Allobj: Record AllObj;
        RecordRef: RecordRef;
        IStream: InStream;
        COnditionText: Text;
        ExitMsg: Label 'Always';
        ObjectIDNotFoundErr: Label 'Error : Table ID %1 not found', Comment = '%1=Table Id';
    begin
        if not Allobj.Get(Allobj."Object Type"::Table, FieldMandtempSetup_lRec."Table Id") then
            exit(StrSubstNo(ObjectIDNotFoundErr, FieldMandtempSetup_lRec."Table Id"));
        RecordRef.Open(FieldMandtempSetup_lRec."Table ID");
        FieldMandtempSetup_lRec.CalcFields(Condition);
        if not FieldMandtempSetup_lRec.Condition.HasValue() then
            exit(ExitMsg);

        FieldMandtempSetup_lRec.Condition.CreateInStream(IStream);
        IStream.Read(COnditionText);
        exit(COnditionText);
    end;
    //T12141-NE
    // [EventSubscriber(ObjectType::Codeunit, Codeunit::"Posting Selection Management", OnConfirmPostPurchaseDocumentOnBeforePurchaseOrderGetPurchaseInvoicePostingPolicy, '', false, false)]
    // local procedure "Posting Selection Management_OnConfirmPostPurchaseDocumentOnBeforePurchaseOrderGetPurchaseInvoicePostingPolicy"(var PurchaseHeader: Record "Purchase Header"; var IsHandled: Boolean)
    // Var
    //     Selection: Integer;
    //     ReceiveOptionsQst: Label '&Receive';
    // begin
    //     if PurchaseHeader."Document Type" = PurchaseHeader."Document Type"::Order then begin
    //         Selection := StrMenu(ReceiveOptionsQst, 1);
    //         if Selection = 0 then
    //             exit;
    //         PurchaseHeader.Receive := true;
    //         PurchaseHeader.Invoice := false;
    //         PurchaseHeader.Modify();
    //         IsHandled := true;
    //     end;
    // end;
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post (Yes/No)", OnBeforeConfirmPostProcedure, '', false, false)]
    local procedure "Purch.-Post (Yes/No)OnBeforeConfirmPostProcedure"(var PurchaseHeader: Record "Purchase Header"; var DefaultOption: Integer; var Result: Boolean; var IsHandled: Boolean)
    var
        PurchasHeader_lRec: Record "Purchase Header";
        Selection: Integer;
        RecvOptionsQst: Label '&Receive';
    begin
        if PurchaseHeader."Document Type" <> PurchaseHeader."Document Type"::Order then
            exit;
        PurchasHeader_lRec.Copy(PurchaseHeader);
        IsHandled := true;
        if PurchaseHeader."Document Type" = PurchaseHeader."Document Type"::Order then begin
            Selection := StrMenu(RecvOptionsQst, 1);
            if Selection = 0 then begin
                Result := false;
                exit;
            end;
            PurchaseHeader.Receive := true;
            PurchaseHeader.Invoice := false;
            PurchaseHeader.Modify();
            Result := true;
        end;
    end;






}