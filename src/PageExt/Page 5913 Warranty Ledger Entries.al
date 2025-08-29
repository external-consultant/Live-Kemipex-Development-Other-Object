pageextension 50170 WarrtyLedgerEntries50170 extends "Warranty Ledger Entries"
{
    layout
    {
        //T12706-NS
        addafter("Vendor Item No.")
        {

            field("Variant Code"; Rec."Variant Code")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the variant code for production order item.';
            }
        }
        //T12706-NE
    }
}
