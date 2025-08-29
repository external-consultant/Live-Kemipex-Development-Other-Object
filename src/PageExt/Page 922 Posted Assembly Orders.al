pageextension 50323 PostedAssemblyOrders50323 extends "Posted Assembly Orders"
{
    layout
    {
        //T12706-NS
        addafter("Item No.")
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
