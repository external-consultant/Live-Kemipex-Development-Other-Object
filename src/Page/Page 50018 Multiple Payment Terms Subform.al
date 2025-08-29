page 50018 "Multiple Payment Terms Subform"
{
    //T12539-N
    Caption = 'Multiple Payment Terms';
    PageType = ListPart;
    SourceTable = "Multiple Payment Terms";
    DelayedInsert = true;
    DeleteAllowed = true;
    InsertAllowed = true;
    ModifyAllowed = true;
    ApplicationArea = all;


    layout
    {
        area(Content)
        {
            repeater(General)
            {
                // field("Table ID"; Rec."Table ID")
                // {
                //     ToolTip = 'Specifies the value of the Table ID field.', Comment = '%';
                // }
                // field("Type"; Rec."Type")
                // {
                //     ToolTip = 'Specifies the value of the Type field.', Comment = '%';
                // }

                // field("Document Type"; Rec."Document Type")
                // {
                //     ToolTip = 'Specifies the value of the Document Type field.', Comment = '%';
                // }
                // field("Line No."; Rec."Line No.")
                // {
                //     ToolTip = 'Specifies the value of the Line No. field.', Comment = '%';
                // }
                field("Document No."; Rec."Document No.")
                {
                    ToolTip = 'Specifies the value of the Document No. field.', Comment = '%';
                    Editable = IsSalesLinesEditable;

                }
                field("Event Date"; Rec."Event Date")
                {
                    ToolTip = 'Specifies the value of the Event Date field.', Comment = '%';

                }
                field("Payment Description"; Rec."Payment Description")
                {
                    ToolTip = 'Specifies the value of the Payment Description field.', Comment = '%';
                    Editable = IsSalesLinesEditable;

                }
                field("Due Date Calculation"; Rec."Due Date Calculation")
                {
                    ToolTip = 'Specifies the value of the Due Date Calculation field.', Comment = '%';
                    Editable = IsSalesLinesEditable;

                }
                field("Due Date"; Rec."Due Date")
                {
                    ToolTip = 'Specifies the value of the Due Date field.', Comment = '%';
                    Editable = IsSalesLinesEditable;

                }
                field("Percentage of Total"; Rec."Percentage of Total")
                {
                    ToolTip = 'Specifies the value of the Percentage of Total field.', Comment = '%';
                    Editable = IsSalesLinesEditable;

                }
                field("Amount of Document"; Rec."Amount of Document")
                {
                    ToolTip = 'Specifies the value of the Amount of Document field.', Comment = '%';
                    Editable = IsSalesLinesEditable;

                }
                field("Remaining Amount"; Rec."Remaining Amount")
                {
                    ToolTip = 'Specifies the value of the Remaining Amount field.', Comment = '%';
                    Editable = IsSalesLinesEditable;

                }
                field("Payment Forecast Date"; Rec."Payment Forecast Date")
                {
                    ToolTip = 'Specifies the value of the Payment Forecast Date field.', Comment = '%';
                    Editable = IsSalesLinesEditable;

                }
                field(Sequence; Rec.Sequence)
                {
                    ToolTip = 'Specifies the value of the Sequence field.', Comment = '%';
                    Editable = IsSalesLinesEditable;

                }
                field(Released; Rec.Released)
                {
                    ToolTip = 'Specifies the value of the Released field.', Comment = '%';
                    Editable = IsSalesLinesEditable;

                    trigger OnValidate()
                    var
                        myInt: Integer;
                    begin
                        EditableFields();
                    end;

                }
                field(Posted; Rec.Posted)
                {
                    ToolTip = 'Specifies the value of the Posted field.', Comment = '%';
                    Editable = IsSalesLinesEditable;

                }
            }
        }
    }

    trigger OnAfterGetRecord()
    var
    begin
        EditableFields();
    end;

    trigger OnOpenPage()
    var
    begin
        EditableFields();
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    var
    begin
        if SalesHeader_gRec.Get(Rec."Document Type", Rec."Document No.") then begin
            Rec.Validate("Table ID", 36);
            //Rec.Sequence := 1;
            Rec.Validate(Type, Rec.Type::Sales);
            SalesHeader_gRec.CalcFields("Amount Including VAT");
            if SalesHeader_gRec."Document Type" in [SalesHeader_gRec."document type"::Order, SalesHeader_gRec."document type"::Invoice, SalesHeader_gRec."document type"::"Return Order", SalesHeader_gRec."document type"::"Credit Memo"] then begin
                SalesHeader_gRec.TestField("Document Date");
                // Rec."Event Date" := SalesHeader_gRec."Document Date";

            end;
            case SalesHeader_gRec."Document Type" of
                SalesHeader_gRec."Document Type"::Order:
                    begin
                        Rec."Document Type" := Rec."Document Type"::Order;
                    end;
                SalesHeader_gRec."Document Type"::Invoice:
                    begin
                        Rec."Document Type" := Rec."Document Type"::Invoice;
                    end;
                SalesHeader_gRec."Document Type"::"Credit Memo":
                    begin
                        Rec."Document Type" := Rec."Document Type"::"Credit Memo";
                    end;
                SalesHeader_gRec."Document Type"::"Return Order":
                    begin
                        Rec."Document Type" := Rec."Document Type"::"Return Order";
                    end;
                SalesHeader_gRec."Document Type"::"Blanket Order":
                    begin
                        Rec."Document Type" := Rec."Document Type"::"Blanket Order";
                    end;
            end;
        end else
            if PurchaseHeader_gRec.Get(Rec."Document Type", Rec."Document No.") then begin
                Rec.Validate("Table ID", 38);
                //Rec.Sequence := 1;

                Rec.Validate(Type, Rec.Type::Purchase);
                PurchaseHeader_gRec.CalcFields("Amount Including VAT");
                if PurchaseHeader_gRec."Document Type" in [PurchaseHeader_gRec."document type"::Order, PurchaseHeader_gRec."document type"::Invoice, PurchaseHeader_gRec."document type"::"Return Order", PurchaseHeader_gRec."document type"::"Credit Memo"] then begin
                    PurchaseHeader_gRec.TestField("Document Date");

                    // Rec."Event Date" := PurchaseHeader_gRec."Document Date";
                end;
                case PurchaseHeader_gRec."Document Type" of
                    PurchaseHeader_gRec."Document Type"::Order:
                        begin
                            Rec."Document Type" := Rec."Document Type"::Order;
                        end;
                    PurchaseHeader_gRec."Document Type"::Invoice:
                        begin
                            Rec."Document Type" := Rec."Document Type"::Invoice;
                        end;
                    PurchaseHeader_gRec."Document Type"::"Credit Memo":
                        begin
                            Rec."Document Type" := Rec."Document Type"::"Credit Memo";
                        end;
                    PurchaseHeader_gRec."Document Type"::"Return Order":
                        begin
                            Rec."Document Type" := Rec."Document Type"::"Return Order";
                        end;
                    PurchaseHeader_gRec."Document Type"::"Blanket Order":
                        begin
                            Rec."Document Type" := Rec."Document Type"::"Blanket Order";
                        end;
                end;
            end;

    end;

    trigger OnDeleteRecord(): Boolean
    var
        myInt: Integer;
    begin
        //IF (Rec."Document Type" <> Rec."Document Type"::Invoice) AND (Rec."Document Type" <> Rec."Document Type"::"Credit Memo") then begin
        IF Rec.Released Or Rec.Posted then
            Error('Record delete not allowed');
        //end;

    end;

    var
        SalesHeader_gRec: Record "Sales Header";
        PurchaseHeader_gRec: Record "Purchase Header";
        IsSalesLinesEditable: Boolean;//T12539-N



    procedure EditableFields()
    var

    begin
        IsSalesLinesEditable := false;
        If Not Rec.Released then
            IsSalesLinesEditable := true;

    end;





}
