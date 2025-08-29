//T12114-NS
page 50002 "Location Routing"
{
    Caption = 'Location Routing';
    PageType = List;
    SourceTable = "Location Routing";

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                Caption = 'General';

                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Item No. field.', Comment = '%';
                }
                field("Location Code"; Rec."Location Code")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Location Code field.', Comment = '%';
                }
                field(Routing; Rec.Routing)
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Routing field.', Comment = '%';
                }
            }
        }
    }
}
//T12114-NE
