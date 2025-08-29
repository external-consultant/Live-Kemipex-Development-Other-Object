//T12114-NS
pageextension 50034 "Page 99000754 WorkCenterCard" extends "Work Center Card"
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