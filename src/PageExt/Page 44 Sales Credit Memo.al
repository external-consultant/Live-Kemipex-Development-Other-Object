pageextension 50090 SalesCreditMemoExt50090 extends "Sales Credit Memo"
{
    layout
    {
        addafter(SalesLines)
        {
            //T12539-NS
            part("Multiple Payment Terms Subform"; "Multiple Payment Terms Subform")
            {
                ApplicationArea = All;
                SubPageLink = "Table ID" = const(36), "Document No." = field("No."), "Document Type" = filter("Credit Memo"), Type = const(Sales);
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