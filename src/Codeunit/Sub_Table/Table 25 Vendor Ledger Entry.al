codeunit 50025 "Subscribe Table 25 VLE"
{
    //T12141-NS
    [EventSubscriber(ObjectType::Table, Database::"Vendor Ledger Entry", OnAfterCopyVendLedgerEntryFromGenJnlLine, '', false, false)]
    local procedure "Vendor Ledger Entry_OnAfterCopyVendLedgerEntryFromGenJnlLine"(var VendorLedgerEntry: Record "Vendor Ledger Entry"; GenJournalLine: Record "Gen. Journal Line")
    var
        Vendor_lRec: Record Vendor;
        PurchInvHdr_lRec: Record "Purch. Inv. Header";
    begin
        PurchInvHdr_lRec.Reset();
        PurchInvHdr_lRec.SetRange("No.", VendorLedgerEntry."Document No.");
        If PurchInvHdr_lRec.FindFirst() then begin
            Vendor_lRec.Reset();
            If Vendor_lRec.GET(PurchInvHdr_lRec."Buy-from Vendor No.") then
                if (Vendor_lRec."MSME Tag") then
                    VendorLedgerEntry."MSME Tag" := Vendor_lRec."MSME Tag";
        end;
    end;
    //T12141-NE
}