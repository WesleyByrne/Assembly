.386
.MODEL FLAT

ExitProcess PROTO NEAR32 stdcall, dwExitCode:DWORD

.STACK  4096

INCLUDE debug.h
INCLUDE io.h
INCLUDE sqrt.h

.DATA

.CODE
_start:


PUBLIC _start
END