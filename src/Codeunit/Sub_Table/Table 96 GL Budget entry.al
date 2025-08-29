
codeunit 50024 "Table 96 G/L Budget Entry Sub"
{
    [EventSubscriber(ObjectType::Table, Database::"G/L Budget Entry", 'OnBeforeInsertEvent', '', true, true)]
    local procedure GLBudgetEntry_OnBeforeInsertEvent(var Rec: Record "G/L Budget Entry")
    var
        GLBudgetname: Record "G/L Budget Name";
    begin
        if GLBudgetname.Get(rec."Budget Name") then begin
            Rec."Currency Code" := GLBudgetname."Currency Code";
            Rec."Exchange Rate" := GLBudgetname."Exchange Rate";
            if Rec.Amount <> 0 then
                Rec."Amount in FCY" := Rec.Amount * GLBudgetname."Exchange Rate";
            if Rec."Amount in FCY" <> 0 then
                Rec.Amount := Rec."Amount in FCY" / GLBudgetname."Exchange Rate";
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"G/L Budget Entry", 'OnBeforeModifyEvent', '', true, true)]
    local procedure GLBudgetEntry_OnBeforeModifyEvent(var Rec: Record "G/L Budget Entry")
    var
        GLBudgetname: Record "G/L Budget Name";
    begin
        if GLBudgetname.Get(rec."Budget Name") then begin
            Rec."Currency Code" := GLBudgetname."Currency Code";
            Rec."Exchange Rate" := GLBudgetname."Exchange Rate";
            if Rec.Amount <> 0 then
                Rec."Amount in FCY" := Rec.Amount * GLBudgetname."Exchange Rate";
            if Rec."Amount in FCY" <> 0 then
                Rec.Amount := Rec."Amount in FCY" / GLBudgetname."Exchange Rate";
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"G/L Budget Entry", 'OnBeforeValidateEvent', 'Amount in FCY', true, true)]
    local procedure "G/L Budget Entry_OnBeforeValidateEvent_Amount in FC"(var Rec: Record "G/L Budget Entry"; CurrFieldNo: Integer)
    begin
        if CurrFieldNo = Rec.FieldNo("Amount in FCY") then begin
            Rec.Amount := 0;
        end;
    end;
}