codeunit 50046 "Subscribe Codeunit 414"
{
    //T12539-NS
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Release Sales Document", OnAfterManualReOpenSalesDoc, '', false, false)]
    local procedure "Release Sales Document_OnAfterManualReOpenSalesDoc"(var SalesHeader: Record "Sales Header"; PreviewMode: Boolean)
    var
        MultiplePmtTerms_lRec: Record "Multiple Payment Terms";
    begin
        If SalesHeader."Document Type" = SalesHeader."Document Type"::Quote then
            exit;

        If SalesHeader.Status <> SalesHeader.Status::Released then begin
            MultiplePmtTerms_lRec.Reset();
            MultiplePmtTerms_lRec.SetRange(Type, MultiplePmtTerms_lRec.Type::Sales);
            MultiplePmtTerms_lRec.SetRange("Document No.", SalesHeader."No.");
            MultiplePmtTerms_lRec.SetRange("Document Type", SalesHeader."Document Type");
            If MultiplePmtTerms_lRec.FindSet() then
                repeat
                    MultiplePmtTerms_lRec.Released := false;
                    MultiplePmtTerms_lRec.Modify();
                until MultiplePmtTerms_lRec.Next() = 0;
        end;
    end;
    //T12539-NE

}