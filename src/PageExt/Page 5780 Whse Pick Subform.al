Pageextension 50082 P_50082_WhsePickSubformExt extends "Whse. Pick Subform"
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

        //T12706-NS
        modify("Variant Code")
        {
            Visible = true;
        }
        //T12706-NE
    }
}
