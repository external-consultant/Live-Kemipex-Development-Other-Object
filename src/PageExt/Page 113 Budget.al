pageextension 50062 "PageExt 113 Budget" extends Budget
{
    layout
    {
        addlast(General)
        {
            //T12141-NS
            field(CurrencyCode_gCod; CurrencyCode_gCod)
            {
                ApplicationArea = all;
                Editable = false;
                Caption = 'Currency Code';
            }
            field(Exchrate_gDec; Exchrate_gDec)
            {
                ApplicationArea = all;
                DecimalPlaces = 0 : 5;
                Editable = false;
                Caption = 'Exchange Rate';
            }
            field(ShowAmtFCY_gBln; ShowAmtFCY_gBln)
            {
                ApplicationArea = all;
                Caption = 'Show Amount in FCY';
                trigger OnValidate()

                begin
                    if ShowAmtFCY_gBln then
                        ShowAmtFCy_lCdu.SetBudgetAmountValue(true)
                    else
                        ShowAmtFCy_lCdu.SetBudgetAmountValue(false);

                    CurrPage.Update(true);
                end;
            }

            //T12141-NE
        }
    }


    actions
    {
        // Add changes to page actions here
    }

    trigger OnOpenPage()
    begin
        ShowAmtFCy_lCdu.GetFieldValue(CurrencyCode_gCod, Exchrate_gDec);
    end;

    trigger OnAfterGetRecord()
    begin
        ShowAmtFCy_lCdu.GetFieldValue(CurrencyCode_gCod, Exchrate_gDec);

    end;

    var
        ShowAmtFCY_gBln: Boolean;
        CurrencyCode_gCod: Code[10];
        Exchrate_gDec: Decimal;
        ShowAmtFCy_lCdu: Codeunit "Show Amount in FCY_SI";
}