codeunit 50022 "Table 454 App. Ent. Subs"
{
    trigger OnRun()
    begin

    end;
    //T12141-NS
    [EventSubscriber(ObjectType::Table, Database::"Approval Entry", 'OnBeforeInsertEvent', '', true, true)]
    local procedure ApprovalEntry_OnBeforeInsertEvent_OutofOffice(var Rec: Record "Approval Entry")
    var
        UserSetup_lRec: Record "User Setup";
        SubstitureUserID: Code[50];
    begin
        if UserId <> Rec."Approver ID" then begin
            UserSetup_lRec.Reset();
            UserSetup_lRec.Get(Rec."Approver ID");
            if UserSetup_lRec."Out of Office" then begin
                Clear(SubstitureUserID);
                UserSetup_lRec.TestField(Substitute);
                SubstitureUserID := FindSubstitute(SubstitureUserID, UserSetup_lRec);
                Rec."Approver ID" := SubstitureUserID;
            end;
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Approval Entry", 'OnBeforeInsertEvent', '', true, true)]
    local procedure ApprovalEntry_OnBeforeInsertEvent(var Rec: Record "Approval Entry")
    var
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
        Customer_lRec: Record Customer;
        Vendor_lRec: Record Vendor;
        Item_lRec: Record Item;
        RecRef: RecordRef;
        RecValue_ltxt: Text;
        Strlength_lInt: Integer;
        Strvalue_lcod: Code[20];
    begin

        if Rec.Status = Rec.Status::Approved then begin
            if Rec."Table ID" = Database::Customer then begin
                RecValue_ltxt := '';
                RecValue_ltxt := Format(Rec."Record ID to Approve");
                Strlength_lInt := StrLen(RecValue_ltxt);
                Strvalue_lcod := CopyStr(RecValue_ltxt, 11, Strlength_lInt);
                // Message(Strvalue_ltxt);
                Customer_lRec.Reset();
                Customer_lRec.SetRange("No.", Strvalue_lcod);
                if Customer_lRec.FindFirst() then begin
                    Clear(Customer_lRec."Workflow Category Type");
                    if not Customer_lRec."First Approval Completed" then
                        Customer_lRec."First Approval Completed" := true;
                    Customer_lRec.Modify();
                end;
            end;
            if Rec."Table ID" = Database::Vendor then begin
                RecValue_ltxt := '';
                RecValue_ltxt := Format(Rec."Record ID to Approve");
                Strlength_lInt := StrLen(RecValue_ltxt);
                Strvalue_lcod := CopyStr(RecValue_ltxt, 9, Strlength_lInt);
                // Message(Strvalue_ltxt);
                Vendor_lRec.Reset();
                Vendor_lRec.SetRange("No.", Strvalue_lcod);
                if Vendor_lRec.FindFirst() then begin
                    Clear(Vendor_lRec."Workflow Category Type");
                    if not Vendor_lRec."First Approval Completed" then
                        Vendor_lRec."First Approval Completed" := true;
                    Vendor_lRec.Modify();
                end;
            end;
            if Rec."Table ID" = Database::Item then begin
                RecValue_ltxt := '';
                RecValue_ltxt := Format(Rec."Record ID to Approve");
                Strlength_lInt := StrLen(RecValue_ltxt);
                Strvalue_lcod := CopyStr(RecValue_ltxt, 7, Strlength_lInt);
                // Message(Strvalue_ltxt);
                Item_lRec.Reset();
                Item_lRec.SetRange("No.", Strvalue_lcod);
                if Item_lRec.FindFirst() then begin
                    Clear(Item_lRec."Workflow Category Type");
                    if not Item_lRec."First Approval Completed" then
                        Item_lRec."First Approval Completed" := true;
                    Item_lRec.Modify();
                end;
            end;
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Approval Entry", 'OnBeforeModifyEvent', '', true, true)]
    local procedure "Approval Entry_OnBeforeModifyEvent"(var Rec: Record "Approval Entry"; var xRec: Record "Approval Entry"; RunTrigger: Boolean)
    var
        Customer_lRec: Record Customer;
        Vendor_lRec: Record Vendor;
        Item_lRec: Record Item;
        RecRef: RecordRef;
        RecValue_ltxt: Text;
        Strlength_lInt: Integer;
        Strvalue_lcod: Code[20];
    begin
        if Rec.Status = Rec.Status::Approved then begin
            if Rec."Table ID" = Database::Customer then begin
                RecValue_ltxt := '';
                RecValue_ltxt := Format(Rec."Record ID to Approve");
                Strlength_lInt := StrLen(RecValue_ltxt);
                Strvalue_lcod := CopyStr(RecValue_ltxt, 11, Strlength_lInt);
                // Message(Strvalue_ltxt);
                Customer_lRec.Reset();
                Customer_lRec.SetRange("No.", Strvalue_lcod);
                if Customer_lRec.FindFirst() then begin
                    Clear(Customer_lRec."Workflow Category Type");
                    if not Customer_lRec."First Approval Completed" then
                        Customer_lRec."First Approval Completed" := true;
                    Customer_lRec.Modify();
                end;
            end;
            if Rec."Table ID" = Database::Vendor then begin
                RecValue_ltxt := '';
                RecValue_ltxt := Format(Rec."Record ID to Approve");
                Strlength_lInt := StrLen(RecValue_ltxt);
                Strvalue_lcod := CopyStr(RecValue_ltxt, 9, Strlength_lInt);
                // Message(Strvalue_ltxt);
                Vendor_lRec.Reset();
                Vendor_lRec.SetRange("No.", Strvalue_lcod);
                if Vendor_lRec.FindFirst() then begin
                    Clear(Vendor_lRec."Workflow Category Type");
                    if not Vendor_lRec."First Approval Completed" then
                        Vendor_lRec."First Approval Completed" := true;
                    Vendor_lRec.Modify();
                end;
            end;
            if Rec."Table ID" = Database::Item then begin
                RecValue_ltxt := '';
                RecValue_ltxt := Format(Rec."Record ID to Approve");
                Strlength_lInt := StrLen(RecValue_ltxt);
                Strvalue_lcod := CopyStr(RecValue_ltxt, 7, Strlength_lInt);
                // Message(Strvalue_ltxt);
                Item_lRec.Reset();
                Item_lRec.SetRange("No.", Strvalue_lcod);
                if Item_lRec.FindFirst() then begin
                    Clear(Item_lRec."Workflow Category Type");
                    if not Item_lRec."First Approval Completed" then
                        Item_lRec."First Approval Completed" := true;
                    Item_lRec.Modify();
                end;
            end;
        end;
    end;
    //T12141-NE

    procedure FindSubstitute(var SubstitureUserID: Code[50]; CurreUserSetupRecord: Record "User Setup"): Code[50]
    var
        UserSetuo_lRec: Record "User Setup";
    begin
        UserSetuo_lRec.Reset();
        UserSetuo_lRec.Get(CurreUserSetupRecord.Substitute);
        if UserSetuo_lRec."Out of Office" then
            FindSubstitute(SubstitureUserID, CurreUserSetupRecord)
        else begin
            SubstitureUserID := CurreUserSetupRecord.Substitute;
            exit(SubstitureUserID);
        end;
    end;

}