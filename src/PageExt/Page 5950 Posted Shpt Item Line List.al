pageextension 50173 PostedShpmitemLineList50173 extends "Posted Shpt. Item Line List"
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
