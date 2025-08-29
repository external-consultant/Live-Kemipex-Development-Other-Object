pageextension 50014 PurchaseOrder_P50014 extends "Purchase Order"
{
    layout
    {
        //T12141-NS
        addlast(General)
        {

            // field("Due Date Calculation Type"; Rec."Due Date Calculation Type")
            // {
            //     ApplicationArea = All;
            //     ToolTip = 'Specifies the value of the Due Date Calculation Type field.', Comment = '%';
            // }
            // field("QC Date"; Rec."QC Date")
            // {
            //     ApplicationArea = All;
            //     ToolTip = 'Specifies the value of the QC Date field.', Comment = '%';
            // }
            // field("Bill of Lading Date"; Rec."Bill of Lading Date")
            // {
            //     ApplicationArea = All;
            //     ToolTip = 'Specifies the value of the Bill of Lading Date field.', Comment = '%';
            // }
            // field("Delivery Date"; Rec."Delivery Date")
            // {
            //     ApplicationArea = All;
            //     Visible = true;
            //     ToolTip = 'Specifies the value of the Delivery Date field.', Comment = '%';
            // }
            // field("Document Submission Date"; Rec."Document Submission Date")
            // {
            //     ApplicationArea = All;
            //     ToolTip = 'Specifies the value of the Document Submission Date field.', Comment = '%';
            // }

            // field("Incoterm Charges Amount"; Rec."Incoterm Charges Amount") //T12937-as per UAT need to close
            // {
            //     ApplicationArea = All;
            //     ToolTip = 'Specifies the value of the Incoterm Charges Amount field.', Comment = '%';
            //     Editable = false;
            //     trigger OnDrillDown()
            //     var
            //         IncoCharge_lRec: Record "Document Incoterms and Charges";
            //         InCoCharge_lPge: Page "Document Incoterms and Charges";
            //     begin
            //         IncoCharge_lRec.Reset();
            //         IncoCharge_lRec.SetRange("Transaction Type", IncoCharge_lRec."Transaction Type"::Purchase);
            //         IncoCharge_lRec.SetRange("Document Type", Rec."Document Type");
            //         IncoCharge_lRec.SetRange("Document No.", Rec."No.");
            //         InCoCharge_lPge.SetTableView(InCoCharge_lRec);
            //         InCoCharge_lPge.Editable(false);
            //         InCoCharge_lPge.Run();
            //     end;
            // }

            field("First Approval Completed"; Rec."First Approval Completed")
            {
                ApplicationArea = All;
                Visible = false;
                ToolTip = 'Specifies the value of the First Approval Completed field.', Comment = '%';
                Description = 'T12141';
            }
        }
        addlast("Shipping and Payment")
        {
            group("Logistic Details")
            {
                field("Vehicle No_New"; Rec."Vehicle No_New")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Vehicle No field.', Comment = '%';
                }
                field("Container Code"; Rec."Container Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Container Code field.', Comment = '%';
                }
                field("Container Plat No."; Rec."Container Plat No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Container Plat No. field.', Comment = '%';
                }
                field("Container Seal No."; Rec."Container Seal No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Container Seal No. field.', Comment = '%';
                }
            }
        }
        addafter("Location Code")
        {
            field("Location Change Remarks"; rec."Location Change Remarks")//T12436-N
            {
                ApplicationArea = All;
            }
        }
        addafter(PurchLines)
        {
            //T12539-NS
            part("Multiple Payment Terms Subform"; "Multiple Payment Terms Subform")
            {
                ApplicationArea = All;
                SubPageLink = "Table ID" = const(38), "Document No." = field("No."), "Document Type" = filter(Order), Type = const(Purchase);
                UpdatePropagation = Both;
                Editable = IsPurchLinesEditable;
                Enabled = CheckStatus;
            }
            //T12539-NE
        }
    }
    //T12141-NE

    actions
    {
        addlast(processing)
        {
            action("Link to Sales Order")
            {
                ApplicationArea = All;
                Image = LinkAccount;

                trigger OnAction()
                var
                    SalesHdr: Record "Sales Header";
                    SalesOrdLt_lPge: Page "Sales Order List";
                    PurchOrdMgmt: Codeunit PurchOrderMgmt;
                    SalesLn: Record "Sales Line";
                begin
                    SalesHdr.Reset();
                    SalesHdr.SetRange("Document Type", SalesHdr."Document Type"::Order);

                    Clear(SalesOrdLt_lPge);
                    SalesOrdLt_lPge.LookupMode := true;
                    SalesOrdLt_lPge.SetTableView(SalesHdr);
                    SalesOrdLt_lPge.SetRecord(SalesHdr);
                    if SalesOrdLt_lPge.RunModal() = Action::LookupOK then begin
                        SalesOrdLt_lPge.GetRecord(SalesHdr);

                        //Add Validation
                        SalesLn.Reset();
                        SalesLn.SetRange("Document Type", SalesHdr."Document Type");
                        SalesLn.SetRange("Document No.", SalesHdr."No.");
                        SalesLn.SetFilter("Purchase Order No.", '<>%1', '');
                        if SalesLn.FindFirst() then
                            Error('Sales Order %1 already link with Purchase Order %2', SalesHdr."No.", SalesLn."Purchase Order No.");


                        Clear(PurchOrdMgmt);
                        PurchOrdMgmt.LinkSalesOrder(Rec, SalesHdr);
                    end;
                end;
            }
            //T12141-NS
            // action("Incoterms and Charges") //T12937-as per UAT need to close
            // {
            //     ApplicationArea = all;
            //     Image = AssessFinanceCharges;
            //     trigger OnAction()
            //     var
            //         InCoCharge_lRec: Record "Document Incoterms and Charges";
            //         InCoCharge_lPge: Page "Document Incoterms and Charges";
            //     begin
            //         InCoCharge_lRec.Reset();
            //         // InCoCharge_lRec.FilterGroup(2);
            //         InCoCharge_lRec.SetRange("Transaction Type", InCoCharge_lRec."Transaction Type"::Purchase);
            //         InCoCharge_lRec.SetRange("Document Type", rec."Document Type");
            //         InCoCharge_lRec.SetRange("Document No.", Rec."No.");
            //         // InCoCharge_lRec.FilterGroup(0);
            //         InCoCharge_lPge.SetTableView(InCoCharge_lRec);
            //         InCoCharge_lPge.Editable(true);
            //         InCoCharge_lPge.Run();
            //     end;
            //     //T12141-NE
            // }
        }
    }
    //T12141-NS

    //trigger OnAfterGetRecord()
    //var
    // IncoCharge_lRec: Record "Incoterms and Charges";
    // begin
    // LastDate_gDte := 0D;
    // IncoChargeItem_gDec := 0;
    // IncoCharge_lRec.Reset();
    // InCoCharge_lRec.SetRange("Inco Term Code", Rec."Shipment Method Code");
    // InCoCharge_lRec.SetRange("Location Code", Rec."Location Code");
    // InCoCharge_lRec.SetRange("Vendor No.", Rec."Buy-from Vendor No.");
    // IncoCharge_lRec.SetFilter("Starting Date", '<=%1', Rec."Document Date");
    // if IncoCharge_lRec.FindLast() then
    //     LastDate_gDte := IncoCharge_lRec."Starting Date";

    // IncoCharge_lRec.Reset();
    // InCoCharge_lRec.SetRange("Inco Term Code", Rec."Shipment Method Code");
    // InCoCharge_lRec.SetRange("Location Code", Rec."Location Code");
    // InCoCharge_lRec.SetRange("Vendor No.", Rec."Buy-from Vendor No.");
    // IncoCharge_lRec.SetFilter("Starting Date", '%1', LastDate_gDte);
    // if IncoCharge_lRec.FindSet() then
    //     repeat
    //         IncoChargeItem_gDec += IncoCharge_lRec."Expected Charge Amount";
    //     until IncoCharge_lRec.Next() = 0;
    // Rec."Incoterm Charges Amount" := IncoChargeItem_gDec;
    //end;
    //T12141-NE
    var
        LastDate_gDte: Date;
        IncoChargeItem_gDec: Decimal;

    trigger OnAfterGetRecord()
    var
        myInt: Integer;
    begin
        //T12539-NS
        IsPurchLinesEditable := Rec.PurchaseLinesEditable();

        If Rec.Status = Rec.Status::Released then
            CheckStatus := false
        else
            CheckStatus := true;
        //T12539-NE
    end;

    var
        IsPurchLinesEditable: Boolean;//T12539-N
        CheckStatus: Boolean;//T12539-N

}
