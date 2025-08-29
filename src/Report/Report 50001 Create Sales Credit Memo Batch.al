report 50001 "Create Sales Credit Memo Batch"
{
    ProcessingOnly = true;
    ApplicationArea = All;
    UsageCategory = ReportsAndAnalysis;
    Description = 'T12115-NS 21-06-2024';

    dataset
    {
        dataitem("Return Receipt Header"; "Return Receipt Header")
        {
            DataItemTableView = sorting("No.");
            RequestFilterFields = "No.";

            trigger OnAfterGetRecord()
            begin
                newInv_gCod := '';
                Clear(NewInv_lRec);
                SalesReceivablesSetup.Get();
                SalesReceivablesSetup.TestField("Credit Memo Nos.");
                NewInv_lRec.Init;
                NewInv_lRec.TransferFields(SOHeader);
                NewInv_lRec."Document Type" := NewInv_lRec."document type"::"Credit Memo";
                NewInv_lRec."No." := NoSeriesManagement_lCdu.GetNextNo(SalesReceivablesSetup."Credit Memo Nos.", Today, true);
                NewInv_lRec."No. Series" := newSeries_lCode;
                NewInv_lRec.Status := NewInv_lRec.Status::Open;
                NewInv_lRec.Insert(true);
                newInv_gCod := NewInv_lRec."No.";
                NewInv_lRec."Your Reference" := "Your Reference";
                NewInv_lRec.Modify(true);


                ReturnReceiptLine.Reset;
                ReturnReceiptLine.SetCurrentkey("Sell-to Customer No.");
                ReturnReceiptLine.SetRange("Document No.", "No.");
                if ReturnReceiptLine.FindSet then begin
                    Clear(SalesGetReturnReceipts);
                    SalesGetReturnReceipts.SetSalesHeader(NewInv_lRec);
                    SalesGetReturnReceipts.CreateInvLines(ReturnReceiptLine);
                end;
            end;
        }
    }


    procedure SetReturnOrder(var SOHeader2: Record "Sales Header")
    begin
        SOHeader := SOHeader2;
    end;


    var
        NewInv_lRec: Record "Sales Header";
        SOHeader: Record "Sales Header";
        NoSeries_lRec: Record "No. Series";
        ReturnReceiptLine: Record "Return Receipt Line";
        SalesReceivablesSetup: Record "Sales & Receivables Setup";
        NoSeriesManagement_lCdu: Codeunit "No. Series";
        SalesGetReturnReceipts: Codeunit "Sales-Get Return Receipts";
        NewInv_gCod: Code[20];

        newSeries_lCode: Code[20];


}