Codeunit 50016 "Table 17 GL Entry Sub"
{
    //T12141 -NS
    [EventSubscriber(ObjectType::Table, Database::"G/L Entry", OnAfterCopyGLEntryFromGenJnlLine, '', false, false)]
    local procedure "G/L Entry_OnAfterCopyGLEntryFromGenJnlLine"(var GLEntry: Record "G/L Entry"; var GenJournalLine: Record "Gen. Journal Line")
    begin
        GLEntry."Bank Transaction No." := GenJournalLine."Bank Transaction No.";
    end;
    //T12141 -NE
}