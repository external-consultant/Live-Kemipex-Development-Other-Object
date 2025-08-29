pageextension 50046 "PageExt 18550 Bank Pay. Vou" extends "Bank Payment Voucher"
{
    layout
    {
        addafter("Amount (LCY)")
        {
            //T12539-NS 
            field("Bank Transaction No."; Rec."Bank Transaction No.")
            {
                ApplicationArea = all;
                Description = 'T12141';
                ToolTip = 'Specifies the value of the Bank Transaction No. field.';
            }
            //T12539-NE
        }
        addafter("HSN/SAC Code")//Hypercare 31-01-2024
        {
            field("GST Credit"; rec."GST Credit")
            {
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        // Add changes to page actions here
    }

    var
}