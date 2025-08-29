report 50005 "Update Detail GST Ledger Entry"
{
    //T12539-N 
    Caption = 'Update Detailed GST Ledger Entry';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    ProcessingOnly = true;
    Permissions = tabledata "Detailed GST Ledger Entry" = RM;

    dataset
    {
        dataitem("Detailed GST Ledger Entry"; "Detailed GST Ledger Entry")
        {
            trigger OnAfterGetRecord()
            var
                DtldGSTLedgEntry_lRec: Record "Detailed GST Ledger Entry";
            begin
                DtldGSTLedgEntry_lRec.Reset();
                DtldGSTLedgEntry_lRec.SetRange("Entry No.", "Detailed GST Ledger Entry"."Entry No.");
                If DtldGSTLedgEntry_lRec.FindSet() then
                    repeat


                        DtldGSTLedgEntry_lRec.Validate("Reconciliation Month", ReconciliationMonth);
                        DtldGSTLedgEntry_lRec.Validate("Reconciliation Year", ReconciliationYear);
                        DtldGSTLedgEntry_lRec.Validate("GST Credit Period Month", GSTCreditPeriodMonth);
                        DtldGSTLedgEntry_lRec.Validate("GST Credit Period Year", GSTCreditPeriodYear);
                        DtldGSTLedgEntry_lRec.Modify(true);
                    until DtldGSTLedgEntry_lRec.Next() = 0;
            end;
        }
    }


    requestpage
    {
        layout
        {
            area(Content)
            {
                group(GroupName)
                {
                    field(ReconciliationMonth; ReconciliationMonth)
                    {
                        Caption = 'Reconciliation Month';
                        ApplicationArea = All;
                        MaxValue = 12;
                        MinValue = 1;
                    }
                    field(ReconciliationYear; ReconciliationYear)
                    {
                        Caption = 'Reconciliation Year';
                        ApplicationArea = All;
                        MaxValue = 2999;
                        MinValue = 1900;
                    }
                    field(GSTCreditPeriodMonth; GSTCreditPeriodMonth)
                    {
                        Caption = 'GST Credit Period Month';
                        ApplicationArea = All;
                        MaxValue = 12;
                        MinValue = 1;
                    }
                    field(GSTCreditPeriodYear; GSTCreditPeriodYear)
                    {
                        Caption = 'GST Credit Period Year';
                        ApplicationArea = All;
                        MaxValue = 2999;
                        MinValue = 1900;
                    }
                }
            }
        }


    }



    var
        ReconciliationMonth: Integer;
        ReconciliationYear: Integer;
        GSTCreditPeriodMonth: Integer;
        GSTCreditPeriodYear: Integer;


}