codeunit 50020 "Bank_Reco_Subscribe"
{

    //T12141-NS
    [EventSubscriber(ObjectType::Table, Database::"Bank Acc. Reconciliation", 'OnBeforeMatchSingle', '', false, false)]
    local procedure OnBeforeMatchSingle(var BankAccReconciliation: Record "Bank Acc. Reconciliation"; DateRange: Integer; var IsHandled: Boolean);
    var
        INTMatchBankRec_lCdu: Codeunit "Match Bank Rec. Lines_SA";
    begin
        Clear(INTMatchBankRec_lCdu);

        INTMatchBankRec_lCdu.BankAccReconciliationAutoMatch(BankAccReconciliation, DateRange);
        IsHandled := true;
    end;

    // [EventSubscriber(ObjectType::Table, Database::"Bank Acc. Reconciliation Line", OnBeforeGetStyle, '', false, false)]
    // local procedure "Bank Acc. Reconciliation Line_OnBeforeGetStyle"(var BankAccReconciliationLine: Record "Bank Acc. Reconciliation Line"; var Result: Text; var IsHandled: Boolean)
    // var
    //     BankAccledentry_lRec: Record "Bank Account Ledger Entry";
    // begin
    //     BankAccledentry_lRec.Reset();
    //     BankAccledentry_lRec.SetRange("Bank Account No.", BankAccReconciliationLine."Bank Account No.");
    //     BankAccledentry_lRec.SetRange(Reversed, false);
    //     BankAccledentry_lRec.SetRange(Open, true);
    //     BankAccledentry_lRec.SetFilter("Statement Status", '<>%1', BankAccledentry_lRec."Statement Status"::Closed);
    //     BankAccledentry_lRec.SetRange("Bank Account No.", BankAccReconciliationLine."Bank Account No.");
    //     if BankAccledentry_lRec.FindFirst() then begin
    //         Result := 'Favorable';
    //     end else
    //         Result := 'Standard';

    //     IsHandled := true;

    // end;

    //T12141-NE
}

