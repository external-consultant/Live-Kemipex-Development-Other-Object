//T12114-NS
pageextension 50033 "Page 99000755 WorkCenterList" extends "Work Center List"
{
    layout
    {
        addafter("Global Dimension 2 Code")
        {

            field("Batch Quantity"; Rec."Batch Quantity")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Batch Quantity field.', Comment = '%';
            }
        }
    }

    actions
    {
        // Add changes to page actions here
    }

    var
}
//T12114-NE