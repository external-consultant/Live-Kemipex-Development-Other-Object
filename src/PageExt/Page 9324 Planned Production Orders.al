pageextension 50349 PlannedprodOrder50121 extends "Planned Production Orders"
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
