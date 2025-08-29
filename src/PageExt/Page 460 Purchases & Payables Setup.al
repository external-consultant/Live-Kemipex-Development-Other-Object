pageextension 50059 PurchandpaysetupExt50059 extends "Purchases & Payables Setup"
{
    layout
    {
        addafter("Copy Cmts Ret.Ord. to Cr. Memo")
        {

            field("Copy Line Description"; Rec."Copy Line Description")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Copy Line Description field.', Comment = '%';
            }
        }
    }
}