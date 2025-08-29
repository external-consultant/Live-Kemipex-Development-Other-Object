pageextension 50089 ChartOfAccExt50089 extends "Chart of Accounts"
{
    layout
    {
        //T12539-NS
        addbefore(Balance)
        {

            field("Opening Balance"; Rec."Opening Balance")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Opening Balance field.', Comment = '%';
                Editable = false;
            }
        }
        //T12539-NE
    }
    var
        Amount_gDec: Decimal;//T12539-N

    //T12539-NS
    trigger OnAfterGetRecord()
    var
        GLEntry_lRec: Record "G/L Entry";
        AccountingPeriod_lRec: Record "Accounting Period";
        Enddate_dt: Date;
    begin
        Amount_gDec := 0;
        Enddate_dt := 0D;

        AccountingPeriod_lRec.Reset();
        AccountingPeriod_lRec.SetRange("New Fiscal Year", true);
        AccountingPeriod_lRec.SetFilter("Starting Date", '<%1', WorkDate());
        if AccountingPeriod_lRec.FindFirst() then
            Enddate_dt := AccountingPeriod_lRec."Starting Date";

        IF Enddate_dt <> 0D THEN begin
            case Rec."Account Type" of
                Rec."Account Type"::Posting:
                    begin
                        GLEntry_lRec.Reset();
                        GLEntry_lRec.SetRange("G/L Account No.", Rec."No.");
                        GLEntry_lRec.SetRange("Posting Date", 0D, Enddate_dt);
                        If GLEntry_lRec.FindSet() then begin
                            repeat
                                Amount_gDec := Amount_gDec + GLEntry_lRec.Amount;
                            until GLEntry_lRec.Next() = 0;
                        end;
                    end;
                Rec."Account Type"::"End-Total":
                    begin
                        GLEntry_lRec.Reset();
                        GLEntry_lRec.SetRange("Posting Date", 0D, Enddate_dt);
                        GLEntry_lRec.SetFilter("G/L Account No.", Rec.Totaling);
                        If GLEntry_lRec.FindSet() then begin
                            repeat
                                Amount_gDec := Amount_gDec + GLEntry_lRec.Amount;
                            until GLEntry_lRec.Next() = 0;
                        end;
                    end;
                else
            end;
        end;

        Rec."Opening Balance" := Amount_gDec;
    end;
    //T12539-NE

    //T13420 NS
    trigger OnOpenPage()
    var
        FilterTextVar: Text;
        RecRef: RecordRef;
        FieldRef: FieldRef;
    begin
        RecRef.GetTable(Rec);
        FieldRef := RecRef.Field(Rec.FieldNo(Blocked));
        rec.SetRange(Blocked, false);
        CurrPage.SetTableView(Rec);
    end;
    //T13420 NE
}