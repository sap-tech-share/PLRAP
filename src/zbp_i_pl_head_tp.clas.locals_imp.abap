CLASS lhc_Plist DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR Plist RESULT result.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR Plist RESULT result.

    METHODS earlynumbering_create FOR NUMBERING
      IMPORTING entities FOR CREATE Plist.

    METHODS SetStatusComplete FOR MODIFY
      IMPORTING keys FOR ACTION Plist~SetStatusComplete RESULT result.

    METHODS SetInitialStatus FOR DETERMINE ON MODIFY
      IMPORTING keys FOR Plist~SetInitialStatus.

    METHODS ValidatePlate FOR VALIDATE ON SAVE
      IMPORTING keys FOR Plist~ValidatePlate.
    METHODS earlynumbering_cba_Plattach FOR NUMBERING
      IMPORTING entities FOR CREATE Plist\_Plattach.

ENDCLASS.

CLASS lhc_Plist IMPLEMENTATION.

  METHOD get_instance_features.
  ENDMETHOD.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD earlynumbering_create.

    DATA(lt_entities) = entities.
    SELECT max(  plist ) FROM ztab_pl_head into @DATA(lv_max_plist).
    SELECT max(  plist ) FROM ztab_pl_head_d into @DATA(lv_max_plist_d).
    if lv_max_plist_d gt lv_max_plist.
        lv_max_plist = lv_max_plist_d.
    endif.

    LOOP AT lt_entities INTO data(ls_entity).
        lv_max_plist = lv_max_plist + 1.
        ls_entity-Plist = |{ lv_max_plist ALPHA = IN }|.

        APPEND VALUE #( %cid = ls_entity-%cid %is_draft = ls_entity-%is_draft plist = ls_entity-Plist ) TO mapped-plist.
    ENDLOOP.
  ENDMETHOD.

  METHOD SetStatusComplete.
    MODIFY ENTITIES OF zi_pl_head_tp IN LOCAL MODE
      ENTITY Plist
         UPDATE
           FIELDS ( Status )
           WITH VALUE #( FOR key IN keys
                           ( %tky         = key-%tky
                             Status = key-%param-status ) )
      FAILED failed
      REPORTED reported.

*   Read the changed values and update result
    READ ENTITIES OF zi_pl_head_tp IN LOCAL MODE
      ENTITY Plist
        ALL FIELDS WITH CORRESPONDING #( keys )
      RESULT DATA(lt_plist).

    result = VALUE #( FOR ls_plist IN lt_plist
                        ( %tky   = ls_plist-%tky
                          %param = ls_plist ) ).
  ENDMETHOD.

  METHOD SetInitialStatus.
    READ ENTITIES OF zi_pl_head_tp IN LOCAL MODE
        ENTITY Plist FIELDS ( Status ) WITH CORRESPONDING #( keys )
        RESULT DATA(lt_plist).

    DELETE lt_plist WHERE Status is  not INITIAL.
    check lt_plist is NOT INITIAL.

    MODIFY ENTITIES of zi_pl_head_tp IN LOCAL MODE
        ENTITY Plist UPDATE FIELDS ( Status )
        WITH VALUE #( for ls_plist IN lt_plist
                    ( %tky      = ls_plist-%tky
                      Status    = 'Created' ) )
        REPORTED DATA(update_reported).

    reported = CORRESPONDING #( DEEP update_reported ).
  ENDMETHOD.

  METHOD ValidatePlate.

    READ ENTITIES OF zi_pl_head_tp IN LOCAL MODE
    ENTITY Plist
    FIELDS ( PlateNo )
    WITH CORRESPONDING #( keys )
    RESULT DATA(lt_plist).


    LOOP AT lt_plist INTO data(ls_plist) WHERE PlateNo IS NOT INITIAL.
      SELECT SINGLE @abap_true FROM ztab_pl_head WHERE plate_no = @ls_plist-PlateNo INTO @data(lv_plate_exists).

      IF lv_plate_exists = abap_true.
*       Updated failed data
        APPEND VALUE #( %tky = ls_plist-%tky ) TO failed-plist.
*       Update message for the failed data
        APPEND VALUE #( %tky = keys[ 1 ]-%tky
                        %msg = new_message_with_text(
                        severity = if_abap_behv_message=>severity-error
                        text = 'Plate Number Exists') ) TO reported-plist.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

  METHOD earlynumbering_cba_Plattach.
    READ ENTITY
     IN LOCAL MODE
     ZI_PL_HEAD_TP
     BY \_PLAttach
     ALL FIELDS WITH CORRESPONDING #( entities )
     RESULT DATA(lt_pl_attach).


    DATA(lt_final_keys) = entities.


    LOOP AT lt_final_keys INTO DATA(ls_final_key) .
      "Get Maximum number from item from the PO
      SELECT MAX( AttachNo ) FROM @lt_pl_attach AS itemkeys
       WHERE Plist = @ls_final_key-Plist
       INTO @DATA(lv_attach_id).

      LOOP AT ls_final_key-%target INTO DATA(ls_item).
*        lv_itemno += 10.
        IF ls_final_key-%is_draft = 01.
          lv_attach_id = lv_attach_id + 10.
        ELSE.
          lv_attach_id = ls_item-AttachNo.
        ENDIF.
        ls_item-AttachNo = |{ lv_attach_id ALPHA = IN }|.
*        APPEND VALUE #( %cid = ls_item-%cid
*                         %tky = ls_final_key-%tky
*                         %key = ls_item-%key ) TO mapped-attachment.
        APPEND VALUE #(  %cid = ls_item-%cid %is_draft = ls_final_key-%tky-%is_draft
        plist = ls_item-%key-Plist attachno = ls_item-%key-AttachNo ) to mapped-attachment.
      ENDLOOP.


    ENDLOOP.
  ENDMETHOD.

ENDCLASS.
