pageextension 50050 "PageExt 381 Apply BankLedEnt" extends "Apply Bank Acc. Ledger Entries"
{
    layout
    {
        addafter(Amount)
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