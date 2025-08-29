page 50011 "Location Category"
{
    AdditionalSearchTerms = 'Location Category';
    ApplicationArea = Location;
    Caption = 'Location Category';
    PageType = List;
    SourceTable = "Location Category";
    UsageCategory = Lists;


    layout
    {
        area(Content)
        {
            repeater(General)
            {

                field("code"; Rec."code")
                {
                    ToolTip = 'Specifies the value of the Code field.', Comment = '%';
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the value of the Description field.', Comment = '%';
                }
                // field("Financial Impact"; Rec."Financial Impact")
                // {
                //     ToolTip = 'Specifies the value of the Financial Impact field.', Comment = '%';
                // }

            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction()
                begin

                end;
            }
        }
    }

    var
        myInt: Integer;
}