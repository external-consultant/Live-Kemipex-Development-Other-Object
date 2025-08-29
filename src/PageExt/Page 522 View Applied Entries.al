Pageextension 50075 P_50075_ViewAppliedEntriesExt extends "View Applied Entries"
{
    layout
    {
        //T12545-NS
        addlast(Control2)
        {
            field("Warranty Date"; Rec."Warranty Date")
            {
                ApplicationArea = All;
                Caption = 'Manufacturing Date';
                ToolTip = 'Specifies the Manufacturing Date for the item on the line.';
            }


        }
        //T12545-NE

    }
}
