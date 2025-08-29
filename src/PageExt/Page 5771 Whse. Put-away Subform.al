Pageextension 50080 P_50080_WhsePutawaySubformExt extends "Whse. Put-away Subform"
{
    layout
    {
        //T12545-NS
        addlast(Control1)
        {
            field("Warranty Date"; Rec."Warranty Date")
            {
                ApplicationArea = All;
                Caption = 'Manufacturing Date';
                ToolTip = 'Specifies the Manufacturing Date for the item on the line.';
                Editable = false;
            }


        }
        //T12545-NE
    }
}
