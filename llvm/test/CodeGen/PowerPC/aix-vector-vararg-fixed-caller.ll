; NOTE: Assertions have been autogenerated by utils/update_mir_test_checks.py
; RUN: llc -verify-machineinstrs -stop-before=ppc-vsx-copy -vec-extabi \
; RUN:     -mcpu=pwr7  -mtriple powerpc-ibm-aix-xcoff < %s | \
; RUN: FileCheck --check-prefix=32BIT %s

; RUN: llc -verify-machineinstrs -stop-before=ppc-vsx-copy -vec-extabi \
; RUN:     -mcpu=pwr7  -mtriple powerpc64-ibm-aix-xcoff < %s | \
; RUN: FileCheck --check-prefix=64BIT %s

define void @caller() {


  ; 32BIT-LABEL: name: caller
  ; 32BIT: bb.0.entry:
  ; 32BIT-NEXT:   ADJCALLSTACKDOWN 88, 0, implicit-def dead $r1, implicit $r1
  ; 32BIT-NEXT:   [[LWZtoc:%[0-9]+]]:gprc = LWZtoc %const.0, $r2 :: (load (s32) from got)
  ; 32BIT-NEXT:   [[LXVW4X:%[0-9]+]]:vsrc = LXVW4X $zero, killed [[LWZtoc]] :: (load (s128) from constant-pool)
  ; 32BIT-NEXT:   [[LI:%[0-9]+]]:gprc = LI 64
  ; 32BIT-NEXT:   STXVW4X killed [[LXVW4X]], $r1, killed [[LI]] :: (store (s128) into stack + 64)
  ; 32BIT-NEXT:   [[LIS:%[0-9]+]]:gprc = LIS 38314
  ; 32BIT-NEXT:   [[ORI:%[0-9]+]]:gprc = ORI killed [[LIS]], 63376
  ; 32BIT-NEXT:   STW killed [[ORI]], 84, $r1 :: (store (s32) into stack + 84, basealign 16)
  ; 32BIT-NEXT:   [[LIS1:%[0-9]+]]:gprc = LIS 16389
  ; 32BIT-NEXT:   [[ORI1:%[0-9]+]]:gprc = ORI killed [[LIS1]], 48905
  ; 32BIT-NEXT:   STW killed [[ORI1]], 80, $r1 :: (store (s32) into stack + 80, align 16)
  ; 32BIT-NEXT:   [[LWZtoc1:%[0-9]+]]:gprc = LWZtoc %const.1, $r2 :: (load (s32) from got)
  ; 32BIT-NEXT:   [[LXVW4X1:%[0-9]+]]:vsrc = LXVW4X $zero, killed [[LWZtoc1]] :: (load (s128) from constant-pool)
  ; 32BIT-NEXT:   [[LWZtoc2:%[0-9]+]]:gprc_and_gprc_nor0 = LWZtoc %const.2, $r2 :: (load (s32) from got)
  ; 32BIT-NEXT:   [[LFD:%[0-9]+]]:f8rc = LFD 0, killed [[LWZtoc2]] :: (load (s64) from constant-pool)
  ; 32BIT-NEXT:   [[LIS2:%[0-9]+]]:gprc = LIS 16393
  ; 32BIT-NEXT:   [[ORI2:%[0-9]+]]:gprc = ORI killed [[LIS2]], 8697
  ; 32BIT-NEXT:   [[LIS3:%[0-9]+]]:gprc = LIS 61467
  ; 32BIT-NEXT:   [[ORI3:%[0-9]+]]:gprc = ORI killed [[LIS3]], 34414
  ; 32BIT-NEXT:   [[LWZtoc3:%[0-9]+]]:gprc_and_gprc_nor0 = LWZtoc %const.3, $r2 :: (load (s32) from got)
  ; 32BIT-NEXT:   [[LFD1:%[0-9]+]]:f8rc = LFD 0, killed [[LWZtoc3]] :: (load (s64) from constant-pool)
  ; 32BIT-NEXT:   [[LI1:%[0-9]+]]:gprc = LI 55
  ; 32BIT-NEXT:   $r3 = COPY [[LI1]]
  ; 32BIT-NEXT:   $v2 = COPY [[LXVW4X1]]
  ; 32BIT-NEXT:   $f1 = COPY [[LFD]]
  ; 32BIT-NEXT:   $r9 = COPY [[ORI2]]
  ; 32BIT-NEXT:   $r10 = COPY [[ORI3]]
  ; 32BIT-NEXT:   $f2 = COPY [[LFD1]]
  ; 32BIT-NEXT:   BL_NOP <mcsymbol .callee[PR]>, csr_aix32_altivec, implicit-def dead $lr, implicit $rm, implicit $r3, implicit $v2, implicit $f1, implicit $r9, implicit $r10, implicit $f2, implicit $r2, implicit-def $r1, implicit-def $v2
  ; 32BIT-NEXT:   ADJCALLSTACKUP 88, 0, implicit-def dead $r1, implicit $r1
  ; 32BIT-NEXT:   [[COPY:%[0-9]+]]:vsrc = COPY $v2
  ; 32BIT-NEXT:   BLR implicit $lr, implicit $rm
  ;
  ; 64BIT-LABEL: name: caller
  ; 64BIT: bb.0.entry:
  ; 64BIT-NEXT:   ADJCALLSTACKDOWN 120, 0, implicit-def dead $r1, implicit $r1
  ; 64BIT-NEXT:   [[LDtocCPT:%[0-9]+]]:g8rc = LDtocCPT %const.0, $x2 :: (load (s64) from got)
  ; 64BIT-NEXT:   [[LXVW4X:%[0-9]+]]:vsrc = LXVW4X $zero8, killed [[LDtocCPT]] :: (load (s128) from constant-pool)
  ; 64BIT-NEXT:   [[LI8_:%[0-9]+]]:g8rc = LI8 96
  ; 64BIT-NEXT:   STXVW4X killed [[LXVW4X]], $x1, killed [[LI8_]] :: (store (s128))
  ; 64BIT-NEXT:   [[LIS8_:%[0-9]+]]:g8rc = LIS8 16389
  ; 64BIT-NEXT:   [[ORI8_:%[0-9]+]]:g8rc = ORI8 killed [[LIS8_]], 48905
  ; 64BIT-NEXT:   [[RLDIC:%[0-9]+]]:g8rc = RLDIC killed [[ORI8_]], 32, 1
  ; 64BIT-NEXT:   [[ORIS8_:%[0-9]+]]:g8rc = ORIS8 killed [[RLDIC]], 38314
  ; 64BIT-NEXT:   [[ORI8_1:%[0-9]+]]:g8rc = ORI8 killed [[ORIS8_]], 63376
  ; 64BIT-NEXT:   STD killed [[ORI8_1]], 112, $x1 :: (store (s64) into stack + 112, align 16)
  ; 64BIT-NEXT:   [[LDtocCPT1:%[0-9]+]]:g8rc = LDtocCPT %const.1, $x2 :: (load (s64) from got)
  ; 64BIT-NEXT:   [[LXVW4X1:%[0-9]+]]:vsrc = LXVW4X $zero8, killed [[LDtocCPT1]] :: (load (s128) from constant-pool)
  ; 64BIT-NEXT:   [[LD:%[0-9]+]]:g8rc = LD 104, $x1 :: (load (s64))
  ; 64BIT-NEXT:   [[LD1:%[0-9]+]]:g8rc = LD 96, $x1 :: (load (s64))
  ; 64BIT-NEXT:   [[LDtocCPT2:%[0-9]+]]:g8rc_and_g8rc_nox0 = LDtocCPT %const.2, $x2 :: (load (s64) from got)
  ; 64BIT-NEXT:   [[LFD:%[0-9]+]]:f8rc = LFD 0, killed [[LDtocCPT2]] :: (load (s64) from constant-pool)
  ; 64BIT-NEXT:   [[LDtocCPT3:%[0-9]+]]:g8rc_and_g8rc_nox0 = LDtocCPT %const.3, $x2 :: (load (s64) from got)
  ; 64BIT-NEXT:   [[LFD1:%[0-9]+]]:f8rc = LFD 0, killed [[LDtocCPT3]] :: (load (s64) from constant-pool)
  ; 64BIT-NEXT:   [[LIS8_1:%[0-9]+]]:g8rc = LIS8 16393
  ; 64BIT-NEXT:   [[ORI8_2:%[0-9]+]]:g8rc = ORI8 killed [[LIS8_1]], 8697
  ; 64BIT-NEXT:   [[RLDIC1:%[0-9]+]]:g8rc = RLDIC killed [[ORI8_2]], 32, 1
  ; 64BIT-NEXT:   [[ORIS8_1:%[0-9]+]]:g8rc = ORIS8 killed [[RLDIC1]], 61467
  ; 64BIT-NEXT:   [[ORI8_3:%[0-9]+]]:g8rc = ORI8 killed [[ORIS8_1]], 34414
  ; 64BIT-NEXT:   [[LI8_1:%[0-9]+]]:g8rc = LI8 55
  ; 64BIT-NEXT:   $x3 = COPY [[LI8_1]]
  ; 64BIT-NEXT:   $v2 = COPY [[LXVW4X1]]
  ; 64BIT-NEXT:   $f1 = COPY [[LFD]]
  ; 64BIT-NEXT:   $x7 = COPY [[ORI8_3]]
  ; 64BIT-NEXT:   $x9 = COPY [[LD1]]
  ; 64BIT-NEXT:   $x10 = COPY [[LD]]
  ; 64BIT-NEXT:   $f2 = COPY [[LFD1]]
  ; 64BIT-NEXT:   BL8_NOP <mcsymbol .callee[PR]>, csr_ppc64_altivec, implicit-def dead $lr8, implicit $rm, implicit $x3, implicit $v2, implicit $f1, implicit $x7, implicit $x9, implicit $x10, implicit $f2, implicit $x2, implicit-def $r1, implicit-def $v2
  ; 64BIT-NEXT:   ADJCALLSTACKUP 120, 0, implicit-def dead $r1, implicit $r1
  ; 64BIT-NEXT:   [[COPY:%[0-9]+]]:vsrc = COPY $v2
  ; 64BIT-NEXT:   BLR8 implicit $lr8, implicit $rm
entry:
  %call = tail call <4 x i32> (i32, <4 x i32>, double, ...) @callee(i32 signext 55, <4 x i32> <i32 170, i32 187, i32 204, i32 221>, double 3.141590e+00, <4 x i32> <i32 10, i32 20, i32 30, i32 40>, double 2.718280e+00)
  ret void
}

declare <4 x i32> @callee(i32 signext, <4 x i32>, double, ...)

