pageextension 50189 PageExtContraVoucher extends "Contra Voucher"
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
}