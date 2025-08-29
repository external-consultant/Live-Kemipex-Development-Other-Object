pageextension 50094 WhseItemTrackingLine_50094 extends "Whse. Item Tracking Lines"
{
    layout
    {
        //T12545-NS
        modify("Warranty Date")
        {
            Caption = 'Manufacturing Date';
            ToolTip = 'Specifies that a Manufacturing Date must be entered manually.';
            Editable = false;
        }
        //T12545-NE

        //T12706-NS
        modify("Variant Code")
        {
            Visible = true;
        }
        //T12706-NE
    }

    actions
    {
        // Add changes to page actions here
    }

    var
        myInt: Integer;
}