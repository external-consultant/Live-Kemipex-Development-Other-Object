//T12068-NS
pageextension 50011 "Page 135 PosSalesCrMemoSubform" extends "Posted Sales Cr. Memo Subform"
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