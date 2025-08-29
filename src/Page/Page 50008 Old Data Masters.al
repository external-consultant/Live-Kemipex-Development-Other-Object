//T12114-NS
page 50008 "Old Data Masters"
{
    ApplicationArea = All;
    Caption = 'Old Data Masters';
    PageType = List;
    SourceTable = "Old Data Master";
    UsageCategory = Lists;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Old Item No."; Rec."Old Item No.")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Old Item No. field.', Comment = '%';
                }

                field("Old Item Description"; rec."Old Item Description")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Old Item Description field.', Comment = '%';
                }


                field("Old Variant No."; Rec."Old Variant No.")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Old Variant No. field.', Comment = '%';
                }
                field("New Item No."; Rec."New Item No.")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the New Item No. field.', Comment = '%';
                }
                field("New Item Description"; rec."New Item Description")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the New Item Description field.', Comment = '%';
                }
                field("New Variant No."; Rec."New Variant No.")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the New Variant No. field.', Comment = '%';
                }
            }

        }


    }

}
//T12114-NE