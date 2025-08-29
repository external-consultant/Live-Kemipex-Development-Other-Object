//T12114-NS
pageextension 50029 "PageExt 75383 QC Rcpt." extends "QC Rcpt."
{
    layout
    {
        addafter("Item No.")
        {

            field("Item No. 2"; Rec."Item No. 2")
            {
                ApplicationArea = All;
                Visible = ItemVisible_gBln;
                ToolTip = 'Specifies the value of the Item No. 2 field.', Comment = '%';
                Editable = false;

            }
        }
    }

    trigger OnOpenPage()
    begin
        ItemVisible_gBln := false;
        if UserSetup_gRec.Get(UserId) then
            if UserSetup_gRec."Allow to view Item No.2" then
                ItemVisible_gBln := true;
    end;


    var
        UserSetup_gRec: Record "User Setup";
        ItemVisible_gBln: Boolean;
}
//T12114-NE