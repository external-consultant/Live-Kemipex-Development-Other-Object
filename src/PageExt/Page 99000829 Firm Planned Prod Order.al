//T12114-NS
pageextension 50028 "PagExt 99000829 Firm PlannedPO" extends "Firm Planned Prod. Order"
{
    layout
    {
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
        }


    }
    actions
    {
        //T12607-NS
        addafter("Co&mments")
        {
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
        Editible_lFnc;
        ItemVisible_gBln := false;
        if UserSetup_gRec.Get(UserId) then
            if UserSetup_gRec."Allow to view Item No.2" then
                ItemVisible_gBln := true;

    end;

    trigger OnAfterGetRecord()
    var
        myInt: Integer;
    begin
        Editible_lFnc();
    end;

    trigger OnAfterGetCurrRecord()
    var
        myInt: Integer;
    begin
        Editible_lFnc();
    end;

    Local procedure Editible_lFnc()
    begin

        if rec."Order Status" in [rec."Order Status"::"Pending Approval", rec."Order Status"::Released] then
            EditibleProBomVersion_gBln := false
        else
            EditibleProBomVersion_gBln := true;

    end;

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

    var
        UserSetup_gRec: Record "User Setup";
        ItemVisible_gBln: Boolean;
        EditibleProBomVersion_gBln: Boolean;
}
//T12114-NE