page 50007 "Field Mand. Templ. Setup"
{
    PageType = List;
    ApplicationArea = Basic, Suite;
    UsageCategory = Administration;
    Caption = 'Field Mandatory Template Setup';
    SourceTable = "Field Mand. Templ. Setup";
    Description = 'T12141';

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Record Type"; Rec."Record Type")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Record Type';
                    ToolTip = 'Specifies the type of Record that the entry belongs to.';
                }
                field("Select Condition"; SelectCondition)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Condition';
                    Editable = false;
                    ToolTip = 'Specifies the conditions required for this series to be used.';

                    trigger OnAssistEdit()
                    var
                        RequestPage: Codeunit "Field Mandatory Setup Mgmt.";
                    begin
                        SelectCondition := '';
                        RequestPage.OpendynamicRequestPage(Rec);
                        SelectCondition := GetConditionAsDisplayText();
                    end;
                }
                field("Config. Template"; Rec."Config. Template")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the Config. Template field.', Comment = '%';
                    InstructionalText = 'Template Code';
                }
                field(Enabled; Rec.Enabled)
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the Enabled field.', Comment = '%';
                }

            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        SelectCondition := '';
        if Rec."Table Id" <> 0 then
            SelectCondition := GetConditionAsDisplayText();
            
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        SelectCondition := '';
    end;

    trigger OnClosePage()
    begin

    end;

    var
        SelectCondition: Text;
        ObjectIDNotFoundErr: Label 'Error : Table ID %1 not found', Comment = '%1=Table Id';
        FieldMandSetup_gRec: Record "Field Mand. Templ. Setup";

    procedure GetConditionAsDisplayText(): Text
    var
        Allobj: Record AllObj;
        RecordRef: RecordRef;
        IStream: InStream;
        COnditionText: Text;
        ExitMsg: Label 'Always';
    begin
        if not Allobj.Get(Allobj."Object Type"::Table, Rec."Table Id") then
            exit(StrSubstNo(ObjectIDNotFoundErr, Rec."Table Id"));
        RecordRef.Open(Rec."Table ID");
        Rec.CalcFields(Condition);
        if not Rec.Condition.HasValue() then
            exit(ExitMsg);

        Rec.Condition.CreateInStream(IStream);
        IStream.Read(COnditionText);
        RecordRef.SetView(COnditionText);
        if RecordRef.GetFilters() <> '' then
            exit(RecordRef.GetFilters());
        RecordRef.Close();
    end;

    local procedure ConvertEventConditionsToFilters(var RecRef: RecordRef): Boolean
    var
        TempBlob: Codeunit "Temp Blob";
        RequestPageParametersHelper: Codeunit "Request Page Parameters Helper";
    begin
        if Rec.Condition.HasValue() then begin
            Rec.CalcFields(Condition);
            TempBlob.FromRecord(Rec, Rec.FieldNo(Condition));
            RequestPageParametersHelper.ConvertParametersToFilters(RecRef, TempBlob);
        end;
    end;
}