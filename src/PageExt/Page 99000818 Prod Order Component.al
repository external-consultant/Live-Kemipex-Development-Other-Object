//T12114-NS
pageextension 50022 "PageExt 99000818 ProdOrderComp" extends "Prod. Order Components"
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
        //Hypercare-17-02-2025
        addafter("Expected Quantity")
        {
            field("Act. Consumption (Qty)"; rec."Act. Consumption (Qty)")
            {
                ApplicationArea = All;
            }
        }
        modify("Reserved Quantity")
        {
            Visible = true;
        }
        modify("Item No.")
        {
            StyleExpr = StyleExpr_gTxt;
        }
        //Hypercare-17-02-2025
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
        CheckReqQty_gFnc(Rec);
    end;

    trigger OnAfterGetRecord()
    begin
        ItemVisible_gBln := false;
        if UserSetup_gRec.Get(UserId) then
            if UserSetup_gRec."Allow to view Item No.2" then
                ItemVisible_gBln := true;
        CheckReqQty_gFnc(Rec);
    end;

    trigger OnAfterGetCurrRecord()
    begin
        ItemVisible_gBln := false;
        if UserSetup_gRec.Get(UserId) then
            if UserSetup_gRec."Allow to view Item No.2" then
                ItemVisible_gBln := true;
        CheckReqQty_gFnc(Rec);
    end;


    procedure CheckReqQty_gFnc(ProdOrderComponent: Record "Prod. Order Component")
    var
        ILe_lRec: Record "Item Ledger Entry";
        NetAvaQTy_lDec: Decimal;
    begin
        NetAvaQTy_lDec := 0;
        ProdOrderComponent.CalcFields("Reserved Qty. (Base)");
        if (ProdOrderComponent."Remaining Qty. (Base)" - ProdOrderComponent."Reserved Qty. (Base)") > 0 then begin
            ILe_lRec.Reset();
            ILe_lRec.SetRange("Item No.", ProdOrderComponent."Item No.");
            ILe_lRec.SetRange("Variant Code", ProdOrderComponent."Variant Code");
            ILe_lRec.SetRange("Location Code", ProdOrderComponent."Location Code");
            ILe_lRec.SetRange(Open, true);
            ILe_lRec.Setfilter("Remaining Quantity", '>%1', 0);
            if ILe_lRec.FindSet() then
                repeat
                    ILe_lRec.CalcFields("Reserved Quantity");
                    NetAvaQTy_lDec += ILe_lRec."Remaining Quantity" - ILe_lRec."Reserved Quantity";
                until ILe_lRec.Next() = 0;

            if (ProdOrderComponent."Remaining Qty. (Base)" - ProdOrderComponent."Reserved Qty. (Base)") - NetAvaQTy_lDec > 0 then
                StyleExpr_gTxt := 'Unfavorable'
            else
                StyleExpr_gTxt := 'Favorable';
        end else
            StyleExpr_gTxt := 'Favorable';
    end;

    var
        UserSetup_gRec: Record "User Setup";
        ItemVisible_gBln: Boolean;
        StyleExpr_gTxt: Text;
}
//T12114-NE