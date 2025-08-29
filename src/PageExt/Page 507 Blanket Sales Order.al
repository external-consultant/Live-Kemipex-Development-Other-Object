pageextension 50092 BlanketSalesOrdExt50092 extends "Blanket Sales Order"
{
    layout
    {
        addafter(SalesLines)
        {
            //T12539-NS
            part("Multiple Payment Terms Subform"; "Multiple Payment Terms Subform")
            {
                ApplicationArea = All;
                SubPageLink = "Table ID" = const(36), "Document No." = field("No."), "Document Type" = filter("Blanket Order"), Type = const(Sales);
                UpdatePropagation = Both;
                // Editable = IsSalesLinesEditable;
                // Enabled = CheckStatus;
            }
            //T12539-NE
        }
        addlast(General)
        {
            //T12540-NS
            field("Quote No."; Rec."Quote No.")
            {
                ApplicationArea = all;
                Editable = true;
            }
            //T12540-NE
        }

    }
    trigger OnAfterGetRecord()
    var
        myInt: Integer;
    begin
        //T12539-NS
        // IsSalesLinesEditable := Rec.SalesLinesEditable();

        // If Rec.Status = Rec.Status::Released then
        //     CheckStatus := false
        // else
        //     CheckStatus := true;
        //T12539-NE
    end;

    var
        IsSalesLinesEditable: Boolean;//T12539-N
        CheckStatus: Boolean;//T12539-N
}