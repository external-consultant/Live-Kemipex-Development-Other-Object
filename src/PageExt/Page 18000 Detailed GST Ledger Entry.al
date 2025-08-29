pageextension 50071 DetailGSTLedEntry50071 extends "Detailed GST Ledger Entry"
{
    layout
    {
        addafter("Reconciliation Year")
        {
            //T12539-NS
            field("GST Credit Period Month"; Rec."GST Credit Period Month")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the GST Credit Period Month field.', Comment = '%';
            }
            field("GST Credit Period Year"; Rec."GST Credit Period Year")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the GST Credit Period Year field.', Comment = '%';
            }
            //T12539-NE
        }
    }
    actions
    {
        addafter("Show Related Information")
        {
            //T12539-NS
            action("Reconcile GST Credits")
            {
                ApplicationArea = All;
                Image = CreditMemo;
                PromotedCategory = Process;
                Promoted = true;
                PromotedOnly = true;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    DtldGSTLedgEntry_lRec: Record "Detailed GST Ledger Entry";
                    MarkDtldGSTLedgEntry_lRec: Record "Detailed GST Ledger Entry";
                    UpdateFieldsDtldGSTLedgEntry_lRec: Record "Detailed GST Ledger Entry";
                    UpdDtlGSTLedgEntry_lRpt: Report "Update Detail GST Ledger Entry";
                begin
                    CurrPage.SetSelectionFilter(DtldGSTLedgEntry_lRec);
                    If DtldGSTLedgEntry_lRec.FindSet() then
                        repeat
                            MarkDtldGSTLedgEntry_lRec.Get(DtldGSTLedgEntry_lRec."Entry No.");
                            MarkDtldGSTLedgEntry_lRec.Mark(true);
                            MarkDtldGSTLedgEntry_lRec.TestField("Credit Availed", True);
                            MarkDtldGSTLedgEntry_lRec.TestField("Reconciliation Month", 0);
                            MarkDtldGSTLedgEntry_lRec.TestField("Reconciliation Year", 0);
                            MarkDtldGSTLedgEntry_lRec.TestField("GST Credit Period Month", 0);
                            MarkDtldGSTLedgEntry_lRec.TestField("GST Credit Period Year", 0);
                        until DtldGSTLedgEntry_lRec.Next() = 0;

                    MarkDtldGSTLedgEntry_lRec.MarkedOnly(true);
                    If MarkDtldGSTLedgEntry_lRec.FindSet() then begin
                        repeat
                            Clear(UpdDtlGSTLedgEntry_lRpt);
                            UpdDtlGSTLedgEntry_lRpt.SetTableView(MarkDtldGSTLedgEntry_lRec);
                        until MarkDtldGSTLedgEntry_lRec.Next() = 0;
                        UpdDtlGSTLedgEntry_lRpt.Run();
                    end;
                end;
            }
            //T12539-NE
        }

    }

}