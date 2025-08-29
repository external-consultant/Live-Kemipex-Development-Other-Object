codeunit 50030 Subscriber83_ItemJournalLine
{
    trigger OnRun()
    begin

    end;
    //T10082024-NS
    [EventSubscriber(ObjectType::Table, Database::"Item Journal Line", 'OnAfterValidateEvent', 'Starting Time', false, false)]
    local procedure OnAfterValidateEvent_StartingTime(var Rec: Record "Item Journal Line")
    begin
        If Rec.IsTemporary then
            exit;
        If Rec."Entry Type" = Rec."Entry Type"::Output then begin
            Rec."Ending Time" := 0T;
        end;
    end;


    [EventSubscriber(ObjectType::Table, Database::"Item Journal Line", 'OnAfterValidateEvent', 'Ending Time', false, false)]
    local procedure OnAfterValidateEvent_EndingTime(var Rec: Record "Item Journal Line")
    var
        CapacityUnitofMeasure_lRec: Record "Capacity Unit of Measure";
        Runtime_lDec: Decimal;
    begin
        Runtime_lDec := 0;
        If Rec.IsTemporary then
            exit;
        If Rec."Entry Type" = Rec."Entry Type"::Output then begin
            If Rec."Ending Time" < Rec."Starting Time" then
                Error('Ending Time Should be less than Start Time');
            If CapacityUnitofMeasure_lRec.Get(Rec."Cap. Unit of Measure Code") then begin
                if CapacityUnitofMeasure_lRec.Type = CapacityUnitofMeasure_lRec.Type::Hours then begin
                    Runtime_lDec := (Rec."Ending Time" - Rec."Starting Time") / 60000;
                    Rec."Run Time" := Runtime_lDec / 60;
                end
                Else if CapacityUnitofMeasure_lRec.Type = CapacityUnitofMeasure_lRec.Type::Minutes then
                    Rec."Run Time" := (Rec."Ending Time" - Rec."Starting Time") / 60000;
            end;
            If Rec."Concurrent Capacity" > 0 then
                Rec."Run Time" := Rec."Run Time" * Rec."Concurrent Capacity";
        End;
    end;

    //T10082024-NE

    var
        myInt: Integer;
}