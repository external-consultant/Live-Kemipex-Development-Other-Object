//T12068-NS
pageextension 50013 "Page 6631 SalesRetOrderSubform" extends "Sales Return Order Subform"
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
        }
    }
}
//T12068-NE