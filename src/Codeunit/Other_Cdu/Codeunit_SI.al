codeunit 50037 ProductionInventory_SI
{
    SingleInstance = true;
    trigger OnRun()
    begin

    end;

    procedure SetMethod_gFnc(ItemNo_iCde: Code[20]; ReqQty_iDec: decimal; BOM_iCde: Code[20]; VersionCode_iCde: code[20]; LineNo_iInt: Integer)
    begin
        Clear(ReqQty_gDec);
        Clear(ItemNo_gCde);
        Clear(BOM_gCde);
        Clear(VersionCode_gCde);
        Clear(LineNo_gInt);
        ItemNo_gCde := ItemNo_iCde;
        ReqQty_gDec := ReqQty_iDec;
        BOM_gCde := BOM_iCde;
        VersionCode_gCde := VersionCode_iCde;
        LineNo_gInt := LineNo_iInt;



    end;

    procedure GetItemValue(): Code[20]
    var
    begin
        exit(ItemNo_gCde);
    end;

    procedure GetReqQtyValue(): Decimal
    var
    begin
        exit(ReqQty_gDec);
    end;

    procedure GetBOMCdeValue(): Code[20]
    var
    begin
        exit(BOM_gCde);
    end;

    procedure GetVesrionCdeValue(): Code[20]
    var
    begin
        exit(VersionCode_gCde);
    end;

    procedure GetLineValue(): Integer
    var
    begin
        exit(LineNo_gInt);
    end;

    var
        ItemNo_gCde: Code[20];
        ReqQty_gDec: Decimal;
        BOM_gCde: Code[20];
        VersionCode_gCde: Code[20];
        LineNo_gInt: Integer;

}