//T12114-NS
pageextension 50020 "Page Ext 99000831 RPO" extends "Released Production Order"
{

    PromotedActionCategories = 'New,Process,Report,Posting,Release,Order,Documents,Print/Send,Navigate,Approval';
    layout
    {
        addafter("Last Date Modified")
        {
            field("Order Status"; Rec."Order Status")
            {
                ApplicationArea = All;
            }
        }
        addafter("Source No.")
        {
            field("Item No. 2"; Rec."Item No. 2")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Item No. 2 field.', Comment = '%';
                Visible = ItemVisible_gBln;
                Editable = false;
            }
            field("Production BOM Version"; Rec."Production BOM Version")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Production BOM Version field.', Comment = '%';
                Editable = EditibleProBomVersion_gBln;
            }
            field("Batch Quantity"; Rec."Batch Quantity")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Batch Quantity field.', Comment = '%';
            }
            field("Firm Planned Order No."; Rec."Firm Planned Order No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Firm Planned Order No. field.', Comment = '%';
                Editable = false;//Hypercare 27-02-2025
            }
        }
        //T12706-NS
        modify("Variant Code")
        {
            Visible = true;
        }
        //T12706-NE

    }

    actions
    {
        modify("Re&plan")
        {
            Enabled = ActionButtonVisible_gBln;
        }
        modify(RefreshProductionOrder)
        {
            Enabled = ActionButtonVisible_gBln;
        }
        addlast("O&rder")
        {
            group("Request Approval")
            {
                action("Send A&pproval request")
                {
                    Enabled = Not OpenApprovalEntriesExist_gBln ANd CanRequestApprovalForFlow_gBln;
                    Image = SendApprovalRequest;
                    Promoted = true;
                    PromotedCategory = Category10;
                    PromotedOnly = true;
                    ApplicationArea = ALL;
                    trigger OnAction()



                    begin
                        If ProductionOrderWorkflowMgmt.CheckProductionOrderApprovalWorkFlowEnable(Rec) then
                            ProductionOrderWorkflowMgmt.OnSendProductionOrderForApproval(Rec);
                    end;
                }
                action("Cancel Approval request")
                {
                    Enabled = CanCancelApprovalForRecord_gBln or CanCancelApprovalForFlow_gBln;
                    Image = CancelApprovalRequest;
                    Promoted = true;
                    PromotedCategory = Category10;
                    PromotedOnly = true;
                    ApplicationArea = ALL;
                    trigger OnAction()
                    var

                    begin
                        ProductionOrderWorkflowMgmt.OnCancleProductionOrderForApproval(Rec);
                    end;
                }
                action("Reopen Order Status")
                {
                    Promoted = true;
                    PromotedCategory = Category10;
                    PromotedOnly = true;
                    ApplicationArea = ALL;
                    Caption = 'Re&open Approval';
                    Image = ReOpen;
                    ToolTip = 'Reopen the document to change it after it has been approved. Approved documents have the Released status and must be opened before they can be changed.';

                    trigger OnAction()
                    var
                        ReleaseSalesDoc: Codeunit "Release Sales Document";
                    begin
                        if Rec."Order Status" = Rec."Order Status"::Open then
                            exit;

                        //OnBeforeReopenTransferDoc(ServHeader);
                        if Rec."Order Status" <> Rec."Order Status"::Released then
                            Error('Document must be released to Reopen it');

                        Rec.Validate("Order Status", Rec."Order Status"::Open);
                        Rec.Modify(true);

                    end;
                }
                action("Release Order Status")
                {
                    Promoted = true;
                    PromotedCategory = Category10;
                    PromotedOnly = true;
                    ApplicationArea = ALL;
                    Caption = 'Re&lease Approval';
                    Image = ReleaseDoc;
                    ToolTip = 'Release the document to the next stage of processing. You must reopen the document before you can make changes to it.';
                    Visible = ReleaseButtonVisible_gBln;
                    trigger OnAction()
                    var
                    begin
                        if Rec."Order Status" = Rec."Order Status"::Released then
                            exit;

                        if ProductionOrderWorkflowMgmt.IsProductionOrderApprovalWorkFlowEnable(Rec) then
                            Error('Kindly , use Send for Approval action for Sending approval.')
                        else begin
                            Rec."Order Status" := Rec."Order Status"::Released;
                            rec.Modify();
                        end;
                    end;
                }

                action(Approvals)
                {
                    AccessByPermission = TableData "Approval Entry" = R;
                    Promoted = true;
                    PromotedCategory = Category10;
                    PromotedOnly = true;
                    ApplicationArea = ALL;
                    Caption = 'Approvals';
                    Image = Approvals;
                    ToolTip = 'View a list of the records that are waiting to be approved. For example, you can see who requested the record to be approved, when it was sent, and when it is due to be approved.';
                    trigger OnAction()
                    var
                    begin
                        OpenApprovalsProduction(Rec);
                    end;
                }

                // action(Approve)
                // {
                //     Enabled = OpenApprovalEntriesExistforCurruser_gBln;
                //     Image = Approve;
                //     Promoted = true;
                //     PromotedIsBig = true;
                //     PromotedCategory = Category10;
                //     PromotedOnly = true;
                //     ApplicationArea = All;
                //     trigger OnAction()
                //     var
                //     begin
                //         ApprovalsMgmt_gCdu.ApproveRecordApprovalRequest(Rec.RecordId);
                //     end;
                // }


                // action(Reject)
                // {
                //     Enabled = OpenApprovalEntriesExistforCurruser_gBln;
                //     Image = Reject;
                //     Promoted = true;
                //     PromotedIsBig = true;
                //     PromotedCategory = Category10;
                //     PromotedOnly = true;
                //     ApplicationArea = All;
                //     trigger OnAction()
                //     var
                //     begin
                //         ApprovalsMgmt_gCdu.RejectRecordApprovalRequest(Rec.RecordId);
                //     end;
                // }

            }
        }
        addafter("Co&mments")
        {
            //T12607-NS
            action("Available Inventory")
            {
                ApplicationArea = All;
                Caption = 'Available Inventory';
                Promoted = true;
                Image = RoutingVersions;
                ToolTip = 'To view and assign the Available Inventory.';
                PromotedCategory = Process;
                trigger OnAction()
                var
                    ProductionBomHdr_lRec: Record "Production BOM Header";
                    ProductionBomLine_lRec: Record "Production BOM Line";
                    NewProductionBomLine_lRec: Record "Production BOM Line";
                    FindLastProdBomLine_lRec: Record "Production BOM Line";
                    ProductionBomLine_lPge: Page "Production Item Inventory";
                    Item_lRec: Record item;
                    SICdu: Codeunit ProductionInventory_SI;
                    Code_lCde: Code[20];
                    FindPBNo_lRec: Record "Production BOM Version";

                begin
                    clear(Code_lCde);
                    if (Rec."Source No." <> '') and (rec."Production BOM Version" <> '') then begin

                        ProductionBomLine_lRec.reset;
                        ProductionBomLine_lRec.SetFilter("Version Code", Rec."Production BOM Version");
                        ProductionBomLine_lRec.SetRange("No.", rec."Source No.");
                        if not ProductionBomLine_lRec.FindSet() then begin
                            FindPBNo_lRec.reset;
                            FindPBNo_lRec.SetFilter("Version Code", Rec."Production BOM Version");
                            if FindPBNo_lRec.FindSet() then;
                            NewProductionBomLine_lRec.init;
                            NewProductionBomLine_lRec."Production BOM No." := FindPBNo_lRec."Production BOM No.";
                            NewProductionBomLine_lRec."Version Code" := FindPBNo_lRec."Version Code";
                            NewProductionBomLine_lRec."Line No." := findLastLineNo_lFnc(FindPBNo_lRec."Production BOM No.", FindPBNo_lRec."Version Code");
                            NewProductionBomLine_lRec.Insert();
                            NewProductionBomLine_lRec."No." := rec."Source No.";
                            NewProductionBomLine_lRec.Description := rec.Description;
                            NewProductionBomLine_lRec."Quantity per" := 1;
                            NewProductionBomLine_lRec."Unit of Measure Code" := Item_lRec."Base Unit of Measure";
                            NewProductionBomLine_lRec.Modify();
                            Code_lCde := FindPBNo_lRec."Production BOM No.";
                            SICdu.SetMethod_gFnc(rec."Source No.", rec.Quantity, FindPBNo_lRec."Production BOM No.", FindPBNo_lRec."Version Code", NewProductionBomLine_lRec."Line No.");
                        end;
                        Commit();
                        Clear(ProductionBomLine_lPge);
                        ProductionBomLine_lRec.reset;
                        ProductionBomLine_lRec.SetRange("Production BOM No.", Code_lCde);
                        ProductionBomLine_lRec.SetRange("Version Code", rec."Production BOM Version");
                        ProductionBomLine_lPge.SetTableView(ProductionBomLine_lRec);
                        ProductionBomLine_lPge.Editable(false);
                        ProductionBomLine_lPge.RunModal();
                    end else if (Rec."Source No." <> '') and (rec."Production BOM Version" = '') then begin
                        Clear(Code_lCde);
                        Item_lRec.get(rec."Source No.");
                        ProductionBomLine_lRec.reset;
                        ProductionBomLine_lRec.SetRange("Production BOM No.", Item_lRec."Production BOM No.");
                        ProductionBomLine_lRec.SetRange("No.", rec."Source No.");
                        if not ProductionBomLine_lRec.FindSet() then begin
                            ProductionBomHdr_lRec.reset;
                            ProductionBomHdr_lRec.SetRange("No.", Item_lRec."Production BOM No.");
                            if ProductionBomHdr_lRec.FindSet() then;

                            NewProductionBomLine_lRec.init;
                            NewProductionBomLine_lRec."Production BOM No." := Item_lRec."Production BOM No.";
                            NewProductionBomLine_lRec."Version Code" := '';
                            NewProductionBomLine_lRec."Line No." := findLastLineNo_lFnc(Item_lRec."Production BOM No.", Rec."Production BOM Version");
                            NewProductionBomLine_lRec.Insert();
                            NewProductionBomLine_lRec."No." := rec."Source No.";
                            NewProductionBomLine_lRec.Description := rec.Description;
                            NewProductionBomLine_lRec."Quantity per" := 1;
                            NewProductionBomLine_lRec."Unit of Measure Code" := Item_lRec."Base Unit of Measure";
                            NewProductionBomLine_lRec.Modify();
                            Code_lCde := Rec."Production BOM Version";
                            SICdu.SetMethod_gFnc(rec."Source No.", rec.Quantity, Item_lRec."Production BOM No.", Rec."Production BOM Version", NewProductionBomLine_lRec."Line No.");
                        end;
                        Commit();
                        Clear(ProductionBomLine_lPge);
                        ProductionBomLine_lRec.reset;
                        ProductionBomLine_lRec.SetRange("Production BOM No.", Item_lRec."Production BOM No.");
                        ProductionBomLine_lRec.Setrange("Version Code", Code_lCde);
                        ProductionBomLine_lPge.SetTableView(ProductionBomLine_lRec);
                        ProductionBomLine_lPge.Editable(false);
                        ProductionBomLine_lPge.RunModal();
                    end;


                end;
            }
        }
        //T12607-NE
    }
    trigger OnOpenPage()
    begin
        if UserSetup_gRec.Get(UserId) then begin
            if UserSetup_gRec."Allow to view Item No.2" then
                ItemVisible_gBln := true
            else
                ItemVisible_gBln := false;
        end;
    END;

    trigger OnAfterGetRecord()
    var
        myInt: Integer;
    begin
        Editible_lFnc();
        OpenApprovalEntriesExistforCurruser_gBln := ApprovalsMgmt_gCdu.HasOpenApprovalEntriesForCurrentUser(Rec.RecordId);
        OpenApprovalEntriesExist_gBln := ApprovalsMgmt_gCdu.HasOpenApprovalEntries(Rec.RecordId);
        CanCancelApprovalForRecord_gBln := ApprovalsMgmt_gCdu.CanCancelApprovalForRecord(Rec.RecordId);
        WorkflowWebhookMgt_gCdu.GetCanRequestAndCanCancel(Rec.RecordId, CanRequestApprovalForFlow_gBln, CanCancelApprovalForFlow_gBln);
    end;

    trigger OnAfterGetCurrRecord()
    var
        myInt: Integer;
    begin
        Editible_lFnc();
    end;

    Local procedure Editible_lFnc()
    begin

        if rec."Order Status" in [rec."Order Status"::"Pending Approval", rec."Order Status"::Released] then begin
            ActionButtonVisible_gBln := false;
            EditibleProBomVersion_gBln := false;
        end else begin
            ActionButtonVisible_gBln := true;
            EditibleProBomVersion_gBln := true;
        end;

        if rec."Order Status" = rec."Order Status"::Released then
            ReleaseButtonVisible_gBln := false
        else
            ReleaseButtonVisible_gBln := true;
    end;

    local procedure OpenApprovalsProduction(ProductionOrder: Record "Production Order")
    begin
        RunWorkflowEntriesPage(
            ProductionOrder.RecordId(), DATABASE::"Production Order", Enum::"Approval Document Type"::Order, ProductionOrder."No.");
    end;

    Local procedure RunWorkflowEntriesPage(RecordIDInput: RecordID; TableId: Integer; DocumentType: Enum "Approval Document Type"; DocumentNo: Code[20])
    var
        ApprovalEntry: Record "Approval Entry";
        WorkflowWebhookEntry: Record "Workflow Webhook Entry";
        Approvals: Page Approvals;
        WorkflowWebhookEntries: Page "Workflow Webhook Entries";
        ApprovalEntries: Page "Approval Entries";
    begin

        // if we are looking at a particular record, we want to see only record related workflow entries
        if DocumentNo <> '' then begin
            ApprovalEntry.SetRange("Record ID to Approve", RecordIDInput);
            WorkflowWebhookEntry.SetRange("Record ID", RecordIDInput);
            // if we have flows created by multiple applications, start generic page filtered for this RecordID
            if not ApprovalEntry.IsEmpty() and not WorkflowWebhookEntry.IsEmpty() then begin
                Approvals.Setfilters(RecordIDInput);
                Approvals.Run();
            end else begin
                // otherwise, open the page filtered for this record that corresponds to the type of the flow
                if not WorkflowWebhookEntry.IsEmpty() then begin
                    WorkflowWebhookEntries.Setfilters(RecordIDInput);
                    WorkflowWebhookEntries.Run();
                    exit;
                end;

                if not ApprovalEntry.IsEmpty() then begin
                    ApprovalEntries.SetRecordFilters(TableId, DocumentType, DocumentNo);
                    ApprovalEntries.Run();
                    exit;
                end;

                // if no workflow exist, show (empty) joint workflows page
                Approvals.Setfilters(RecordIDInput);
                Approvals.Run();
            end
        end else
            // otherwise, open the page with all workflow entries
            Approvals.Run();
    end;

    //T12607-NS
    Local procedure findLastLineNo_lFnc(PBom_iCde: code[20]; VersionCode_iCde: Code[20]): Integer;
    var
        FindLastProdBomLine_lRec: Record "Production BOM Line";
        Lineno: Integer;
    begin
        FindLastProdBomLine_lRec.reset;
        FindLastProdBomLine_lRec.SetRange("Production BOM No.", PBom_iCde);
        if VersionCode_iCde <> '' then
            FindLastProdBomLine_lRec.SetRange("Version Code", VersionCode_iCde)
        else
            FindLastProdBomLine_lRec.SetRange("Version Code", VersionCode_iCde);

        if FindLastProdBomLine_lRec.FindLast() then
            exit(FindLastProdBomLine_lRec."Line No." + 10000)
        else
            exit(10000);

    end;
    //T12607-NE

    var
        UserSetup_gRec: Record "User Setup";
        ItemVisible_gBln: Boolean;
        EditibleProBomVersion_gBln: Boolean;
        WorkflowWebhookMgt_gCdu: Codeunit "Workflow Webhook Management";
        ApprovalsMgmt_gCdu: Codeunit "Approvals Mgmt.";
        OpenApprovalEntriesExistforCurruser_gBln: Boolean;
        OpenApprovalEntriesExist_gBln: Boolean;
        CanCancelApprovalForRecord_gBln: Boolean;
        CanCancelApprovalForFlow_gBln: Boolean;
        CanRequestApprovalForFlow_gBln: Boolean;
        ProductionOrderWorkflowMgmt: Codeunit "Production Order Workflow Mgmt";
        ActionButtonVisible_gBln: Boolean;
        ReleaseButtonVisible_gBln: Boolean;
}
//T12114-NE