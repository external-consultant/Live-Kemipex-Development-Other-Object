report 50002 "Create Purch Invoice Batch"
{
    ProcessingOnly = true;
    ApplicationArea = All;
    UsageCategory = ReportsAndAnalysis;
    Description = 'T12115-NS 21-06-2024';

    dataset
    {
        dataitem("Purch. Rcpt. Header"; "Purch. Rcpt. Header")
        {
            DataItemTableView = sorting("No.");
            RequestFilterFields = "No.";

            trigger OnAfterGetRecord()
            begin
                newInv_gCod := '';
                Clear(NewInv_lRec);
                NewInv_lRec.Init;
                NewInv_lRec.TransferFields(POHeader);
                NewInv_lRec."Document Type" := NewInv_lRec."document type"::Invoice;
                NewInv_lRec."No." := NoSeriesManagement_lCdu.GetNextNo(PurchasePayablesSetup."Invoice Nos.", Today, true);
                NewInv_lRec."No. Series" := newSeries_lCode;
                NewInv_lRec.Status := NewInv_lRec.Status::Open;
                NewInv_lRec.Insert(true);
                newInv_gCod := NewInv_lRec."No.";

                PurchRcptLine.Reset;
                PurchRcptLine.SetCurrentkey("Pay-to Vendor No.");
                PurchRcptLine.SetRange("Document No.", "No.");
                PurchRcptLine.SetRange("Pay-to Vendor No.", NewInv_lRec."Pay-to Vendor No.");
                PurchRcptLine.SetRange("Buy-from Vendor No.", NewInv_lRec."Buy-from Vendor No.");
                PurchRcptLine.SetFilter("Qty. Rcd. Not Invoiced", '<>0');
                PurchRcptLine.SetRange("Currency Code", NewInv_lRec."Currency Code");
                PurchRcptLine.SetRange("Buy-From GST Registration No", NewInv_lRec."Vendor GST Reg. No.");
                PurchRcptLine.SetRange("Order Address Code", NewInv_lRec."Order Address Code");
                if PurchRcptLine.FindFirst then begin
                    NewInv_lRec.Validate("Location Code", PurchRcptLine."Location Code");
                    NewInv_lRec.Validate("Shortcut Dimension 1 Code", POHeader."Shortcut Dimension 1 Code");
                    NewInv_lRec.Validate("Shortcut Dimension 2 Code", POHeader."Shortcut Dimension 2 Code");
                    NewInv_lRec."Dimension Set ID" := POHeader."Dimension Set ID";
                    if DimensionValue_lRec.Get(GLSetup_gRec."Global Dimension 1 Code", PurchRcptLine."Location Code") then
                        NewInv_lRec.Validate("Shortcut Dimension 1 Code", DimensionValue_lRec.Code);
                end;


                NewInv_lRec."Vendor Order No." := "Vendor Order No.";
                NewInv_lRec."Vendor Shipment No." := "Vendor Shipment No.";
                NewInv_lRec."Your Reference" := "Your Reference";
                NewInv_lRec."Vendor Shipment No." := "Vendor Shipment No.";
                NewInv_lRec."Vendor Invoice No." := POHeader."Vendor Invoice No.";


                if NewInv_lRec."Shortcut Dimension 1 Code" = '' then
                    NewInv_lRec.Validate("Shortcut Dimension 1 Code", POHeader."Shortcut Dimension 1 Code");

                if NewInv_lRec."Shortcut Dimension 2 Code" = '' then
                    NewInv_lRec.Validate("Shortcut Dimension 2 Code", POHeader."Shortcut Dimension 2 Code");

                NewInv_lRec."Dimension Set ID" := POHeader."Dimension Set ID";
                NewInv_lRec."Document Date" := POHeader."Document Date";
                NewInv_lRec.Modify(true);

                PurchRcptLine.Reset;
                PurchRcptLine.SetCurrentkey("Pay-to Vendor No.");
                PurchRcptLine.SetRange("Document No.", "No.");
                if PurchRcptLine.FindSet then begin
                    Clear(GetReceipts);
                    GetReceipts.SetPurchHeader(NewInv_lRec);
                    GetReceipts.CreateInvLines(PurchRcptLine);
                end;
            end;
        }
    }


    procedure SetReturnOrder(var POHeader2: Record "Purchase Header")
    begin
        POHeader := POHeader2;
    end;


    var
        GLSetup_gRec: Record "General Ledger Setup";
        PurchasePayablesSetup: Record "Purchases & Payables Setup";
        DimensionValue_lRec: Record "Dimension Value";
        NewInv_lRec: Record "Purchase Header";
        POHeader: Record "Purchase Header";
        NoSeries_lRec: Record "No. Series";
        PurchRcptLine: Record "Purch. Rcpt. Line";
        SalesReceivablesSetup: Record "Sales & Receivables Setup";
        NoSeriesManagement_lCdu: Codeunit "No. Series";
        GetReceipts: Codeunit "Purch.-Get Receipt";
        NewInv_gCod: Code[20];
        newSeries_lCode: Code[20];



    trigger OnPreReport()
    begin
        GLSetup_gRec.Get();
        PurchasePayablesSetup.Get();
    end;


}