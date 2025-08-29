//T12114-NS
pageextension 50023 "Page Ext 99000867 FPO" extends "Finished Production Order"
{
    layout
    {
        addafter("Source No.")
        {
            field("Item No. 2"; Rec."Item No. 2")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Item No. 2 field.', Comment = '%';
                Visible = ItemVisible_gBln;
                Editable = false;

            }
            field("Firm Planned Order No."; Rec."Firm Planned Order No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Firm Planned Order No. field.', Comment = '%';
                Editable = false;//Hypercare 27-02-2025
            }
        }
        //T12706-NS
        modify("Variant Code")
        {
            Visible = true;
        }
        //T12706-NE
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