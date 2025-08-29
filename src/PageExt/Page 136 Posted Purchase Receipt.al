pageextension 50054 PostedPurchReceiptExt50054 extends "Posted Purchase Receipt"
{
    layout
    {
        //T12141-NS
        addlast(Shipping)
        {
            group("Logistic Details")
            {
                field("Vehicle No_New"; Rec."Vehicle No_New")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Vehicle No field.', Comment = '%';
                }
                field("Container Code"; Rec."Container Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Container Code field.', Comment = '%';
                }
                field("Container Plat No."; Rec."Container Plat No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Container Plat No. field.', Comment = '%';
                }
                field("Container Seal No."; Rec."Container Seal No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Container Seal No. field.', Comment = '%';
                }
            }
        }
        //T12141-NE
        // addafter("Location Code")
        addafter("Ship-to")
        {
            field("Location Change Remarks"; rec."Location Change Remarks")//T12436-N
            {
                ApplicationArea = All;
            }
        }


    }
}