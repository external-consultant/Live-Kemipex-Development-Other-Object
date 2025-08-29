//T12068-NS
pageextension 50015 SalesPurcP50015 extends "Salespersons/Purchasers"
{

    layout
    {
        addfirst(Control1)
        {
            field(MarkRecord_gBln; MarkRecord_gBln)
            {
                Caption = 'Mark Record';
                ApplicationArea = All;
                Visible = ViewMarkingActionField_gBln;
                StyleExpr = StyleExp_gTxt;

                trigger OnValidate()
                begin
                    IF MarkRecord_gBln then
                        SelectedRec.Add(Rec.Code)
                    Else
                        SelectedRec.Remove(Rec.Code);
                end;
            }
        }
    }

    actions
    {
        addfirst(processing)
        {

            action("Mark")
            {
                ApplicationArea = All;
                Visible = ViewMarkingActionField_gBln;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Image = Approval;
                ShortcutKey = F2;

                trigger OnAction()
                begin
                    SelectedRec.Add(Rec.Code)
                end;
            }

            action("Unmark")
            {
                ApplicationArea = All;
                Visible = ViewMarkingActionField_gBln;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Image = Reject;
                ShortcutKey = F3;

                trigger OnAction()
                begin
                    IF SelectedRec.Contains(Rec.Code) Then
                        SelectedRec.Remove(Rec.Code);
                end;
            }


            action("View Only Mark Records")
            {
                ApplicationArea = All;
                Visible = ViewMarkingActionField_gBln;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Image = MakeOrder;

                trigger OnAction()
                Var
                    i: Integer;
                begin
                    Rec.RESET;
                    For i := 1 to SelectedRec.Count Do begin
                        Rec.SetRange(Code, SelectedRec.Get(i));
                        Rec.FindFirst();
                        Rec.Mark(TRUE);
                    end;
                    Rec.SetRange(Code);
                    Rec.MarkedOnly(true);
                end;
            }

            action("View All Records")
            {
                ApplicationArea = All;
                Visible = ViewMarkingActionField_gBln;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Image = AllLines;

                trigger OnAction()
                begin
                    Rec.RESET;
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    var
        myInt: Integer;
    begin
        MarkRecord_gBln := false;
        StyleExp_gTxt := 'Normal';
        IF SelectedRec.Contains(Rec.Code) then begin
            MarkRecord_gBln := true;
            StyleExp_gTxt := 'Favorable';
        End;
    end;

    procedure SetMarkRecords(SelectedValues_iTxt: Text)
    var
        SP_lRec: Record "Salesperson/Purchaser";
    begin
        ViewMarkingActionField_gBln := true;
        IF SelectedValues_iTxt <> '' Then begin
            SP_lRec.Reset();
            SP_lRec.SetFilter(Code, SelectedValues_iTxt);
            IF SP_lRec.FindSet() Then begin
                repeat
                    SelectedRec.Add(SP_lRec.Code);
                until SP_lRec.Next = 0;
            end;
        end;
    end;


    procedure GetMarkRecords(): Text;
    var
        SelectRecord_lTxt: Text;
        i: Integer;
    begin
        SelectRecord_lTxt := '';
        For i := 1 to SelectedRec.Count Do begin
            IF SelectRecord_lTxt = '' then
                SelectRecord_lTxt := SelectedRec.Get(i)
            Else
                SelectRecord_lTxt += '|' + SelectedRec.Get(i);
        end;

        Exit(SelectRecord_lTxt);
    end;

    procedure GetMarkRecordsWithastriek(): Text;
    var
        SelectRecord_lTxt: Text;
        i: Integer;
    begin
        SelectRecord_lTxt := '';
        For i := 1 to SelectedRec.Count Do begin
            IF SelectRecord_lTxt = '' then
                SelectRecord_lTxt := SelectedRec.Get(i)
            Else
                SelectRecord_lTxt += '*|*' + SelectedRec.Get(i);
        end;

        Exit(SelectRecord_lTxt);
    end;

    var
        SelectedRec: List of [Text];
        MarkRecord_gBln: Boolean;
        ViewMarkingActionField_gBln: Boolean;
        StyleExp_gTxt: Text;

}
//T12068-NE