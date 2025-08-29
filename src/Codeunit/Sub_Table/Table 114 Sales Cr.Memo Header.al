codeunit 50039 "Subscribe Table 114"
{
    //T12539-NS
    [EventSubscriber(ObjectType::Table, Database::"Sales Cr.Memo Header", 'OnAfterDeleteEvent', '', false, false)]
    local procedure SalesHeader_OnAfterDeletEvent(var Rec: Record "Sales Cr.Memo Header")
    var
        PstdMultiplePmtTerms_lRec: Record "Posted Multiple Payment Terms";
    begin
        If Rec.IsTemporary then
            exit;

        PstdMultiplePmtTerms_lRec.Reset();
        PstdMultiplePmtTerms_lRec.SetRange("Document No.", Rec."No.");
        PstdMultiplePmtTerms_lRec.SetRange("Document Type", PstdMultiplePmtTerms_lRec."Document Type"::"Posted Sales Cr. Memo");
        PstdMultiplePmtTerms_lRec.SetRange(Type, PstdMultiplePmtTerms_lRec.Type::Sales);
        If PstdMultiplePmtTerms_lRec.FindSet() then
            repeat
                PstdMultiplePmtTerms_lRec.DeleteAll(true);
            until PstdMultiplePmtTerms_lRec.Next() = 0;
    end;
    //T12539-NE
}