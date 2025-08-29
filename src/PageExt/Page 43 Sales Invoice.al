//T12068-NS
pageextension 50006 "Page 43 Sales Invoice" extends "Sales Invoice"
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

            //T12141-NS
            field("First Approval Completed"; Rec."First Approval Completed")
            {
                ApplicationArea = All;
                Visible = false;
                ToolTip = 'Specifies the value of the First Approval Completed field.', Comment = '%';
                Description = 'T12141';
            }
            //T12141-NE
        }
        addlast("Shipping and Billing")
        {
            group("Logistic Details")
            {
                field("Vehicle No_New"; Rec."Vehicle No_New")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Vehicle No field.', Comment = '%';
                }
                field("Container Code"; Rec."Container Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Container Code field.', Comment = '%';
                }
                field("Container Plat No."; Rec."Container Plat No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Container Plat No. field.', Comment = '%';
                }
                field("Container Seal No."; Rec."Container Seal No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Container Seal No. field.', Comment = '%';
                }
            }
        }
        addafter(SalesLines)
        {
            //T12539-NS
            part("Multiple Payment Terms Subform"; "Multiple Payment Terms Subform")
            {
                ApplicationArea = All;
                SubPageLink = "Table ID" = const(36), "Document No." = field("No."), "Document Type" = filter(Invoice), Type = const(Sales);
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
