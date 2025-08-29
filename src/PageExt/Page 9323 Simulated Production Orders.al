pageextension 50328 SimulatedPrdOrder50124 extends "Simulated Production Orders"
{
    layout
    {
        //T12706-NS
        addafter("Source No.")
        {

            field("Variant Code"; Rec."Variant Code")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the variant code for production order item.';
            }
        }
    }
    //T12706-NE
}
