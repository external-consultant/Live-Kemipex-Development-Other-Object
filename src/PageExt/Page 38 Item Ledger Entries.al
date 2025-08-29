//T12114-NS
pageextension 50018 "Page Ext 38 Item Led Entries" extends "Item Ledger Entries"
{
    layout
    {
        addafter("Item No.")
        {
            field("Item No. 2"; Rec."Item No. 2")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Item No. 2 field.', Comment = '%';
                Visible = ItemVisible_gBln;
                Editable = false;

            }
        }
        addlast(Control1)
        {
            //T12545-NS

            field("Warranty Date"; Rec."Warranty Date")
            {
                ApplicationArea = All;
                Caption = 'Manufacturing Date';
                ToolTip = 'Specifies the Manufacturing Date for the item on the line.';
            }
            //T12545-NE
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
        // Rec.SetFilter(Open, 'true'); //T13395-N
        // Rec.SetFilter("Remaining Quantity", '>0');//T13395-N
    end;


    var
        UserSetup_gRec: Record "User Setup";
        ItemVisible_gBln: Boolean;
}
//T12114-NE