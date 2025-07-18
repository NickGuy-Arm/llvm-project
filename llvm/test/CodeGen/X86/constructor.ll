; RUN: llc -mtriple x86_64 < %s | FileCheck --check-prefix=INIT-ARRAY %s
; RUN: llc -mtriple x86_64-pc-linux -use-ctors < %s | FileCheck --check-prefix=CTOR %s
; RUN: llc -mtriple x86_64-unknown-freebsd -use-ctors < %s | FileCheck --check-prefix=CTOR %s
; RUN: llc -mtriple x86_64-pc-solaris2.11 -use-ctors < %s | FileCheck --check-prefix=CTOR %s
; RUN: llc -mtriple x86_64-pc-linux < %s | FileCheck --check-prefix=INIT-ARRAY %s
; RUN: llc -mtriple x86_64-unknown-freebsd < %s | FileCheck --check-prefix=INIT-ARRAY %s
; RUN: llc -mtriple x86_64-pc-solaris2.11 < %s | FileCheck --check-prefix=INIT-ARRAY %s
; RUN: llc -mtriple i586-intel-elfiamcu -use-ctors < %s | FileCheck %s --check-prefix=MCU-CTORS
; RUN: llc -mtriple i586-intel-elfiamcu < %s | FileCheck %s --check-prefix=MCU-INIT-ARRAY
; RUN: llc -mtriple x86_64-win32-gnu < %s | FileCheck --check-prefix=COFF-CTOR %s
@llvm.global_ctors = appending global [5 x { i32, ptr, ptr }] [{ i32, ptr, ptr } { i32 65535, ptr @f, ptr null}, { i32, ptr, ptr } { i32 15, ptr @g, ptr @v }, { i32, ptr, ptr } { i32 55555, ptr @h, ptr @v }, { i32, ptr, ptr } { i32 65535, ptr @i, ptr null }, { i32, ptr, ptr } { i32 65535, ptr @j, ptr null }]

@v = weak_odr global i8 0

define void @f() {
entry:
  ret void
}

define void @g() {
entry:
  ret void
}

define void @h() {
entry:
  ret void
}

define void @i() {
entry:
  ret void
}

define void @j() {
entry:
  ret void
}

; CTOR:	        .section	.ctors,"aw",@progbits
; CTOR-NEXT:	.p2align	3
; CTOR-NEXT:	.quad	j
; CTOR-NEXT:	.quad	i
; CTOR-NEXT:	.quad	f
; CTOR-NEXT:	.section	.ctors.09980,"awG",@progbits,v,comdat
; CTOR-NEXT:	.p2align	3
; CTOR-NEXT:	.quad	h
; CTOR-NEXT:	.section	.ctors.65520,"awG",@progbits,v,comdat
; CTOR-NEXT:	.p2align	3
; CTOR-NEXT:	.quad	g

; INIT-ARRAY:		.section	.init_array.15,"awG",@init_array,v,comdat
; INIT-ARRAY-NEXT:	.p2align	3
; INIT-ARRAY-NEXT:	.quad	g
; INIT-ARRAY-NEXT:	.section	.init_array.55555,"awG",@init_array,v,comdat
; INIT-ARRAY-NEXT:	.p2align	3
; INIT-ARRAY-NEXT:	.quad	h
; INIT-ARRAY-NEXT:	.section	.init_array,"aw",@init_array
; INIT-ARRAY-NEXT:	.p2align	3
; INIT-ARRAY-NEXT:	.quad	f
; INIT-ARRAY-NEXT:	.quad	i
; INIT-ARRAY-NEXT:	.quad	j

; MCU-CTORS:         .section        .ctors,"aw",@progbits
; MCU-INIT-ARRAY:    .section        .init_array,"aw",@init_array

; COFF-CTOR:		.section	.ctors.65520,"dw",associative,v,unique,0
; COFF-CTOR-NEXT:	.p2align	3
; COFF-CTOR-NEXT:	.quad	g
; COFF-CTOR-NEXT:	.section	.ctors.09980,"dw",associative,v,unique,0
; COFF-CTOR-NEXT:	.p2align	3
; COFF-CTOR-NEXT:	.quad	h
; COFF-CTOR-NEXT:	.section	.ctors,"dw"
; COFF-CTOR-NEXT:	.p2align	3
; COFF-CTOR-NEXT:	.quad	f
; COFF-CTOR-NEXT:	.quad	i
; COFF-CTOR-NEXT:	.quad	j
