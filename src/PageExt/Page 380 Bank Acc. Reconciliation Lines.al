pageextension 50049 "PageExt 380 BankAccRecLines" extends "Bank Acc. Reconciliation Lines"
{
    layout
    {
        addafter("Applied Amount")
        {
            field("Bank Transaction No."; Rec."Bank Transaction No.")
            {
                ApplicationArea = all;
                Description = 'T12141';
                ToolTip = 'Specifies the value of the Bank Transaction No. field.';
            }
        }
    }

    actions
    {
        // Add changes to page actions here
    }

    var
}