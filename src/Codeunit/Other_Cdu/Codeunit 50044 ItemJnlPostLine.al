codeunit 50044 ItemJnlPostLine
{
    Permissions = TableData "Reservation Entry" = d;
    trigger OnRun()    
    begin        
    end;
    procedure ItemJnlLineDeleteAll_gFnc(Rec: Record "Item Journal Line")
    var
        ItemJournalLine: Record "Item Journal Line";
        ReservationEntry_lRec: Record "Reservation Entry";
        count_Int: Integer;
        ResCount: Integer;        
    begin
        if not Confirm('Would you like to Delete all data?') then
            exit;
        ResCount :=0; 
        ItemJournalLine.Reset();
        ItemJournalLine.SetRange("Journal Template Name", Rec."Journal Template Name");
        ItemJournalLine.SetRange("Journal Batch Name", Rec."Journal Batch Name");
        if ItemJournalLine.findSet then
        count_Int := ItemJournalLine.Count;
        Message('Total Record Find %1 against Template %2 - %3',count_Int,ItemJournalLine."Journal Template Name",ItemJournalLine."Journal Batch Name"); 
        count_Int :=0; 
               
        Repeat
            ReservationEntry_lRec.Reset();
            ReservationEntry_lRec.SetRange("Source Type", 83);
            ReservationEntry_lRec.SetRange("Source Subtype", ReservationEntry_lRec."Source Subtype"::"2");
            ReservationEntry_lRec.SetRange("Source ID", ItemJournalLine."Journal Template Name");
            ReservationEntry_lRec.SetRange("Source Batch Name", ItemJournalLine."Journal Batch Name");
            ReservationEntry_lRec.SetRange("Source Ref. No.", ItemJournalLine."Line No.");
            ReservationEntry_lRec.SetRange("Item No.", ItemJournalLine."Item No.");
            ReservationEntry_lRec.SetRange("Location Code", ItemJournalLine."Location Code");            
            if ReservationEntry_lRec.FindSet() then begin                
                repeat
                 ResCount +=1;
                 //Message('%1',ReservationEntry_lRec."Item No.");
                ReservationEntry_lRec.Delete(true);
                until ReservationEntry_lRec.next = 0;
            end;

             count_Int += 1;
            ItemJournalLine.Delete(true);
        until ItemJournalLine.next = 0;
        Message('Total Record Item Jnl Line %1 and Reservation Entry %2 is deleted', count_Int,ResCount);
    end;

    // //T12971-NS
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Jnl.-Post Line", OnSetupSplitJnlLineOnBeforeSplitTempLines, '', false, false)]
    local procedure "Item Jnl.-Post Line_OnSetupSplitJnlLineOnBeforeSplitTempLines"(var TempSplitItemJournalLine: Record "Item Journal Line" temporary; var TempTrackingSpecification: Record "Tracking Specification" temporary)
    begin
        TempTrackingSpecification.FindSet();
        repeat
            if CheckWarrantyDateExist_lFnc(TempTrackingSpecification) then
                if (TempTrackingSpecification."Warranty Date" = 0D) then
                    Error('Manufacturing Date must have a value in Item Tracking Line.');
        until TempTrackingSpecification.next = 0;

    end;

    procedure CheckWarrantyDateExist_lFnc(var TempTrackingSpecification: Record "Tracking Specification" temporary): Boolean
    var
        ItemTrackingCode_gRec: Record "Item Tracking Code";
        Location_lRec: Record Location;
        Item_lRec: Record Item;
    begin
        //need to apply only for custom Error-

        Item_lRec.Get(TempTrackingSpecification."Item No.");
        if Item_lRec."Item Tracking Code" <> '' then begin
            ItemTrackingCode_gRec.Get(Item_lRec."Item Tracking Code");
            if (ItemTrackingCode_gRec."Man. Warranty Date Entry Reqd.") then
                exit(true)
            else
                exit(false);
        end;
    end;
    //T12971-NE
    }

   
