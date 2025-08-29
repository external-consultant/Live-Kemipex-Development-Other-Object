codeunit 50021 "Check Field Mandatory App."
{
    trigger OnRun()
    begin
    end;
    //T12141-NS

    //For Customer
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", OnAfterCheckCustomerApprovalsWorkflowEnabled, '', false, false)]
    local procedure "Approvals Mgmt._OnSendCustomerForApproval"(var Customer: Record Customer)
    var
        //FieldMandatorySetup_lRec: Record "Field Mandatory Setup";
        ConfTempHead_lRec: Record "Config. Template Header";
        ConfTempLine_lRec: Record "Config. Template Line";
        FieldRef_lFrf: FieldRef;
        RecRef_lRrf: RecordRef;
        ErrorMsghandler: Codeunit "Error Message Handler";
        ErrorMsgMgt: Codeunit "Error Message Management";
        Fieldvalue_txt: Text;
        FieldMandtempSetup_lRec: Record "Field Mand. Templ. Setup";
        ConditionFilter_lText: Text;
        CustomerNoFilter_lText: Text;
        RecordRef_lSH: RecordRef;
        TemplateFound_lCode: Code[10];
        TemplateFound_lInt: Integer;
    begin
        // FieldMandatorySetup_lRec.Get();
        // FieldMandatorySetup_lRec.TestField("Customer Config. Template");

        // CustomerNoFilter_lText := ',Field1=1(' + Customer."No." + '))';
        // CustomerNoFilter_lText := 'VERSION(1) SORTING(Field1) WHERE(Field1=1(' + Customer."No." + '))';


        TemplateFound_lCode := '';
        FieldMandtempSetup_lRec.Reset();
        FieldMandtempSetup_lRec.SetRange("Record Type", FieldMandtempSetup_lRec."Record Type"::Customer);
        FieldMandtempSetup_lRec.SetRange(Enabled, true);
        FieldMandtempSetup_lRec.SetRange("Table Id", Database::Customer);
        If FieldMandtempSetup_lRec.FindSet() then
            repeat
                Clear(ConditionFilter_lText);
                ConditionFilter_lText := CopyStr(GetConditionAsDisplayText(FieldMandtempSetup_lRec), 1, StrLen(GetConditionAsDisplayText(FieldMandtempSetup_lRec)));
                if ConditionFilter_lText = '' then
                    CustomerNoFilter_lText := 'VERSION(1) SORTING(Field1) WHERE(Field1=1(' + Customer."No." + '))'
                else
                    CustomerNoFilter_lText := ',Field1=1(' + Customer."No." + '))';
                ConditionFilter_lText := ConditionFilter_lText + CustomerNoFilter_lText;
                if TemplateFound_lCode = '' then begin
                    RecordRef_lSH.Open(Database::Customer);
                    RecordRef_lSH.SetView(ConditionFilter_lText);
                    if RecordRef_lSH.FindFirst() then begin
                        TemplateFound_lCode := FieldMandtempSetup_lRec."Config. Template";
                        TemplateFound_lInt := FieldMandtempSetup_lRec.ID;
                    end;
                    RecordRef_lSH.Close();
                end;
            until FieldMandtempSetup_lRec.Next() = 0;

        // if TemplateFound_lCode = '' then
        //     Error('Configuration Template must have value in Field Mandatory Template Setup for ID: %1', TemplateFound_lInt);

        ErrorMsgMgt.Activate(ErrorMsghandler);
        ConfTempHead_lRec.Reset();
        ConfTempHead_lRec.SetRange(Code, TemplateFound_lCode);
        ConfTempHead_lRec.SetRange("Table ID", Database::Customer);
        if ConfTempHead_lRec.FindFirst() then begin
            ConfTempLine_lRec.Reset();
            ConfTempLine_lRec.SetRange("Data Template Code", ConfTempHead_lRec.Code);
            if ConfTempLine_lRec.FindSet() then
                repeat
                    RecRef_lRrf.GetTable(Customer);
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

    //For Vendor

    [EventSubscriber(ObjectType::Page, Page::"Vendor List", OnBeforeActionEvent, 'SendApprovalRequest', false, false)]
    local procedure "VendorListOnBeforeActionEventSendApprovalRequest"(var Rec: Record Vendor)
    var
        //FieldMandatorySetup_lRec: Record "Field Mandatory Setup";
        ConfTempHead_lRec: Record "Config. Template Header";
        ConfTempLine_lRec: Record "Config. Template Line";
        FieldRef_lFrf: FieldRef;
        RecRef_lRrf: RecordRef;
        ErrorMsghandler: Codeunit "Error Message Handler";
        ErrorMsgMgt: Codeunit "Error Message Management";
        Fieldvalue_txt: Text;
        FieldMandtempSetup_lRec: Record "Field Mand. Templ. Setup";
        ConditionFilter_lText: Text;
        VendorNoFilter_lText: Text;
        RecordRef_lSH: RecordRef;
        TemplateFound_lCode: Code[10];
        TemplateFound_lInt: Integer;
    begin
        // FieldMandatorySetup_lRec.Get();
        // FieldMandatorySetup_lRec.TestField("Vendor Config. Template");

        // VendorNoFilter_lText := 'VERSION(1) SORTING(Field1) WHERE(Field1=1(' + Rec."No." + '))';

        TemplateFound_lCode := '';
        FieldMandtempSetup_lRec.Reset();
        FieldMandtempSetup_lRec.SetRange("Record Type", FieldMandtempSetup_lRec."Record Type"::Vendor);
        FieldMandtempSetup_lRec.SetRange(Enabled, true);
        FieldMandtempSetup_lRec.SetRange("Table Id", Database::Vendor);
        If FieldMandtempSetup_lRec.FindSet() then
            repeat
                Clear(ConditionFilter_lText);
                ConditionFilter_lText := CopyStr(GetConditionAsDisplayText(FieldMandtempSetup_lRec), 1, StrLen(GetConditionAsDisplayText(FieldMandtempSetup_lRec)));
                if ConditionFilter_lText = '' then
                    VendorNoFilter_lText := 'VERSION(1) SORTING(Field1) WHERE(Field1=1(' + Rec."No." + '))'
                else
                    VendorNoFilter_lText := ',Field1=1(' + REc."No." + '))';
                ConditionFilter_lText := ConditionFilter_lText + VendorNoFilter_lText;
                if TemplateFound_lCode = '' then begin
                    RecordRef_lSH.Open(Database::Vendor);
                    RecordRef_lSH.SetView(ConditionFilter_lText);
                    if RecordRef_lSH.FindFirst() then begin
                        TemplateFound_lCode := FieldMandtempSetup_lRec."Config. Template";
                        TemplateFound_lInt := FieldMandtempSetup_lRec.ID;
                    end;
                    RecordRef_lSH.Close();
                end;
            until FieldMandtempSetup_lRec.Next() = 0;

        // if TemplateFound_lCode = '' then
        //     Error('Configuration Template must have value in Field Mandatory Template Setup for ID: %1', TemplateFound_lInt);

        ErrorMsgMgt.Activate(ErrorMsghandler);
        ConfTempHead_lRec.Reset();
        ConfTempHead_lRec.SetRange(Code, TemplateFound_lCode);
        ConfTempHead_lRec.SetRange("Table ID", Database::Vendor);
        if ConfTempHead_lRec.FindFirst() then begin
            ConfTempLine_lRec.Reset();
            ConfTempLine_lRec.SetRange("Data Template Code", ConfTempHead_lRec.Code);
            if ConfTempLine_lRec.FindSet() then
                repeat
                    RecRef_lRrf.GetTable(Rec);
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

    [EventSubscriber(ObjectType::Page, Page::"Vendor Card", OnBeforeActionEvent, 'SendApprovalRequest', false, false)]
    local procedure "VendorCardOnBeforeActionEventSendApprovalRequest"(var Rec: Record Vendor)
    var
        //FieldMandatorySetup_lRec: Record "Field Mandatory Setup";
        ConfTempHead_lRec: Record "Config. Template Header";
        ConfTempLine_lRec: Record "Config. Template Line";
        FieldRef_lFrf: FieldRef;
        RecRef_lRrf: RecordRef;
        ErrorMsghandler: Codeunit "Error Message Handler";
        ErrorMsgMgt: Codeunit "Error Message Management";
        Fieldvalue_txt: Text;
        FieldMandtempSetup_lRec: Record "Field Mand. Templ. Setup";
        ConditionFilter_lText: Text;
        VendorNoFilter_lText: Text;
        RecordRef_lSH: RecordRef;
        TemplateFound_lCode: Code[10];
        TemplateFound_lInt: Integer;

    begin
        // FieldMandatorySetup_lRec.Get();
        // FieldMandatorySetup_lRec.TestField("Vendor Config. Template");

        // VendorNoFilter_lText := 'VERSION(1) SORTING(Field1) WHERE(Field1=1(' + Rec."No." + '))';

        TemplateFound_lCode := '';
        FieldMandtempSetup_lRec.Reset();
        FieldMandtempSetup_lRec.SetRange("Record Type", FieldMandtempSetup_lRec."Record Type"::Vendor);
        FieldMandtempSetup_lRec.SetRange(Enabled, true);
        FieldMandtempSetup_lRec.SetRange("Table Id", Database::Vendor);
        If FieldMandtempSetup_lRec.FindSet() then
            repeat
                Clear(ConditionFilter_lText);
                ConditionFilter_lText := CopyStr(GetConditionAsDisplayText(FieldMandtempSetup_lRec), 1, StrLen(GetConditionAsDisplayText(FieldMandtempSetup_lRec)));
                if ConditionFilter_lText = '' then
                    VendorNoFilter_lText := 'VERSION(1) SORTING(Field1) WHERE(Field1=1(' + Rec."No." + '))'
                else
                    VendorNoFilter_lText := ',Field1=1(' + REc."No." + '))';
                ConditionFilter_lText := ConditionFilter_lText + VendorNoFilter_lText;
                if TemplateFound_lCode = '' then begin
                    RecordRef_lSH.Open(Database::Vendor);
                    RecordRef_lSH.SetView(ConditionFilter_lText);
                    if RecordRef_lSH.FindFirst() then begin
                        TemplateFound_lCode := FieldMandtempSetup_lRec."Config. Template";
                        TemplateFound_lInt := FieldMandtempSetup_lRec.ID;
                    end;
                    RecordRef_lSH.Close();
                end;
            until FieldMandtempSetup_lRec.Next() = 0;

        // if TemplateFound_lCode = '' then
        //     Error('Configuration Template must have value in Field Mandatory Template Setup for ID: %1', TemplateFound_lInt);

        ErrorMsgMgt.Activate(ErrorMsghandler);
        ConfTempHead_lRec.Reset();
        ConfTempHead_lRec.SetRange(Code, TemplateFound_lCode);
        ConfTempHead_lRec.SetRange("Table ID", Database::Vendor);
        if ConfTempHead_lRec.FindFirst() then begin
            ConfTempLine_lRec.Reset();
            ConfTempLine_lRec.SetRange("Data Template Code", ConfTempHead_lRec.Code);
            if ConfTempLine_lRec.FindSet() then
                repeat
                    RecRef_lRrf.GetTable(Rec);
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

    //For Item
    [EventSubscriber(ObjectType::Page, Page::"Item List", OnBeforeActionEvent, 'SendApprovalRequest', false, false)]
    local procedure "ItemListOnBeforeActionEventSendApprovalRequest"(var Rec: Record Item)
    var
        //FieldMandatorySetup_lRec: Record "Field Mandatory Setup";
        ConfTempHead_lRec: Record "Config. Template Header";
        ConfTempLine_lRec: Record "Config. Template Line";
        FieldRef_lFrf: FieldRef;
        RecRef_lRrf: RecordRef;
        ErrorMsghandler: Codeunit "Error Message Handler";
        ErrorMsgMgt: Codeunit "Error Message Management";
        Fieldvalue_txt: Text;
        FieldMandtempSetup_lRec: Record "Field Mand. Templ. Setup";
        ConditionFilter_lText: Text;
        ItemNoFilter_lText: Text;
        RecordRef_lSH: RecordRef;
        TemplateFound_lCode: Code[10];
        TemplateFound_lInt: Integer;

    begin
        // FieldMandatorySetup_lRec.Get();
        // FieldMandatorySetup_lRec.TestField("Item Config. Template");

        // ItemNoFilter_lText := 'VERSION(1) SORTING(Field1) WHERE(Field1=1(' + Rec."No." + '))';

        TemplateFound_lCode := '';
        FieldMandtempSetup_lRec.Reset();
        FieldMandtempSetup_lRec.SetRange("Record Type", FieldMandtempSetup_lRec."Record Type"::Item);
        FieldMandtempSetup_lRec.SetRange(Enabled, true);
        FieldMandtempSetup_lRec.SetRange("Table Id", Database::Item);
        If FieldMandtempSetup_lRec.FindSet() then
            repeat
                Clear(ConditionFilter_lText);
                ConditionFilter_lText := CopyStr(GetConditionAsDisplayText(FieldMandtempSetup_lRec), 1, StrLen(GetConditionAsDisplayText(FieldMandtempSetup_lRec)));
                if ConditionFilter_lText = '' then
                    ItemNoFilter_lText := 'VERSION(1) SORTING(Field1) WHERE(Field1=1(' + Rec."No." + '))'
                else
                    ItemNoFilter_lText := ',Field1=1(' + Rec."No." + '))';
                ConditionFilter_lText := ConditionFilter_lText + ItemNoFilter_lText;
                if TemplateFound_lCode = '' then begin
                    RecordRef_lSH.Open(Database::Item);
                    RecordRef_lSH.SetView(ConditionFilter_lText);
                    if RecordRef_lSH.FindFirst() then begin
                        TemplateFound_lCode := FieldMandtempSetup_lRec."Config. Template";
                        TemplateFound_lInt := FieldMandtempSetup_lRec.ID;
                    end;
                    RecordRef_lSH.Close();
                end;
            until FieldMandtempSetup_lRec.Next() = 0;

        // if TemplateFound_lCode = '' then
        //     Error('Configuration Template must have value in Field Mandatory Template Setup for ID: %1', TemplateFound_lInt);

        ErrorMsgMgt.Activate(ErrorMsghandler);
        ConfTempHead_lRec.Reset();
        ConfTempHead_lRec.SetRange(Code, TemplateFound_lCode);
        ConfTempHead_lRec.SetRange("Table ID", Database::Item);
        if ConfTempHead_lRec.FindFirst() then begin
            ConfTempLine_lRec.Reset();
            ConfTempLine_lRec.SetRange("Data Template Code", ConfTempHead_lRec.Code);
            if ConfTempLine_lRec.FindSet() then
                repeat
                    RecRef_lRrf.GetTable(Rec);
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

    [EventSubscriber(ObjectType::Page, Page::"Item Card", OnBeforeActionEvent, 'SendApprovalRequest', false, false)]
    local procedure "itemCardOnBeforeActionEventSendApprovalRequest"(var Rec: Record Item)
    var
        //FieldMandatorySetup_lRec: Record "Field Mandatory Setup";
        ConfTempHead_lRec: Record "Config. Template Header";
        ConfTempLine_lRec: Record "Config. Template Line";
        FieldRef_lFrf: FieldRef;
        RecRef_lRrf: RecordRef;
        ErrorMsghandler: Codeunit "Error Message Handler";
        ErrorMsgMgt: Codeunit "Error Message Management";
        Fieldvalue_txt: Text;
        FieldMandtempSetup_lRec: Record "Field Mand. Templ. Setup";
        ConditionFilter_lText: Text;
        ItemNoFilter_lText: Text;
        RecordRef_lSH: RecordRef;
        TemplateFound_lCode: Code[10];
        TemplateFound_lInt: Integer;

    begin
        // FieldMandatorySetup_lRec.Get();
        // FieldMandatorySetup_lRec.TestField("Item Config. Template");

        // ItemNoFilter_lText := 'VERSION(1) SORTING(Field1) WHERE(Field1=1(' + Rec."No." + '))';

        TemplateFound_lCode := '';
        FieldMandtempSetup_lRec.Reset();
        FieldMandtempSetup_lRec.SetRange("Record Type", FieldMandtempSetup_lRec."Record Type"::Item);
        FieldMandtempSetup_lRec.SetRange(Enabled, true);
        FieldMandtempSetup_lRec.SetRange("Table Id", Database::Item);
        If FieldMandtempSetup_lRec.FindSet() then
            repeat
                Clear(ConditionFilter_lText);
                ConditionFilter_lText := CopyStr(GetConditionAsDisplayText(FieldMandtempSetup_lRec), 1, StrLen(GetConditionAsDisplayText(FieldMandtempSetup_lRec)));
                if ConditionFilter_lText = '' then
                    ItemNoFilter_lText := 'VERSION(1) SORTING(Field1) WHERE(Field1=1(' + Rec."No." + '))'
                else
                    ItemNoFilter_lText := ',Field1=1(' + Rec."No." + '))';
                ConditionFilter_lText := ConditionFilter_lText + ItemNoFilter_lText;
                if TemplateFound_lCode = '' then begin
                    RecordRef_lSH.Open(Database::Item);
                    RecordRef_lSH.SetView(ConditionFilter_lText);
                    if RecordRef_lSH.FindFirst() then begin
                        TemplateFound_lCode := FieldMandtempSetup_lRec."Config. Template";
                        TemplateFound_lInt := FieldMandtempSetup_lRec.ID;
                    end;
                    RecordRef_lSH.Close();
                end;
            until FieldMandtempSetup_lRec.Next() = 0;

        // if TemplateFound_lCode = '' then
        //     Error('Configuration Template must have value in Field Mandatory Template Setup for ID: %1', TemplateFound_lInt);

        ErrorMsgMgt.Activate(ErrorMsghandler);
        ConfTempHead_lRec.Reset();
        ConfTempHead_lRec.SetRange(Code, TemplateFound_lCode);
        ConfTempHead_lRec.SetRange("Table ID", Database::Item);
        if ConfTempHead_lRec.FindFirst() then begin
            ConfTempLine_lRec.Reset();
            ConfTempLine_lRec.SetRange("Data Template Code", ConfTempHead_lRec.Code);
            if ConfTempLine_lRec.FindSet() then
                repeat
                    RecRef_lRrf.GetTable(Rec);
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

    //For Sales Header

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", OnBeforeCheckSalesApprovalPossible, '', false, false)]
    local procedure "Approvals Mgmt._OnBeforeCheckSalesApprovalPossible"(var SalesHeader: Record "Sales Header"; var Result: Boolean; var IsHandled: Boolean)
    var
    begin
        RunFieldmandatorycheckSales(SalesHeader);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Release Sales Document", OnBeforeReleaseSalesDoc, '', false, false)]
    local procedure "Release Sales Document_OnBeforeReleaseSalesDoc"(var SalesHeader: Record "Sales Header"; PreviewMode: Boolean; var IsHandled: Boolean; var SkipCheckReleaseRestrictions: Boolean; SkipWhseRequestOperations: Boolean)
    begin
        RunFieldmandatorycheckSales(SalesHeader);
    end;


    // [EventSubscriber(ObjectType::Codeunit, Codeunit::"Release Sales Document", OnBeforeManualReleaseSalesDoc, '', false, false)]
    // local procedure "Release Sales Document_OnBeforeManualReleaseSalesDoc"(var SalesHeader: Record "Sales Header"; PreviewMode: Boolean)
    // begin
    //     RunFieldmandatorycheckSales(SalesHeader);
    // end;


    procedure RunFieldmandatorycheckSales(Var SalesHeader: Record "Sales Header")
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

        SalesHeaderDocNoFilter_lText := 'Field3=1(' + SalesHeader."No." + '))';
        SalesHeaderDocvType_lText := 'Field1=1(' + Format(SalesHeader."Document Type".AsInteger()) + ')';

        TemplateFound_lCode := '';
        FieldMandtempSetup_lRec.Reset();
        FieldMandtempSetup_lRec.SetRange("Record Type", FieldMandtempSetup_lRec."Record Type"::"Sales Document");
        FieldMandtempSetup_lRec.SetRange(Enabled, true);
        FieldMandtempSetup_lRec.SetRange("Table Id", Database::"Sales Header");
        If FieldMandtempSetup_lRec.FindSet() then
            repeat
                Clear(ConditionFilter_lText);
                ConditionFilter_lText := CopyStr(GetConditionAsDisplayText(FieldMandtempSetup_lRec), 1, StrLen(GetConditionAsDisplayText(FieldMandtempSetup_lRec)));
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

        // if TemplateFound_lCode = '' then
        //     Error('Configuration Template must have value in Field Mandatory Template Setup for ID: %1', TemplateFound_lInt);

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

    //For Purchase Header
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", OnBeforeCheckPurchaseApprovalPossible, '', false, false)]
    local procedure "Approvals Mgmt._OnBeforeCheckPurchaseApprovalPossible"(var PurchaseHeader: Record "Purchase Header"; var Result: Boolean; var IsHandled: Boolean)
    begin
        RunFieldmandatorycheckPurchase(PurchaseHeader);
    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Release Purchase Document", OnBeforeReleasePurchaseDoc, '', false, false)]
    local procedure "Release Purchase Document_OnBeforeReleasePurchaseDoc"(var PurchaseHeader: Record "Purchase Header"; PreviewMode: Boolean; var SkipCheckReleaseRestrictions: Boolean; var IsHandled: Boolean; SkipWhseRequestOperations: Boolean)
    begin
        RunFieldmandatorycheckPurchase(PurchaseHeader);
    end;

    procedure RunFieldmandatorycheckPurchase(var PurchaseHeader: Record "Purchase Header")
    var
        //FieldMandatorySetup_lRec: Record "Field Mandatory Setup";
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

        PurchaseHeaderDocNoFilter_lText := 'Field3=1(' + PurchaseHeader."No." + '))';
        PurchaseHeaderDocTypeFilter_lText := 'Field1=1(' + FORMAT(PurchaseHeader."Document Type".AsInteger()) + ')';

        TemplateFound_lCode := '';
        FieldMandtempSetup_lRec.Reset();
        FieldMandtempSetup_lRec.SetRange("Record Type", FieldMandtempSetup_lRec."Record Type"::"Purchase Document");
        FieldMandtempSetup_lRec.SetRange(Enabled, true);
        FieldMandtempSetup_lRec.SetRange("Table Id", Database::"Purchase Header");
        If FieldMandtempSetup_lRec.FindSet() then
            repeat
                Clear(ConditionFilter_lText);
                ConditionFilter_lText := CopyStr(GetConditionAsDisplayText(FieldMandtempSetup_lRec), 1, StrLen(GetConditionAsDisplayText(FieldMandtempSetup_lRec)));
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

        // if TemplateFound_lCode = '' then
        //     Error('Configuration Template must have value in Field Mandatory Template Setup for ID: %1', TemplateFound_lInt);

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
            // exit(ExitMsg);
            exit('');

        FieldMandtempSetup_lRec.Condition.CreateInStream(IStream);
        IStream.Read(COnditionText);
        COnditionText := CopyStr(COnditionText, 1, StrLen(COnditionText) - 1);
        COnditionText := COnditionText + ',';
        exit(COnditionText);
    end;
    //T12141-NE
}