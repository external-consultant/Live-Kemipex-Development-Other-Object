codeunit 50047 "Subscribe Codeunit 415"
{
    //T12539-NS
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Release Purchase Document", OnAfterManualReopenPurchaseDoc, '', false, false)]
    local procedure "Release Purchase Document_OnAfterManualReopenPurchaseDoc"(var PurchaseHeader: Record "Purchase Header"; PreviewMode: Boolean)
    var
        MultiplePmtTerms_lRec: Record "Multiple Payment Terms";
    begin
        If PurchaseHeader."Document Type" = PurchaseHeader."Document Type"::Quote then
            exit;

        If PurchaseHeader.Status <> PurchaseHeader.Status::Released then begin
            MultiplePmtTerms_lRec.Reset();
            MultiplePmtTerms_lRec.SetRange(Type, MultiplePmtTerms_lRec.Type::Purchase);
            MultiplePmtTerms_lRec.SetRange("Document No.", PurchaseHeader."No.");
            MultiplePmtTerms_lRec.SetRange("Document Type", PurchaseHeader."Document Type");
            If MultiplePmtTerms_lRec.FindSet() then
                repeat
                    MultiplePmtTerms_lRec.Released := false;
                    MultiplePmtTerms_lRec.Modify();
                until MultiplePmtTerms_lRec.Next() = 0;
        end;
    end;
    //T12539-NE

}