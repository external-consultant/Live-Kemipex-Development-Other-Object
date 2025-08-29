//T12068-NS
pageextension 50180 "PageExt 119 User Setup" extends "User Setup"
{
    layout
    {

        addafter("Purch. Invoice Posting Policy")
        {
            field("Allow to View R&D Also"; Rec."Allow to View R&D Also")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Allow to View R&D Also field.', Comment = '%';
                Description = 'T12113';
            }
            field("Allow to view Item No.2"; Rec."Allow to view Item No.2")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Allow to view Item No.2 field.', Comment = '%';
                Description = '//T12114-N';
            }
            field("Allow to view Item Sub"; Rec."Allow to view Item Sub")
            {
                ApplicationArea = All;
                Caption = 'Allow to view Item Substitution';
                ToolTip = 'Specifies the value of the Allow to view Item Substitution field.', Comment = '%';
                Description = '//T12114-N';
            }
            field("Allow to Reserve"; Rec."Allow to Reserve")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the value of the Allow to Reserve field.';
            }
            //T13396-NS
            field("Allow view Hidden Product Code"; Rec."Allow view Hidden Product Code")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Allow view Hidden Product Code field.', Comment = '%';
            }
            //T13396-NE
            field("Out of Office"; rec."Out of Office")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Out of Office field.';
                trigger OnValidate()
                var
                begin
                    // if rec."Out of Office" then
                    //     rec.TestField(Substitute);
                end;
            }
            field(Substitute; Rec.Substitute)
            {
                ApplicationArea = Basic;
            }

            field("Linked SalesPersons"; Rec."Linked SalesPersons")
            {
                ApplicationArea = all;

                trigger OnLookup(var Text: Text): Boolean
                var
                    SP_lPge: Page "Salespersons/Purchasers";
                begin
                    Clear(SP_lPge);
                    SP_lPge.SetMarkRecords(Rec."Linked SalesPersons");
                    SP_lPge.Editable(false);
                    SP_lPge.LookupMode(TRUE);
                    IF SP_lPge.RunModal() = Action::LookupOK Then begin
                        Rec."Linked SalesPersons" := SP_lPge.GetMarkRecords();
                        IF Rec."Linked SalesPersons" <> '' then
                            Rec."Linked SalesPersons" += '|' + '''''';
                        Rec.Modify();
                    end;
                end;
            }


        }

    }
    //T12068-NE

    actions
    {
        // Add changes to page actions here
    }

    var
    // myInt: Integer;
}