codeunit 50017 "Table 271 Bank Led Entries Sub"
{
    //T12141 -NS
    [EventSubscriber(ObjectType::Table, Database::"Bank Account Ledger Entry", OnAfterCopyFromGenJnlLine, '', false, false)]
    local procedure "Bank Account Ledger Entry_OnAfterCopyFromGenJnlLine"(var BankAccountLedgerEntry: Record "Bank Account Ledger Entry"; GenJournalLine: Record "Gen. Journal Line")
    begin
        BankAccountLedgerEntry."Bank Transaction No." := GenJournalLine."Bank Transaction No.";
    end;
    //T12141 -NE
}