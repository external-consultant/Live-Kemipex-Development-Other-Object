pageextension 50172 ServiceItemComp50172 extends "Filed Service Contract Lines"
{
    layout
    {
        //T12706-NS
        addafter("Item No.")
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

