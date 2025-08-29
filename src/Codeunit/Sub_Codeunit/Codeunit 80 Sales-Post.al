codeunit 50007 "Subscriber CU 80"
{
    //T12115-NS 21-06-2024
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", OnAfterFinalizePostingOnBeforeCommit, '', false, false)]
    local procedure "Sales-Post_OnAfterFinalizePostingOnBeforeCommit"(var SalesHeader: Record "Sales Header"; var SalesShipmentHeader: Record "Sales Shipment Header"; var SalesInvoiceHeader: Record "Sales Invoice Header"; var SalesCrMemoHeader: Record "Sales Cr.Memo Header"; var ReturnReceiptHeader: Record "Return Receipt Header"; var GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line"; var CommitIsSuppressed: Boolean; var PreviewMode: Boolean; WhseShip: Boolean; WhseReceive: Boolean; var EverythingInvoiced: Boolean)
    var
        SalesReceivables: Record "Sales & Receivables Setup";
        CreateSalesCrMemoBatch: Report "Create Sales Credit Memo Batch";
        ReturnReceiptHeader2: Record "Return Receipt Header";
    begin
        IF (ReturnReceiptHeader."No." <> '') AND (SalesHeader."Document Type" = SalesHeader."Document Type"::"Return Order") THEN BEGIN
            SalesReceivables.Get();
            if SalesReceivables."Prepostd CrMemo on Sal Ret Ord" then begin

                CLEAR(CreateSalesCrMemoBatch);
                ReturnReceiptHeader2.RESET;
                ReturnReceiptHeader2.SETRANGE("No.", ReturnReceiptHeader."No.");
                IF ReturnReceiptHeader2.FINDSET THEN BEGIN
                    CreateSalesCrMemoBatch.SetReturnOrder(SalesHeader);
                    CreateSalesCrMemoBatch.SETTABLEVIEW(ReturnReceiptHeader2);
                    CreateSalesCrMemoBatch.USEREQUESTPAGE(FALSE);
                    CreateSalesCrMemoBatch.RUNMODAL;
                    IF Not PreviewMode Then
                        COMMIT;
                END;
            end;
        end;
    end;
    //T12115-NE 21-06-2024

    //T12141-NS
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", OnBeforePostSalesDoc, '', false, false)]
    local procedure "Sales-Post_OnBeforePostSalesDoc"(var SalesHeader: Record "Sales Header")
    var
        FieldMandtempSetup_lRec: Record "Field Mand. Templ. Setup";
        ConfTempHead_lRec: Record "Config. Template Header";
        ConfTempLine_lRec: Record "Config. Template Line";
        FieldRef_lFrf: FieldRef;
        RecRef_lRrf: RecordRef;
        ErrorMsghandler: Codeunit "Error Message Handler";
        ErrorMsgMgt: Codeunit "Error Message Management";
        Fieldvalue_txt: Text;
        ConditionFilter_lText: Text;
        SalesHeaderDocNoFilter_lText: Text;
        RecordRef_lSH: RecordRef;
        TemplateFound_lCode: Code[10];
        TemplateFound_lInt: Integer;
        SalesHeaderDocvType_lText: Text;
        ReservationEntry: Record "Reservation Entry";
    begin
        SalesHeaderDocNoFilter_lText := ',Field3=1(' + SalesHeader."No." + '))';
        SalesHeaderDocvType_lText := 'Field3=1(' + Format(SalesHeader."Document Type".AsInteger()) + '))';

        TemplateFound_lCode := '';
        FieldMandtempSetup_lRec.Reset();
        FieldMandtempSetup_lRec.SetRange("Record Type", FieldMandtempSetup_lRec."Record Type"::"Sales Document");
        FieldMandtempSetup_lRec.SetRange(Enabled, true);
        FieldMandtempSetup_lRec.SetRange("Table Id", Database::"Sales Header");
        If FieldMandtempSetup_lRec.FindSet() then
            repeat
                Clear(ConditionFilter_lText);
                ConditionFilter_lText := CopyStr(GetConditionAsDisplayText(FieldMandtempSetup_lRec), 1, StrLen(GetConditionAsDisplayText(FieldMandtempSetup_lRec)) - 1);
                ConditionFilter_lText := ConditionFilter_lText + SalesHeaderDocNoFilter_lText;
                if (TemplateFound_lCode = '') and (StrPos(ConditionFilter_lText, SalesHeaderDocvType_lText) <> 0) then begin
                    RecordRef_lSH.Open(Database::"Sales Header");
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
        ConfTempHead_lRec.SetRange("Table ID", Database::"Sales Header");
        if ConfTempHead_lRec.FindFirst() then begin
            ConfTempLine_lRec.Reset();
            ConfTempLine_lRec.SetRange("Data Template Code", ConfTempHead_lRec.Code);
            if ConfTempLine_lRec.FindSet() then
                repeat
                    RecRef_lRrf.GetTable(SalesHeader);
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

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Release Sales Document", OnBeforePerformManualReleaseProcedure, '', false, false)]
    local procedure "Release Sales Document_OnBeforePerformManualReleaseProcedure"(var SalesHeader: Record "Sales Header"; PreviewMode: Boolean; var IsHandled: Boolean)
    var
        FieldMandtempSetup_lRec: Record "Field Mand. Templ. Setup";
        ConfTempHead_lRec: Record "Config. Template Header";
        ConfTempLine_lRec: Record "Config. Template Line";
        FieldRef_lFrf: FieldRef;
        RecRef_lRrf: RecordRef;
        ErrorMsghandler: Codeunit "Error Message Handler";
        ErrorMsgMgt: Codeunit "Error Message Management";
        Fieldvalue_txt: Text;
        ConditionFilter_lText: Text;
        SalesHeaderDocNoFilter_lText: Text;
        RecordRef_lSH: RecordRef;
        TemplateFound_lCode: Code[10];
        TemplateFound_lInt: Integer;
        SalesHeaderDocvType_lText: Text;
    begin
        SalesHeaderDocNoFilter_lText := ',Field3=1(' + SalesHeader."No." + '))';
        SalesHeaderDocvType_lText := 'Field3=1(' + Format(SalesHeader."Document Type".AsInteger()) + '))';


        TemplateFound_lCode := '';
        FieldMandtempSetup_lRec.Reset();
        FieldMandtempSetup_lRec.SetRange("Record Type", FieldMandtempSetup_lRec."Record Type"::"Sales Document");
        FieldMandtempSetup_lRec.SetRange(Enabled, true);
        FieldMandtempSetup_lRec.SetRange("Table Id", Database::"Sales Header");
        If FieldMandtempSetup_lRec.FindSet() then
            repeat
                Clear(ConditionFilter_lText);
                ConditionFilter_lText := CopyStr(GetConditionAsDisplayText(FieldMandtempSetup_lRec), 1, StrLen(GetConditionAsDisplayText(FieldMandtempSetup_lRec)) - 1);
                ConditionFilter_lText := ConditionFilter_lText + SalesHeaderDocNoFilter_lText;
                if (TemplateFound_lCode = '') and (StrPos(ConditionFilter_lText, SalesHeaderDocvType_lText) <> 0) then begin
                    RecordRef_lSH.Open(Database::"Sales Header");
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
        ConfTempHead_lRec.SetRange("Table ID", Database::"Sales Header");
        if ConfTempHead_lRec.FindFirst() then begin
            ConfTempLine_lRec.Reset();
            ConfTempLine_lRec.SetRange("Data Template Code", ConfTempHead_lRec.Code);
            if ConfTempLine_lRec.FindSet() then
                repeat
                    RecRef_lRrf.GetTable(SalesHeader);
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


    //T12937-NS
    // [EventSubscriber(ObjectType::Codeunit, Codeunit::"Posting Selection Management", OnConfirmPostSalesDocumentOnBeforeSalesOrderGetSalesInvoicePostingPolicy, '', false, false)]
    // local procedure "Posting Selection Management_OnConfirmPostSalesDocumentOnBeforeSalesOrderGetSalesInvoicePostingPolicy"(var SalesHeader: Record "Sales Header"; var IsHandled: Boolean)
    // Var
    //     Selection: Integer;
    //     ShipOptionsQst: Label '&Ship';
    // begin
    //     IsHandled := true;
    //     if SalesHeader."Document Type" = SalesHeader."Document Type"::Order then begin
    //         Selection := StrMenu(ShipOptionsQst, 1);
    //         if Selection = 0 then
    //             exit;
    //         SalesHeader.Ship := true;
    //         SalesHeader.Invoice := false;
    //         SalesHeader.Modify();
    //         // IsHandled := true;
    //     end;
    // end;
    //T12937-NE
    //T12937-OS
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post (Yes/No)", OnBeforeConfirmPost, '', false, false)]
    local procedure "Sales-Post (Yes/No)_OnBeforeConfirmPost"(var SalesHeader: Record "Sales Header"; var DefaultOption: Integer; var Result: Boolean; var IsHandled: Boolean)
    var
        SalesHeader_lRec: Record "Sales Header";
        Selection: Integer;
        ShipOptionsQst: Label '&Ship';
    begin
        if SalesHeader."Document Type" <> SalesHeader."Document Type"::Order then
            exit;
        SalesHeader_lRec.Copy(SalesHeader);
        IsHandled := true;
        if SalesHeader."Document Type" = SalesHeader."Document Type"::Order then begin
            Selection := StrMenu(ShipOptionsQst, 1);
            if Selection = 0 then begin
                Result := false;
                exit;
            end;
            SalesHeader.Ship := true;
            SalesHeader.Invoice := false;
            SalesHeader.Modify();
            Result := true;
        end;
    end;
    //T12937-OE

    // [EventSubscriber(ObjectType::Page, Page::"Sales Invoice", OnBeforeActionEvent, 'Post', false, false)]
    // local procedure SalesInvoicePost(var Rec: Record "Sales Header")
    // var
    //     Int_lint: Integer;
    // begin
    //     Int_lint += 1;
    // end;






}