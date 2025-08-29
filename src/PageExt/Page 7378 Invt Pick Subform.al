Pageextension 50083 P_50083_InvtPickSubformExt extends "Invt. Pick Subform"
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
