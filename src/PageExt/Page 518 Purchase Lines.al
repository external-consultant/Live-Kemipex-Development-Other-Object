pageextension 50099 PurchaseLineslist50099 extends "Purchase Lines"
{
    layout
    {
        //T12706-NS
        modify("Variant Code")
        {
            Visible = true;
        }
        //T12706-NE
    }
}
