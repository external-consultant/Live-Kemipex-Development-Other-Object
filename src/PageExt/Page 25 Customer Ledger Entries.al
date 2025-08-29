pageextension 50091 CustledgEntriesExt50091 extends "Customer Ledger Entries"
{
    layout
    {
        // Add changes to page layout here
    }

    actions
    {
        addlast(processing)
        {
            //T12539-NS
            action("Show Multiple Payment Terms")
            {
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Image = SendToMultiple;
                PromotedOnly = true;
                trigger OnAction()
                var
                    PstdMultiplePmtTerms_lRec: Record "Posted Multiple Payment Terms";
                    PstdMultiplePmtTerms_lPge: Page "Posted Multiple Payment Terms";
                begin
                    PstdMultiplePmtTerms_lRec.Reset();
                    PstdMultiplePmtTerms_lRec.SetRange("Document No.", Rec."Document No.");
                    PstdMultiplePmtTerms_lRec.SetRange(Type, PstdMultiplePmtTerms_lRec.Type::Sales);
                    if Rec."Document Type" = Rec."Document Type"::Invoice then
                        PstdMultiplePmtTerms_lRec.SetRange("Document Type", PstdMultiplePmtTerms_lRec."Document Type"::"Posted Sales Invoice")
                    else if Rec."Document Type" = rec."Document Type"::"Credit Memo" then
                        PstdMultiplePmtTerms_lRec.SetRange("Document Type", PstdMultiplePmtTerms_lRec."Document Type"::"Posted Sales Cr. Memo");
                    If PstdMultiplePmtTerms_lRec.FindSet() then begin
                        Clear(PstdMultiplePmtTerms_lPge);
                        PstdMultiplePmtTerms_lPge.SetTableView(PstdMultiplePmtTerms_lRec);
                        PstdMultiplePmtTerms_lPge.Run();
                    end else
                        Message('No Multiple Payment Terms For %1 Document No.', Rec."Document No.");

                end;
            }
            //T12539-NE
        }
    }

}