pageextension 50063 "PageExt 121 GLBudgetNames" extends "G/L Budget Names"
{
    layout
    {
        addlast(Control1)
        {
            //T12141-NS
            field("Currency Code"; Rec."Currency Code")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Currency Code field.', Comment = '%';
                trigger OnValidate()
                var
                    GLBudEnt_lRec: Record "G/L Budget Entry";
                begin
                    if xRec."Currency Code" <> '' then
                        if Rec."Currency Code" <> xRec."Currency Code" then begin
                            GLBudEnt_lRec.Reset();
                            GLBudEnt_lRec.SetRange("Budget Name", Rec.Name);
                            GLBudEnt_lRec.SetRange("Currency Code", xRec."Currency Code");
                            if GLBudEnt_lRec.FindFirst() then
                                Error('You cannot modify Currency Code since there is already G/L budget entries associated with it.');
                        end;
                end;
            }
            field("Exchange Rate"; Rec."Exchange Rate")
            {
                ApplicationArea = All;
                DecimalPlaces = 0 : 5;
                ToolTip = 'Specifies the value of the Exchange Rate field.', Comment = '%';
                trigger OnValidate()
                var
                    GLBudEnt_lRec: Record "G/L Budget Entry";
                    TotalBudgetamt_lDec: Decimal;
                begin
                    Rec.TestField("Currency Code");
                    TotalBudgetamt_lDec := 0;
                    if xRec."Exchange Rate" <> 0 then
                        if Rec."Exchange Rate" <> xRec."Exchange Rate" then begin
                            GLBudEnt_lRec.Reset();
                            GLBudEnt_lRec.SetRange("Budget Name", Rec.Name);
                            GLBudEnt_lRec.SetRange("Currency Code", Rec."Currency Code");
                            GLBudEnt_lRec.SetRange("Exchange Rate", xRec."Exchange Rate");
                            GLBudEnt_lRec.SetLoadFields(Amount);
                            if GLBudEnt_lRec.FindSet() then begin
                                GLBudEnt_lRec.CalcSums(Amount);
                                TotalBudgetamt_lDec := GLBudEnt_lRec.Amount;
                            end;
                            if TotalBudgetamt_lDec <> 0 then
                                Error('You cannot modify Exchange Rate since there is already G/L budget entries associated with it.');
                        end;
                end;
            }
        }
        //T12141-NE
    }

    actions
    {
        // Add changes to page actions here
    }

    var
}