//T12114-NS
pageextension 50026 "Page Ext 5802 ValueEntries" extends "Value Entries"
{
    layout
    {
        addafter("Item No.")
        {
            field("Item No. 2"; Rec."Item No. 2")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Item No. 2 field.', Comment = '%';
                Editable = false;
                Visible = ItemVisible_gBln;
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