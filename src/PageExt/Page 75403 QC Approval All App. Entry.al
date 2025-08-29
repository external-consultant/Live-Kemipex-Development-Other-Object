//T12114-NS
pageextension 50032 "PageExt 75403 QCAllAppEntry" extends "QC Approval All App. Entry"
{
    layout
    {
        addafter("Document No.")
        {
            field("Item No."; Rec."Item No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Item No. field.', Comment = '%';
            }
            field("Item No. 2"; Rec."Item No. 2")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Item No. 2 field.', Comment = '%';
                Visible = ItemVisible_gBln;
                Editable = false;

            }
        }
    }

    actions
    {
        // Add changes to page actions here
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