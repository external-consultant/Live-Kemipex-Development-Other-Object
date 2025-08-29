page 50003 "Due & Outstanding Purch. Inv"
{
    //T12141-N 
    ApplicationArea = All;
    Caption = 'Due & Outstanding Purchase Invoice';
    PageType = CardPart;

    layout
    {
        area(Content)
        {
            cuegroup("Purchase Invoices")
            {
                field(DuePurchInvoicesCount; DuePurchInvoicesCount)
                {
                    Caption = 'Due Purchase Invoices';
                    ApplicationArea = All;

                    trigger OnDrillDown()
                    var
                        VendLedgEntry_lRec: Record "Vendor Ledger Entry";
                        VendLedgEntries_lPge: page "Vendor Ledger Entries";
                    begin
                        VendLedgEntry_lRec.Reset();
                        VendLedgEntry_lRec.SetRange(Open, true);
                        VendLedgEntry_lRec.SetRange("Document Type", VendLedgEntry_lRec."Document Type"::Invoice);
                        VendLedgEntry_lRec.SetFilter("Due Date", '<=%1', Today);
                        If VendLedgEntry_lRec.FindSet() then begin
                            Clear(VendLedgEntries_lPge);
                            VendLedgEntries_lPge.SetTableView(VendLedgEntry_lRec);
                            VendLedgEntries_lPge.Run();
                        end;

                    end;
                }
                field(OutstandingPurchInvoicesCount; OutstandingPurchInvoicesCount)
                {
                    Caption = 'Outstanding Purchase Invoices';
                    ApplicationArea = All;

                    trigger OnDrillDown()
                    var
                        VendLedgEntry_lRec: Record "Vendor Ledger Entry";
                        VendLedgEntries_lPge: page "Vendor Ledger Entries";
                    begin
                        VendLedgEntry_lRec.Reset();
                        VendLedgEntry_lRec.SetRange(Open, true);
                        VendLedgEntry_lRec.SetRange("Document Type", VendLedgEntry_lRec."Document Type"::Invoice);
                        If VendLedgEntry_lRec.FindSet() then begin
                            Clear(VendLedgEntries_lPge);
                            VendLedgEntries_lPge.SetTableView(VendLedgEntry_lRec);
                            VendLedgEntries_lPge.Run();
                        end;

                    end;
                }
            }
        }
    }

    trigger OnOpenPage()
    var
        VendLedgEntry_lRec: Record "Vendor Ledger Entry";

    begin
        VendLedgEntry_lRec.Reset();
        VendLedgEntry_lRec.SetRange(Open, true);
        VendLedgEntry_lRec.SetRange("Document Type", VendLedgEntry_lRec."Document Type"::Invoice);
        If VendLedgEntry_lRec.FindSet() then begin
            OutstandingPurchInvoicesCount := VendLedgEntry_lRec.Count;
        end;

        VendLedgEntry_lRec.Reset();
        VendLedgEntry_lRec.SetRange(Open, true);
        VendLedgEntry_lRec.SetRange("Document Type", VendLedgEntry_lRec."Document Type"::Invoice);
        VendLedgEntry_lRec.SetFilter("Due Date", '<=%1', Today);
        If VendLedgEntry_lRec.FindSet() then begin
            DuePurchInvoicesCount := VendLedgEntry_lRec.Count;
        end;
    end;

    var

        DuePurchInvoicesCount: Integer;
        OutstandingPurchInvoicesCount: Integer;
}
