Pageextension 50081 P_50081_RegisPutawaySubformExt extends "Registered Put-away Subform"
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
            }
        }
        //T12545-NE
    }
}
