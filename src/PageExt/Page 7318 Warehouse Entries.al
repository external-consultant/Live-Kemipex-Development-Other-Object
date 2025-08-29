//T12114-NS
pageextension 50027 "Page Ext 7318 WarehouseEntries" extends "Warehouse Entries"
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
        //T12545-NS
        addlast(Control1)
        {
            field("Warranty Date"; Rec."Warranty Date")
            {
                ApplicationArea = All;
                Caption = 'Manufacturing Date';
                ToolTip = 'Specifies the Manufacturing Date for the item on the line.';
            }


        }
        //T12545-NE
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