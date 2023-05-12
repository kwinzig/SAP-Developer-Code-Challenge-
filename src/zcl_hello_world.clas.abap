CLASS zcl_hello_world DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    METHODS hello_world
      RETURNING VALUE(r_result) TYPE string.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_hello_world IMPLEMENTATION.
  METHOD hello_world.
    r_result = 'Hello World'.
  ENDMETHOD.

ENDCLASS.
