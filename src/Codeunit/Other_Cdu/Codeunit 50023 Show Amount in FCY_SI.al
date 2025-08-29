codeunit 50023 "Show Amount in FCY_SI"
{//T12141-NS
    SingleInstance = true;
    trigger OnRun()
    begin

    end;

    procedure SetBudgetAmountValue(SetAmtValue: Boolean)
    var
        budgetmatrix: Page "Budget";
    begin
        BudAmtFCY_gBln := SetAmtValue;
    end;

    procedure GetBudgetAmountValue(): Boolean
    var
    begin
        exit(BudAmtFCY_gBln);
    end;

    [EventSubscriber(ObjectType::Page, Page::Budget, OnAfterValidateBudgetName, '', false, false)]
    local procedure Budget_OnAfterValidateBudgetName(var GLAccBudgetBuf: Record "G/L Acc. Budget Buffer"; var GLBudgetName: Record "G/L Budget Name")
    begin
        BudgetName_gcod := GLBudgetName.Name;
    end;


    [EventSubscriber(ObjectType::Page, Page::"Budget Matrix", OnBeforeCalcFieldsAndGetBudgetedAmount, '', false, false)]
    local procedure "Budget Matrix_OnBeforeCalcFieldsAndGetBudgetedAmount"(var GLAccBudgetBuffer: Record "G/L Acc. Budget Buffer"; var Result: Decimal; var IsHandled: Boolean)
    var
        GLBudgetname: Record "G/L Budget Name";

    begin
        if BudAmtFCY_gBln then begin
            if GLBudgetname.Get(BudgetName_gcod) then
                if GLBudgetname."Currency Code" <> '' then begin
                    GLAccBudgetBuffer.CalcFields("Budgeted Amount FCY");
                    Result := GLAccBudgetBuffer."Budgeted Amount FCY";
                end;
            IsHandled := true;
        end;
    end;


    [EventSubscriber(ObjectType::Page, Page::"G/L Budget Names", 'OnBeforeActionEvent', 'EditBudget', false, false)]
    local procedure onBeforeActionEditBudget(var Rec: Record "G/L Budget Name")
    begin
        CurrencyCode_gCod := Rec."Currency Code";
        Exchrate_gDec := Rec."Exchange Rate";
    end;

    procedure GetFieldValue(Var CurrencyCode: Code[10]; Var ExchangeRate: Decimal)
    begin
        CurrencyCode := CurrencyCode_gCod;
        ExchangeRate := Exchrate_gDec;
    end;

    [EventSubscriber(ObjectType::Table, Database::"G/L Budget Entry", 'OnBeforeInsertEvent', '', true, true)]
    local procedure GLBudgetEntry_OnBeforeInsertEvent(var Rec: Record "G/L Budget Entry")
    var
    begin
        if BudAmtFCY_gBln then
            Error('Show Amount in FCY muust be false for Budget: %1', Rec."Budget Name");

    end;

    [EventSubscriber(ObjectType::Table, Database::"G/L Budget Entry", 'OnBeforeModifyEvent', '', true, true)]
    local procedure GLBudgetEntry_OnBeforeModifyEvent(var Rec: Record "G/L Budget Entry")
    var
    begin
        if BudAmtFCY_gBln then
            Error('Show Amount in FCY muust be false for Budget: %1', Rec."Budget Name");
    end;

    var
        BudAmtFCY_gBln: Boolean;
        BudgetName_gCod: code[10];
        CurrencyCode_gCod: Code[10];
        Exchrate_gDec: Decimal;
    //T12141-NE
}