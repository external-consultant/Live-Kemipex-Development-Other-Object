page 50021 "Multiple Payment Terms"
{
    ApplicationArea = All;
    Caption = 'Multiple Payment Terms';
    PageType = List;
    SourceTable = "Multiple Payment Terms";
    UsageCategory = Lists;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Document No."; Rec."Document No.")
                {
                    ToolTip = 'Specifies the value of the Document No. field.', Comment = '%';
                }
                field("Type"; Rec."Type")
                {
                    ToolTip = 'Specifies the value of the Type field.', Comment = '%';
                }

                field("Event Date"; Rec."Event Date")
                {
                    ToolTip = 'Specifies the value of the Event Date field.', Comment = '%';
                }
                field("Payment Description"; Rec."Payment Description")
                {
                    ToolTip = 'Specifies the value of the Payment Description field.', Comment = '%';
                }
                field("Due Date Calculation"; Rec."Due Date Calculation")
                {
                    ToolTip = 'Specifies the value of the Due Date Calculation field.', Comment = '%';
                }
                field("Due Date"; Rec."Due Date")
                {
                    ToolTip = 'Specifies the value of the Due Date field.', Comment = '%';
                }
                field("Percentage of Total"; Rec."Percentage of Total")
                {
                    ToolTip = 'Specifies the value of the Percentage of Total field.', Comment = '%';
                }
                field("Amount of Document"; Rec."Amount of Document")
                {
                    ToolTip = 'Specifies the value of the Amount of Document field.', Comment = '%';
                }
                field("Remaining Amount"; Rec."Remaining Amount")
                {
                    ToolTip = 'Specifies the value of the Remaining Amount field.', Comment = '%';
                }
                field("Payment Forecast Date"; Rec."Payment Forecast Date")
                {
                    ToolTip = 'Specifies the value of the Payment Forecast Date field.', Comment = '%';
                }
                field(Sequence; Rec.Sequence)
                {
                    ToolTip = 'Specifies the value of the Sequence field.', Comment = '%';
                }
                field(Released; Rec.Released)
                {
                    ToolTip = 'Specifies the value of the Released field.', Comment = '%';
                }
                field(Posted; Rec.Posted)
                {
                    ToolTip = 'Specifies the value of the Posted field.', Comment = '%';
                }
            }
        }
    }
    trigger OnDeleteRecord(): Boolean
    var
        myInt: Integer;
    begin
        //IF (Rec."Document Type" <> Rec."Document Type"::Invoice) AND (Rec."Document Type" <> Rec."Document Type"::"Credit Memo") then begin
        IF Rec.Released Or Rec.Posted then
            Error('Record delete not allowed');
        //end;

    end;
}
