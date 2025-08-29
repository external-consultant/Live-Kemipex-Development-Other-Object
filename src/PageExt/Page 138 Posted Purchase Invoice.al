pageextension 50043 "PageExt 138 PosPurchinv" extends "Posted Purchase Invoice"
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
        //T12141-NE

        addafter(PurchInvLines)
        { //T12539-NS
            part("Multiple Payment Terms Subform"; "Posted Multi Payment Terms Sub")
            {
                ApplicationArea = All;
                SubPageLink = "Table ID" = const(122), "Document No." = field("No."), "Document Type" = filter("Posted Purchase Invoice"), Type = const(Purchase);
                UpdatePropagation = Both;
            }
            //T12539-NE

        }
    }
}