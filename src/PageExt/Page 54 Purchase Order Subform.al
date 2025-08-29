pageextension 50038 PurchaseOrderSubform_Ext extends "Purchase Order Subform"
{
    layout
    {
        addafter("Unit of Measure")
        {
            field("Sales Order No."; Rec."Sales Order No.")
            {
                ApplicationArea = All;
                Editable = false;
            }
            field("Sales Order Line No."; Rec."Sales Order Line No.")
            {
                ApplicationArea = All;
                Editable = false;
            }
        }
        //T12706-NS
        modify("Variant Code")
        {
            Visible = true;
        }
        //T12706-NE
    }
}
