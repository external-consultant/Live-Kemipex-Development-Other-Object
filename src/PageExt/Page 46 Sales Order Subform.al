//T12068-NS
pageextension 50005 "Page 46 Sales Order Subform" extends "Sales Order Subform"
{
    layout
    {
        addafter("Unit Price")
        {
            //T13399-OS
            // field(BDM; Rec.BDM)
            // {
            //     ApplicationArea = all;
            //     Editable = false;
            //     ToolTip = 'Specifies the value of the BDM field.';
            // }
            //T13399-OE

            field("SalesPerson Code"; Rec."SalesPerson Code")
            {
                ApplicationArea = all;
                Editable = false;
                ToolTip = 'Specifies the value of the SalesPerson field.';
            }
            field("Purchase Order No."; Rec."Purchase Order No.")
            {
                ApplicationArea = All;
                Editable = false;
            }
            field("Purch. Order Line No."; Rec."Purch. Order Line No.")
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
//T12068-NE