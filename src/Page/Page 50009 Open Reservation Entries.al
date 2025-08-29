page 50009 "Open Reservation Entries"
{
    //TABA-N 080824 Create New Part Page
    Caption = 'Activities';
    PageType = CardPart;
    RefreshOnActivate = true;
    ShowFilter = false;
    SourceTable = "Reservation Entry";

    layout
    {
        area(content)
        {
            cuegroup(Control54)
            {
                Caption = 'Open Reservation Entries';
                field(OpenReservationCount_gInt; OpenReservationCount_gInt)
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the Count of the Open Reservation Entries.';
                    Caption = 'Open Reservation Entries';
                    Style = Attention;
                    StyleExpr = true;

                    trigger OnDrillDown()
                    var
                        ReservationList_lPge: Page "Reservation Entries";
                        Reservation_lRec: Record "Reservation Entry";
                    begin
                        clear(ExpiryDateValue_gDte);
                        Clear(ReservationList_lPge);
                        SalesSetup_gRec.Get();
                        if not SalesSetup_gRec.Get() then
                            exit;
                        SalesSetup_gRec.TestField("Reservation Expiry Days");
                        ExpiryDateValue_gDte := CalcDate('<-' + Format(SalesSetup_gRec."Reservation Expiry Days") + '>', Today + 5);

                        Reservation_lRec.Reset();
                        Reservation_lRec.SetRange("Reservation Status", Reservation_lRec."Reservation Status"::Reservation);
                        Reservation_lRec.SetRange("Source Type", 32);
                        Reservation_lRec.SetFilter("Creation Date", '<%1', ExpiryDateValue_gDte);
                        ReservationList_lPge.SetTableView(Reservation_lRec);
                        ReservationList_lPge.Editable(false);
                        ReservationList_lPge.RunModal();
                    end;
                }
            }
        }
    }
    trigger OnAfterGetRecord()
    var
        myInt: Integer;
        Reservation_lRec: Record "Reservation Entry";
    begin
        SalesSetup_gRec.Get();
        clear(ExpiryDateValue_gDte);
        if not SalesSetup_gRec.Get() then
            exit;
        SalesSetup_gRec.TestField("Reservation Expiry Days");
        ExpiryDateValue_gDte := CalcDate('<-' + Format(SalesSetup_gRec."Reservation Expiry Days") + '>', Today + 5);
        Reservation_lRec.Reset();
        Reservation_lRec.SetRange("Reservation Status", Reservation_lRec."Reservation Status"::Reservation);
        Reservation_lRec.SetRange("Source Type", 32);
        Reservation_lRec.SetFilter("Creation Date", '<%1', ExpiryDateValue_gDte);
        if Reservation_lRec.FindSet() then begin
            OpenReservationCount_gInt := Reservation_lRec.Count;
        end;
    end;

    var
        OpenReservationCount_gInt: Integer;
        SalesSetup_gRec: Record "Sales & Receivables Setup";
        ExpiryDateValue_gDte: Date;
        NewExpiryDateValue_gDte: date;
}

