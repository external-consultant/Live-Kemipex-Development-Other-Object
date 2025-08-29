codeunit 50045 "Subscribe Report 492"
{
    //T12539-NS
    [EventSubscriber(ObjectType::Report, Report::"Copy Purchase Document", OnAfterOnPreReport, '', false, false)]
    local procedure "Copy Purchase Document_OnAfterOnPreReport"(PurchDocTypeFrom: Enum "Purchase Document Type From"; DocNo: Code[20]; var PurchaseHeader: Record "Purchase Header")
    var
        MultiplePmtTerms_lRec: Record "Multiple Payment Terms";
        CopyMultiplePmtTerms_lRec: Record "Multiple Payment Terms";
        PurchaseEnum: Enum "Purchase Document Type";
    begin
        If PurchaseHeader."Document Type" = PurchaseHeader."Document Type"::Quote then
            exit;

        case PurchDocTypeFrom of
            PurchDocTypeFrom::Order:
                PurchaseEnum := PurchaseEnum::Order;
            PurchDocTypeFrom::Invoice:
                PurchaseEnum := PurchaseEnum::Invoice;
            PurchDocTypeFrom::"Return Order":
                PurchaseEnum := PurchaseEnum::"Return Order";
            PurchDocTypeFrom::"Credit Memo":
                PurchaseEnum := PurchaseEnum::"Credit Memo";
        end;

        MultiplePmtTerms_lRec.Reset();
        MultiplePmtTerms_lRec.SetRange(Type, MultiplePmtTerms_lRec.Type::Purchase);
        MultiplePmtTerms_lRec.SetRange("Document No.", DocNo);
        MultiplePmtTerms_lRec.SetRange("Document Type", PurchaseEnum);
        If MultiplePmtTerms_lRec.FindSet() then
            repeat
                CopyMultiplePmtTerms_lRec.Reset();
                CopyMultiplePmtTerms_lRec.Init();
                CopyMultiplePmtTerms_lRec.TransferFields(MultiplePmtTerms_lRec);
                CopyMultiplePmtTerms_lRec."Document No." := PurchaseHeader."No.";
                CopyMultiplePmtTerms_lRec."Document Type" := PurchaseHeader."Document Type";
                CopyMultiplePmtTerms_lRec.Released := false;
                CopyMultiplePmtTerms_lRec.Posted := false;
                CopyMultiplePmtTerms_lRec.Insert();
            until MultiplePmtTerms_lRec.Next() = 0;
    end;
    //T12539-NE
}