pageextension 50168 ServiceLineList50125 extends "Service Line List"
{
    layout
    {
        //T12706-NS
        addafter("Location Code")
        {

            field("Variant Code"; Rec."Variant Code")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the variant code for production order item.';
            }
        }
        //T12706-NE
    }
}
