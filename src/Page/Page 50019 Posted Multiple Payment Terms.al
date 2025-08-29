page 50019 "Posted Multiple Payment Terms"
{
    //T12539-N
    ApplicationArea = All;
    Caption = 'Posted Multiple Payment Terms';
    PageType = List;
    SourceTable = "Posted Multiple Payment Terms";
    UsageCategory = Lists;
    // Editable = false;
    SourceTableView = where(Posted = const(true));


    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Table ID"; Rec."Table ID")
                {
                    ToolTip = 'Specifies the value of the Table ID field.', Comment = '%';
                    Editable = false;
                }
                field("Document Type"; Rec."Document Type")
                {
                    ToolTip = 'Specifies the value of the Document Type field.', Comment = '%';
                    Editable = false;
                }
                field("Line No."; Rec."Line No.")
                {
                    ToolTip = 'Specifies the value of the Line No. field.', Comment = '%';
                    Editable = false;
                }
                field("Document No."; Rec."Document No.")
                {
                    ToolTip = 'Specifies the value of the Document No. field.', Comment = '%';
                    Editable = false;
                }
                field("Type"; Rec."Type")
                {
                    ToolTip = 'Specifies the value of the Type field.', Comment = '%';
                    Editable = false;
                }
                field("Event Date"; Rec."Event Date")
                {
                    ToolTip = 'Specifies the value of the Event Date field.', Comment = '%';
                    Editable = True;

                }
                field("Payment Description"; Rec."Payment Description")
                {
                    ToolTip = 'Specifies the value of the Payment Description field.', Comment = '%';
                    Editable = false;
                }
                field("Due Date Calculation"; Rec."Due Date Calculation")
                {
                    ToolTip = 'Specifies the value of the Due Date Calculation field.', Comment = '%';
                    Editable = false;
                }
                field("Due Date"; Rec."Due Date")
                {
                    ToolTip = 'Specifies the value of the Due Date field.', Comment = '%';
                    Editable = false;
                }
                field("Percentage of Total"; Rec."Percentage of Total")
                {
                    ToolTip = 'Specifies the value of the Percentage of Total field.', Comment = '%';
                    Editable = false;
                }
                field("Amount of Document"; Rec."Amount of Document")
                {
                    ToolTip = 'Specifies the value of the Amount of Document field.', Comment = '%';
                    Editable = false;
                }
                field("Remaining Amount"; Rec."Remaining Amount")
                {
                    ToolTip = 'Specifies the value of the Remaining Amount field.', Comment = '%';
                    Editable = false;
                }
                field("Payment Forecast Date"; Rec."Payment Forecast Date")
                {
                    ToolTip = 'Specifies the value of the Payment Forecast Date field.', Comment = '%';
                    Editable = false;
                }
                field(Sequence; Rec.Sequence)
                {
                    ToolTip = 'Specifies the value of the Sequence field.', Comment = '%';
                    Editable = false;
                }
                field(Released; Rec.Released)
                {
                    ToolTip = 'Specifies the value of the Released field.', Comment = '%';
                    Editable = false;
                }
                field(Posted; Rec.Posted)
                {
                    ToolTip = 'Specifies the value of the Posted field.', Comment = '%';
                    Editable = false;
                }
            }
        }
    }
    trigger OnDeleteRecord(): Boolean
    var
        myInt: Integer;
    begin
        IF Rec.Released Or Rec.Posted then
            Error('Record delete not allowed');
    end;
}
