pageextension 50119 AvailTransferlines50119 extends "Available - Transfer Lines"
{
    layout
    {
        //T12706-NS
        addafter("Transfer-to Code")
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
