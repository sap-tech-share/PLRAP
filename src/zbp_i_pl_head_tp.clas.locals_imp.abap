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
    data lv_max_plist TYPE ztab_pl_head-plist.
    DATA(lt_entities) = entities.
    SELECT max(  plist ) FROM ztab_pl_head into @lv_max_plist.

    LOOP AT lt_entities INTO data(ls_entity).
        lv_max_plist = lv_max_plist + 1.
        ls_entity-Plist = |{ lv_max_plist ALPHA = IN }|.

        APPEND VALUE #( %cid = ls_entity-%cid %is_draft = ls_entity-%is_draft plist = ls_entity-Plist ) TO mapped-plist.
    ENDLOOP.
  ENDMETHOD.

  METHOD SetStatusComplete.
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
