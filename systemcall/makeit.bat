gcc -mno-cygwin -fnative-struct -c -DBUILDING_DLL=1 -I. -g -Wall  -o systemcall.o systemcall.c
gcc -mno-cygwin -fnative-struct -c -DBUILDING_DLL=1 -I. -g -Wall  -o dllinit.o dllinit.c
dllwrap -mingw --export-all --output-def systemcall.def --implib libsystemcall.a -o systemcall.dll systemcall.o dllinit.o
REM dllwrap -mingw --export-all --output-def systemcall.def --implib libsystemcall.a -o systemcall.dll systemcall.o dllinit.o
