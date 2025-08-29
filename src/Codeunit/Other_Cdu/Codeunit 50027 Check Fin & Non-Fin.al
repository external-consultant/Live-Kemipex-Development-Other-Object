codeunit 50027 "Check Fin & Non-Fin"
{
    trigger OnRun()
    begin

    end;


    //For Customer Financial Fields
    [EventSubscriber(ObjectType::Table, Database::Customer, 'OnAfterValidateEvent', 'Payment Terms Code', true, true)]
    local procedure Customer_OnAfterValidateEvent_PaymentTermsCode(var Rec: Record Customer; var xRec: Record Customer; CurrFieldNo: Integer)
    var
        CategoryType: Code[10];
    begin
        If Rec.IsTemporary then
            exit;

        if not Rec."First Approval Completed" then
            exit;

        if CurrFieldNo <> Rec.FieldNo("Payment Terms Code") then
            exit;

        CategoryType := UpdateWorkflow('Financial', Rec."Workflow Category Type");

        if Rec."Workflow Category Type" <> CategoryType then begin
            Rec."Workflow Category Type" := CategoryType;
            Rec.Modify();
        end;
    end;

    //For Customer Non-Financial Fields
    [EventSubscriber(ObjectType::Table, Database::Customer, 'OnAfterValidateEvent', 'E-Mail', true, true)]
    local procedure Customer_OnAfterValidateEvent_EMail(var Rec: Record Customer; var xRec: Record Customer; CurrFieldNo: Integer)
    var
        CategoryType: Code[10];
    begin
        If Rec.IsTemporary then
            exit;

        if not Rec."First Approval Completed" then
            exit;

        if CurrFieldNo <> Rec.FieldNo("E-Mail") then
            exit;

        CategoryType := UpdateWorkflow('Non-Financial', Rec."Workflow Category Type");

        if Rec."Workflow Category Type" <> CategoryType then begin
            Rec."Workflow Category Type" := CategoryType;
            Rec.Modify();
        end;
    end;

    //For Vendor Financial Fields
    [EventSubscriber(ObjectType::Table, Database::Vendor, 'OnAfterValidateEvent', 'Payment Terms Code', true, true)]
    local procedure Vendor_OnAfterValidateEvent_PaymentTermsCode(var Rec: Record Vendor; var xRec: Record Vendor; CurrFieldNo: Integer)
    var
        CategoryType: Code[10];
    begin
        If Rec.IsTemporary then
            exit;

        if not Rec."First Approval Completed" then
            exit;

        if CurrFieldNo <> Rec.FieldNo("Payment Terms Code") then
            exit;

        CategoryType := UpdateWorkflow('Financial', Rec."Workflow Category Type");

        if Rec."Workflow Category Type" <> CategoryType then begin
            Rec."Workflow Category Type" := CategoryType;
            Rec.Modify();
        end;
    end;

    //For Vendor Non-Financial Fields
    [EventSubscriber(ObjectType::Table, Database::Vendor, 'OnAfterValidateEvent', 'E-Mail', true, true)]
    local procedure Vendor_OnAfterValidateEvent_EMail(var Rec: Record Vendor; var xRec: Record Vendor; CurrFieldNo: Integer)
    var
        CategoryType: Code[10];
    begin
        If Rec.IsTemporary then
            exit;

        if not Rec."First Approval Completed" then
            exit;

        if CurrFieldNo <> Rec.FieldNo("E-Mail") then
            exit;

        CategoryType := UpdateWorkflow('Non-Financial', Rec."Workflow Category Type");

        if Rec."Workflow Category Type" <> CategoryType then begin
            Rec."Workflow Category Type" := CategoryType;
            Rec.Modify();
        end;
    end;

    //For Item Financial Fields
    [EventSubscriber(ObjectType::Table, Database::Item, 'OnAfterValidateEvent', 'Unit Cost', true, true)]
    local procedure Item_OnAfterValidateEvent_UnitCost(var Rec: Record Item; var xRec: Record Item; CurrFieldNo: Integer)
    var
        CategoryType: Code[10];
    begin
        If Rec.IsTemporary then
            exit;

        if not Rec."First Approval Completed" then
            exit;

        if CurrFieldNo <> Rec.FieldNo("Unit Cost") then
            exit;

        CategoryType := UpdateWorkflow('Financial', Rec."Workflow Category Type");

        if Rec."Workflow Category Type" <> CategoryType then begin
            Rec."Workflow Category Type" := CategoryType;
            Rec.Modify();
        end;
    end;

    //For Item Non-Financial Fields
    [EventSubscriber(ObjectType::Table, Database::Item, 'OnAfterValidateEvent', 'Description', true, true)]
    local procedure Item_OnAfterValidateEvent_Description(var Rec: Record Item; var xRec: Record Item; CurrFieldNo: Integer)
    var
        CategoryType: Code[10];
    begin
        If Rec.IsTemporary then
            exit;

        if not Rec."First Approval Completed" then
            exit;

        if CurrFieldNo <> Rec.FieldNo(Description) then
            exit;

        CategoryType := UpdateWorkflow('Non-Financial', Rec."Workflow Category Type");

        if Rec."Workflow Category Type" <> CategoryType then begin
            Rec."Workflow Category Type" := CategoryType;
            Rec.Modify();
        end;
    end;

    //For Sales Header Financial Fields
    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnAfterValidateEvent', 'Payment Terms Code', true, true)]
    local procedure SalesHeader_OnAfterValidateEvent_PaymentTermsCode(var Rec: Record "Sales Header"; var xRec: Record "Sales Header"; CurrFieldNo: Integer)
    var
        CategoryType: Code[10];
    begin
        If Rec.IsTemporary then
            exit;

        if not Rec."First Approval Completed" then
            exit;

        if CurrFieldNo <> Rec.FieldNo("Payment Terms Code") then
            exit;

        CategoryType := UpdateWorkflow('Financial', Rec."Workflow Category Type");

        if Rec."Workflow Category Type" <> CategoryType then begin
            Rec."Workflow Category Type" := CategoryType;
            Rec.Modify();
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnAfterValidateEvent', 'Payment Discount %', true, true)]
    local procedure SalesHeader_OnAfterValidateEvent_PaymentDiscount(var Rec: Record "Sales Header"; var xRec: Record "Sales Header"; CurrFieldNo: Integer)
    var
        CategoryType: Code[10];
    begin
        If Rec.IsTemporary then
            exit;

        if not Rec."First Approval Completed" then
            exit;

        if CurrFieldNo <> Rec.FieldNo("Payment Discount %") then
            exit;

        CategoryType := UpdateWorkflow('Financial', Rec."Workflow Category Type");

        if Rec."Workflow Category Type" <> CategoryType then begin
            Rec."Workflow Category Type" := CategoryType;
            Rec.Modify();
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnAfterValidateEvent', 'Sell-to Customer No.', true, true)]
    local procedure SalesHeader_OnAfterValidateEvent_BilltoCustomerNo(var Rec: Record "Sales Header"; var xRec: Record "Sales Header"; CurrFieldNo: Integer)
    var
        CategoryType: Code[10];
    begin
        If Rec.IsTemporary then
            exit;

        if not Rec."First Approval Completed" then
            exit;

        if CurrFieldNo <> Rec.FieldNo("Sell-to Customer No.") then
            exit;

        CategoryType := UpdateWorkflow('Financial', Rec."Workflow Category Type");

        if Rec."Workflow Category Type" <> CategoryType then begin
            Rec."Workflow Category Type" := CategoryType;
            Rec.Modify();
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnAfterValidateEvent', 'Sell-to Customer Name', true, true)]
    local procedure SalesHeader_OnAfterValidateEvent_SelltoCustomerName(var Rec: Record "Sales Header"; var xRec: Record "Sales Header"; CurrFieldNo: Integer)
    var
        CategoryType: Code[10];
    begin
        If Rec.IsTemporary then
            exit;

        if not Rec."First Approval Completed" then
            exit;

        if CurrFieldNo <> Rec.FieldNo("Sell-to Customer Name") then
            exit;

        CategoryType := UpdateWorkflow('Financial', Rec."Workflow Category Type");

        if Rec."Workflow Category Type" <> CategoryType then begin
            Rec."Workflow Category Type" := CategoryType;
            Rec.Modify();
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnAfterValidateEvent', 'Due Date', true, true)]
    local procedure SalesHeader_OnAfterValidateEvent_DueDate(var Rec: Record "Sales Header"; var xRec: Record "Sales Header"; CurrFieldNo: Integer)
    var
        CategoryType: Code[10];
    begin
        If Rec.IsTemporary then
            exit;

        if not Rec."First Approval Completed" then
            exit;

        if CurrFieldNo <> Rec.FieldNo("Due Date") then
            exit;

        CategoryType := UpdateWorkflow('Financial', Rec."Workflow Category Type");

        if Rec."Workflow Category Type" <> CategoryType then begin
            Rec."Workflow Category Type" := CategoryType;
            Rec.Modify();
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnAfterValidateEvent', 'Currency Code', true, true)]
    local procedure SalesHeader_OnAfterValidateEvent_Currencycode(var Rec: Record "Sales Header"; var xRec: Record "Sales Header"; CurrFieldNo: Integer)
    var
        CategoryType: Code[10];
    begin
        If Rec.IsTemporary then
            exit;

        if not Rec."First Approval Completed" then
            exit;

        if CurrFieldNo <> Rec.FieldNo("Currency Code") then
            exit;

        CategoryType := UpdateWorkflow('Financial', Rec."Workflow Category Type");

        if Rec."Workflow Category Type" <> CategoryType then begin
            Rec."Workflow Category Type" := CategoryType;
            Rec.Modify();
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnAfterValidateEvent', 'Location Code', true, true)]
    local procedure SalesHeader_OnAfterValidateEvent_Locationcode(var Rec: Record "Sales Header"; var xRec: Record "Sales Header"; CurrFieldNo: Integer)
    var
        CategoryType: Code[10];
        Loc_lRec: Record Location;//12475-N

    begin
        If Rec.IsTemporary then
            exit;
        //T12475-NS
        if Rec."Location Code" <> xRec."Location Code" then begin
            if Loc_lRec.Get(Rec."Location Code") then begin
                Loc_lRec.TestField("Location Category");
                Rec."Location Category" := Loc_lRec."Location Category";
                Rec."Last Location Category" := xRec."Location Category";
            end;
        end;
        //T12475-NE     

        //T12475-OS
        // if not Rec."First Approval Completed" then
        //     exit;
        //T12475-OE

        if Rec."First Approval Completed" then begin//T12475-N 
            if CurrFieldNo <> Rec.FieldNo("Location Code") then
                exit;
            if rec."Location Category" <> rec."Last Location Category" then
                rec."Workflow Category Type" := '1'
            else
                rec."Workflow Category Type" := '2';
            //18-11-2024 Rec.Modify();

            //T12475-OS //18-11-2024-NS
            CategoryType := UpdateWorkflow('Financial', Rec."Workflow Category Type");
            if Rec."Workflow Category Type" <> CategoryType then begin
                Rec."Workflow Category Type" := CategoryType;
                Rec.Modify();
            end;
            //T12475-OE //18-11-2024-NE
        end;//T12475-N
    end;
    //12475-NS
    [EventSubscriber(ObjectType::Table, Database::"Sales Line", 'OnAfterValidateEvent', 'Location Code', true, true)]
    local procedure SalesLine_OnAfterValidateEvent_Locationcode(var Rec: Record "Sales Line"; var xRec: Record "Sales Line"; CurrFieldNo: Integer)
    var
        CategoryType: Code[10];
        Loc_lRec: Record Location;
        Sh_lRec: Record "Sales Header";

    begin
        If Rec.IsTemporary then
            exit;
        //T12475-NS
        if Rec."Location Code" <> xRec."Location Code" then begin
            if Loc_lRec.Get(Rec."Location Code") then begin
                Loc_lRec.TestField("Location Category");
                Rec."Location Category" := Loc_lRec."Location Category";
                Rec."Last Location Category" := xRec."Location Category";
            end;
        end;
        //T12475-NE     

        //T12475-OS
        // if not Rec."First Approval Completed" then
        //     exit;
        //T12475-OE
        if Sh_lRec.Get(Rec."Document Type", Rec."Document No.") then begin
            if Sh_lRec."First Approval Completed" then begin//T12475-N 
                if CurrFieldNo <> Rec.FieldNo("Location Code") then
                    exit;
                if rec."Location Category" <> rec."Last Location Category" then
                    Sh_lRec."Workflow Category Type" := '1'
                else
                    Sh_lRec."Workflow Category Type" := '2';
                Sh_lRec.Modify();
                //18-11-2024 Rec.Modify();

                //T12475-OS //18-11-2024-NS
                CategoryType := UpdateWorkflow('Financial', Sh_lRec."Workflow Category Type");
                if Sh_lRec."Workflow Category Type" <> CategoryType then begin
                    Sh_lRec."Workflow Category Type" := CategoryType;
                    Sh_lRec.Modify();
                end;
                //T12475-OE //18-11-2024-NE
            end;
        end;

        //T12475-N
    end;
    //12475-NE

    [EventSubscriber(ObjectType::Table, Database::"Purchase Line", 'OnAfterValidateEvent', 'Location Code', true, true)]
    local procedure PurchaseLine_OnAfterValidateEvent_Locationcode(var Rec: Record "Purchase Line"; var xRec: Record "Purchase Line"; CurrFieldNo: Integer)
    var
        CategoryType: Code[10];
        Loc_lRec: Record Location;
        Ph_lRec: Record "Purchase Header";

    begin
        If Rec.IsTemporary then
            exit;
        //T12475-NS
        if Rec."Location Code" <> xRec."Location Code" then begin
            if Loc_lRec.Get(Rec."Location Code") then begin
                Loc_lRec.TestField("Location Category");
                Rec."Location Category" := Loc_lRec."Location Category";
                Rec."Last Location Category" := xRec."Location Category";
            end;
        end;
        //T12475-NE     

        //T12475-OS
        // if not Rec."First Approval Completed" then
        //     exit;
        //T12475-OE
        if Ph_lRec.Get(Rec."Document Type", Rec."Document No.") then begin
            if Ph_lRec."First Approval Completed" then begin//T12475-N 
                if CurrFieldNo <> Rec.FieldNo("Location Code") then
                    exit;
                if rec."Location Category" <> rec."Last Location Category" then
                    Ph_lRec."Workflow Category Type" := '1'
                else
                    Ph_lRec."Workflow Category Type" := '2';
                Ph_lRec.Modify();
                //18-11-2024 Rec.Modify();

                //T12475-OS //18-11-2024-NS
                CategoryType := UpdateWorkflow('Financial', Ph_lRec."Workflow Category Type");
                if Ph_lRec."Workflow Category Type" <> CategoryType then begin
                    Ph_lRec."Workflow Category Type" := CategoryType;
                    Ph_lRec.Modify();
                end;
                //T12475-OE //18-11-2024-NE
            end;
        end;

        //T12475-N
    end;
    //12475-NE

    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnAfterValidateEvent', 'Charge Group Code', true, true)]
    local procedure SalesHeader_OnAfterValidateEvent_ChargeGroupCode(var Rec: Record "Sales Header"; var xRec: Record "Sales Header"; CurrFieldNo: Integer)
    var
        CategoryType: Code[10];
    begin
        If Rec.IsTemporary then
            exit;

        if not Rec."First Approval Completed" then
            exit;

        if CurrFieldNo <> Rec.FieldNo("Charge Group Code") then
            exit;

        CategoryType := UpdateWorkflow('Financial', Rec."Workflow Category Type");

        if Rec."Workflow Category Type" <> CategoryType then begin
            Rec."Workflow Category Type" := CategoryType;
            Rec.Modify();
        end;
    end;


    //For Sales Header Non-Financial Fields
    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnAfterValidateEvent', 'Sell-to E-Mail', true, true)]
    local procedure SalesHeader_OnAfterValidateEvent_EMail(var Rec: Record "Sales Header"; var xRec: Record "Sales Header"; CurrFieldNo: Integer)
    var
        CategoryType: Code[10];
    begin
        If Rec.IsTemporary then
            exit;

        if not Rec."First Approval Completed" then
            exit;

        if CurrFieldNo <> Rec.FieldNo("Sell-to E-Mail") then
            exit;

        CategoryType := UpdateWorkflow('Non-Financial', Rec."Workflow Category Type");

        if Rec."Workflow Category Type" <> CategoryType then begin
            Rec."Workflow Category Type" := CategoryType;
            Rec.Modify();
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnAfterValidateEvent', 'Sell-to Phone No.', true, true)]
    local procedure SalesHeader_OnAfterValidateEvent_PhoneNo(var Rec: Record "Sales Header"; var xRec: Record "Sales Header"; CurrFieldNo: Integer)
    var
        CategoryType: Code[10];
    begin
        If Rec.IsTemporary then
            exit;

        if not Rec."First Approval Completed" then
            exit;

        if CurrFieldNo <> Rec.FieldNo("Sell-to Phone No.") then
            exit;

        CategoryType := UpdateWorkflow('Non-Financial', Rec."Workflow Category Type");

        if Rec."Workflow Category Type" <> CategoryType then begin
            Rec."Workflow Category Type" := CategoryType;
            Rec.Modify();
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnAfterValidateEvent', 'Sell-to Address', true, true)]
    local procedure SalesHeader_OnAfterValidateEvent_Address(var Rec: Record "Sales Header"; var xRec: Record "Sales Header"; CurrFieldNo: Integer)
    var
        CategoryType: Code[10];
    begin
        If Rec.IsTemporary then
            exit;

        if not Rec."First Approval Completed" then
            exit;

        if CurrFieldNo <> Rec.FieldNo("Sell-to Address") then
            exit;

        CategoryType := UpdateWorkflow('Non-Financial', Rec."Workflow Category Type");

        if Rec."Workflow Category Type" <> CategoryType then begin
            Rec."Workflow Category Type" := CategoryType;
            Rec.Modify();
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnAfterValidateEvent', 'Sell-to Address 2', true, true)]
    local procedure SalesHeader_OnAfterValidateEvent_Address2(var Rec: Record "Sales Header"; var xRec: Record "Sales Header"; CurrFieldNo: Integer)
    var
        CategoryType: Code[10];
    begin
        If Rec.IsTemporary then
            exit;

        if not Rec."First Approval Completed" then
            exit;

        if CurrFieldNo <> Rec.FieldNo("Sell-to Address 2") then
            exit;

        CategoryType := UpdateWorkflow('Non-Financial', Rec."Workflow Category Type");

        if Rec."Workflow Category Type" <> CategoryType then begin
            Rec."Workflow Category Type" := CategoryType;
            Rec.Modify();
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnAfterValidateEvent', 'External Document No.', true, true)]
    local procedure SalesHeader_OnAfterValidateEvent_ExtDocNo(var Rec: Record "Sales Header"; var xRec: Record "Sales Header"; CurrFieldNo: Integer)
    var
        CategoryType: Code[10];
    begin
        If Rec.IsTemporary then
            exit;

        if not Rec."First Approval Completed" then
            exit;

        if CurrFieldNo <> Rec.FieldNo("External Document No.") then
            exit;

        CategoryType := UpdateWorkflow('Non-Financial', Rec."Workflow Category Type");

        if Rec."Workflow Category Type" <> CategoryType then begin
            Rec."Workflow Category Type" := CategoryType;
            Rec.Modify();
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnAfterValidateEvent', 'Shipment Method Code', true, true)]
    local procedure SalesHeader_OnAfterValidateEvent_ShipmentMethodcode(var Rec: Record "Sales Header"; var xRec: Record "Sales Header"; CurrFieldNo: Integer)
    var
        CategoryType: Code[10];
    begin
        If Rec.IsTemporary then
            exit;

        if not Rec."First Approval Completed" then
            exit;

        if CurrFieldNo <> Rec.FieldNo("Shipment Method Code") then
            exit;

        CategoryType := UpdateWorkflow('Non-Financial', Rec."Workflow Category Type");

        if Rec."Workflow Category Type" <> CategoryType then begin
            Rec."Workflow Category Type" := CategoryType;
            Rec.Modify();
        end;
    end;

    [EventSubscriber(ObjectType::Page, Page::"Sales Order", OnAfterValidateShippingOptions, '', false, false)]
    local procedure "Sales Order_OnAfterValidateShippingOptions"(var SalesHeader: Record "Sales Header"; ShipToOptions: Option)
    var
        CategoryType: Code[10];
    begin
        If SalesHeader.IsTemporary then
            exit;

        if not SalesHeader."First Approval Completed" then
            exit;


        CategoryType := UpdateWorkflow('Non-Financial', SalesHeader."Workflow Category Type");

        if SalesHeader."Workflow Category Type" <> CategoryType then begin
            SalesHeader."Workflow Category Type" := CategoryType;
            SalesHeader.Modify();
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Header", OnAfterCopySellToAddressToBillToAddress, '', false, false)]
    local procedure "Sales Header_OnAfterCopySellToAddressToBillToAddress"(var SalesHeader: Record "Sales Header")
    var
        CategoryType: Code[10];
    begin
        If SalesHeader.IsTemporary then
            exit;

        if not SalesHeader."First Approval Completed" then
            exit;

        CategoryType := UpdateWorkflow('Non-Financial', SalesHeader."Workflow Category Type");

        if SalesHeader."Workflow Category Type" <> CategoryType then begin
            SalesHeader."Workflow Category Type" := CategoryType;
            SalesHeader.Modify();
        end;
    end;


    // For Sales Line Financial Fields
    // [EventSubscriber(ObjectType::Table, Database::"Sales Line", 'OnAfterValidateEvent', 'Location Code', true, true)]
    // local procedure SalesLine_OnAfterValidateEvent_Locationcode(var Rec: Record "Sales Line"; var xRec: Record "Sales Line"; CurrFieldNo: Integer)
    // var
    //     CategoryType: Code[10];
    //     Saleshead_lRec: Record "Sales Header";
    //     Location_lRec: Record Location;//12475-N
    // begin
    //     If Rec.IsTemporary then
    //         exit;
    //     Saleshead_lRec.Get(rec."Document Type", Rec."Document No.");

    //     if not Saleshead_lRec."First Approval Completed" then
    //         exit;

    //     if CurrFieldNo <> Rec.FieldNo("Location Code") then
    //         exit;


    //     CategoryType := UpdateWorkflow('Financial', Saleshead_lRec."Workflow Category Type");

    //     if Saleshead_lRec."Workflow Category Type" <> CategoryType then begin
    //         Saleshead_lRec."Workflow Category Type" := CategoryType;
    //         Saleshead_lRec.Modify();
    //     end;
    // end;

    //For Purchase Header Financial Fields
    //18-11-2024-NS
    [EventSubscriber(ObjectType::Table, Database::"Purchase Header", 'OnAfterValidateEvent', 'Location Code', true, true)]
    local procedure PurchaseHeader_OnAfterValidateEvent_Locationcode(var Rec: Record "Purchase Header"; var xRec: Record "Purchase Header"; CurrFieldNo: Integer)
    var
        CategoryType: Code[10];
        Loc_lRec: Record Location;//12475-N
    begin
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
            if CurrFieldNo <> Rec.FieldNo("Location Code") then
                exit;
            if rec."Location Category" <> rec."Last Location Category" then
                rec."Workflow Category Type" := '1'
            else
                rec."Workflow Category Type" := '2';
            CategoryType := UpdateWorkflow('Financial', Rec."Workflow Category Type");
            if Rec."Workflow Category Type" <> CategoryType then begin
                Rec."Workflow Category Type" := CategoryType;
                Rec.Modify();
            end;
        end;
    end;
    //18-11-2024-NE


    [EventSubscriber(ObjectType::Table, Database::"Purchase Header", 'OnAfterValidateEvent', 'Payment Terms Code', true, true)]
    local procedure PurchaseHeader_OnAfterValidateEvent_PaymentTermsCode(var Rec: Record "Purchase Header"; var xRec: Record "Purchase Header"; CurrFieldNo: Integer)
    var
        CategoryType: Code[10];
    begin
        If Rec.IsTemporary then
            exit;

        if not Rec."First Approval Completed" then
            exit;

        if CurrFieldNo <> Rec.FieldNo("Payment Terms Code") then
            exit;

        CategoryType := UpdateWorkflow('Financial', Rec."Workflow Category Type");

        if Rec."Workflow Category Type" <> CategoryType then begin
            Rec."Workflow Category Type" := CategoryType;
            Rec.Modify();
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Purchase Header", 'OnAfterValidateEvent', 'Payment Discount %', true, true)]
    local procedure PurchaseHeader_OnAfterValidateEvent_PaymentDiscount(var Rec: Record "Purchase Header"; var xRec: Record "Purchase Header"; CurrFieldNo: Integer)
    var
        CategoryType: Code[10];
    begin
        If Rec.IsTemporary then
            exit;

        if not Rec."First Approval Completed" then
            exit;

        if CurrFieldNo <> Rec.FieldNo("Payment Discount %") then
            exit;

        CategoryType := UpdateWorkflow('Financial', Rec."Workflow Category Type");

        if Rec."Workflow Category Type" <> CategoryType then begin
            Rec."Workflow Category Type" := CategoryType;
            Rec.Modify();
        end;
    end;

    //For Purchase Header Non-Financial Fields
    [EventSubscriber(ObjectType::Table, Database::"Purchase Header", 'OnAfterValidateEvent', "Buy-from Contact No.", true, true)]
    local procedure PurchaseHeader_OnAfterValidateEvent_EMail(var Rec: Record "Purchase Header"; var xRec: Record "Purchase Header"; CurrFieldNo: Integer)
    var
        CategoryType: Code[10];
    begin
        If Rec.IsTemporary then
            exit;

        if not Rec."First Approval Completed" then
            exit;

        if CurrFieldNo <> Rec.FieldNo("Buy-from Contact No.") then
            exit;

        CategoryType := UpdateWorkflow('Non-Financial', Rec."Workflow Category Type");

        if Rec."Workflow Category Type" <> CategoryType then begin
            Rec."Workflow Category Type" := CategoryType;
            Rec.Modify();
        end;
    end;
    //For Transfer Header Financial Fields
    // [EventSubscriber(ObjectType::Table, Database::"Transfer Header", 'OnAfterValidateEvent', "Transfer-from Code", true, true)]
    // local procedure TransferHeader_OnAfterValidateEvent_PaymentTermsCode(var Rec: Record "Transfer Header"; var xRec: Record "Transfer Header"; CurrFieldNo: Integer)
    // var
    //     CategoryType: Code[10];
    // begin
    //     If Rec.IsTemporary then
    //         exit;

    //     if not Rec."First Approval Completed" then
    //         exit;

    //     if CurrFieldNo <> Rec.FieldNo("Payment Terms Code") then
    //         exit;

    //     CategoryType := UpdateWorkflow('Financial', Rec."Workflow Category Type");

    //     if Rec."Workflow Category Type" <> CategoryType then begin
    //         Rec."Workflow Category Type" := CategoryType;
    //         Rec.Modify();
    //     end;
    // end;
    //For Transfer Header Financial Fields

    local procedure UpdateWorkflow(StatusType: Text; FinStatus: Text): Text
    begin
        If (StatusType = 'Financial') and (FinStatus = '1') then
            exit;

        If (StatusType = 'Non-Financial') and (FinStatus = '2') then
            exit;


        if (FinStatus = '1|2') then
            exit(FinStatus);

        If StatusType = 'Financial' then begin
            If FinStatus = '' then
                exit('1');
            if FinStatus = '2' then
                exit('1|2');
        end;

        If StatusType = 'Non-Financial' then begin
            If FinStatus = '' then
                exit('2');
            if FinStatus = '1' then
                exit('1|2');
        end;

    end;



    //UAT-NS 12-11-2024
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Copy Document Mgt.", OnAfterCopyPurchHeaderDone, '', false, false)]
    local procedure "Copy Document Mgt._OnAfterCopyPurchHeaderDone"(var ToPurchaseHeader: Record "Purchase Header"; OldPurchaseHeader: Record "Purchase Header"; FromPurchaseHeader: Record "Purchase Header"; FromPurchRcptHeader: Record "Purch. Rcpt. Header"; FromPurchInvHeader: Record "Purch. Inv. Header"; ReturnShipmentHeader: Record "Return Shipment Header"; FromPurchCrMemoHdr: Record "Purch. Cr. Memo Hdr."; FromPurchaseHeaderArchive: Record "Purchase Header Archive")
    begin
        if FromPurchaseHeader."First Approval Completed" then
            ToPurchaseHeader."First Approval Completed" := false;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Copy Document Mgt.", OnBeforeCopyPurchHeaderFromPurchHeader, '', false, false)]
    local procedure "Copy Document Mgt._OnBeforeCopyPurchHeaderFromPurchHeader"(FromDocType: Enum "Purchase Document Type From"; FromPurchHeader: Record "Purchase Header"; OldPurchHeader: Record "Purchase Header"; var ToPurchHeader: Record "Purchase Header"; var IsHandled: Boolean)
    begin
        if FromPurchHeader."First Approval Completed" then
            ToPurchHeader."First Approval Completed" := false;
        //ToPurchHeader."Location Change Remarks" := FromPurchHeader."Location Change Remarks";//Anoop
    end;
    //UAT-NE 12-11-2024
    //HyperCare Support-NS
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Blanket Purch. Order to Order", OnBeforePurchOrderHeaderModify, '', false, false)]
    local procedure "Blanket Purch. Order to Order_OnBeforePurchOrderHeaderModify"(var PurchOrderHeader: Record "Purchase Header"; BlanketOrderPurchHeader: Record "Purchase Header")
    begin
        if BlanketOrderPurchHeader."First Approval Completed" then
            PurchOrderHeader."First Approval Completed" := false;

    end;
    //HyperCare Support-NE



    var
        Statustype_lOpt: Option " ","Financial","Non-Financial";
}