pageextension 50165 MyExtension extends "Budget Matrix"
{
    layout
    {

        modify(Control1)
        {
            Editable = Seteditable;
        }
    }

    actions
    {
        // Add changes to page actions here
    }

    trigger OnOpenPage()
    begin
        Seteditable := not ShowAmtFCy_lCdu.GetBudgetAmountValue();

    end;

    trigger OnAfterGetRecord()
    begin

        Seteditable := not ShowAmtFCy_lCdu.GetBudgetAmountValue();
    end;

    var
        ShowAmtFCy_lCdu: Codeunit "Show Amount in FCY_SI";
        Seteditable: Boolean;

}