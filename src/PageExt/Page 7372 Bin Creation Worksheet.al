pageextension 50195 BinCreationWorksheetLine50195 extends "Bin Creation Worksheet"
{
    layout

    //T12706-NS

    {
        addafter("Bin Code")
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
