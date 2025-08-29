pageextension 50096 AvailablePurchlines50096 extends "Available - Purchase Lines"
{
    layout
    {
        //T12706-NS
        addafter("Location Code")
        {

            field("Variant Code"; Rec."Variant Code")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the variant code of the item of this line.';
            }
        }
        //T12706-NE
    }
}
