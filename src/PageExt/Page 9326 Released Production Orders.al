pageextension 50327 RelPrdord50123 extends "Released Production Orders"
{
    layout
    {
        //T12706-NS
        addafter("Source No.")
        {

            field("Variant Code"; Rec."Variant Code")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the variant code for production order item.';
            }
            field("Firm Planned Order No."; Rec."Firm Planned Order No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Firm Planned Order No. field.', Comment = '%';
                Editable = false;//Hypercare 27-02-2025
            }
        }
    }
    //T12706-NE
}
