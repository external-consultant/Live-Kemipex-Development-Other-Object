pageextension 50326 ProdOrdList50122 extends "Production Order List"
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
        //T12706-NE
    }
}
