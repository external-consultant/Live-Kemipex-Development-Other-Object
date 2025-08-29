//T12114-NS
pageextension 50017 "Page Ext 30" extends "Item Card"
{
    layout
    {
        addafter("No.")
        {
            field("No. 2"; Rec."No. 2")
            {
                ApplicationArea = all;
                Visible = ItemVisible_gBln;
                ToolTip = 'Specifies the value of the No. 2 field.';
            }
        }
        //T12113-NS
        addlast(Item)
        {

            field("R&D"; Rec."R&D")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the R&D field.', Comment = '%';
                caption = 'R&D';
            }
            field("First Approval Completed"; Rec."First Approval Completed")
            {
                ApplicationArea = All;
                Visible = false;
                ToolTip = 'Specifies the value of the First Approval Completed field.', Comment = '%';
                Description = 'T12141';
            }
        }
        //T12113-NE

    }
    actions
    {
        addafter("Ledger E&ntries")
        {
            action("Location Routing")
            {
                ApplicationArea = All;
                Caption = 'Location Routing';
                Promoted = true;
                Image = RoutingVersions;
                RunObject = Page "Location Routing";
                RunPageLink = "Item No." = field("No.");
                ToolTip = 'To view and assign the Location Routing.';
                PromotedCategory = Process;
                trigger OnAction()
                begin

                end;
            }
        }
    }
    trigger OnAfterGetRecord()
    begin
        //T12113-NS
        if UserSetup_gRec.Get(UserId) then begin
            if UserSetup_gRec."Allow to view Item No.2" then
                ItemVisible_gBln := true
            else
                ItemVisible_gBln := false;
            //T12113-NE
        end;
    end;

    trigger OnOpenPage()
    begin
        //T12113-NS
        if UserSetup_gRec.Get(UserId) then begin
            if UserSetup_gRec."Allow to view Item No.2" then
                ItemVisible_gBln := true
            else
                ItemVisible_gBln := false;
            //T12113-NE
        end;
    end;


    var
        UserSetup_gRec: Record "User Setup";
        ItemVisible_gBln: Boolean;
        RND_gBln: Boolean;//T12113-N
}
//T12114-NE