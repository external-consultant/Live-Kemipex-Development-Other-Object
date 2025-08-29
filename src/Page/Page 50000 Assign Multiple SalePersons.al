//T12068-NS
page 50000 "Assign Multiple SalesPersons"
{
    PageType = List;
    SourceTable = "Assign Multiple SalesPersons";

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("SalesPerson Code"; Rec."SalesPerson Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the SalesPerson Code field.';
                    InstructionalText = 'SalesPerson Code';
                }
                field("SalesPerson Name"; Rec."SalesPerson Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the SalesPerson Name field.';

                }
            }
        }
    }

    actions
    {
        /*area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;
                ToolTip = 'Executes the ActionName action.';

                trigger OnAction()
                begin

                end;
            }
        }*/
    }

    var
        myInt: Page "Assembly Order";
}
//T12068-NE