Pageextension 50088 P_50088_ItemTrackCodeCardExt extends "Item Tracking Code Card"
{
    layout
    {
        //T12545-NS
        modify("Warranty Date Formula")
        {
            Caption = 'Manufacturing Date Formula';
            ToolTip = 'Specifies the formula that calculates the Manufacturing date entered in the Manufacturing Date field on item tracking line.';

        }
        modify("Man. Warranty Date Entry Reqd.")
        {
            Caption = 'Required Manufacturing Date Entry';
            ToolTip = 'Specifies that a Manufacturing date must be entered manually.';
        }
        //T12545-NE
    }
}
