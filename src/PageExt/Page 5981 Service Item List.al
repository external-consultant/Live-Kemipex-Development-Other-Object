pageextension 50171 ServiceItemList50171 extends "Service Item List"
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
