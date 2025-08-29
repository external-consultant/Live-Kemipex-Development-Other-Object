Pageextension 50074 P_50074_ApplicatiWorksheetExt extends "Application Worksheet"
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
