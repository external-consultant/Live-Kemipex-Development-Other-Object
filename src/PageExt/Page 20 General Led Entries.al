pageextension 50052 "PageExt 20 Gen Led Entries" extends "General Ledger Entries"
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