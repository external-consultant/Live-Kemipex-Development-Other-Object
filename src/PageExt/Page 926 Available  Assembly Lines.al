pageextension 50322 AvailAssemblyline50322 extends "Available - Assembly Lines"
{
    layout
    {
        //T12706-NS
        addafter("Location Code")
        {

            field("Variant Code"; Rec."Variant Code")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the code of the item variant of the item that is being assembled.';
            }
        }
        //T12706-NE
    }
}
