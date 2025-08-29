codeunit 50043 "Subscribe Table 380"
{
    //T12539-NS
    [EventSubscriber(ObjectType::Table, Database::"Detailed Vendor Ledg. Entry", 'OnAfterInsertEvent', '', false, false)]
    local procedure DetailedVendLdEntry_OnAfterInsertEvent(var Rec: Record "Detailed Vendor Ledg. Entry")
    var
        VendLedgEntry_lRec: Record "Vendor Ledger Entry";
        RemainingAmount_ldec: Decimal;
    begin
        If Rec.IsTemporary then
            exit;

        CalCulateRemainingAmount(Rec);
    end;
    //T12539-NE


    //T12539-NS
    [EventSubscriber(ObjectType::Table, Database::"Detailed Vendor Ledg. Entry", 'OnAfterModifyEvent', '', false, false)]
    local procedure DetailedVendLdEntry_OnAfterModifyEvent(var Rec: Record "Detailed Vendor Ledg. Entry")
    var
        VendLedgEntry_lRec: Record "Vendor Ledger Entry";
        RemainingAmount_ldec: Decimal;
    begin
        If Rec.IsTemporary then
            exit;

        CalCulateRemainingAmount(Rec);
    end;
    //T12539-NE

    //T12539-NS
    procedure CalCulateRemainingAmount(var Rec: Record "Detailed Vendor Ledg. Entry")
    var
        VendLedgEntry_lRec: Record "Vendor Ledger Entry";
        PstdMultiplePmtTerms_lRec: Record "Posted Multiple Payment Terms";
        RemainingAmount_ldec: Decimal;
    begin
        if Rec."Entry Type" <> Rec."Entry Type"::Application then
            exit;

        RemainingAmount_ldec := Rec.Amount;
        if RemainingAmount_ldec = 0 then exit;

        VendLedgEntry_lRec.Reset();
        VendLedgEntry_lRec.SetRange("Entry No.", Rec."Vendor Ledger Entry No.");
        If VendLedgEntry_lRec.FindFirst() then begin
            PstdMultiplePmtTerms_lRec.Reset();
            PstdMultiplePmtTerms_lRec.SetCurrentKey("Document No.", Type, Sequence);
            if not Rec.Unapplied then
                PstdMultiplePmtTerms_lRec.SetAscending(Sequence, true)
            else
                PstdMultiplePmtTerms_lRec.SetAscending(Sequence, false);
            PstdMultiplePmtTerms_lRec.SetRange("Document No.", VendLedgEntry_lRec."Document No.");
            PstdMultiplePmtTerms_lRec.SetRange(Type, PstdMultiplePmtTerms_lRec.Type::Purchase);
            if VendLedgEntry_lRec."Document Type" = VendLedgEntry_lRec."Document Type"::Invoice then
                PstdMultiplePmtTerms_lRec.SetRange("Document Type", PstdMultiplePmtTerms_lRec."Document Type"::"Posted Purchase Invoice")
            else if VendLedgEntry_lRec."Document Type" = VendLedgEntry_lRec."Document Type"::"Credit Memo" then
                PstdMultiplePmtTerms_lRec.SetRange("Document Type", PstdMultiplePmtTerms_lRec."Document Type"::"Posted Purchase Cr. Memo");
            If PstdMultiplePmtTerms_lRec.FindSet() then
                repeat
                    if not Rec.Unapplied then begin
                        if PstdMultiplePmtTerms_lRec."Remaining Amount" <> 0 then begin
                            if Abs(PstdMultiplePmtTerms_lRec."Remaining Amount") > Abs(RemainingAmount_ldec) then begin
                                if PstdMultiplePmtTerms_lRec."Remaining Amount" > 0 then begin
                                    PstdMultiplePmtTerms_lRec."Remaining Amount" := PstdMultiplePmtTerms_lRec."Remaining Amount" - Abs(RemainingAmount_ldec);
                                end
                                else begin
                                    PstdMultiplePmtTerms_lRec."Remaining Amount" := PstdMultiplePmtTerms_lRec."Remaining Amount" + Abs(RemainingAmount_ldec);
                                end;
                                RemainingAmount_ldec := 0;
                            end
                            else
                                if Abs(PstdMultiplePmtTerms_lRec."Remaining Amount") = Abs(RemainingAmount_ldec) then begin
                                    PstdMultiplePmtTerms_lRec."Remaining Amount" := 0;
                                    RemainingAmount_ldec := 0;
                                end else begin
                                    RemainingAmount_ldec := RemainingAmount_ldec + PstdMultiplePmtTerms_lRec."Remaining Amount";
                                    PstdMultiplePmtTerms_lRec."Remaining Amount" := 0
                                end;
                            PstdMultiplePmtTerms_lRec.Modify();
                        end;
                    end
                    else begin
                        if Abs(PstdMultiplePmtTerms_lRec."Remaining Amount") < Abs(PstdMultiplePmtTerms_lRec."Amount of Document") then begin
                            if (Abs(PstdMultiplePmtTerms_lRec."Amount of Document") - Abs(PstdMultiplePmtTerms_lRec."Remaining Amount")) >= Abs(RemainingAmount_ldec) then begin
                                if PstdMultiplePmtTerms_lRec."Amount of Document" > 0 then begin
                                    PstdMultiplePmtTerms_lRec."Remaining Amount" := PstdMultiplePmtTerms_lRec."Remaining Amount" + Abs(RemainingAmount_ldec);
                                end
                                else begin
                                    PstdMultiplePmtTerms_lRec."Remaining Amount" := PstdMultiplePmtTerms_lRec."Remaining Amount" - Abs(RemainingAmount_ldec);
                                end;
                                RemainingAmount_ldec := 0;
                            end
                            else begin
                                if RemainingAmount_ldec > 0 then
                                    RemainingAmount_ldec := RemainingAmount_ldec - (Abs(PstdMultiplePmtTerms_lRec."Amount of Document") - Abs(PstdMultiplePmtTerms_lRec."Remaining Amount"))
                                else
                                    RemainingAmount_ldec := RemainingAmount_ldec + (Abs(PstdMultiplePmtTerms_lRec."Amount of Document") - Abs(PstdMultiplePmtTerms_lRec."Remaining Amount"));

                                if PstdMultiplePmtTerms_lRec."Amount of Document" > 0 then begin
                                    PstdMultiplePmtTerms_lRec."Remaining Amount" := PstdMultiplePmtTerms_lRec."Remaining Amount" + (Abs(PstdMultiplePmtTerms_lRec."Amount of Document") - Abs(PstdMultiplePmtTerms_lRec."Remaining Amount"));
                                end
                                else begin
                                    PstdMultiplePmtTerms_lRec."Remaining Amount" := PstdMultiplePmtTerms_lRec."Remaining Amount" - (Abs(PstdMultiplePmtTerms_lRec."Amount of Document") - Abs(PstdMultiplePmtTerms_lRec."Remaining Amount"));
                                end;
                            end;
                            PstdMultiplePmtTerms_lRec.Modify();
                        end
                    end;
                until (PstdMultiplePmtTerms_lRec.Next() = 0) or (RemainingAmount_ldec = 0);
        end;
    end;
    //T12539-NS
}