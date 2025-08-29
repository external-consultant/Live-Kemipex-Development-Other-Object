pageextension 50056 "PageExt 26 VendorCard" extends "Vendor Card"

{
    layout
    {
        addlast(General)
        {


            // field("Due Date Calculation Type"; Rec."Due Date Calculation Type")
            // {
            //     ApplicationArea = All;
            //     Description = 'T12141';
            //     ToolTip = 'Specifies the value of the Due Date Calculation Type field.', Comment = '%';
            // }

            //T12141-NS
            field("MSME Tag"; Rec."MSME Tag")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the MSME Tag field.', Comment = '%';
            }
            field("MSME Type"; Rec."MSME Type")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the MSME Type field.', Comment = '%';
                Editable = Rec."MSME Tag";
            }

            field("MSME License No."; Rec."MSME License No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the MSME License No. field.', Comment = '%';
            }
            field("First Approval Completed"; Rec."First Approval Completed")
            {
                ApplicationArea = All;
                Visible = false;
                ToolTip = 'Specifies the value of the First Approval Completed field.', Comment = '%';
            }
            //T12141-NE
        }
    }
}