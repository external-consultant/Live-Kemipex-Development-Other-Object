pageextension 50060 VendLedEntriesPreviewExt50060 extends "Vend. Ledg. Entries Preview"
{
    layout
    {
        addafter(AmountFCY)
        {

            field("Copy Line Description"; Rec."Copy Line Description")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Copy Line Description field.', Comment = '%';
            }
        }
    }


}