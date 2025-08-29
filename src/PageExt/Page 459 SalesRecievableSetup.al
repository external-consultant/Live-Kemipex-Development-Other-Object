//T12068-NS
pageextension 50003 "Page 459 Sales&RecievableSetup" extends "Sales & Receivables Setup"
{
    layout
    {
        addlast(General)
        {
            field("Reservation Expiry Days"; Rec."Reservation Expiry Days")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the value of the Reservation Expiry Days field.';
            }

            //T12115-NS 21-06-2024

            field("Prepostd CrMemo on Sal Ret Ord"; Rec."Prepostd CrMemo on Sal Ret Ord")
            {
                ApplicationArea = All;
            }
            //T12115-NE 21-06-2024
        }
    }
}
//T12068-NE