codeunit 50034 "Subscribe Report 292"
{
    //T12539-NS
    [EventSubscriber(ObjectType::Report, Report::"Copy Sales Document", OnPreReportOnBeforeCopySalesDoc, '', false, false)]
    local procedure "Copy Sales Document_OnPreReportOnBeforeCopySalesDoc"(var Sender: Report "Copy Sales Document"; var CopyDocumentMgt: Codeunit "Copy Document Mgt."; DocType: Integer; DocNo: Code[20]; SalesHeader: Record "Sales Header"; CurrReportUseRequestPage: Boolean; IncludeHeader: Boolean; RecalculateLines: Boolean; ExactCostReversingMandatory: Boolean)
    var
        MultiplePmtTerms_lRec: Record "Multiple Payment Terms";
        CopyMultiplePmtTerms_lRec: Record "Multiple Payment Terms";
        SalesEnum: Enum "Sales Document Type";
    begin
        If SalesHeader."Document Type" = SalesHeader."Document Type"::Quote then
            exit;


        Case DocType of
            2:
                SalesEnum := SalesEnum::Order;
            3:
                SalesEnum := SalesEnum::Invoice;
            4:
                SalesEnum := SalesEnum::"Return Order";
            5:
                SalesEnum := SalesEnum::"Credit Memo";
        End;

        MultiplePmtTerms_lRec.Reset();
        MultiplePmtTerms_lRec.SetRange(Type, MultiplePmtTerms_lRec.Type::Sales);
        MultiplePmtTerms_lRec.SetRange("Document No.", DocNo);
        MultiplePmtTerms_lRec.SetRange("Document Type", SalesEnum);
        If MultiplePmtTerms_lRec.FindSet() then
            repeat
                CopyMultiplePmtTerms_lRec.Reset();
                CopyMultiplePmtTerms_lRec.Init();
                CopyMultiplePmtTerms_lRec.TransferFields(MultiplePmtTerms_lRec);
                CopyMultiplePmtTerms_lRec."Document No." := SalesHeader."No.";
                CopyMultiplePmtTerms_lRec."Document Type" := SalesHeader."Document Type";
                CopyMultiplePmtTerms_lRec.Released := false;
                CopyMultiplePmtTerms_lRec.Posted := false;
                CopyMultiplePmtTerms_lRec.Insert();
            until MultiplePmtTerms_lRec.Next() = 0;
    end;
    //T12539-NE


}