CLASS zcl_abap_mustache_test DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    METHODS build_html
      RETURNING
        VALUE(rv_text) TYPE string
      RAISING
        zcx_mustache_error.

    INTERFACES if_oo_adt_classrun.

    TYPES:
      BEGIN OF ty_spfli,
        connid   TYPE s_conn_id,
        cityfrom TYPE s_from_cit,
        cityto   TYPE s_to_city,
      END OF ty_spfli.

    TYPES: ty_spfli_tt TYPE STANDARD TABLE OF ty_spfli WITH DEFAULT KEY.

    TYPES: BEGIN OF ty_scarr,
             carrid   TYPE s_carr_id,
             carrname TYPE s_carrname,
             flights  TYPE ty_spfli_tt,
           END OF ty_scarr.

    TYPES ty_scarr_tt TYPE STANDARD TABLE OF ty_scarr WITH DEFAULT KEY.
  PROTECTED SECTION.
  PRIVATE SECTION.
    METHODS get_flight_data RETURNING VALUE(rt_flight_data) TYPE ty_scarr_tt.

ENDCLASS.



CLASS zcl_abap_mustache_test IMPLEMENTATION.
  METHOD if_oo_adt_classrun~main.
    DATA lv_text TYPE string.


    lv_text = build_html( ).

    out->write( lv_text ).
  ENDMETHOD.

  METHOD build_html.

    DATA lo_mustache TYPE REF TO zcl_mustache.
    DATA lv_text     TYPE string.
    DATA(c_nl) = cl_abap_char_utilities=>newline.

    DATA(lt_scarr) = get_flight_data(  ).


    lo_mustache = zcl_mustache=>create('<html style="font-family: Arial">'
     && 'Carrier: <b>{{carrid}}</b> - {{carrname}} '  &&
       '<table border="1">' &&
       '<tr>' &&
       '<th> CONNID </th> ' &&
       '<th> FROM</th> ' &&
       '<th> TO </th> ' &&
       '</tr>' &&
       '{{#flights}}'  &&
       '<tr>' &&
       '<td> {{connid}} </td> ' &&
       '<td> {{cityfrom}}</td> ' &&
       '<td> {{cityto}} </td> ' &&
        '</tr>' &&
       '{{/flights}}' &&
       '</table>' &&
       '<br>' &&
       '</hmtl>'
    ).

    rv_text = lo_mustache->render( lt_scarr ). " ls_my_data type ty_scarr

  ENDMETHOD.

  METHOD get_flight_data.
    SELECT carrid, carrname FROM scarr INTO CORRESPONDING FIELDS OF TABLE @rt_flight_data.
    LOOP AT rt_flight_data ASSIGNING FIELD-SYMBOL(<fs_flight_data>).
      SELECT connid, cityfrom, cityto FROM spfli WHERE carrid = @<fs_flight_data>-carrid INTO CORRESPONDING FIELDS OF TABLE @<fs_flight_data>-flights.
    ENDLOOP.
  ENDMETHOD.

ENDCLASS.
