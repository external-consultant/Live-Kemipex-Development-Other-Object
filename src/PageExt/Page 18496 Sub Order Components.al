pageextension 50203 SubOrdCompList extends "Sub Order Components"
{
    layout

    //T12706-NS

    {
        addafter("Item No.")
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
