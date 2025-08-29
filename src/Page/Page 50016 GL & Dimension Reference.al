page 50016 "GL & Dimension Reference"
{
    ApplicationArea = All;
    Caption = 'GL & Dimension Reference';
    PageType = List;
    SourceTable = "GL & Dimension Reference";
    UsageCategory = Lists;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Entry No."; Rec."Entry No.")
                {
                    ToolTip = 'Specifies the value of the Entry No. field.', Comment = '%';
                }
                field("Old GL Account No."; Rec."Old GL Account No.")
                {
                    ToolTip = 'Specifies the value of the Old GL Account No. field.', Comment = '%';
                }
                field("Old GL Name"; Rec."Old GL Name")
                {
                    ToolTip = 'Specifies the value of the Old GL Name field.', Comment = '%';
                }
                field("Old Dimension Code"; Rec."Old Dimension Code")
                {
                    ToolTip = 'Specifies the value of the Old Dimension Code field.', Comment = '%';
                }
                field("Old Dimension Value"; Rec."Old Dimension Value")
                {
                    ToolTip = 'Specifies the value of the Old Dimension Value field.', Comment = '%';
                }
                field("New GL Account No."; Rec."New GL Account No.")
                {
                    ToolTip = 'Specifies the value of the New GL Account No. field.', Comment = '%';
                }
                field("New GL Name"; Rec."New GL Name")
                {
                    ToolTip = 'Specifies the value of the New GL Name field.', Comment = '%';
                }
                field("New Dimension Code"; Rec."New Dimension Code")
                {
                    ToolTip = 'Specifies the value of the New Dimension Code field.', Comment = '%';
                }
                field("New Dimension Value"; Rec."New Dimension Value")
                {
                    ToolTip = 'Specifies the value of the New Dimension Value field.', Comment = '%';
                }
            }
        }
    }
}
