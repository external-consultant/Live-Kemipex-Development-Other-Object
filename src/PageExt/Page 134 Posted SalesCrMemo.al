//T12068-NS
pageextension 50010 "Page 134 Pos.SalesCrMemo" extends "Posted Sales Credit Memo"
{
    layout
    {
        addlast(General)
        {
            //T13399-OS
            // field(BDM; Rec.BDM)
            // {
            //     ApplicationArea = all;
            //     ToolTip = 'Specifies the value of the BDM field.';
            // }
            //T13399-OE
        }
        addafter(SalesCrMemoLines)
        {
            //T12539-NS
            part("Multiple Payment Terms Subform"; "Posted Multi Payment Terms Sub")
            {
                ApplicationArea = All;
                SubPageLink = "Table ID" = const(114), "Document No." = field("No."), "Document Type" = filter("Posted Sales Cr. Memo"), Type = const(Sales);
                UpdatePropagation = Both;
            }
            //T12539-NE
        }
    }
}
//T12068-NE
