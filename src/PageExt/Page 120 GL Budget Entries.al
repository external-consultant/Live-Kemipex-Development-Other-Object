pageextension 50064 "PageExt 120 GL Budget entries" extends "G/L Budget Entries"
{
    layout
    {
        //T12141-NS
        addafter(Amount)
        {

            field("Amount in FCY"; Rec."Amount in FCY")
            {
                DecimalPlaces = 0 : 5;
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Amount in FCY field.', Comment = '%';
            }
            field("Currency Code"; Rec."Currency Code")
            {
                ApplicationArea = All;
                Editable = false;
                ToolTip = 'Specifies the value of the Currency Code field.', Comment = '%';
            }
            field("Exchange Rate"; Rec."Exchange Rate")
            {
                ApplicationArea = All;
                Editable = false;
                DecimalPlaces = 0 : 5;
                ToolTip = 'Specifies the value of the Exchange Rate field.', Comment = '%';
            }
            //T12141-NE
        }
    }

    actions
    {
        // Add changes to page actions here
    }


}