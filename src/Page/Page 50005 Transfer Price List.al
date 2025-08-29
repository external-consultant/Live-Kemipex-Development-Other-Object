page 50005 "Transfer Price List"
{
    ApplicationArea = All;
    Caption = 'Transfer Price List';
    PageType = List;
    SourceTable = "Transfer Price List";
    UsageCategory = Lists;
    DelayedInsert = true;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Type Of Transaction"; Rec."Type Of Transaction")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Type Of Transaction field.', Comment = '%';

                    trigger OnValidate()
                    var
                        myInt: Integer;
                    begin
                        EditableMergin();
                    end;
                }
                field("IC Partner Code"; Rec."IC Partner Code")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Inter Company Customer Partner Code field.', Comment = '%';
                }

                field("Starting Date"; Rec."Starting Date")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Starting Date field.', Comment = '%';
                }
                field("Ending Date"; Rec."Ending Date")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Ending Date field.', Comment = '%';
                }
                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Item No. field.', Comment = '%';
                }
                field("Variant Code"; Rec."Variant Code")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Variant Code field.', Comment = '%';
                }
                field("Unit of Measure"; Rec."Unit of Measure")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Unit of Measure field.', Comment = '%';
                }
                field("Currency Code"; Rec."Currency Code")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Currency Code field.', Comment = '%';
                }
                field(Price; Rec.Price)
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Price field.', Comment = '%';
                }
                field("Margin %"; Rec."Margin %")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Margin % field.', Comment = '%';
                    Editable = Mergin;
                }
            }
        }
    }


    trigger OnAfterGetRecord()
    var
    begin
        EditableMergin
    end;


    procedure EditableMergin()
    var
        myInt: Integer;
    begin
        If Rec."Type Of Transaction" = Rec."Type Of Transaction"::Purchase then
            Mergin := false
        else
            Mergin := true;
    end;

    var
        Mergin: Boolean;

}
