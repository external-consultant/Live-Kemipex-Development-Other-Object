pageextension 50047 "PageExt 18853 Bank Rcpt. Vou" extends "Bank Receipt Voucher"
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
    }

    actions
    {
        // Add changes to page actions here
    }

    var
}