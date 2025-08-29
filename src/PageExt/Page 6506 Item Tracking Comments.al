pageextension 50178 ItemTrackingComment50178 extends "Item Tracking Comments"
{
    layout

    //T12706-NS

    {
        addafter(Comment)
        {

            field("Variant Code"; Rec."Variant Code")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Variant Code field.', Comment = '%';
            }
        }

    }

    //T12706-NE
}
