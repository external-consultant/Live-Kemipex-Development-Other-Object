//T12068-NS
pageextension 50012 "Page 6630 Sales Return Order" extends "Sales Return Order"
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
        addafter(SalesLines)
        {
            //T12539-NS
            part("Multiple Payment Terms Subform"; "Multiple Payment Terms Subform")
            {
                ApplicationArea = All;
                SubPageLink = "Table ID" = const(36), "Document No." = field("No."), "Document Type" = filter("Return Order"), Type = const(Sales);
                UpdatePropagation = Both;
                Editable = IsSalesLinesEditable;
                Enabled = CheckStatus;
            }
            //T12539-NE
        }
    }
    trigger OnAfterGetRecord()
    var
        myInt: Integer;
    begin
        //T12539-NS
        IsSalesLinesEditable := Rec.SalesLinesEditable();

        If Rec.Status = Rec.Status::Released then
            CheckStatus := false
        else
            CheckStatus := true;
        //T12539-NE
    end;

    var
        IsSalesLinesEditable: Boolean;//T12539-N
        CheckStatus: Boolean;//T12539-N
}
//T12068-NE
