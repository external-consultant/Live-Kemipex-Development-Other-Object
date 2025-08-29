codeunit 50013 "Item List Subs"
{
    //T12113-NS
    [EventSubscriber(ObjectType::Page, Page::"Item List", OnOpenPageEvent, '', false, false)]
    local procedure "Item List_OnOpenPageEvent"(var Rec: Record Item)
    var
        UserSetup_lRec: Record "User Setup";
    begin
        UserSetup_lRec.Get(UserId);
        if UserSetup_lRec."Allow to View R&D Also" then begin
            Rec.FilterGroup(2);
            Rec.SetFilter("R&D", '%1|%2', true, false);
            Rec.FilterGroup(0);
        end else
            if not UserSetup_lRec."Allow to View R&D Also" then begin
                Rec.FilterGroup(2);
                Rec.SetRange("R&D", false);
                Rec.FilterGroup(0);
            end;
    end;

    [EventSubscriber(ObjectType::Page, Page::"Production BOM List", OnOpenPageEvent, '', false, false)]
    local procedure "Production BOM List _OnOpenPageEvent"(var Rec: Record "Production BOM Header")
    var
        UserSetup_lRec: Record "User Setup";
    begin
        UserSetup_lRec.Get(UserId);
        if UserSetup_lRec."Allow to View R&D Also" then begin
            Rec.FilterGroup(2);
            Rec.SetFilter("R&D", '%1|%2', true, false);
            Rec.FilterGroup(0);
        end else
            if not UserSetup_lRec."Allow to View R&D Also" then begin
                Rec.FilterGroup(2);
                Rec.SetRange("R&D", false);
                Rec.FilterGroup(0);
            end;
    end;

    [EventSubscriber(ObjectType::Page, Page::"Routing List", OnOpenPageEvent, '', false, false)]
    local procedure "Routing List_OnOpenPageEvent"(var Rec: Record "Routing Header")
    var
        UserSetup_lRec: Record "User Setup";
    begin
        UserSetup_lRec.Get(UserId);
        if UserSetup_lRec."Allow to View R&D Also" then begin
            Rec.FilterGroup(2);
            Rec.SetFilter("R&D", '%1|%2', true, false);
            Rec.FilterGroup(0);
        end else
            if not UserSetup_lRec."Allow to View R&D Also" then begin
                Rec.FilterGroup(2);
                Rec.SetRange("R&D", false);
                Rec.FilterGroup(0);
            end;
    end;
    //T12113-NE
}