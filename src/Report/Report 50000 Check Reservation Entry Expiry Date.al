//T12068-NS
Report 50000 "Check ReservEntry ExpiryDate"
{
    Caption = 'Check Reservation Entry Expiry Date';
    ApplicationArea = all;
    UsageCategory = Administration;
    ProcessingOnly = true;
    dataset
    {
        dataitem("Reservation Entry"; "Reservation Entry")
        {
            DataItemTableView = sorting("Entry No.") order(ascending);
            RequestFilterFields = "Entry No.", "Source ID";
            trigger OnAfterGetRecord()
            var
                ReservEngineMgt: Codeunit "Reservation Engine Mgt.";
            begin
                CurrentRec_gDec += 1;
                Windows_gDlg.Update(2, CurrentRec_gDec);

                Clear(ReservEngineMgt);
                ReservEngineMgt.CancelReservation("Reservation Entry");
                Commit();
            end;

            trigger OnPostDataItem()
            begin
                Windows_gDlg.Close;
            end;

            trigger OnPreDataItem()
            begin

                SetFilter("Creation Date", '<%1', ExpiryDateValue_gDte);
                SetRange("Reservation Status", "Reservation Entry"."Reservation Status"::Reservation);
                SetRange(Positive, TRUE);
                SetFilter("Source Type", '%1', 32);  //ILE - In Future we will add more source type

                Windows_gDlg.Open('Total Record : #1#########\' + 'Current Record : #2##########\');
                Windows_gDlg.Update(1, Count);
            end;
        }
    }
    requestpage
    {
        layout
        {
        }
        actions
        {
        }
    }

    labels
    {
    }
    trigger OnPreReport()
    var
    begin
        SalnRecSetup_gRec.GET;
        SalnRecSetup_gRec.TestField("Reservation Expiry Days");
        ExpiryDateValue_gDte := CalcDate('<-' + Format(SalnRecSetup_gRec."Reservation Expiry Days") + '>', Today);
    end;

    var
        Windows_gDlg: Dialog;
        CurrentRec_gDec: Decimal;
        SalnRecSetup_gRec: Record "Sales & Receivables Setup";
        ExpiryDateValue_gDte: Date;

}
//T12068-NE