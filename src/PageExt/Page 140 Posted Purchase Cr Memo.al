pageextension 50044 "PageExt 140 PostedPurchCrMemo" extends "Posted Purchase Credit Memo"
{
    layout
    {
        //T12141-NS

        addlast(General)
        {

            field("Due Date Calculation Type"; Rec."Due Date Calculation Type")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Due Date Calculation Type field.', Comment = '%';
            }
            field("QC Date"; Rec."QC Date")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the QC Date field.', Comment = '%';
            }
            field("Bill of Lading Date"; Rec."Bill of Lading Date")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Bill of Lading Date field.', Comment = '%';
            }
            field("Delivery Date"; Rec."Delivery Date")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Delivery Date field.', Comment = '%';
            }
            field("Document Submission Date"; Rec."Document Submission Date")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Document Submission Date field.', Comment = '%';
            }
        }
        //T12141-NE

        addafter(PurchCrMemoLines)
        { //T12539-NS
            part("Multiple Payment Terms Subform"; "Posted Multi Payment Terms Sub")
            {
                ApplicationArea = All;
                SubPageLink = "Table ID" = const(124), "Document No." = field("No."), "Document Type" = filter("Posted Purchase Cr. Memo"), Type = const(Purchase);
                UpdatePropagation = Both;
            }
            //T12539-NE

        }
    }
}