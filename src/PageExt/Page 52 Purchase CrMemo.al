pageextension 50041 "PageExt 52 PurchCrMemo" extends "Purchase Credit Memo"
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
            //     ToolTip = 'Specifies the value of the Delivery Date field.', Comment = '%';
            // }
            // field("Document Submission Date"; Rec."Document Submission Date")
            // {
            //     ApplicationArea = All;
            //     ToolTip = 'Specifies the value of the Document Submission Date field.', Comment = '%';
            // }
            field("First Approval Completed"; Rec."First Approval Completed")
            {
                ApplicationArea = All;
                Visible = false;
                ToolTip = 'Specifies the value of the First Approval Completed field.', Comment = '%';
                Description = 'T12141';
            }
        }
        //T12141-NE


        addafter(PurchLines)
        {
            //T12539-NS
            part("Multiple Payment Terms Subform"; "Multiple Payment Terms Subform")
            {
                ApplicationArea = All;
                SubPageLink = "Table ID" = const(38), "Document No." = field("No."), "Document Type" = filter("Credit Memo"), Type = const(Purchase);
                UpdatePropagation = Both;
                Editable = IsPurchLinesEditable;
                Enabled = CheckStatus;
            }
            //T12539-NE
        }
    }

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