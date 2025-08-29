codeunit 50035 "Sibscribe Table 122"
{
    //T12539-NS
    [EventSubscriber(ObjectType::Table, Database::"Purch. Inv. Header", 'OnAfterDeleteEvent', '', false, false)]
    local procedure PurchaseHeader_OnAfterDeletEvent(var Rec: Record "Purch. Inv. Header")
    var
        PostedMultiplePmtTerms_lRec: Record "Posted Multiple Payment Terms";
    begin
        If Rec.IsTemporary then
            exit;

        PostedMultiplePmtTerms_lRec.Reset();
        PostedMultiplePmtTerms_lRec.SetRange("Document No.", Rec."No.");
        PostedMultiplePmtTerms_lRec.SetRange(Type, PostedMultiplePmtTerms_lRec.Type::Purchase);
        PostedMultiplePmtTerms_lRec.SetRange("Document Type", PostedMultiplePmtTerms_lRec."Document Type"::"Posted Purchase Invoice");
        If PostedMultiplePmtTerms_lRec.FindSet() then
            repeat
                PostedMultiplePmtTerms_lRec.DeleteAll(true);
            until PostedMultiplePmtTerms_lRec.Next() = 0;
    end;
    //T12539-NE
}